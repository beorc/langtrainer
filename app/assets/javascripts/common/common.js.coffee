window.initNamespace = (str) ->
  namespaces = str.split('.')
  namespaceToUse = window
  for namespace in namespaces
    if !namespaceToUse[namespace]
      namespaceToUse[namespace] = {}
    namespaceToUse = namespaceToUse[namespace]

  return namespaceToUse

# Twitter
((d, s, id) ->
  fjs = d.getElementsByTagName(s)[0]

  return if d.getElementById(id)

  js = d.createElement(s)
  js.id = id
  js.src="//platform.twitter.com/widgets.js"
  fjs.parentNode.insertBefore(js, fjs)
)(document, 'script', 'twitter-wjs')

$ ->
  if $("[data-skip-analytics]").size() == 0
    LANGTRAINER.lib.visitorsAnalytics.init()

  $('[data-toggle="tooltip"]').each ->
    options = {}
    placement = $(@).data('placement')
    options.placement = placement if placement

    $(@).tooltip(options)

