#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MODE=""
for arg in "$@"; do
    case "$arg" in
        --cache)   MODE="cache" ;;
        --offline) MODE="offline" ;;
    esac
done

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
    $SUDO -v || { echo "sudo access is required." >&2; exit 1; }
fi

# --cache mode: download assets to cache/ and exit
if [ "$MODE" = "cache" ]; then
    CACHE_DIR="$SCRIPT_DIR/cache"
    mkdir -p "$CACHE_DIR"
    for repo in ohmyzsh/ohmyzsh zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting; do
        name="${repo##*/}"
        dest="$CACHE_DIR/$name"
        if [ -d "$dest" ]; then
            echo "Updating $name..."
            git -C "$dest" pull --quiet
        else
            echo "Cloning $name..."
            git clone --quiet "https://github.com/$repo.git" "$dest"
        fi
    done
    # Cache yazi binary
    ARCH="$(uname -m)"
    [ "$ARCH" = "arm64" ] && ARCH="aarch64"
    echo "Downloading yazi for $ARCH..."
    curl -fsSL "https://github.com/sxyazi/yazi/releases/latest/download/yazi-${ARCH}-unknown-linux-musl.zip" \
        -o "$CACHE_DIR/yazi.zip"
    # Cache zoxide binary
    echo "Downloading zoxide for $ARCH..."
    ZOXIDE_TMP="$(mktemp -d)"
    ZOXIDE_URL="$(curl -sSf https://api.github.com/repos/ajeetdsouza/zoxide/releases/latest \
        | jq -r ".assets[] | select(.name | test(\"zoxide-.*-${ARCH}-unknown-linux-musl.tar.gz\")) | .browser_download_url")"
    curl -fsSL "$ZOXIDE_URL" -o "$ZOXIDE_TMP/zoxide.tar.gz"
    tar -xzf "$ZOXIDE_TMP/zoxide.tar.gz" -C "$ZOXIDE_TMP"
    cp "$ZOXIDE_TMP/zoxide" "$CACHE_DIR/zoxide"
    rm -rf "$ZOXIDE_TMP"
    echo "Cache ready at $CACHE_DIR"
    exit 0
fi

# --offline pre-check: cache/ must exist
if [ "$MODE" = "offline" ]; then
    CACHE_DIR="$SCRIPT_DIR/cache"
    for name in ohmyzsh zsh-autosuggestions zsh-syntax-highlighting; do
        if [ ! -d "$CACHE_DIR/$name" ]; then
            echo "Missing $CACHE_DIR/$name — run './setup.sh --cache' on an online machine first." >&2
            exit 1
        fi
    done
    for file in yazi.zip zoxide; do
        if [ ! -f "$CACHE_DIR/$file" ]; then
            echo "Missing $CACHE_DIR/$file — run './setup.sh --cache' on an online machine first." >&2
            exit 1
        fi
    done
fi

backup_file() {
    local target="$1"
    if [ -f "$target" ]; then
        local bak="${target}.bak.$(date +%Y%m%d-%H%M%S)"
        cp "$target" "$bak"
        echo "Backed up $target -> $bak"
    fi
}

# Pre-flight checks
if [ "$MODE" != "offline" ]; then
    if [ ! -f /etc/debian_version ] && ! command -v apt-get &>/dev/null; then
        echo "This script requires a Debian/Ubuntu system with apt-get." >&2; exit 1
    fi
fi

# System packages
if [ "$MODE" != "offline" ]; then
    $SUDO apt-get update -y
    $SUDO apt-get install -y git curl wget htop tree zsh zip jq aria2 \
        fd-find ripgrep fzf poppler-utils ffmpeg imagemagick p7zip-full file unzip
    echo "System packages installed."
else
    echo "Offline mode: skipping apt-get (assuming packages already installed)."
fi

# Yazi terminal file manager
mkdir -p "$HOME/.local/bin"
if ! command -v yazi &>/dev/null; then
    echo "Installing yazi..."
    ARCH="$(uname -m)"
    [ "$ARCH" = "arm64" ] && ARCH="aarch64"
    YAZI_TMP="$(mktemp -d)"
    if [ "$MODE" = "offline" ]; then
        unzip -qo "$SCRIPT_DIR/cache/yazi.zip" -d "$YAZI_TMP"
    else
        curl -fsSL "https://github.com/sxyazi/yazi/releases/latest/download/yazi-${ARCH}-unknown-linux-musl.zip" \
            -o "$YAZI_TMP/yazi.zip"
        unzip -qo "$YAZI_TMP/yazi.zip" -d "$YAZI_TMP"
    fi
    cp "$YAZI_TMP"/yazi-*/yazi "$HOME/.local/bin/yazi"
    cp "$YAZI_TMP"/yazi-*/ya "$HOME/.local/bin/ya"
    chmod +x "$HOME/.local/bin/yazi" "$HOME/.local/bin/ya"
    rm -rf "$YAZI_TMP"
    echo "Yazi installed."
else
    echo "Yazi already installed, skipping."
fi

# fd symlink (Debian installs fd-find as fdfind)
if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    echo "Created fd symlink for fdfind."
fi

# Zoxide
if ! command -v zoxide &>/dev/null; then
    echo "Installing zoxide..."
    if [ "$MODE" = "offline" ]; then
        cp "$SCRIPT_DIR/cache/zoxide" "$HOME/.local/bin/zoxide"
        chmod +x "$HOME/.local/bin/zoxide"
    else
        ARCH="$(uname -m)"
        [ "$ARCH" = "arm64" ] && ARCH="aarch64"
        ZOXIDE_TMP="$(mktemp -d)"
        ZOXIDE_TAG="$(curl -sSf -H 'Accept: application/json' https://github.com/ajeetdsouza/zoxide/releases/latest | sed 's/.*"tag_name":"\([^"]*\)".*/\1/')"
        if [ -z "$ZOXIDE_TAG" ]; then
            echo "Warning: failed to detect latest zoxide version, using v0.9.6" >&2
            ZOXIDE_TAG="v0.9.6"
        fi
        curl -fsSL "https://github.com/ajeetdsouza/zoxide/releases/download/${ZOXIDE_TAG}/zoxide-${ZOXIDE_TAG#v}-${ARCH}-unknown-linux-musl.tar.gz" \
            -o "$ZOXIDE_TMP/zoxide.tar.gz"
        tar -xzf "$ZOXIDE_TMP/zoxide.tar.gz" -C "$ZOXIDE_TMP"
        cp "$ZOXIDE_TMP/zoxide" "$HOME/.local/bin/zoxide"
        chmod +x "$HOME/.local/bin/zoxide"
        rm -rf "$ZOXIDE_TMP"
    fi
    echo "Zoxide installed."
else
    echo "Zoxide already installed, skipping."
fi

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    if [ "$MODE" = "offline" ]; then
        cp -r "$SCRIPT_DIR/cache/ohmyzsh" "$HOME/.oh-my-zsh"
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    echo "Oh My Zsh installed."
fi

# Plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    plugin_dir="$ZSH_CUSTOM/plugins/$plugin"
    if [ -d "$plugin_dir" ]; then
        if [ "$MODE" != "offline" ]; then
            git -C "$plugin_dir" pull --quiet
        fi
    else
        if [ "$MODE" = "offline" ]; then
            cp -r "$SCRIPT_DIR/cache/$plugin" "$plugin_dir"
        else
            git clone --quiet "https://github.com/zsh-users/$plugin.git" "$plugin_dir"
        fi
    fi
done
echo "Plugins ready."

# Config files
backup_file "$HOME/.vimrc"
cp "$SCRIPT_DIR/configs/.vimrc" "$HOME/.vimrc"
backup_file "$HOME/.zshrc"
cp "$SCRIPT_DIR/configs/.zshrc" "$HOME/.zshrc"
backup_file "$HOME/.tmux.conf"
cp "$SCRIPT_DIR/configs/.tmux.conf" "$HOME/.tmux.conf"
echo "Config files deployed."
tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true

# Default shell
CURRENT_USER="${USER:-$(whoami)}"
current_shell="$(getent passwd "$CURRENT_USER" | cut -d: -f7)"
zsh_path="$(which zsh)"
if [ "$current_shell" != "$zsh_path" ]; then
    $SUDO chsh -s "$zsh_path" "$CURRENT_USER"
    echo "Default shell changed to zsh."
fi

echo ""
echo "Setup complete! Run 'exec zsh' or re-login to start."
