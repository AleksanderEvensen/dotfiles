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



$result = PromptUser -title "Run the Setup Script" -desc "Should we run the setup.ps1 script after the insallation. This script will install everything needed"  -choices @(
    @("&yes", "Yes"),
    @("&no", "No")
) -default 1

write-host "Installing git..."
# Download git cli tool
winget install Git.Git
write-host "Git installed"
write-host "Cloning repo"
# Cloning the repo
pushd $HOME
git clone https://github.com/AleksanderEvensen/dotfiles.git
popd

cd $HOME/dotfiles

if ($result -eq 0) {
    Invoke-Expression -Command "./setup.ps1"
} else {
    write-host "Skipping script execution. start the setup.ps1 script manually to complete the setup"
}

