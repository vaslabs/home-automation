FIRST_TWO_CONTROLLERS=.ds4drv
NEXT_TWO_CONTROLLERS=.ds4drv_4players

function start_ds4drv() {
    if [[ -z $1 ]]; then
		ds4_drv_file=$FIRST_TWO_CONTROLLERS
	else
		ds4_drv_file=$1
	fi
	ds4drv --emulate-xpad-wireless --next-controller --emulate-xpad-wireless --hidraw >$HOME/$ds4_drv_file
}

function find_gamepad_input() {
    grep -oE 'event[0-9]+'
}

function find_first_gamepad() {
    cat $HOME/$FIRST_TWO_CONTROLLERS | find_gamepad_input | head -n1
}

function find_second_gamepad() {
    cat $HOME/$FIRST_TWO_CONTROLLERS | find_gamepad_input | tail -n1
}

function find_third_gamepad() {
    cat $HOME/$NEXT_TWO_CONTROLLERS | find_gamepad_input | head -n1
}

function find_fourth_gamepad() {
    cat $HOME/$NEXT_TWO_CONTROLLERS | find_gamepad_input | tail -n1
}

function stop_ds4drv() {
	if [[ -z $1 ]]; then
		ds4_drv_file=$FIRST_TWO_CONTROLLERS
	else
		ds4_drv_file=$1
	fi
	kill $(pgrep ds4drv) && rm $HOME/$ds4_drv_file
}

connect_two_players() {
    source find_game_proxy.sh

    if [ -f $HOME/$FIRST_TWO_CONTROLLERS ]; then
        stop_ds4drv
    fi
    start_ds4drv &
    sleep 3
    CONTROLLER_PROXY=$(ssh_proxy)
    gamepad1=$(find_first_gamepad)
    gamepad2=$(find_second_gamepad)
    echo $gamepad1
    echo $gamepad2
    ssh $CONTROLLER_PROXY sudo cat /dev/input/event3 >/dev/input/"$gamepad1" &
    ssh $CONTROLLER_PROXY sudo cat /dev/input/event4 >/dev/input/"$gamepad2" &
}

connect_four_players() {
    source find_game_proxy.sh

    if [ -f $HOME/.ds4drv_4players ]; then
        stop_ds4drv .ds4drv_4players
    fi
    start_ds4drv &
    sleep 3
    CONTROLLER_PROXY=$(ssh_proxy)
    gamepad1=$(find_third_gamepad)
    gamepad2=$(find_fourth_gamepad)
    echo $gamepad1
    echo $gamepad2
    ssh $CONTROLLER_PROXY sudo cat /dev/input/event3 >/dev/input/"$gamepad1" &
    ssh $CONTROLLER_PROXY sudo cat /dev/input/event4 >/dev/input/"$gamepad2" &
}