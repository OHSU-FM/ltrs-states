$ ->
  $('i[data-toggle="popover"]').popover(
    content: $('#popover-content').html(),
    html: true,
    container: 'body'
  )
