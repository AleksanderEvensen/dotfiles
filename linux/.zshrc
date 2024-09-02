# Add zoxide aliases
eval "$(zoxide init zsh)"
# Starship prompt
eval "$(starship init zsh)"

# Aliases
alias cls="clear"
alias ..="cd .."
alias ls="eza --icons --group-directories-first --time-style=\"+%d.%m.%Y %H:%M\""