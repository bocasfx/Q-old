$( document ).ready(function() {

    // var game = new Phaser.Game($(window).width(), $(window).height(), Phaser.AUTO, '', { preload: preload, create: create, update: update });
    var game = new Phaser.Game(800, 600, Phaser.AUTO, '', { preload: preload, create: create, update: update });

    $(window).resize(function() { resizeGame(); } );

    function resizeGame() {
        var height = $(window).height();
        var width = $(window).width();
            
        game.width = width;
        game.height = height;
        game.stage.width = width;
        game.stage.height = height;
            
        if (game.renderType === Phaser.WEBGL)
        {
            game.renderer.resize(width, height);
        }
    }

    socket = io.connect('http://127.0.0.1', { port: 8082, rememberTransport: false});
    socket.on('connect', function() {
        // sends to socket.io server the host/port of oscServer
        // and oscClient
        socket.emit('config',
            {
                server: {
                    port: 3333,
                    host: '127.0.0.1'
                },
                client: {
                    port: 3334,
                    host: '127.0.0.1'
                }
            }
        );
    });

    
    var prtcl;

    function preload() {
        game.load.image('node', 'assets/node.png');
        game.load.image('particle', 'assets/ball2.png');
    }

    function create() {
        nodes = game.add.group();
        nodes.enableBody = true;

        particles = game.add.group();
        particles.enableBody = true;

        prtcl = particles.create(0, 0, 'particle');

        game.input.addMoveCallback(pointerMoved, this);
        game.input.onDown.add(pointerDown, this);
        
    }

    function pointerMoved ( pointer, x, y) {
        console.log("moved.");
    }

    function pointerDown ( pointer, x, y) {
        console.log("down.");
        var node = nodes.create(pointer.x - 15, pointer.y - 15, 'node');
        node.freq = 666.0;
        node.active = false;
        
    }

    function update() {
        prtcl.x = prtcl.x + 1;
        prtcl.y = prtcl.y + 1;

        for (var i = nodes.length - 1; i >= 0; i--) {
            var node = nodes.getAt(i);
            var collided = game.physics.arcade.overlap(prtcl, node, collisionHandler, null, this);
            if ( ! collided ) {
                node.active = false;
            }
        }
        
    }

    function collisionHandler(prtcl, node) {
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
    }
});


// "/carrier/freq" ",f" 440.4  
// {
//   address: "/carrier/freq",
//   args: [440.4]
// }

// "/float/andArray" ",f[ii]" 440.4 42 47  
// {
//   address: "/carrier/freq",
//   args: [
//     440.4, [42, 47]
//   ]
// }

// "/aTimeTag" ",t" 3608146800 2147483648  
// {
//   address: "/scheduleAt",
//   args: [
//     {
//       raw: [3608146800, 2147483648],
//       jsTime: 1399158000500
//     }
//   ]
// }

// "/blob" ",b" 0x63 0x61 0x74 0x21    
// {
//   address: "/blob",
//   args: [
//     Uint8Aray([0x63, 0x61, 0x74, 0x21])
//   ]
// }
    
// "/colour" ",r" "255 255 255 255"    
// {
//   address: "/colour",
//   args: [{
//       r: 255,
//       g: 255,
//       b: 255,
//       a: 1.0
//     }
//   ]
// }

// "/midiMessage" ",m" 0x00 0x90 0x45 0x65 
// {
//   address: "/midiMessage",
//   args: [
//     // Port ID, Status, Data 1, Data 2
//     Uint8Array([0, 144, 69, 101])
//   ]
// }