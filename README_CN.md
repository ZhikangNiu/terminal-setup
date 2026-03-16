# 终端环境配置

[English](README.md)

一条命令完成 Ubuntu/Debian 服务器的终端环境配置。

## 功能

- 安装系统包：`git`、`curl`、`wget`、`htop`、`tree`、`zsh`、`zip`
- 安装 [Oh My Zsh](https://ohmyz.sh/)，使用 `ys` 主题
- 安装插件：`zsh-autosuggestions`、`zsh-syntax-highlighting`
- 部署 `.zshrc` 和 `.vimrc` 配置文件（自动备份已有文件）
- 将 zsh 设为默认 shell
- 配置常用别名（`ll`、`la`、`gs`、`gl`、`pyd` 等）
- 设置 `HF_ENDPOINT` 为 Hugging Face 镜像站
- 部署 Claude Code 插件配置（`settings.json`，含已启用插件）

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
| Oh My Zsh | 安装 | 跳过（目录已存在） |
| 插件 | `git clone` | `git pull` |
| 配置文件 | 备份 + 复制 | 新备份 + 复制 |
| Claude Code 配置 | 创建 `~/.claude/` + 复制 | 备份 + 复制 |
| 默认 shell | 切换为 zsh | 跳过（已是 zsh） |

## tmux 复制粘贴

鼠标拖选文本 → 松开完成复制 → `Ctrl+b` 然后 `]` 粘贴

## 自定义

- **主题**：编辑 `configs/.zshrc`，修改 `ZSH_THEME`
- **插件**：编辑 `configs/.zshrc` 中的 `plugins=(...)` 行
- **Vim**：编辑 `configs/.vimrc`
- **系统包**：编辑 `setup.sh` 中的 `apt-get install` 行
- **Claude Code 插件**：编辑 `.claude/settings.json`，增减 `enabledPlugins`
