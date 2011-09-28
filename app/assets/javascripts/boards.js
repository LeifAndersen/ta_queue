$(document).ready(function() {
  $.ajaxSetup(
  {
    headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
  });
  
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

  // Javascript needed to set up the tabs correctly.
  $("ul.tabs").tabs("div.panes > div");
  $("ul.tabs").center();
});

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
