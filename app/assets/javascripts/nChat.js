function Chat(user) {
	this.user = user;
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
	      var currentMsg = new Message(msg, new Date().getTime());
	      addMessage(user, currentMsg);
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
		var user = new User("kamal", "http://gravatar.com/avatar/4cc30665303007ca1b503141d3f85858.jpg?d=monsterid" );
		console.log("user:" + user.getUserHTML());
	    var text = "message............ kdsafhjahd";
	    var message = new Message(text, new Date().getTime());
	    addMessage(user, message);
	    
	},2000);

	function addHtmlToChatBox(html) {
		$printer.append("<div class='message-html'>" + html + "<div>");
		scrollBottom(); 
	}

	function addMessage(user, message) {
		addHtmlToChatBox("<div class='user-msg-area'>" + user.getUserHTML() + message.getMessageHTML() + "</div>");
		$('.timeago').timeago('refresh');
	}

}



function User(name, picture) {
	this.name = name;
	this.picture = picture;
}

User.prototype.getUserHTML = function() {
	console.log("user html");
	var html = '<div class="user-display-area"><div class="user-picture">'
	+ '<img src="' + 
		this.picture +
	'"></div><div class="username">' + this.name + '</div></div>';
	console.log("html:" + html);
	return html;
}

function Message(text, time) {
	this.text = text;
	this.time = time;
}

Message.prototype.getMessageHTML = function() {
	var date = new Date(this.time);
	var msgHtml = "<div class='text-msg-area'><div class='text-msg'>" + 
					linkifyHtml(this.text, {defaultProtocal: 'http'}) + //TODO: html encode text
					"</div>" + "<div class='msg-timestamp'>" + 
					"<time class='timeago' datetime='" + 
						new Date(date).toISOString() + "' >" + 
						new Date(date).toString() +  
					"</time></div>";
	return msgHtml;
}

jQuery(document).ready(function() {
	var user = new User("kamal Joshi", "http://gravatar.com/avatar/4cc30665303007ca1b503141d3f85858.jpg?d=monsterid");
  	Chat(user);
});