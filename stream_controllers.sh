#!/bin/bash
source find_game_proxy.sh
start_ds4drv
CONTROLLER_PROXY=$(ssh_proxy)
first_gamepad=$(find_first_gamepad)
second_gamepad=$(find_second_gamepad)
ssh $CONTROLLER_PROXY sudo cat /dev/input/event3 | tee $first_gamepad >/dev/null &
ssh $CONTROLLER_PROXY sudo cat /dev/input/event4 | tee $second_gamepad >/dev/null &
