function Message(message, user) {
	this.id = message.id;
	this.text = message.message;
	this.time = new Date(message.created_at).getTime();
	this.user = user;
	this.type = "text";
}

Message.prototype.getMessageHTML = function() {
	var date = new Date(this.time);
	var msgContent;
	if (this.type === 'text') {
		msgContent = "<div class='text-msg'>" + 
						emojione.toImage(linkifyHtml(this.text, {defaultProtocal: 'http'})) + //TODO: html encode text
					"</div>";
	} else if (this.type === 'file') {
		msgContent = "<div class='file-msg'>" 
					+ getFilePreview(this.text) +
					"</div>"
	}
	var msgHtml = "<div class='text-msg-area'>" + 
					msgContent + "<div class='msg-timestamp'>" + 
					"<time class='timeago' datetime='" + 
						new Date(date).toISOString() + "' >" + 
						new Date(date).toString() +  
					"</time></div>";
	return msgHtml;

	function getFilePreview(text) {
		var fileName = getFileName(text);
		//TODO check if this is a image file link?
		if (isImage(text)) {
			return "<img class='chat-img-preview' src='https://www.gravatar.com/avatar/98fdf4b6dee9b8156d22736311cd0d41?s=50'>";
		} else {
			return "<div> File <a target='_tab' href='" + text + "'>" + fileName + "</a></div>";
		}
	}

	function isImage(text) {
		var list = [".jpeg", ".jpg", ".png", ".gif"];
		var isImage = false;
		list.forEach(function(l) {
			isImage |= text.endsWith();
		});
		return isImage;
	}

	function getFileName(text) {
		return text.substr(text.lastIndexOf('/') + 1);
	}
}