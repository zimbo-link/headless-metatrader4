var request = require('request');

request.post(
    'http://localhost:8080',
    { json: { account: 5000, profit: -27.5 } },
    function (error, response, body) {
        if (!error && response.statusCode == 200) {
            console.log(response.statusCode,body);
        }
    }
);