###################################
#  This script will add a new tag and value all Azure VM's running within Subscription.  It will configure VM's
#  for updates to be installed only during maintenance windows, and allow pre-download of updates.  It will also
#  create the deployment schedules.
#  Current Version:  .01000001 01111010 01110101 01110010 01100101
#  Date Written:  8-29-2019
#  Date Updated:  9-18-2019
#  Created By:    Kristopher J. Turner (The Country Cloud Boy)
#  Uses the Az Module and not the AzureRM module
#####################################

#  Variables - Required
#  Please fill in the following 6 variables.
<#$AutomationAccount=""
$ResourceGroupName=""
$TenantID=""
$SubscriptionID=""
$aztag = ""
$tagvalue = "" #>

#  Sandbox
# Variables - Required
$AutomationAccount="cloudlabaa"
$ResourceGroupName="cloudlabworkspaceRG"
$TenantID="f838dbf6-e9d4-4d84-a2e3-a4bba4064586"
$SubscriptionID="2c58324e-3624-4ef5-bd68-7a8043129590"
$aztag = "UpdateWindow"
$tagvalue = "Default"

Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID

#  Part I - Create Tag and Tag Values
#  Discovery of all Azure VM's in the current subscription.
$azurevms = Get-AzVM | Select-Object -ExpandProperty Name
Write-Host "Discovering Azure VM's in the following subscription $SubscriptionID  Please hold...."

Write-Host "The following VM's have been discovered in subscription $SubscriptionID"
$azurevms

foreach ($azurevm in $azurevms) {
    
    Write-Host Checking for tag "$aztag" on "$azurevm"
    $TAGResourceGroupName = get-azvm -name $azurevm | Select-Object -ExpandProperty ResourceGroupName
    
    $tags = (Get-AzResource -ResourceGroupName $TAGResourceGroupName `
                        -Name $azurevm).Tags

If ($tags.UpdateWindow){
Write-Host "$azurevm already has the tag $aztag."
}
else
{
Write-Host "Creating Tag $aztag and Value $tagvalue for $azurevm"
$tags.Add($aztag,$tagvalue)
  
    Set-AzResource -ResourceGroupName $TAGResourceGroupName `
               -ResourceName $azurevm `
               -ResourceType Microsoft.Compute/virtualMachines `
               -Tag $tags `
               -Force `
   }
   
}
Write-Host "All tagging is done (and hopfully it worked).  Please exit the ride to your left.  Have a nice day!"

#  Part II -  VM's Configuration
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
Write-Host "All settigns have been deployed. (and hopfully it worked).  Please tip your waitress.  Have a nice day!"

#  Part III - Create Deployment Schedules
#  Build the array
#  This will use the array.csv file.

Write-Host "Building array, this may take some time......"

$ScheduleConfig = Get-Content -Path .\array.csv | ConvertFrom-Csv

Write-Host "Array is built. We on moving forward with the deployment.  Please standby."

#  Schedule Deployments Start Here

$scope = "/subscriptions/$((Get-AzContext).subscription.id)"
$QueryScope = @($scope)

$WindowsSchedules = $ScheduleConfig | Where-Object {$_.OS -eq "Windows"}
$LinuxSchedules = $ScheduleConfig | Where-Object {$_.OS -eq "Linux"}

foreach($WindowsSchedule in $WindowsSchedules){

$tag = @{$WindowsSchedule.TagName=$WindowsSchedule.TagValue}
$azq = New-AzAutomationUpdateManagementAzureQuery -ResourceGroupName $ResourceGroupName `
                                       -AutomationAccountName $AutomationAccount `
                                       -Scope $QueryScope `
                                       -Tag $tag

$AzureQueries = @($azq)

$date=((get-date).AddDays(1)).ToString("yyyy-MM-dd")
$time=$WindowsSchedule.Starttime
$datetime= $date + "t" + $time

$startTime = [DateTimeOffset]"$datetime"
$duration = New-TimeSpan -Hours 2

$schedule = New-AzAutomationSchedule -ResourceGroupName $ResourceGroupName `
                                                  -AutomationAccountName $AutomationAccount `
                                                  -Name $WindowsSchedule.ScheduleName `
                                                  -StartTime $StartTime `
                                                  -DayofWeek $WindowsSchedule.DayofWeek `
                                                  -DayofWeekOccurrence $WindowsSchedule.DaysofWeekOccurrence `
                                                  -MonthInterval 1 `
                                                  -ForUpdateConfiguration
}

foreach ($LinuxSchedule in $LinuxSchedules){

$tag = @{$LinuxSchedule.TagName=$LinuxSchedule.TagValue}
$azq = New-AzAutomationUpdateManagementAzureQuery -ResourceGroupName $ResourceGroupName `
                                       -AutomationAccountName $AutomationAccount `
                                       -Scope $QueryScope `
                                       -Tag $tag

$AzureQueries = @($azq)

$date=((get-date).AddDays(1)).ToString("yyyy-MM-dd")
$time=$LinuxSchedule.Starttime
$datetime= $date + "t" + $time

$startTime = [DateTimeOffset]"$datetime"
$duration = New-TimeSpan -Hours 2
$schedule = New-AzAutomationSchedule -ResourceGroupName $ResourceGroupName `
                                                  -AutomationAccountName $AutomationAccount `
                                                  -Name $LinuxSchedule.ScheduleName `
                                                  -StartTime $StartTime `
                                                  -DayofWeek $LinuxSchedule.DayofWeek `
                                                  -DayofWeekOccurrence $LinuxSchedule.DaysofWeekOccurrence `
                                                  -MonthInterval 1 `
                                                  -ForUpdateConfiguration

New-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $ResourceGroupName `
                                                 -AutomationAccountName $AutomationAccount `
                                                 -Schedule $schedule `
                                                 -Linux `
                                                 -Azurequery $AzureQueries `
                                                 -IncludedPackageClassification Critical,Security `
                                                 -Duration $duration `
                                                 -RebootSetting $LinuxSchedule.Reboot
}
Write-host "That is all folks!"