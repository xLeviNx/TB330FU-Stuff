# TB330FU Disable Telephony

Disables all cellular/telephony on the **Wi‑Fi‑only** Lenovo Tab M11 (TB330FU). The GSI advertises telephony features even though this tablet has no modem, which produces phantom SIM/mobile UI and makes `com.android.phone` crash-loop. This module makes Android treat the device as a non-phone.

After flashing + reboot:

- No **SIM / mobile network** settings
- No **cellular calling / SMS** UI, no "Emergency calls only" on the lockscreen
- `com.android.phone` **stops crash-looping** (no more "Phone has stopped")
- Wi‑Fi, Bluetooth, and everything else untouched

## How it works

A single permissions file at `/system/etc/permissions/disable-telephony.xml` marks the telephony features **unavailable**. Android's `SystemConfig` reads `<unavailable-feature>` and removes those features from the device even if the GSI declares them, so SIM/mobile/calling code paths are never activated.

Features marked unavailable:

```
android.hardware.telephony
android.hardware.telephony.gsm
android.hardware.telephony.cdma
android.hardware.telephony.ims
android.hardware.telephony.ims.singlereg
android.hardware.telephony.euicc
android.hardware.telephony.euicc.mep
android.hardware.telephony.mbms
android.hardware.telephony.calling
android.hardware.telephony.data
android.hardware.telephony.messaging
android.hardware.telephony.radio.access
android.hardware.telephony.subscription
```

## Install

1. Flash `TB330FU-NoTelephony-v1.zip` in Magisk → Modules → Install from storage.
2. **Reboot.**

## Undo

Toggle the module off in Magisk → Modules and reboot. (You'd only want telephony back if moving this to a cellular-capable model.)

## Verify (optional, with adb)

```sh
adb shell pm list features | grep telephony
```

After the module is active this should return **nothing** — all telephony features gone.
