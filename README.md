## How to start
### Setup
If you are on gnome you can add a .local/autostart entry to get the script running on login.

You need a dedicated SQS for reading from the machine you are running this script from, which is meant to 
contain alexa intents.

Use the provided .config/autostart and .local/bin to setup your startup.


### AWS with Raspberry Pi setup

- Create an ec2 instance
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
