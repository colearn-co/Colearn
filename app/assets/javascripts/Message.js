function Message(message, user) {
	this.id = message.id;
	this.text = message.message;
	if (message.created_at instanceof Date) {
		this.time = message.created_at.getTime();
	} else {
		this.time = new Date(message.created_at).getTime();
	}
	this.user = user;
	if (message.chat_resource) {
		this.resource_path = message.chat_resource.private_resource_url;
		this.resource_type = message.chat_resource.avatar_content_type;	
		this.file_name = message.chat_resource.avatar_file_name;
	}
}

Message.prototype.getMessageContent = function() {
	var content;
	if (!this.resource_path) {
		content = this.getTextMsgHtml();
	} else {
		content = "<div class='file-msg'>" 
					+ this.getFilePreview() +
					"</div>"
	}
	return content;
}
Message.prototype.getTextMsgHtml = function() {
	return "<div class='text-msg'>" + 
					emojione.toImage(linkifyHtml(this.text, {defaultProtocal: 'http'})) + //TODO: html encode text
				"</div>";	
}
Message.prototype.isImage = function() {
	return this.resource_type.startsWith("image/");
}
Message.prototype.getFilePreview = function() {
	//TODO check if this is a image file link?
		var attachment_div = '<div class="attachment">' 
									+ '<div class="attachment-label">uploaded a file: </div>'
									+ '<a class="file-name" target="_tab" href="' + this.resource_path + '">' + this.file_name + '</a>' 
									+ '<a target="_tab" class="attachment-action glyphicon glyphicon-download" href="' + this.resource_path + '">' + '</a>';
						+ '</div>';
		if (this.isImage()) {
			return attachment_div + '<div class="attachment-preview">' + '<img class="chat-img-preview js_img_preview" src="' + this.resource_path + '">' + '</div>';
		} else {
			return attachment_div;
		}
}

Message.prototype.getMessageHTML = function() {
	var date = new Date(this.time);
	var msgContent = this.getMessageContent();
	
		
	var msgHtml = "<div class='text-msg-area'>" + 
					msgContent;
	var msg_time = "<div class='msg-timestamp'>" + 
					"<time class='timeago' datetime='" + 
						new Date(date).toISOString() + "' >" + 
						new Date(date).toString() +  
					"</time></div>";
		msgHtml = '<div class="user-msg-area">' + 
				'<div class="user-picture">'
				+ '<img " src="' + 
					this.user.picture +
				'"></div><div class="username-msg-area">' + 
				'<div class="chat-username">' + this.user.name + msg_time + '</div>'
				+ msgHtml + '</div></div>'
		 		
	return msgHtml;



}