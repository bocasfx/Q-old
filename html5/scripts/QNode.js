define("QNode", ['jquery'], function($) {
	
	var QNode = function(x, y, context) {
		var myself = this;
		myself.x = x;
		myself.y = y;
		myself.context = context;

		this.render = function() {
			myself.context.beginPath();
			myself.context.arc(myself.x, myself.y, 20, 0, 2*Math.PI);
			myself.context.strokeStyle = '#FAB727';
			myself.context.lineWidth = 2;
			myself.context.stroke();
		}
	};

	return QNode;
});