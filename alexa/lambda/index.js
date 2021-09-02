const AWS = require('aws-sdk');

const sqs = new AWS.SQS({apiVersion: '2012-11-05'}); 

const RPI_QUEUE = process.env.RPI_QUEUE;
const GAMING_PC_QUEUE = process.env.GAMING_PC_QUEUE;

exports.handler = (event, context, callback) => {
 
  sendMessage(RPI_QUEUE, event);
  sendMessage(GAMING_PC_QUEUE, event);
  
};

function sendMessage(queue, event) {
    sqs.sendMessage(params(queue, event), function(err, data) {
        if (err) {
          console.log("Error", err);
          context.succeed(response);
        } else {
          console.log("Success", data.MessageId);
          context.succeed(response);
        }
      });
}


function params(queueUrl, event) {
    const params = {
      DelaySeconds: 10,
      MessageAttributes: {
      },
      MessageBody: JSON.stringify(event.request.intent),
      QueueUrl: queueUrl
    };
  
  return params;
}


const response = 
{
  "version": "1.0",
  "sessionAttributes": {
  },
  "response": {
    "outputSpeech": {
      "type": "PlainText",
      "text": "Roger that"
    },
    "shouldEndSession": true
  }
}
