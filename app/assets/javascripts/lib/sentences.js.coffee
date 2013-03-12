ns = initNamespace('LANGTRAINER.lib.sentences')

ns.init = ->
  sendCorrection = (cfg) ->
    data = sentence_id: cfg.id
    data[cfg.language] = cfg.content

    $.ajax
      url: cfg.url
      type: cfg.method
      dataType: 'json'
      data: data
      context: cfg.element
      beforeSend: ->
        $('.changes-applied').removeClass('changes-applied')
      complete: (xhr, status) ->
        if xhr.status == 200
          input = $(@)

          if xhr.responseText.length > 1
            response = $.parseJSON xhr.responseText
            sentence = input.closest('.sentence')

            sentence.attr('data-id', response.id)
            sentence.attr('data-url', response.url)
            sentence.attr('data-method', response.method)

          input.removeClass('changed')
          input.addClass('changes-applied')
          sentence = input.closest('.sentence')
          sentence.find('.save-sentence').addClass('hidden')
        else
          alert(gon.unknown_error_message)

    false

  applyTranslation = (input) ->
    sentence = input.closest('.sentence')
    cfg =
      id: sentence.attr('data-id')
      url: sentence.attr('data-url')
      method: sentence.attr('data-method')
      content: input.val()
      language: input.closest('.translation').data('lang')
      element: input

    sendCorrection(cfg)

  $('textarea').keypress (e) ->
    input = $(@)

    if e.which != 13
      unless input.hasClass('changed')
        input.addClass('changed')
        sentence = input.closest('.sentence')
        sentence.find('.save-sentence').removeClass('hidden')
      return true

    applyTranslation(input)

    return false

  $('.save-sentence').click ->
    inputs = $(@).closest('.sentence').find('textarea.changed')
    inputs.each ->
      applyTranslation($(@))
    false

  $('.exercises-list select').change () ->
    option = $(@).find('option:selected')
    url = option.attr('url')
    window.location = url

  $('input.search').keypress (e) ->
    input = $(@)

    return true if e.which != 13

    input.closest('form').submit()

    return false

