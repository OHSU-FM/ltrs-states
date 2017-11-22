style_tooltip = (node) ->
  $(node).qtip()
  return

$(document).ready ->
  $('.dropdown-toggle').dropdown()
  $(document).on 'create', '.tooltip', ->
    $(this).tooltip()
    return

  # datepicker stuff
  $('#start-datepicker').datepicker(
    format: 'yyyy-mm-dd',
  ).on "changeDate", (e) ->
    $('#end-datepicker').datepicker('setStartDate', e["date"])


  $('#end-datepicker').datepicker(
    format: 'yyyy-mm-dd'
  )


  $('[data-toggle="tooltip"]').tooltip()
  # Close popovers when we click outside of the box
  $('body').on 'click', (e) ->
    $('[data-toggle="popover"]').each ->
      # the 'is' for buttons that trigger popups
      # the 'has' for icons within a button that triggers a popup
      if !$(this).is(e.target) and $(this).has(e.target).length == 0 and $('.popover').has(e.target).length == 0
        $(this).popover 'hide'
      return
    return
  return
