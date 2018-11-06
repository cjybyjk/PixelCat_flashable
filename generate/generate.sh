#!/system/bin/sh

# 在这里修改项目名称和作者
project_name="PixelCat"
project_author="橘猫520"

# 可以自行添加 timer_rate
allowed_timer_rate=(
"boost"
"boostpulse_duration"
"timer_rate"
"timer_slack"
"min_sampling_time"
"align_windows"
"max_freq_hysteresis"
"enable_prediction"
"io_is_busy"
"ignore_hispeed_on_notif"
"use_sched_load"
"use_migration_notif"
"go_hispeed_load"
"hispeed_freq"
"above_hispeed_delay"
"target_loads"
)

function trim()
{
    echo $1 | sed -e 's/^[ \t]*//g' -e 's/[ \t]*$//g'
}

function get_clusters()
{
	case "$socModel" in
		"sd_820" | "sd_821" )
			is_big_little="y"
			cluster_0="cpu0"
			cluster_1="cpu2"
			;;
		"sd_660" | "sd_636" | "sd_835" | "exynos_9810" | "exynos_8895" ) 
			is_big_little="y"
			cluster_0="cpu0"
			cluster_1="cpu4"
			;;
		*) 
			read -p "是否使用big.LITTLE架构(y/n)" is_big_little
			read -p "请输入cluster0(默认为 cpu0):" cluster_0
			read -p "请输入cluster1(默认为 cpu4):" cluster_1
			[ -z "$is_big_little" ] && is_big_little="y"
			[ -z "$cluster_0" ] && cluster_0="cpu0"
			[ -z "$cluster_1" ] && cluster_1="cpu4"
			;;
	esac
}

function savemode()
{
    if [ "" != "$modeText" ]; then
        sed -i "s/# ${mode}_params/$modeText/g" powercfg.apk
        modeText=""
        echo "$mode saved"
    fi
}

function check_timer_rate()
{
    for i in ${!allowed_timer_rate[@]}
    do
        if [ "$timer_rate" = "${allowed_timer_rate[$i]}" ]; then
            return 0
        fi
        if [[ "$timer_rate" =~ "${allowed_timer_rate[$i]}" ]] || [[ "${allowed_timer_rate[$i]}" =~ "$timer_rate" ]]; then
            mostLikely=${allowed_timer_rate[$i]}
        fi
    done
    echo "目标 \"$timer_rate\" 可能存在错误, 与它最相似的是 \"$mostLikely\""
    read -p "请在此进行修改(默认为 $mostLikely):" rightTimerRate <&3
    [ -z "$rightTimerRate" ] && rightTimerRate="$mostLikely"
    timer_rate="$rightTimerRate"
}

basepath=$(cd `dirname $0`; pwd)

# 备份标准输入
exec 3<&0

echo "powercfg script generator
by cjybyjk @ coolapk
License: GPL v3

项目名称: $project_name
项目作者: $project_author
"

read -p "输入Soc型号:" socModel
platformPath="${basepath}/../platforms/$socModel"
get_clusters

rm -rf $platformPath
mkdir -p $platformPath
cd $platformPath

cp -r $basepath/powercfg_template ./powercfg.apk

vim ./perf_text

# 对复制的调度进行处理
echo -n "规范化调度参数(y/n):"
read flag_TextReplace
if [ "$flag_TextReplace" = "y" ]; then
    sed -i 's/[A-Z]/\u&/g' ./perf_text
    sed -i 's/:/：/g' ./perf_text
    sed -i 's/： /：/g' ./perf_text
    sed -i 's/：：/：/g' ./perf_text
    sed -i 's/\([0-9]\)：\([0-9]\)/\1:\2/g' ./perf_text
    sed -i 's/big：/\nbig：/g' ./perf_text
    sed -i 's/little：/\nlittle：/g' ./perf_text
    sed -i '/^\s*$/d' ./perf_text
    echo -e "\n" >> ./perf_text
fi

# default
mode="balance"

OLD_IFS="$IFS" 
IFS="："

while read lineinText
do 
    [ -z "$lineinText" ] && continue
    if [[ "$lineinText" =~ "省电" ]]; then
        savemode
        mode="powersave"
        continue
    elif [[ "$lineinText" =~ "性能" ]]; then
        savemode
        mode="performance"
        continue
    elif [[ "$lineinText" =~ "均衡" ]]; then
        savemode
        mode="balance"
        continue
    fi

    arrCmd=($lineinText)
    timer_rate="${arrCmd[0]}"
    if [ "$timer_rate" = "big" ] || [ "$timer_rate" = "little" ]; then
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
    param=`trim "$param"`
    cluster=`trim "$cluster"`
    timer_rate=`echo $timer_rate | tr -d '[ \t]'`
    [ -z "$param" ] && continue
    check_timer_rate
    [ "$timer_rate" = "target_loads" ] && [ "$cluster" = "little" ] && sed -i "s/${mode}_tload/$param/g" powercfg.apk
    [[ "$param" =~ " " ]] && param="\"$param\""
    modeText=${modeText}"set_param_$cluster $timer_rate $param\n	" 
done < ./perf_text

savemode

IFS="$OLD_IFS"

rm ./perf_text

# 写入相关信息
sed -i "s/project_name/$project_name/g" powercfg.apk
sed -i "s/project_author/$project_author/g" powercfg.apk
sed -i "s/soc_model/$socModel/g" powercfg.apk
sed -i "s/cluster_0/$cluster_0/g" powercfg.apk
sed -i "s/cluster_1/$cluster_1/g" powercfg.apk
sed -i "s/is_big_little/$is_big_little/g" powercfg.apk
sed -i "s/generate_date/`date`/g" powercfg.apk

exit 0
