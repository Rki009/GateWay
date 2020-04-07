# Raspberry Pi Internet Gateway Monitor Script

gateway.sh
- Bash script to verify a Raspberry Pi is connected to an Internet gateway
- It will turn of the RED power LED and indicate connectivity on the GREEN LED
- For ease of use it will also disable the GREEN LED indicator at night
- Add to /etc/rc.local to run on boot:
    /home/pi/Scripts/gateway.sh >/dev/null 2>/dev/null &
Aurhor: Ron K. Irvine
