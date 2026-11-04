# Enable network ADB & sideload apps (the safe path)

This is the **low-risk** route: it does **not** unlock the bootloader and won't brick the box. It gets you **wireless ADB**, which is enough to **sideload apps, install a launcher, and [block ads](block-ads.md)**.

> [!NOTE]
> This guide explains the method and **points you to the upstream tools** that do the heavy lifting — we don't repackage their code. See [CREDITS.md](../CREDITS.md). Check your model in the [compatibility matrix](compatibility.md) first.

## How it works (plain English)

Your box checks in with Jio's provisioning server (TR-069 / "ACS") **at boot**. This method makes your box resolve that server's name to **your own PC** instead, where a small local server answers and flips on the hidden **USB/wireless-debugging** switch. Nothing leaves your network; you're talking to your own PC.

## What you need

| Tool | Role | Platforms |
|---|---|---|
| **Docker Desktop** | Runs the local provisioning server (GenieACS) | Win / macOS / Linux |
| **Technitium DNS** | Redirects Jio's ACS hostname to your PC | Win / Linux (Docker on macOS) |
| **Python 3** | Runs the proxy / helper scripts | all |
| **ADB (platform-tools)** | Connects to the box afterward | all |
| Upstream tooling | `sideload-jiostb` (JMSC/JMSB/JHS) or `Housekeeping-PoC` stage 1 (incl. D200) | — |

## Steps

### 1. Same network, know your PC's IP
Put PC and STB on the same LAN. Get your PC's IPv4:
- Windows: `ipconfig` · macOS/Linux: `ipconfig getifaddr en0` / `ip addr`

### 2. Open the box's hidden Android settings (USB bug)
The stock launcher hides real settings. Reach them via a USB stick:
**Insert empty USB → My Music → Settings → Eject USB → Internal Storage → Apps → (stock) Settings → Network.**

### 3. Point the box's DNS at your PC
In **Technitium DNS** on your PC, create primary zone **`jio.com`** and add an **A record** for the ACS host (e.g. `acs.oss` / `acs.oss.j.com`) → **your PC's IP**. Then on the box (via step 2) set a **static IP** with **DNS 1 = your PC's IP**.

### 4. Isolate the box from the internet
Disconnect the router's WAN/internet so the box can only reach your PC (prevents it contacting the real Jio server). Temporarily allow the DNS/HTTPS ports through your PC firewall.

### 5. Start the local provisioning server
Launch Docker Desktop, then start the upstream stack:
- **JMSC / JMSB:** run the TLS containers + `pass_front.py` proxy.
- **JHS:** use `run_acs.sh` (mints the cert chain those boxes require).
- **JMSD200Av2 (AirFiber):** use `Housekeeping-PoC` **stage 1** — see [airfiber-jmsd200.md](airfiber-jmsd200.md).

### 6. Trigger it — cold power-cycle
The box only contacts the ACS at boot. **Unplug from the wall** (not just standby) and power back on. Run the stage-1 script per the upstream README (e.g. `./stage1.sh --list-devices`). It sets:
- `Device.JSTB.USB.USBDebugging = true`
- debug validity → `2037` (so it stays on)
- FOTA / auto-update → disabled

### 7. Connect ADB
```bash
adb connect <box-ip>:5555
adb devices           # should list your box
```

### 8. Sideload apps
Jio disabled the on-box installer UI, so install from your PC:
```bash
adb install "app.apk"
adb install -r "app.apk"     # reinstall/update, keep data
adb uninstall <package.name> # remove
```

### 9. Tear down
Stop the containers, reconnect your router's internet, re-enable your firewall. Wireless ADB persists (validity 2037) and updates stay blocked.

## Next

- 🚫 **[Block ads](block-ads.md)** (boot + in-app) — the main reason most people do this.
- 🧰 Install a launcher (Monet) and a Shizuku-style helper (Shevery) from the upstream project.
- ❓ **[Troubleshooting](troubleshooting.md)** if ADB won't connect or DNS isn't intercepting.
