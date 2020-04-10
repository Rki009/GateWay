#!/bin/bash
#	(C) Ron K. Irvine, 2020. All rights reserved.
# gateway.sh
#	Script to monitor the Raspberry Pi's WiFi Internet gateway.
#	Red LED:
#		Off	- trurned off
#	Green LED:
#		Off	- No Internet Gateway
#		On	- Gateway detected, daytime hours
#		Blink	- Gateway detected, night hours 
#

# Options
offAtNight=1

# daytime - daytime hours; 07:30 to 23:00
# don't foget the leading 0 on the hour "hh:mm", 5 characters
# note sting compare is limited to EQ, GT and LT
# so LE (less than or equal) is the same as NOT GT (not greater than)
isDaylight() {
    currenttime=$(date +%H:%M)
    if [[ ! "$currenttime" < "07:30" ]] && [[ "$currenttime" < "23:00" ]]; then
        daytime=1
    else
        daytime=0
    fi
    printf "$currenttime: Daytime = $daytime\n"
}


# use the 'ip route' command to get the gateway's IP address
#	an empty string if no gateway
gateway=$(ip route | grep "default via" | cut -d ' ' -f 3)
device=$(ip route | grep "default via" | cut -d ' ' -f 5)
if [ -z "$gateway" ]; then
	printf "Gateway: Not Found...\n"
else
	printf "Ping Gateway: $gateway - $device\n"
	ping -q -w 1 -c 1 $gateway >/dev/null 2>/dev/null && echo Gateway - Ok! || echo Gateway - ERROR!
fi

# led0: Green Led - default usage is flash access indicator [mmc0]
led0=/sys/class/leds/led0
# disable [mmc0] trigger (control) for Green LED
sudo bash -c "echo none >$led0/trigger"

#led1: Red LED - default power on/off indicator
led1=/sys/class/leds/led1
# disable Red power LED - 0 = Off
sudo bash -c "echo 0 >$led1/brightness"

printf "Loop forever ... ^C to exit\n"
while [ 1 ]; do
	isDaylight
	gateway=$(ip route | grep "default via" | cut -d ' ' -f 3)
	if [ -z "$gateway" ]; then
		printf "Gateway - Down!\n"
		# Green LED - 0 = Off
		sudo bash -c "echo 0 >$led0/brightness"
	else
		printf "Gateway $gateway - Ok!\n"
		# Green LED - 1 = On
		if [ "$offAtNight" -eq "1" ]; then
			sudo bash -c "echo $daytime >$led0/brightness"
		elif [ "$daytime" -eq "1" ]; then
			# daytime - GREEN LED - On
			sudo bash -c "echo 1 >$led0/brightness"
		else
			# at night - just a short blink of the GREEN LED
			sudo bash -c "echo 1 >$led0/brightness"
			sleep 0.001
			sudo bash -c "echo 0 >$led0/brightness"
 		fi
	fi
	sleep 3
done

