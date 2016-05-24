#!/usr/bin/env bash

case $PACKER_BUILDER_TYPE in

  virtualbox-iso)
  # If we haven't defined a location for the Vagrant SSH certificate, grab from upstream
  [ -z "$VAGRANT_KEY" ] && VAGRANT_KEY="https://raw.github.com/mitchellh/vagrant/master/keys/vagrant"
  [ -z "$VAGRANT_PUB" ] && VAGRANT_PUB="https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub"

  # Add build time
  echo "Add build time to /etc/vagrant_box_build_time"
  date > /etc/vagrant_box_build_time

  # Add Vagrant user
  echo "Add Vagrant user"
  useradd -m vagrant -G wheel -m -d /home/vagrant
  echo vagrant | passwd vagrant --stdin

  # Set up SSH
  echo "Set up SSH for Vagrant user"
  mkdir -p -m 0700 /home/vagrant/.ssh
  curl -Lkso /home/vagrant/.ssh/authorized_keys $VAGRANT_PUB
  curl -Lkso /home/vagrant/.ssh/vagrant.key $VAGRANT_KEY
  chmod 0600 /home/vagrant/.ssh/*
  chown -R vagrant:vagrant /home/vagrant/.ssh

  # Speed up SSH
  echo "Remove DNS from SSH daemon"
  sed -i 's/.*UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

  # Add to sudoers
  echo "Add Vagrant user to sudoers"
  sed -i 's/^Defaults.*requiretty/Defaults !requiretty/' /etc/sudoers
  cat << 'EOF' > /etc/sudoers.d/vagrant
  # Built by BoxFactory. Changing this file is not recommended.

  # Add passwordless sudo for Vagrant user
  vagrant ALL=NOPASSWD: ALL

  # Override SSHD configuration file defaults
  Defaults:vagrant !requiretty
  Defaults:vagrant env_keep="SSH_AUTH_SOCK"
EOF
  chmod 0440 /etc/sudoers.d/vagrant
  ;;

  *)
  echo "No vagrant config specified for this build type"
  ;;

esac

exit 0
