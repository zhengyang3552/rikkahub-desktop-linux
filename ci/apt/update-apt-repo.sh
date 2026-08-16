#!/usr/bin/env bash
set -euo pipefail

# 更新 apt 源(flat 布局 + pool/ 存包,托管在 apt 分支,由 GitHub Pages 发布)。
# Packages 的 Filename 为相对路径(pool/xxx.deb),兼容所有 apt 版本。
#
# 用法: update-apt-repo.sh <deb路径>
# 在 apt 分支根目录运行,原地更新:
#   pool/  Packages / Packages.gz / Release / Release.gpg / InRelease
#
# 依赖: dpkg-deb, dpkg-scanpackages(dpkg-dev), gzip, apt-ftparchive(apt-utils), gpg
# 签名使用本机 keyring 中的第一把私钥(CI 里先导入 Actions Secret 的私钥)。

[ $# -eq 1 ] || { echo "用法: $0 <deb路径>" >&2; exit 1; }
DEB="$1"
[ -f "$DEB" ] || { echo "找不到 deb: $DEB" >&2; exit 1; }
command -v dpkg-deb           >/dev/null || { echo "缺少 dpkg-deb" >&2; exit 1; }
command -v dpkg-scanpackages  >/dev/null || { echo "缺少 dpkg-scanpackages(dpkg-dev)" >&2; exit 1; }
command -v apt-ftparchive     >/dev/null || { echo "缺少 apt-ftparchive(apt-utils)" >&2; exit 1; }

KEYID="$(gpg --list-secret-keys --with-colons 2>/dev/null | awk -F: '$1=="sec"{print $5; exit}')"
[ -n "$KEYID" ] || { echo "keyring 中没有 GPG 私钥,无法签名" >&2; exit 1; }

DEBNAME="$(basename "$DEB")"
NEWPKG="$(dpkg-deb --field "$DEB" Package)"
NEWVER="$(dpkg-deb --field "$DEB" Version)"

# 1) 放入 pool:删掉同 Package+Version 的旧包(重复发布/重传资产场景)
mkdir -p pool
for f in pool/*.deb; do
  [ -e "$f" ] || continue
  if [ "$(dpkg-deb --field "$f" Package 2>/dev/null)" = "$NEWPKG" ] && \
     [ "$(dpkg-deb --field "$f" Version 2>/dev/null)" = "$NEWVER" ]; then
    rm -f "$f"
  fi
done
cp "$DEB" "pool/$DEBNAME"

# 2) 从 pool 重建索引(Filename: pool/xxx.deb 相对路径)
dpkg-scanpackages --multiversion pool > Packages
rm -f Packages.gz
gzip -9k Packages

# 3) Release(apt-ftparchive 自动跳过 .git 等隐藏目录) + 签名
rm -f Release Release.gpg InRelease
apt-ftparchive release \
  -o APT::FTPArchive::Release::Origin="rikkahub-desktop" \
  -o APT::FTPArchive::Release::Label="rikkahub-desktop" \
  -o APT::FTPArchive::Release::Description="rikkahub-desktop Linux packages" \
  . > Release
gpg --batch --yes --local-user "$KEYID" --armor --detach-sign --output Release.gpg Release
gpg --batch --yes --local-user "$KEYID" --clearsign --output InRelease Release

echo "apt 索引已更新:"
echo "  ${NEWPKG} ${NEWVER} -> pool/${DEBNAME}"
echo "  Packages 共 $(grep -c '^Package:' Packages) 条记录"
