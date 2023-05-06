ATTENTION!!! THIS IS AN OUTDATED VERSION OF THE SETUP MANUAL!!!

## Tune-up
### Presetting

The MJSXJ03HL camera setup is different from most cameras. At this moment, the camera cannot connect to the Internet and we cannot use SSH. We also cannot use the WEB-interface. Therefore, all commands for now will be executed in the terminal access to the camera. The command syntax in this case is the same.

So, connect your camera to your computer via UART, enter the terminal and power up the camera. DO NOT INTERRUPT BOOT! Login to camera console (not Uboot console!)

#### Driver loading

First of all, you need to manually add the driver for the wireless module.

The driver with which I was able to configure the network can be downloaded from [link](https://github.com/OpenIPC/device-mjsxj03hl/raw/master/flash/autoconfig/lib/modules/rtl8189ftv.ko)

Copy the driver to the SD card, put it in the camera's memory, connect the UART, terminal, power on. Login to camera console (not U-Boot!)
Log in and enter the following commands:
1. Go to SD-card
```
cd /mnt/mmcblk0p1
``` 
2. Make sure the file is present
```
ls -l
```
3. Copy
```
cp rtl8189ftv.ko /lib/modules/
```
For now, there is no point in rebooting and checking the network. Go to the next stage

#### Network configuration

The network configuration is located in the file /etc/network/interfaces
Unfortunately, only `vi` is available from text editors. I recommend that you first familiarize yourself with the nuances of this editor.

Give a command:
``` 
vi /etc/network/interfaces
```
And let's correct its contents to the form:

```
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet dhcp
    pre-up modprobe mac80211
    pre-up modprobe cfg80211
    pre-up insmod /lib/modules/rtl8189ftv.ko
    pre-up wpa_passphrase "SSID" "PASSWORD" >/tmp/wpa_supplicant.conf
    pre-up sed -i '2i \\tscan_ssid=1' /tmp/wpa_supplicant.conf
    pre-up sleep 1
    pre-up wpa_supplicant -B -D nl80211 -i wlan0 -c/tmp/wpa_supplicant.conf
    post-down killall -q wpa_supplicant
    
  
#source-dir /etc/network/interfaces.d
```

Save your changes (make sure you did everything right) and reboot your camera. The network should appear. Log in to the web interface and complete other settings, like admin password, ssh, tome zone a.o.

In addition, in the web interface, enter the _Majestic --> ISP_ section and set the **Block count** parameter to **1**

#### Fix Majestic Streamer

Login to the camera console via SSH or via UART. How to use SSH is written [here](https://github.com/OpenIPC/wiki/blob/master/en/faq.md#how-to-sign-in-into-camera-via-ssh)

At the first, disable HLS
```
cli -s .hls.enabled false
```
Then set some variables: 
```
fw_setenv bootargs 'mem=34M@0x0 rmem=30M@0x2200000 console=ttyS1,115200n8 panic=20 root=/dev/mtdblock3 rootfstype=squashfs init=/init mtdparts=jz_sfc:256k(boot),64k(env),3072k(kernel),10240k(rootfs),-(rootfs_data) nogmac'
```
And rebbot your device: `reboot`
Now the video should work.

#### Write the path to the storage
In the web interface, select Majestic --> Recording and write the path to the storage. Set the field:
```
/mnt/mmcblk0p1/%Y/%m/%d/%H.mp4
```
Reboot and make sure that the camera is recording video to the memory card.

#### Night mode
Set up night mode as shown in the screenshot. Pay attention to the field values!
![photo_2023-03-12_21-16-53](https://user-images.githubusercontent.com/88727968/224554161-4f69f333-c3ef-4ed0-8f04-5c504bec5009.jpg)

