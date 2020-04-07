#!/bin/bash
#	(C) Ron K. Irvine, 2020. All rights reserved.

# daylight - daylight hours; 8:00 to 11pm
# note sting compare is limited to EQ, GT and LT
isDaylight() {
    currenttime=$(date +%H:%M)
    if [[ "$currenttime" > "07:59" ]] && [[ "$currenttime" < "23:00" ]]; then
        daylight=1
    else
        daylight=0
    fi
    printf "$currenttime: Daylight = $daylight\n"
}


# get the gateway's IP address; empty string if no gateway
gateway=`ip r | grep default | cut -d ' ' -f 3`
if [ -z "$gateway" ]; then
	printf "Gateway: Not Found...\n"
else
	printf "Ping Gateway: $gateway\n"
	ping -q -w 1 -c 1 $gateway >/dev/null 2>/dev/null && echo Gateway - Ok! || echo Gateway - ERROR!
fi

# disable [mmc0] trigger (control) for Green LED
sudo bash -c "echo none >/sys/class/leds/led0/trigger"
# disable Red power LED - 0 = Off
sudo bash -c "echo 0 >/sys/class/leds/led1/brightness"

printf "Loop forever ... ^C to exit\n"
while [ 1 ]; do
	isDaylight
	gateway=`ip r | grep default | cut -d ' ' -f 3`
	if [ -z "$gateway" ]; then
		printf "Gateway - Down!\n"
		# Green LED - 0 = Off
		sudo bash -c "echo 0 >/sys/class/leds/led0/brightness"
	else
		printf "Gateway - Ok!\n"
		# Green LED - 1 = On
		sudo bash -c "echo $daylight >/sys/class/leds/led0/brightness"
	fi
	sleep 1
done

