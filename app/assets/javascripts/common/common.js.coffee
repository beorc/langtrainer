window.initNamespace = (str) ->
  namespaces = str.split('.')
  namespaceToUse = window
  for namespace in namespaces
    if !namespaceToUse[namespace]
      namespaceToUse[namespace] = {}
    namespaceToUse = namespaceToUse[namespace]

  return namespaceToUse

# Twitter
#((d, s, id) ->
  #fjs = d.getElementsByTagName(s)[0]

  #return if d.getElementById(id)

  #js = d.createElement(s)
  #js.id = id
  #js.src="//platform.twitter.com/widgets.js"
  #fjs.parentNode.insertBefore(js, fjs)
#)(document, 'script', 'twitter-wjs')


$ ->
  if $("[data-skip-analytics]").size() == 0
    LANGTRAINER.lib.visitorsAnalytics.init()

  $('[data-toggle="tooltip"]').each ->
    options = {}
    placement = $(@).data('placement')
    options.placement = placement if placement

    $(@).tooltip(options)

  $.getScript "//yandex.st/share/share.js", () ->
    # Конструирование текста, который будет вставлен в тело lj-поста
    ljDescription = () ->
      container = $('<p></p>')

      aTag = $("<a></a>").attr('href', window.location.href)
      footLink = aTag.clone().
        text($('title').text()).
        wrap('<p>').parent()

      description = $('.lj-description p:first').clone()
      if description.length == 0
        text = $('meta[name="description"]').attr('content')
        description = $("<p>#{text}</p>")
      if description
        container.append(description)

      container.append(footLink)

      imgUrl = $('.lj-image').attr 'src'
      if imgUrl && imgUrl.length > 0
        imgContainer = aTag.clone()
        $('<img></img>').
          attr('src', imgUrl).
          attr('title', $('title')).
          appendTo imgContainer
        container.prepend imgContainer

      container.html()

    options =
      element: 'yashare'
      l10n: gon.locale
      elementStyle:
        type: 'button'
        quickServices: ['twitter', 'facebook', 'vkontakte', 'odnoklassniki']
      title: gon.shares_title,
      image: $('meta[property="og:image"]').attr('content'),
      description: $('meta[name="description"]').attr('content'),
      serviceSpecific:
        lj:
          description: ljDescription()

    new Ya.share options

