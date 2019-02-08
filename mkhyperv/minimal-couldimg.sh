#! /bin/bash

# Download and fill the so-called "Minimal Ubuntu"
# https://blog.ubuntu.com/2018/07/09/minimal-ubuntu-released

abort() {
    echo "$@"
    exit 256
}

disk="$1"

[ -z "$disk" ] && abort "USAGE: $0 /path/to/device"

read -p "### BEWARE### erasing ${disk} [y/N]: " proceed

case $proceed in y|Y) ;;
*) abort "OK, aborting."
   ;;
esac

# TODO make these command line options
apt_cacher="http://172.17.0.1:3142"
image='ubuntu:bionic'
arch='amd64'

set -e
set -x

sudo apt install parted e2fsprogs dosfstools docker-ce zerofree

# Watch out: we fill the disk from back to front.
sudo parted -s "${disk}" -a minimal -- \
     mklabel gpt \
     mkpart linux ext4 100MB -0G \
     mkpart esp fat32 0G 100MB \
     name 1 linux \
     name 2 efi \
     set 2 boot on \
     set 2 esp on \
     quit
sudo partprobe "${disk}"
sync;sync;sync
sleep 1
root="${disk}1"
efi="${disk}2"

# https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/best-practices-for-running-linux-on-hyper-v
sudo mkfs.ext4 -G 4096 "${root}"
sudo tune2fs -O ^has_journal -o nobarrier,discard "${root}"
sudo mkfs.vfat -F 32 "${efi}"

mountpoint=`mktemp -d`

cleanup() {
    error=$?

    [ ! -d "${mountpoint}" ] && return
    if [ "${error}" -gt 0 ]; then
	echo
	echo "got error: ${error}"
    else
	echo "finished."
    fi

    set +e
    sync; sync; sync
    sudo umount -l "${mountpoint}/tmp"
    sudo umount -l "${mountpoint}/sys"
    sudo umount -l "${mountpoint}/dev/pts"
    sudo umount -l "${mountpoint}/dev"
    sudo umount -l "${mountpoint}/boot/efi"
    sudo umount -l "${mountpoint}"
    rmdir "${mountpoint}"

    exit "${error}"
}

trap "cleanup" EXIT TERM INT

# fill in the partition
sudo docker pull "${image}"
containerid=`sudo docker container create "${image}" /bin/false`
sudo mount -o noatime "${root}" "${mountpoint}"
sudo docker export "${containerid}" | sudo tar -C "${mountpoint}" -x
sudo docker rm "${containerid}"

# tweak the image
sudo mv "${mountpoint}/etc/apt/sources.list" "${mountpoint}/etc/apt/sources.list.save"
sudo cp assets/99apt.conf "${mountpoint}/etc/apt/apt.conf.d"
sudo cp assets/99dpkg.cfg "${mountpoint}/etc/dpkg/dpkg.cfg.d"
sudo cp assets/99sources.list "${mountpoint}/etc/apt/sources.list.d"
sudo sed -i "s/arch=amd64/arch=${arch}/" \
      "${mountpoint}/etc/apt/sources.list.d/99sources.list"
sudo sed -i "s,http://,${apt_cacher}/," \
      "${mountpoint}/etc/apt/sources.list.d/99sources.list"

sudo rm "${mountpoint}/usr/sbin/policy-rc.d" "${mountpoint}/sbin/initctl"

# mount something
sudo mkdir -p "${mountpoint}/boot/efi"
sudo mount "${efi}" "${mountpoint}/boot/efi"
sudo mount --bind /dev "${mountpoint}/dev"
sudo mount -t devpts /dev/pts "${mountpoint}/dev/pts"
sudo mount -t proc proc "${mountpoint}/proc"
sudo mount -t sysfs sysfs "${mountpoint}/sys"
sudo mount -t tmpfs tmpfs "${mountpoint}/tmp"

# chroot
sudo chroot "${mountpoint}" dpkg-divert --local --remove /sbin/initctl 
sudo chroot "${mountpoint}" apt update
sudo chroot "${mountpoint}" apt install \
     linux-image-virtual \
     grub-efi \
     initramfs-tools \
     systemd-sysv \
     openssh-client \
     openssh-server \
     netbase
sudo chroot "${mountpoint}" apt upgrade
cat assets/99modules | sudo tee -a "${mountpoint}/etc/initramfs-tools/modules" > /dev/null
sudo chroot "${mountpoint}" update-initramfs -u
sudo chroot "${mountpoint}" grub-install \
     --target=x86_64-efi \
     --efi-directory=/boot/efi \
     --bootloader-id=ubuntu \
     --recheck
sudo chroot "${mountpoint}" update-grub

# fixup
sudo mount -o remount,ro "${mountpoint}"
sudo zerofree "${mountpoint}"
