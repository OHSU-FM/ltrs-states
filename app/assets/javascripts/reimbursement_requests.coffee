$ ->
  $('i[data-toggle="popover"]').popover(
    content: $('#popover-content').html(),
    html: true,
    container: 'body'
  )

  # cocoon config
  $('#add-assoc-itinerary')
    .data('association-insertion-method', 'append')
    .data('association-insertion-node', '#itinerary-attachment')
  $('#add-assoc-agenda')
    .data('association-insertion-method', 'append')
    .data('association-insertion-node', '#agenda-attachment')
  $('#add-assoc-miles-map')
    .data('association-insertion-method', 'append')
    .data('association-insertion-node', '#miles-map-attachment')
  $('#add-assoc-add-docs')
    .data('association-insertion-method', 'append')
    .data('association-insertion-node', '#add-docs-attachment')
