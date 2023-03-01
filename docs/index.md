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
