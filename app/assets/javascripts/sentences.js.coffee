ns = initNamespace('LANGTRAINER.sentences')

ns.init = ->
  LANGTRAINER.lib.embedded_alphabets.init()
  LANGTRAINER.lib.sentences.init()
