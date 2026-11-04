# Bootloader unlock / root (advanced — brick risk)

> [!CAUTION]
> This is the **dangerous** path. It can **permanently brick** your box, UBOOT fastboot is heavily restricted so recovery is limited, and it may further breach your lease terms with Jio.
>
> **You almost certainly don't need it.** Sideloading apps and [blocking ads](block-ads.md) — including boot ads — only need **ADB** (the [safe path](sideload-network-adb.md)). Root adds device-wide `hosts`/AdAway blocking and full app control, nothing more for the typical user.

## This repo does not ship an unlock exploit

The working research and tooling for the bootloader unlock is **already public and maintained** by its authors at **[`JFC-Group/Housekeeping-PoC`](https://github.com/JFC-Group/Housekeeping-PoC)** (Apache-2.0). If you want this path, use their project directly and follow **their** instructions and warnings — they wrote it, they test it, and they can support it. We just link and credit them ([CREDITS.md](../CREDITS.md)).

Reproducing their exploit chain here would add risk without adding value, so this page intentionally stays a pointer, not a how-to.

## Before you even consider it — sanity checks

Confirm you're a candidate (run these once you have ADB from stage 1):

```bash
adb shell getprop ro.product.model                 # which box
adb shell getprop ro.build.version.security_patch  # unlock tooling targets older patch levels
```

- **Confirmed target:** `JMSC200Av2`. Everything else — including the AirFiber **`JMSD200Av2`** — is **untested**; see [airfiber-jmsd200.md](airfiber-jmsd200.md). Trying an unlock meant for one model on another is a common way to brick.
- If your security-patch date is recent, the upstream tooling likely won't apply at all.
- There is **no reliable un-brick** if UBOOT fastboot is locked down on your unit. Assume a failed attempt = dead box.

## A saner order of operations

1. Do the [safe path](sideload-network-adb.md) → get ADB.
2. [Block ads](block-ads.md) and sideload the apps you want.
3. Live with it for a while. If — and only if — you hit a wall that genuinely requires root, read the upstream project end-to-end, make sure your model/firmware matches theirs, and accept the brick risk before starting.

---

*If you successfully (or unsuccessfully) run the upstream unlock on a given model + firmware, please record the outcome in an [issue](../CONTRIBUTING.md) so the [compatibility matrix](compatibility.md) reflects reality.*
