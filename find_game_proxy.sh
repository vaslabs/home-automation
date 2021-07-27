#!/bin/bash

#Setup an ec2 instance with a tag purpose and value gamepads
# My ec2 instance runs ubuntu and has ds4drv installed and running
function gamepad_proxy() {
	aws ec2 describe-instances --filters "Name=tag:purpose, Values=gamepads" | jq -r '.Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicDnsName'	
}

function ssh_proxy() {
	echo ubuntu@$(gamepad_proxy)
}
