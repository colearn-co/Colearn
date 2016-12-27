function Chat(currentUser, users, options, newMsgCallback) {
	this.newMsgCallback = newMsgCallback;
	this.currentUser = currentUser;
	var scrollTopEventCallback;
	var usersMap = {};
	users.forEach(function(user) {
		usersMap[user.id] = user;
	});
	usersMap[currentUser.id] = currentUser;
	
	var $chatArea     = $('.chat-area'),
		$userArea = $('.user-area'),
	    $printer  = $('.messages'),
	    $textArea = $('.message-input-area'),
	    preventNewScroll = false;

	$textArea.focus();
	$('.messages').scroll(function() {
	    var pos = $('.messages').scrollTop();
	    if (pos >= 0 && pos < 8) {
	    	if (scrollTopEventCallback) {
	       		scrollTopEventCallback();
	    	}
	    }
	});
	//add all users to user area
	addUsersToUserArea(users);

	function addUser(user) {
		if (!userMap[user.id]) {
			userMap[user.id] = user;
			addUserToUserArea(user);
		}
	}

	function addUserToUserArea(user) {
		$userArea.append(user.getUserHTMLUserArea());
	}
	function addUsersToUserArea(users) {
		$userArea.empty();
		users.forEach(function(user) {
			addUserToUserArea(user);
		});
		$('.timeago').timeago('refresh'); //TODO fix dom parsing every time for time update
	}

	//// SCROLL BOTTOM	
	function scrollBottom() {
		$(".messages").scrollTop($(".messages")[0].scrollHeight); //TODO: add animation.
		//$printer.stop().animate( {scrollTop: $printer[0].scrollHeight - printerH  }, 600); // SET SCROLLER TO BOTTOM
	}
	$(window).resize(function() {
		scrollBottom();
	});	
	scrollBottom(); 
	window.onload = function() {
    	scrollBottom(); // scroll bottom again after all images are loaded.
	};
	function postMessage(e) {  
	  // on Post click or 'enter' but allow new lines using shift+enter
	  if (e.type=='click' || (e.which==13 && !e.shiftKey)) { 
	    //e.preventDefault();
	    var msg = $textArea.val(); // not empty / space
	    $textArea[0].value=''; // CLEAR TEXTAREA
	    msg = msg.replace(/^\s+|\s+$/g, ''); // replaceing linebreaks
	    msg = $.trim(msg);
	    if(msg) {
	      var currentMsg = new Message({
	      	message: msg, created_at: new Date()
	      }, currentUser);
	      if (newMsgCallback) {
	      	newMsgCallback(currentMsg.text);
	      }
	      addMessage(currentMsg);
	     
	      scrollBottom(); // DO ON POST
	        
	    } 
	  }
	}

	$textArea.keyup(postMessage);

	function addHtmlToChatBox(html) {
		$printer.append(html);
		scrollBottom(); 
	}
	function addHtmlsToChatBox(htmls) {
		var es = [];
		htmls.forEach(function(html) {
			es.push(html);
		});
		$printer.append(es);
		scrollBottom(); 
	}

	function prependHtmlsToChatBox(htmls) {
		var es = [];
		htmls.forEach(function(html) {
			es.push(html);
		});
		$printer.prepend(es);
	}

	function addHtmlToUserArea(html) {
		$userArea.append(html);
	}

	function getMessageHtml(message) {
		return '<div class="message-html" data-uid="' + message.user.id + '" data-time="' + message.time + '" >'
										+ message.getMessageHTML() + "</div>";
	}
	function addMessage(message) {
		var lastElem = $('.messages .message-html:last');
		if (lastElem.data("uid") == message.user.id && message.time - parseInt(lastElem.data('time')) < 60 *1000) {
			lastElem.data('time', message.time);
			lastElem.find('.text-msg-area').append(message.getMessageContent());
		} else {
			addHtmlToChatBox(getMessageHtml(message));
		}
		$('.timeago').timeago('refresh');
	}
	function addMessages(messages) {
		if (messages.length > 0) {
			for (i = 0; i < messages.length; i++) {
				addMessage(messages[i]);
			}
			$('.timeago').timeago('refresh');	
		}
	}
	function addMessagesToTop(messages) {
		if (messages.length > 0) {
			var firstMsg = $('.messages .message-html:first'); // get top element of div.
				var lastElem = $('');
			messages = messages.reverse();
			for (i = 0; i < messages.length; i++) {
				var message = messages[i];
				if (lastElem.data("uid") == message.user.id &&  parseInt(lastElem.data('time') - message.time) < 60 *1000) {
					lastElem.data('time', message.time);
					lastElem.find('.text-msg-area').prepend(message.getMessageContent());
					lastElem.find('.username-msg-area .msg-timestamp .timeago').attr('datatime', new Date(message.time).toISOString())
			
				} else {
					prependHtmlsToChatBox([getMessageHtml(messages[i])]);
				}
				var lastElem = $('.messages .message-html:first');
			}
			$(".messages").scrollTop(firstMsg.position().top)
			$('.timeago').timeago('refresh');	
		}
        
	}
	// public methods
	this.addUsersToUserArea = addUsersToUserArea;
	this.addMessage = addMessage;
	this.addMessages = addMessages;
	this.addMessagesToTop = addMessagesToTop;
	this.setScrollTopEventCallback = function(callback) {
		scrollTopEventCallback = callback;
	}

}
