#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: run_baseline.sh <problem_path> <output_dir>" >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_PATH="${RTL_AGENT_CONFIG:-${SCRIPT_DIR}/config/experiment.example.json}"
cd "${SCRIPT_DIR}"
exec python -m baseline.cli run --problem "$1" --config "${CONFIG_PATH}" --output "$2"
