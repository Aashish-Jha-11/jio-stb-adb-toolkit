# Credits

This project is a **documentation and orchestration hub**. The real reverse-engineering was done by the people and communities below. It organizes and links their public work — it does not host or repackage their exploit code. If you're an author here and want attribution changed or something removed, open an issue.

## Projects

- **[`ilikechocopies/sideload-jiostb`](https://github.com/ilikechocopies/sideload-jiostb)** — the network-ADB / sideload method for JMSC200Av2, JMSB200A, and JHS boxes (GenieACS + DNS redirect, launcher, ad/update blocking). Most of the [safe path](docs/sideload-network-adb.md) derives from their guide.
- **[`JFC-Group/Housekeeping-PoC`](https://github.com/JFC-Group/Housekeeping-PoC)** *(Apache-2.0)* — stage-1 ADB enablement and the bootloader-unlock research. The [unlock page](docs/unlock-bootloader.md) points to them rather than reproducing their work.

## Research & community

- **[TechEnclave — Jio STB Unlock Research](https://techenclave.com/t/jio-stb-unlock-research/446600)** — the richest ongoing thread, and the source of the **JMSD200Av2 ("ohm")** specs and the Oct-2026 report that stage 1 works on the D200. Thanks to the contributors there (incl. *r2d3*).
- **[XDA — enable ADB & sideload on updated Jio STB](https://xdaforums.com/t/jio-stb-guide-to-enable-adb-and-sideload-apps-on-the-updated-version-of-jio-stb.4317263/)** — long-running guide thread.
- **[XDA Developers article — unlock old JioFi & Jio STB](https://www.xda-developers.com/how-to-unlock-jiofi-jio-stb/)**
- **Jio AirFiber STB teardown** (codewsuraj) — hardware confirmation (S905X4, eMMC, etc.).

## License note

This repo's own content is MIT ([LICENSE](LICENSE)). If you later import code **derived from** the Apache-2.0 `Housekeeping-PoC`, you must retain its `LICENSE`/`NOTICE`, note your changes, and attribute it — keep such code in a clearly separated directory with its own license file.

> Not affiliated with, endorsed by, or connected to Reliance Jio. All trademarks belong to their owners.
