const WebSocket = require("ws").Server;
const HttpsServer = require('https').createServer;
const HttpServer = require('http').createServer;
var http = require("http");
const fs = require("fs");
var WS_PORT = 8081; 
var HTTP_PORT = 8080;
var clients = [];
///home/winer/.wine/drive_c/mt4/MQL4/Node/certs/loc.23b.io/privkey.pem'
server = HttpServer({
    //cert: fs.readFileSync('/etc/letsencrypt/live/loc.23b.io/fullchain.pem'),
    //key: fs.readFileSync('/etc/letsencrypt/live/loc.23b.io/privkey.pem')
   // cert: fs.readFileSync('/home/winer/.wine/drive_c/mt4/MQL4/Node/certs/prod.zimbo.link/fullchain.pem'),
   // key: fs.readFileSync('/home/winer/.wine/drive_c/mt4/MQL4/Node/certs/prod.zimbo.link/privkey.pem')
})
socket = new WebSocket({
    server: server
});
socket.getUniqueID = function () {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
    }
    return s4() + s4() + '-' + s4();
};
socket.on('connection', ws => {
	ws.id = socket.getUniqueID();

	if(clients.lenght > 8)
		clients = [];

	clients.push( ws );
	console.log("connect: ", ws.id, " count: ", clients.length);
  
	ws.on('close', () => {
		const index = clients.indexOf(ws);
		if (index > -1) {
		  clients.splice(index, 1);
		}
		console.log("connect: ", ws.id, " count: ", clients.length);
	});
	ws.on('message', message => {
		//console.log(`Received message => ${message}`);
		lastMsg = message;
	});  
});
server.listen(WS_PORT);
console.log("WSS server listening on port " + WS_PORT);

srvr = http.createServer(function onRequest(request, response) {
    request.setEncoding("utf8");
    var content = [];
    request.addListener("data", function (data) {
        content.push(data); //Collect the incoming data
    });
    if (request.url == "/health") {
        response.writeHead(200, { 'Content-Type': 'text/plain' });
        response.writeHead(200, { 'Access-Control-Allow-Origin': '*' });
        response.end('200 OK\n');
        return;
    }
    request.addListener("end", function () {
        response.writeHead(200, { "Content-Type": "text/plain" });
        ms = content[0];
        if (ms && ms.toString() != "") {
            var msg = ms.toString();
            var reqObj = JSON.parse(msg);
            //console.log(JSON.stringify(reqObj));
            clients.forEach(function (client) {
                client.send(JSON.stringify(reqObj));
            });
            response.write(JSON.stringify(reqObj));
            response.end();
        }
    });
});
srvr.listen(HTTP_PORT);
console.log("HTTP server listening on port " + HTTP_PORT);