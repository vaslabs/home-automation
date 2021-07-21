source find_game_proxy.sh

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
	kill $(pgrep ds4drv) && {
        if [[ -f $NEXT_TWO_CONTROLLERS ]]; then
            rm $HOME/$NEXT_TWO_CONTROLLERS
        fi
        if [[ -f $FIRST_TWO_CONTROLLERS ]]; then
            rm $HOME/$FIRST_TWO_CONTROLLERS
        fi
    }
    
}

connect_two_players() {
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
    ssh $CONTROLLER_PROXY sudo cat /dev/input/event4 >/dev/input/"$gamepad1" &
    ssh $CONTROLLER_PROXY sudo cat /dev/input/event5 >/dev/input/"$gamepad2" &
}

connect_four_players() {
    if [ -f $HOME/.ds4drv_4players ]; then
        stop_ds4drv
        connect_two_players
    fi
    start_ds4drv &
    sleep 3
    CONTROLLER_PROXY=$(ssh_proxy)
    gamepad1=$(find_third_gamepad)
    gamepad2=$(find_fourth_gamepad)
    echo $gamepad1
    echo $gamepad2
    ssh $CONTROLLER_PROXY sudo cat /dev/input/event6 >/dev/input/"$gamepad1" &
    ssh $CONTROLLER_PROXY sudo cat /dev/input/event7 >/dev/input/"$gamepad2" &
}