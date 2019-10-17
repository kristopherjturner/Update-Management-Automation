<#

.SYNOPSYS

    This script will add a new tag and value all Azure VM's running within Subscription.  It will configure VM's
    for updates to be installed only during maintenance windows, and allow pre-download of updates.  It will also
    create the deployment schedules.
    This includes:
    * Tags
    * etc....

.VERSION
    1.0  First version of deployment script.

.AUTHOR
    Kristopher J Turner
    Blog: http://www.kristopherjturner.com
    Twitter: @kristopherj

.CREDITS


.GUIDANCE

    Please refer to the Readme.md (https://github.com/countrycloudboy/Update-Management-Automation/blob/master/README.md) for recommended
    deployment instructions.

#>

#####################################################################################
#   Future Releases:
#       I plan to add the following:
#           *  Add automation of Azure Policy to catch all new VM's for tagging
#           *  Add automation of Azure Policy to catch all new VM's for workspace assignment
#           *  Add automation of Azure Monitor for Deployment Schedule Alets
#           *  Change from Variables to Parameters
#
######################################################################################

#######################################
#  Make sure all variables below are filled in correctly.
#######################################

$ResourceGroupName = ""
$ResourceGroupLocation = ""
$WorkspaceName = ""
$WorkspaceLocation = ""
$AutomationAccountName = ""
$AutomationAccountLocation = ""
$TenantID = ""
$SubscriptionID = ""
$VMTagName = "UpdateWindow"
$TagValue = "Default" 
$AutoEnroll = $true

# Script settings
Set-StrictMode -Version Latest

function ThrowTerminatingError {
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ErrorId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $ErrorCategory,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Exception
    )

    $errorRecord = [System.Management.Automation.ErrorRecord]::New($Exception, $ErrorId, $ErrorCategory, $null)
    throw $errorRecord
}

####################################
#  Connect to Azure Subscription
####################################


Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID

##################################################################################################################
#  Step 1 - Deployment of the Automation Account and Log Analytics Workspace
####

Write-Host "Step 1 -  Deployment of the Automation Account and Log Analytics Workspace"

#
# Automation account requires 6 chars at minimum
#
if ( $AutomationAccountName.Length -lt 6 ) {
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
if (-not (Test-Path -Path $changeTrackingTemplateFile ) ) {
    $message = "$changeTrackingTemplateFile does not exist. Please ensure this file exists in the same directory as the this script."
    ThrowTerminatingError -ErrorId "TemplateNotFound" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message `

}

$scopeConfigTemplateFile = "$mydir\Templates\ScopeConfig.json"
if (-not (Test-Path -Path $scopeConfigTemplateFile ) ) {
    $message = "$scopeConfigTemplateFile does not exist. Please ensure this file exists in the same directory as the this script."
    ThrowTerminatingError -ErrorId "TemplateNotFound" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message `

}

$workspaceAutomationTemplateFile = "$mydir\Templates\Workspace-AutomationAccount.json"
if (-not (Test-Path -Path $workspaceAutomationTemplateFile ) ) {
    $message = "$workspaceAutomationTemplateFile does not exist. Please ensure this file exists in the same directory as the this script."
    ThrowTerminatingError -ErrorId "TemplateNotFound" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message `

}

$workspaceSolutionsTemplateFile = "$mydir\Templates\WorkspaceSolutions.json"
if (-not (Test-Path -Path $workspaceSolutionsTemplateFile ) ) {
    $message = "$workspaceSolutionsTemplateFile does not exist. Please ensure this file exists in the same directory as the this script."
    ThrowTerminatingError -ErrorId "TemplateNotFound" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message `

}

#
# Choose the right subscription
#
try {
    $Subscription = Get-AzSubscription -SubscriptionID $SubscriptionID  -ErrorAction Stop
}
catch {
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
if (-not $userRole) {
    $message = "Insufficient permissions for Policy assignment."
    ThrowTerminatingError -ErrorId "UserUnAuthorizedForPolicyAssignment" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message
}

#
# Create the Resource group if not exist
#
$newResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -ErrorAction SilentlyContinue
If (-not $NewResourceGroup) {
    Write-Output "Creating resource group: $($ResourceGroupName)"
    $newResourceGroup = New-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation
}
else {
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
try {
    Write-Output "Phase 1 Deployment start: Create resources"

    #
    # Check for workspace and automation account name to be unique in the subscription across resoure groups
    # Duplicate names can cause "bad request" error.
    #

    #
    # Check if the automation account already exists
    #
    $existingAutomationAccount = Get-AzResource -Name $AutomationAccountName -ResourceType "Microsoft.Automation/automationAccounts" -ErrorAction SilentlyContinue
    if ($existingAutomationAccount) {
        $message = "Automation account: $AutomationAccountName already exists in this subscription. Please use a unique name."
        ThrowTerminatingError -ErrorId "AutomationAccountAlreadyExists" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
    }

    #
    # Check if the workspace already exists
    #
    $workspace = Get-AzResource -Name $WorkspaceName -ResourceType "Microsoft.OperationalInsights/workspaces" -ErrorAction SilentlyContinue
    if ($workspace) {
        $message = "Workspace: $WorkspaceName already exists. Please use a unique name."
        ThrowTerminatingError -ErrorId "WorkspaceAlreadyExists" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
    }

    #
    # Start deployment, provisioning Automation Account and Workspace
    #
    try {
        New-AzResourceGroupDeployment -Name "WorkSpaceAndAutomationAccountProvisioning" -ResourceGroupName $ResourceGroupName -TemplateFile $workspaceAutomationTemplateFile -workspaceName $WorkspaceName -workspaceLocation $WorkspaceLocation -automationName $AutomationAccountName -automationLocation $AutomationAccountLocation -ErrorAction Stop
    }
    catch {
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
    try {
        New-AzResourceGroupDeployment -Name "EnableSolutions" -ResourceGroupName $ResourceGroupName -TemplateFile $workspaceSolutionsTemplateFile -workspaceName $WorkspaceName -WorkspaceLocation $WorkspaceLocation -Mode Incremental -ErrorAction Stop
    }
    catch {
        $message = "Solution provisioning on workspace failed. Detailed below... `n $_"
        ThrowTerminatingError -ErrorId "SolutionProvisioningFailed" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
    }
    
    If ($AutoEnroll -eq $false) {
        #
        # Check if default change tracking saved search group already exists
        # If not, add the default change tracking saved search and scope config
        #
        $savedSearch = Get-AzOperationalInsightsSavedSearch -ResourceGroupName $ResourceGroupName -WorkspaceName $WorkspaceName

        $createSavedSearch = $true
        foreach ($s in $savedSearch.Value) {
            if ($s.Id.Contains("changetracking|microsoftdefaultcomputergroup")) {
                Write-output "Default saved search group already exists: $($s.Id)"
                $createSavedSearch = $false
                break
            }
        }

        if ($createSavedSearch) {
            Write-Output "Phase 1 Deployment start: Add scope config to the workspace"		

            try {
                New-AzResourceGroupDeployment -Name "AddScopeConfig" -ResourceGroupName $ResourceGroupName -TemplateFile $scopeConfigTemplateFile -workspaceName $WorkspaceName -WorkspaceLocation $Workspacelocation -Mode Incremental -ErrorAction Stop
            }
            catch {
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
    if (-not $workspace) {
        $message = "Workspace: $($WorkspaceName) does not exists. Please check."
        ThrowTerminatingError -ErrorId "WorkspaceNotFound" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
    }

    #
    # Phase 2 deployment
    #
    Write-Output "Phase 2 Deployment start: Configure Change tracking"		

    try {
        New-AzResourceGroupDeployment -Name "ConfigureChangeTracking" -ResourceGroupName $ResourceGroupName -TemplateFile $changeTrackingTemplateFile -workspaceName $WorkspaceName -WorkspaceLocation $Workspacelocation -Mode Incremental -ErrorAction Stop
    }
    catch {
        $message = "ChangeTracking provisioning on ResouceGroup failed. Detailed below... `n $_"
        ThrowTerminatingError -ErrorId "ChangeTrackingProvisioningFailed" `
            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
            -Exception $message
    }
}
catch {
    $message = "Deployment failed.`n $_"
    ThrowTerminatingError -ErrorId "DeploymentFailed" `
        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
        -Exception $message
}


##################################################################################################################
#  Step 2 - Enable Update Management Agent on Azure VM's
####

Write-Host "Step 2 - Enable Update Management Agent on Azure VM's"

$workspace = (Get-AzOperationalInsightsWorkspace).Where( { $_.Name -eq $workspaceName })

if ($workspace.Name -ne $workspaceName) {
    Write-Error "Unable to find OMS Workspace $workspaceName. "
}

$workspaceId = $workspace.CustomerId
$workspaceKey = (Get-AzOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $workspace.ResourceGroupName -Name $workspace.Name).PrimarySharedKey

$WindowsVMs = Get-AzVM | where-object { $_.StorageProfile.OSDisk.OSType -eq "Windows" } | Sort-Object Name | ForEach-Object { $_.Name } | Out-String -Stream | Select-Object
$LinuxVMs = Get-AzVM | where-object { $_.StorageProfile.OSDisk.OSType -eq "Linux" } | Sort-Object Name | ForEach-Object { $_.Name } | Out-String -Stream | Select-Object


foreach ($WindowsVM in $WindowsVMs) {

    $VMResourceGroup = get-azvm -name $WindowsVM | Select-Object -ExpandProperty ResourceGroupName
    $VMLocation = Get-AzVM -Name $WindowsVM | Select-Object -ExpandProperty Location

    Set-AzVMExtension -ResourceGroupName $VMresourcegroup -VMName $WindowsVM -Name 'MicrosoftMonitoringAgent' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'MicrosoftMonitoringAgent' -TypeHandlerVersion '1.0' -Location $VMLocation -SettingString "{'workspaceId':  '$workspaceId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey' }"

}

foreach ($LinuxVM in $LinuxVMs) {

    $VMResourceGroup = get-azvm -name $LinuxVM | Select-Object -ExpandProperty ResourceGroupName
    $VMLocation = Get-AzVM -Name $LinuxVM | Select-Object -ExpandProperty Location

    Set-AzVMExtension -ResourceGroupName $VMresourcegroup -VMName $LinuxVM -Name 'OmsAgentForLinux' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'OmsAgentForLinux' -TypeHandlerVersion '1.0' -Location $VMlocation -SettingString "{'workspaceId':  '$workspaceId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey' }"

}

Write-Host "All Azure VMs have been enabled for Update Management.  Please don't forget to tip your serves.  Have a nice day!"


##################################################################################################################
#  Step 3 - Deploy Azure Policy for automating the enablement of Update Management on new Azure VMs..... (Coming Soon!)
####

Write-Host "Step 3 -  Deploy Azure Policy for Update Management Agent! (Sorry, this is coming soon!!!!!)  Until Next week!"


##################################################################################################################
#  Step 4 - Automation of Azure VM Resource Tagging.
####

Write-Host " Step 4 - Automation of Azure VM Resource Tagging."


#  Discovery of all Azure VM's in the current subscription.
$azurevms = Get-AzVM | Select-Object -ExpandProperty Name
Write-Host "Discovering Azure VM's in the following subscription $SubscriptionID  Please hold...."

Write-Host "The following VM's have been discovered in subscription $SubscriptionID"
$azurevms


foreach ($azurevm in $azurevms) {
    
    Write-Host Checking for tag "$vmtagname" on "$azurevm"
    $tagrg = get-azvm -name $azurevm | Select-Object -ExpandProperty ResourceGroupName
    
    $tags = (Get-AzResource -ResourceGroupName $tagrg `
            -Name $azurevm).Tags

    Write-Host "Creating Tag $vmtagname and Value $tagvalue for $azurevm"
    $tags.Add($vmtagname, $tagvalue)
  
    Set-AzResource -ResourceGroupName $tagrg `
        -ResourceName $azurevm `
        -ResourceType Microsoft.Compute/virtualMachines `
        -Tag $tags `
        -Force
}


#  Section use to work.  Commented out to discover why.
# foreach ($azurevm in $azurevms) {
    
#     Write-Host Checking for tag "$vmtagname" on "$azurevm"
#     $tagrg = get-azvm -name $azurevm | Select-Object -ExpandProperty ResourceGroupName
    
#     $tags = (Get-AzResource -ResourceGroupName $tagrg `
#                         -Name $azurevm).Tags

# If ($tags.UpdateWindow){
# Write-Host "$azurevm already has the tag $vmtagname."
# }
# else
# {
# Write-Host "Creating Tag $vmtagname and Value $tagvalue for $azurevm"
# $tags.Add($vmtagname,$tagvalue)
  
#     Set-AzResource -ResourceGroupName $tagrg `
#                -ResourceName $azurevm `
#                -ResourceType Microsoft.Compute/virtualMachines `
#                -Tag $tags `
#                -Force
#    }
   
# }

Write-Host "All tagging is done (and hopfully it worked).  Please exit the ride to your left.  Have a nice day!"


##################################################################################################################
#  Step 5 - Deploy Azure Policy for Tagging (Coming Soon!)
####

Write-Host "Step 5 -  Deploy Azure Policy for Tagging! (Sorry, this is coming soon!!!!!)  Please Play again!"


##################################################################################################################
#  Step 6 - Configure AZ Windows VM's Advance Setttings for Update Management.
####

Write-Host "Step 6 - Configure AZ Windows VM's Advance Setttings for Update Management."

#  Discovery of all Azure VM's in the current subscription.
$azurevms = Get-AzVM | where-object { $_.StorageProfile.OSDisk.OSType -eq "Windows" } | Sort-Object Name | ForEach-Object { $_.Name } | Out-String -Stream | Select-Object
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
    $ServiceManager.AddService2($ServiceId, 7, "")

}

Write-Host "All settigns have been deployed. (and hopfully it worked).  Please exit the ride to your left.  Have a nice day!"


##################################################################################################################
#  Step 7 - Deploy Azure Policy for WAU Client Configurations..... (Coming Soon!)
####

Write-Host "Step 7 -  Deploy Azure Policy for to configure WAU on Azure VM! (Sorry, this is coming soon!!!!!)  Not again!!"


##################################################################################################################
#  Step 8 - Create the Deployment Schedules
#####

Write-Host "Step 8 - Create the Deployment Schedules"


#  Build the array
#  This will use the array.csv file.

$ScheduleConfig = Get-Content -Path .\array.csv | ConvertFrom-Csv

#  Schedule Deployments Start Here

$scope = "/subscriptions/$((Get-AzContext).subscription.id)"
$QueryScope = @($scope)

$WindowsSchedules = $ScheduleConfig | Where-Object { $_.OS -eq "Windows" }
$LinuxSchedules = $ScheduleConfig | Where-Object { $_.OS -eq "Linux" }

foreach ($WindowsSchedule in $WindowsSchedules) {

    $tag = @{$WindowsSchedule.TagName = $WindowsSchedule.TagValue }
    $azq = New-AzAutomationUpdateManagementAzureQuery -ResourceGroupName $ResourceGroupName `
        -AutomationAccountName $AutomationAccountName `
        -Scope $QueryScope `
        -Tag $tag

    $AzureQueries = @($azq)

    $date = ((get-date).AddDays(1)).ToString("yyyy-MM-dd")
    $time = $WindowsSchedule.Starttime
    $datetime = $date + "t" + $time

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
        -IncludedUpdateClassification Critical, Security, Updates, UpdateRollup, Definition `
        -Duration $duration `
        -RebootSetting $WindowsSchedule.Reboot
}

foreach ($LinuxSchedule in $LinuxSchedules) {

    $tag = @{$LinuxSchedule.TagName = $LinuxSchedule.TagValue }
    $azq = New-AzAutomationUpdateManagementAzureQuery -ResourceGroupName $ResourceGroupName `
        -AutomationAccountName $AutomationAccountName `
        -Scope $QueryScope `
        -Tag $tag

    $AzureQueries = @($azq)

    $date = ((get-date).AddDays(1)).ToString("yyyy-MM-dd")
    $time = $LinuxSchedule.Starttime
    $datetime = $date + "t" + $time

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
        -IncludedPackageClassification Critical, Security `
        -Duration $duration `
        -RebootSetting $LinuxSchedule.Reboot
}

Write-Host "Now that took forever but the deployment schedules are done!"

##################################################################################################################
# All Done.
#####

Write-host "That is all folks!"
