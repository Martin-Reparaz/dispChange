#!/bin/bash

RED='\033[1;31m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
GREEN='\033[1;32m'
NC='\033[0m'

echo -e "${YELLOW}Changing configuration...${PURPLE}"
truncate -s 0 /etc/X11/xorg.conf

if [ $? = 0 ]
then
	tee -a /etc/X11/xorg.conf <<- EOF
	# This xorg configuration file is meant to be used
	# to start a dummy X11 server.
	# For details, please see:
	# https://www.xpra.org/xorg.conf

	# Here we setup a Virtual Display of 1920x1080 pixels

	Section "Device"
	    Identifier "Configured Video Device"
	    Driver "dummy"
	    #VideoRam 4096000
	    #VideoRam 256000
	    VideoRam 16384
	EndSection

	Section "Monitor"
	    Identifier "Configured Monitor"
	    HorizSync 5.0 - 1000.0
	    VertRefresh 5.0 - 200.0
	    #Modeline "1600x900" 33.92 1600 1632 1760 1792 900 921 924 946
	    Modeline "1920x1080" 173.00  1920 2048 2248 2576  1080 1083 1088 1120 # by using "cvt 1920 1080" in command line
	EndSection

	Section "Screen"
	    Identifier "Default Screen"
	    Monitor "Configured Monitor"
	    Device "Configured Video Device"
	    DefaultDepth 24
	    SubSection "Display"
		Viewport 0 0
		Depth 24
		#Virtual 1600 900
		Virtual 1920 1080
	    EndSubSection
	EndSection
	EOF
else
	echo -e "${RED}ERROR!"
	echo -e "${YELLOW}Execute it with ${RED}sudo${YELLOW}!"
	exit 1
fi

echo -e "${YELLOW}"
wc -l /etc/X11/xorg.conf
num_lineas=$(wc -l < "/etc/X11/xorg.conf")

if [ $num_lineas = 0 ]
then
	echo -e "${YELLOW}Execute with ${RED}sudo${YELLOW}!"
	echo ""
	exit 1
elif [ $num_lineas = 35 ] # Change this number if adding/removing lines in xorg.conf
then
	echo -e "${GREEN}Success!"
else
	echo -e "${RED}ERROR!"
	exit 1
fi

#echo -e "${YELLOW}El número de líneas en el archivo es: $num_lineas"
echo -e "${RED}Reboot in 5s, (ctrl + C) to cancel reboot...${NC}"

sleep 5

echo -e "${RED}Rebooting..."
sudo reboot
