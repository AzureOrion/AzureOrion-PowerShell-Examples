<#

.SYNOPSIS
Azure Powershell quick start

.DESCRIPTION
Script to connect to Azure and offer a list of subscriptions to select from


#>

# Login to Azure
$context = Get-AzContext
if (!$context) {
    Write-Host "Logging in to Azure" -ForegroundColor Yellow
    Connect-AzAccount
}
else {
    Write-Host "You are already connected to Azure, Proceeding..." -ForegroundColor Yellow
}

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

Write-Host "Subscription selected = $($sub.name) "