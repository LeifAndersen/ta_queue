$(document).ready(function() {
  $.ajax({
    type:"GET",
    url:"/boards/CS1410",
    dataType:"json",
    success:queue_cb
    });
  $('#freeze_button').click( function() {
    return false;
  });
});

function queue_cb(data)
{
  html = "";
  html += '<ul>';
  for(i = 0; i < data.students.length; i++)
  {
    html += '<li>';
    html += data.students[i].username;
    html += " - " + data.students[i].location;
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
