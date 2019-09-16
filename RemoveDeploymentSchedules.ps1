#  In case you goof and need to remove all the deployment schedules.

# Variables - Required
$AutomationAccount=""
$ResourceGroupName=""
$TenantID=""
$SubscriptionID=""

Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID

#  Build the array
#  This will use the array.csv file.

$ScheduleConfig = Get-Content -Path .\array.csv | ConvertFrom-Csv

$ScheduleNames=$ScheduleConfig.ScheduleName

foreach($ScheduleName in $ScheduleNames){

    Remove-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount -Name $ScheduleName

}
