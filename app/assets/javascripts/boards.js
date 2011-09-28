$(document).ready(function() {
	$.ajaxSetup(
	{
		headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
	});
  
	queue_setup();

	// Javascript needed to set up the tabs correctly.
	$("ul.tabs").tabs("div.panes > div");
	$("ul.tabs").center();
});
