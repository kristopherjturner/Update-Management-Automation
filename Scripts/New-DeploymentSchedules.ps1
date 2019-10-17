###################################
#  This script is will create deployment schedules for Update Management.
#  Current Version:  .01000001 01111010 01110101 01110010 01100101
#  Date Written:  8-29-2019
#  Last Updated:  9-15-2019
#  Created By:    Kristopher J. Turner (The Country Cloud Boy)
#  Uses the Az Module and not the AzureRM module
#####################################

# Variables - Required
$AutomationAccountName="ccb-mgmt-aa"
$ResourceGroupName="demo05"
$TenantID="bed2fa4a-37d3-4ce9-b9fd-89bdc448e84c"
$SubscriptionID="b97908c7-a0fc-4a2a-bd8c-0721c4d7978e"


Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID

#  Build the array
#  This will use the array.csv file.

$ScheduleConfig = Get-Content -Path .\array.csv | ConvertFrom-Csv

#  Schedule Deployments Start Here

$scope = "/subscriptions/$((Get-AzContext).subscription.id)"
$QueryScope = @($scope)

$WindowsSchedules = $ScheduleConfig | Where-Object {$_.OS -eq "Windows"}
$LinuxSchedules = $ScheduleConfig | Where-Object {$_.OS -eq "Linux"}

foreach($WindowsSchedule in $WindowsSchedules){

$tag = @{$WindowsSchedule.TagName=$WindowsSchedule.TagValue}
$azq = New-AzAutomationUpdateManagementAzureQuery -ResourceGroupName $ResourceGroupName `
                                       -AutomationAccountName $AutomationAccountName `
                                       -Scope $QueryScope `
                                       -Tag $tag

$AzureQueries = @($azq)

$date=((get-date).AddDays(1)).ToString("yyyy-MM-dd")
$time=$WindowsSchedule.Starttime
$datetime= $date + "t" + $time

$startTime = [DateTimeOffset]"$datetime"
$duration = New-TimeSpan -Hours 2

$schedule = New-AzAutomationSchedule -ResourceGroupName $ResourceGroupName `
                                                  -AutomationAccountName $AutomationAccountName `
                                                  -Name $WindowsSchedule.ScheduleName `
                                                  -StartTime $StartTime `
                                                  -DayofWeek $WindowsSchedule.DayofWeek `
                                                  -DayofWeekOccurrence $WindowsSchedule.DaysofWeekOccurrence `
                                                  -MonthInterval 1 `
                                                  -ForUpdateConfiguration

New-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $ResourceGroupName `
                                                 -AutomationAccountName $AutomationAccountName `
                                                 -Schedule $schedule `
                                                 -Windows `
                                                 -Azurequery $AzureQueries `
                                                 -IncludedUpdateClassification Critical,Security,Updates,UpdateRollup,Definition `
                                                 -Duration $duration `
                                                 -RebootSetting $WindowsSchedule.Reboot
}

foreach ($LinuxSchedule in $LinuxSchedules){

$tag = @{$LinuxSchedule.TagName=$LinuxSchedule.TagValue}
$azq = New-AzAutomationUpdateManagementAzureQuery -ResourceGroupName $ResourceGroupName `
                                       -AutomationAccountName $AutomationAccountName `
                                       -Scope $QueryScope `
                                       -Tag $tag

$AzureQueries = @($azq)

$date=((get-date).AddDays(1)).ToString("yyyy-MM-dd")
$time=$LinuxSchedule.Starttime
$datetime= $date + "t" + $time

$startTime = [DateTimeOffset]"$datetime"
$duration = New-TimeSpan -Hours 2
$schedule = New-AzAutomationSchedule -ResourceGroupName $ResourceGroupName `
                                                  -AutomationAccountName $AutomationAccountName `
                                                  -Name $LinuxSchedule.ScheduleName `
                                                  -StartTime $StartTime `
                                                  -DayofWeek $LinuxSchedule.DayofWeek `
                                                  -DayofWeekOccurrence $LinuxSchedule.DaysofWeekOccurrence `
                                                  -MonthInterval 1 `
                                                  -ForUpdateConfiguration

New-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $ResourceGroupName `
                                                 -AutomationAccountName $AutomationAccountName `
                                                 -Schedule $schedule `
                                                 -Linux `
                                                 -Azurequery $AzureQueries `
                                                 -IncludedPackageClassification Critical,Security `
                                                 -Duration $duration `
                                                 -RebootSetting $LinuxSchedule.Reboot
}

Write-host "That is all folks!"