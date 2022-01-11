const WebSocket = require("ws").Server;
const HttpsServer = require('https').createServer;
const fs = require("fs");
var WS_PORT = 8081; 
var clients = [];
server = HttpsServer({
    cert: fs.readFileSync('/etc/letsencrypt/live/loc.23b.io/fullchain.pem'),
    key: fs.readFileSync('/etc/letsencrypt/live/loc.23b.io/privkey.pem')
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