# TB330FU Tweaks — Auto-brightness + Headphone jack

Fixes two things that the LineageOS GSI leaves disabled on the Lenovo Tab M11 (TB330FU):

- **Adaptive (auto) brightness** — the hardware light sensor works, but the GSI ships `config_automatic_brightness_available=false` with an empty brightness curve, so Android never offers or uses adaptive brightness. This module turns it on and supplies a lux → backlight curve.
- **3.5 mm headphone jack** — the kernel detects the plug correctly, but the GSI ships `config_useDevInputEventForAudioJack=false`, so `WiredAccessoryManager` listens on the legacy `/sys/class/switch/h2w` path (which doesn't exist here) instead of the real input device, and audio never routes to the jack. This module flips that flag to `true`.

## How it works

It's a **static Runtime Resource Overlay (RRO)** targeting the framework (`package="android"`), installed to `/product/overlay/` via the module. Because it's static and lives on the product partition, it's trusted and applied at boot — no signature from the platform key required.

Overridden framework resources:

| Resource | Value |
|----------|-------|
| `config_automatic_brightness_available` (bool) | `true` |
| `config_autoBrightnessLevels` (lux thresholds) | `8,20,45,90,180,360,700,1300,2500` |
| `config_autoBrightnessLcdBacklightValues` (0–255) | `10,20,40,60,90,120,150,185,215,255` |
| `config_useDevInputEventForAudioJack` (bool) | `true` |

## Install

1. Flash `TB330FU-Tweaks-v2.zip` in Magisk → Modules → Install from storage.
2. **Reboot.**
3. Adaptive brightness is enabled automatically; you can confirm it under **Settings → Display**.

## Tuning the brightness curve

The curve is a reasonable first pass, not factory-calibrated. To adjust it, edit the arrays in [`overlay-src/res/values/config.xml`](overlay-src/res/values/config.xml):

- Screen too dim in a normal room → raise the mid-range `config_autoBrightnessLcdBacklightValues`.
- Not bright enough outdoors → raise the top values.

Then rebuild (see below) and reflash.

## Building from source

Source is in [`src/`](src/) (the Magisk module skeleton) and [`overlay-src/`](overlay-src/) (the RRO). To rebuild the overlay APK you need Android build-tools (`aapt2`, `zipalign`, `apksigner`) and the device's own `framework-res.apk` as the link reference (pull it with `adb pull /system/framework/framework-res.apk`):

```sh
aapt2 compile --dir overlay-src/res -o compiled.zip
aapt2 link -I framework-res.apk --manifest overlay-src/AndroidManifest.xml \
  --min-sdk-version 30 --target-sdk-version 34 -o overlay_unsigned.apk compiled.zip
zipalign -f 4 overlay_unsigned.apk overlay_aligned.apk
apksigner sign --ks your.keystore --out src/system/product/overlay/TB330FU_AutoBright.apk overlay_aligned.apk
```

Then zip the contents of `src/` into the module (keep forward-slash paths so Magisk can read it).
