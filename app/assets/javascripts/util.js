function addReferrerCookie() {
	if ($.cookie("referrer") == undefined) {
		$.cookie("referrer", window.location.pathname)
	}
}

function trackUser() {
	addReferrerCookie();
}