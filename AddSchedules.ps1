# Variables - Required
$AutomationAccount=""
$ResourceGroupName=""
$TenantID=""
$SubscriptionID=""

Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID

# Build the array
$ScheduleConfig = @(
[pscustomobject]@{ScheduleName='1st Saturday UTC0 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC0 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC0 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC0 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC0 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC0 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC0-NR';StartTime='00:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Saturday UTC8 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC8 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC8 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC8 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC8 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC8 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC8-NR';StartTime='08:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='1st Saturday UTC16 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='1st Saturday UTC16 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT1UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='First'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC16 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='2nd Saturday UTC16 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT2UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='Second'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC16 - Windows Update - No Reboot';Reboot='Never';OS='Windows';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='Third'}
[pscustomobject]@{ScheduleName='3rd Saturday UTC16 - Linux Update - No Reboot';Reboot='Never';OS='Linux';DayofWeek='Saturday';TagName='UpdateWindow';TagValue='SAT3UTC16-NR';StartTime='16:00';DaysofWeekOccurrence='Third'}
)

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

New-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $ResourceGroupName `
                                                 -AutomationAccountName $AutomationAccount `
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