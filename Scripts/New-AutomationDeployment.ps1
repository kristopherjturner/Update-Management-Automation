###################################
#  This script is will deploy automation components.
#  Current Version:  .01000001 01111010 01110101 01110010 01100101
#  Date Written:  8-29-2019
#  Last Updated:  9-15-2019
#  Created By:    Kristopher J. Turner (The Country Cloud Boy)
#  Uses the Az Module and not the AzureRM module
#####################################

$ResourceGroupName = ""
$ResourceGroupLocation = ""
$WorkspaceName = ""
$WorkspaceLocation = ""
$AutomationAccountName = ""
$AutomationAccountLocation = ""
$TenantID=""
$SubscriptionID=""
$AutoEnroll = $true

# Script settings
Set-StrictMode -Version Latest

function ThrowTerminatingError
{
     Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ErrorId,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $ErrorCategory,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $Exception
    )

    $errorRecord = [System.Management.Automation.ErrorRecord]::New($Exception, $ErrorId, $ErrorCategory, $null)
    throw $errorRecord
}

Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID

#
# Automation account requires 6 chars at minimum
#
if ( $AutomationAccountName.Length -lt 6 )
{
    $message = "Automation account name validation failed: The name can contain only letters, numbers, and hyphens. The name must start with a letter, and it must end with a letter or a number. The account name length must be from 6 to 50 characters"
    ThrowTerminatingError -ErrorId "InvalidAutomationAccountName" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message `
}

#
# Check all dependency files exist along with this script
#
$curInvocation = get-variable myinvocation
$mydir = split-path $curInvocation.Value.MyCommand.path

# $enableVMInsightsPerfCounterScriptFile = "$mydir\Enable-VMInsightsPerfCounters.ps1"
# if (-not (Test-Path -Path $enableVMInsightsPerfCounterScriptFile))
# {
#     $message = "$enableVMInsightsPerfCounterScriptFile does not exist. Please ensure this file exists in the same directory as the this script."
#     ThrowTerminatingError -ErrorId "ScriptNotFound" `
#         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
#         -Exception $message `
# }

$changeTrackingTemplateFile = "$mydir\Templates\ChangeTracking-Filelist.json"
if (-not (Test-Path -Path $changeTrackingTemplateFile ) )
{
    $message = "$changeTrackingTemplateFile does not exist. Please ensure this file exists in the same directory as the this script."
    ThrowTerminatingError -ErrorId "TemplateNotFound" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message `
}

$scopeConfigTemplateFile = "$mydir\Templates\ScopeConfig.json"
if (-not (Test-Path -Path $scopeConfigTemplateFile ) )
{
    $message = "$scopeConfigTemplateFile does not exist. Please ensure this file exists in the same directory as the this script."
    ThrowTerminatingError -ErrorId "TemplateNotFound" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message `
}

$workspaceAutomationTemplateFile = "$mydir\Templates\Workspace-AutomationAccount.json"
if (-not (Test-Path -Path $workspaceAutomationTemplateFile ) )
{
    $message = "$workspaceAutomationTemplateFile does not exist. Please ensure this file exists in the same directory as the this script."
    ThrowTerminatingError -ErrorId "TemplateNotFound" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message `
}

$workspaceSolutionsTemplateFile = "$mydir\Templates\WorkspaceSolutions.json"
if (-not (Test-Path -Path $workspaceSolutionsTemplateFile ) )
{
    $message = "$workspaceSolutionsTemplateFile does not exist. Please ensure this file exists in the same directory as the this script."
    ThrowTerminatingError -ErrorId "TemplateNotFound" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message `
}

#
# Choose the right subscription
#
try
{
    $Subscription = Get-AzSubscription -SubscriptionID $SubscriptionID  -ErrorAction Stop
}
catch 
{
    ThrowTerminatingError -ErrorId "FailedToGetSubscriptionInformation" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidResult) `
        -Exception $_.Exception `
}

#
# Check if user is owner of the subscription
#
$azContext = Get-AzContext
$currentUser = $azContext.Account.Id
$userRole = Get-AzRoleAssignment -SignInName $currentUser -RoleDefinitionName Owner -Scope "/subscriptions/$($Subscription.Id)"
if (-not $userRole)
{
    $message = "Insufficient permissions for Policy assignment."
    ThrowTerminatingError -ErrorId "UserUnAuthorizedForPolicyAssignment" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message
}

#
# Create the Resource group if not exist
#
$newResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -ErrorAction SilentlyContinue
If (-not $NewResourceGroup)
{
    Write-Output "Creating resource group: $($ResourceGroupName)"
    $newResourceGroup = New-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation
}
else
{
    #
    # We are intentionally not trying to re-use an existing resource group. 
    # For e.g. if it exists, but not in the location that was requested, could set us in an inconsistent state.
    #
    $message = "ResourceGroup: $($ResourceGroupName) already exists. Please use a new resource group."
    ThrowTerminatingError -ErrorId "ResourceGroupAlreadyExists" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message
}

#
# Deploy Workspace and solutions
#
try 
{
    Write-Output "Phase 1 Deployment start: Create resources"

    #
    # Check for workspace and automation account name to be unique in the subscription across resoure groups
    # Duplicate names can cause "bad request" error.
    #

    #
    # Check if the automation account already exists
    #
    $existingAutomationAccount = Get-AzResource -Name $AutomationAccountName -ResourceType "Microsoft.Automation/automationAccounts" -ErrorAction SilentlyContinue
    if ($existingAutomationAccount)
    {
        $message = "Automation account: $AutomationAccountName already exists in this subscription. Please use a unique name."
        ThrowTerminatingError -ErrorId "AutomationAccountAlreadyExists" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
    }

    #
    # Check if the workspace already exists
    #
    $workspace = Get-AzResource -Name $WorkspaceName -ResourceType "Microsoft.OperationalInsights/workspaces" -ErrorAction SilentlyContinue
    if ($workspace)
    {
        $message = "Workspace: $WorkspaceName already exists. Please use a unique name."
        ThrowTerminatingError -ErrorId "WorkspaceAlreadyExists" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
    }

    #
    # Start deployment, provisioning Automation Account and Workspace
    #
    try
    {
        New-AzResourceGroupDeployment -Name "WorkSpaceAndAutomationAccountProvisioning" -ResourceGroupName $ResourceGroupName -TemplateFile $workspaceAutomationTemplateFile -workspaceName $WorkspaceName -workspaceLocation $WorkspaceLocation -automationName $AutomationAccountName -automationLocation $AutomationAccountLocation -ErrorAction Stop
    }
    catch
    {
        $message = "Automation Account and Workspace, provisioning failed. Details below... `n $_"
        ThrowTerminatingError -ErrorId "AutomationAccountAndWorkspaceProvisioningFailed" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
    }

    #
    # If we are here Automoation account and Workspace have been provisioned.
    #

    #
    # Enable solutions on the workspace
    #
    Write-Output "Phase 1 Deployment start: Enable solutions on the workspace"		
    try
    {
        New-AzResourceGroupDeployment -Name "EnableSolutions" -ResourceGroupName $ResourceGroupName -TemplateFile $workspaceSolutionsTemplateFile -workspaceName $WorkspaceName -WorkspaceLocation $WorkspaceLocation -Mode Incremental -ErrorAction Stop
    }
    catch
    {
        $message = "Solution provisioning on workspace failed. Detailed below... `n $_"
        ThrowTerminatingError -ErrorId "SolutionProvisioningFailed" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
    }
    
    If ($AutoEnroll -eq $false)
    {
        #
        # Check if default change tracking saved search group already exists
        # If not, add the default change tracking saved search and scope config
        #
        $savedSearch = Get-AzOperationalInsightsSavedSearch -ResourceGroupName $ResourceGroupName -WorkspaceName $WorkspaceName

        $createSavedSearch = $true
        foreach ($s in $savedSearch.Value)
        {
            if ($s.Id.Contains("changetracking|microsoftdefaultcomputergroup")) 
            {
                Write-output "Default saved search group already exists: $($s.Id)"
                $createSavedSearch = $false
                break
            }
        }

        if ($createSavedSearch)
        {
            Write-Output "Phase 1 Deployment start: Add scope config to the workspace"		

            try
            {
                New-AzResourceGroupDeployment -Name "AddScopeConfig" -ResourceGroupName $ResourceGroupName -TemplateFile $scopeConfigTemplateFile -workspaceName $WorkspaceName -WorkspaceLocation $Workspacelocation -Mode Incremental -ErrorAction Stop
            }
            catch
            {
                $message = "ScopeConfig provisioning on ResouceGroup failed. Detailed below... `n $_"
                ThrowTerminatingError -ErrorId "ScopeConfigProvisioningFailed" `
                -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                -Exception $message 
            }
        }
    }

    #
    # Check if the workspace already exists
    #
    $workspace = Get-AzResource -Name $WorkspaceName -ResourceType "Microsoft.OperationalInsights/workspaces" -ErrorAction SilentlyContinue
    if (-not $workspace)
    {
        $message = "Workspace: $($WorkspaceName) does not exists. Please check."
        ThrowTerminatingError -ErrorId "WorkspaceNotFound" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
    }

    #
    # Phase 2 deployment
    #
    Write-Output "Phase 2 Deployment start: Configure Change tracking"		

    try
    {
        New-AzResourceGroupDeployment -Name "ConfigureChangeTracking" -ResourceGroupName $ResourceGroupName -TemplateFile $changeTrackingTemplateFile -workspaceName $WorkspaceName -WorkspaceLocation $Workspacelocation -Mode Incremental -ErrorAction Stop
    }
    catch
    {
        $message = "ChangeTracking provisioning on ResouceGroup failed. Detailed below... `n $_"
        ThrowTerminatingError -ErrorId "ChangeTrackingProvisioningFailed" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
    }
}
catch 
{
    $message = "Deployment failed.`n $_"
        ThrowTerminatingError -ErrorId "DeploymentFailed" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
}
