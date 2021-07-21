#!/bin/bash
source connect_controllers.sh

if [[ $1 = "more" ]]; then
    connect_four_players
else
    connect_two_players
fi