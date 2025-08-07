# Starship prompt
eval "$(starship init zsh)"

# Environment
export TERM=xterm-256color
export EDITOR=nvim

# Aliases
alias ls="exa --icons"
alias ll="exa -l --icons"
alias la="exa -la --icons"
alias cat="bat"
alias find="fd"
alias grep="rg"