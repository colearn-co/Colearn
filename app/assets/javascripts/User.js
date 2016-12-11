function User(user) {
	this.id = user.id;
	this.name = user.name;
	this.picture = user.pic;
	this.status = user.online_status;
	this.last_visited = user.last_visited;
}

User.prototype.getUserHTMLUserArea = function() {
	console.log("user html");

	var html = '<div id="' + this.getUserElementId() + '" class="user-display-area"><div class="user-picture">'
	+ '<img class="' + getStatusClass(this.status) + '" src="' + 
		this.picture +
	'"></div><div class="username">' + this.name + '</div></div>';
	console.log("html:" + html);
	return html;
	function getStatusClass(status) {
		return status;
	}
}

User.prototype.getUserHTML = function() {
	console.log("user html");

	var html = '<div id="' + this.getUserElementId() + '" class="user-display-area"><div class="user-picture">'
	+ '<img " src="' + 
		this.picture +
	'"></div><div class="username">' + this.name + '</div></div>';
	console.log("html:" + html);
	return html;
	function getStatusClass(status) {
		return status;
	}
}

User.prototype.getUserElementId = function() {
	return "UA-user-id-" + this.id;
}