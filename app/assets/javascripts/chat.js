
/*function Chat(var postId, var user) =  {
	showChat : sh
}*/
$( document ).ready(function() {
    console.log( "ready!" );
});

function showChat(postId, title, username) {
	getAllChats(postId, function(chats) {
		var elementId = "#chat_div";
		$(elementId).chatbox({id:"chat_div", 
                            user:{username : username},
                            title : title ? title : "Chat",
                            messageSent : function(id, user, msg) {
                                
                                $.post("posts/" + postId + "/chats", {
                                	"chat[message]": msg
                                }, function(status) {
                                	console.log("post request success ", status); // why this is not called?
                                });
                                $("#" + id).chatbox("option", "boxManager").addMsg(user.username, msg);
                            }});
		chats.reverse().forEach(function(chat) {
			$(elementId).chatbox("option", "boxManager").addMsg(chat.username, chat.message);
		});
	});
	 
}

function hideChat(postId) {
	$('#chat-popup').removeClass('popup-box-on');
}

function getAllChats(postId, callback) {
	$.get("posts/"+ postId + "/chats/", function(data, status) {
		console.log("chat data:", data, status);
		if (callback) {
			callback(data);
		}
	});
} 