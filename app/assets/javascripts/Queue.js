/*
 *  Queue.js
 *
 *  Defines an object that maintains and updates the state of the queue.
 *
 */
 
function Queue ()
{
  $.ajaxSetup(
	{
		headers: 
		  { 
		    'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content'),
        'Authorization' : base64_encode(this.username + ":" + this.password)
      }
	});
	
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
	  alert('we changed it');
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
	this.updateStudents = function (a)
	{
	  var html = '';
	  this.studentsInQueue = a;	  
	  $('#queue_list').html('');
	  
	  if (this.active == false)
	  {
      return;	  
	  }
	  
	  this.updateDateTime();
	  
	  for (var i = 0; i < this.studentsInQueue.length; i++)
	  {
	    html += '<div id="_' + i + '" class="';
	    
	    if (i % 2 == 0)
	    {
	      html += 'even student">';
	    }
	    else
	    {
	      html += 'odd student">';
	    }
	    
	    html += '<p class="username">' + studentsInQueue[i].username + '</p>';
	    html += '<p class="location">' + studentsInQueue[i].location + '</p>';
	    html += '</div>';
	  }
	  
	  $('#queue_list').append(html);
	}
	
	this.updateTas = function (a)
	{
	  this.tasInQueue = a;
	  
	  for (var i = 0; i < this.tasInQueue.length; i++)
	  {
	  
	  }
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
    else if (hour == 24)
    {
      hour = hour - 12;
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