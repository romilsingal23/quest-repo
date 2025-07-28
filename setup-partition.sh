#!/bin/bash

set -euo pipefail

echo "[INFO] Starting partitioning and mounting..."

# Function to partition, format, mount, and update fstab
setup_partition() {
  local device=$1
  local mount_point=$2
  local mount_opts=$3

  echo "[INFO] Working on ${device} for ${mount_point}..."

  # Wipe existing partitions
  wipefs -a "$device"

  # Create new GPT and partition
  parted -s "$device" mklabel gpt
  parted -s -a optimal "$device" mkpart primary xfs 1MiB 100%

  # Wait for partition to settle
  partprobe "$device"
  sleep 2

  local partition="${device}1"

  # Format partition with XFS
  mkfs.xfs -f "$partition"

  # Create mount point
  mkdir -p "$mount_point"

  # Mount it temporarily
  mount "$partition" "$mount_point"

  # Get UUID
  local uuid
  uuid=$(blkid -s UUID -o value "$partition")

  # Append to fstab
  echo "UUID=${uuid} ${mount_point} xfs ${mount_opts} 0 0" >> /etc/fstab

  echo "[INFO] Mounted $partition to $mount_point with options: $mount_opts"
}

# Setup /tmp on /dev/sdb
setup_partition "/dev/sdb" "/tmp" "defaults,nodev,nosuid,noexec"

# Setup /home on /dev/sdc
setup_partition "/dev/sdc" "/home" "defaults,nodev"

# Setup /var on /dev/sdd
setup_partition "/dev/sdd" "/var" "defaults"

# Remount /dev/shm with secure options
mount -o remount,nodev,nosuid,noexec /dev/shm
sed -i '/\/dev\/shm/d' /etc/fstab
echo 'tmpfs /dev/shm tmpfs defaults,nodev,nosuid,noexec 0 0' >> /etc/fstab

echo "[INFO] Partitioning and mounting complete."
