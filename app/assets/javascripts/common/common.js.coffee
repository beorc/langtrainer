window.initNamespace = (str) ->
  namespaces = str.split('.')
  namespaceToUse = window
  for namespace in namespaces
    if !namespaceToUse[namespace]
      namespaceToUse[namespace] = {}
    namespaceToUse = namespaceToUse[namespace]

  return namespaceToUse

