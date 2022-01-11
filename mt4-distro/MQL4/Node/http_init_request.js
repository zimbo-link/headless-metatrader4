var request = require('request');
//string reqest = StringConcatenate("{\"type\":\"",4,"\",\"account\":\"",AccountNumber(),"\",\"ivinvest_id\":\"",IvInvest,"\"}");
require('dotenv').config();

 // "239482"
request.post(
    'http://'+process.env.IBOT_HOST+':'+process.env.IBOT_PORT+'/confirmations',
    { 
        json: { 
            type: 4, 
            account: process.env.MT4_ACCOUNT,
            ivinvest_id: process.env.IVINVEST_ID
        } 
    },
    function (error, response, body) {
        if (!error && response.statusCode == 200) {
            console.log(body);
        }
    }
);