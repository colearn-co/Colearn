
/*function Chat(var postId, var user) =  {
	showChat : sh
}*/
$( document ).ready(function() {
    console.log( "ready!" );

	$("#status_message").keypress(function(e) {
	    if(e.which == 13) {
	 		var element = $("#status_message");
	 		var message = element.val();
	 		element.val("");
	        alert('You pressed enter!' + message);
	    }
	});
	$("#removeClass").click(function () {
		$('#chat-popup').removeClass('popup-box-on');
	});

});

function showChat() {
	$("#chat_div").chatbox({id:"chat_div", 
                                                user:{key : "value"},
                                                title : "test chat",
                                                messageSent : function(id, user, msg) {
                                                    $("#chat_div").chatbox("option", "boxManager").addMsg(id, msg);
                                                }});
	 
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