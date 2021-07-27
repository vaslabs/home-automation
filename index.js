const { Consumer } = require('sqs-consumer');
const { exec } = require("child_process");

const PC_MAC_ADDRESS = process.env.PC_MAC_ADDRESS
const wakeOnLanCommand = PC_MAC_ADDRESS ? `wakeonlan ${PC_MAC_ADDRESS}` : "echo NoOp"
const QUEUE_URL = process.env.QUEUE_URL
const RESTART_STEAM_COMMAND = onlyOnGamingPC("/usr/bin/kill --verbose --timeout 3000 TERM --timeout 7000 KILL --signal QUIT $(pgrep steam | head -n1) && sleep 5 && DRI_PRIME=1 steam")
const START_STEAM_COMMAND = onlyOnGamingPC("DRI_PRIME=1 steam")
const forward_controllers_command = onlyOnGamingPC("./stream_controllers.sh")
const add_two_players_command = onlyOnGamingPC("./stream_controllers.sh more")
const stop_controllers_command = onlyOnGamingPC("./stop_controller_streaming.sh")
const update_proton_command = onlyOnGamingPC("./update_proton_ge.sh")

const mapping = {
  "TurnOnPc": {command: wakeOnLanCommand},
  "TurnOffPc": {command: "poweroff"},
  "RestartSteam": {command: RESTART_STEAM_COMMAND},
  "StartSteam": {command: START_STEAM_COMMAND},
  "RestartPC": {command: "reboot"},
  "ForwardControllers": {command: forward_controllers_command},
  "AddTwoPlayers": {command: add_two_players_command},
  "StopControllerForwarding": {command: stop_controllers_command},
  "UpdateGEProton": {command: update_proton_command}
}

const app = Consumer.create({
  queueUrl: QUEUE_URL,
  handleMessage: async (message) => {
    const intent = JSON.parse(message.Body)
    console.log(intent)
    const game = mapping[intent.name]
    if (game) {
      console.log(game.message)
      if (game.command) {
        run(game.command)
      }
    }
  }
});
 
app.on('error', (err) => {
  console.error(err.message);
});
 
app.on('processing_error', (err) => {
  console.error(err.message);
});
 
app.start();

function run(command) {
  exec(`${command} &`, (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
    });
}

function onlyOnGamingPC(command) {
  return PC_MAC_ADDRESS ? "echo NoOp" : command;
}
