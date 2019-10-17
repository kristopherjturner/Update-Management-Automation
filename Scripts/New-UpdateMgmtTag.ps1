###################################
#  This script is will add a new tag and value all Azure VM's running within Subscription.
#  Current Version:  .01000001 01111010 01110101 01110010 01100101
#  Date Written:   8-29-2019
#  Created By:    Kristopher J. Turner (The Country Cloud Boy)
#  Uses the Az Module and not the AzureRM module
#####################################

#  Please fill in the following 4 variables.
$TenantID=""
$SubscriptionID=""
$vmtagname = "UpdateWindow"
$tagvalue = "Default"


Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID


#  Discovery of all Azure VM's in the current subscription.
$azurevms = Get-AzVM | Select-Object -ExpandProperty Name
Write-Host "Discovering Azure VM's in the following subscription $SubscriptionID  Please hold...."

Write-Host "The following VM's have been discovered in subscription $SubscriptionID"
$azurevms


foreach ($azurevm in $azurevms) {
    
    Write-Host Checking for tag "$vmtagname" on "$azurevm"
    $tagRGname = get-azvm -name $azurevm | Select-Object -ExpandProperty ResourceGroupName
    
    $tags = (Get-AzResource -ResourceGroupName $tagRGname `
                        -Name $azurevm).Tags

If ($tags.UpdateWindow){
Write-Host "$azurevm already has the tag $vmtagname."
}
else
{
Write-Host "Creating Tag $vmtagname and Value $tagvalue for $azurevm"
$tags.Add($vmtagname,$tagvalue)
  
    Set-AzResource -ResourceGroupName $tagRGname `
               -ResourceName $azurevm `
               -ResourceType Microsoft.Compute/virtualMachines `
               -Tag $tags `
               -Force `
   }
   
}

Write-Host "All tagging is done (and hopfully it worked).  Please exit the ride to your left.  Have a nice day!"