/*=============================================================================
 *
 *  boards.js
 *
 *  This is the main javascript file for the TA Board page.  Other files
 *  needed for this to work correctly are:
 *      - queue.js
 *      - questions.js (not included yet)
 *
 *  Note: This file doesn't need to be included anywhere except for pages
 *        where the main board is actually displayed.
 *
 *==========
 */

$(document).ready(function() 
{
	// Set up the ajax headers.
	$.ajaxSetup(
	{
		headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
	});
  
	// Sets the interval for the browser to requery the database, and sets up
	// the queue.
	set_interval(3000);
	queue_setup();
});
