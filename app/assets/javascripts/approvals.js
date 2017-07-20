// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$().ready(function(){
  // Initially hide the submit button
  $('select#approval_state_aasm_state,select#leave_request_status,select#travel_request_status').each(function(){
    $(this).siblings('input[type=submit]').hide();
  });
});

$(document).ready(function(){
  $('form#search_approvals i[data-toggle="popover"]').popover();

  $(document).on('ajax:complete', 'form.edit_approval_state', function(){
    $(this).find('input[type=submit]').hide();
  });
  $(document).on('ajax:success', 'form.edit_approval_state', function(){
    $(this).append('<i class="glyphicon glyphicon-ok" style="color:green;"></i>');
  });
  $(document).on('ajax:beforeSend', 'form.edit_approval_state', function(){
    $(this).find('.glyphicon-ok').remove();
  });
  $(document).on('ajax:error', 'form.edit_approval_state', function(a,b,c){
    var msg = b.responseJSON.map(function(v){return v[0] + ': ' + v[1]}).join('<br/>')
    $(this).find('input[type=submit]').hide();
    $(this).append('<i style="color:red;cursor:pointer;cursor:hand;" data-html="true" data-toggle="popover" title="Error" class="glyphicon glyphicon-exclamation-sign" data-content="'+msg+'"></i>')
    $(this).find('i[data-toggle="popover"]').popover();
  });


  // Initially hide the submit button
  $('select#approval_state_aasm_state,select#leave_request_status,select#travel_request_status').each(function(){
    $(this).siblings('input[type=submit]').hide();
  });

  // Only Show save buttons when there is a change
  var save_selectors = 'select#approval_state_aasm_state,select#leave_request_status,select#travel_request_status';
  $(document).on('change', save_selectors, function(){
    original = $(this).siblings('#status_was').attr('value');
    newval = $(this).val();
    if (original==newval){
      $(this).siblings('input[type=submit]').fadeOut(500);
    }else{
      $(this).siblings('input[type=submit]').fadeIn(500);
    }
  });


  var css_finder = '#page-content-wrapper > div > div:nth-child(2) > div > div.wide.partial_form'
  var digg_finder = '.digg_pagination'

  // auto update contents on success
  $('form#search_approvals').on('ajax:success', function(evt, data, status, xhr){
    // show description
    $('#approvals_title').replaceWith(function(){
      return $(data).find('#approvals_title').fadeIn();
    });
    $('#search_description').replaceWith(function(){
      return $(data).find('#search_description').fadeIn();
    });
    // show content
    $(digg_finder).replaceWith(function(){
      return $(data).find(digg_finder).fadeIn();
    });
    // show pagination
    $(css_finder).replaceWith(function(){
      return $(data).find(css_finder).fadeIn();
    });
    $(document).trigger('page:load');

    // update on error
  }).on('ajax:error', function(evt, xhr, data){
    // display error message
    $(css_finder).replaceWith(function(){
      var xdata = '<div class="wide partial_form bs-callout bs-callout-danger"> <i class="glyphicon glyphicon-exclamation-sign" style="color:red;"></i> We are sorry, but an error has occurred. We have been notified of the error and will be looking for a solution shortly. </div>'
      return $(xdata)
    });

    // empty paginator
    $(digg_finder).replaceWith(function(){
      var xdata = '<div class="digg_pagination"> </div>'
      return $(xdata)
    });
  });

  $(document).on('ajax:beforeSend', 'form#search_approvals', function(x, y){
    $('#approvals_table').replaceWith($('<div class="centered-spinner-image">'))
  });

  // auto submit search on selector change
  $(document).on('change', 'form#search_approvals select', function(){
    $(this).parents('form').trigger('submit.rails');
  });

});
