function PromptUser {

    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$title, 
        [Parameter(Mandatory=$true, Position=1)]
        [string]$desc, 
        [Parameter(Mandatory=$true, Position=2)]
        [string[][]]$choices, 
        [Parameter(Mandatory=$false, Position=3)]
        [int]$default = -1
    )

    $options = @();
    foreach ($choice in $choices) {
        write-host $choice;
        $options += (New-Object System.Management.Automation.Host.ChoiceDescription $choice) 
    }

    Write-Host $options
    return $host.ui.PromptForChoice($title, $desc, $options, $default)
}



$result = PromptUser "Run the Setup Script" "Should we run the setup.ps1 script after the insallation. This script will install everything needed" @(
    @("&yes", "Yes"),
    @("&no", "No")
) -default 1

write-host "Installing git..."
# Download git cli tool
winget install Git.Git
# Refresh the path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
write-host "Git installed"
write-host "Cloning repo"
# Cloning the repo
Push-Location $HOME
git clone https://github.com/AleksanderEvensen/dotfiles.git
Pop-Location

Set-Location $HOME/dotfiles

if ($result -eq 0) {
    Invoke-Expression -Command "./setup.ps1"
} else {
    write-host "Skipping script execution. start the setup.ps1 script manually to complete the setup"
}

