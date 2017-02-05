$(document).ready(function() {
	$('#notice-rem').click(function() {
		$('#colearn-notice').slideUp(500, function() {
			if (colearn_notify_closed) {
				colearn_notify_closed();
			}
		});
	})
})