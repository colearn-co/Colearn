function User(user) {
	this.id = user.id;
	this.name = user.name;
	this.picture = user.picture;
	this.status = user.status;
	if (!user.status) {
		this.status = "online";
	}
}

User.prototype.getUserHTML = function() {
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

User.prototype.getUserElementId = function() {
	return "UA-user-id-" + this.id;
}