#!/usr/bin/env bash
#
# jio-stb-doctor — read-only diagnostic for Jio set-top boxes.
# It ONLY reads device properties over an existing ADB connection and tells you
# which documented path applies. It does NOT modify, exploit, or unlock anything.
#
# Usage:
#   ./jio-stb-doctor.sh                 # uses current `adb` connection
#   ./jio-stb-doctor.sh 192.168.1.50    # adb connect <ip>:5555 first
#
set -euo pipefail

IP="${1:-}"

note() { printf '%s\n' "$*"; }
rule() { printf -- '--------------------------------------------------\n'; }

if ! command -v adb >/dev/null 2>&1; then
  note "ERROR: 'adb' not found. Install Android platform-tools and retry."
  exit 1
fi

if [ -n "$IP" ]; then
  note ">> adb connect ${IP}:5555"
  adb connect "${IP}:5555" >/dev/null 2>&1 || true
fi

if ! adb get-state >/dev/null 2>&1; then
  note "No ADB device connected."
  note "Get ADB first (safe path): docs/sideload-network-adb.md"
  exit 1
fi

getp() { adb shell getprop "$1" 2>/dev/null | tr -d '\r'; }

MODEL="$(getp ro.product.model)"
DEVICE="$(getp ro.product.device)"
RELEASE="$(getp ro.build.version.release)"
PATCH="$(getp ro.build.version.security_patch)"
BUILD="$(getp ro.build.display.id)"

rule
note "Jio STB Doctor — read-only report"
rule
note "Model            : ${MODEL:-unknown}"
note "Device/codename  : ${DEVICE:-unknown}"
note "Android release  : ${RELEASE:-unknown}"
note "Build            : ${BUILD:-unknown}"
note "Security patch   : ${PATCH:-unknown}"
rule

# --- Which sideload path applies? ---
case "$MODEL" in
  *JMSC200A*|*JMSB200A*)
    note "Sideload/ADB : SUPPORTED (public method). See docs/sideload-network-adb.md" ;;
  *JHSC200*|*JHS*)
    note "Sideload/ADB : SUPPORTED (JHS variant — different cert/proxy step)." ;;
  *JMSD200A*)
    note "Sideload/ADB : REPORTED WORKING on D200 via stage 1 (unverified)."
    note "               Start here: docs/airfiber-jmsd200.md" ;;
  *)
    note "Sideload/ADB : UNKNOWN model — check docs/compatibility.md and please report it." ;;
esac

# --- Unlock window check (lexical ISO-date compare; CVE fixed June 2024) ---
if [ -n "${PATCH:-}" ] && [ "$PATCH" != "unknown" ]; then
  if [[ "$PATCH" < "2024-06-01" ]]; then
    note "Unlock window: patch ${PATCH} is BEFORE Jun-2024 (upstream tooling *may* apply)."
  else
    note "Unlock window: patch ${PATCH} is Jun-2024 or later (unlock path likely CLOSED)."
  fi
fi

rule
note "Reminder: you do NOT need the unlock to sideload apps or block ads."
note "Ad-blocking guide: docs/block-ads.md"
rule
