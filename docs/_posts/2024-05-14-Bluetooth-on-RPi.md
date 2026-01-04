---
layout: post
title:  "Raspberry Pi Zero: How to send and receive Files from other Devices using Bluetooth"
date:   2024-05-13 16:31:42 +0200
tags: ["Computer Science"]
abstract: "For the Oskam, which includes a Raspberry Pi Zero W, I wanted to be able to send pictures to it for printing, receive pictures from it, and send text commands to it using Bluetooth. To accomplish this, I needed to set up and implement Bluetooth communication features. This turned out to be quite complicated due to the numerous options and outdated resources available. In this post, I will walk you through the steps I took to get it running."
short-abstract: 'How to configure Bluetooth on Raspberry Pi Zero W for exchanging files and data with other devices'
title-image: 'Bluetooth/title-image'
read_time: 4
---

The code was used to configure and utilize Bluetooth on the Oskam. To optimize boot time, I followed suggestions from [a post on Raspberry Pi Geek](https://www.raspberry-pi-geek.de/ausgaben/rpg/2020/06/die-boot-zeit-von-raspbian-optimieren/), which disables Bluetooth on startup. As a result, some of the service files might be in different locations for you, or you might not need to manually start Bluetooth as I did. Please note that I am writing this several months after implementing it, so some details might be missing. Feel free to reach out to me if you encounter any issues.

On my device, the output of `systemctl list-unit-files` for checking the state of services is:

```bash
...
bluetooth.service                      disabled        enabled
bluetooth.target                       static          -
obexpush.service                       enabled         enabled
hciuart.service                        disabled        enabled
...
```

# Install
```bash
python -m pip install -U watchdog
sudo apt-get install bluetooth libbluetooth-dev
sudo apt-get install obexpushd
```

I also found `sudo python3 -m pip install pybluez` in my `.bash_history`, but this step should not be necessary for this implementation.

# Configuration
Add the following lines to `/etc/rc.local`:
```bash
sudo bluetoothctl power on
sudo bluetoothctl pairable on
# sudo bluetoothctl discoverable on # bluetooth not activated by default
```

Enable the following settings in `/etc/bluetooth/main.conf`
```bash
DiscoverableTimeout = 0 # stay discoverable forever
AlwaysPairable = true
[Policy]
AutoEnable=false
```

Set content of `/etc/systemd/system/obexpush.service` to
```bash
[Unit]
Description=OBEX Push service
After=bluetooth.service
Requires=bluetooth.service

[Service]
ExecStart=/usr/bin/obexpushd -B23 -o <BLUETOOTH DIR> -n
Restart=always
User=philip

[Install]
WantedBy=multi-user.target
```

, where `<BLUETOOTH DIR>` is a directory in which you want to store incoming files. I set this to `/home/philip/main/bluetooth`. Make sure the directory exists.


Set content of `/usr/lib/systemd/system/bluetooth.service` to
```bash
[Unit]
Description=Bluetooth service
Documentation=man:bluetoothd(8)
ConditionPathIsDirectory=/sys/class/bluetooth

[Service]
Type=dbus
BusName=org.bluez
ExecStart=/usr/libexec/bluetooth/bluetoothd -C
NotifyAccess=main
#WatchdogSec=10
#Restart=on-failure
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
LimitNPROC=1
ProtectHome=true
ProtectSystem=full

[Install]
WantedBy=bluetooth.target
Alias=dbus-org.bluez.service
```

Be aware that the service files may be located in `/usr/lib/systemd/user/`, `/etc/systemd/system/`, `/usr/lib/systemd/system/`, or other directories, depending on your settings. This can vary based on whether the services are configured to start after booting.

I would advise rebooting after changing the service settings. You can also use
```bash
sudo systemctl stop obexpush.service
sudo systemctl start obexpush.service
systemctl daemon-reload
```
for restarting individual services and
```bash
sudo systemctl status obexpush.service
```
for getting their status.

To get all running services use
```bash
systemctl --type=service --state=running
```

To change the bluetooth name of your RasPi run `bluetoothctl system-alias <NEW NAME>` in the terminal once.


# Test Bluetooth

To view all paired devices:
```bash
bluetoothctl paired-devices
```

To unpair/ delete a device:
```bash
bluetoothctl remove aa:bb:cc:dd:ee:ff
```

To turn Bluetooth on:
```bash
sudo systemctl start bluetooth
sudo hciconfig hci0 piscan
bluetoothctl discoverable on
bluetoothctl agent NoInputNoOutput
sudo obexpushd -B23 -o ~/transfer -n #-a

sudo bluetoothctl power on
sudo bluetoothctl discoverable on
sudo bluetoothctl pairable on
```

, where `-B23` changes bluetooth channel to 23 ([see forums.raspberrypi.com](https://forums.raspberrypi.com/viewtopic.php?t=146328))

To turn on Bluetooth in Python, first `import subprocess`, then call
```python
subprocess.call(['sudo', 'systemctl', 'start', 'bluetooth.service'])
subprocess.call(['sudo', 'systemctl', 'start', 'hciuart.service'])
subprocess.call(['sudo', 'systemctl', 'start', 'bthelper@hci0.service'])
subprocess.call(['sudo', 'hciconfig', 'hci0', 'up'])
subprocess.call(['sudo', 'hciconfig', 'hci0', 'piscan'])
subprocess.call(['bluetoothctl', 'power', 'on'])
subprocess.call(['bluetoothctl', 'discoverable', 'on'])
subprocess.call(['bluetoothctl', 'pairable', 'on'])
```

To turn it back off, I call
```python
subprocess.call(['bluetoothctl', 'discoverable', 'off'])
subprocess.call(['sudo', 'hciconfig', 'hci0', 'noscan'])
subprocess.call(['sudo', 'systemctl', 'stop', 'bluetooth.service'])
```
This does, however, not disable all the services necessary for Bluetooth anymore. I primarily keep them disabled at boot to achieve a faster startup time, rather than to reduce energy consumption.

After you have turned it on, you can pair it with your Smartphone. Notice that you don't need to stay paired with it afterward to send or receive files/ send commands. Sometimes it needs multiple attempts when sending files for the first time.

# Send files from the Raspberry Pi to other devices
Send files from the device to your smartphone or other devices:
```bash
bt-obex -p <BLUETOOTH ADRESS> <FILE>
```

The <BLUETOOTH ARESS> of the target device is a unique 48-bit identifier assigned to each Bluetooth device, for example `aa:bb:cc:dd:ee:ff`. I hardcoded the address of my smartphone, but you can use [`pybluez`](https://github.com/pybluez/pybluez)  to obtain the addresses of all discoverable devices nearby.

You can achieve this from Python as follows:
```python
subprocess.call(['bt-obex', '-p', '<BLUETOOTH ADRESS>',  '<FILE>'])
```

# React to incoming files
To handle incoming files via Bluetooth, you will need a FileSystemEventHandler. This handler manages files written to the directory `<BLUETOOTH DIR>`, where you want to store incoming files. Ensure this directory is the same one you configured in `/etc/systemd/system/obexpush.service`.

```python
from watchdog.events import FileSystemEventHandler
from os import remove

class MyHandler(FileSystemEventHandler):
    def on_closed(self, event):
        file = (event.src_path).strip()
        # DO THINGS WITH THE FILE HERE
        
        # Optional: remove the received file after processing
        remove((event.src_path).strip())
```

You can then start listening like so:

```python
from watchdog.observers import Observer

# For observing files that were written to the folder:
observer = Observer()
observer.schedule(MyHandler(), path='<BLUETOOTH DIR>', recursive=False)
observer.start()
```

and stop listening like by calling `observer.stop()`

# React to incoming text commands

To handle incoming data or commands from a stream (in addition to files automatically handled by `obexpush`), you will also need a Bluetooth listener. I had to run this listener in a separate thread, as it would otherwise block the GUI of the Oskam.

```python
import bluetooth
import asyncio
import time
import threading

class ThreadStoppedException(Exception):
    pass

class SerialBluetoothListener(threading.Thread):
    """Thread class with a stop() method. The thread itself has to check
    regularly for the stopped() condition."""
    
    client_sock = None
    server_sock = None
    thread = None
    port = None
    uuid = None

    def __init__(self,  *args, **kwargs):
        super(SerialBluetoothListener, self).__init__(*args, **kwargs)
        self._stop_event = threading.Event()
        self.server_sock=bluetooth.BluetoothSocket( bluetooth.RFCOMM )
        self.server_sock.bind(("", 8))
        self.server_sock.listen(1)
        self.server_sock.settimeout(5.0)
        self.port = self.server_sock.getsockname()[1]
        self.uuid = "A82EFA21-AE5C-3DDE-9BBC-F16DA7B16C5A"
        
        bluetooth.advertise_service( self.server_sock,
                           "OskamSerialService",
                           service_id = self.uuid,
                           service_classes = [ self.uuid, bluetooth.SERIAL_PORT_CLASS ],
                           profiles = [ bluetooth.SERIAL_PORT_PROFILE ])
        
        print("SerialBluetoothListener initialized")

    def stop(self):
        self._stop_event.set()

    def stopped(self):
        return self._stop_event.is_set()
    
    def run(self):
      try:
        print("handle_serial_messages initialized", flush=True)
        print("Waiting for connection on RFCOMM channel %d" % self.port)
        while self.client_sock == None:
          try:
            self.client_sock, client_info = self.server_sock.accept()
            print("Accepted connection from ", client_info)
          except bluetooth.btcommon.BluetoothError:
            pass
          if self.stopped():
            raise ThreadStoppedException
        self.client_sock.settimeout(5.0)
        while True:
          try:
            data = self.client_sock.recv(1024)
            if len(data) == 0: break
            print("received [%s]" % data)
            # REACT TO INCOMING DATA HERE
          except bluetooth.btcommon.BluetoothError:
            pass
          if self.stopped():
            raise ThreadStoppedException
      except ThreadStoppedException:
        print('Thread was stopped!')
      finally:
        print('closing resources')    
        if self.server_sock is not None:
          self.server_sock.close()    
        if self.client_sock is not None:
          self.client_sock.close() 
```

You can start listening to incoming data by calling

```python
from SerialBluetoothListener import SerialBluetoothListener
# For starting the bluetooth listener:
serial_listener = SerialBluetoothListener()
serial_listener.start()
```

and stop it using `serial_listener.stop()`.

For sending commands to the Raspberry Pi from my Smartphone, I used the [Serial Bluetooth Terminal Android App](https://play.google.com/store/apps/details?id=de.kai_morich.serial_bluetooth_terminal&hl=de&gl=US).