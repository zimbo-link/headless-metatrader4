var express = require('express');
var https = require('https');
var http = require('http');
var fs = require('fs');
require('dotenv').config();
// This line is from the Node.js HTTPS documentation.
///home/winer/.wine/drive_c/mt4/MQL4/Node/certs/loc.23b.io/privkey.pem
 
 
var options = {
    key: fs.readFileSync('certs/loc.23b.io/privkey.pem'),
    cert: fs.readFileSync('certs/loc.23b.io/fullchain.pem')
};
// Create a service (the app object is just a callback).
var app = express();

// Create an HTTP service.
http.createServer(app);
// Create an HTTPS service identical to the HTTP service.
https.createServer(options, app);

app.listen = function () {
    var server = http.createServer(this)
    return server.listen.apply(server, arguments)
}

app.get('/', (req, res) => {
    res.send('OK')
})