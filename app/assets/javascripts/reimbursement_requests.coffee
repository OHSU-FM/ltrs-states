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

  # datepicker stuff
  # instantiate both
  sdp = $('#rr-start-datepicker').datepicker(format: 'yyyy-mm-dd')
  edp = $('#rr-end-datepicker').datepicker(format: 'yyyy-mm-dd')

  sdp.datepicker('setEndDate', edp.datepicker('getDate')
  ).on("changeDate", (e) ->
    edp.datepicker('setStartDate', e["date"])
  ).on("hide", (e) ->
    handleMRRFields()
  )

  edp.datepicker('setStartDate', sdp.datepicker('getDate')
  ).on("changeDate", (e) ->
    sdp.datepicker('setEndDate', e["date"])
  ).on("hide", (e) ->
    handleMRRFields()
  )

  # functions

  handleMRRFields = () ->
    if dateLengthsEqual()
    else
      startDate = $('#rr-start-datepicker').datepicker('getDate')
      endDate = $('#rr-end-datepicker').datepicker('getDate')
      ary = getDateArray(startDate, endDate)
      $('#mrr-days-row').html('')
      options = { weekday: 'short', year: 'numeric', month: 'long', day: 'numeric' }
      counter = 0 # so we can have unique ids if multiple days added
      newPerDiem date, options, counter for date in ary

  newPerDiem = (date, options, counter) ->
    r = $('#mrr-days-row')
    content = r.data('association-insertion-template')
    assoc = 'meal_reimbursement_requests'
    regexp_braced = new RegExp('\\[new_' + assoc + '\\](.*?\\s)', 'g')
    new_id = new Date().getTime() + counter++
    new_content = content.replace(regexp_braced, newcontent_braced(new_id))
    template = $.parseHTML(new_content)
    $(template).find('#replace-me-label').html(date.toLocaleDateString('en-US', options))
    $(template).find('#replace-me-input').val(date)
    r.append(template)
    return

  dateLengthsEqual = () ->
    days = $('.mrr-day').length
    ms = msBetweenDates($('#rr-start-datepicker'), $('#rr-end-datepicker'))

    if days == msToDays(ms) + 1
      return true
    if (days == 1 and msToDays(ms) == 0)
      return true
    else
      return false

  msBetweenDates = (sdp, edp) ->
    return edp.datepicker('getDate') - sdp.datepicker('getDate')

  msToDays = (ms) ->
    return Math.round(ms / 1000 / 60 / 60 / 24)

  # returns an array of dates bw startDate and endDate including beginning and end
  getDateArray = (startDate, endDate) ->
    dateArray = new Array()
    currentDate = new Date(startDate)
    while (currentDate < addDays(endDate, 1))
      d = new Date(currentDate)
      dateArray.push(d)
      currentDate = addDays(currentDate, 1)
    return dateArray

  addDays = (date, numDays) ->
    newDate = new Date()
    newDate.setDate(date.getDate() + numDays)
    return newDate

  newcontent_braced = (id) ->
    return '[' + id + ']$1'
