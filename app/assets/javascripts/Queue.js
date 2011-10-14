/*
 *  Queue.js
 *
 *  Defines an object that maintains and updates the state of the queue.
 *
 */
 
function Queue ()
{	
  this.username = $('#user_id').val();
  //$('#user_id').remove();

  this.password = $('#user_token').val();
  //$('#user_token').remove();
  
  this.boardTitle = $('#board_title').val();
  //$('#board_title').remove();
  
  this.isTA = $('#is_ta').val();
  //$('#is_ta').remove();
  
  this.interval;
  
  this.frozen;
  
  this.active;
  
  this.studentsInQueue = [];
  
  this.tasInQueue = [];
	
	this.addEventListeners2Queue = function ()
	{
	  with (this)
	  {
  	  $('#activate_queue').click(function ()
  	  {
        if ($(this).attr('value') == 'Activate')
        {
  	      activateQueue(true);
  	      $(this).attr('value','Deactivate');
  	    }
  	    else
  	    {
  	      activateQueue(false);
  	      $(this).attr('value','Activate');
  	    }
  	  });
  	  
  	  $('#freeze_queue').click(function ()
  	  {
        if ($(this).attr('value') == 'Unfreeze')
        {
  	      freezeQueue(false);
  	      $(this).attr('value','Freeze');
  	    }
  	    else
  	    {
  	      freezeQueue(true);
  	      $(this).attr('value','Unfreeze');
  	    }
  	  });
  	  
  	  $('#enter_queue').click(function ()
  	  {
  	    if ($(this).attr('value') == 'Enter Queue')
  	    {
  	      $(this).attr('value','Exit Queue');
  	      enterQueue();
  	    }
  	    else
  	    {
  	      $(this).attr('value','Enter Queue');
  	      exitQueue();
  	    }
  	  });
  	}
	}
	
	this.queryQueue = function ()
	{
	  with (this)
  	{
  	  $.ajax({
  		  type : 'GET',
  		  url : '/boards/' + boardTitle + '/queue',
  		  headers : 
  		  { 
  		    'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content'),
          'Authorization' : base64_encode(username + ":" + password)
        },
  		  dataType : 'json',
  		  success : function (data) 
  		  {
  		    queryQueueSuccess(data);
  		  }
  		}); 
		}
		
		with (this)
		{
		  interval = setTimeout(function () { queryQueue(); }, 3000);
		}
		
	}
	
	this.queryQueueSuccess = function (data)
	{
	  this.active = data.active;
	  this.frozen = data.frozen;

	  if (data.active && !data.frozen) // Active and not frozen
	  {
	    $('#notification').html('The queue is active. Enter at your convenience.');
	    this.updateStudents(data.students);
	    this.updateTas(data.tas);
	  }
	  else if (data.active && data.frozen) // Active but frozen
	  {
	    $('#notification').html('The queue is active, but no new students may enter.');
	    this.updateStudents(data.students);
	    this.updateTas(data.tas);
	  }
	  else if (!data.active) // Not active and frozen
	  {
	    $('#notification').html('The queue is inactive.');
	    this.updateStudents(data.students);
	    this.updateTas(data.tas);
	  }
	}
	
	this.activateQueue = function (isActive)
	{
	  with (this)
  	  {
  	  $.ajax({
    		  type : 'POST',
    		  url : '/boards/' + boardTitle,
    		  headers : 
    		  { 
    		    'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content'),
            'Authorization' : base64_encode(username + ":" + password)
          },
    		  data : 
    		  { 
    		    _method : 'PUT', 
    		    'board[active]' : isActive
    		  },
    		  dataType : 'json',
    		  success : function (data) 
    		  {
    		    activateQueueSuccess(data);
    		  }
    	});
    }
	}
	
	this.activateQueueSuccess = function (data)
	{
	  
	}
	
	this.freezeQueue = function (isFrozen)
	{
	  with (this)
  	{
  	  $.ajax({
    		  type : 'POST',
    		  url : '/boards/' + boardTitle + '/queue',
    		  headers : 
    		  { 
    		    'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content'),
            'Authorization' : base64_encode(username + ":" + password)
          },
    		  data : 
    		  { 
    		    _method : 'PUT', 
    		    'queue[frozen]' : isFrozen
    		  },
    		  dataType : 'json',
    		  success : function (data) 
    		  {
    		    freezeQueueSuccess(data);
    		  }
    	});
    }
	}
	
	this.freezeQueueSuccess = function (data)
	{
	
	}
	
	this.enterQueue = function ()
	{
  	with (this)
  	{
  	  $.ajax({
    		  type : 'GET',
    		  url : '/boards/' + boardTitle + '/queue/enter_queue',
    		  headers : 
    		  { 
    		    'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content'),
            'Authorization' : base64_encode(username + ":" + password)
          },
    		  dataType : 'json',
    		  success : function (data) 
    		  {
    		    queryQueueSuccess(data);
    		  }
    	});
    }
	}
  
  this.exitQueue = function ()
  {
    with (this)
  	{
  	  $.ajax({
    		  type : 'GET',
    		  url : '/boards/' + boardTitle + '/queue/exit_queue',
    		  headers : 
    		  { 
    		    'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content'),
            'Authorization' : base64_encode(username + ":" + password)
          },
    		  dataType : 'json',
    		  success : function (data) 
    		  {
    		    queryQueueSuccess(data);
    		  }
    	});
    }
  }
  	
	this.updateStudents = function (a)
	{
	  var i;
	  var html = '';
	   
	  $('#queue_list').html('');
	  
	  if (this.active == false)
	  {
      return;	  
	  }
	  
	  this.updateDateTime();
	  
	  for (i = 0; i < a.length; i++)
	  {
	    html += '<div id="' + a[i].id + '~~~~' + i + '" class="';
	    
	    if (i % 2 == 0)
	    {
	      html += 'even student">';
	    }
	    else
	    {
	      html += 'odd student">';
	    }
	    
	    html += '<p class="username">' + a[i].username + '</p>';
	    html += '<p class="location">' + a[i].location + '</p>';
  
	    if (this.isTA == 'true')
	    {
	      html += '<input type="button" class="accept" value="Accept"/>';
	    }
	    
	    html += '</div>';
	  }
	  
	  if (i % 2 == 0)
    {
      html += '<div id="queue_bottom" class="even"></div>';
    }
    else
    {
      html += '<div id="queue_bottom" class="odd"></div>';
    }
    
	  $('#queue_list').append(html);
	  $('.scroll-pane').jScrollPane();
	  with (this)
	  {
  	  $('.accept').click(function ()
      {
        var student_id = $(this).parent().attr('id');
        acceptStudent(student_id);
      });
    }
	}
	
	this.acceptStudent = function (sid)
	{
	    
    with (this)
  	{
  	  $.ajax({
    		  type : 'GET',
    		  url : '/boards/' + boardTitle + '/students/' + sid.split('~~~~')[0] + '/ta_accept',
    		  headers : 
    		  { 
    		    'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content'),
            'Authorization' : base64_encode(username + ":" + password)
          },
    		  dataType : 'json',
    		  success : function (data) 
    		  {
    		    removeStudent(data,sid);
    		  }
    	});
    }
	}
	
	this.removeStudent = function (data,sid)
	{
	  with (this)
  	{
      $.ajax({
  		  type : 'GET',
  		  url : '/boards/' + boardTitle + '/students/' + sid.split('~~~~')[0] + '/ta_remove',
  		  headers : 
  		  { 
  		    'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content'),
          'Authorization' : base64_encode(username + ":" + password)
        },
  		  dataType : 'json',
  		  success : function (data) 
  		  {
  		    removeStudentSuccess(data);
  		  }
    	});
    }
	}
	
	this.removeStudentSuccess = function (data)
	{
	  this.queryQueue();
	}
	
	this.centerControlBar = function ()
	{
	  var parentWidth = $('#control_panel').innerWidth();
	  var childWidth = $('#control_bar').innerWidth();
	  var margin = (parentWidth - childWidth)/2 + 17;
	  
	  $('#control_bar').css('margin-left',margin + 'px');
	}
	
	this.updateTas = function (a)
	{
	  var html = '';
	  
	  $('#tas_list').html(html);
	  
	  for (var i = 0; i < a.length; i++)
	  {
	    html += '<div class="post_it">';
	    
	    html += '<div class="ta_name">' + a[i].username + '</div>';
	    
	    html += '<div class="student_info">';
	    
	    if (a[i].student == null)
	    {
	      html += 'Current Student: none';
	    }
	    else
	    {
	      html += 'Currently with ' + a[i].student.username;
	      html += ' at ' + a[i].student.location;
	    }
	    
	    html += '</div>';
	    html += '<div class="ta_status">Status: '
	    
	    if (a[i].status == '')
	    {
	      html += 'None';
	    }
	    else
	    {
	      html += a[i].status;
	    }
	    
	    html += '</div>';
	    
	    html += '</div>';
	  }
	  
	  $('#tas_list').append(html);
	  $('.scroll-pane').jScrollPane();
	
	}
	
	this.getDate = function ()
  {
    var d = new Date();
    var date = d.getDate();
    var month = d.getMonth();
    var year = d.getFullYear();
    var dayOfWeek = d.getDay();
    
    var daysOfWeek = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
    var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    
    var dateString = daysOfWeek[dayOfWeek] + ' ' + months[month] + ' ' + date + ', ' + year;
    
    return dateString;
  }
  
  this.getTime = function ()
  {
    var d = new Date();
    var hour = d.getHours();
    var minute = (d.getMinutes() < 10) ? '0' + d.getMinutes() : d.getMinutes();
    
    var timeString = '';
    
    if (hour == 12)
    {
      timeString += hour + ':' + minute + ' pm';
    }
    else if (hour == 0)
    {
      hour = 12;
      timeString += hour + ':' + minute + ' am';
    }
    else if (hour > 12)
    {
      hour = hour - 12;
      timeString += hour + ':' + minute + ' pm';
    }
    else
    {
      timeString += hour + ':' + minute + ' am';
    }
    
    return timeString;
  }

	this.updateDateTime = function ()
  {
    var html = '<div id="queue_datetime">';
    html += '<span class="left">' + this.getDate() + '</span>';
    html += '<span class="right">' + this.getTime() + '</span>';
    html += '<div class="clear"></div>';
    html += '</div>';
  
    $('#queue_list').append(html);
  }
  
  
}