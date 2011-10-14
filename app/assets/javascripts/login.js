/*=============================================================================
 *
 *  login.js
 *
 *  This is the main javascript file for the login page.
 *
 *  Note: This file doesn't need to be included anywhere except for pages
 *        where login control happens.
 *
 *==========
 */

$(document).ready(function() 
{
  $('#ta_password').attr('value','password');
  $('#ta_username,#student_username').attr('value','username');
  $('#student_location').attr('value','location');
  
  if (window.location.search == 'ta')
  {
    alert('gotcha');
  }
	// TA tab/panel and student tab/panel toggle
	$('#student_tab, #ta_tab')
	  .click(function ()
	  {

  	  if ($(this).attr('id') == 'student_tab' && $('#student_panel').css('display') == 'none')
  	  {
  	    $('#student_panel').toggle();
  	    $('#ta_panel').toggle();
  	    
  	    $('#student_tab').css('color','#aa6622');
  	    $('#student_tab').css('text-shadow','1px 1px 1px #eeee88');
      	$('#ta_tab').css('color','#834f1a');   
  	    $('#ta_tab').css('text-shadow','1px 1px 1px #ccaa66');
  	    
  	    $('#ta_tab').hover(
  	      function ()
  	      {
            $(this).css('text-shadow','1px 1px 1px #eeee88');
          },
          function ()
          {
            $(this).css('text-shadow','1px 1px 1px #ccaa66'); 
          }	        
  	    );
  	    
  	     $('#student_tab').hover(
  	      function ()
  	      {
            $(this).css('text-shadow','1px 1px 1px #eeee88');
          },
          function ()
          {
            $(this).css('text-shadow','1px 1px 1px #eeee88'); 
          }	 
        );
  	    
  	    $('#ta_tab .left_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/htab_left_dark.png\')', 
  	        'background-position' :  '0px 0px',
  	        'background-repeat' : 'no-repeat'
  	      }
  	    );
  	    
  	    $('#ta_tab .content_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/h_wood_dark.jpg\')',
  	        'background-position' : '0px 0px',
  	        'background-repeat' : 'repeat-x'
  	      }
  	    );
  	    
  	    $('#ta_tab .right_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/htab_right_dark.png\')',
  	        'background-position' : '0px 0px',
  	        'background-repeat' : 'no-repeat'
  	      }
  	    );
  	    
  	    
  	    $('#student_tab .left_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/htab_left.png\')',
  	        'background-position' : '0px 0px',
  	        'background-repeat' : 'no-repeat'
  	      }
  	    );
  	    
  	    $('#student_tab .content_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/h_wood.jpg\')',
  	        'background-position' : '0px 0px',
  	        'background-repeat' : 'repeat-x'
  	      }
  	    );
  	    
  	    $('#student_tab .right_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/htab_right.png\')',
  	        'background-position' : '0px 0px',
  	        'background-repeat' : 'no-repeat'
  	      }
  	    );
  	    
  	  }
  	  
  	  if ($(this).attr('id') == 'ta_tab' && $('#ta_panel').css('display') == 'none')
  	  {
  	    $('#student_panel').toggle();
  	    $('#ta_panel').toggle();
  	    
  	    $('#student_tab').css('color','#834f1a');
  	    $('#student_tab').css('text-shadow','1px 1px 1px #ccaa66');
      	$('#ta_tab').css('color','#aa6622');   
  	    $('#ta_tab').css('text-shadow','1px 1px 1px #eeee88');
  	    
  	    $('#student_tab').hover(
  	      function ()
  	      {
            $(this).css('text-shadow','1px 1px 1px #eeee88');
          },
          function ()
          {
            $(this).css('text-shadow','1px 1px 1px #ccaa66'); 
          }	        
  	    );
  	    
  	    $('#ta_tab').hover(
  	      function ()
  	      {
            $(this).css('text-shadow','1px 1px 1px #eeee88');
          },
          function ()
          {
            $(this).css('text-shadow','1px 1px 1px #eeee88'); 
          }	 
        );
  	    
  	    $('#ta_tab .left_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/htab_left.png\')', 
  	        'background-position' :  '0px 0px',
  	        'background-repeat' : 'no-repeat'
  	      }
  	    );
  	    
  	    $('#ta_tab .content_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/h_wood.jpg\')',
  	        'background-position' : '0px 0px',
  	        'background-repeat' : 'repeat-x'
  	      }
  	    );
  	    
  	    $('#ta_tab .right_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/htab_right.png\')',
  	        'background-position' : '0px 0px',
  	        'background-repeat' : 'no-repeat'
  	      }
  	    );  	    
  	    
  	    $('#student_tab .left_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/htab_left_dark.png\')',
  	        'background-position' : '0px 0px',
  	        'background-repeat' : 'no-repeat'
  	      }
  	    );
  	    
  	    $('#student_tab .content_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/h_wood_dark.jpg\')',
  	        'background-position' : '0px 0px',
  	        'background-repeat' : 'repeat-x'
  	      }
  	    );
  	    
  	    $('#student_tab .right_tab').css(
  	      {
  	        'background-image' : 'url(\'/assets/htab_right_dark.png\')',
  	        'background-position' : '0px 0px',
  	        'background-repeat' : 'no-repeat'
  	      }
  	    );
  	  }	  
  	}
	);
	
	// Default form values and input responses to focus in/out
	$('#student_username, #ta_username')
	  .focusin(function () 
	  {
	    if ($(this).attr('value') == 'username')
	    {
	      $(this).attr('value','');
	    }
	  } 
	);
	
	$('#student_location')
	  .focusin(function () 
	  {
	    if ($(this).attr('value') == 'location')
	    {
	      $(this).attr('value','');
	    }
	  } 
	);
	
	$('#ta_password')
	  .focusin(function () 
	  {
	    if ($(this).attr('value') == 'password')
	    {
	      $(this).attr('value','');
	    }
	    
	    if ($(this).attr('id') == 'ta_password')
	    {
	      document.getElementById('ta_password').setAttribute('type','password');
	    }
	  } 
	);
	
  $('#student_username, #ta_username')
    .focusout(function () 
    {
      if ($(this).attr('value') == '')
      {
        $(this).attr('value','username');
      }
    }
  );
  
  $('#student_location')
    .focusout(function () 
    {
      if ($(this).attr('value') == '')
      {
        $(this).attr('value','location');
      }
    }
  );
  
  $('#ta_password')
    .focusout(function () 
    {
      if ($(this).attr('value') == '')
      {
        document.getElementById('ta_password').setAttribute('type','text');
        $(this).attr('value','password');
      }
    }
  );
  
  $('#new_ta').submit(function ()
  {
    alert('here');
    window.location.search = 'ta=true';
  });
  
  $('#new_student').submit(function ()
  {
    
  });
  
});
