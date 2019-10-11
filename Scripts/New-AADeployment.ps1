<#
    .SYNOPSIS
        This script rolls orchestrate the deployment of the solutions and the agents.
    .Parameter SubscriptionName
    .Parameter WorkspaceName
    .Parameter AutomationAccountName
    .Parameter WorkspaceLocation
    .Parameter AutomationAccountLocation

    .Example
    .\New-AMSDeployment.ps1 -SubscriptionName 'Subscription Name' -WorkspaceName 'WorkspaceName' -WorkspaceLocation 'eastus' -AutomationAccountName -AutomationAccountLocation

    .Notes
    PolicySet '[Preview]: Enable Azure Monitor for VMs' is assigned with name VMInsightPolicy. 
#>

param (
    [Parameter(Mandatory=$true, HelpMessage="Subscription Name" ) ]
    [string]$SubscriptionName,

    [Parameter(Mandatory=$true, HelpMessage="Resource Group Name" )]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false, HelpMessage="Resource Group location. Defaults to EastUS" )]
    [string]$ResourceGroupLocation = "eastus",

    [Parameter(Mandatory=$true, HelpMessage="Workspace Name" )]
    [string]$WorkspaceName,

    [Parameter(Mandatory=$false, HelpMessage="Workspace location. Defaults to EastUS" )]
    [string]$WorkspaceLocation = "eastus",

    [Parameter(Mandatory=$true, HelpMessage="Automation Account Name" )]
    [string]$AutomationAccountName,

    [Parameter(Mandatory=$false, HelpMessage="Automation Account location. Defaults to EastUS2" )]
    [string]$AutomationAccountLocation = "eastus2",

    [Parameter(Mandatory=$false, HelpMessage="Auto Enroll." )]
    [string]$AutoEnroll = $false

)

# Script settings
Set-StrictMode -Version Latest

# function ThrowTerminatingError
# {
#      Param
#     (
#         [Parameter(Mandatory=$true)]
#         [ValidateNotNullOrEmpty()]
#         [String]
#         $ErrorId,

#         [Parameter(Mandatory=$true)]
#         [ValidateNotNullOrEmpty()]
#         $ErrorCategory,

#         [Parameter(Mandatory=$true)]
#         [ValidateNotNullOrEmpty()]
#         $Exception
#     )

#     $errorRecord = [System.Management.Automation.ErrorRecord]::New($Exception, $ErrorId, $ErrorCategory, $null)
#     throw $errorRecord
# }

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

$changeTrackingTemplateFile = @"
[
{
    "contentVersion": "1.0.0.0",
    "parameters": {
        "workspaceLocation": {
            "type": "String"
        },
        "workspaceName": {
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "name": "[Concat(parameters('workspaceName'), '/ChangeTrackingServices_CollectionFrequency')]",
            "type": "Microsoft.OperationalInsights/workspaces/dataSources",
            "kind": "ChangeTrackingServices",
            "comments": "The Collection Time Interval is in seconds",
            "apiVersion": "2015-11-01-preview",
            "location": "[parameters('workspaceLocation')]",
            "properties": {
                "ListType":"Blacklist",
                "CollectionTimeInterval":12
            }
        },
        {
            "name": "[Concat(parameters('workspaceName'), '/ChangeTrackingDataTypeConfiguration_FileRecursive')]",
            "type": "Microsoft.OperationalInsights/workspaces/dataSources",
            "kind": "ChangeTrackingDataTypeConfiguration",
            "comments": "Adding one file requires two PUT calls. Also each file needs to be added individually",
            "apiVersion": "2015-11-01-preview",
            "location": "[parameters('workspaceLocation')]",
            "properties": {
                "DataTypeId": "FileRecursive",
                "Enabled": "false"
            }
        },
        {
            "name": "[Concat(parameters('workspaceName'), '/ChangeTrackingWindows_HostsFile')]",
            "type": "Microsoft.OperationalInsights/workspaces/dataSources",
            "kind": "ChangeTrackingCustomPath",
            "comments": "Adding hosts file",
            "apiVersion": "2015-11-01-preview",
            "location": "[parameters('workspaceLocation')]",
            "properties": {
                "checksum": "MD5",
                "enabled": true,
                "groupTag": "Security",
                "path": "%winDir%\\System32\\Drivers\\etc\\hosts",
                "pathType": "File",
                "recurse": false
            }
        },
        {
            "name": "[Concat(parameters('workspaceName'), '/ChangeTrackingLinux_networkfolder')]",
            "type": "Microsoft.OperationalInsights/workspaces/dataSources",
            "kind": "ChangeTrackingLinuxPath",
            "comments": "Adding linux network file",
            "apiVersion": "2015-11-01-preview",
            "location": "[parameters('workspaceLocation')]",
            "properties": {
                "checksum": "MD5",
                "enabled": true,
                "groupTag": "custom",
                "destinationPath": "/etc/networks/*.*",
                "pathType": "File",
                "recurse": true,
                "useSudo": "true",
                "type": "File",
                "MaxContentsReturnable": "5000000",
                "MaxOutputSize": "5000000",
                "links": "Follow"           
            }
        }
    ]
}
]
"@

$scopeConfigTemplateFile = @"
[

{
    "contentVersion": "1.0.0.0",
    "parameters": {
      "workspaceName": {
        "type": "string",
        "defaultValue": "WorkspaceOne",
        "metadata": {
          "description": "Assign a name for the Log Analytic Workspace Name"
          }
      },
      "workspaceLocation": {
        "type": "string",
        "metadata": {
          "description": "Specify the region for your Workspace"
        }
      }
    },
      "variables": {
        "ChangeTrackingInclude": ["ChangeTracking_MicrosoftDefaultComputerGroup"] ,
        "ScopeConfigName": "MicrosoftDefaultScopeConfig-ChangeTracking",
        "ScopeConfigKind": "SearchComputerGroup"
      },

      "resources": [
       {
            "apiVersion": "2017-04-26-preview",
            "type": "Microsoft.OperationalInsights/workspaces/savedSearches",
            "name": "[concat(parameters('workspaceName'), '/', 'changetracking|microsoftdefaultcomputergroup')]",
            "location": "[parameters('workspaceLocation')]",
            "properties": {
                "displayname": "MicrosoftDefaultComputerGroup",
                "category": "ChangeTracking",
                "query": "Heartbeat | where Computer in~ (\"\") or ComputerEnvironment =~ \"Azure\" or VMUUID in~ (\"\") | distinct Computer",
                "functionAlias": "ChangeTracking_MicrosoftDefaultComputerGroup",
                "etag": "",
                "tags": [
                    {
                        "Name": "Group",
                        "Value": "Computer"
                    }
                ]
            }
        },
        {
            "apiVersion": "2015-11-01-preview",
            "type": "Microsoft.OperationalInsights/workspaces/configurationScopes",
            "name": "[concat(parameters('workspaceName'), '/', variables('ScopeConfigName'), '/')]",
            "kind": "[variables('ScopeConfigKind')]",            
            "location": "[parameters('workspaceLocation')]",
            "properties": {
                "Include": "[variables('ChangeTrackingInclude')]"
              }
        }
      ], 
  
    "outputs": {
      }
  }

]
"@


$workspaceAutomationTemplateFile = @"
[
{
  "parameters": {
    "workspaceName": {
      "type": "string",
      "defaultValue": "WorkspaceOne",
      "metadata": {
        "description": "Assign a name for the Log Analytic Workspace Name"
        }
    },
    "workspaceLocation": {
      "type": "string",
      "defaultValue": "eastus",
      "metadata": {
        "description": "Specify the region for your Workspace"
      }
    },
    "automationLocation": {
      "type": "string",
      "defaultValue": "eastus2",
      "metadata": {
        "description": "Specify the region for your Automation Account"
      }
    },
    "automationName": {
        "type": "string",
        "defaultValue": "AutomationAccountOne",
        "metadata": {
            "description": "Assign a name for the Automation Account Name"
        }
    }
  },
    "variables": {
    },
    "resources": [
      {
        "apiversion": "2015-10-31",
        "location": "[parameters('automationLocation')]",
        "name": "[parameters('automationName')]",
        "type": "Microsoft.Automation/automationAccounts",
        "comments": "Automation account",
        "properties": {
          "sku": {
            "name": "OMS"
          }
        }
      },

      {
        "apiVersion": "2017-03-15-preview",
        "location": "[parameters('workspaceLocation')]",
        "name": "[parameters('workspaceName')]",
        "type": "Microsoft.OperationalInsights/workspaces",
        "comments": "Log Analytics workspace",
        "properties": {
          "sku": {
            "name": "pernode"
          },
          "features": {
            "legacy": 0,
            "searchVersion": 1
          }
        },
        "resources": [
          {
            "name": "AzureActivityLog",
            "type": "datasources",
            "apiVersion": "2015-11-01-preview",
            "dependsOn": [
                "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workspaceName'))]"
            ],
            "kind": "AzureActivityLog",
            "properties": {
                "linkedResourceId": "[concat(subscription().id, '/providers/Microsoft.Insights/eventTypes/management')]"
            }
          },

          {
              "name": "Automation",
              "type": "linkedServices",
              "apiVersion": "2015-11-01-preview",
              "dependsOn": [
                  "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workspaceName'))]",
                  "[concat('Microsoft.Automation/automationAccounts/', parameters('automationName'))]"
              ],
              "properties": {
                  "resourceId": "[resourceId('Microsoft.Automation/automationAccounts/', parameters('automationName'))]"
              }
          }
        ]
      } 
    ], 

  "outputs": {
    }
  
}


]
"@

$workspaceSolutionsTemplateFile = @"
[

{
  "parameters": {
    "workspaceName": {
      "type": "string",
      "metadata": {
        "description": "Specify  the Log Analytic Workspace Name"
        }
    },
    "workspaceLocation": {
      "type": "string",
      "metadata": {
        "description": "Specify the region for your Workspace"
      }
    }
  },
  "variables": {
    "solutions": {
      "solution": [
        {
            "name": "[concat('SecurityCenterFree', '(', parameters('workspaceName'), ')')]",
            "marketplaceName": "SecurityCenterFree"
        },
        {
            "name": "[concat('AgentHealthAssessment', '(', parameters('workspaceName'), ')')]",
            "marketplaceName": "AgentHealthAssessment"
        },
        {
            "name": "[concat('ChangeTracking', '(', parameters('workspaceName'), ')')]",
            "marketplaceName": "ChangeTracking"
        },
        {
            "name": "[concat('Updates', '(', parameters('workspaceName'), ')')]",
            "marketplaceName": "Updates"
        },
        {
            "name": "[concat('AzureActivity', '(', parameters('workspaceName'), ')')]",
            "marketplaceName": "AzureActivity"
        },
        {
            "name": "[concat('AzureAutomation', '(', parameters('workspaceName'), ')')]",
            "marketplaceName": "AzureAutomation"
        },
        {
            "name": "[concat('InfrastructureInsights', '(', parameters('workspaceName'), ')')]",
            "marketplaceName": "InfrastructureInsights"
        },
        {
            "name": "[concat('ServiceMap', '(', parameters('workspaceName'), ')')]",
            "marketplaceName": "ServiceMap"
        }
      ]
    }
  },
  "resources": [
    {
      "apiVersion": "2015-11-01-preview",
      "type": "Microsoft.OperationsManagement/solutions",
      "name": "[concat(variables('solutions').solution[copyIndex()].Name)]",
      "location": "[parameters('workspaceLocation')]",
      "copy": {
          "name": "solutionCopy",
          "count": "[length(variables('solutions').solution)]"
      },
      "properties": {
          "workspaceResourceId": "[resourceId('Microsoft.OperationalInsights/workspaces/', parameters('workspaceName'))]"
      },
      "plan": {
          "name": "[variables('solutions').solution[copyIndex()].name]",
          "product": "[concat('OMSGallery/', variables('solutions').solution[copyIndex()].marketplaceName)]",
          "promotionCode": "",
          "publisher": "Microsoft"
      }
    }
  ], 

  "outputs": {
  }
}

]
"@


#
# Choose the right subscription
#
try
{
    $subscription = Get-AzSubscription -SubscriptionName $SubscriptionName  -ErrorAction Stop
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
