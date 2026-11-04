# Block ads on your Jio STB — boot ads + in-app ads

**Goal:** kill the startup/boot advertisement and cut ads inside apps and the launcher.

> [!IMPORTANT]
> **The good news:** you do **not** need the risky bootloader unlock to block ads. You only need **ADB access** (stage 1). Most of this works **without root**.
>
> **The honest limit:** DNS-based blocking stops ad *domains*. It can't stop **server-stitched video ads** that are baked into the stream itself (some live-TV / JioCinema mid-rolls). Those need the app's own settings or a subscription.

## What you can block, and how

| Ad type | Method | Needs root? |
|---|---|:---:|
| Boot / startup ad | Disable the boot-ad package with ADB | No |
| Launcher ads & "recommendation" rows | Replace launcher **or** disable the launcher's ad component | No |
| In-app banner / pre-roll ads (DNS-resolvable) | Point the box at an ad-blocking DNS resolver | No |
| Device-wide, hosts-level | AdAway / system `hosts` file | Yes (optional) |

---

## Step 1 — Get ADB (prerequisite)

Follow **[sideload-network-adb.md](sideload-network-adb.md)**. On the AirFiber **JMSD200Av2**, this is the stage-1 path — see **[airfiber-jmsd200.md](airfiber-jmsd200.md)**. You're ready when:

```bash
adb devices        # your box's IP shows as "device"
```

## Step 2 — Kill the boot / startup ad

First **find** the package that plays on boot (names differ by firmware, so don't guess — identify it):

```bash
# List candidate Jio/ad/launcher packages
adb shell pm list packages | grep -iE 'jio|ad|boot|promo|launch'

# Catch whatever is on screen right at boot: power-cycle the box, then quickly run:
adb shell dumpsys activity activities | grep -iE 'mResumedActivity|topResumedActivity'
```

Once you've identified the boot-ad package, disable it (this is **reversible**):

```bash
adb shell pm disable-user --user 0 <package.name>
```

Undo if something misbehaves:

```bash
adb shell pm enable <package.name>
```

> Commonly-cited Jio launcher/ad package prefixes are `com.jio.*` / `com.jiostb.*` — **verify on your own box before disabling.** Disabling the wrong system package can break the UI (recoverable via `pm enable` or factory reset).

## Step 3 — Block in-app ads with Private DNS (no root)

ADB can set Android's **Private DNS** (DNS-over-TLS) to an ad-blocking resolver — system-wide, no app needed:

```bash
adb shell settings put global private_dns_mode hostname
adb shell settings put global private_dns_specifier dns.adguard-dns.com
```

Alternatives for the specifier:
- **NextDNS** (free, customizable blocklists): create a config → use `<your-id>.dns.nextdns.io`
- **AdGuard DNS:** `dns.adguard-dns.com`
- **Local Pi-hole / AdGuard Home** on your LAN: set the box's DNS to that server's IP instead.

Revert anytime:

```bash
adb shell settings put global private_dns_mode off
```

## Step 4 — Replace the launcher (optional)

Install a clean launcher (e.g. **Monet**, from the sideload guide) and set it default. This removes the stock launcher's ad rows and "recommendations." Fully reversible by switching the default launcher back.

## Step 5 — Nuclear option (root only, NOT required for ads)

If you've unlocked (brick risk — see [unlock-bootloader.md](unlock-bootloader.md)), you can use a system `hosts` file or **AdAway** for device-wide blocking and remove ad apps outright. Overkill just for ads; listed for completeness.

## Keep ads from coming back

Jio can re-enable ads or patch your ADB with a forced update. **Block OTA updates** (stage 1 does this automatically) so your changes stick. See [troubleshooting.md](troubleshooting.md) if ads return after an update.

---

*Have exact boot-ad package names or working DNS blocklists for a specific model/firmware? That's gold — [add them](../CONTRIBUTING.md) so the next person can copy-paste.*
