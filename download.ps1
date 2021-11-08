function PromptUser($title, $desc, $choices, $default = -1) {
    $options = ("hello world", "test");
    # for( $i=0; $i -lt $choices.length; $i++) {
    #     write-host $choices[$i]
    #     $options.Add((New-Object System.Management.Automation.Host.ChoiceDescription $choices[$i] ) ) 
    # }
    write-host $title
    write-host $desc
    write-host $default
    Write-Output $choices -NoEnumerate | Measure-Object
    Write-Output $options -NoEnumerate | Measure-Object
    # Write-Output $options
    return 0;
    return $host.ui.PromptForChoice($title, $desc, $options, 1)
}


$result = PromptUser("Title", "Description", @(
    ("&Yes", "Idk"),
    ("&No", "Idk 2")
), 1)


switch ($result) {
  0 {
    Write-Host "Yes"
  }

  1 {
    Write-Host "No"
  }
}
# write-host "Installing git..."
# # Download git cli tool
# winget install Git.Git
# write-host "Git installed"
# write-host "Cloning repo"
# pushd $HOME
# git clone https://github.com/AleksanderEvensen/dotfiles.git
# popd
# cd $HOME/dotfiles

