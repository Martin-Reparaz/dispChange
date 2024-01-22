# CHANGEDISP SCRIPT
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

## Layout rearranging script
Depending on the vino versions and the platform you are using, sometimes despite the correct keyboard layout is being selected, in reality it doesnt match.
For this purpose this script was created, by executing it using `./layout_rearrange.sh` it will change to the spanish layout.
