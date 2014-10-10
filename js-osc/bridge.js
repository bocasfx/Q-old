var osc = require('node-osc'),
    io = require('socket.io').listen(8082),
    midi = require('midi');

var oscServer, oscClient;

io.sockets.on('connection', function (socket) {
  socket.on("config", function (obj) {
    oscServer = new osc.Server(obj.server.port, obj.server.host);
    oscClient = new osc.Client(obj.client.host, obj.client.port);

    oscClient.send('/status', socket.sessionId + ' connected');

    oscServer.on('message', function(msg, rinfo) {
      console.log(msg, rinfo);
      socket.emit("message", msg);
    });
  });
  socket.on("osc", function (obj) {
    console.log("osc message");
    oscClient.send(obj);
  });
  socket.on("midi", function (obj) {
    console.log("midi message");
    var output = new midi.output();
    output.getPortCount();
    output.getPortName(0);
    output.openPort(0);
    output.sendMessage(obj.args);
    output.closePort();
  });
});
