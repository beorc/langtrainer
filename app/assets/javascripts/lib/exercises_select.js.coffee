ns = initNamespace('LANGTRAINER.lib.exercises_select')

ns.init = ->
  $('.exercises-list select').change () ->
    option = $(@).find('option:selected')
    url = option.attr('url')
    window.location = url

