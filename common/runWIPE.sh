# PixelCat support

RestoreSELinux=false
SEStatus=`getenforce`

MODE=`cat /data/pixelcat_mode`
[ "" == "$MODE" ] && MODE=`cat /sdcard/pixelcat_mode`
[ "" == "$MODE" ] && MODE=`cat /data/media/0/pixelcat_mode`
[ "disabled" == "$MODE" ] && exit 0

rm -f /dev/.pixelcat_runonce
powercfg $MODE > /dev/pixelcat_state

$RestoreSELinux && setenforce $SEStatus
