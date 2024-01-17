#!/bin/bash

echo "Applying VINO Configuration..."
bash -c "mkdir -p /home/usuario/.config/autostart /home/usuario/.config/dconf"
bash -c "chown -R usuario /home/usuario/.config"
bash -c "cp /usr/share/applications/vino-server.desktop /home/usuario/.config/autostart"

echo "Executing gsettings..."
sudo -Hu usuario dbus-launch gsettings set org.gnome.Vino prompt-enabled false
sudo -Hu usuario dbus-launch gsettings set org.gnome.Vino require-encryption false
sudo -Hu usuario dbus-launch gsettings set org.gnome.Vino authentication-methods "['vnc']"
sudo -Hu usuario dbus-launch gsettings set org.gnome.Vino vnc-password $(echo -n "usuario"|base64)

echo "Configuration finished"
