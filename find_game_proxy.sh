#!/bin/bash

#Setup an ec2 instance with a tag purpose and value gamepads
# My ec2 instance runs ubuntu and has ds4drv installed and running
function gamepad_proxy() {
	aws ec2 describe-instances --filters "Name=tag:purpose, Values=gamepads" | jq -r '.Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicDnsName'	
}

function ssh_proxy() {
	echo ubuntu@$(gamepad_proxy)
}

function start_ds4drv() {
	ds4drv --emulate-xpad-wireless --next-controller --emulate-xpad-wireless --hidraw >$HOME/.ds4drv
}

function find_first_gamepad() {
    cat $HOME/.ds4drv | grep -oE '/dev/input/event[0-9]+' | head -n1
}

function find_second_gamepad() {
    cat $HOME/.ds4drv | grep -oE '/dev/input/event[0-9]+' | head -n2
}

function stop_ds4drv() {
	kill $(pgrep ds4drv)
}
