#!/usr/bin/env bash
set -Eeuo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TORDIR="/etc/tor"
TORRC_DIR="${TORDIR}/torrc.d"

echo "[*] Installing dependencies..."

if ! command -v python3 >/dev/null 2>&1; then
  echo "[!] python3 not found. Install it first."
  exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "[!] This installer expects apt-get (Kali/Debian)."
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "[!] Please run as root: sudo bash install.sh"
  exit 1
fi

apt-get update
apt-get install -y tor python3 python3-pip python3-venv curl

python3 -m pip install --upgrade pip
python3 -m pip install -r "${APP_DIR}/requirements.txt"

mkdir -p "${TORRC_DIR}"
chmod 755 "${TORRC_DIR}"

if [[ -f "${APP_DIR}/torrc.d/tor_location_manager.conf" ]]; then
  cp "${APP_DIR}/torrc.d/tor_location_manager.conf" "${TORRC_DIR}/tor_location_manager.conf"
  chmod 644 "${TORRC_DIR}/tor_location_manager.conf"
fi

if ! grep -q 'torrc.d' /etc/tor/torrc 2>/dev/null; then
  echo 'Include /etc/tor/torrc.d/*.conf' >> /etc/tor/torrc
fi

systemctl enable tor 2>/dev/null || true
systemctl restart tor 2>/dev/null || true

echo
echo "[+] Installation complete."
echo "[+] Run: sudo ./run.sh"
echo "[+] Or: sudo python3 tor_location_manager.py"
