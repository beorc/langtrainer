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

