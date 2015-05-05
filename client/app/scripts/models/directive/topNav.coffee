app = angular.module 'alter'

app.factory 'topNavModel', ->
  service = {}
  createMenu = (name, state) ->
    menu = {
      name: name
      type: 'link'
      state: state
    }
  createToggleMenu = (name, items = []) ->
    menu = {
      name: name
      type: 'toggle'
      opened: true
      iconOpen: 'expand_less'
      iconClose: 'expand_more'
      items: items
    }
  # 固定で表示するメニュー
  service.staticMenus = [
    createMenu 'ルーム一覧', 'chat.room'
  ]
  # お気に入り等のユーザー操作によって変化するメニュー
  service.dynamicMenus = [
    createToggleMenu 'お気に入り'
  ]
  # メニューの追加を行う
  service.addLinkMenu = (name, state) ->
    service.dynamicMenus.push createMenu name, state
  # メニューのトグルメニューを追加する
  service.addToggleMenu = (name, items = []) ->
    service.dynamicMenus.push createToggleMenu name, items
  # トグルメニューに子メニューを追加する
  service.addToggleInMenu = (toggleName, name, state) ->
    toggleMenu = null
    for menu in service.dynamicMenus
      if menu.name is toggleName and menu.type is 'toggle'
        toggleMenu = menu
        break
    if toggleMenu?
      toggleMenu.items.push createMenu name, state
  # トグルメニューに子メニューを追加する
  service.removeToggleInMenu = (toggleName, name) ->
    toggleMenu = null
    for menu, idx in service.dynamicMenus
      if menu.name is toggleName and menu.type is 'toggle'
        index = idx
        toggleMenu = menu
        break
    if toggleMenu?
      for item, index in toggleMenu.items
        if item.name is name
          toggleMenu.items.splice index, 1
          break

  service