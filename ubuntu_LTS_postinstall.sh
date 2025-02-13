#!/usr/bin/env bash

# Last Edit: 13.02.2025

echo " 
            ...This script is created for Ubuntu LTS 24.04... 
For newer LTS Version this script may need some changes like package names etc.
"
echo ""
sleep 5
clear

echo ""
echo "----------------------------------------------"
echo "    ..Ubuntu LTS config after install..       "
echo "              Minimal Install                 "
echo "----------------------------------------------"
sleep 2

read -p "   Read this script before execute!!
               Press any key to continue..
"

echo ""
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
sudo apt-mark hold snapd
sudo rm -vrf ~/snap 
sudo rm -vrf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd 
clear


# PPA for firefox and thunderbird
sudo add-apt-repository -y ppa:mozillateam/ppa

# Xtra packages like latest yt-dlp
sudo add-apt-repository -y ppa:xtradeb/apps

# Latest Strawberry Player
sudo add-apt-repository -y ppa:jonaski/strawberry

# Latest stable flatpak
sudo add-apt-repository -y ppa:flatpak/stable

# Latest point release of Mesa plus select non-invasive early backports
sudo add-apt-repository -y ppa:kisak/kisak-mesa

# Latest amd drivers with latest mesa. May be unstable sometimes.
# sudo add-apt-repository -y ppa:oibaf/graphics-drivers

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
    ffmpeg \
    lame \
    flac \
    x264 \
    x265 \
    opus-tools 
clear

echo ""
echo "Install zsh shell"
echo ""
sleep 2
sudo apt -y install curl
sudo apt -y install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# chsh -s $(which zsh)

# Start zsh with a terminal
echo "
exec zsh
" | tee -a ~/.bashrc
touch ~/.zshrc
sleep 2
clear



# Install Nvidia Graphics Driver (change the nvidia version to the newest one first)
# sudo apt install -y nvidia-dkms-525 nvidia-driver-525 nvidia-settings libnvidia-gl-525 libnvidia-gl-525:i386 nvidia-compute-utils-525 nvidia-utils-525  

# Intel Graphics Driver Install
# sudo apt-get install intel-media-va-driver-non-free i965-va-driver-shaders intel-opencl-icd intel-hdcp libigfxcmrt7 libva-glx2


# Install Mesa drivers
sudo apt install -y mesa-utils mesa-va-drivers mesa-vdpau-drivers mesa-opencl-icd
sudo apt install -y ocl-icd-libopencl1 vulkan-tools vulkan-validationlayers
 
sudo apt install -y wayland-protocols wayland-utils libva-wayland2 libwayland-egl++1 


sudo apt install -y firefox eog eog-plugins file-roller
sudo apt install -y build-essential binutils fakeroot git winbind dkms ufw xfsdump f2fs-tools mtools cpufrequtils
sudo apt install -y synaptic gdebi gnome-tweaks gnome-firmware gnome-disk-utility gsmartcontrol
sudo apt install -y soundconverter celluloid strawberry yt-dlp pavucontrol pipewire-v4l2 pipewire-libcamera

# Install Steam
sudo apt-get install steam-installer protontricks ttf-mscorefonts-installer
sudo apt install -y libvkd3d1 libvkd3d-shader1 goverlay libfaudio0 libgdiplus 


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

# Install Linux Mint Wallpaper
wget http://packages.linuxmint.com/pool/main/m/mint-backgrounds-ulyana/mint-backgrounds-ulyana_1.1_all.deb
sudo dpkg -i mint-backgrounds-ulyana_1.1_all.deb
sudo apt install -f

# Remove downloaded stuff
rm mint-l-icons_1.7.4_all.deb
rm mint-l-theme_1.9.9_all.deb
rm mint-backgrounds-ulyana_1.1_all.deb



echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
sudo apt update  
sudo apt install linux-xanmod-lts-x64v3
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
sudo apt purge -y 
sudo apt clean

sudo systemctl enable fstrim.timer
sudo fstrim -av


echo "
CPU_LIMIT=0
GPU_USE_SYNC_OBJECTS=1
PYTHONOPTIMIZE=1
MESA_LOADER_DRIVER_OVERRIDE=radeonsi
__GL_SYNC_TO_VBLANK=1
__GLX_VENDOR_LIBRARY_NAME=mesa
PROTON_USE_WINED3D=1
PROTON_USE_FSYNC=1
GAMEMODE=1
PULSE_LATENCY_MSEC=30  
" | sudo tee -a /etc/environment

clear
echo ""
echo "----------------------------------------------"
echo "    ...System config is now complete...       "
echo "       System restarts in 6 seconds !         "
echo "----------------------------------------------"
sleep 6
sudo reboot
