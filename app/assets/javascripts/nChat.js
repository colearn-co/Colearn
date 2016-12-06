function createChat() {
	var $chatArea     = $('.chat-area'),
	    $printer  = $('.messages'),
	    $textArea = $('.message-input-area'),
	    printerH  = $printer.innerHeight(),
	    preventNewScroll = false;

	$textArea.focus();

	//// SCROLL BOTTOM	
	function scrollBottom(){
	  if(!preventNewScroll){ // if mouse is not over printer
		$printer.stop().animate( {scrollTop: $printer[0].scrollHeight - printerH  }, 600); // SET SCROLLER TO BOTTOM
	  }
	}	
	scrollBottom(); // DO IMMEDIATELY

	function postMessage(e){  
	  // on Post click or 'enter' but allow new lines using shift+enter
	  if(e.type=='click' || (e.which==13 && !e.shiftKey)){ 
	    e.preventDefault();
	    var msg = $textArea.val(); // not empty / space
	    if($.trim(msg)){
	      $printer.append('<div>'+ msg.replace(/\n/g,'<br>') +'</div>');
	      $textArea[0].value=''; // CLEAR TEXTAREA
	      scrollBottom(); // DO ON POST
	      // HERE Use AJAX to post msg to PHP      
	    } 
	  }
	}


	//// PREVENT SCROLL TO BOTTOM WHILE READING OLD MESSAGES
	$printer.hover(function( e ) {
	  preventNewScroll = e.type=='mouseenter' ? true : false ;
	  if(!preventNewScroll){ scrollBottom(); } // On mouseleave go to bottom
	});

	$textArea.keyup(postMessage);

	//// TEST ONLY - SIMULATE NEW MESSAGES
	var i = 0;
	intv = setInterval(function(){
	    $printer.append("<div>Message ... "+ (++i) +"</div>");
	    scrollBottom(); // DO ON NEW MESSAGE (AJAX)
	},2000);
}

jQuery(document).ready(function() {
  createChat();
});