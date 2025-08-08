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
alias lv="nvim"
alias cd="z"
alias ps="procs"
alias du="dust"
alias top="btm"

# Initialize modern CLI tools
eval "$(zoxide init zsh)"

# GitHub CLI completion
if command -v gh &> /dev/null; then
  eval "$(gh completion -s zsh)"
fi

# Load zsh plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestion configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)