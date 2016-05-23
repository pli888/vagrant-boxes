#!/usr/bin/env bash
# DESCRIPTION:
# Sets a password for the centos user for aws instances. This
# password is then removed by a further script at the end of the build
# process.


case $PACKER_BUILDER_TYPE in

  amazon-ebs)
  echo "Setting password for centos user"
  echo centos | sudo passwd --stdin centos
  ;;

  *)
  echo "Password set not required for vmware or virtualbox"
  ;;

esac