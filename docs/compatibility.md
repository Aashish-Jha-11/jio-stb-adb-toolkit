# Compatibility matrix

**Find your exact model + firmware before doing anything.** It's on the sticker under the box (`Model: ...`) and in **Settings → About / System**. Or run [`doctor/jio-stb-doctor.sh`](../doctor/jio-stb-doctor.sh) once ADB is reachable — it reads your model and security-patch date and tells you which path applies.

Legend: ✅ public method works · ⚠️ reported but **unverified** / conditional · ❌ not possible / no public method · 🔬 active research

| Model | Marketing name | SoC | Network-ADB + sideload | Launcher / block ads+updates | Bootloader unlock / root |
|---|---|---|:---:|:---:|:---:|
| **JMSC200Av2** | Jio Set-Top Box | Amlogic | ✅ | ✅ | ✅ *(sec-patch **≤ May 2024**, one shot per boot)* |
| **JMSB200A** | Jio Set-Top Box | Amlogic | ✅ | ✅ | ⚠️ |
| **JHSC200 v1** | Jio Home STB (JioOS 2.0) | Amlogic | ✅ *(different cert/proxy step)* | ✅ | ❌ |
| **JMSD200Av2** | **Jio AirFiber STB** ("ohm") | **Amlogic S905X4** | ⚠️ **reported working** *(stage 1, Oct 2026, 1 report)* | ⚠️ *(follows from ADB)* | ⚠️ **untested** *(see notes)* |

## The unlock window (why the patch date matters)

The deep bootloader-unlock uses **CVE-2024-31317**, a public Android Zygote bug fixed by Google in **June 2024**. It only works if your box's `ro.build.version.security_patch` is **May 2024 or earlier**. After that it's patched and the unlock path is closed (sideload may still work).

```
adb shell getprop ro.build.version.security_patch
```

## Known firmware builds

Reported working for the **sideload** path on supported models: `22.1.09`, `24.1.39`, `25.1.9`, and older. Newer forced-update builds can close the method — which is why people **block updates** immediately after setup.

## JMSD200Av2 (AirFiber) — current reading

Per the [TechEnclave research thread](https://techenclave.com/t/jio-stb-unlock-research/446600): codename **"ohm"**, JioOS 2.0 / Android 11, kernel **5.4.125**, security patch **2024-02-05**, secure boot ON, bootloader locked, UART read-only, ADB off (5555 closed), AVB/dm-verity on `/system`, stripped recovery.

The notable part: on **Oct 28, 2026** a user reported running **`stage1.sh`** (the network-ADB enablement from `Housekeeping-PoC`) successfully and being able to **install any app**. That report is **single-source and unverified**, but it means the D200 is likely **sideloadable**, and because its patch (`2024-02-05`) predates the June-2024 fix, the unlock *might* also be in range — **untested on the D200, secure boot ON, real brick risk.** See **[airfiber-jmsd200.md](airfiber-jmsd200.md)**.

---

*Community-maintained — may be wrong or out of date. First-hand results are the most valuable contribution here; please [submit a correction](../CONTRIBUTING.md).*
