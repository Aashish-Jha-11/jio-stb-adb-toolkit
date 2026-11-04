#!/usr/bin/env bash
#
# sideload.sh — install / manage apps on a Jio STB over ADB.
# The on-box installer UI is disabled by Jio, so apps go in from your PC.
# This is plain `adb install` wrapping — no exploit.
#
# Prereq: you already have ADB (see docs/sideload-network-adb.md).
#
# Examples:
#   ./sideload.sh --ip 192.168.1.50 install app.apk        # install one APK
#   ./sideload.sh install ./apks/                          # install every .apk in a folder
#   ./sideload.sh --list                                   # list installed 3rd-party apps
#   ./sideload.sh uninstall com.example.app                # remove an app
#   ./sideload.sh launcher                                 # install bundled Monet launcher
#
set -euo pipefail

IP=""
SUB_APK="third_party/sideload-jiostb/monet-launcher.apk"

usage() { sed -n '2,18p' "$0"; exit "${1:-0}"; }

[ $# -eq 0 ] && usage 0
while [ $# -gt 0 ]; do
  case "$1" in
    --ip) IP="$2"; shift 2;;
    -h|--help) usage 0;;
    *) break;;
  esac
done

command -v adb >/dev/null 2>&1 || { echo "ERROR: adb not found (install platform-tools)."; exit 1; }
[ -n "$IP" ] && { echo ">> adb connect ${IP}:5555"; adb connect "${IP}:5555" >/dev/null 2>&1 || true; }
adb get-state >/dev/null 2>&1 || { echo "No ADB device. Get ADB first: docs/sideload-network-adb.md"; exit 1; }

CMD="${1:-}"; shift || true
case "$CMD" in
  install)
    TARGET="${1:-}"; [ -n "$TARGET" ] || { echo "Give an .apk file or a folder."; exit 1; }
    if [ -d "$TARGET" ]; then
      shopt -s nullglob
      for apk in "$TARGET"/*.apk; do
        echo ">> installing $apk"; adb install -r "$apk" || echo "  (failed: $apk)"
      done
    else
      echo ">> installing $TARGET"; adb install -r "$TARGET"
    fi
    ;;
  list)
    echo ">> Installed third-party apps:"
    adb shell pm list packages -3 | tr -d '\r' | sed 's/^package://'
    ;;
  uninstall)
    PKG="${1:-}"; [ -n "$PKG" ] || { echo "Give a package name."; exit 1; }
    echo ">> uninstalling $PKG"; adb uninstall "$PKG"
    ;;
  launcher)
    if [ -f "$SUB_APK" ]; then
      echo ">> installing bundled launcher: $SUB_APK"; adb install -r "$SUB_APK"
      echo "Set it default from Settings, or press Home and pick it."
    else
      echo "Launcher APK not found. Run: git submodule update --init --recursive"
    fi
    ;;
  *) usage 0;;
esac
