# this handles showing the right followup field from a dd selection
# (business_purpose dropdown)
# https://gist.github.com/masonjm/1c221475fc099c90ba30
$.fn.dependsOn = (element, value) ->
  elements = this

  hideOrShow = ->
    $this = $(this)
    showEm = undefined
    if $this.is('input[type="checkbox"]')
      showEm = $this.is(':checked')
    else if $this.is('select')
      fieldValue = $this.find('option:selected').val()
      if typeof value == 'undefined'
        showEm = fieldValue and $.trim(fieldValue) != ''
      else if $.isArray(value)
        showEm = $.inArray(fieldValue, value.map((v) ->
          v.toString()
        )) >= 0
      else
        showEm = value.toString() == fieldValue
    elements.toggle showEm
    return

  #add change handler to element
  $(element).change hideOrShow
  #hide the dependent fields
  $(element).each hideOrShow
  elements

$.fn.fillTravelProfile = (data) ->
  for attr, value of data["travel_profile"]
    if attr == 'ff_numbers'
      s = $('#grant_funded_travel_request_ffid')
      s.empty()
      for _, ffn of value
        opt = "<option value=" + ffn["ffid"] + ">" + ffn["airline"] + "</option>"
        $(opt).appendTo(s)
    else
      $('#grant_funded_travel_request_' + attr).val(value)

$(document).on 'ready page:load', ->
  $('*[data-depends-on]').each ->
    $this = $(this)
    master = $this.data('dependsOn').toString()
    value = $this.data('dependsOnValue')
    if typeof value != 'undefined'
      $this.dependsOn master, value
    else
      $this.dependsOn master
    return

  $('#delegate-dd').on 'change', ->
    uid = this.value
    $.ajax({
      url: "/users/" + uid + "/travel_profile/",
      dataType: "json",
      method: "GET"
    }).success (data) ->
      $(this).fillTravelProfile data

  # cocoon config
  $('#add-assoc-spec-circ')
    .data('association-insertion-method', 'append')
    .data('association-insertion-node', '#spec-circ-attachment')
  return
