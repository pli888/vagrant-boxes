#!/usr/bin/env bash

# Update installed packages
yum -y update

# Install base and core groups
# yum -y groupinstall base core

# Used to install common packages on all vm images
PACKAGES="ntp bind-utils wget nfs-utils autofs bzip2 unzip mlocate yum-utils yum-plugin-remove-with-leaves deltarpm epel-release"
yum install -y $PACKAGES

# Disable SElinux
sudo sed -i 's/enforcing/disabled/' /etc/selinux/config /etc/selinux/config

# Disable iptables on boot up
sudo chkconfig iptables off

