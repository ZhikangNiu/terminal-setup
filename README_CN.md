# 终端环境配置

[English](README.md)

一条命令完成 Ubuntu/Debian 服务器的终端环境配置。

## 功能

- 安装系统包：`git`、`curl`、`wget`、`htop`、`tree`、`zsh`、`zip`、`jq`、`aria2`、`fd-find`、`ripgrep`、`fzf`、`ffmpeg`、`imagemagick`、`poppler-utils`、`p7zip-full` 等
- 安装 [Oh My Zsh](https://ohmyz.sh/)，使用 `ys` 主题
- 安装插件：`zsh-autosuggestions`、`zsh-syntax-highlighting`
- 安装 [Yazi](https://yazi-rs.github.io/) 终端文件管理器（从 GitHub releases 下载预编译二进制）
- 安装 [Zoxide](https://github.com/ajeetdsouza/zoxide) 智能目录跳转（替代 Oh My Zsh 的 `z` 插件）
- 部署 `.zshrc`、`.vimrc` 和 `.tmux.conf` 配置文件（自动备份已有文件）
- 将 zsh 设为默认 shell
- 配置常用别名（`ll`、`la`、`gs`、`gl`、`pyd`、`y` 等）
- 提供 `proxy_on` / `proxy_off` 代理管理函数
- 设置 `HF_ENDPOINT` 为 Hugging Face 镜像站

## 使用方法

```bash
git clone <this-repo> ~/terminal_setup
cd ~/terminal_setup
bash setup.sh
```

一键运行（克隆后）：

```bash
bash ~/terminal_setup/setup.sh
```

## 重复运行

脚本完全幂等，可安全多次运行：

| 步骤 | 首次运行 | 再次运行 |
|------|---------|---------|
| 系统包 | 安装 | 跳过已安装的 |
| Yazi | 下载二进制 | 跳过（已在 PATH 中） |
| Zoxide | 安装 | 跳过（已在 PATH 中） |
| Oh My Zsh | 安装 | 跳过（目录已存在） |
| 插件 | `git clone` | `git pull` |
| 配置文件 | 备份 + 复制 | 新备份 + 复制 |
| 默认 shell | 切换为 zsh | 跳过（已是 zsh） |

## Claude Code 配置（手动）

仓库包含 Claude Code 配置文件（`.claude/` 目录），克隆后手动复制：

```bash
mkdir -p ~/.claude
cp ~/terminal_setup/.claude/settings.json ~/.claude/
cp ~/terminal_setup/.claude/statusline.sh ~/.claude/
```

## tmux 复制粘贴

鼠标拖选文本 → 松开完成复制 → `Ctrl+b` 然后 `]` 粘贴

## 自定义

- **主题**：编辑 `configs/.zshrc`，修改 `ZSH_THEME`
- **插件**：编辑 `configs/.zshrc` 中的 `plugins=(...)` 行
- **Vim**：编辑 `configs/.vimrc`
- **系统包**：编辑 `setup.sh` 中的 `apt-get install` 行
- **Claude Code 插件**：编辑 `.claude/settings.json`，增减 `enabledPlugins`
- **Claude Code 状态栏**：编辑 `.claude/statusline.sh`
