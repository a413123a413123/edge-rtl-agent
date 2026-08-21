#!/bin/bash
# =========================================================================
# setup.sh — WSL2 Ubuntu 環境重現腳本(edge-rtl-agent)
# =========================================================================
# 在全新的 WSL2 Ubuntu(24.04+/26.04)上重建本專案的完整工具鏈。
# 只有 apt 與 docker 安裝需要 sudo;其餘全部使用者空間。
# 執行:bash env/setup.sh
# =========================================================================
set -euo pipefail

echo "=== [1/5] 系統套件(需要 sudo)==="
sudo apt-get update
sudo apt-get install -y build-essential python3 python3-venv python3-pip python3-tk curl make git

echo "=== [2/5] Docker CE(需要 sudo;裝完建議重開 WSL 讓群組生效)==="
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker "$USER"
  sudo systemctl enable --now docker
else
  echo "docker 已存在,跳過"
fi

echo "=== [3/5] LibreLane(venv,使用者空間)==="
python3 -m venv "$HOME/.venvs/librelane"
"$HOME/.venvs/librelane/bin/pip" install --quiet --upgrade pip
"$HOME/.venvs/librelane/bin/pip" install --quiet librelane
"$HOME/.venvs/librelane/bin/librelane" --version

echo "=== [4/5] LibreLane smoke test(拉容器與 sky130 PDK,約數 GB)==="
# 注意:非互動環境需 script 包偽終端;成功判準是輸出含「Smoke test passed.」
script -qec "$HOME/.venvs/librelane/bin/librelane --dockerized --smoke-test" /dev/null \
  | tail -5 | grep -q "Smoke test passed" && echo "SMOKE TEST OK" || {
    echo "SMOKE TEST 未確認,請檢查上方輸出"; exit 1; }

echo "=== [5/5] VerilogEval v2 題庫 ==="
if [ ! -d "$HOME/verilog-eval" ]; then
  git clone --depth 1 https://github.com/NVlabs/verilog-eval "$HOME/verilog-eval"
else
  echo "verilog-eval 已存在,跳過"
fi

echo ""
echo "完成。另需在 Windows 側:安裝 Ollama 並 pull qwen2.5-coder:3b / 7b。"
echo "評測範例:"
echo "  docker run --rm -v \$HOME:\$HOME -w \$HOME/edge-rtl-agent ghcr.io/librelane/librelane:3.0.10 \\"
echo "    python3 harness/evaluate.py --completions results/completions_3b \\"
echo "    --dataset \$HOME/verilog-eval/dataset_spec-to-rtl --out results/baseline_3b.json"
