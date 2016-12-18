function User(user) {
	this.id = user.id;
	this.name = user.name;
	this.picture = user.picture;
	this.status = user.online_status;
	this.last_visited = user.last_visited;
}

User.prototype.getUserHTMLUserArea = function() {
	// console.log("user html");

	var html = '<div id="' + this.getUserElementId() + '" class="user-display-area"><div class="user-picture">'
	+ '<img class="' + '" src="' + 
		this.picture +
	'"></div><div class="chat-username"><div>' + this.name + '</div>'

	if (this.status == 'offline') {
		html += '<div class="last-seen-time">Active: <time class="timeago" datetime="' + new Date(this.last_visited).toISOString() + '">' 
				+ (this.last_visited == null ? '' : new Date(this.last_visited).toString()) + '</time></div>'
	}
	html += '</div><span class="' + getStatusClass(this.status) + '"></span></div>';
	//console.log("html:" + html);
	return html;
	function getStatusClass(status) {
		return 'status ' + status;
	}
}

User.prototype.getUserElementId = function() {
	return "UA-user-id-" + this.id;
}