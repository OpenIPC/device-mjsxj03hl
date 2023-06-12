# OpenIPC for Xiaomi MJSXJ03HL 
[Версия на русском языке](https://github.com/OpenIPC/device-mjsxj03hl/blob/master/Manual_ru.md)

![Изображение](https://user-images.githubusercontent.com/88727968/222164240-66044bf1-16da-4ea2-af38-6fd3d3fb1b92.png)

Attention! Any changes you make will void your warranty for this device! The author is not responsible for any damage resulting from any actions of the user!
_______________
## Preparation
### Connecting UART adapter

We will need:

- Computer with USB port 
- Tester or voltmeter
- UART adapter 3,3V , like this

![изображение](https://user-images.githubusercontent.com/88727968/222174358-5203eb83-14ce-4f55-89bd-24775af82599.png)

All steps will be shown on Linux OS, if your OS is different, please refer to specific UART setup [instructions on your OS.](https://github.com/OpenIPC/wiki/blob/master/en/installation.md#step-3-connect-to-uart-port-of-your-camera)

Operating procedure:
1) Take a close look at the UART adapter. Find pins `GND`,`TX`,`RX`. If your adapter supports the function of selecting the operating voltage, make sure that it is set to 3.3V!
2) Using a tester (voltmeter), make sure that your UART adapter outputs 3.3V. To do this, take measurements between the contacts `GND` and `TX`, as well as `GND` and `RX`. Do not use the adapter if the voltage value is 5V! This will kill your camera!
3) Connect the UART adapter to your computer USB port. You need to find out the mount point of the adapter in your operating system.
4) Use terminal. Run the `lsusb` command and carefully examine the output. Find your UART adapter.
5) Use terminal. Run the command `dmesg | grep attached` from superuser. Compare the output of both commands and find the adapter mount point. For example, use the screenshot below: ![Screenshot_20230301_210433](https://user-images.githubusercontent.com/88727968/222186693-932e241c-5f92-4876-b4de-e51271ea6ae9.png)
6) So, we got that our device is mounted at `/dev/ttyUSB0`. In your case, the mount address may be different. We will use this address when connecting via UART. Be careful, when connecting several such devices, as well as when disconnecting incorrectly, the mount address may change.
_____________________________

### Disassembling

Currently, the camera only supports flashing via UART adapter, so we need to disassemble the camera to perform the operations. **Remember that this will void your manufacturer's warranty!**

We will need:
- The device
- Hairdryer or another heater
- A flat, thin object, such as a utility knife
- Long thin x-type screwdriver
- Accuracy

So, let's go:
1) Gently warm up the front of the camera (where the lens is)
2) Using a utility knife or other pointed object, carefully pry off the front part. Remember, there are important wires under the front, ***don't damage them!***
3) Working in a circle, carefully separate the front part from the camera body. ***Remember that it is wired to the main board of the camera!***
4) Under the bottom you will find two screws that need to be removed. After that, carefully separate the halves of the camera body. Be careful not to hurt yourself or damage the connecting wires or parts of the camera!
5) Unscrew a few more screws, freeing the main board of the device. Also free the type C port
________________

### Discovering
Examine the camera carefully, find the necessary elements, because in the next steps we will have to physically interact with some of them.
The manufacturer may change some components of the device without notifying consumers. For this reason, two cameras released at different times may have different hardware and different software. Therefore, once again carefully study the components, make sure that they correspond to those indicated in this manual. If you have any questions, please contact our [Telegram channel](https://t.me/OpenIPC)

##### Main board (front view)
![IMG_20210904_194002](https://user-images.githubusercontent.com/88727968/222473262-913af0d1-0fee-4ae6-843f-256784381163.jpg "Main board (front view)")

The most important part for us on it is the memory chip.
##### Memory chip 
![IMG_20210904_194034](https://user-images.githubusercontent.com/88727968/222473270-dfb08412-0019-4a57-aecc-3820421263e8.jpg "Memory chip on it.")

It has a numerical-alphabetic marking. Make sure the chip on your board has a similar marking! The number 128 means the number of bits of memory. 128/8=16, so our memory is 16 MB. You need to choose the firmware for this type of memory!
##### Main board (rear view)
![IMG_20210904_194151](https://user-images.githubusercontent.com/88727968/222473288-c3efcdc6-2691-452f-aebb-9ab1789d4d2d.jpg "Main board (rear view)")

This is where the wireless module, CPU, and various other components are located. But the most important thing for us is the three contacts with a hole, located side by side in the upper right sector of the board. It is through them that we give control signals to the camera.

##### CPU
![IMG_20210904_194132](https://user-images.githubusercontent.com/88727968/222473285-9c00e6d9-f585-4481-a48b-867b0c1f3a85.jpg "CPU")

In our case, it has a numerical-alphabetic marking. Ingenic T31N. The letter N is a series. It is listed in the second row. [More](https://wiki.openipc.org/en/installation.html#step-1-determine-the-system-on-chip)
_________
### Connecting the camera and UART adapter

In order to connect the UART adapter to the camera board, you need to use the wires with terminals. They can come with a UART adapter. However, they can be replaced with similar ones. Similar connection types are found in a variety of electronics. The second end of the wire to the board should be soldered so that the contact does not disappear at the right time. Be careful when soldering, do not damage the circuit elements and do not short the contacts together!

![IMG_20210904_1941511](https://user-images.githubusercontent.com/88727968/222906480-dea0a59c-2dab-45e3-96fa-81cf335b745b.jpg)

Connect the wires coming from the UART adapter to the board as shown in the figure. If you did everything right, the camera will show the log during the boot. Let's check it out.

#### Checking the functionality of the terminal, camera and connection

First, we need to install a terminal program to send control commands from the camera and receive feedback. Linux has a fairly large number of terminals, you can choose the most convenient for you. Among them are **screen, picocom, minicom, cutecom**. The latter has a GUI.
Install the terminal program:
```sudo apt install <NAME>```
The commands will be given for the picocom program.
To get started, familiarize yourself with the program's capabilities and command syntax:
```picocom --help``` 
Connect the UART adapter and run the command in the terminal:
```
picocom -b 115200 /dev/ttyUSB0
```
where the `-b` option specifies the baudrate, and `/dev/ttyUSB0` is the mount point address we learned earlier.

If you did everything right, the program will write that the terminal is ready to work. Familiarize yourself with terminal control commands by pressing the key sequence `Ctrl+A Ctrl+H`. For a more detailed understanding of the terminal program, refer to the relevant manuals on the web.

If you power up the camera, you will see the boot log. Try pressing keys such as `Enter` and make sure that the terminal responds to them and sends events. If everything is done correctly, you can proceed to the next step.
____________

### Get access to the bootloader
Unfortunately, the MJSXJ03HL camera does not support boot interruption by sending a key combination. For this reason, boot interrupting and gaining access to the downloader console will be done by us manually. To do this, it will be necessary to close some contacts of the [memory chip](https://github.com/OpenIPC/device-mjsxj03hl#memory-chip).
For how to do this, read [here](https://github.com/OpenIPC/wiki/blob/master/en/help-uboot.md#shorting-pins-on-flash-chip).
Carefully study the above manual, find the memory chip and the necessary contacts, prepare what you will close the contacts with. All manipulations will have to be done quickly enough.
ATTENTION!!! You take full responsibility for your actions!
The following is the sequence of actions to gain access to the bootloader console:
1. Connect the camera to the UART adapter
2. Connect the UART adapter to the computer's USB port.
3. Launch the terminal on the computer, make sure it sees the UART adapter
4. Get ready to close the contacts
5. Apply power to the board
6. The download log should appear in the terminal window
7. Close the contacts of the memory chip (This must be done 0.5-1 sec after power is applied)
8. The download should abort. Contacts can be opened.
9. If you did everything correctly, the U-boot console will appear on the screen with a `>` symbol and the ability to enter.
10. Type `help` to list the commands present in the bootloader

Unfortunately, the manufacturer for this camera greatly limited the capabilities of U-boot, this will create a series of obstacles for us in the future until we flash U-boot from OpenIPC. But first we need to save the stock firmware of the camera.
__________
### Save the original firmware
Attention! Do not let this point! The backup of the factory firmware will allow you to restore the performance of the device, if suddenly something goes wrong.

We will need:
- Camera disassembled with connected UART
- Computer
- SD card with a capacity of at least 16 MB
It is first recommended to familiarize yourself with [the original article](https://github.com/OpenIPC/wiki/blob/master/en/help-uboot.md#saving-firmware-via-sd-card)

ATTENTION! During the following manipulations, all information from the SD card will be inaccessible, and the card itself cannot be used before formatting! All data, located on the map will be irrevocably lost!

The card must be inserted into the camera slot. The UART-adapter must be attached to the computer, and the terminal program is launched.

1) Interrupt the loading of the camera by closing the contacts, we get into the bootloader console.
2) If the SD card was inserted after the load interruption, perform `mmc rescan`
3) First, we clean the required space for recording a dump of the original firmware there:
```
mmc dev 0
mmc erase 0x10 0x8000
```
4) Now you need to copy the contents of the firmware from the flash memory chip into the RAM of the camera. To do this, clean the site of RAM, get access to the flash memory chip and copy the entire volume of flash memory into the purified space of RAM. Then save the copied data from RAM to the card. Insert the commands line-by-line!
```
mw.b 0x80600000 ff 0x1000000
sf probe 0
sf read 0x80600000 0x0 0x1000000
mmc write 0x80600000 0x10 0x8000
```
_where `0x80600000` - Load address of Ingenic T31N._

Remove the card from the camera and insert into the computer with the Linux operating system. Using the `dd` command, copy the data from the card to the binary file on the computer disk.
```
dd bs=512 skip=16 count=32768 if=/dev/sdc of=./fulldump.bin
```
_Attention! The mounting point of `sdc` may differ (sda, sdb), depending on the connected equipment of your computer ._
_______

## Flashing

### Firmware generation
**NOTE:  !Lite version recommended!** All the following manipulations are described for the Lite version

To obtain firmware and instructions, use [Automatic generator Instruction for our processor](https://openipc.org/cameras/Vendors/ingenic/socs/t31n)
Fill the required fields and indicate your MAC address. Like this:

![изображение](https://github.com/OpenIPC/device-mjsxj03hl/assets/88727968/e5b8e124-02bb-427e-a2c4-16b16575fce7)

Generate the firmware. Carefully study the page with firmware and instructions.
Unfortunately, the manufacturer did not add a TFTP program to the factory bootloader, therefore we will flash our firmware in parts and manually.
Go to the section **Alternatively, flash OpenIPC Firmware by its parts** and download the bootloader's binary file to the link. You should get a binary file **u-boot-t31n-universal.bin**. Do not close the page with the instructions. We will need it later.

Place the resulting file on your SD card. **Attention!** If you use the same memory card as in the last paragraph, format it in MBR (MS-DOS). Do not use GPT! If you use Windows OS, this is the most common formatting. Just connect the memory card and Windiows yourself will offer it to format it.

### UBoot flashing
So, we have our camera connected to the UART, in the slot of which a memory card is inserted, formatted in Fat32 with a bootloader binary file on it.
Just in case, let's do
```
mmc rescan
```
and additionally check that you did everything correctly
```
fatls mmc 0:1
```
Your memory card data should come out. If any errors come up, do not continue until they are fixed! Otherwise, flashing the camera will be possible only on special equipment.

At the beginning, we will enter the environment variables with the `setenv` command
```
setenv baseaddr 0x80600000
setenv flashsize 0x1000000
```
The factory bootloader does not support saving variables, so if the camera was rebooted, you will have to enter it again.

Now we proceed to the most crucial moment - U-Boot flashing. Insert commands line by line! Be careful that the commands do not return errors! Do not continue if something goes wrong, do not try to restart the camera, ask for help in our [Telegram channel](https://t.me/openipc)
```
mw.b ${baseaddr} 0xff 0x50000
sf probe 0
sf erase 0x0 0x50000
fatload mmc 0:1 ${baseaddr} u-boot-t31n-universal.bin
sf write ${baseaddr} 0x0 ${filesize}
```
If everything went well, then you now have a new bootloader from OpenIPC that supports all the necessary commands.
Command `reset` in the bootloader console, the camera will reboot. Camera loading can now be interrupted by pressing `Ctrl+C`
________________
### OpenIPC install

Now that we have a bootloader with the right set of commands, we can flash the rest of the firmware.
Go back to the instruction page we received in [Firmware generation](https://github.com/OpenIPC/device-mjsxj03hl#firmware-generation)
Next in the section **Flash OpenIPC Linux kernel and root filesystem**. Download the archive from the link _Download OpenIPC Firmware (Ultimate) bundle_
You will find 4 files in it: the root FS image and the kernel, as well as checksums for them. Unzip them to your memory card and place it in the camera slot.

Next:
1) Connect the UART, launch the terminal
2) We supply power to the camera and quickly stop the download by pressing `Ctrl+C`. Get into the bootloader console
3) Checking access to the memory card
```
mmc rescan
```
4) Enter environment variables and save them:
```
setenv baseaddr 0x80600000
setenv flashsize 0x1000000
saveenv
```
5) Reassign ROM partitions according to the size and type of flash memory. Despite the fact that we have 16Mb of memory, using this layout in combination with the Lite version will allow us to get more free space.
```
run setnor8m
```
6) Flash boot (Commands are entered line by line!)
```
mw.b 0x80600000 0xff 0x200000
fatload mmc 0:1 0x80600000 uImage.t31n
sf probe 0; sf lock 0;
sf erase 0x50000 0x200000; sf write 0x80600000 0x50000 ${filesize}
```
7) Flash rootfs (Commands are entered line by line!)
```
mw.b 0x80600000 0xff 0x500000
fatload mmc 0:1 0x80600000 rootfs.squashfs.t31n
sf probe 0; sf lock 0;
sf erase 0x250000 0x500000; sf write 0x80600000 0x250000 ${filesize}
```
8) We command `reset` and the camera reboots with the new firmware.

If you did everything right, the following will appear in the terminal window:
```
Welcome to OpenIPC
openipc-t31 login: 
```
Login as `root` , without password

![изображение](https://user-images.githubusercontent.com/88727968/223940074-c9f63e1a-b19c-4905-a7fb-66faca1aca52.png)

In the resulting input field, command
```
firstboot
```
**Congratulations on successfully installing OpenIPC!**
_____
## Tune-up
### Presetting

_ATTENTION! Use a separate SD card for basic settings or delete the contents of the **autoconfig** folder after this step!_

We will need:
- Computer with card reader
- Micro SD card
- Camera

_ATTENTION!!! After this procedure, all camera settings will be deleted!_
If this is unacceptable, or you do not have a microSD card - manually configure according to the [outdated version of the manual](https://github.com/OpenIPC/device-mjsxj03hl/blob/master/old_setting_up_en.md)

Download to your computer and extract the contents of the [flash](https://github.com/OpenIPC/device-mjsxj03hl/tree/master/flash) folder to a memory card.

The contents of the folder must be unpacked into the root directory, and the directory and file structure must be preserved!

Edit the **wlan0** file located in the path **~/autoconfig/etc/network/interfaces.d** - replace `SSID` and `PASSWORD` with the parameters of your access point.

Insert a memory card into the camera, turn on the power. The camera will automatically complete all the presets and reboot.

After these manipulations, the network should appear. You can log in to the web interface and continue setting up

**ATTENTION! Don't forget to remove the memory card and delete the _autoconfig_ folder or replace the memory card!**

### Finality
Now you can control the camera via SSH and Web interface. Carefully disconnect the wires from the board. Assemble the camera. Remember, the camera is easy to assemble, do not use force. Be careful not to damage your camera.

**Success in use OpenIPC!**
