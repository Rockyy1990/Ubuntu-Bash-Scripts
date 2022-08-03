#!/usr/bin/env bash
echo "--------------------------------------"
echo "   Ubuntu Legacy Server config        "
echo " Custom Ubuntu install and config     "
echo "--------------------------------------"
sleep 4
echo "Updating and System Upgrade"
echo
sleep 2
sudo dpkg --add-architecture i386 
sudo apt-get update 
sudo apt dist-upgrade -y
clear

echo "Ubuntu Desktop"  
sudo apt-get install xorg ubuntu-desktop-minimal dkms language-pack-gnome-de language-pack-gnome-de-base pavucontrol
clear
echo "Xubuntu Desktop (XFCE4)"
sudo apt-get install xorg xubuntu-desktop dkms ntpdate breeze-cursor-theme binutils pavucontrol language-pack-gnome-de language-pack-gnome-de-base 
sudo apt autoremove -y pidgin xfburn thunderbird gnome-mines gnome-sudoku sgt-puzzles
clear
echo "Install Cinnamon Desktop"
sudo apt install --install-recommends xorg dkms cinnamon pavucontrol language-pack-gnome-de language-pack-gnome-de-base 
clear

echo "Install System Programs"
echo
sudo apt-get install synaptic ubuntu-restricted-extras build-essential gnome-disk-utility binutils fakeroot ufw f2fs-tools xfsdump mtools flatpak binutils gufw gnome-text-editor

echo "remove snap"
echo
sudo apt purge snapd 
rm -vrf ~/snap 
sudo rm -vrf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd 
sudo apt-mark hold snapd 
clear

echo "Liquorix Kernel (optimized workloads for gaming etc)"
echo
sudo add-apt-repository ppa:damentz/liquorix 
sudo apt-get update  
sudo apt-get install -y linux-image-liquorix-amd64 linux-headers-liquorix-amd64  

echo "Install Nvidia Graphics Driver"
echo 
sudo apt install -y nvidia-dkms-515 nvidia-driver-515 nvidia-settings libnvidia-gl-515 libnvidia-gl-515:i386 nvidia-compute-utils-515 nvidia-utils-515  
clear

echo "Reduce Overhead with tlp (Performance tweak)"
echo
sudo add-apt-repository ppa:linrunner/tlp  
sudo apt update -y 
sudo apt install -y tlp tlp-rdw 
sudo tlp start

Install tuned for dynamic system optimaze*
sudo apt install tuned tuned-utils tuned-utils-systemtap

echo "Nützliches"
echo
sudo apt install ntpdate libvulkan1 vulkan-tools  gnome-tweak-tool thunderbird thunderbird-locale-de eog eog-plugins transmission-gtk cpufreqd indicator-cpufreq file-roller winbind elementary-xfce-icon-theme
clear
echo "Multimedia"
sudo apt-get install vlc soundconverter yt-dlp lame flac sox libsox-fmt-pulse

echo "Strawberry Player"
sudo add-apt-repository ppa:jonaski/strawberry  
sudo apt-get update 
sudo apt-get install -y strawberry
clear
echo "----------------------------------------------------------------------------------------"
echo "Gaming"
echo
echo "Steam Game Platform"
sudo apt-get install --install-recommends steam-installer protontricks proton-caller
clear
echo "Lutris"
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt install -y --install-recommends lutris gamemode
echo "----------------------------------------------------------------------------------------"
clear
echo
echo "SSD trim"
sudo systemctl enable fstrim.timer

echo "use for ext4" 
sudo sed -i 's/ errors=remount-ro/ noatime,errors=remount-ro/' /etc/fstab
clear
echo "System cleaning"
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get clean -y
clear
echo
echo "System setup and config is complete"
echo "The System will reboot in 10 seconds"
sleep 9
echo "Reboot"
sleep 2
sudo reboot



 












