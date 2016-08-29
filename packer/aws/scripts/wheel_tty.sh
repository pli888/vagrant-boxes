#!/usr/bin/env bash

# Allows wheel group to run all commands without password and tty
sed -e "/^#/ {/%wheel/s/^# *//}" -i /etc/sudoers
sed -e "/^#/! {/requiretty/s/^/# /}" -i /etc/sudoers