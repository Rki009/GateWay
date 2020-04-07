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


gateway=`ip r | grep default | cut -d ' ' -f 3`
printf "Ping Gateway: $gateway\n"

ping -q -w 1 -c 1 $gateway >/dev/null 2>/dev/null && echo Gateway - Ok! || echo Gateway - ERROR!
# ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo ok || echo error


printf "Loop forever ... ^C to exit\n"
# disable [mmc0] trigger (control)
sudo bash -c "echo none >/sys/class/leds/led0/trigger"
# Red LED - Off
sudo bash -c "echo 0 >/sys/class/leds/led1/brightness"

while [ 1 ]; do
	isDaylight
	gateway=`ip r | grep default | cut -d ' ' -f 3`
	if [ -z "$gateway" ]; then
		printf "Gateway - Down!\n"
		# Green LED - Off
		sudo bash -c "echo 0 >/sys/class/leds/led0/brightness"
	else
		printf "Gateway - Ok!\n"
		# Green LED - On
		sudo bash -c "echo $daylight >/sys/class/leds/led0/brightness"
	fi
	sleep 1
done

