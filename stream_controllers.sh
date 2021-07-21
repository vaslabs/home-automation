#!/bin/bash
source find_game_proxy.sh
if [ -f $HOME/.ds4drv ]; then
    stop_ds4drv
fi
start_ds4drv &
sleep 3
CONTROLLER_PROXY=$(ssh_proxy)
gamepad1=$(find_first_gamepad)
gamepad2=$(find_second_gamepad)
echo $gamepad1
echo $gamepad2
ssh $CONTROLLER_PROXY sudo cat /dev/input/event4 >/dev/input/"$gamepad1" &
ssh $CONTROLLER_PROXY sudo cat /dev/input/event5 >/dev/input/"$gamepad2" &
