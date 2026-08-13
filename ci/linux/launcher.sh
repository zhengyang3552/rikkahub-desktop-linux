#!/bin/sh
# Rikkahub Desktop 启动器(系统安装:deb / Arch / Nix 共用)
# 安装目录只读,数据目录默认 ~/.local/share/rikkahub-desktop,
# 可用 RIKKAHUB_PC_DATA_DIR 覆盖(foundation/paths.ts 按此环境变量落盘)。
DATA_DIR="${RIKKAHUB_PC_DATA_DIR:-$HOME/.local/share/rikkahub-desktop}"
mkdir -p "$DATA_DIR"
export RIKKAHUB_PC_DATA_DIR="$DATA_DIR"
exec /opt/rikkahub-desktop/rikkahub-pc "$@"
