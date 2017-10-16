$().ready ->
  # Automatically set the active user form tab
  whash = window.location.hash
  if $.inArray(whash, ['#home', '#delegates', '#contacts', '#travler-profile']) >= 0
    $('a[href="' + whash + '"]').trigger 'click'
  else
    $('a[href="#home"]').trigger 'click'

  # Cocoon config for contacts form
  $('#ldap_query a.add_fields')
    .data('association-insertion-method', 'append')
    .data('association-insertion-node', '#ldap_query_table')
  # Cocoon config for delegates form
  $('#ldap_delegates_query a.add_fields')
    .data('association-insertion-method', 'append')
    .data('association-insertion-node', '#ldap_delegates_table')

  $('form').submit ->
    submitBtn = $(this).find(':submit')
    $.ajax()
      .success ->
        submitBtn
          .prop('disabled', false)

