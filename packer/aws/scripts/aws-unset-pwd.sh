#!/usr/bin/env bash
# DESCRIPTION:
#   Removes password for the centos user for aws instances.
#

case $PACKER_BUILDER_TYPE in

  amazon-ebs)
  echo "Unsetting password for centos user"
  sudo passwd -d centos
  ;;

  *)
  echo "Password unset not required for vmware or virtualbox"
  ;;

esac
