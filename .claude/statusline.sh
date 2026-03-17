#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# User and host
user=$(whoami)

# Directory: replace $HOME with ~
home="$HOME"
display_dir="${cwd/#$home/~}"

# Git branch and status
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ]; then
    git_state="x"
    git_color="\033[0;31m"
  else
    git_state="o"
    git_color="\033[0;32m"
  fi
  git_info=" on \033[0;34mgit\033[0;36m:${branch}${git_color} ${git_state}\033[0m"
fi

# Context usage
ctx_info=""
if [ -n "$used" ]; then
  ctx_info=" ctx:${used}%"
fi

# Time
time_str=$(date +%H:%M:%S)

printf "\033[1;34m#\033[0m \033[0;36m%s\033[0m in \033[1;33m%s\033[0m%b [\033[0m%s\033[0m] \033[0;35m%s\033[0m%s" \
  "$user" "$display_dir" "$git_info" "$time_str" "$model" "$ctx_info"
