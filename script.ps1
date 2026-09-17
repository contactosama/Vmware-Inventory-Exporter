#1. Install-Module -Name VMware.PowerCLI
#2. powershell -ExecutionPolicy Bypass -NoExit
#3. Import-Module VMware.VimAutomation.Core
#4. Connect-VIServer -Server localhost.localdomain (after setting hostfile name with vsphere IP)
#5. # Get vCenter or host name you're connected to

$vcName = $global:DefaultVIServer.Name

# Clean up the name for safe filename use (remove colons/slashes if any)
$vcNameClean = $vcName -replace '[^a-zA-Z0-9\-]', '_'

# Build full path with dynamic file name
$exportPath = "$([Environment]::GetFolderPath('UserProfile'))\Downloads\vSphere_VM_Report_$vcNameClean.csv"

# Export VM data
Get-VM | Select-Object Name,
    @{Name="OSName"; Expression = { $_.ExtensionData.Config.GuestFullName }},
    @{Name="CPU"; Expression = { $_.NumCpu }},
    @{Name="MemoryGB"; Expression = { $_.MemoryGB }},
    @{Name="DiskGB"; Expression = { 
        ($_.ExtensionData.Config.Hardware.Device | 
         Where-Object { $_ -is [VMware.Vim.VirtualDisk] } | 
         Measure-Object -Property CapacityInKB -Sum).Sum / 1MB
    }},
    @{Name="DatastoreNames"; Expression = {
        $disks = $_.ExtensionData.Config.Hardware.Device | Where-Object { $_ -is [VMware.Vim.VirtualDisk] }
        $datastores = @()
        foreach ($disk in $disks) {
            if ($disk.Backing -and $disk.Backing.Datastore) {
                $datastoreRef = $disk.Backing.Datastore
                $ds = Get-Datastore | Where-Object { $_.ExtensionData.MoRef -eq $datastoreRef }
                if ($ds) {
                    $datastores += $ds.Name
                }
            }
        }
        ($datastores | Sort-Object -Unique) -join ", "
    }},
    @{Name="PowerState"; Expression = { $_.PowerState }},
    @{Name="VMHost"; Expression = { $_.VMHost.Name }} |
Export-Csv -Path $exportPath -NoTypeInformation

# Optional: Show where the file was saved
Write-Output "VM report saved to: $exportPath"
