#!/bin/bash

#Definicion colores echo -e
RED='\033[1;31m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' #No color

######################################### FUNCIONES #######################################################
# Función print help
help()
{
	echo "Usage: $0 [options]
		-d  | --hdmi    HDMI boot mode
		-v  | --vnc     VNC boot mode
		-h  | --help"
    	exit 2
} 

# Función para comprobar permisos
check_root()
{
	if  [ $(id -u) -ne 0 ]
	then
		echo -e "${YELLOW}ERROR: This script should be executed with ${RED}sudo${YELLOW}!"
		exit 1
	fi
}

# Función para modo HDMI
HDMI_mode()
{
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
        exit 1
    fi

echo -e "${YELLOW}"
wc -l /etc/X11/xorg.conf
num_lineas=$(wc -l < "/etc/X11/xorg.conf")

if [ $num_lineas = 30 ] # Change this number if adding/removing lines in xorg.conf
then
	echo -e "${GREEN}Success!"
else
	echo -e "${RED}ERROR!"
	exit 1
fi

}

# Función para modo VNC
VNC_mode()
{
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
	exit 1
fi

echo -e "${YELLOW}"
wc -l /etc/X11/xorg.conf
num_lineas=$(wc -l < "/etc/X11/xorg.conf")

if [ $num_lineas = 35 ] # Change this number if adding/removing lines in xorg.conf
then
	echo -e "${GREEN}Success!"
else
	echo -e "${RED}ERROR!"
	exit 1
fi
}
###########################################################################################################

# Ensure that the script is executed with with privileges
check_root

# More info for getopt here (https://www.man7.org/linux/man-pages/man1/getopt.1.html)
SHORT=v,d,h         # If followed by : it expects an argument
LONG=vnc,hdmi,help  # If followed by : it expects an argument
OPTS=$(getopt -n prepare --options $SHORT --longoptions $LONG -- "$@")
if [ $? -ne 0 ]
then
	echo "ERROR: Error parsing arguments!"
	exit 3
fi


case "$1" in
    -v | --vnc )
        echo -e "${RED}Enabling VNC..."
        VNC_mode
        #shift 2 # shift removes arguments from the beginning of the argument list
        ;;

    -d | --hdmi )
        echo -e "${RED}Enabling HDMI..."
        HDMI_mode
        #shift 2
        ;;

    -h | --help)
        help
        ;;

    --)
        #shift;
        ;;

    *) # Default
        echo "Unexpected option: $1"
        help
        ;;
esac


echo -e "${RED}Reboot in 5s, (ctrl + C) to cancel reboot...${NC}"

sleep 5

echo -e "${RED}Rebooting..."
sudo reboot
