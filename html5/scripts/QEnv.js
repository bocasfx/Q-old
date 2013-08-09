
define("QEnv", ['jquery'], function($) {
	
	var QEnv = function() {
		
		var myself = this;

		this.context = {};		

		var fpsNode = $('#fps');
		var fps = 0;
		var now, lastUpdate = (new Date)*1 - 1;
		var fpsFilter = 50;
		var fpsInterval;
	
		this.mouseDownHandler = function(event) {
			
		};

		this.mouseUpHandler = function(event) {};

		this.mouseMoveHandler = function(event) {};

		this.requestAnimFrame = function(){
			return window.requestAnimationFrame ||
			window.webkitRequestAnimationFrame ||
			window.mozRequestAnimationFrame ||
			function( callback ){
				window.setTimeout(callback, 1000 / 60);
			};
		};

		this.render = function() {
			var thisFrameFPS = 1000 / ((now = new Date) - lastUpdate);
			fps += (thisFrameFPS - fps) / fpsFilter;
			if (fps == NaN) {
				fps = 0;
			}
			lastUpdate = now;
		};

		this.animloop = function() {
			window.requestAnimFrame(myself.animloop);
			myself.render();
		};

		this.showFPS = function() {
			fpsNode.show();
			fpsInterval = setInterval(function(){
				fpsNode.html(String(fps.toFixed(1) + " fps"));
			}, 1000);
		}

		this.hideFPS = function() {
			clearInterval(fpsInterval);
			fpsNode.hide();
		}

		window.requestAnimFrame = myself.requestAnimFrame();
	};

	return QEnv;
});