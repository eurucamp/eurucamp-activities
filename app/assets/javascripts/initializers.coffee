$ ->
  # show how "full" an activity is
  showProgress = (img)-> $(img).progress()
  $('#activities img.progress').each ->
    setTimeout showProgress, Math.random() * 1000 + 500, @

  # filters
  $filters    = $('form.filters label')
  $activities = $('#activities li')

  $filters.on 'click', (e)->
    e.preventDefault()
    $filters.removeClass 'selected'
    $filter = $(@).addClass 'selected'
    value   = $filter.find('input').prop('checked', true).val()
    $activities.show()
    $activities.not(".#{value}").hide() unless value is 'all'
