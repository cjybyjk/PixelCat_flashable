# PixelCat_flashable
A script for flash interactive options script by [@橘猫520](http://www.coolapk.com/u/628386) into your device

好用的话记得给颗Star~

** 注意：和 [WIPE_flashable](https://github.com/cjybyjk/WIPE_flashable/) 不能共存 **

### Thanks to
[@橘猫520](http://www.coolapk.com/u/628386)
[@yc9559](https://github.com/yc9559)

### How to use
#### 刷入 (Flash)
-   下载zip到你的设备中 
    (Download zip to your device.)
	- [下载卡刷包 (Download the flashable ZIP)](https://github.com/cjybyjk/PixelCat_flashable/releases)
-   重启到Recovery模式下并刷入zip
    (Reboot to recovery mode and flash it.)
	- 如果不想安装为magisk模块,可以执行这个命令后重新刷入 
	```bash
		touch /pixelcat_no_magisk
	```
	- 如果以传统模式安装后没有成功应用,可以执行这个命令后重新刷入
	```bash
		touch /pixelcat_no_apply_once
	```
#### 更改模式 (Change Mode)
##### 自动应用 重启后生效 (Apply on boot)
-   在终端以root身份执行命令
	(Run command as root in terminal):
	```bash
	echo "powersave" > /data/pixelcat_mode #省电
	echo "balance" > /data/pixelcat_mode #均衡(默认)
	echo "performance" > /data/pixelcat_mode #性能
	echo "disabled" > /data/pixelcat_mode #停用
	```

##### 临时应用 立即生效 (Temporary Apply (NOW))
-   在终端以root身份执行命令
    (Run command as root in terminal): 
    ```bash
	powercfg powersave #省电
	powercfg balance #均衡
	powercfg performance #性能
    ```
#### SELinux问题 (SELinux problem)
##### 如果这个脚本导致了SELinux问题(例如不正确的SELinux permissive),请按以下步骤操作
-	安装为magisk模块
	- 使用文本编辑器打开这些文件(如果存在) , 将 `RestoreSELinux=false` 改为 `RestoreSELinux=true`, 然后保存
		- /sbin/.core/img/PixelCat/service.sh
-	SuperSU Systemless
	- 使用文本编辑器打开这些文件(如果存在) , 将 `RestoreSELinux=false` 改为 `RestoreSELinux=true`, 然后保存
		- /su/su.d/99pixelcat
-	传统安装方式
	- 使用文本编辑器打开这些文件(如果存在) , 将 `RestoreSELinux=false` 改为 `RestoreSELinux=true`, 然后保存
		- /system/etc/init.qcom.post_boot.sh
		- /vendor/bin/init.qcom.post_boot.sh
		- /system/su.d/99pixelcat
		- /system/etc/init.d/99pixelcat
		- /system/addon.d/99pixelcat
		- /system/etc/install-recovery.sh
		- /system/bin/sysinit
		- /system/bin/install-recovery.sh

#### 卸载 (Uninstall)
-	下载 WIPE_flashable Remover
	(Download WIPE_flashable Remover.)
-	重启到Recovery模式下并刷入
	(Reboot to recovery mode and flash it.)
