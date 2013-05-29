$ ->
  $(document).ajaxError (e, xhr) ->
    console.error "AJAX ERRPR!", arguments
    window.location.replace(App.paths.login) if xhr.status == 401

  # show how "full" an activity is
  showProgress = (img)-> $(img).progress()
  $('#activities img.progress').each ->
    setTimeout showProgress, Math.random() * 1000 + 500, @

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
