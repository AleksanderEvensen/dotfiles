# DotFiles Aleksander Evensen

## What is this
This is a repo used to automate the PC setup process with my preferred settings and tools/programs


## How to use
When setting up a new computer: 
1. Start PowerShell as Administrator
2. Copy paste the code under this section
3. Accept all if necessary

PS: Do not run the code below if you don't trust me

```ps1
Set-ExecutionPolicy Unrestricted -Scope LocalMachine # Can change the scope to Process if you only want the policy to run for the current process
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/AleksanderEvensen/dotfiles/main/download.ps1'))
```
### What does it do
This script will download the contents from the latest download.ps1 file in this repository and execute the code within it