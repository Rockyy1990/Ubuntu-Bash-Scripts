#!/bin/bash

echo ""
echo "----------------------------------------------"
echo "    ..Ubuntu LTS config after install..       "
echo "                                              "
echo "----------------------------------------------"
sleep 1

read -p "Read this script before execute!!"

sudo apt autoremove -y apport-gtk apport apport-core-dump-handler apport-symptoms

echo "Remove snap from Ubuntu"
sleep 2
sudo snap remove firefox
sudo snap remove chromium
sudo systemctl disable --now snapd
sudo apt purge -y snapd
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd ~/snap

cat << EOF | sudo tee -a /etc/apt/preferences.d/no-snap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

sudo chown root:root /etc/apt/preferences.d/no-snap.pref


# Updated open graphics drivers
sudo add-apt-repository -y ppa:oibaf/graphics-drivers

# Mesa PPA
sudo add-apt-repository -y ppa:kisak/kisak-mesa

# Strawberry PPA
sudo add-apt-repository -y ppa:jonaski/strawberry

# Extra up to date Apps
sudo add-apt-repository -y ppa:xtradeb/apps

# Latest Pipewire
sudo add-apt-repository -y ppa:pipewire-debian/pipewire-upstream

# Latest WirePlumber
sudo add-apt-repository -y ppa:pipewire-debian/wireplumber-upstream

echo "Intel Graphics Driver Install"
sleep 2
sudo apt-get install intel-media-va-driver-non-free i965-va-driver-shaders intel-opencl-icd intel-hdcp libigfxcmrt7 libva-glx2


sudo dpkg --add-architecture i386 
sudo apt update
sudo apt dist-upgrade -y

sudo apt install -y chromium chromium-l10n gutenprint ghostscript system-config-printer
sudo apt install -y synaptic gufw gsmartcontrol timeshift file-roller f2fs-tools xfsdump winbind samba fakeroot curl
sudo apt install -y pavucontrol pipewire-v4l2 ffmpeg lame flac x264 x265 sox libsox-fmt-mp3 libsox-fmt-ao 
sudo apt install -y soundconverter vlc strawberry transmission yt-dlp

# Flatpak
sudo apt install -y flatpak libflatpak0 gnome-software-plugin-flatpak flatpak-xdg-utils
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub org.mozilla.Thunderbird
flatpak install -y flathub org.gnome.Boxes

echo ""
echo "XanMod Kernel (optimierte Kernel)"
echo ""
sleep 2
echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
sudo apt update  
sudo apt install linux-xanmod-x64v3
sudo update-grub

sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean

sudo systemctl enable fstrim.timer
sudo fstrim -av

echo "export HISTSIZE=0" | sudo tee -a ~/.bashrc

# Set the default editor
export EDITOR=nano
export VISUAL=nano

# Alias config
echo "alias update='sudo apt dist-upgrade -y' " | sudo tee -a ~/.bashrc
echo "alias add='sudo apt install -y' " | sudo tee -a ~/.bashrc
echo "alias remove='sudo apt remove -y' " | sudo tee -a ~/.bashrc
echo "alias trim='sudo fstrim -av' " | sudo tee -a ~/.bashrc
echo "alias kver='uname -r' " | sudo tee -a ~/.bashrc
echo "alias disks='sudo gnome-disk-utility' " | sudo tee -a ~/.bashrc
    


history -c 

sudo timeshift --create

read -p "Postsetup is complete. Press any key to reboot"
sudo reboot


