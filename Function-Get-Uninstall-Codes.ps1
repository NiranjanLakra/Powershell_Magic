Function get-uninstallString{

[CmdletBinding()]param(
    [Parameter(Mandatory = $True, HelpMessage = "Please enter a Product Name to search for its Uninstall String")]$productName)
try{
    $uninstall_string1 = Get-childitem -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString | Select-String $productName
    $uninstall_string2 = Get-childitem -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\  | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString | Select-String $productName
    Write-Host " "
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
        }
    $uninstall_string3 = Get-childitem -Path Registry::HKEY_CLASSES_ROOT\Installer\Products\ | Get-ItemProperty | Select-Object -Property ProductName, PackageCode, ProductIcon | Select-String $productName
    }
catch{"Usage : .\Get-Uninstall-Codes.ps1 -productName malwarebytes"}

return (($uninstall_string1, $uninstall_string2, $uninstall_string3).Line | FT -AutoSize)
}