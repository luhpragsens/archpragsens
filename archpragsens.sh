# == PragSensArchlinux ==
#Checkpoint1
echo -e "[\033[1;33m Prag & Sens arch uwu linux installer \033[0m]"
pacman --noconfirm -Sy archlinux-keyring
loadkeys us-acentos
timedatectl set-ntp 1
lsblk
echo "Enter the drive: "
read drive
cfdisk $drive
echo "Enter the linux partition: "
read partition
mkfs.ext4 $partition
read -p "Want to create efi partition? [y/n]" answer
if [[ $answer = y ]] ; then
  echo "Enter EFI partition: "
  read efipartition
  mkfs.vfat -F 32 $efipartition
fi
read -p "Want to create swap partition? [y/n]" swap
if [[ $swap = y ]] ; then
  echo "Enter Swap partition: "
  read swappartition
  mkswap $swappartition
  swapon $swappartition
fi
mount $partition /mnt
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^#Checkpoint2$/d' archpragsens.sh > /mnt/archpragsens2.sh
chmod +x /mnt/archpragsens2.sh
arch-chroot /mnt ./archpragsens2.sh
exit

#Checkpoint2
ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us-acentos" > /etc/vconsole.conf
echo "Hostname: 11400pragsens"
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1		localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1		$hostname.localdomain $hostname" >> /etc/hosts
mkinitcpio -p
passwd
pacman --noconfirm -S grub efibootmgr os-prober
echo "Enter EFI partition: "
read efipartition
mkdir /boot/efi
mount $efipartition /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
sed -i 's/quiet/pci=noaer/g' /etc/default/grub
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
#Installing core tools

pacman -S --noconfirm xorg-server xorg-xrandr xorg-xinit libxinerama bash rustup nushell networkmanager unzip pipewire pipewire-pulse man-db intel-ucode amd-ucode ntfs-3g git nvim p7zip unrar alacritty

systemctl enable NetworkManager.service
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/bash $username
passwd $username
echo -e "[\033[1;33m Installation Finish Reboot now \033[0m]"
aps3path=/home/$username/archpragsens3.sh
sed '1,/^#Checkpoint3$/d' archpragsens2.sh > $aps3path
chown $username:$username $aps3path
chmod +x $aps3path
su -c $aps3path -s /bin/bash $username
exit

#Checkpoint3
cd $HOME
git clone https:/aur.archlinux.org/paru-bin.git
cd ./paru
makepkg -si
rm -r $HOME/paru-bin
paru -S leftwm

