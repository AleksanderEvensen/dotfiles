# Import Modules
Import-Module posh-git
oh-my-posh --init --shell pwsh --config $HOME/dotfiles/configs/AleksanderEvensen.omp.json | Invoke-Expression
Import-Module ZLocation
Import-Module Terminal-Icons

# Configure Oh My Posh
Set-PoshPrompt -Theme ys

# Configure PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows