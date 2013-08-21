
define("QEnv", ['jquery', 'QNode'], function($, QNode) {
	
	var QEnv = function() {
		
		var myself = this;
		myself.context = {};
		myself.fps = 0;
		myself.now = lastUpdate = (new Date()) * 1 - 1;
		myself.fpsFilter = 50;
		myself.fpsInterval = 0;
		myself.nodesList = [];
		myself.canvasNode = $('#canvas');
		myself.fpsNode = $('#fps');
		myself.myRectangle = {
			x: 250,
			y: 70,
			width: 100,
			height: 50,
			borderWidth: 5
		};
		myself.startTime = (new Date()).getTime();

		// -------------------------------------------------------------------
	
		this.mouseDownHandler = function(event) {
			console.log(event);
			console.log(myself.context);
			myself.nodesList.push(new QNode(event.clientX, event.clientY, myself.context));
			console.log(myself.nodesList.length);
		};

		// -------------------------------------------------------------------

		this.mouseUpHandler = function(event) {};

		// -------------------------------------------------------------------

		this.mouseMoveHandler = function(event) {};

		// -------------------------------------------------------------------

		this.requestAnimFrame = function(){
			return window.requestAnimationFrame ||
			window.webkitRequestAnimationFrame ||
			window.mozRequestAnimationFrame ||
			function( callback ){
				window.setTimeout(callback, 1000 / 60);
			};
		};

		// -------------------------------------------------------------------

		this.render = function() {
			var thisFrameFPS = 1000 / ((now = new Date()) - lastUpdate);
			myself.fps += (thisFrameFPS - myself.fps) / myself.fpsFilter;
			if (isNaN(myself.fps)) {
				myself.fps = 0;
			}
			lastUpdate = now;

			// update
			var time = (new Date()).getTime() - myself.startTime;
			var amplitude = 150;

			// in ms
			var period = 2000;
			var centerX = window.innerWidth / 2 - 100 / 2;
			var nextX = amplitude * Math.sin(time * 2 * Math.PI / period) + centerX;
			myself.myRectangle.x = nextX;

			// clear
			myself.context.clearRect(0, 0, window.innerWidth, window.innerHeight);

			// draw
			myself.drawRectangle(myself.myRectangle, myself.context);
		};

		this.drawRectangle = function(myRectangle, context) {
			context.beginPath();
			context.rect(myRectangle.x, myRectangle.y, myRectangle.width, myRectangle.height);
			context.fillStyle = '#8ED6FF';
			context.fill();
			context.lineWidth = myRectangle.borderWidth;
			context.strokeStyle = 'black';
			context.stroke();
		};

		// -------------------------------------------------------------------

		this.animloop = function() {
			window.requestAnimFrame(myself.animloop);
			myself.render();
		};

		// -------------------------------------------------------------------

		this.showFPS = function() {
			myself.fpsNode.show();
			myself.fpsInterval = setInterval(function(){
				myself.fpsNode.html(String(myself.fps.toFixed(1) + " fps"));
			}, 1000);
		};

		// -------------------------------------------------------------------

		this.hideFPS = function() {
			clearInterval(myself.fpsInterval);
			myself.fpsNode.hide();
		};

		// -------------------------------------------------------------------

		this.initializeToolbar = function() {
			$('#streamButton').on('click', myself.toolbarHandler);
			$('#nodeButton').on('click', myself.toolbarHandler);
			$('#gearButton').on('click', myself.toolbarHandler);
		};

		// -------------------------------------------------------------------

		this.toolbarHandler = function(event) {
			selectedTool = $(this)[0].id;

			$('#toolbar li div').each(function(i, val) {
				$(val).removeClass($(val)[0].id + 'Down');
			});

			$('#' + selectedTool).addClass(selectedTool + 'Down');

		};

		// -------------------------------------------------------------------
		// -------------------------------------------------------------------

		window.requestAnimFrame = myself.requestAnimFrame();

		myself.context = myself.canvasNode[0].getContext('2d');
		myself.context.canvas.width = window.innerWidth;
		myself.context.canvas.height = window.innerHeight;
		myself.animloop();
		myself.showFPS();
		myself.initializeToolbar();

		myself.canvasNode.on('mousemove', myself.mouseMoveHandler);
		myself.canvasNode.on('mousedown', myself.mouseDownHandler);
		myself.canvasNode.on('mouseup', myself.mouseUpHandler);
	};

	return QEnv;
});