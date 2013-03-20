ns = initNamespace('LANGTRAINER.exercises')

ns.currentSentence = null

ns.rollSentence = () ->
  ns.currentSentence = ns.currentSentence.next()

  if ns.currentSentence.length == 0
    ns.currentSentence = $('.sentences .sentence[data-atom=false]:first')

  question = $('.question').empty()
  ns.currentSentence.clone().appendTo question


  unless ns.currentSentence.data('atom')
    ns.hideSkipAtoms()

  $('.answer').val ''

ns.hideSkipAtoms = ->
  $('.actions a.skip-atoms').addClass('hide')

ns.init = () ->
  ns.currentSentence = $('.sentences .sentence:first')

  $('.actions .next').click () ->
    ns.rollSentence()
    false

  $('.answer').keyup (e) ->
    if e.which == 13
      ns.rollSentence()
      return false

    input = $(@)
    answer = input.val().toLowerCase()
    rightAnswer = ns.currentSentence.data('translation').toLowerCase()
    if rightAnswer.indexOf(answer) >= 0
      input.css color:'green'
    else
      input.css color:'red'
    true

  $('.look').click ->
    rightAnswer = ns.currentSentence.data('translation')
    $('.answer').val(rightAnswer)
    false

  $('.show-hint').click ->
    hints = $('.hints')
    if hints.hasClass('hide')
      hints.removeClass('hide')
    else
      hints.addClass('hide')

    false

  $('.correct').click ->
    url = ns.currentSentence.data('correction-url')
    window.location = url
    false

  $('.create').click ->
    url = $('.sentences').data('creation-url')
    window.location = url
    false

  $('a.skip-atoms').click ->
    ns.hideSkipAtoms()
    ns.currentSentence = $('.sentences .sentence[data-atom=true]:last')
    ns.rollSentence()
    false

  LANGTRAINER.lib.exercises_select.init()

  $('a.accordion-toggle').click ->
    targetId = $(@).attr('href')
    $(targetId).collapse('toggle')
    false


