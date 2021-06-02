#!/bin/bash
whoami >$HOME/.local/var/log/home_automation.whoami
cd ~/home-automation
QUEUE_URL=<TODO> npm start >$HOME/.local/var/log/home_automation.txt
