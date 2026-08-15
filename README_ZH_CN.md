<div align="center">
  <img src="docs/icon.png" alt="App 图标" width="100" />
  <h1>Rikkahub</h1>

  Rikkahub 是一个原生 Windows 桌面 LLM 聊天客户端，支持切换不同的供应商进行聊天 🤖💬
  
  —— 同时也能在 Linux 上运行（原生二进制或 Docker）。

  依赖作者 RE 构建的 [Android 版 Rikkahub](https://github.com/rikkahub/rikkahub) 重构而成。

  [English](README.md) | [繁體中文](README_ZH_TW.md) | 简体中文
</div>

## 🚀 下载

Linux 安装包由 CI 基于同步的上游源码自动构建，发布在本仓库的
[Releases](https://github.com/zhengyang3552/rikkahub-desktop-Linux/releases) 页面（x86_64）。

**Debian / Ubuntu / Mint 用户推荐使用 apt 源**，一次配置，之后常规 `apt upgrade` 自动拿新版：

```bash
curl -fsSL https://zhengyang3552.github.io/rikkahub-desktop-linux/key.gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/rikkahub-desktop.gpg
echo "deb [signed-by=/usr/share/keyrings/rikkahub-desktop.gpg] https://zhengyang3552.github.io/rikkahub-desktop-linux/ ./" \
  | sudo tee /etc/apt/sources.list.d/rikkahub-desktop.list
sudo apt update && sudo apt install rikkahub-desktop
```

也可以直接下载单个安装包手动安装：

* Debian / Ubuntu / Mint：rikkahub-desktop_X.X.X_amd64.deb

  ```
  sudo dpkg -i rikkahub-desktop_X.X.X_amd64.deb
  ```
* Arch / Manjaro：rikkahub-desktop-X.X.X-1-x86_64.pkg.tar.zst

  ```
  sudo pacman -U rikkahub-desktop-X.X.X-1-x86_64.pkg.tar.zst
  ```
* AppImage（任意发行版）：rikkahub-desktop-X.X.X-x86_64.AppImage

  ```
  chmod +x rikkahub-desktop-X.X.X-x86_64.AppImage
  ./rikkahub-desktop-X.X.X-x86_64.AppImage
  ```
* 便携版：Rikkahub_X.X.X_linux_x64.tar.gz

  ```
  tar -xzf Rikkahub_X.X.X_linux_x64.tar.gz
  ./rikkahub-pc/rikkahub-pc
  ```
* NixOS：rikkahub-desktop-bin-X.X.X-nix（Nix closure + derivation，见包内 README）
* 源码包：rikkahub-desktop-X.X.X.tar.gz（从源码构建）

启动后 UI 服务于 http://localhost:8080 ，并自动用默认浏览器打开。
数据（会话、设置、上传文件）默认存放在 `~/.local/share/rikkahub-desktop`，
可用环境变量 `RIKKAHUB_PC_DATA_DIR` 覆盖。

无遥测、无管理员权限、无云端账号，**一切在本地完成**。

> **用 Windows？** Windows 安装包与便携版 `.zip` 请到上游
> [yuh-G/rikkahub-desktop Releases](https://github.com/yuh-G/rikkahub-desktop/releases) 下载。

## 📦 社区打包

原生包现已由本仓库 CI 官方构建（见上方 [下载](#-下载)）。社区另外维护了替代安装渠道——
**这些渠道由各自作者维护，并非本项目官方维护**：

| 发行版 | 安装方式 | 维护者 |
|---|---|---|
| NixOS / Nix | `nur.repos.af-nur.rikkahub-desktop`（从源码构建，建议使用二进制缓存 `af-nur.cachix.org`） | [@AstralFlare-owo](https://github.com/AstralFlare-owo) |

此前由 [@Noah0932](https://github.com/Noah0932) 手工构建的 `.deb` / `.pkg.tar.zst`
已由上方 CI 构建的资产接替。感谢两位补上了这些发行版的空缺。

## ✨ 功能特色

- 🎨 多套主题色（Claude / RikkaHub / Mono / 自定义） + 🌙 深色模式
- 🐧 同样支持 Linux —— 自带依赖的原生二进制，或多架构 Docker 镜像（amd64 / arm64）
- 🔄 多种供应商支持：OpenAI / Anthropic / Google Gemini + 任意 OpenAI 兼容接口
- 🦙 开箱即用的本地模型支持：通过 [Ollama](https://ollama.com/) /
  [LM Studio](https://lmstudio.ai/) /
  [llama.cpp server](https://github.com/ggerganov/llama.cpp)，
  把 OpenAI 兼容供应商指向 `http://localhost:11434/v1` 即可
- 🖼️ 多模态输入：图片、PDF、DOCX、PPTX、EPUB、纯文本
- 🛠️ MCP（Model Context Protocol）Streamable HTTP 支持
- 📝 Markdown 渲染：代码高亮、LaTeX 数学公式、表格、Mermaid 图
- 🪾 消息分支、重新生成、分支独立换模型
- 🔍 17 种联网搜索：Tavily、Exa、Brave、Perplexity、博查、智谱、秘塔、Firecrawl、Grok、
  Ollama、Jina、SearXNG、自定义 JS、…
- 🧠 助手级或全局共享的记忆工具，支持参考最近聊天 + 长时间无消息后自动注入时间提醒
- 🧩 Prompt 模板变量（模型名称、当前时间、地区、设备信息……）
- 🤖 多助手自定义：独立 System Prompt、提示词注入、世界书、快捷消息
- 🛠️ 模型精细化配置：手动添加模型，每个模型可设自定义请求头 / 请求体 / 供应商覆盖（per-model
  baseUrl + API Key）
- 🎨 图像生成：gpt-image-2、DALL·E 3、Imagen、Qwen-Image、FLUX、…
- 🎙️ TTS 与 ASR：系统语音（Windows SAPI / Linux espeak-ng）、OpenAI、Gemini、Qwen、Groq、MiniMax、MiMo
- 📥 一键导入 Android 端 .zip 备份：对话历史、设置、附件、Skills、MCP、提示词注入、世界书、快捷消息
- 📤 WebDAV 与 S3 兼容云端备份，JSON 导入导出
- 📊 请求日志与每日活动热力图统计

## 💎 赞助商

以下组织赞助了 Rikkahub 的持续开发，在此致谢。

<table>
  <tr>
    <td width="120" align="center">
      <a href="https://naapi.cc">
        <img src="icons/naapi.jpg" width="100" alt="钠API" />
      </a>
    </td>
    <td>
      <a href="https://naapi.cc"><b>钠API</b></a><br/>
      提供 ChatGPT、Claude、Gemini 等 100+ 全球顶级模型的统一接口，主打有竞争力的价格与出色的稳定性。
    </td>
  </tr>
</table>

## 🏗️ 从源码构建

本地打包安装器需要以下工具——**供开发者使用**：

- [Bun](https://bun.sh/) 1.1+
- [Rust](https://rustup.rs/) 工具链（stable，Windows 下 rustup 默认选 MSVC target）
- [Visual Studio Build Tools 2022](https://visualstudio.microsoft.com/visual-cpp-build-tools/) +
  **"使用 C++ 的桌面开发"** 工作负载（提供 MSVC linker 和 Windows SDK）

```powershell
# 1. 编译嵌入的后端服务（Bun --compile → 单文件 Windows exe）
cd pc-server
bun run compile

# 2. 把刚编出的 sidecar 拷到 Tauri 指定位置
cp ../dist/rikkahub-pc.exe ../web-ui/src-tauri/binaries/rikkahub-server-x86_64-pc-windows-msvc.exe

# 3. 一并构建前端、Tauri 壳和 NSIS 安装包
cd ../web-ui
bun install
./src-tauri/tauri-msvc.cmd build --bundles nsis
```

最终安装包在 `dist/Rikkahub_X.X.X_x64-setup.exe`。包装脚本 `tauri-msvc.cmd` 在调用 cargo 前
激活 MSVC 环境、并把 `CARGO_TARGET_DIR` 设到 ASCII 路径，用来绕开两个 Windows 开发坑：
Git Bash 的 `link.exe` 跟 MSVC 链接器冲突，以及项目路径含非 ASCII 字符导致 build 失败。

### 开发流程

```powershell
# 后端在 http://localhost:8080
cd pc-server
bun run server.ts

# 前端 Vite dev server 在 http://localhost:5173（自动把 /api 代理到 :8080）
cd ../web-ui
bun run dev
```

只调前端时直接浏览器打开 `http://localhost:5173` 即可——自定义标题栏在非 Tauri 环境下会
自动隐藏，整套 UI 在浏览器里也能用。

### 烟雾测试

```powershell
cd pc-server
bun run smoke:request-chain
```

会拉起 mock 供应商 / MCP / WebDAV / S3 服务，跑一遍完整的请求链路。

### 🐧 Linux 二进制

编译一个自带依赖的 Linux x64 原生二进制（只需要 [Bun](https://bun.sh/)）：

```bash
# 1. 构建前端 SPA
cd web-ui && bun install && bun run build

# 2. 编译后端二进制
cd ../pc-server && bun run compile:linux
# → dist/rikkahub-pc
```

运行：

```bash
./dist/rikkahub-pc
# 浏览器打开 http://localhost:8080
# 数据保存在 ./pc-data/
```

**需要的系统包** —— 用到对应功能前安装即可：

| 系统包 | 对应功能 |
|---|---|
| `espeak-ng` | 系统语音播报（TTS 工具、语音播放） |
| `xclip`（X11）或 `wl-clipboard`（Wayland） | 剪贴板读写工具 |
| `unzip`、`zip` | 备份恢复 / 从 ZIP 导入 Skill |

Debian/Ubuntu：`sudo apt install espeak-ng xclip unzip zip`  
Fedora/RHEL：`sudo dnf install espeak-ng xclip unzip zip`

缺失的工具会在启动时被检测并以警告列出——服务照常启动，其它功能不受影响。

### Docker

用项目自带的 `Dockerfile` 可以构建多架构镜像：

```bash
docker build -t rikkahub-pc .
```

带持久化数据运行：

```bash
docker run -d \
  --name rikkahub \
  -p 8080:8080 \
  -v ./pc-data:/app/pc-data \
  rikkahub-pc
```

然后浏览器打开 `http://localhost:8080`。镜像基于 `distroless/base-debian12`，已内置
`unzip`/`zip`；剪贴板和 TTS 在无头容器内不可用。

**局域网 / 公网部署安全注记:** AI 的 `scrape_web` 工具会在容器内直接抓取模型给出的
任意 URL——被注入提示词的网页可能诱导模型去探测内网服务或云元数据地址(SSRF)。若你的
网络环境在意这一点,请隔离容器网络或限制其出站流量。

### 反向代理(nginx)

把 RikkaHub 放到反向代理后面(比如加 HTTPS)时,有两个关键点:

- **Host 透传** —— 服务端会拒绝 `Origin` 与请求 `Host` 不一致的写请求(CSRF 防护)。
  默认的 `proxy_pass` 会把 `Host` 改写成上游地址,导致所有 POST/DELETE 一律 403,
  表现为"网页打得开但什么都保存不了"。用 `proxy_set_header Host $host` 透传原始 Host。
- **流式输出** —— SSE 响应已带 `X-Accel-Buffering: no`,nginx 会据此自动关闭响应缓冲;
  `proxy_buffering off` 只是给不认这个头的代理兜底。

```nginx
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen 443 ssl;
    server_name rikka.example.com;
    # ssl_certificate ...; ssl_certificate_key ...;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;              # 保住 Origin/Host CSRF 校验
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;   # WebSocket(语音输入)
        proxy_set_header Connection $connection_upgrade;
        proxy_buffering off;                      # 兜底;SSE 已发 X-Accel-Buffering: no
        proxy_read_timeout 1h;                    # 长连接 SSE / 生成流
        client_max_body_size 0;                   # 备份恢复上传可达数百 MB
    }
}
```

只要代理让服务可以从本机之外访问,务必设置 `RIKKAHUB_PASSWORD`。

## 🧰 技术栈

- [Bun](https://bun.sh/) —— 运行时、打包器、包管理器
- [Tauri v2](https://tauri.app/) + Rust —— 桌面壳（原生窗口、NSIS 安装器、sidecar 生命周期、
  Job Object 绑定保证父进程异常退出时子进程也一并清理）
- [TypeScript](https://www.typescriptlang.org/) —— 严格类型，前后端一致
- [React 19](https://react.dev/) + [React Router 7](https://reactrouter.com/) —— SPA（纯客户端模式）
- [Tailwind CSS v4](https://tailwindcss.com/) + [shadcn/ui](https://ui.shadcn.com/) —— 样式与组件
- [Zustand](https://zustand-demo.pmnd.rs/) —— 状态管理
- [ky](https://github.com/sindresorhus/ky) —— HTTP 客户端
- [Lucide](https://lucide.dev/) —— 图标集
- [i18next](https://www.i18next.com/) —— 国际化（zh-CN / en-US）

## 🙏 致谢

本项目是基于 [@re-ovo](https://github.com/re-ovo) 的
[RikkaHub](https://github.com/rikkahub/rikkahub) 产品设计、品牌与理念在 Windows 平台上的
移植版。

## ⭐ Star History

如果 Rikkahub 对你有帮助，欢迎点个 Star ⭐

[![Star History Chart](https://api.star-history.com/svg?repos=yuh-G/rikkahub-pc&type=Date)](https://star-history.com/#yuh-G/rikkahub-desktop&Date)

## 📄 许可证

[License](LICENSE)
