###################################
#  This script will fix your goofs.
#  Current Version:  .01000001 01111010 01110101 01110010 01100101
#  Date Written:  8-29-2019
#  Last Updated:  9-15-2019
#  Created By:    Kristopher J. Turner (The Country Cloud Boy)
#  Uses the Az Module and not the AzureRM module
#####################################

#  In case you goof and need to remove all the deployment schedules.

# Variables - Required
$AutomationAccountName=""
$ResourceGroupName=""
$TenantID=""
$SubscriptionID=""

# Script settings
Set-StrictMode -Version Latest

Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID

#  Build the array
#  This will use the array.csv file.

$ScheduleConfig = Get-Content -Path .\array.csv | ConvertFrom-Csv

$ScheduleNames=$ScheduleConfig.ScheduleName

foreach($ScheduleName in $ScheduleNames){

    Remove-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Name $ScheduleName

}

Write-Host "All the goofs have been deleted.  Have a nice day!"
