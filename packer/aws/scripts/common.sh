#!/usr/bin/env bash

# Update installed packages
yum -y update

# Install base and core groups
# yum -y groupinstall base core

# Required for downloading vagrant key
yum -y install wget

# Disable SElinux
sudo sed -i 's/enforcing/disabled/' /etc/selinux/config /etc/selinux/config

# Disable iptables on boot up
sudo chkconfig iptables off

