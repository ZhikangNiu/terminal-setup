# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="ys"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

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

# Proxy
proxy_on() {
    export http_proxy="http://127.0.0.1:7890"
    export https_proxy="http://127.0.0.1:7890"
    export all_proxy="socks5://127.0.0.1:7890"
    export no_proxy="localhost,127.0.0.1,::1"
    echo "Proxy ON: $http_proxy"
}

proxy_off() {
    unset http_proxy https_proxy all_proxy no_proxy
    echo "Proxy OFF"
}

# Zoxide (smarter cd, replaces z plugin)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Yazi wrapper: cd to last browsed directory on exit
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}