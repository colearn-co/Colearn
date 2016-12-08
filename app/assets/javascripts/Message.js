function Message(text, time) {
	this.text = text;
	this.time = time;
}

Message.prototype.getMessageHTML = function() {
	var date = new Date(this.time);
	var msgHtml = "<div class='text-msg-area'><div class='text-msg'>" + 
					linkifyHtml(this.text, {defaultProtocal: 'http'}) + //TODO: html encode text
					"</div>" + "<div class='msg-timestamp'>" + 
					"<time class='timeago' datetime='" + 
						new Date(date).toISOString() + "' >" + 
						new Date(date).toString() +  
					"</time></div>";
	return msgHtml;
}