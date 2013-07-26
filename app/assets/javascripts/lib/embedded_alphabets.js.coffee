ns = initNamespace('LANGTRAINER.lib.embedded_alphabets')

ns.init = ->
  $('.with-alphabet textarea').keyup (e) ->
    if e.which == 27
      controlContainer = $(@).closest('.with-alphabet')
      controlContainer.find('.alphabet-container').addClass('hide')
    true

  $('.with-alphabet textarea').focus ->
    controlContainer = $(@).closest('.with-alphabet')
    lang = controlContainer.data('lang')
    $(".alphabet-container[data-lang=#{lang}]").removeClass('hide').appendTo controlContainer

