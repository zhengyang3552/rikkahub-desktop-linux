#!/bin/sh
# AppImage 入口 AppRun:rikkahub-pc 二进制与 web-ui/ 平铺在 AppDir 根(与 AppRun 同层),
# foundation/paths.ts 依赖 "exe 同目录存在 web-ui/" 来定位静态资源。
# AppImage 挂载为只读 squashfs,数据目录必须落到用户目录。
HERE="$(dirname "$(readlink -f "$0")")"
DATA_DIR="${RIKKAHUB_PC_DATA_DIR:-$HOME/.local/share/rikkahub-desktop}"
mkdir -p "$DATA_DIR"
export RIKKAHUB_PC_DATA_DIR="$DATA_DIR"
exec "$HERE/rikkahub-pc" "$@"
