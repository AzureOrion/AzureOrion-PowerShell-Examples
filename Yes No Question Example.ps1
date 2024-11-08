Write-host "Would you like to download your PublishSettings File to connect to Azure? (Default is Yes)" -ForegroundColor Yellow 
$Readhost = Read-Host " ( y / n ) " 
Switch ($ReadHost) { 
  Y { Write-host "Yes, Download PublishSettings"; $PublishSettings = $true } 
  N { Write-Host "No, Skip PublishSettings"; $PublishSettings = $false } 
  Default { Write-Host "Default, Skip PublishSettings"; $PublishSettings = $false } 
} 