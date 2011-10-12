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
function base64_encode (data) {
    // http://kevin.vanzonneveld.net
    // +   original by: Tyler Akins (http://rumkin.com)
    // +   improved by: Bayron Guevara
    // +   improved by: Thunder.m
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   bugfixed by: Pellentesque Malesuada
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   improved by: Rafał Kukawski (http://kukawski.pl)
    // -    depends on: utf8_encode
    // *     example 1: base64_encode('Kevin van Zonneveld');
    // *     returns 1: 'S2V2aW4gdmFuIFpvbm5ldmVsZA=='
    // mozilla has this native
    // - but breaks in 2.0.0.12!
    //if (typeof this.window['atob'] == 'function') {
    //    return atob(data);
    //}
    var b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    var o1, o2, o3, h1, h2, h3, h4, bits, i = 0,
        ac = 0,
        enc = "",
        tmp_arr = [];

    if (!data) {
        return data;
    }

    do { // pack three octets into four hexets
        o1 = data.charCodeAt(i++);
        o2 = data.charCodeAt(i++);
        o3 = data.charCodeAt(i++);

        bits = o1 << 16 | o2 << 8 | o3;

        h1 = bits >> 18 & 0x3f;
        h2 = bits >> 12 & 0x3f;
        h3 = bits >> 6 & 0x3f;
        h4 = bits & 0x3f;

        // use hexets to index into b64, and append result to encoded string
        tmp_arr[ac++] = b64.charAt(h1) + b64.charAt(h2) + b64.charAt(h3) + b64.charAt(h4);
    } while (i < data.length);

    enc = tmp_arr.join('');
    
    var r = data.length % 3;
    
    return (r ? enc.slice(0, r - 3) : enc) + '==='.slice(r || 3);

}


$(document).ready(function() 
{
	// Set up the ajax headers.
  //username = $('#user_id').val();
  //password = $('#user_token').val();
	//$.ajaxSetup(
	//{
	//	headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
  //             'Authorization': base64_encode(username + ":" + password)
  //          }
  
  var q = new Queue();
  q.queryQueue();
  q.setupQueue();
  console.dir(q);
  
	// Sets the interval for the browser to requery the database, and sets up
	// the queue.
	//set_interval(3000);
	//queue_setup();
});
