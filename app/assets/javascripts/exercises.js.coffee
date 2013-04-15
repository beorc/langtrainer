ns = initNamespace('LANGTRAINER.exercises')

ns.currentSentence = null

ns.getTime = ->
  new Date().getTime()

ns.prevPassIncTime = ns.getTime()

ns.incPassCounter = ->
  MIN_INC_INTERVAL = 2000
  currentTime = ns.getTime()
  timeDiff = currentTime  - ns.prevPassIncTime
  ns.prevPassIncTime = currentTime

  return if timeDiff < MIN_INC_INTERVAL

  $.ajax
    url: gon.increment_pass_counter_path
    type: 'put'
    dataType: 'json'

ns.rollSentence = () ->
  ns.currentSentence = ns.currentSentence.next()

  if ns.currentSentence.length == 0
    ns.currentSentence = $('.sentences .sentence[data-atom=false]:first')

  question = $('.question').empty()
  ns.currentSentence.clone().appendTo question


  unless ns.currentSentence.data('atom')
    ns.hideSkipAtoms()

  ns.answerInput().val ''

  ns.incPassCounter()

ns.hideSkipAtoms = ->
  $('.actions a.skip-atoms').addClass('hide')

ns.answerInput = ->
  $('textarea#answer')

ns.init = () ->
  ns.currentSentence = $('.sentences .sentence:first')

  $('.actions .next').click () ->
    ns.rollSentence()
    false

  ns.answerInput().keyup (e) ->
    if e.which == 13
      ns.rollSentence()
      return false

    input = $(@)
    answer = input.val()
    rightAnswer = ns.currentSentence.data('translation')
    if answer.length is 0
      input.removeClass('wrong').removeClass('right')
    else if rightAnswer.match("^#{answer}", 'i')
      input.removeClass('wrong').addClass('right')
    else
      input.removeClass('right').addClass('wrong')
    true

  $('.look').click ->
    rightAnswer = ns.currentSentence.data('translation')
    $('textarea#answer').removeClass('wrong').removeClass('right')
    ns.answerInput().val(rightAnswer)
    false

  $('.show-hint').click ->
    hints = $('.hints')
    if hints.hasClass('hide')
      hints.removeClass('hide')
    else
      hints.addClass('hide')

    false

  $('.show-next-word').click ->
    rightAnswer = ns.currentSentence.data('translation')
    answer = ns.answerInput().val()
    answerRegexp = new RegExp("^#{answer}(\\w*)\\s*(\\w*)", 'i')
    matches = answerRegexp.exec rightAnswer

    return false if matches is null

    ending = matches[1]

    if ending.length > 0
      ns.answerInput().val("#{answer}#{ending}")
      return false

    nextWord = matches[2]

    ns.answerInput().val("#{answer} #{nextWord}")
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


