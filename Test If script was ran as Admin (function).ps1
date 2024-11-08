function Test-Administrator {  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    return (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

if ((Test-Administrator) -eq $false) {
    Write-Host -ForegroundColor Red "The script should be executed with admin previliges"
    Trace("Script wasn't executed as admin");
    Exit 1;
}
