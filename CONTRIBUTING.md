# Contributing

The most valuable thing you can add is **first-hand results from a real box** — especially the **AirFiber JMSD200Av2**, where the picture is still forming.

## The single best contribution: a data point

Open an issue (or PR to the [matrix](docs/compatibility.md)) with:

- **Model** (e.g. `JMSD200Av2`) and **marketing name**
- **Firmware build** — `adb shell getprop ro.build.display.id`
- **Security patch** — `adb shell getprop ro.build.version.security_patch`
- **What you tried** (stage 1 / sideload / ad-block / unlock) and **what happened**
- Screenshots or logs if you have them

Even **"method X did nothing on build Y"** is useful — negative results save everyone time.

## Scope & ground rules

- **Right-to-repair only.** Content is for people modifying **their own** hardware on **their own** network. No attacking Jio infrastructure or anyone else's device.
- **Link upstream, don't repackage.** Point to the original projects for exploit tooling; keep this repo as docs + orchestration. If you add code derived from an Apache-2.0 source, follow its license (see [CREDITS.md](CREDITS.md)).
- **No secrets in commits.** Never commit serial numbers, MACs, private keys/certs, or firmware dumps — the [`.gitignore`](.gitignore) covers the common cases, but double-check.
- **Honesty over hype.** Mark things ⚠️ unverified until confirmed by more than one person. The repo's value is that it's trustworthy.

## Docs style

- Lead with the **safe path**; gate risky steps behind clear warnings.
- Prefer copy-pasteable commands with a one-line explanation.
- Keep model-specific notes in the right doc (e.g. D200 details → [airfiber-jmsd200.md](docs/airfiber-jmsd200.md)).

## Good first issues

- Add your box's result to the compatibility matrix.
- Confirm boot-ad package names for a specific model/firmware.
- Share a working DNS blocklist/config for Jio in-app ads.
- Improve a confusing step in the [sideload guide](docs/sideload-network-adb.md).

Thanks for helping make this the honest, central reference for Jio STB owners. ⭐
