alias ".." "cd .."
alias lg lazygit
alias cc "codex --yolo"
alias oc "opencode --yolo"
complete -c oc -e
complete -c oc -w opencode

# ls aliases
alias ls "eza --icons --group-directories-first --time-style=\"+%d.%m.%Y %H:%M\""
alias la "ls -la"
alias l "ls -la"
alias ll "ls -l"
alias sl "ls"

alias q "pi --model big-pickle -p"

alias clauded "claude --dangerously-skip-permissions"
alias cclauded "cclaude --dangerously-skip-permissions"


zoxide init fish | source
starship init fish | source
fnm env --use-on-cd --shell fish | source

# Added by zv setup
source "$HOME/.zv/env.fish"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

source $HOME/.turso/env.fish


set -gx JAVA_HOME (brew --prefix openjdk@17)
fish_add_path $JAVA_HOME/bin

set -gx ANDROID_HOME $HOME/Library/Android/sdk
fish_add_path $ANDROID_HOME/platform-tools

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# opencode
fish_add_path $HOME/.opencode/bin

fish_add_path $HOME/.spicetify
