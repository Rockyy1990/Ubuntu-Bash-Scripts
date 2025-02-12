#!/usr/bin/env bash

# Last Edit: 12.02.2025

echo ""
echo "----------------------------------------------"
echo "    ..Ubuntu LTS config after install..       "
echo "              Minimal Install                 "
echo "----------------------------------------------"
sleep 1

read -p "   Read this script before execute!!
               Press any key to continue..
"

sudo apt purge -y apport* 
sudo apt autoremove -y
clear

echo ""
echo "Remove snap from Ubuntu"
sleep 2
sudo snap remove firefox
sudo snap remove thunderbird
sudo snap remove gnome-42-2204
sudo snap remove snap-store
sudo systemctl disable --now snapd
sudo apt purge -y snapd
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd ~/snap

cat << EOF | sudo tee -a /etc/apt/preferences.d/no-snap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

sudo chown root:root /etc/apt/preferences.d/no-snap.pref
clear


sudo add-apt-repository -y ppa:mozillateam/ppa
sudo add-apt-repository -y ppa:oibaf/graphics-drivers
sudo add-apt-repository -y ppa:xtradeb/apps

sudo dpkg --add-architecture i386

sudo apt update

sudo apt upgrade -y
sudo apt dist-upgrade -y

# Install essential multimedia packages
sudo apt install -y \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-vaapi \
    gstreamer1.0-libav \
    gstreamer1.0-fdkaac \
    libavcodec-extra \
    libavformat-extra \
    libfaad2 \
    libfaac0 \
    libxvidcore \
    ffmpeg \
    lame \
    flac \
    x264 \
    x265 \
    opus-tools 

# Install Mesa drivers
sudo apt install -y mesa-utils mesa-va-drivers mesa-vdpau-drivers mesa-opencl-icd
sudo apt install -y ocl-icd-libopencl1 vulkan-tools vulkan-validationlayers
 
sudo apt install -y wayland-protocols wayland-utils libva-wayland2 libwayland-egl++1 


sudo apt install -y firefox thunderbird file-roller
sudo apt install -y build-essential fakeroot git winbind dkms ufw xfsdump f2fs-tools mtools cpufrequtils
sudo apt install -y synaptic gdebi gnome-tweaks gnome-firmware gnome-disk-utility gsmartcontrol
sudo apt install -y soundconverter celluloid yt-dlp pavucontrol pipewire-v4l2 pipewire-libcamera pipewire-vulkan

# Install Steam
sudo apt install -y steam-installer steam-libs steam-libs-i386:i386 protontricks ttf-mscorefonts-installer
sudo apt install -y libvkd3d1 libvkd3d-shader1 goverlay libfaudio0 libgdiplus

wget -O discord.deb https://discord.com/api/download?platform=linux&format=deb
sudo dpkg -i discord.deb
sudo apt-get install -f


# Download Protonup-qt AppImage
wget https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v2.11.1/ProtonUp-Qt-2.11.1-x86_64.AppImage


# Download mint-l-icons
wget http://packages.linuxmint.com/pool/main/m/mint-l-icons/mint-l-icons_1.7.4_all.deb
sudo dpkg -i mint-l-icons_1.7.4_all.deb
sudo apt install -f

# Download mint-l-theme
wget http://packages.linuxmint.com/pool/main/m/mint-l-theme/mint-l-theme_1.9.9_all.deb
sudo dpkg -i mint-l-theme_1.9.9_all.deb
sudo apt install -f

rm mint-l-icons_1.7.4_all.deb
rm mint-l-theme_1.9.9_all.deb


echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
sudo apt update  
sudo apt install linux-xanmod-x64v3
sudo update-grub


sudo cpufreq-set -g performance

echo "
GOVERNOR="performance"
" | sudo tee -a /etc/default/cpufrequtils
sudo systemctl restart cpufrequtils


sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
clear

sudo sed -i -e '/^\/\/tmpfs/d' /etc/fstab
echo -e "
tmpfs /var/tmp tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/log tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/run tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/lock tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/cache tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/volatile tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/spool tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /media tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /dev/shm tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
" | sudo tee -a /etc/fstab
clear

sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean

sudo systemctl enable fstrim.timer
sudo fstrim -av


echo "
CPU_MAX_FREQ=high
MESA_LOADER_DRIVER_OVERRIDE=radeonsi
VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.json
__GL_SYNC_TO_VBLANK=1
__GLX_VENDOR_LIBRARY_NAME=mesa
PROTON_USE_WINED3D=1
PROTON_NO_ESYNC=1
GAMEMODE=1
SDL_VIDEODRIVER=x11  
SDL_RENDER_DRIVER=opengl  
PULSE_LATENCY_MSEC=30  
" | sudo tee -a /etc/environment


echo ""
read -p "Installation complete! Press any key to restart the system"
sudo reboot
