#!/usr/bin/env bash

# Read the Default User Settings section on https://docs.vagrantup.com/v2/boxes/base.html

# Create 'vagrant' user with password 'vagrant'
useradd vagrant -G wheel
echo "vagrant" | passwd --stdin vagrant

# Allows wheel group to run all commands without password and tty
sed -e "/^#/ {/%wheel/s/^# *//}" -i /etc/sudoers
sed -e "/^#/! {/requiretty/s/^/# /}" -i /etc/sudoers

# Set up vagrant user with insecure keypair (https://github.com/mitchellh/vagrant/tree/master/keys)
mkdir /home/vagrant/.ssh
wget --no-check-certificate -O authorized_keys 'https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub'
mv authorized_keys /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod -R go-rwsx /home/vagrant/.ssh
restorecon /home/vagrant /home/vagrant/.ssh /home/vagrant/.ssh/authorized_keys
