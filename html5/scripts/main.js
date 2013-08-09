require(['jquery', 'QEnv'], function($, QEnv) {

	var selectedTool = '';

	$(document).ready(function() {

		var qenv = new QEnv();
		
		qenv.context = $('#canvas')[0].getContext('2d');
		qenv.context.canvas.width = window.innerWidth;
		qenv.context.canvas.height = window.innerHeight;

		var toggle = false;

		$('#canvas').on('mousemove', qenv.mouseMoveHandler);
		$('#canvas').on('mousedown', qenv.mouseDownHandler);
		$('#canvas').on('mouseup', qenv.mouseUpHandler);

		qenv.animloop();
		qenv.showFPS();
		initializeToolbar();
	});

	function initializeToolbar(qenv) {
		$('#streamsButton').on('click', toolbarHandler);
		$('#nodesButton').on('click', toolbarHandler);
	};

	function toolbarHandler(event) {
		var tool = $(this)[0].id;

		$('#toolbar').children().each()


		// switch (tool) {
		// 	case 'streamsButton':
				
		// 		break;
		// 	default:
		// 		break;
		// }
	};
});


