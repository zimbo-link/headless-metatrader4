var https = require("https");
const fs = require('fs');
const WebSocket = require("ws").Server;

var _PORT = 443; 
const options = {
    key: fs.readFileSync('/etc/letsencrypt/live/prod.zimbo.link/privkey.pem'),
    cert: fs.readFileSync('/etc/letsencrypt/live/prod.zimbo.link/fullchain.pem')
};

srvr = https.createServer(options, function onRequest(request, response) {
	request.setEncoding("utf8");
	var content = []; 
	request.addListener("data", function(data) {
		content.push(data); //Collect the incoming data
	});
	if(request.url == "/health") {
		response.writeHead(200, {'Content-Type': 'text/plain'});
		response.writeHead(200, {'Access-Control-Allow-Origin': '*'});
		response.end('200 OK\n');
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