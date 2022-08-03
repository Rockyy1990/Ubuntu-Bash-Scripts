#! usr/bin/env bash

echo ""
echo "----------------------------------------------"
echo "  Ubuntu einrichten (minimal installation)    "
echo "----------------------------------------------"

sleep 3
sudo dpkg --add-architecture i386 
sudo apt-get update 
clear
echo ""
echo "Timeshift (Snapshots)"
echo ""
sudo apt-get install -y timeshift 
clear
sleep 2
echo "System upgrade and install System tools"
echo ""
sleep 2
sudo apt-get full-upgrade -y
sudo apt install -y synaptic gsmartcontrol build-essential dkms gufw gnome-text-editor pavucontrol mtools f2fs-tools xfsdump hfsplus hfsprogs
sleep 2
echo ""
clear
echo ""
echo "komplettes entfernen von Snap"
echo ""
sleep 3
sudo apt purge snapd 
rm -vrf ~/snap 
sudo rm -vrf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd 
sudo apt-mark hold snapd  
clear
sleep 3
echo "install Flatpak Paketmanager"
sleep 2
sudo apt install -y flatpak gnome-software-plugin-flatpak 
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 

echo "Ubuntu restricted extras installieren"
sleep 2
sudo apt-get install -y ubuntu-restricted-extras ffmpeg libavdevice58 sox libsox-fmt-mp3 libsox-fmt-ao libsox-fmt-pulse gnome-shell-extension-gpaste gnome-tweaks eog eog-plugins
sudo apt-get install -y elementary-xfce-icon-theme vlc soundconverter yt-dlp ntp ntpdate libvulkan1 vulkan-tools transmission-gtk file-roller winbind neofetch
echo ""
echo "XanMod Kernel (optimierte Kernel)"
echo ""
sleep 3
echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
sudo apt update  
sudo apt install linux-xanmod
clear
echo ""
echo "SSD Trim"
echo ""
sleep 2
sudo systemctl enable fstrim.timer  
sudo fstrim -av
echo ""
echo "ext4 otpimieren"
echo ""
sudo sed -i 's/ errors=remount-ro/ noatime,errors=remount-ro/' /etc/fstab
clear
sudo bash -c "echo vm.swappiness=10 >> /etc/sysctl.conf"
sudo bash -c "echo neofetch > /etc/bashrc"

echo ""
echo "Grub Bootloader konfigurieren"
echo ""
sleep 3
sudo nano /etc/default/grub
echo ""
echo "Reduce Overhead with tlp (Performance tweak)"
sleep 2
sudo add-apt-repository ppa:linrunner/tlp 
sudo apt update -y 
sudo apt install -y tlp tlp-rdw 
sudo tlp start
echo ""
echo "Intel Graphics Driver Install"
sleep 2
sudo apt-get install intel-media-va-driver-non-free i965-va-driver-shaders intel-opencl-icd intel-hdcp libigfxcmrt7 libva-glx2
echo ""
echo "Repository fuer Nvidia Graphics Driver (Proprietär) einrichten"
echo ""
sleep 2
sudo add-apt-repository ppa:graphics-drivers/ppa  
sudo apt-get update 
echo ""
echo "Nvidia Graphics Driver"
echo ""
sleep 3
sudo apt install nvidia-dkms-515 nvidia-driver-515 nvidia-settings libnvidia-gl-515 libnvidia-gl-515:i386 nvidia-compute-utils-515 nvidia-utils-515 
clear
echo ""
echo "Install Steam Gaming Plattform"
echo ""
sleep 3
sudo apt-get install steam-installer steam-devices protontricks proton-caller
echo ""
echo "Strawberry Player"
sleep 2
sudo add-apt-repository -y ppa:jonaski/strawberry  
sudo apt-get update  
sudo apt-get install -y strawberry
echo ""
echo "Windows support einrichten.."
echo ""
sleep 3
wget -nc https://dl.winehq.org/wine-builds/winehq.key 
sudo apt-key add winehq.key
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' 
sudo apt-get update  
sudo apt-get install -y --install-recommends winehq-staging
clear

echo ""
echo "System aufräumen..."
sleep 2
sudo apt autoremove -y apport apport-gtk 
sudo apt-get -y --purge autoremove
sudo apt-get autoclean -y
sudo apt-get clean
sudo rm -rfv /var/tmp/flatpak-cache-*
flatpak uninstall --delete-data -y
sudo update-grub
history -c 
clear
echo "------------------------------------------------------------------------------"
echo " System wurde konfiguriert.. Neustart in 10 sekunden"
echo ""
echo "  ... Firefox Flatpak:flatpak install firefox " 
echo "------------------------------------------------------------------------------"
sleep 11
reboot
