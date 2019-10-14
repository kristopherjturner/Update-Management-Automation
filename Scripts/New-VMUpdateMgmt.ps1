# <#
#     .SYNOPSIS
#         This script rolls orchestrate the deployment of the solutions and the agents.
#     .Parameter SubscriptionID
#     .Parameter WorkspaceName
#     .Parameter TenantID
    
#     .Example
#     .\Enable-VMUpdateMgmt.ps1 -SubscriptionID 'Subscription ID' -WorkspaceName 'WorkspaceName' -TenantID 'Tenant ID'

#     .Notes
     
# #>

# param (
#     [Parameter(Mandatory=$true, HelpMessage="Subscription ID" ) ]
#     [string]$SubscriptionID,

#     [Parameter(Mandatory=$true, HelpMessage="Tenant ID" )]
#     [string]$TenantID,

#     [Parameter(Mandatory=$true, HelpMessage="Workspace Name" )]
#     [string]$WorkspaceName

# )

# # Script settings
# Set-StrictMode -Version Latest

$WorkspaceName = "ccb-eastus-mgmt-ws"
$TenantID="bed2fa4a-37d3-4ce9-b9fd-89bdc448e84c"
$SubscriptionID="b97908c7-a0fc-4a2a-bd8c-0721c4d7978e"

#Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID

$workspace = (Get-AzOperationalInsightsWorkspace).Where({$_.Name -eq $workspaceName})

if ($workspace.Name -ne $workspaceName)
{
    Write-Error "Unable to find OMS Workspace $workspaceName. "
}

$workspaceId = $workspace.CustomerId
$workspaceKey = (Get-AzOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $workspace.ResourceGroupName -Name $workspace.Name).PrimarySharedKey

$azurevms = Get-AzVM | Select-Object -ExpandProperty Name
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

