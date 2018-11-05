#!/system/bin/sh
MODDIR=${0%/*}
# PixelCat support

# wait for boot animation stopped
until [ "`getprop init.svc.bootanim`" = "stopped" ]
do
sleep 10
done

# mode detect
MODE=`cat /data/pixelcat_mode`
[ "" == "$MODE" ] && MODE=`cat /sdcard/pixelcat_mode`
[ "" == "$MODE" ] && MODE=`cat /data/media/0/pixelcat_mode`
[ "disabled" == "$MODE" ] && exit 0

powercfg $MODE > /dev/pixelcat_state

