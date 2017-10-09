
$(function() {
  // Prevent Flash of unstylized content
  $('.stop_flouc').hide();

  // Hide error messages that we dont want people to see
  // but we still want field highlighting
  $('li:contains("stop_flouc")').hide();

});


$().ready( function(){
  // Function for estimating time off
  function datepicker_estimate(elem){
    dates = $('.leave_dates input[type="date"]').map(function(index){
      var val = $(this).val();
      if (val != ''){
        var date = new Date(val)
        return date
      }
    });
    dates.sort(function(a,b){a-b});
    days_diff = Math.abs((dates[0]-dates[1])/86400000);
    if (days_diff==undefined || dates[0] == null || dates[1]==null){return;}
    var dow = dates[0].getUTCDay();
    var week_days = 0;
    for(i=0; i <= days_diff; i++){
      var cur_day = (dow+i)%7;
      if(cur_day > 0 && cur_day < 6){week_days++;}
    }

    $('.js_days_estimate').html(week_days );
  }

  // Create estimate if values already exist
  $('form.LeaveRequest_form input[type="date"]').each(function(){
    datepicker_estimate(this);
  });

  // Create estimate when values change
  $('form.LeaveRequest_form input[type="date"]').change(function(e){
    datepicker_estimate(this);
  });

  function total_leave_hours(){
    var total=0;
    $('.leave_hours input[type=number]').each(function(){
      cur = parseFloat( $(this).val() );
      if(cur > 0 ){
        total+=cur;
      }
    });
    $('.js_hours_total').html( total.toFixed(2) );
  }

  // Leave hours partial total
  $('.leave_hours input[type=number]').change(function(){
    total_leave_hours();
  });

  total_leave_hours();

  // Set the dates for this table equal to the travel dates
  $('.same_time').click(function(){
    // Depart date information
    $('.dest_depart_date').val( $('#travel_request_dest_depart_date').val() );
    $('.dest_depart_hour').val( $('#travel_request_dest_depart_hour').val() );
    $('.dest_depart_min').val(  $('#travel_request_dest_depart_min').val()  );
    $('.dest_arrive_hour').val( $('#travel_request_dest_arrive_hour').val() );
    $('.dest_arrive_min').val(  $('#travel_request_dest_arrive_min').val()  );

    // Return date information
    $('.ret_depart_date').val( $('#travel_request_ret_depart_date').val() );
    $('.ret_depart_hour').val( $('#travel_request_ret_depart_hour').val() );
    $('.ret_depart_min').val(  $('#travel_request_ret_depart_min').val()  );
    $('.ret_arrive_hour').val( $('#travel_request_ret_arrive_hour').val() );
    $('.ret_arrive_min').val(  $('#travel_request_ret_arrive_min').val()  );

    // Travel destination
    $('.dest_desc').val(  $('#travel_request_dest_desc').val()  );
  });

  // Change military time to am pm time in time select dropdown
  $('td .ampmdisabled').each(function(){
    // Only on 24 hour selectors
    if ( $(this).children('option').size() < 23  ) {return;}
    $(this).children('option').text(function(){
      val = parseFloat( $(this).val() );
      if ( !isNaN(val) ){ val+=1; }
      if (val && val < 12){ $(this).text( val.toString()+'am' ); }
      if (val && val == 12){ $(this).text( (val).toString()+'pm'  );  }
      if (val && val > 12){ $(this).text( (val-12).toString()+'pm'  );  }
    });


  });

  // first: hide forms unless associated true radio button is checked
  $('.toggle_form input[type="radio"][value="true"]').each(function() {
    if (!$(this).is('checked')) {
      hide_form($(this).data().target);
    }
  });

  // then: hide or show form when radio buttons are clicked
  $('.toggle_form input[type="radio"]').click(function() {
    if ($(this).val() == 'true') {
      show_form($(this).data().target);
    } else {
      hide_form($(this).data().target);
    }
  });

  if ( $('.modal_post').length > 0 && $('#modal_post').length == 0){
    $('#content').append('<div id="modal_post"></div>');
  }

  // Create modal wait dialog for post
  $('.modal_post').click(function(ev){
    ev.preventDefault();
    form = $(ev.target).closest('form');
    modal_post( form );
  });

});

// Use a modal dialog to show a form
function modal_show(url){

  $( "#modal_show" ).dialog( {
    width: 600,
    position: 'top',
    autoOpen: true,
    title: 'Details',
    hide: 'fold',
    show: 'blind',
    modal: true,
    open: function(){
      $(this).load(url, function(){
        $(this).children('#content').css('width','550px');
        $(this).children('.button').css('font-size','11pt');
      });
    }
  });

}

// Use a modal dialog to show post wait form
function modal_post(form){
  var url = $(form).attr('action');
  var spinner =  '<br/><img src="'+base_url+'/assets/spinner.gif" alt="Wait" />';
  var img_alert = '<img src="'+base_url+'/assets/emblem-alert.png" alt="Wait" />';
  var modal = $('#modal_post');
  var new_url = '';
  modal.dialog( {
    width: 400,
    position: 'center',
    autoOpen: true,
    title: 'Submitting request',
    hide: 'fold',
    show: 'blind',
    modal: true,
    open: function(){

      modal.html('<b>Contacting Server...</b>'+spinner);

      $.ajax({
        url: url,
        type: 'POST',
        dataType: 'json',
        data: $(form).serialize(),
        error: function(data){
          modal.dialog( "option", "buttons", [ { text: "Ok", click: function() { $( this ).dialog( "close" ); } } ] );
          modal.parent('.ui-dialog').find('.ui-state-default').each(function(){  $(this).addClass('ui-state-error');  });
          modal.dialog( "option", "title", "Server Error" );
          modal.dialog( "option", "dialogClass", "alert" );
          modal.html('There was a server error.');
        },
        success: function(data){
          if (data.next_page != undefined){
            window.location.replace(data.next_page);
          }else{
            location.reload();
          }
        }
      });
    }
  });

}

// Toggle visibility of questions - FadeIn and FadeOut
function toggle_form(obj){
  var $obj = $(obj);
  var match_against = ($obj.data().invert == true) ? 'false' : 'true'
  if($obj.val() == match_against){
    hide_form($obj.data().target)
  } else {
    show_form($obj.data().target)
  }
}

function hide_form(identifier) {
  $(identifier)
  .css('opacity', 1)
  .slideUp('slow')
  .animate(
    { opacity: 0 },
    { queue: false, duration: 'slow' }
  );
}

function show_form(identifier) {
  $(identifier)
  .css('opacity', 0)
  .slideDown('slow')
  .animate(
    { opacity: 1 },
    { queue: false, duration: 'slow' }
  );
}
