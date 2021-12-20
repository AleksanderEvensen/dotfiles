# Import Modules
oh-my-posh --init --shell pwsh --config $HOME/dotfiles/configs/AleksanderEvensen.omp.json | Invoke-Expression
Import-Module posh-git
Import-Module ZLocation
Import-Module Terminal-Icons

# Configure PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows