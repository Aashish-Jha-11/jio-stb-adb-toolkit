# Troubleshooting

## ADB / stage 1

**`adb devices` is empty / `adb connect` fails**
- Box and PC on the **same subnet**? Re-check the box's static IP + DNS (set via the USB-bug settings path).
- Did you do a **cold** power-cycle (unplug from wall)? The box only contacts the provisioning server at boot.
- Firewall: the DNS (53) and HTTPS (443/8443) ports must reach your PC during the run.
- Try `adb kill-server && adb connect <box-ip>:5555`.

**Box ignores your DNS / still reaches the internet**
- The router's WAN must be **disconnected** so the box can't reach the real Jio ACS.
- Confirm the Technitium zone (`jio.com`) and A-record host match what your model expects (`acs.oss` vs `acs.oss.j.com`).

**`stage1.sh` runs but ADB never turns on**
- Wrong proxy for your model: `pass_front.py` (JMSC/JMSB) vs `run_acs.sh` (JHS). D200 → use `Housekeeping-PoC` stage 1.
- Firmware may be newer than the method supports — check the [matrix](compatibility.md).

## Ads

**Boot ad still plays after disabling a package**
- You likely disabled the wrong one. Re-identify it at boot with:
  `adb shell dumpsys activity activities | grep -iE 'ResumedActivity'`
- Re-enable anything you broke: `adb shell pm enable <pkg>`.

**Private DNS won't stick**
- Some firmwares reset it. Verify: `adb shell settings get global private_dns_specifier`.
- If it reverts, a **LAN-level** Pi-hole/AdGuard Home (box DNS → that server IP) is more durable.

**Ads came back after a while**
- A forced update re-enabled them. Make sure OTA/FOTA is blocked (stage 1 does this). Re-check: `adb shell getprop ro.build.display.id` vs what you had.
- Video ads *inside* a stream (server-stitched) can't be DNS-blocked — that's expected.

## General

**Box is stuck / UI broke after disabling packages**
- `adb shell pm enable <pkg>` to undo, or **Factory reset** from recovery (reboot → factory reset). This does **not** un-root/re-lock anything; it just restores apps.

**I think I bricked it**
- If you only did stage 1 / ad-blocking (no unlock), you almost certainly didn't — try a factory reset.
- If you ran the unlock and it's dead: that's the documented risk; recovery depends on whether UBOOT fastboot is accessible on your unit.

Still stuck? Open an [issue](../CONTRIBUTING.md) with your **model, firmware build, security-patch date**, the exact command, and the full output.
