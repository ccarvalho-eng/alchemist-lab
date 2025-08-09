# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Starship prompt
eval "$(starship init zsh)"

# Environment
export TERM=xterm-256color
export EDITOR=nvim

# Initialize modern CLI tools first
eval "$(zoxide init zsh)"

# Aliases
alias ls="exa --icons"
alias ll="exa -l --icons"
alias la="exa -la --icons"
alias cat="batcat"
alias find="fdfind"
alias grep="rg"
alias lv="nvim"
alias vim="nvim"
alias ps="procs"
alias du="dust"
alias top="btm"
alias lg="lazygit"
alias http="http"

# GitHub CLI completion
if command -v gh &> /dev/null; then
  eval "$(gh completion -s zsh)"
fi
