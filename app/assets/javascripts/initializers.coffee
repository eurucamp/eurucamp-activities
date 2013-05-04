$ ->
  # show how "full" an activity is
  showProgress = (img)-> $(img).progress()
  $('#activities img.progress').each ->
    setTimeout showProgress, Math.random() * 1000 + 500, @

  # filters
  $filters    = $('form.filters label')
  $activities = $('#activities li')

  $filters.attr('unselectable', 'on')
          .css('user-select', 'none')
          .on('selectstart', false)

  $filters.on 'click', (e)->
    e.preventDefault()
    if !e.shiftKey || (e.shiftKey && $(@).find('input').val() == 'all')
      $filters.removeClass 'selected'

    $(@).addClass('selected')

    values = $filters.filter('.selected')
                     .find('input[type=radio]')
                     .map(-> return $(@).val()).get()
    $activities.show()
    unless 'all' in values
      $activities.not(".#{values.join(',.')}").hide()
