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
