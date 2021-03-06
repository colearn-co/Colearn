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

ChatDAO.prototype.sendMessage = function(msgObj, callback) {
	$.post("/posts/" + this.postId + "/chats", {
		"chat[message]": msgObj.message,
		"chat[src_device_id": msgObj.src_device_id
	}, callback);
};
