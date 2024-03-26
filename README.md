# DISPCHANGE SCRIPT

## Setup
```
sudo apt update
sudo apt-get install -y vino
git clone https://github.com/Martin-Reparaz/dispChange.git
cd dispChange
sudo chmod +x conf_vnc_server.sh dispMode.sh layout_rearrange.sh
./conf_vnc_server.sh
```
## Configuration script
This script configures the vino-server for jetson platforms. It is recomended to use it before starting to use the vnc server.
Execute it by using: `sudo ./conf_vnc_server.sh`.

## Script for changing between HDMI and VNC conection on Jetson platforms
This script must be used with **sudo** privileges.
To run the script simply use the following command:

`sudo ./dispMode.sh --mode`
- **--hdmi** for hdmi conection. `sudo ./dispMode.sh --hdmi`.
- **--vnc** for vnc conection. `sudo ./dispMode.sh --vnc`.
- **--help** to show script use instructions. `sudo ./dispMode.sh --help`.

**NOTE:** --hdmi mode allows both the HDMI and VNC connection. So, if you´re planning to use both of them just execute the command once with the --hdmi option. 

$${\color{red}**CAUTION!** /space After /space script /space completion, /space if /space no /space ctrl+C /space is /space pressed, /space the /space board /space will /space automatically /space reboot /space after /space 5s.}$$

## Layout rearranging script
Depending on the vino versions and the platform you are using, sometimes despite the correct keyboard layout is being selected, in reality it doesnt match.
For this purpose this script was created, by executing it using `./layout_rearrange.sh` it will change to the spanish layout.

## Accessibility
To be able to run these scripts from anywhere in your file system, run the following commands inside the dispChange directory:
```
echo "export PATH=$PATH:$(pwd)" >> ~/.bashrc
cd ~
source .bashrc
```
