###################################
#  This script is enable the Udpate Management Agent on all VMs.
#  Current Version:  .01000001 01111010 01110101 01110010 01100101
#  Date Written:   8-29-2019
#  Created By:    Kristopher J. Turner (The Country Cloud Boy)
#  Uses the Az Module and not the AzureRM module
#####################################

$SubscriptionId = ""
$TenantID = ""
$WorkspaceName = ""

# Script settings
Set-StrictMode -Version Latest

Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID


$workspace = (Get-AzOperationalInsightsWorkspace).Where({$_.Name -eq $workspaceName})

if ($workspace.Name -ne $workspaceName)
{
    Write-Error "Unable to find OMS Workspace $workspaceName. "
}

$workspaceId = $workspace.CustomerId
$workspaceKey = (Get-AzOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $workspace.ResourceGroupName -Name $workspace.Name).PrimarySharedKey

$WindowsVMs = Get-AzVM | where-object { $_.StorageProfile.OSDisk.OSType -eq "Windows" } | Sort-Object Name | ForEach-Object {$_.Name} | Out-String -Stream | Select-Object
$LinuxVMs = Get-AzVM | where-object { $_.StorageProfile.OSDisk.OSType -eq "Linux" } | Sort-Object Name | ForEach-Object {$_.Name} | Out-String -Stream | Select-Object


foreach($WindowsVM in $WindowsVMs){

$VMResourceGroup = get-azvm -name $WindowsVM | Select-Object -ExpandProperty ResourceGroupName
$VMLocation = Get-AzVM -Name $WindowsVM | Select-Object -ExpandProperty Location

Set-AzVMExtension -ResourceGroupName $VMresourcegroup -VMName $WindowsVM -Name 'MicrosoftMonitoringAgent' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'MicrosoftMonitoringAgent' -TypeHandlerVersion '1.0' -Location $VMLocation -SettingString "{'workspaceId':  '$workspaceId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey' }"

}

foreach($LinuxVM in $LinuxVMs){

$VMResourceGroup = get-azvm -name $LinuxVM | Select-Object -ExpandProperty ResourceGroupName
$VMLocation = Get-AzVM -Name $LinuxVM | Select-Object -ExpandProperty Location

Set-AzVMExtension -ResourceGroupName $VMresourcegroup -VMName $LinuxVM -Name 'OmsAgentForLinux' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'OmsAgentForLinux' -TypeHandlerVersion '1.0' -Location $VMlocation -SettingString "{'workspaceId':  '$workspaceId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey' }"

}

Write-Host "All Azure VMs have been enabled for Update Management.  Please don't forget to tip your serves.  Have a nice day!"