function ChatDAO(postId) {
	this.postId = postId;
}

ChatDAO.prototype.getChatsInfo = function(query, callback) {

	var after_id = query.after_id;
	// console.log("query sting" + $.param(query));
	// console.log("json" + JSON.stringify(query));
	$.get("/posts/"+ this.postId + "/fetch_chat_info.json", 
		query, function(data, status) {
		if (callback) {
			callback(data);
		}
	});
};

ChatDAO.prototype.sendMessage = function(message, callback) {
	$.post("/posts/" + this.postId + "/chats", {
		"chat[message]": message
	}, callback);
};

/*
jQuery(document).ready(function() {
	var chatDAO = new ChatDAO(28);
	chatDAO.getChatsInfo({}, function(data) {
		console.log("data:" + JSON.stringify(data));
	});
	var user = current_user;
	var m = new Message("https://www.gravatar.com/avatar/98fdf4b6dee9b8156d22736311cd0d41?s=50", new Date().getTime(), {type: 'file'});
	chatDAO.sendMessage(m, function(status) {
		console.log("Message sent:" + status);
	});
});*/