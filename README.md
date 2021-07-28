## How to start

Use this guide if you know what you are doing. You need an AWS account and basic knowledge around IAM, SQS, EC2 and creating Alexa skills.

### Setup
If you are on gnome you can add a .local/autostart entry to get the script running on login.

You need a dedicated SQS for reading from the machine you are running this script from, which is meant to 
contain alexa intents.

Use the provided .config/autostart and .local/bin to setup your startup.


#### AWS with Raspberry Pi setup

- Create an ec2 instance running ubuntu and install `ds4drv`
- Create two SQS queues (one for the gaming pc, one for the raspberry pi)
- Create a lambda function that forwards alexa events to the sqs queue. [Example](https://www.playingplaces.com/posts/implementation/#building-the-custom-skill)
- Create an alexa skill and connect it to the lambda function
- Create the gaming pc user that can access SQS and describe ec2 instances. On the gaming PC use `aws configure` to setup the AWS keys.
- Create the raspberry pi user that can access the other SQS queue). On the raspberry pi use `aws configure` to setup the AWS keys.
- Install wakeonlan on the raspberry pi


#### First test
- Create a turn off gaming pc intent on your alexa skill. When you trigger it, the gaming PC and raspberry pi will read the message from the queues and turn off.
- Turn on the raspberry pi. Create a turn on gaming pc intent on your alexa skill. Enable wake on lan on your gaming pc bios settings. When you trigger it, the raspberry pi should read the message from the queue and send a wake on lan to the gaming pc. The gaming pc should turn on.
- Follow the [code](https://github.com/vaslabs/home-automation/blob/master/index.js) for more Alexa skill Intents


## Special cases

Assuming your Alexa skill has all the intents the [code](https://github.com/vaslabs/home-automation/blob/master/index.js) expects.

### Sequence for adding 4 players with dual shock 4 controllers

1. Start ds4drv on your machine you have physical access to (the client).
2. On the gaming PC, start ds4drv
3. Make sure ds4drv is also running on the ec2 instance and maps the controllers to /dev/input/event4 and /dev/input/event5 (if not, adapt the code, these values are hardcoded in the shell scripts).
4. Connect 2 virtual controllers on your client to the ec2. Guidance [here](https://github.com/vaslabs/home-automation/blob/master/.bash_aliases)
5. Connect your dual shock controllers with bluetooth as normal.
6. Start remote play to connect to the gaming pc
7. Tell alexa to connect controllers
8. Wait for the xbox 360 notifications to appear
9. Make sure your 2 controllers work
10. Connect 2 more controllers
11. Tell alexa to add two more players (trigger the add 2 players intent)

### Remote play does not connect

If your devices are connected to the internet this can happen due to the gaming PC being frozen or steam being unresponsive. On the first case you need to have smart plugs to turn them off and force a power down. For the second case you can have a restart steam intent (supported in the code)
