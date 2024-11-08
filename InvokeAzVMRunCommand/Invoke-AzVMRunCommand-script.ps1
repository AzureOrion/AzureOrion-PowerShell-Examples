<#

.SYNOPSIS
Invoke AzVMRunCommand

.DESCRIPTION
Run a PowerShell Script (or other command) against a group of Virtual Machines

.NOTES
*** PowerShell 7 is required ***

To pass paramaters to the client Virtual Machine, uncomment the Parameters @ line 67

.EXAMPLE
Invoke-AzVMRunCommand-script.ps1 -tenantId 'tenant ID' -rgName 'rgname' -targetPS1 '.\script.ps1'

#>

####################################
#  Parameter                       #
####################################

param(
    [Parameter(Position = 0,Mandatory = $true)]
    [string]  $tenantId,
    [Parameter(Position = 1,Mandatory = $true)]
    [string]  $rgName,
    [Parameter(Mandatory = $true)]
    [string]  $TargetPS1 = '.\script.ps1'
)

####################################
#  Preparation                     #
####################################
#Requires -Version 7.0

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

#Get all Azure VMs which are in running state and are running Windows
$myAzureVMs = Get-AzVM -ResourceGroupName $rgName -status | Where-Object {$_.PowerState -eq "VM running" -and $_.StorageProfile.OSDisk.OSType -eq "Windows"}

#Run the scirpt again all VMs in parallel
$myAzureVMs | ForEach-Object -Parallel {
    $out = Invoke-AzVMRunCommand `
        -ResourceGroupName $_.ResourceGroupName `
        -Name $_.Name  `
        -CommandId 'RunPowerShellScript' `
        -ScriptPath $TargetPS1
        # -Parameter @{"arg1" = "var1";"arg2" = "var2"}

    #Formating the Output with the VM name
    $output = $_.Name + " " + $out.Value[0].Message
    $output   
}

#############
#    END    #
#############