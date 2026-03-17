# Terminal Setup

[中文版](README_CN.md)

One-command terminal environment setup for Ubuntu/Debian servers.

## What It Does

- Installs system packages: `git`, `curl`, `wget`, `htop`, `tree`, `zsh`, `zip`, `jq`, `aria2`
- Installs [Oh My Zsh](https://ohmyz.sh/) with the `ys` theme
- Installs plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`
- Deploys `.zshrc` and `.vimrc` configs (backs up existing files)
- Sets zsh as the default shell
- Configures useful aliases (`ll`, `la`, `gs`, `gl`, `pyd`, etc.)
- Sets `HF_ENDPOINT` to the Hugging Face mirror
## Usage

```bash
git clone <this-repo> ~/terminal_setup
cd ~/terminal_setup
bash setup.sh
```

One-liner (after cloning):

```bash
bash ~/terminal_setup/setup.sh
```

## Re-running

The script is fully idempotent — safe to run multiple times:

| Step | First run | Re-run |
|------|-----------|--------|
| System packages | Installs | Skips already-installed |
| Oh My Zsh | Installs | Skips (directory exists) |
| Plugins | `git clone` | `git pull` |
| Config files | Backup + copy | New backup + copy |
| Default shell | Changes to zsh | Skips (already zsh) |

## Claude Code Setup (Manual)

The repo includes Claude Code config under `.claude/`. Copy them manually after cloning:

```bash
mkdir -p ~/.claude
cp ~/terminal_setup/.claude/settings.json ~/.claude/
cp ~/terminal_setup/.claude/statusline.sh ~/.claude/
```

## tmux Copy & Paste

Mouse drag to select → release to copy → `Ctrl+b` then `]` to paste

## Customization

- **Theme**: Edit `configs/.zshrc` and change `ZSH_THEME`
- **Plugins**: Edit the `plugins=(...)` line in `configs/.zshrc`
- **Vim**: Edit `configs/.vimrc`
- **Packages**: Edit the `apt-get install` line in `setup.sh`
- **Claude Code plugins**: Edit `.claude/settings.json` to add/remove `enabledPlugins`
- **Claude Code status line**: Edit `.claude/statusline.sh`
