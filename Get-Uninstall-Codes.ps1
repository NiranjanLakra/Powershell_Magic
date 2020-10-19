[CmdletBinding()]param(
    [Parameter(Mandatory = $True, HelpMessage = "Please enter a Product Name to search for its Uninstall String")]$productName)
try{
    Write-Host " "
    Write-Host -ForegroundColor Gray “------------------------Getting UninstallString, Products Codes------------------------”
    Write-Host " "
    Write-Host -ForegroundColor Green “HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\”
    Get-childitem -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString | Select-String $productName
    Write-Host " "
    Write-Host “--------------------------------------------------------------------------”
    Write-Host " "
    Write-Host -ForegroundColor Green “HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\”
    Write-Host " "
    Get-childitem -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\  | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString | Select-String $productName
    Write-Host " "
    Write-Host “--------------------------------------------------------------------------”
    $a=Get-PSDrive |Select-String HKCR
    if ($a -like ‘HKCR’)
        {
            Write-Host " "
            Write-Host “HKCR already Mounted”
            Write-Host “--------------------------------------------------------------------------”
        }
    else
        {
            Write-Host " "
            Write-Host “[+] Mounting HKCR”
            New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -NAme HKCR
            Write-Host “[+] HKCR Mounted”
            Write-Host " "
            Write-Host “--------------------------------------------------------------------------”
        }
    Write-Host " "
    Write-Host -ForegroundColor Green "HKEY_CLASSES_ROOT\Installer\Products\"
    Write-Host " "
    Get-childitem -Path Registry::HKEY_CLASSES_ROOT\Installer\Products\ | Get-ItemProperty | Select-Object -Property ProductName, PackageCode, ProductIcon | Select-String $productName
    Remove-PSDrive -Name HKCR
    Write-Host " "
    Write-Host “[-] UN-Mounted HKCR”
    Write-Host " "
    }
catch{"Usage : .\Get-Uninstall-Codes.ps1 -productName malwarebytes"}