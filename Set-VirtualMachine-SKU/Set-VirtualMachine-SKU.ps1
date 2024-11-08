<#

.SYNOPSIS
Set Virtual Machine SKU

.DESCRIPTION
Script to change the SKU of one Virtual Machine

.NOTES


.EXAMPLE
Set-VirtualMachineSKU-RG -tenantId "tenant ID" -rgName "rgname" -vmName "Virtual Machine name" -TargetSKU "Standard_E4ads_v5"

#>

####################################
#  Parameter                       #
####################################

param(
    [Parameter(Position = 0,Mandatory = $true)]
    [string]  $tenantId,
    [Parameter(Position = 1,Mandatory = $true)]
    [string]  $rgName,
    [Parameter(Position = 3,Mandatory = $true)]
    [string]  $vmName,
    [Parameter(Mandatory = $true,ParameterSetName = "ShowRecursive")]
    [string]  $TargetSKU = 'Standard_E4ads_v5'
)

####################################
#  Preparation                     #
####################################

# Logon to Azure
Connect-AzAccount -Tenant $tenantId

# Subscription Select
$subscriptions = Get-AzSubscription
$cnt = 1
Write-Host "ID    Subscription Name"
Write-Host "-----------------------"

foreach ($sub in $subscriptions) {
    Write-Host "$cnt   $($sub.name)"
    $cnt++
}
$selection = Read-Host -Prompt "Select a subscription to deploy to"
$subSelect = $subscriptions[$selection - 1] # Revert 1-index to 0-index

Select-AzSubscription $subSelect.SubscriptionId


#####################
# Start             # 
#####################
# Get a list of all VMs from a Resource Group
$VM = Get-AzVM -ResourceGroupName $rgName -Name $vmName | Select-Object -ExpandProperty Name

# Resize the VM
Write-Output "Changing $($VM) to $($TargetSKU)"
$VM_Data = Get-AzVM -ResourceGroupName $rgName -VMName $VM
$VM_Data.HardwareProfile.VmSize = $TargetSKU
Update-AzVM -VM $VM_Data -ResourceGroupName $rgName | Out-Null

#############
#    END    #
#############