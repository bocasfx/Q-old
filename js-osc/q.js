
var SC = SC || {};
var game = new Phaser.Game(800, 600, Phaser.AUTO, '', { preload: preload, create: create, update: update });

// Connect to the web socket server (node.js)
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

// Preload sprites
function preload() {
    game.load.image('node', 'assets/node.png');
    game.load.image('particle', 'assets/ball2.png');
}

// Create actors
function create() {
    nodes = game.add.group();
    nodes.enableBody = true;

    particles = game.add.group();
    particles.enableBody = true;

    streams = game.add.group();
    streams.enableBody = true;

    // prtcl = particles.create(0, 0, 'particle');

    game.input.addMoveCallback(pointerMoved, this);
    game.input.onDown.add(pointerDown, this);
}

function update() {
    // prtcl.x = prtcl.x + 1;
    // prtcl.y = prtcl.y + 1;

    // for (var i = nodes.length - 1; i >= 0; i--) {
    //     var node = nodes.getAt(i);
    //     var collided = game.physics.arcade.overlap(prtcl, node, collisionHandler, null, this);
    //     if ( ! collided ) {
    //         node.active = false;
    //     }
    // }

    // for (var i = streams.length - 1; i >= 0; i--) {
    //     streams[i].flow();
    // }
}

function pointerMoved ( pointer, x, y ) {
        // console.log("moved.");
    }

function pointerDown ( pointer, x, y ) {
    // console.log("down.");
    // var nodeSprite = nodes.create(pointer.x - 15, pointer.y - 15, 'node');
    // nodeSprite.node = new SC.Node(socket);

    var stream = new SC.Stream( game, streams );
}
