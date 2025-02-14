#!/usr/bin/env bash

# Last Edit: 14.02.2025

echo "
            ...This script is created for Kubuntu LTS 24.04...
For newer LTS Version this script may need some changes like package names etc.
"
echo ""
sleep 5
clear

echo ""
echo "----------------------------------------------"
echo "         ..config after install..             "
echo "            Kubuntu LTS minimal               "
echo "----------------------------------------------"
sleep 2

read -p "   Read this script before execute!!
               Press any key to continue..
"

echo ""
sudo apt purge -y apport*
sudo apt autoremove -y
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

# Install flatpak. Replace for Ubuntu Snap.
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


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

# Install Virt-Manager
sudo apt install -y virt-manager ovmf qemu-kvm qemu-utils libvirt-daemon-system libvirt-clients bridge-utils

# Guestfs support for Virt-Manager
sudo apt install -y guestfs-tools guestfsd libguestfs-gfs2 libguestfs-rsync python3-guestfs libguestfs-ocaml oz


# Install Steam
sudo apt install -y steam-installer
sudo apt install -y protontricks ttf-mscorefonts-installer libvkd3d1 libvkd3d-shader1 goverlay libfaudio0 libgdiplus

flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub com.usebottles.bottles
#flatpak install flathub com.valvesoftware.Steam


# Download Protonup-qt AppImage
wget https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v2.11.1/ProtonUp-Qt-2.11.1-x86_64.AppImage



# Install Linux Mint Wallpaper
wget http://packages.linuxmint.com/pool/main/m/mint-backgrounds-victoria/mint-backgrounds-victoria_1.2_all.deb
wget http://packages.linuxmint.com/pool/main/m/mint-backgrounds-tina/mint-backgrounds-tina_1.2_all.deb
sudo gdebi -n mint-backgrounds-victoria_1.2_all.deb
sudo gdebi -n mint-backgrounds-tina_1.2_all.deb


# Remove downloaded stuff
rm mint-backgrounds-victoria_1.2_all.deb
rm mint-backgrounds-tina_1.2_all.deb



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
__GL_SYNC_TO_VBLANK=1
__GLX_VENDOR_LIBRARY_NAME=mesa
MESA_BACK_BUFFER=ximage
MESA_NO_DITHER=0
MESA_SHADER_CACHE_DISABLE=false
mesa_glthread=true
MESA_DEBUG=0
PROTON_USE_WINED3D=0
PROTON_USE_FSYNC=1
GAMEMODE=1
DXVK_ASYNC=1
WINE_FSR_OVERRIDE=1
WINE_FULLSCREEN_FSR=1
WINE_VK_USE_FSR=1
 " | sudo tee -a /etc/environment


 clear
echo ""
echo "----------------------------------------------"
echo "    ...System config is now complete...       "
echo "       System restarts in 6 seconds !         "
echo "----------------------------------------------"
sleep 6
sudo reboot
