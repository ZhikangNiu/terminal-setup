# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="ys"

# Plugins
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Aliases
alias ll='ls -lh'
alias la='ls -lAh'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status'
alias gl='git log --oneline -20'
alias pyd='python -m debugpy --wait-for-client --listen 5678'
alias pkf='pkill -f'
alias psg='ps aux | grep -v grep | grep'
alias tn='tmux new -s'

# export
export HF_ENDPOINT="https://hf-mirror.com"
export PATH="$HOME/.local/bin:$PATH"