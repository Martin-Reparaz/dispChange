#!/bin/bash

echo "Applying VINO Configuration..."
bash -c "mkdir -p /home/$USER/.config/autostart /home/$USER/.config/dconf"
bash -c "chown -R $USER /home/$USER/.config"
bash -c "cp /usr/share/applications/vino-server.desktop /home/$USER/.config/autostart"

echo "Executing gsettings..."
sudo -Hu $USER dbus-launch gsettings set org.gnome.Vino prompt-enabled false
sudo -Hu $USER dbus-launch gsettings set org.gnome.Vino require-encryption false
sudo -Hu $USER dbus-launch gsettings set org.gnome.Vino authentication-methods "['vnc']"
sudo -Hu $USER dbus-launch gsettings set org.gnome.Vino vnc-password $(echo -n "$USER"|base64)

echo "Configuration finished"
