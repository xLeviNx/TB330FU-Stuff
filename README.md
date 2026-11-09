# TB330FU-Stuff

Magisk modules and fixes for the **Lenovo Tab M11 (TB330FU)** running a **LineageOS GSI** (LineageOS 23.2 / Android 16).

The TB330FU is the **Wi‑Fi‑only** Tab M11 (MediaTek MT6768 / Helio G85). Because a GSI (Generic System Image) is device-agnostic by design, it ships without this tablet's device-specific configuration — so several things that work on the stock firmware are missing or misbehave on the GSI. These modules restore them.

> **Requirements:** a rooted TB330FU (Magisk) running a LineageOS/Treble GSI. Built and tested on *this* device — flash on other models at your own risk.

## Modules

| Module | What it does |
|--------|--------------|
| [**tweaks**](tweaks/) | Enables **adaptive (auto) brightness** and makes the **3.5 mm headphone jack** route audio (both are disabled by default on the GSI). |
| [**notelephony**](notelephony/) | **Disables all cellular/telephony** — removes SIM / mobile-network / calling UI and stops `com.android.phone` crash‑looping on this Wi‑Fi‑only tablet. |

Each folder contains the ready-to-flash `.zip`, the module source, and its own README.

## Installing

1. Copy the module `.zip` to the tablet.
2. Open **Magisk → Modules → Install from storage** and select the `.zip`.
3. **Reboot.**

To remove one: toggle it off in Magisk → Modules and reboot.

## If something goes wrong

These are small, framework-level overlays/permission files — low risk — but if a module ever causes a boot problem, hold **Volume Down** during boot to start Magisk in **safe mode** (all modules disabled), then remove the offending module.

## Why these are needed (short version)

- **Auto-brightness:** the GSI sets `config_automatic_brightness_available=false` and ships an empty brightness curve, so the light sensor is never used. The module overlays those framework resources.
- **Headphone jack:** the GSI sets `config_useDevInputEventForAudioJack=false`, so `WiredAccessoryManager` watches a legacy switch that doesn't exist on this hardware and ignores the real input-device jack events — the jack is detected but never routed. The module flips that flag to `true`.
- **Telephony:** the GSI advertises `android.hardware.telephony*` features even though this tablet has no modem, which creates phantom SIM/mobile UI and crash-loops `com.android.phone`. The module marks those features unavailable.

## License

Provided as-is, no warranty. Do what you like with it.
