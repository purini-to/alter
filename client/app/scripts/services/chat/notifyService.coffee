app = angular.module 'alter'

###
# 通知を行うサービス
###
app.factory 'notifyService', ->
  service = {}
  ###
  # 5秒後に自動的に通知を閉じるように設定
  ###
  notify.config({
    autoClose: 5000
  })

  ###
  # 現在のタブを最前面にする
  ###
  activeWindow = ->
    window.focus()

  ###
  # ブラウザがデスクトップ通知に対応しているかチェック
  ###
  service.isSupported = ->
    notify.isSupported

  ###
  # 通知の許可設定がされているかチェック
  ###
  service.isPermissionGrant = ->
    permission = notify.permissionLevel()
    permission is notify.PERMISSION_GRANTED

  ###
  # 通知許可のポップアップを表示する
  ###
  service.requestPermission = ->
    if service.isSupported() and !service.isPermissionGrant()
      notify.requestPermission()

  ###
  # チャットのデスクトップ通知を表示
  ###
  service.showChat = (sendUserName, log, options) ->
    if service.isSupported() and service.isPermissionGrant()
      settings = {
        icon: 'notifyAlter.ico'
        click: (notification, wrapper)->
          wrapper.close()
          activeWindow()
      }
      _options = angular.extend settings, options
      _options.body = log
      notify.createNotification "@#{sendUserName}", _options

  service
