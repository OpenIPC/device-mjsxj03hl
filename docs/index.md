## OpenIPC for Xiaomi MJSXJ03HL (UNDER CONSTRUCTION!!!) 
[Версия на русском языке](https://github.com/OpenIPC/device-mjsxj03hl/blob/master/docs/ru_index.md)
![Изображение](https://user-images.githubusercontent.com/88727968/222164240-66044bf1-16da-4ea2-af38-6fd3d3fb1b92.png)

Attention! Any changes you make will void your warranty for this device! The author is not responsible for any damage resulting from any actions of the user!

### Connecting UART adapter

We will need:

- Computer with USB port 
- Tester or voltmeter
- UART adapter 3,3V , like this

![изображение](https://user-images.githubusercontent.com/88727968/222174358-5203eb83-14ce-4f55-89bd-24775af82599.png)

All steps will be shown on Linux OS, if your OS is different, please refer to specific UART setup [instructions on your OS.](https://wiki.openipc.org/en/installation.html#step-3-connect-to-uart-port-of-your-camera)

Operating procedure:
1) Take a close look at the UART adapter. Find pins `GND`,`TX`,`RX`. If your adapter supports the function of selecting the operating voltage, make sure that it is set to 3.3V!
2) Using a tester (voltmeter), make sure that your UART adapter outputs 3.3V. To do this, take measurements between the contacts `GND` and `TX`, as well as `GND` and `RX`. Do not use the adapter if the voltage value is 5V! This will kill your camera!
3) Connect the UART adapter to your computer USB port. You need to find out the mount point of the adapter in your operating system.
4) Use terminal. Run the `lsusb` command and carefully examine the output. Find your UART adapter.
5) Use terminal. Run the command `dmesg | grep attached` from superuser. Compare the output of both commands and find the adapter mount point. For example, use the screenshot below: ![Screenshot_20230301_210433](https://user-images.githubusercontent.com/88727968/222186693-932e241c-5f92-4876-b4de-e51271ea6ae9.png)
6) So, we got that our device is mounted at `/dev/ttyUSB0`. In your case, the mount address may be different. We will use this address when connecting via UART. Be careful, when connecting several such devices, as well as when disconnecting incorrectly, the mount address may change.


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

### Discovering
Examine the camera carefully, find the necessary elements, because in the next steps we will have to physically interact with some of them.
The manufacturer may change some components of the device without notifying consumers. For this reason, two cameras released at different times may have different hardware and different software. Therefore, once again carefully study the components, make sure that they correspond to those indicated in this manual. If you have any questions, please contact our [Telegram channel](https://t.me/OpenIPC)

##### Main board (front view)
![IMG_20210904_194002](https://user-images.githubusercontent.com/88727968/222473262-913af0d1-0fee-4ae6-843f-256784381163.jpg)Main board (front view)

The most important part for us on it is the memory chip.
##### Memory chip 
![IMG_20210904_194034](https://user-images.githubusercontent.com/88727968/222473270-dfb08412-0019-4a57-aecc-3820421263e8.jpg)Memory chip on it.

It has a numerical-alphabetic marking. Make sure the chip on your board has a similar marking! The number 128 means the number of bits of memory. 128/8=16, so our memory is 16 MB. You need to choose the firmware for this type of memory!
##### Main board (rear view)
![IMG_20210904_194151](https://user-images.githubusercontent.com/88727968/222473288-c3efcdc6-2691-452f-aebb-9ab1789d4d2d.jpg)Main board (rear view)

This is where the wireless module, CPU, and various other components are located.

##### CPU
![IMG_20210904_194132](https://user-images.githubusercontent.com/88727968/222473285-9c00e6d9-f585-4481-a48b-867b0c1f3a85.jpg)CPU

In our case, it has a numerical-alphabetic marking. Ingenic T31N. The letter N is a series. It is listed in the second row. [More](https://wiki.openipc.org/en/installation.html#step-1-determine-the-system-on-chip)
