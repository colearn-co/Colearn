function Chat(currentUser, users, newMsgCallback) {
	this.currentUser = currentUser;
	this.users = users;
	this.newMsgCallback = newMsgCallback;
	var $chatArea     = $('.chat-area'),
		$userArea = $('.user-area'),
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
	scrollBottom(); 
	function postMessage(e){  
	  // on Post click or 'enter' but allow new lines using shift+enter
	  if (e.type=='click' || (e.which==13 && !e.shiftKey)) { 
	    e.preventDefault();
	    var msg = $textArea.val(); // not empty / space
	    if($.trim(msg)) {
	      var currentMsg = new Message(msg, new Date().getTime());
	      if (newMsgCallback) {
	      	newMsgCallback(currentMsg);
	      }
	      addMessage(currentUser, currentMsg);
	      $textArea[0].value=''; // CLEAR TEXTAREA
	      scrollBottom(); // DO ON POST
	        
	    } 
	  }
	}


	//// PREVENT SCROLL TO BOTTOM WHILE READING OLD MESSAGES
	$printer.hover(function( e ) {
	  preventNewScroll = e.type=='mouseenter' ? true : false ;
	  if (!preventNewScroll) { scrollBottom(); } // On mouseleave go to bottom
	});

	$textArea.keyup(postMessage);

	//// TEST ONLY - SIMULATE NEW MESSAGES
	var i = 0;
	intv = setInterval(function(){
		var user = new User({
			name: "kamal", 
			picture: "http://gravatar.com/avatar/4cc30665303007ca1b503141d3f85858.jpg?d=monsterid" 
		});
		console.log("user:" + user.getUserHTML());
	    var text = "message............ kdsafhjahd";
	    var message = new Message(text, new Date().getTime());
	    addMessage(user, message);
	    addHtmlToUserArea(user.getUserHTML());
	    
	},2000);

	function addHtmlToChatBox(html) {
		$printer.append("<div class='message-html'>" + html + "<div>");
		scrollBottom(); 
	}

	function addHtmlToUserArea(html) {
		$userArea.append(html);
	}

	function addMessage(user, message) {
		addHtmlToChatBox("<div class='user-msg-area'>" + user.getUserHTML() + message.getMessageHTML() + "</div>");
		$('.timeago').timeago('refresh');
	}

}


function User(user) {
	this.name = user.name;
	this.picture = user.picture;
	this.status = user.status;
	if (!user.status) {
		this.status = "online";
	}
}

User.prototype.getUserHTML = function() {
	console.log("user html");

	var html = '<div class="user-display-area"><div class="user-picture">'
	+ '<img class="' + getStatusClass(this.status) + '" src="' + 
		this.picture +
	'"></div><div class="username">' + this.name + '</div></div>';
	console.log("html:" + html);
	return html;
	function getStatusClass(status) {
		return status;
	}
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
	var user = new User({name: "kamal Joshi", 
		picture: "http://gravatar.com/avatar/4cc30665303007ca1b503141d3f85858.jpg?d=monsterid", 
		status: "online"});
  	Chat(user, function(msg) {
  		console.log("New message: " + msg);
  		//send to server
  	});
});