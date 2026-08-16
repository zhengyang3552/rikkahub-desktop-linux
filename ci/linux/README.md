# Linux 打包(CI)

`Package Linux` 工作流(`.github/workflows/package-linux.yml`)在仓库从上游同步
(push 到 main)后自动编译并产出全部 Linux 发行版格式,也可在 Actions 页手动触发。

## 产物(均 x86_64 / amd64)

| 格式 | 文件名 | 安装方式 |
|---|---|---|
| 便携 tar.gz | `Rikkahub_<ver>_linux_x64.tar.gz` | 解压后 `./rikkahub-pc/rikkahub-pc`(应用内更新按此命名匹配) |
| Debian/Ubuntu | `rikkahub-desktop_<ver>_amd64.deb` | `sudo apt install ./rikkahub-desktop_<ver>_amd64.deb` |
| Arch/Manjaro | `rikkahub-desktop-<ver>-1-x86_64.pkg.tar.zst` | `sudo pacman -U rikkahub-desktop-<ver>-1-x86_64.pkg.tar.zst` |
| AppImage | `rikkahub-desktop-<ver>-x86_64.AppImage` | `chmod +x` 后直接运行 |
| NixOS 二进制包 | `rikkahub-desktop-bin-<ver>-nix/`(closure 导出 + derivation) | 见产物内 README.md |
| 源码包 | `rikkahub-desktop-<ver>.tar.gz` | `git archive` 生成,仅含被跟踪文件 |

## 布局约定

系统包装(deb / Arch / Nix)统一安装到 `/opt/rikkahub-desktop/`(Nix 为
`$out/opt/rikkahub-desktop/`),内容 = `rikkahub-pc` 二进制 + `web-ui/build/client`
+ `fonts/` + `icons/`。二进制必须与 `web-ui/` 同目录——`pc-server/foundation/paths.ts`
按 "exe 同目录存在 web-ui/" 定位静态资源。

命令统一为 `rikkahub-desktop`(`ci/linux/launcher.sh` 生成)。
安装目录只读,因此数据目录(会话、设置、上传文件、API Key)默认落到
`~/.local/share/rikkahub-desktop`,由启动器设置 `RIKKAHUB_PC_DATA_DIR`
(该环境变量为 `foundation/paths.ts` 的官方覆盖入口),用户可自行改指。

AppImage 为只读 squashfs,同理把数据落用户目录;`AppRun` 由
`ci/linux/appimage-apprun.sh` 生成。

## apt 源（Debian / Ubuntu 自动升级）

正式 Release 发布后，`package-linux.yml` 的 `apt` job 自动更新 `apt` 分支的源：
`pool/` 存各版本 deb，分支根目录是 flat 索引（`Packages` / `Release` / `InRelease`），
由 GitHub Pages 托管。`Packages` 的 `Filename` 为相对路径 `pool/xxx.deb`，
兼容所有 apt 版本。索引签名用专用 GPG 密钥（私钥存 Actions Secret
`APT_GPG_PRIVATE_KEY`，公钥为 apt 分支根目录 `key.gpg`）。
索引生成逻辑在 `ci/apt/update-apt-repo.sh`（在 main 上，CI job 取用）。

## 文件

- `rikkahub-desktop.desktop` — freedesktop 菜单项(启动后打开浏览器访问 localhost:8080)
- `launcher.sh` — 系统安装启动器(Nix derivation 会 sed 替换安装路径)
- `appimage-apprun.sh` — AppImage AppRun

hicolor 图标在 CI 中由 `docs/icon.png` 现场缩放生成(32/48/64/128/256)。
