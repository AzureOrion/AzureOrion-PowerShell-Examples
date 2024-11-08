function Get-WebFile {
    param(
        [parameter(Mandatory)]
        [string]$FileName,
        [parameter(Mandatory)]
        [string]$URL
    )
    $Counter = 0
    do {
        $Response = Invoke-WebRequest -Uri $URL -OutFile $FileName  -UseBasicParsing -UseDefaultCredentials -PassThru
        if ($Response.StatusCode -ne 200) { 
            Write-Host "Failed to download $FileName" -ForegroundColor Red
            Write-Host "Response $($Response.StatusCode) ($($Response.StatusDescription))" -ForegroundColor Red
        }
        if ($Counter -gt 0) {
            Start-Sleep -Seconds 30
        }
        $Counter++
    }
    until((Test-Path $FileName) -or $Counter -eq 9)
    if ($Response.StatusCode -eq 200) { 
        Write-Host "Successfully downloaded $FileName" -ForegroundColor Green
    }
} 


# Download
Get-WebFile -URL $DownloadPathRemote -FileName ($DownloadPathLocal + $DownloadFileName)