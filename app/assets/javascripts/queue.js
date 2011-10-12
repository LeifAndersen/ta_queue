/*=============================================================================
 *
 *  queue.js
 *
 *  Everything related to queue portion of the database should go here.
 *
 *==========
 */

function queue_setup()
{
	$("#enter_queue_button").click(function ()
	{
    	enter_queue();
  });
  
	$("#exit_queue_button").click(function ()
	{
		exit_queue();
	});
	
	$("#accept_next_button").click(function()
	{
    var next_person = $("#queue li").first().find(".student_token").val();
    accept(next_person);
	});

	$('#freeze_button').click(function() 
	{
		return false;
	});

  is_ta = $("#is_ta").val();

  
  // Do an initial query before the 3 second one
  query_queue();
}

function set_interval(milliseconds)
{
	window.setInterval(query_queue, milliseconds);
}

function accept(usr_id)
{

  user_id = $("#user_id").val();
  board_title = $("#board_title").val();
  url = "/boards/" + board_title + "/tas/" + user_id;
  
  $.ajax({
    type:"POST",
    url:url,
    data: { _method:"PUT", accept_student:usr_id },
    dataType:"json",
    success:query_queue,
    });

}

function remove_from_queue(user_id)
{
  requesting_user_id = $("#user_id").val();
  board_title = $("#board_title").val();
  url = "/boards/" + board_title + "/students/" + user_id;
  
  $.ajax({
    type:"POST",
    url:url,
    data: { _method:"PUT", ta_id:requesting_user_id, 'student[in_queue]':false },
    dataType:"json",
    success:query_queue,
    });
}

function query_queue()
{
	$.ajax({
		type:"GET",
		url:"/boards/" + $("#board_title").val() + "/queue",
		dataType:"json",
		success:queue_cb,
		statusCode: {
		  304:function () {alert('nothing new');}
		}
	});
}

// This method is responsible for updating queue data.
function queue_cb(data,textStatus,xhr)
{
	html = "";
	html += '<ul id="queue">';
	for(i = 0; i < data.students.length; i++)
	{
		html += '<li>';
		html += data.students[i].username;
		html += '<input type="hidden" class="student_id" name="student_' + i + '" value="' + data.students[i].id + '" />';
    if(is_ta == "true")
    {
      html += '<input type="button" style="float:right;" class="student_remove_button" value="Remove" />';
      html += '<input type="button" style="float:right;" class="student_accept_button" value="Accept" />';
    }
		html += '</li>';
	}
	html += '</ul>';

	$("#inner_list").html(html);

  $('.student_remove_button').click(function ()
  {
    var temp = $(this).siblings('.student_id').val();
    remove_from_queue(temp);
  });

  $(".student_accept_button").click(function() 
  {
    var temp = $(this).siblings('.student_id').val();
    accept(temp);
  });

	html = ""
	html += '<ul>';
	for(i = 0; i < data.tas.length; i++)
	{
		html += '<li>';
		html += data.tas[i].username;
		if(data.tas[i].student)
		{
			html += " - currently assigned to " + data.tas[i].student;
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
  board_title = $("#board_title").val();
  url = "/boards/" + board_title + "/students/" + user_id;
  // NOTE: You must use _method:"PUT" when updating records
  $.ajax({
    type:"POST",
    url:url,
    data: { _method:"PUT", "student[in_queue]":true },
    dataType:"json",
    success:query_queue,
    });
}

function exit_queue()
{
  user_id = $("#user_id").val();
  board_title = $("#board_title").val();
  url = "/boards/" + board_title + "/students/" + user_id;
  $.ajax({
    type:"POST",
    url:url,
    data: { _method:"PUT", "student[in_queue]":false },
    dataType:"json",
    success:query_queue,
    });
}
