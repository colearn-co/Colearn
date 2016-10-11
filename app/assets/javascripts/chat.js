var chats = {};
chats.interval = 5000;

function showChat(postId, title, username) {
	if (chats["currentallyShownId"] && chats["currentallyShownId"] !== postId) {
		hideChat(chats["currentallyShownId"]);
	}
	console.log("Showing postid:" + postId)
	var elementId = "chat_div" + postId;
	if (!chats[postId]) {
		getAllChats(postId, function(allChats) {
			$("#" + elementId).chatbox({id: elementId, 
	                            user:{username : username},
	                            title : title ? title : "Chat",
	                            offset: 100,
	                            boxClosed: function(id) {
	                            	hideChat(postId)
	                            },
	                            messageSent : function(id, user, msg) {
	                                $.post("/posts/" + postId + "/chats", {
	                                	"chat[message]": msg
	                                }, function(status) {
	                                	console.log("post request success ", status); // why this is not called?
	                                });
	                                $("#" + id).chatbox("option", "boxManager").addMsg(user.username, msg);
	                            	
	                            }});
			allChats.forEach(function(chat) {
				$("#" + elementId).chatbox("option", "boxManager").addMsg(chat.username, chat.message);
				
			});
			chats[postId] = {added: true};
			chats[postId].lastChatId = allChats[allChats.length - 1].id;
			
			setInterval(function() {
				console.log("Getting new message for post:" + postId, chats.postId);
				getChats({postId: postId, id: chats[postId]["lastChatId"]}, function(newChats) {
					console.log("Got " + newChats.length, "new messages for postId: " + postId);
					if (newChats.length != 0) {
						newChats.forEach(function(chat) {
							if (chat.user_id !== current_user.id) {
								$("#" + elementId).chatbox("option", "boxManager").addMsg(chat.username, chat.message);
							}
						});
						chats[postId].lastChatId = newChats[newChats.length - 1].id;	
					}
					
				});
			}, chats.interval);

		});
	} else {
		$("#" + elementId).chatbox("option", "hidden", false)
	}
	chats.currentallyShownId = postId;
	 
}

function hideChat(postId) {
	console.log("Hidding postid:" + postId);
	var elementId = "chat_div" + postId;
	if (chats[postId]) {
		$("#" + elementId).chatbox("option", "hidden", true);
	}
	delete chats["currentallyShownId"];
}

function getAllChats(postId, callback) {
	$.get("/posts/"+ postId + "/chats/", function(data, status) {
		console.log("chat data:", data, status);
		if (callback) {
			callback(data);
		}
	});
} 
function getChats(params, callback) {
	$.get("/posts/"+ params.postId + "/chats/", {id: params.id}, function(data, status) {
		console.log("chat data:", data, status);
		if (callback) {
			callback(data);
		}
	});
} 