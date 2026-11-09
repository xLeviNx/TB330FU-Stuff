#!/system/bin/sh
ui_print "- Installing TB330FU Disable Telephony"
ui_print "- Marking android.hardware.telephony* unavailable"
ui_print "- Reboot after flashing"

# Standard perms/context for a permissions XML so SystemConfig can read it.
set_perm_recursive "$MODPATH/system/etc/permissions" 0 0 0755 0644
