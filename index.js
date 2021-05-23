const { Consumer } = require('sqs-consumer');
const { exec } = require("child_process");

const PC_MAC_ADDRESS = process.env.PC_MAC_ADDRESS
const wakeOnLanCommand = PC_MAC_ADDRESS ? `wakeonlan ${PC_MAC_ADDRESS}` : "echo NoOp"

const mapping = {
  "StartOvercooked": {message: "Starting overcooked", id: "1243830"},
  "StartCantDriveThis": {message: "Starting can't drive this", id: "466980"},
  "StartFootball": {message: "Starting PES2021", id: "1259970"},
  "StartCyberpunk": {message: "Starting cyberpunk", id: "1091500"},
  "StartPlagueSimulation": {message: "Starting plague simulation", id: "246620"},
  "StartPlagueTaleInnocence": {message: "Starting plague tale: innocence", id: "752590"},
  "StartUltimateChickenHorse": {message: "Starting ultimate chicket horse", id: "386940"},
  "TurnOnPc": {command: wakeOnLanCommand},
  "TurnOffPc": {command: "poweroff"}
}

const app = Consumer.create({
  queueUrl: 'https://sqs.eu-west-1.amazonaws.com/459553275750/home_actions',
  handleMessage: async (message) => {
    const intent = JSON.parse(message.Body)
    console.log(intent)
    const game = mapping[intent.name]
    if (game) {
      console.log(game.message)
      if (game.id) {
        startGame(game.id)
      } else if (game.command) {
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

function startGame(gameId) {

    exec(`steam steam://rungameid/${gameId} &`, (error, stdout, stderr) => {
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