$(document).ready(function() {
	$('#notice-rem').click(function() {
		$('#colearn-notice').slideUp(500, function() {
			try {
				colearn_notify_closed();
			}
			catch(e){}
		});
	})
})