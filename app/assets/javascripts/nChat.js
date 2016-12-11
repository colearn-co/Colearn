function Chat(currentUser, users, options, newMsgCallback) {
	this.currentUser = currentUser;
	var scrollTopEventCallback;
	var usersMap = {};
	users.forEach(function(user) {
		usersMap[user.id] = user;
	});
	usersMap[currentUser.id] = currentUser;
	this.newMsgCallback = newMsgCallback;
	var $chatArea     = $('.chat-area'),
		$userArea = $('.user-area'),
	    $printer  = $('.messages'),
	    $textArea = $('.message-input-area'),
	    printerH  = $printer.innerHeight(),
	    preventNewScroll = false;

	$textArea.focus();
	$('.messages').scroll(function() {
	    var pos = $('.messages').scrollTop();
	    if (pos > 0 && pos < 50) {
	    	if (scrollTopEventCallback) {
	       		scrollTopEventCallback();
	    	}
	    }
	});
	//add all users to user area
	for (var userId in usersMap) {
		addUserToUserArea(usersMap[userId]);
	}

	function addUser(user) {
		if (!userMap[user.id]) {
			userMap[user.id] = user;
			addUserToUserArea(user);
		}
	}

	function removeUser(user) {
		if (userMap[user.id]) {
			userMap.remove(user.id);
			removeUserFromUserArea();
		}
	}

	this.changeUserStatus = function (userId, newStatus) {
		var user = usersMap[userId];
		var imgElement = $userArea.find("#" + user.getUserElementId()).find("img");
		imgElement.removeClass(user.status);
		imgElement.addClass(newStatus);
		user.status = newStatus;
	} 

	function addUserToUserArea(user) {
		$userArea.append(user.getUserHTML());
	}

	function removeUserFromUserArea(user) {
		$("#" + user.getUserElementId()).remove();
	}
	//// SCROLL BOTTOM	
	function scrollBottom() {
	  if(!preventNewScroll){ // if mouse is not over printer
		$printer.stop().animate( {scrollTop: $printer[0].scrollHeight - printerH  }, 600); // SET SCROLLER TO BOTTOM
	  }
	}	
	scrollBottom(); 
	function postMessage(e) {  
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

	function addHtmlToChatBox(html) {
		$printer.append("<div class='message-html'>" + html + "<div>");
		scrollBottom(); 
	}

	function prependHtmlsToChatBox(htmls) {
		var es = [];
		htmls.forEach(function(html) {
			es.push("<div class='message-html'>" + html + "<div>");
		});
		$printer.prepend(es);
	}

	function addHtmlToUserArea(html) {
		$userArea.append(html);
	}

	function getUserMessageHtml(user, message) {
		return "<div class='user-msg-area'>" + user.getUserHTML() + message.getMessageHTML() + "</div>";
	}
	function addMessage(user, message) {
		addHtmlToChatBox(getUserMessageHtml(user, message));
		$('.timeago').timeago('refresh');
	}
	function addMessagesToTop(users, messages) {
		var htmls = [];
		for (i = 0; i < messages.length; i++) {
			htmls.push(getUserMessageHtml(users[i], messages[i]));
		}
		prependHtmlsToChatBox(htmls);
		$('.timeago').timeago('refresh');
	}

	this.addMessage = addMessage;
	this.addMessagesToTop = addMessagesToTop;
	this.setScrollTopEventCallback = function(callback) {
		scrollTopEventCallback = callback;
	}

}


jQuery(document).ready(function() {
	var user = new User({
		id: 2,
		name: "kamal Joshi", 
		picture: "http://gravatar.com/avatar/4cc30665303007ca1b503141d3f85858.jpg?d=monsterid", 
		status: "online"
	});
  	chat = new Chat(user, [user], function(msg) {
  		console.log("New message: " + msg);
  		//send to server
  	});
  	setTimeout(function() {
  		chat.changeUserStatus(2, "offline");
  	}, 5000);
  	setTimeout(function() {
  		var m = new Message("https://www.gravatar.com/avatar/98fdf4b6dee9b8156d22736311cd0d41?s=50", new Date().getTime(), {type: 'file'});
  		chat.addMessage(user, m);
  	}, 10000);
  	var isAddingDataToTop = false;
  	chat.setScrollTopEventCallback(function() {
  		console.log("Scroll top envent");
  		if (!isAddingDataToTop) {
  			isAddingDataToTop = true;
  			var ms = [];
  			var users = [];
	  		for (i = 0; i < 5;i++) {
	  			var m = new Message("m :" , new Date().getTime());
	  			m.text += i;
	  			ms.push(m);
	  			users.push(user);
	  		}
	  		chat.addMessagesToTop(users, ms);
	  		setTimeout(function() {
	  			isAddingDataToTop = false;	
	  		}, 5000);
  		}
  		
  	});
});