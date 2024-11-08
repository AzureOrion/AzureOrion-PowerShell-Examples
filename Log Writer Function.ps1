#region - These routines writes the output string to the console and also to the log file.
function Log-Info([string] $OutputText)
{
    Write-Host $OutputText -ForegroundColor White
    $OutputText = [string][DateTime]::Now + " " + $OutputText
    $OutputText | ForEach-Object{ Out-File -filepath $InstallerLog -inputobject $_ -append -encoding "ASCII" }
}

function Log-InfoHighLight([string] $OutputText)
{
    Write-Host $OutputText -ForegroundColor Cyan
    $OutputText = [string][DateTime]::Now + " " + $OutputText
    $OutputText | ForEach-Object{ Out-File -filepath $InstallerLog -inputobject $_ -append -encoding "ASCII" }
}

function Log-Input([string] $OutputText)
{
    Write-Host $OutputText -ForegroundColor White -BackgroundColor DarkGray -NoNewline
    $OutputText = [string][DateTime]::Now + " " + $OutputText
    $OutputText | ForEach-Object{ Out-File -filepath $InstallerLog -inputobject $_ -append -encoding "ASCII" }
    Write-Host " " -NoNewline
}

function Log-Success([string] $OutputText)
{
    Write-Host $OutputText -ForegroundColor Green
    $OutputText = [string][DateTime]::Now + " " + $OutputText
    $OutputText | ForEach-Object{ Out-File -filepath $InstallerLog -inputobject $_ -append -encoding "ASCII" }
}

function Log-Warning([string] $OutputText)
{
    Write-Host $OutputText -ForegroundColor Yellow
    $OutputText = [string][DateTime]::Now + " " + $OutputText
    $OutputText | ForEach-Object{ Out-File -filepath $InstallerLog -inputobject $_ -append -encoding "ASCII"  }
}

function Log-Error([string] $OutputText)
{
    Write-Host $OutputText -ForegroundColor Red
    $OutputText = [string][DateTime]::Now + " " + $OutputText
    $OutputText | ForEach-Object{ Out-File -filepath $InstallerLog -inputobject $_ -append -encoding "ASCII" }
}
#endregion


#region - Global Variables
$TimeStamp = [DateTime]::Now.ToString("yyyy-MM-dd-HH-mm-ss")
$LogFileDir               = "$env:ProgramData`\Microsoft Azure\Logs"
$LogFileName = "PSScriptLogFile_$($TimeStamp).log"

#endregion


## region - create the logfile
New-Item -ItemType Directory -Force -Path $LogFileDir | Out-Null
$InstallerLog = "$($LogFileDir)\$($LogFileName)"
Log-InfoHighLight "Log file created `"$InstallerLog`" for troubleshooting purpose.`n"

#endregion