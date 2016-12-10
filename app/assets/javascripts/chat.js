jQuery(document).ready(function() {
  jQuery("time.timeago").timeago();
});

var chats = {};
chats.interval = 5000;
var chatBotWelcomeMsg = "Hello Colearners! You are now joined, you can start chatting now. Good luck and have fun.";
function showChat(postId, title, username, options) {
	if (chats["currentallyShownId"] && chats["currentallyShownId"] !== postId) {
		hideChat(chats["currentallyShownId"]);
	}
	if (!options) {
		options = {hidden: false};
	}
	var elementId = "chat_div" + postId;
	if (!chats[postId]) {

		getAllChats(postId, function(allChats) {
			$("#" + elementId).chatbox({id: elementId, 
	                            user:{username : username},
	                            title : title ? title : "Chat",
	                            offset: 100,
	                            hidden: options.hidden,
	                            boxClosed: function(id) {
	                            	hideChat(postId)
	                            },
	                            messageSent : function(id, user, msg) {
	                                $.post("/posts/" + postId + "/chats", {
	                                	"chat[message]": msg
	                                }, function(status) {
	                                });
	                                $("#" + id).chatbox("option", "boxManager").addMsg(user.username, getMessageHtml(msg, new Date()));
	                            	$('.timeago').timeago('refresh');
	                            }});
			$("#" + elementId).chatbox("option", 
				"boxManager").addMsg("colearn-bot", getMessageHtml(chatBotWelcomeMsg));
			allChats.forEach(function(chat) {
				$("#" + elementId).chatbox("option", "boxManager").
					addMsg(chat.username, getMessageHtml(chat.message, chat.created_at));
			});
			$('.timeago').timeago('refresh');
			chats[postId] = {added: true};
			chats[postId].lastChatId = allChats[allChats.length - 1].id;
			
			setInterval(function() {
				getChats({postId: postId, id: chats[postId]["lastChatId"]}, function(newChats) {
					if (newChats.length != 0) {
						showChat(postId, title, username); // show the chat where new message has come.
						newChats.forEach(function(chat) {
							if (chat.user_id !== current_user.id) {
								$("#" + elementId).chatbox("option", "boxManager").
								addMsg(chat.username, getMessageHtml(chat.message, chat.created_at));
							}
						});
						$('.timeago').timeago('refresh');
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
function addBotMessage() {
	addMsg("colearn-bot", getMessageHtml("chat.message"));
}
function hideChat(postId) {
	var elementId = "chat_div" + postId;
	if (chats[postId]) {
		$("#" + elementId).chatbox("option", "hidden", true);
	}
	delete chats["currentallyShownId"];
}

function getAllChats(postId, callback) {
	$.get("/posts/"+ postId + "/chats/", function(data, status) {
		if (callback) {
			callback(data);
		}
	});
} 
function getChats(params, callback) {
	$.get("/posts/"+ params.postId + "/chats/", {id: params.id}, function(data, status) {
		if (callback) {
			callback(data);
		}
	});
}

function getMessageHtml(msg, date) {
	if (date instanceof Date) date = getMicroformat(date);
	var dateHtml = "";
	if (date) dateHtml = "</br><div style='float: right;'><time class='timeago' datetime='" + new Date(date).toISOString()
	+ "' >" + new Date(date).toString() +  "</time></div>";
	return "<span>" + linkifyHtml(msg, {defaultProtocal: 'http'}) + //TODO: html encode msg
	"</span>" + dateHtml ;
} 

function getMicroformat(date) {
  var d = date.toString();    
  var parts = d.split(" ");
  return parts[0]+", "+
         parts[2]+" "+
         parts[1]+" "+
         parts[3]+" "+
         parts[4]+" "+
         parts[5].replace(/[A-Z]/g,"");
}
