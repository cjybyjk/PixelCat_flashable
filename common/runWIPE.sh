# PixelCat support

MODE=`cat /data/pixelcat_mode`
[ "" == "$MODE" ] && MODE=`cat /sdcard/pixelcat_mode`
[ "" == "$MODE" ] && MODE=`cat /data/media/0/pixelcat_mode`
[ "disabled" == "$MODE" ] && exit 0

powercfg $MODE > /dev/pixelcat_state

