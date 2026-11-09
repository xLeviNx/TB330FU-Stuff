#!/system/bin/sh
# Printed during Magisk flash.
ui_print "- Installing TB330FU Auto Brightness overlay"
ui_print "- Static RRO -> /product/overlay"
ui_print "- Reboot once after flashing"

# Place the overlay with correct perms/context for OMS to read it.
set_perm_recursive "$MODPATH/system/product/overlay" 0 0 0755 0644
