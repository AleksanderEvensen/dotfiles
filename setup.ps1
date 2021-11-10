Write-Host "Installing apps"
# Install all the apps listed in the winget-apps.json file
winget import $PSScriptRoot/winget-apps.json

Write-Host "Installing PowerShell Modules"
Install-Module posh-git
Install-Module ZLocation
Install-Module -Name Terminal-Icons -Repository PSGallery

if (Test-Path $PROFILE) {
    Remove-Item -Force $PROFILE
}
New-Item -ItemType SymbolicLink -Path $PROFILE -Target $PSScriptRoot/configs/PowerShell.ps1