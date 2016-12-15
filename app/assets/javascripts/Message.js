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

Message.prototype.getMessageHTML = function() {
	var date = new Date(this.time);
	var msgContent;

	if (!this.resource_path) {
		msgContent = getTextMsgHtml(this.text);
	} else {
		msgContent = getTextMsgHtml(this.text) + "<div class='file-msg'>" 
					+ getFilePreview(this.resource_path, this.resource_type, this.file_name) +
					"</div>"
	}
		
	var msgHtml = "<div class='text-msg-area'>" + 
					msgContent + "<div class='msg-timestamp'>" + 
					"<time class='timeago' datetime='" + 
						new Date(date).toISOString() + "' >" + 
						new Date(date).toString() +  
					"</time></div>";
					
		msgHtml = '<div class="user-msg-area">' + 
				'<div class="user-picture">'
				+ '<img " src="' + 
					this.user.picture +
				'"></div><div class="username-msg-area">' + 
				'<div class="username">' + this.user.name + '</div>'
				+ msgHtml + '</div></div>'
		 		
	return msgHtml;

	function getFilePreview(resource_path, resource_type, file_name) {
		//TODO check if this is a image file link?
		if (isImage(resource_type)) {
			return "<img class='chat-img-preview' src='" + resource_path + "'>";
		} else {
			return "<div> File <a target='_tab' href='" + resource_path + "'>" + file_name + "</a></div>";
		}
	}

	function isImage(resource_type) {
		return resource_type.startsWith("image/");
	}

	
	function getTextMsgHtml(text) {
		return "<div class='text-msg'>" + 
						emojione.toImage(linkifyHtml(text, {defaultProtocal: 'http'})) + //TODO: html encode text
					"</div>";
	}
}