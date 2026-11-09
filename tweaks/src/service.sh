#!/system/bin/sh
# Turn adaptive brightness ON once the system is up, so the feature the
# overlay just enabled is actually used by default.
until [ "$(getprop sys.boot_completed)" = "1" ]; do
  sleep 2
done
sleep 3
settings put system screen_brightness_mode 1
