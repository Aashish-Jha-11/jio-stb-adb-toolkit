#!/usr/bin/env bash
#
# setup.sh — check prerequisites and point you to the right next step.
# Does not run any exploit; it verifies your environment and guides you.
#
# Usage:
#   ./setup.sh                 # environment check + guidance
#   ./setup.sh --ip 1.2.3.4    # also run the read-only doctor against your box
#
set -euo pipefail
IP="${2:-}"
[ "${1:-}" = "--ip" ] && IP="${2:-}"

ok()   { printf '  [ok]   %s\n' "$*"; }
miss() { printf '  [MISS] %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

echo "== Prerequisites =="
have adb     && ok "adb (platform-tools)"      || miss "adb — install Android platform-tools"
have docker  && ok "docker"                    || miss "docker — needed to run the local provisioning server"
have python3 && ok "python3"                   || miss "python3 — needed by the stage-1 proxy scripts"
have git     && ok "git"                        || miss "git"

echo
echo "== Bundled upstream code (submodules) =="
if [ -f third_party/sideload-jiostb/stage1.sh ]; then ok "sideload-jiostb present"; else
  miss "sideload-jiostb not initialized → run: git submodule update --init --recursive"; fi
if [ -f third_party/Housekeeping-PoC/stage1.sh ]; then ok "Housekeeping-PoC present"; else
  miss "Housekeeping-PoC not initialized → run: git submodule update --init --recursive"; fi

if [ -n "$IP" ]; then
  echo; echo "== Device check (read-only) =="
  bash doctor/jio-stb-doctor.sh "$IP" || true
fi

cat <<'NEXT'

== What to do next ==
1. Enable ADB (safe path):   see docs/sideload-network-adb.md
   - JMSC / JMSB  -> use third_party/sideload-jiostb (stage1.sh + pass_front)
   - JHS          -> use third_party/sideload-jiostb (run_acs.sh)
   - JMSD200Av2   -> use third_party/Housekeeping-PoC stage 1  (see docs/airfiber-jmsd200.md)
2. Block ads:                ./scripts/block-ads.sh --ip <box-ip> --dns
3. Sideload apps:            ./scripts/sideload.sh  --ip <box-ip> install app.apk
4. (Advanced, brick risk)    bootloader unlock lives in the Housekeeping-PoC submodule;
                             read docs/unlock-bootloader.md first. Not needed for ads/sideload.
NEXT
