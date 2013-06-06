ready = ->
  $(document).ajaxError (e, xhr) ->
    console.error "AJAX ERROR!", arguments if console?.error?
    window.location.replace(App.paths.login) if xhr.status == 401

  # show how "full" an activity is
  showProgress = (img)-> $(img).progress()
  $('#activities img.progress').each ->
    setTimeout showProgress, Math.random() * 1000 + 500, @

  $('#activity img.progress').progress(strokeWidth: 12)

  $('.date-capture').pickadate
    min: new Date(App.event.startTime)
    max: new Date(App.event.endTime)
    format: 'ddd, d.m.'
    formatSubmit: 'dd-mm-yyyy'
    onSet: (e)->
      target              = @$node.data 'target'
      {year, month, date} = @get 'select'
      $("#activity_#{target}_1i").val(year)
      $("#activity_#{target}_2i").val(month + 1)
      $("#activity_#{target}_3i").val(date)
    onClose: ->
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

  $('.time-capture').pickatime
    format: 'HH:i'
    formatSubmit: 'HH:i'
    onSet: (e)->
      target             = @$node.data 'target'
      [hours, minutes]   = [parseInt((e.select / 60), 10), e.select % 60]
      $("#activity_#{target}_4i").val(if hours < 10 then "0#{hours}" else hours)
      $("#activity_#{target}_5i").val(minutes)

    onClose: ->
      otherSelector      = @$node.data('update')
      other              = $(otherSelector).pickatime('picker')
      console.log $(otherSelector), $(otherSelector).pickatime('picker')
      {hour, mins, pick} = @get 'select'
      otherPick          = other.get('select').pick

      if otherSelector.match /end-time/
        other.set 'min', [hour, mins]
        other.set 'select', [hour, mins] if otherPick < pick
      else
        other.set 'max', [hour, mins]
        other.set 'select', [hour, mins] if otherPick > pick

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


  $('#notifications').fadeOut('slow')

  $('#notifications').bind 'click', ->
    $(this).fadeOut('slow')

$(document).ready(ready)
$(document).on('page:load', ready)
