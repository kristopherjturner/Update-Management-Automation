###################################
#  This script is will configure AZ Windows VM's Advance Setttings for Update Management.
#  Current Version:  .01000001 01111010 01110101 01110010 01100101
#  Date Written:   8-29-2019
#  Created By:    Kristopher J. Turner (The Country Cloud Boy)
#  Uses the Az Module and not the AzureRM module
#####################################

# Variables - Required
$TenantID=""
$SubscriptionID=""

Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID

#  Discovery of all Azure VM's in the current subscription.
$azurevms = Get-AzVM | where-object { $_.StorageProfile.OSDisk.OSType -eq "Windows" } | Sort-Object Name | ForEach-Object {$_.Name} | Out-String -Stream | Select-Object
Write-Host "Discovering Azure VM's.  Please hold...."

foreach ($azurevm in $azurevms) {
    
#  This will configure VM's to pre-download updates.
$WUSettings = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
$WUSettings.NotificationLevel = 3
$WUSettings.Save()

#  This will disable the automation installation of updates on VM's.
$AutoUpdatePath = "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
Set-ItemProperty -Path $AutoUpdatePath -Name NoAutoUpdate -Value 1

#  This will enable updates for other Microsoft products.
$ServiceManager = (New-Object -com "Microsoft.Update.ServiceManager")
$ServiceManager.Services
$ServiceID = "7971f918-a847-4430-9279-4a52d1efe18d"
$ServiceManager.AddService2($ServiceId,7,"")

}

Write-Host "All settigns have been deployed. (and hopfully it worked).  Please exit the ride to your left.  Have a nice day!"