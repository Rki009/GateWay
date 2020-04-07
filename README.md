# Raspberry Pi Internet Gateway Monitor Script
I have a Raspberry Pi 4 connected to a WiFi Access Point. The raspberry Pi is set up as a bridge from wlan0 to eth0. A WiFi router is connect via its WAN ethernet port to the Raspberry Pi eth0. Complicated, yes, but it allows devices to be connected to the second WiFi network independent of the internet WiFi Access Point. The gateway.sh script allows me to monitor the WiFi Access Point connection and thus the connection of the secondary network to the internet at a glance.

##gateway.sh
- Bash script to verify a Raspberry Pi is connected to an Internet gateway
- It will turn of the RED power LED and indicate connectivity on the GREEN LED
- For ease of use it will also disable the GREEN LED indicator at night
- Add to */etc/rc.local* to run on boot:
```
/home/pi/Scripts/gateway.sh >/dev/null 2>/dev/null &
```
Author: Ron K. Irvine, 2020.
