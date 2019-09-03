###################################
#  This script is will add a new tag and value all Azure VM's running within Subscription.
#  Current Version:  .01000001 01111010 01110101 01110010 01100101
#  Date Written:   8-29-2019
#  Created By:    Kristopher J. Turner (The Country Cloud Boy)
#  Uses the Az Module and not the AzureRM module
#####################################

#  Need Authentication Step if not running within Azure CloudShell
#  If not using Cloudshell use the current version of Azure PowerShell
#  Use the AZ Module and not AzureRM Module

# Variables - Required
$TenantID=""
$SubscriptionID=""

Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID


#  Discovery of all Azure VM's in the current subscription.
$azurevms = Get-AzVM | Select-Object -ExpandProperty Name
Write-Host "Discovering Azure VM's.  Please hold...."

#  Variables that can change but really shouldn't.  Unless you want to change these variables then they should be changed. 
$aztag = "UpdateWindow"
$tagvalue = "Default"

foreach ($azurevm in $azurevms) {
    
    Write-Host Adding tag "$aztag" to "$azurevm" with the value of "$tagvalue"
    $ResourceGroupName = get-azvm -name $azurevm | Select-Object -ExpandProperty ResourceGroupName
    
    $tags = (Get-AzResource -ResourceGroupName $ResourceGroupName `
                        -Name $azurevm).Tags

    $tags.Add($aztag,$tagvalue)
  
    Set-AzResource -ResourceGroupName $ResourceGroupName `
               -ResourceName $azurevm `
               -ResourceType Microsoft.Compute/virtualMachines `
               -Tag $tags `
               -Force `
               
}

Write-Host "All tagging is done (and hopfully it worked).  Please exit the ride to your left.  Have a nice day!"