#!/usr/bin/env bash
#
# block-ads.sh — kill ads on a Jio STB over ADB (no root needed).
# Safe & reversible: sets system Private DNS to an ad-blocking resolver and/or
# disables a boot-ad package you choose. Nothing here exploits the device.
#
# Prereq: you already have ADB (see docs/sideload-network-adb.md).
#
# Examples:
#   ./block-ads.sh --ip 192.168.1.50 --dns            # enable ad-blocking DNS
#   ./block-ads.sh --list                             # list candidate ad/launcher pkgs
#   ./block-ads.sh --disable com.jio.example.ads      # disable a boot-ad pkg (reversible)
#   ./block-ads.sh --enable  com.jio.example.ads      # undo a disable
#   ./block-ads.sh --dns-off                          # turn ad-blocking DNS back off
#
set -euo pipefail

IP=""
DNS_HOST="dns.adguard-dns.com"   # change with --dns-host <hostname>
ACTION=""

usage() { sed -n '2,20p' "$0"; exit "${1:-0}"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --ip)        IP="$2"; shift 2;;
    --dns)       ACTION="dns_on"; shift;;
    --dns-host)  DNS_HOST="$2"; shift 2;;
    --dns-off)   ACTION="dns_off"; shift;;
    --list)      ACTION="list"; shift;;
    --disable)   ACTION="disable"; PKG="$2"; shift 2;;
    --enable)    ACTION="enable"; PKG="$2"; shift 2;;
    -h|--help)   usage 0;;
    *) echo "Unknown arg: $1"; usage 1;;
  esac
done

command -v adb >/dev/null 2>&1 || { echo "ERROR: adb not found (install platform-tools)."; exit 1; }
[ -n "$IP" ] && { echo ">> adb connect ${IP}:5555"; adb connect "${IP}:5555" >/dev/null 2>&1 || true; }
adb get-state >/dev/null 2>&1 || { echo "No ADB device. Get ADB first: docs/sideload-network-adb.md"; exit 1; }

case "$ACTION" in
  dns_on)
    echo ">> Setting Private DNS (DoT) to: ${DNS_HOST}"
    adb shell settings put global private_dns_mode hostname
    adb shell settings put global private_dns_specifier "${DNS_HOST}"
    echo "Done. Verify: adb shell settings get global private_dns_specifier"
    echo "Note: blocks DNS-resolvable ad domains; can't stop server-stitched video ads."
    ;;
  dns_off)
    echo ">> Disabling Private DNS ad-blocking"
    adb shell settings put global private_dns_mode off
    echo "Done."
    ;;
  list)
    echo ">> Candidate ad / launcher / promo packages (review before disabling):"
    adb shell pm list packages | tr -d '\r' | grep -iE 'jio|ad|boot|promo|launch' || echo "(none matched)"
    echo
    echo "Tip: to catch the BOOT ad, power-cycle the box then quickly run:"
    echo "  adb shell dumpsys activity activities | grep -iE 'ResumedActivity'"
    ;;
  disable)
    echo ">> Disabling (reversible): ${PKG}"
    adb shell pm disable-user --user 0 "${PKG}"
    echo "Done. Undo with: $0 --enable ${PKG}"
    ;;
  enable)
    echo ">> Re-enabling: ${PKG}"
    adb shell pm enable "${PKG}"
    echo "Done."
    ;;
  *)
    usage 0;;
esac
