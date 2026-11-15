#!/bin/bash
# 小德 · 新设备一键复活入口（零依赖：只需要 curl + 浏览器登录 GitHub）
#
# 用法（新 Mac 终端直接粘）:
#   curl -fsSL https://raw.githubusercontent.com/hk-hue70/door/main/xiaode-bootstrap.sh | bash
#
# 流程: ①网络探测(不通则提示开手机热点/梯子) ②装 gh ③设备码登录(唯一人工步)
#       ④clone devin-env(私有仓) ⑤跑仓内 bootstrap.sh→install.sh 全量装机
set -e
export PATH="$HOME/.local/bin:$PATH"
echo "==> 小德 · 新设备复活 (⌐■_■)"

# 1) 网络探测：GitHub 不通先提示（大陆常见：开手机热点共享梯子）
echo "[1/4] 网络探测…"
if ! curl -fsSL -m 10 -o /dev/null https://api.github.com 2>/dev/null; then
  echo "  ✗ GitHub 不可达。"
  echo "    请先用以下任一种方式通网再重跑："
  echo "    - 手机开热点给本机（手机上有梯子即可共享）"
  echo "    - 本机先开任意代理"
  exit 1
fi
echo "  GitHub 可达"

# 2) gh（缺失则装官方 tarball，不走 brew）
if ! command -v gh >/dev/null 2>&1; then
  echo "[2/4] 安装 gh…"
  mkdir -p ~/.local/bin
  OS=$(uname -s); ARCH=$(uname -m)
  case "$OS:$ARCH" in
    Darwin:arm64)   PLAT=macOS_arm64 ;;
    Darwin:x86_64)  PLAT=macOS_amd64 ;;
    Linux:aarch64)  PLAT=linux_arm64 ;;
    *)              PLAT=linux_amd64 ;;
  esac
  GV=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest \
        | python3 -c 'import json,sys;print(json.load(sys.stdin)["tag_name"].lstrip("v"))')
  curl -fsSL -o /tmp/gh.tgz "https://github.com/cli/cli/releases/download/v$GV/gh_${GV}_${PLAT}.tar.gz"
  tar xzf /tmp/gh.tgz -C /tmp
  cp "/tmp/gh_${GV}_${PLAT}/bin/gh" ~/.local/bin/gh
fi
echo "  gh: $(gh --version | head -1)"

# 3) GitHub 设备码登录（唯一人工步：手机/浏览器开 github.com/login/device）
if ! gh auth status >/dev/null 2>&1; then
  echo "[3/4] GitHub 登录 — 跟着设备码走（浏览器点一下即可）"
  gh auth login --hostname github.com --git-protocol https --web
fi
gh auth status

# 4) 拉 devin-env → 仓内 bootstrap.sh 接管全量装机
echo "[4/4] 拉取系统镜像仓 devin-env…"
R="$HOME/devin/devin-env"
if [ -d "$R/.git" ]; then
  git -C "$R" pull --ff-only || true
else
  mkdir -p "$HOME/devin"
  gh repo clone hk-hue70/devin-env "$R"
fi
exec bash "$R/bootstrap.sh"
