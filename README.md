# DotFiles Aleksander Evensen

## What is this
This is a repo used to automate the PC setup process with my preffered settings and tools / programs


## How to use
When setting up a new computer: 
1. Start PowerShell as Administrator
2. Copy paste the code under this section
3. Accept all if necessery
PS: Do not run if you don't trust me. ;)

```ps1
Set-ExecutionPolicy Unrestricted -Scope LocalMachine # Can change the scope to Process if you only want the policy to run for the current process
iex ((New-Object System.Net.WebClient).DownloadString('link_here'))
```