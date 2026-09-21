#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

if [[ $EUID -ne 0 ]]; then
  echo "[!] Please run as root: sudo ./run.sh"
  exit 1
fi

python3 "${SCRIPT_DIR}/tor_location_manager.py"
