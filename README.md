# Vmware-Inventory-Exporter

vSphere VM Inventory Report Script
A PowerShell script that connects to a VMware vCenter/ESXi host and exports a detailed inventory of all virtual machines to a CSV file.

📋 Overview
This script uses VMware PowerCLI to query a vCenter Server or ESXi host and generate a CSV report containing key VM details such as name, guest OS, CPU, memory, disk capacity, datastores, power state, and host.

✅ Prerequisites
PowerShell 5.1+ (or PowerShell 7+)
VMware PowerCLI module installed
Network access to your vCenter Server or ESXi host
Valid credentials with read permissions on the vCenter/ESXi environment

🛠️ Installation
1. Install VMware PowerCLI
Open an elevated PowerShell prompt and run:
Install-Module -Name VMware.PowerCLI -Scope CurrentUser
If prompted about an untrusted repository, type Y to confirm.

2. (Optional) Set PowerCLI Configuration
To suppress certificate warnings (common in lab environments):
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
3. Update the Hosts File (optional but recommended)
Add the vCenter hostname to your hosts file so it resolves correctly.
Windows: C:\Windows\System32\drivers\etc\hosts
192.168.1.100    localhost.localdomain
Replace the IP with your vCenter/ESXi address.

🚀 Usage
Step 1 - Launch PowerShell with Execution Policy Bypass
powershell -ExecutionPolicy Bypass -NoExit
Step 2 - Import the PowerCLI Core Module
Import-Module VMware.VimAutomation.Core
Step 3 - Connect to vCenter/ESXi
Connect-VIServer -Server localhost.localdomain
You will be prompted for credentials. Use an account with at least read-only privileges.

Step 4 - Run the Report Script
Copy the entire script block (from $vcName = ... to the final Write-Output) and paste it into your PowerShell session, then press Enter.

📄 Output
The script generates a CSV file saved to your Downloads folder with a dynamic filename based on the connected vCenter/ESXi server:
%USERPROFILE%\Downloads\vSphere_VM_Report_<vCenterName>.csv
