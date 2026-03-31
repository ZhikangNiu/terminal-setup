# Yazi 终端文件管理器 - macOS 安装与配置指南

## 1. 安装

使用 Homebrew 安装 yazi 及推荐依赖：

```bash
brew install yazi ffmpeg-full sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick-full font-symbols-only-nerd-font
brew link ffmpeg-full imagemagick-full -f --overwrite
```

各依赖用途：
- `ffmpeg-full` / `imagemagick-full` — 视频、图片预览
- `poppler` — PDF 预览
- `fd` / `ripgrep` / `fzf` — 文件搜索
- `zoxide` — 智能目录跳转
- `sevenzip` — 压缩包预览
- `jq` — JSON 预览
- `resvg` — SVG 预览
- `font-symbols-only-nerd-font` — 图标字体

## 2. 修复图标显示（iTerm2）

安装后图标可能显示为 `?`，需在 iTerm2 中配置 Nerd Font：

1. 打开 iTerm2 → **Settings**（`Cmd + ,`）
2. 进入 **Profiles** → 选择你的 Profile → **Text** 标签
3. 勾选 **Use a different font for non-ASCII text**
4. 在非 ASCII 字体中选择 **Symbols Nerd Font Mono**
5. 关闭设置即可生效

## 3. Shell Wrapper（推荐）

在 `~/.zshrc` 末尾添加以下函数，退出 yazi 时自动 cd 到最后浏览的目录：

```bash
# Yazi wrapper: cd to last browsed directory on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
```

添加后执行 `source ~/.zshrc` 或开新终端窗口生效。此后用 `y` 代替 `yazi` 启动。

## 4. 主题配置

### 安装主题

```bash
ya pkg add yazi-rs/flavors:catppuccin-mocha
```

更多主题见：https://github.com/yazi-rs/flavors

### 启用主题

编辑 `~/.config/yazi/theme.toml`：

```toml
[flavor]
dark = "catppuccin-mocha"
light = "catppuccin-mocha"
```

## 5. 快捷键速查

### 基础导航

| 操作 | 按键 |
|------|------|
| 上下移动 | `k` / `j` |
| 进入目录 / 打开文件 | `l` 或 `Enter` |
| 返回上级目录 | `h` |
| 退出 yazi | `q` |

### 文件操作

| 操作 | 按键 |
|------|------|
| 选中文件 | `Space` |
| 全选 | `Ctrl+a` |
| 复制 | `y` |
| 剪切 | `x` |
| 粘贴 | `p` |
| 删除（回收站） | `d` |
| 永久删除 | `D` |
| 重命名 | `r` |
| 新建文件 | `a`（输入文件名） |
| 新建目录 | `a`（文件名末尾加 `/`） |

### 搜索与其他

| 操作 | 按键 |
|------|------|
| 交互式过滤 | `f` |
| zoxide 跳转 | `z` |
| 跳到顶部/底部 | `gg` / `G` |
| 切换隐藏文件 | `.` |
| 打开命令行 | `:` |
| 查看所有快捷键 | `~` |

## 6. 相关文件位置

| 文件 | 路径 |
|------|------|
| 主配置 | `~/.config/yazi/yazi.toml` |
| 主题配置 | `~/.config/yazi/theme.toml` |
| 快捷键配置 | `~/.config/yazi/keymap.toml` |
| 已安装的包 | `~/.local/state/yazi/packages/` |
