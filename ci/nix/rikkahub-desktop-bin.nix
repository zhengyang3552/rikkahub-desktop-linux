# rikkahub-desktop-bin — NixOS 二进制包 derivation
#
# 包装官方预编译 Linux tar.gz(Rikkahub_<ver>_linux_x64.tar.gz):
#   $out/opt/rikkahub-desktop/  二进制 + web-ui/build/client + fonts + icons
#   $out/bin/rikkahub-desktop   启动器,数据目录默认 ~/.local/share/rikkahub-desktop
#
# CI 用法(本地 src,见 .github/workflows/package-linux.yml):
#   nix-build -E 'let pkgs = import <nixpkgs> {};
#     in pkgs.callPackage ./ci/nix/rikkahub-desktop-bin.nix { version = "1.5.0"; src = ./Rikkahub_1.5.0_linux_x64.tar.gz; }'
#
# 从 Release 资产构建:
#   nix-build -E '(import <nixpkgs> {}).callPackage ./rikkahub-desktop-bin.nix {
#     version = "1.5.0"; sha256 = "<Rikkahub_1.5.0_linux_x64.tar.gz 的 sha256>"; }'
{ lib
, stdenvNoCC
, fetchurl
, version ? "1.5.0"
, sha256 ? lib.fakeHash
, src ? null
}:
let
  remoteSrc = fetchurl {
    url = "https://github.com/zhengyang3552/rikkahub-desktop-Linux/releases/download/v${version}/Rikkahub_${version}_linux_x64.tar.gz";
    inherit sha256;
  };
in
stdenvNoCC.mkDerivation {
  pname = "rikkahub-desktop-bin";
  inherit version;

  src = if src != null then src else remoteSrc;

  dontConfigure = true;
  dontBuild = true;
  # bun --compile 产物是"ELF 运行时 + 尾部附加 bundle"的单文件,strip 会破坏附加数据
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt/rikkahub-desktop" "$out/bin" "$out/share/applications" \
      "$out/share/icons/hicolor/192x192/apps"
    # tarball 仅含 rikkahub-pc/ 单顶层目录时,unpackPhase 会将其设为 sourceRoot
    # 并已 cd 进去;布局变化(多顶层条目)时回退当前目录
    SRC=.
    if [ -d rikkahub-pc ]; then SRC=rikkahub-pc; fi
    cp -r "$SRC/." "$out/opt/rikkahub-desktop/"

    # launcher.sh 中 /opt/rikkahub-desktop 替换为本 store 路径
    sed "s|/opt/rikkahub-desktop|$out/opt/rikkahub-desktop|g" \
      ${../linux/launcher.sh} > "$out/bin/rikkahub-desktop"
    chmod 755 "$out/bin/rikkahub-desktop"

    install -m644 ${../linux/rikkahub-desktop.desktop} \
      "$out/share/applications/rikkahub-desktop.desktop"
    install -m644 ${../../docs/icon.png} \
      "$out/share/icons/hicolor/192x192/apps/rikkahub-desktop.png"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rikkahub desktop LLM chat client (prebuilt Linux binary)";
    longDescription = ''
      Native LLM chat client with multi-provider support (OpenAI / Anthropic /
      Gemini / OpenAI-compatible endpoints), MCP tools, web search, image
      generation and local model support. Runs a local server at
      http://localhost:8080 and opens the UI in the default browser.
      Data directory: ~/.local/share/rikkahub-desktop (RIKKAHUB_PC_DATA_DIR overrides).
    '';
    homepage = "https://github.com/zhengyang3552/rikkahub-desktop-Linux";
    # 非商业 AGPL-3.0,商业使用需授权,详见 LICENSE(分段双重许可)
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "rikkahub-desktop";
  };
}
