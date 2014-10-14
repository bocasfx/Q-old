
SC.Stream = function( game ) {
	this.game = game;
	this.queue = [];
	this.path = [];
	this.streamSize = 400;
	this.particleCount = 10;
	this.active = false;
	this.headPosition = '';
	this.mouseState = 'up';
	this.pathIndex = 0;
	this.easing = '';
	this.children = [];
	var sprite = game.add.sprite(0, 0, 'particle');
	var tween = game.add.tween(sprite);
	tween.to({ x: 600 }, 6000);
	tween.start();
};

SC.Stream.prototype.flow = function() {
	if ( this.active && this.headPosition !== '' ) {
        if (this.mouseState == "up" ) {
            if (this.path.length > 0 ) {
                this.headPosition = this.path[this.pathIndex];
                this.advancePathIndex();
            }
        } else {
			this.path.push(this.headPosition);
			if (this.queue.length < this.streamSize) {
				this.queue.push(this.headPosition);
			}
		}
		if ( this.easing === '' ) {
            this.easing = this.headPosition;
        }

        this.easing = this.calculateEasing( this.headPosition, this.easing, 0.08 );
        this.queue[0] = this.easing;
        this.queue.rotate(1);

        var i = 1;
        var j = 0;
        while ( i < this.queue ) {
            this.children[j].pos = this.queue[i];
            i += (this.streamSize / this.particleCount);
            j += 1;
        }
	}
};

SC.Stream.prototype.advancePathIndex = function() {
	this.pathIndex += 1;
	if ( this.pathIndex >= this.path.length - 1 ) {
        this.pathIndex = 0;
    }
};


//		var sprite = game.add.sprite(-400, 0, 'einstein');

//     //  Here we create a tween on the sprite created above
//     var tween = game.add.tween(sprite);

//     //  The object defines the properties to tween.
//     //  In this case it will move to x 600
//     //  The 6000 is the duration in ms - 6000ms = 6 seconds
//     tween.to({ x: 600 }, 6000);

//     //  And this starts it going
//     tween.start();








