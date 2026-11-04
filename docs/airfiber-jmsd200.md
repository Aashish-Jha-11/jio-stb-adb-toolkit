# AirFiber STB — JMSD200Av2 (codename "ohm") — status & how to try it

**If you have this box, start here.** It's the newest, most locked-down Jio STB — but recent research says it's **probably sideloadable**, which is enough to **block ads and install apps** without the risky unlock.

## TL;DR

- **Sideload / ADB:** ⚠️ **reported working** via `Housekeeping-PoC` **stage 1** (one unverified report, Oct 28 2026). If it works for you → you can install apps and [block ads](block-ads.md).
- **Bootloader unlock / root:** ⚠️ **untested** on this model. Your patch level *might* be in range, but secure boot is ON and the brick risk is real. Not needed for ads/sideloading.

## Hardware & firmware (from research)

| Property | Value |
|---|---|
| Model | `JMSD200Av2` (commodity `IPSTB JMSD200Av2_J with acc`, sticker `AF1`) |
| Codename | **ohm** |
| SoC | Amlogic **S905X4** (quad Cortex-A55, Mali-G31) |
| OS | **JioOS 2.0** (Android 11) |
| Kernel | **5.4.125** |
| Security patch | **2024-02-05** *(before the June-2024 CVE fix → unlock window technically open)* |
| Secure boot | **ON** |
| Bootloader | **Locked** |
| ADB | Off by default (TCP `5555` closed) |
| UART | Present but **read-only** @ 921600 baud (AOCPU FreeRTOS log only) |
| `/system` | Read-only, AVB / dm-verity |
| Recovery | Stripped (reboot / factory-reset only; no "apply update from ADB") |

Source: [TechEnclave — Jio STB Unlock Research](https://techenclave.com/t/jio-stb-unlock-research/446600).

## First: check YOUR box's patch date

Your box may have a newer forced update than `2024-02-05`, which closes the unlock window. Once you have ADB:

```bash
adb shell getprop ro.build.version.security_patch   # ≤ 2024-05 = unlock window open
adb shell getprop ro.product.model                   # confirm JMSD200Av2
adb shell getprop ro.build.display.id                # firmware build
```

Or run [`doctor/jio-stb-doctor.sh <box-ip>`](../doctor/jio-stb-doctor.sh) — it reports all of this and tells you which paths apply.

## How to try stage 1 (ADB + sideload) on the D200

This is the part reported working. It does **not** unlock the bootloader and is far lower risk.

1. Read the full safe-path walkthrough: **[sideload-network-adb.md](sideload-network-adb.md)**.
2. Use the **`Housekeeping-PoC`** stage-1 tooling (the TR-069 / GenieACS + DNS redirect that flips `Device.JSTB.USB.USBDebugging`). Credit & link: [CREDITS.md](../CREDITS.md).
3. After `stage1.sh` succeeds: `adb connect <box-ip>:5555`, then `adb install app.apk`.
4. Go to **[block-ads.md](block-ads.md)** to kill boot + in-app ads.

> Report your result (worked / didn't, firmware build, patch date) in an issue — the D200 picture is still being pieced together and your data point genuinely helps.

## The unlock (only if you insist, and accept brick risk)

The patch window may be open on `2024-02-05` builds, but **no one has confirmed the full unlock on a D200**, secure boot is ON, and UBOOT fastboot is heavily restricted. Read **[unlock-bootloader.md](unlock-bootloader.md)** fully first. For just removing ads and adding apps, **you don't need this.**

## Research leads (for contributors)

- Confirm/deny stage 1 across D200 firmware builds; record patch dates where it still works.
- Map the hidden settings surface on JioOS 2.0 (is a debugging toggle exposed?).
- Capture the box's boot-time provisioning (DNS/ACS endpoints) on your own LAN.
- Document whether stage 2 (`setBootenv` → `/dev/block/env` lock-bit flip) is reachable on S905X4 secure-boot.

## Status log (newest first)

| Date | Finding | Source |
|---|---|---|
| 2026-10-28 | `stage1.sh` reported working on a D200 — "can install any app." | TechEnclave (user *r2d3*) |
| 2026-11 | Full specs confirmed: S905X4, secure boot ON, BL locked, patch 2024-02-05, UART read-only, stripped recovery. | TechEnclave + teardowns |

*Add a row whenever something is confirmed or refuted.*
