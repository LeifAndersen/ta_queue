/*=============================================================================
 *
 *  Everything related to quering the Queue portion of the database should go 
 *  here including Ajax callback methods.
 *
 *==========
 */

//Sets the interval for the browser to requery the database.

function queue_setup()
{
	$("#enter_queue_button").click(function ()
	{
    	enter_queue();
  	});
  
	$("#exit_queue_button").click(function (){
		exit_queue();
	});

	$('#freeze_button').click(function() {
		return false;
	});
}

function set_interval(milliseconds)
{
	window.setInterval(query_queue, milliseconds);
}

function query_queue()
{
	$.ajax({
		type:"GET",
		url:"/boards/" + $("#board_title").val(),
		dataType:"json",
		success:queue_cb
	});
}

function queue_cb(data)
{
	html = "";
	html += '<ul>';
	for(i = 0; i < data.students.length; i++)
	{
		html += '<li>';
		html += data.students[i].username;
		html += " - " + data.students[i].location;
		if(data.students[i].in_queue == true)
		{
			html += " (in queue)";
		}
    	else
    	{
      		html += " (not in queue)";
      	}
		html += '</li>';
	}
	html += '</ul>';

	$("#inner_list").html(html);

	html = ""
	html += '<ul>';
	for(i = 0; i < data.tas.length; i++)
	{
		html += '<li>';
		html += data.tas[i].username;
		if(data.tas[i].current_student)
		{
			html += " - currently assigned to " + data.tas[i].current_student;
		}
		html += '</li>';
	}
	html += '</ul>';

	$('ul#ta_list').html(html);
	return false;
}

function enter_queue()
{
  user_id = $("#user_id").val();
  user_token = $("#user_token").val();
  board_title = $("#board_title").val();
  url = "/boards/" + board_title + "/students";
  $.ajax({
    type:"POST",
    url:url,
    data: { id:user_id, token:user_token, "student[in_queue]":true },
    dataType:"json",
    success:query_queue,
    });
}

function exit_queue()
{
  user_id = $("#user_id").val();
  user_token = $("#user_token").val();
  board_title = $("#board_title").val();
  url = "/boards/" + board_title + "/students";
  $.ajax({
    type:"POST",
    url:url,
    data: { id:user_id, token:user_token, "student[in_queue]":false },
    dataType:"json",
    success:query_queue,
    });
}
