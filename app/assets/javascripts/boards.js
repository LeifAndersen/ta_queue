$(document).ready(function() {
  query_queue();
  $("#enter_queue_button").click( function (){
    enter_queue();
  });
  $("#exit_queue_button").click( function (){
    exit_queue();
  });
  window.setInterval(query_queue, 3000);
  $('#freeze_button').click( function() {
    return false;
  });
});

function query_queue()
{
  $.ajax({
    type:"GET",
    url:"/boards/CS1410",
    dataType:"json",
    success:queue_cb
    });
}

function enter_queue()
{
  user_id = $("#user_id").val();
  user_token = $("#user_token").val();
  board_title = $("#board_title").val();
  url = "/boards/" + board_title + "/students";
  $.post(url, { id:user_id, token:user_token, in_queue:true }, query_queue, "json");
}

function exit_queue()
{
  user_id = $("#user_id").val();
  user_token = $("#user_token").val();
  board_title = $("#board_title").val();
  url = "/boards/" + board_title + "/students";
  $.post(url, { id:user_id, token:user_token, in_queue:false }, query_queue, "json");

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
      html += " (in queue)";
    else
      html += " (not in queue)";
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
