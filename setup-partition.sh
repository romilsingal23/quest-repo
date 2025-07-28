#!/bin/bash

set -e

# Create and mount /tmp
truncate -s 1G /tmpdisk
mkfs.xfs /tmpdisk
mkdir -p /mnt/tmp
mount /tmpdisk /mnt/tmp
echo '/tmpdisk /tmp xfs defaults,nodev,nosuid,noexec 0 0' >> /etc/fstab

# Remount /dev/shm with secure options
mount -o remount,nodev,nosuid,noexec /dev/shm
echo 'tmpfs /dev/shm tmpfs defaults,nodev,nosuid,noexec 0 0' >> /etc/fstab

# Create and mount /home
truncate -s 1G /homedisk
mkfs.xfs /homedisk
mkdir -p /mnt/home
mount /homedisk /mnt/home
echo '/homedisk /home xfs defaults,nodev 0 0' >> /etc/fstab

# Create and mount /var
truncate -s 1G /vardisk
mkfs.xfs /vardisk
mkdir -p /mnt/var
mount /vardisk /mnt/var
echo '/vardisk /var xfs defaults 0 0' >> /etc/fstab
