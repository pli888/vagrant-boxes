#!/usr/bin/env bash

#yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
#yum -y clean all
#rm -rf /etc/yum.repos.d/{puppetlabs,epel}.repo
#rm -rf VBoxGuestAdditions_*.iso

# Remove traces of mac address from network configuration
#sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
#rm /etc/udev/rules.d/70-persistent-net.rules



# DESCRIPTION:
#   Used to clean up an environment ready for exporting from packer.
#
# USAGE:
#   Set $CLEAN_DISKS to 0 to skip disk cleaning.

# Ensure script is run as root
[ $(id -u) != 0 ] && sudo -i

# Clean package repository databases
yum clean all

# Remove items in /root
echo "Remove items left in /root"
rm -rf /root/*

# Empty Bash history
echo "Remove bash history"
unset HISTFILE
rm -f /root/.bash_history

# Remove anything remaining in /tmp
echo "Remove temporary files"
rm -rf /tmp/*

# Clean logs
echo "Clean logs"
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Purge ssh keys
echo "Purging SSH keys"
rm -f /etc/ssh/ssh_host_*


if [ "$CLEAN_DISKS" -ne 0 ]; then

  case $PACKER_BUILDER_TYPE in

    amazon-ebs)
    echo "Disk clean up not required for for AWS"
    ;;


    *)
    # Write zeros to disk to improve compression
    echo "Clean disks"
    dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1;
    rm -f /EMPTY;

    # Whiteout /boot
    echo "Clean up /boot"
    count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
    dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count > /dev/null 2>&1;
    rm /boot/whitespace;

    # Whiteout swap
    echo "Clean up swap partitions"
    swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
    swapoff $swappart;
    dd if=/dev/zero of=$swappart bs=1M > /dev/null 2>&1;
    mkswap $swappart > /dev/null 2>&1;
    swapon $swappart;
    ;;

  esac
fi

# Do not quit until the file-system buffer has been flushed
sync

exit 0