ns = initNamespace('LANGTRAINER.exercises')

ns.currentSentence = null

ns.rollSentence = () ->
  ns.currentSentence = ns.currentSentence.next()

  if ns.currentSentence.length == 0
    ns.currentSentence = $('.sentences .sentence:first')

  question = $('.question').empty()
  ns.currentSentence.clone().appendTo question

  $('.answer').val ''

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
    answer = input.val()
    rightAnswer = ns.currentSentence.data('translation')
    if rightAnswer.indexOf(answer) >= 0
      input.css color:'green'
    else
      input.css color:'red'
    true

  $('.look').click () ->
    rightAnswer = ns.currentSentence.data('translation')
    $('.answer').val(rightAnswer)

