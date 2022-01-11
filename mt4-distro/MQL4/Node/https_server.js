var https = require("https");
const fs = require('fs');
 

///home/winer/.wine/drive_c/mt4/MQL4/Node/certs/loc.23b.io/privkey.pem

const options = {
    key: fs.readFileSync('/home/winer/.wine/drive_c/mt4/MQL4/Node/certs/loc.23b.io/privkey.pem'),
    cert: fs.readFileSync('/home/winer/.wine/drive_c/mt4/MQL4/Node/certs/loc.23b.io/fullchain.pem')
  }; 

  const optionsWSS = {
    key: fs.readFileSync('/home/winer/.wine/drive_c/mt4/MQL4/Node/certs/loc.23b.io/privkey.pem'),
    cert: fs.readFileSync('/home/winer/.wine/drive_c/mt4/MQL4/Node/certs/loc.23b.io/fullchain.pem'),
	port: 8081 
  }; 

const WebSocket = require('ws')
var _PORT = 8080; 

var clients = [];

 var srvr = {
	 listening : false 
 };

 var socket = new WebSocket.Server(optionsWSS);
var lastMsg = "";

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
})

srvr = https.createServer(options, function onRequest(request, response) {
	request.setEncoding("utf8");
	var content = []; 
	request.addListener("data", function(data) {
		content.push(data); //Collect the incoming data
	});
	if(request.url == "/getData") {
		response.writeHead(200, {'Content-Type': 'text/plain'});
		response.writeHead(200, {'Access-Control-Allow-Origin': '*'});
		response.end('get data\n');
		return;
	} 
	request.addListener("end", function() { 
		response.writeHead( 200, {"Content-Type": "text/plain"} ); 
		ms = content[0]; 
		if(ms && ms.toString() != "") {
			var msg = ms.toString(); 
			console.log(msg);
			var reqObj = JSON.parse(msg); 
			clients.forEach(function(client) {
				client.send(JSON.stringify(reqObj));
			});
			response.write(lastMsg); 
			response.end(); 
		} 
	}); 
});
srvr.listen(_PORT);  
console.log("Node.js HTTPS server listening on port "+ _PORT);
