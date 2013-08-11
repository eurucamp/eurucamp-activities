###

jQuery plugin, displays a number between 0 and 100
as partial circle around an image.

MIT licensed, (c) 2013 Florian Plank, florian@polarblau.com

###
$ = jQuery

$.fn.extend
  progress: (options) ->

    settings =
      strokeWidth    : 6
      strokeColor    : '#15d701'
      strokeColorFull: '#e73921'
      duration       : 1500
      easing         : 'easeOutBounce'

    settings   = $.extend settings, options

    init = ->
      $el        = $(@)
      size       = $el.width()
      canvasSize = size + settings.strokeWidth * 2

      # this is the value we want to display
      progress   = settings.progress || parseInt($el.data('progress'))

      # when the value > 100 use different color
      color      = if progress >= 100 then settings.strokeColorFull else settings.strokeColor

      # wrap image
      $wrapper   = $('<div/>', class: 'progress-wrapper').css
        position: 'relative'
        # padding : settings.strokeWidth
      $el.wrap($wrapper)

      # generate canvas
      $canvas    = $('<canvas/>')
        .attr(width: canvasSize, height: canvasSize)
        .css
          position: 'absolute'
          zIndex  : 1
          left    : 0
          top     : 0
      $el.after($canvas)
      context    = $canvas.get(0).getContext("2d")

      # animated call to render
      $(progress: 0).animate({
        progress: progress
      },{
        duration  : settings.duration
        queue     : false
        easing    : settings.easing
        step      : (percentage) -> render(percentage, context)
      })

    percentageToRadians = (percentage) ->
      (1.5 - (percentage * 2 / 100)) * Math.PI

    render = (percentage, context) ->
      canvasSize = context.canvas.width
      context.clearRect(0, 0, canvasSize, canvasSize)
      context.beginPath()
      context.arc(canvasSize / 2,                            # origin x
                  canvasSize / 2,                            # origin y
                  canvasSize / 2 - settings.strokeWidth / 2, # radius
                  percentageToRadians(percentage),           # start angle
                  1.5 * Math.PI,                             # end angle
                  false)
      context.strokeStyle = color
      context.lineCap     = 'round'
      context.lineWidth   = settings.strokeWidth
      context.stroke()

    @each -> init.call(@)
