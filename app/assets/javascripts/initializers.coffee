ready = ->
  $(document).ajaxError (e, xhr) ->
    window.location.replace(App.paths.login) if xhr.status == 401

  # hide validation errors on focus
  $('input.validation-error').on 'focus', ->
    $(@).next('span.validation-error-message').fadeOut()

  # show how "full" an activity is
  $('#activities .progress').progress()
  $('#activity .progress').progress(strokeWidth: 12)

  # show participants list
  $('a.participants').on 'click', (e)->
    e.preventDefault()
    $(@).hide()
    $('section.participants').show()

  $('.date-capture').pickadate
    min: new Date(App.event.startTime)
    max: new Date(App.event.endTime)
    format: 'ddd, d.m.'
    formatSubmit: 'dd-mm-yyyy'
    today: ''
    clear: ''
    onSet: (e)->
      target              = @$node.data 'target'
      {year, month, date} = @get 'select'
      $("#activity_#{target}_1i").val(year)
      $("#activity_#{target}_2i").val(month + 1)
      $("#activity_#{target}_3i").val(date)
      $('#activity_anytime').attr('checked', false)
    onClose: ->
      # TODO: Extract?
      otherSelector             = @$node.data('update')
      other                     = $(otherSelector).pickadate('picker')
      {year, month, date, pick} = @get 'select'
      otherPick                 = other.get('select').pick

      if otherSelector.match /end-time/
        other.set 'min', [year, month, date]
        other.set 'select', [year, month, date] if otherPick < pick
      else
        other.set 'max', [year, month, date]
        other.set 'select', [year, month, date] if otherPick > pick

      if onSameDay() then setTimePickerLimits() else removeTimePickerLimits()

  $('.time-capture').pickatime
    format: 'HH:i'
    formatSubmit: 'HH:i'
    clear: ''
    onSet: (e)->
      target             = @$node.data 'target'
      if e.select?
        [hours, minutes]   = [parseInt((e.select / 60), 10), e.select % 60]

        $("#activity_#{target}_4i").val(if hours < 10 then "0#{hours}" else hours)
        $("#activity_#{target}_5i").val(if minutes < 10 then "0#{minutes}" else minutes)
        $('#activity_anytime').attr('checked', false)
    onClose: ->
      if onSameDay() then setTimePickerLimits() else removeTimePickerLimits()

  # run through time pickers and
  # adjust the corresponding picker's limits
  setTimePickerLimits = ->
    $('.time-capture').each ->
      picker        = $(@).pickatime('picker')
      otherSelector = picker.$node.data('update')
      other         = $(otherSelector).pickatime('picker')
      {hour, mins}  = picker.get 'select'

      if otherSelector.match /end-time/
        other.set 'min', [hour, mins]
      else
        other.set 'max', [hour, mins]

  # remove min and max values from time pickers
  removeTimePickerLimits = (picker)->
    $('.time-capture').each ->
      $(@).pickatime('picker').set 'min': null, 'max': null

  onSameDay = ->
    $.unique(
      $.map($('.date-capture'), (el)->
        $(el).pickadate('picker').get('select').pick
      )
    ).length == 1

  # filters
  $filters    = $('form.filters label:not(.search)')
  $search     = $('form.filters label.search input')
  $activities = $('#activities li')

  $filters.attr('unselectable', 'on')
          .css('user-select', 'none')
          .on('selectstart', false)

  filterActivities = ->
    $activities.show()
    # the filter tabs
    values = $filters.filter('.selected')
                     .find('input[type=radio]')
                     .map(-> $(@).val()).get()
    unless 'all' in values
      $activities.not(".#{values.join(',.')}").hide()
    # use search input to filter further
    if query = $search.val()
      $activities
        .filter(':visible')
        .filter(-> !(new RegExp(query, 'i')).test $(@).find('h4').text())
        .hide()

  $filters.on 'click', (e)->
    e.preventDefault()
    $filter = $(@)
    if $filter.hasClass('selected')
      $filters.filter('.all').trigger('click')
    else
      if !e.shiftKey || (e.shiftKey && $filter.find('input').val() == 'all')
        $filters.removeClass 'selected'
      $filter.addClass('selected')
      filterActivities()

  # search
  # TODO: debounce
  $search.on 'keyup', filterActivities

  $search.next('a.clear').on 'click', (e)->
    e.preventDefault()
    $search.val('').trigger 'keyup'

  # form
  checkImageURL = (url, success, error) ->
    try
      img = new Image()
      img.onload  = -> success(url)
      img.onerror = -> error(url)
      img.src     = url
    catch error

  # form
  $('#new-activity #activity_image_url')
    .on 'keyup focus blur', ->
      $input   = $(@)
      $preview = $input.next('.preview').addClass('checking')

      error    = ->
        $input.addClass 'validation-error' if $input.val().length
        $preview
          .css('backgroundImage', '')
          .removeClass 'checking'
      success  = (url) ->
        $input.removeClass 'validation-error'
        $preview
          .css('backgroundImage', "url(#{url})")
          .removeClass 'checking'
      checkImageURL @value, success, error

    .trigger('keyup')


  hideNotification = ->
    $('#notifications').addClass 'hide'

  $('#notifications').on 'click', hideNotification
  setTimeout hideNotification, 3000

$(document).ready(ready)
$(document).on('page:load', ready)
