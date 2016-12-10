function Message(text, time, options) {
	if (!options) options = {};
	this.text = text;
	this.time = time;
	this.type = options.type ? options.type : 'text';
	console.log("type:" + this.type);
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
		//TODO check if this is a image file link?
		return "<img class='chat-img-preview' src='https://www.gravatar.com/avatar/98fdf4b6dee9b8156d22736311cd0d41?s=50'>";
	}
}