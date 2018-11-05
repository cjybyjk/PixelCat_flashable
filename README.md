# PixelCat_flashable
A script for flash interactive options script by [@橘猫520](http://www.coolapk.com/u/628386) into your device

好用的话记得给颗Star~

**注意：不能和 [WIPE_flashable](https://github.com/cjybyjk/WIPE_flashable/) 以及其他调度同时使用**

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
    输出 $MODE OK 即生效

#### 卸载 (Uninstall)
-	下载 WIPE_flashable Remover
	(Download WIPE_flashable Remover.)
-	重启到Recovery模式下并刷入
	(Reboot to recovery mode and flash it.)
