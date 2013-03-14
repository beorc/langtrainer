ns = initNamespace('LANGTRAINER.lib.visitorsAnalytics')

ns.initYandexMetrika = (w, c) ->
  if gon.ym
    (w[c] = w[c] || []).push () ->
      try
        w[gon.ym] = new Ya.Metrika { id: gon.ym, enableAll: true, trackHash:true, webvisor:true }
      catch error
    $.getScript 'http://mc.yandex.ru/metrika/watch.js'

ns.init = ->
  ns.initYandexMetrika(window, 'yandex_metrika_callbacks')
