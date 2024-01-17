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
	# Copyright (c) 2017, NVIDIA CORPORATION. All rights Reserved.
	#
	# This is the minimal configuration necessary to use the Tegra driver.
	# Please refer to the xorg.conf man page for more configuration
	# options provided by the X server, including display-related options
	# provided by RandR 1.2 and higher.

	# Disable extensions not useful on Tegra.
	Section "Module"
	    Disable "dri"
	    SubSection "extmod"
	    Option "omit xfree86-dga"
	    EndSubSection
	EndSection

	Section "Device"
	    Identifier "Tegra0"
	    Driver "nvidia"
	    Option "AllowEmptyInitialConfiguration" "true"
	EndSection

	Section "Screen"
	    Identifier "Default Screen"
	    Monitor "Configured Monitor"
	    Device "Tegra0"
	    SubSection "Display"
		Depth 24
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
elif [ $num_lineas = 30 ] # Change this number if adding/removing lines in xorg.conf
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
