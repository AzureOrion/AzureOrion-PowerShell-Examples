#####################################################################################################################
# Check for Pending Reboot
# returns true if a reboot pending, false or null if not. 
#####################################################################################################################

# ................................................................................................................. #
# Introduction / Banner 
Write-Host "############################################################" -ForegroundColor Blue
Write-Host "  Check for Pending Reboot"
Write-Host "############################################################" -ForegroundColor Blue
Write-Host ""


# Check Component Based Servicing
Write-Host "Component Based Servicing..."
$CBS = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue
if ($CBS) {
	Write-Host "   TRUE" -ForegroundColor Red
} else {
	Write-Host "   FALSE" -ForegroundColor Green
}
Write-Host ""

# Check Auto Update 
Write-Host "Auto Update..."
$AU = Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue
if ($AU) {
	Write-Host "   TRUE" -ForegroundColor Red
} else {
	Write-Host "   FALSE" -ForegroundColor Green
}
Write-Host ""

# Check Session Manager
Write-Host "Session Manager..."
$SM = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -ErrorAction SilentlyContinue
if ($SM) {
	Write-Host "   TRUE" -ForegroundColor Red
} else {
	Write-Host "   FALSE" -ForegroundColor Green
} 
Write-Host ""

# Check #4 SCCM WMI
Write-Host "SCCM WMI..."
try { 
	$util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
	$status = $util.DetermineIfRebootPending()
	if(($null -ne $status) -and $status.RebootPending){
		Write-Host "   TRUE" -ForegroundColor Red
	} else {
		Write-Host "   FALSE" -ForegroundColor Green
	}   
}catch{
	Write-Host "   FALSE" -ForegroundColor Green
}
Write-Host ""

Pause
