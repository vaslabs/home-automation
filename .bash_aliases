## Useful aliases for client machine
alias ps4_as_xbox='ds4drv --emulate-xpad-wireless --next-controller --emulate-xpad-wireless --hidraw'
alias ps4='ds4drv --next-controller --hidraw'

alias ps4_as_xbox_four_players='ds4drv --emulate-xpad-wireless --next-controller --emulate-xpad-wireless --next-controller --emulate-xpad-wireless --next-controller --emulate-xpad-wireless --hidraw'

function find_controller_host() {
  cd $HOME/home-automation
  source ./find_game_proxy.sh
  ssh_proxy
}

function connect_first_controller {

  cat /dev/input/event$1 | ssh $(ssh_proxy) sudo tee -a /dev/input/event4 >/dev/null
}

function connect_second_controller {
  cat /dev/input/event$1 | ssh ubuntu@$(ssh_proxy) sudo tee -a /dev/input/event5 >/dev/null
}

function connect_third_controller {
  cat /dev/input/event$1 | ssh ubuntu@$(ssh_proxy) sudo tee -a /dev/input/event6 >/dev/null
}

function connect_fourth_controller {
  cat /dev/input/event$1 | ssh $(ssh_proxy) sudo tee -a /dev/input/event7 >/dev/null
}
