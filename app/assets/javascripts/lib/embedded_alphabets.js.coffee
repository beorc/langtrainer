ns = initNamespace('LANGTRAINER.lib.embedded_alphabets')

ns.removeKeyboard = (controlContainer) ->
  controlContainer.find('.alphabet-container').addClass('hide')
  false

ns.init = ->
  $('.with-alphabet textarea').keyup (e) ->
    ns.removeKeyboard($(@).closest('.with-alphabet')) if e.which == 27
    false

  $('.with-alphabet textarea').focus ->
    controlContainer = $(@).closest('.with-alphabet')
    lang = controlContainer.data('lang')
    $(".alphabet-container[data-lang=#{lang}]").removeClass('hide').appendTo controlContainer

  $('body').on 'click', '.with-alphabet .alphabet button.shift', ->
    alphabet = $(@).closest('.alphabet')
    alphabet.find('a.btn').each (i, button) ->
      $(button).changeCase()

  $('body').on 'click', '.with-alphabet .alphabet a.btn', ->
    controlContainer = $(@).closest('.with-alphabet')
    char = $(@).text()
    input = controlContainer.find('textarea')
    answer = input.val()

    input.insertAtCaret(char)
    input.focus()
    false
