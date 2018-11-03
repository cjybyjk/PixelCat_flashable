#!/system/bin/sh

function savemode()
{
    if [ "" != "$modeText" ]; then
        sed -i "s/$mode/$modeText/g" powercfg.apk
        modeText=""
        echo "$mode saved"
    fi
}

basepath=$(cd `dirname $0`; pwd)/template

echo -n "输入Soc型号:"
read socModel
if [ ! -f "$basepath/$socModel/powercfg.apk" ]; then
    echo "! 没有适配这个型号"
    exit 0
fi
platformPath="${basepath}/../../platforms/$socModel"

rm -rf $platformPath
mkdir -p $platformPath
cd $platformPath

cp -r $basepath/$socModel/* ./

vim ./perf_text

# 对复制的调度进行处理
echo -n "规范化调度参数(y/N):"
read flag_TextReplace
if [ "$flag_TextReplace" == "y" ]; then
    sed -i 's/\([0-9]\)：\([0-9]\)/\1:\2/g' ./perf_text
    sed -i 's/align_ windows/align_windows/g' ./perf_text
    sed -i 's/\([a-z]\):：/\1：/g' ./perf_text
    sed -i 's/go_hispeed_freq：\([0-9]*\) \([0-9]*\)/go_hispeed_freq：\nbig：\1\nlittle：\2/g' ./perf_text
    echo -e "\n" >> ./perf_text
fi

# default
mode="balance_params"
modeTload="balance_tload"

OLD_IFS="$IFS" 
IFS="："
while read lineinText
do 
    [[ "$lineinText" == "" ]] && continue
    if [[ "$lineinText" =~ "省电" ]]; then
        savemode
        mode="powersave_params"
        modeTload="powersave_tload"
        continue
    elif [[ "$lineinText" =~ "性能" ]]; then
        savemode
        mode="performance_params"
        modeTload="performance_tload"
        continue
    elif [[ "$lineinText" =~ "均衡" ]]; then
        savemode
        mode="balance_params"
        modeTload="balance_tload"
        continue
    fi

    arrCmd=($lineinText)
    timer_rate="${arrCmd[0]}"
    if [ "$timer_rate" == "big" ] || [ "$timer_rate" == "little" ]; then
        timer_rate=$timer_rate_bak
        cluster="${arrCmd[0]}" 
        param="${arrCmd[1]}"
    else
        timer_rate_bak=$timer_rate
        if [ "${arrCmd[1]}" != "big" ] && [ "${arrCmd[1]}" != "little" ] ; then
            cluster="all" 
            param="${arrCmd[1]}"
        else
            cluster="${arrCmd[1]}" 
            param="${arrCmd[2]}"
        fi
    fi
    [[ "" == "$param" ]] && continue
    [[ "$timer_rate" == "target_loads" ]] && [[ "$cluster" == "little" ]] && sed -i "s/$modeTload/$param/g" powercfg.apk
    [[ "$param" =~ " " ]] && param="\"$param\""
    modeText=${modeText}"set_param_$cluster $timer_rate $param\n	" 
done < ./perf_text

savemode

IFS="$OLD_IFS"

rm ./perf_text

sed -i "s/generate_date/`date`/g" powercfg.apk

exit 0
