
SC.Node = function( socket ) {
    this.socket = socket;
};

SC.Node.prototype.collisionHandler = function(prtcl, node) {
    console.log("collided");
    if ( ! node.active ) {
        socket.emit('osc', {
            address: "/carrier/freq",
            args: [440.4, node.freq, prtcl.body.speed]
        });

        socket.emit('midi', {
            address: "/carrier/freq",
            args: [176,22,1]
        });

        node.active = true;
    }
};