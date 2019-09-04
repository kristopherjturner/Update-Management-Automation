###################################
#  This script is will add a new tag and value all Azure VM's running within Subscription.
#  Current Version:  .01000001 01111010 01110101 01110010 01100101
#  Date Written:   8-29-2019
#  Created By:    Kristopher J. Turner (The Country Cloud Boy)
#  Uses the Az Module and not the AzureRM module
#####################################

Param (
    [Parameter(Mandatory = $true)]
    [string]$TenantID, 
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionID,    
    [string]$AzTag = "UpdateWindow",
    [string]$TagValue = "Default"
)

Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID


#  Discovery of all Azure VM's in the current subscription.
$azurevms = Get-AzVM | Select-Object -ExpandProperty Name
Write-Output "Discovering Azure VM's in the following subscription $SubscriptionID  Please hold...."

Write-Output "The following VM's have been discovered in subscription $SubscriptionID"
Write-Output $azurevms


foreach ($azurevm in $azurevms) {
    
    Write-Output Checking for tag "$AzTag" on "$azurevm"
    $ResourceGroupName = get-azvm -name $azurevm | Select-Object -ExpandProperty ResourceGroupName
    
    $tags = (Get-AzResource -ResourceGroupName $ResourceGroupName `
                        -Name $azurevm).Tags

If ($tags.UpdateWindow){
Write-Output "$azurevm already has the tag $AzTag."
}
else
{
Write-Output "Creating Tag $AzTag and Value $TagValue for $azurevm"
$tags.Add($AzTag,$TagValue)
  
    Set-AzResource -ResourceGroupName $ResourceGroupName `
               -ResourceName $azurevm `
               -ResourceType Microsoft.Compute/virtualMachines `
               -Tag $tags `
               -Force `
   }
   
}

Write-Output "All tagging is done (and hopfully it worked).  Please exit the ride to your left.  Have a nice day!"
