#!/bin/bash
#TODO fix the below
sudo apt-get -y update
sudo apt-get -y install python3-pip
sudo pip3 install ds4drv
sudo ds4drv --emulate-xpad-wireless --next-controller --emulate-xpad-wireless --hidraw &disown