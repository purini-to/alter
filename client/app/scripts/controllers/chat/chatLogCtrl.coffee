app = angular.module 'alter'

app.controller 'chatLogCtrl', ($rootScope, $scope, $location, $anchorScroll, $timeout, $mdDialog, $mdSidenav, $state, $mdToast, $mdMedia, Upload, socketUtil, roomService, userService, roomModel, userModel, topNavModel) ->
  $scope.isOpenSubNav = false
  $scope.activeRoom = roomModel.activeRoom
  $scope.enterUsers = []
  $scope.logsLoadBusy = false
  $scope.form = {}
  $scope.files = []
  $scope.logs = []
  $scope.log = {
    content: ''
    contentType: 1
    user: userModel.user
    room: roomModel.activeRoom
  }
  $scope.getAvator = (index) ->
    logUser = $scope.logs[index].user
    if logUser.avator? and logUser.avator.path? and !$scope.isContinuation(index, -1)
      logUser.avator.path
    else
      'null'

  $scope.subNavClose = ->
    $scope.isOpenSubNav = false

  $scope.subNavOpen = (value) ->
    $scope.isOpenSubNav = true

  scrollElement = angular.element('.main-content')
  goButtomSettings = {
    container: '.main-content'
    duration: 700
    easing: 'swing'
  }

  textareaElement = angular.element('.chat-input-container textarea')
  fileupElement = angular.element('.chat-input-container .file-upload')

  textareaElement.bind 'paste', (ev) ->
    items = ev.originalEvent.clipboardData.items
    for item in items
      if item.type.indexOf("image") isnt -1
        file = item.getAsFile()
        Upload.upload({
          url: "upload/file/#{$scope.activeRoom._id}"
          fields: {user: userModel.user},
          file: file
        }).success (data,  status,  headers,  config) ->
          tmp = $scope.log.content
          $scope.log.content = data
          $scope.log.contentType = 2
          socketUtil.emit 'room:sendLog', $scope.log
          $scope.log.content = tmp
          $scope.log.contentType = 1

  textareaElement.closest('md-content').bind 'dragenter', (ev) ->
    $timeout ->
      fileupElement.addClass 'active'

  fileupElement.closest('md-content').bind 'dragleave', (ev) ->
    fileupElement.removeClass 'active'

  fileupElement.closest('md-content').bind 'drop', (ev) ->
    fileupElement.removeClass 'active'

  showAlert = ->
    $mdDialog.show(
      $mdDialog.alert()
        .parent document.body
        .title 'ファイル数が多すぎます'
        .content '同時にアップロード出来るファイル数は５個までです。'
        .ariaLabel 'Alert Dialog File Upload'
        .ok '確認'
    )

  $scope.$watch 'files', (files) ->
    targets = files.filter (val, index) ->
      val.type? and val.type isnt 'directory'
    if targets? and targets.length
      if targets.length < 6
        for file in targets
          Upload.upload({
            url: "upload/file/#{$scope.activeRoom._id}",
            fields: {user: userModel.user},
            file: file
          }).success (data,  status,  headers,  config) ->
            tmp = $scope.log.content
            $scope.log.content = data
            if file.type.indexOf("image") is -1
              $scope.log.contentType = 3
            else
              $scope.log.contentType = 2
            socketUtil.emit 'room:sendLog', $scope.log
            $scope.log.content = tmp
            $scope.log.contentType = 1
      else
        showAlert()

  mouseOverLogIndex = null

  goButtom = (settings, timout, callback) ->
    $timeout ->
      scrollPane = scrollElement
      scrollY = scrollPane.get(0).scrollHeight
      scrollPane.animate {scrollTop: scrollY},  settings.duration,  settings.easing, ->
        if typeof callback is 'function'
          callback.call(this)
    , timout

  indexOfEnterUser = (_id) ->
    index = -1
    for user, idx in $scope.enterUsers
      if user._id is _id
        index = idx
        break
    index

  isNotEmptyLog = ->
    $scope.log.content? and $scope.log.content.trim() isnt ''

  loadLogs = ->
    if $scope.logsLoadBusy is true
      return
    else
      $scope.logsLoadBusy = true
      socketUtil.emit 'room:moreLogs', {roomId: $scope.activeRoom._id, offset: $scope.logs.length}

  $scope.setMouseOverLogIndex = (index) ->
    mouseOverLogIndex = index
  $scope.resetMouseOverLogIndex = ->
    mouseOverLogIndex = null
  $scope.isMouseOverLog = (index) ->
    index is mouseOverLogIndex

  $scope.isOwnerLog = (index) ->
    result = false
    logUser = $scope.logs[index].user
    if logUser?
      result = logUser._id is userModel.user._id
    result
  $scope.removeLog = (index) ->
    logId = $scope.logs[index]._id
    socketUtil.emit 'room:removeLog', {roomId: $scope.activeRoom._id, logId: logId}
    $scope.resetMouseOverLogIndex()

  $scope.isContinuation = (index, corre) ->
    if index is 0 and corre < 0
      return false
    pre = index + corre
    l = $scope.logs[index].user._id
    lp = $scope.logs[pre].user._id
    l is lp

  $scope.isAdminRoom = ->
    isAdmin = false
    for userInfo in $scope.activeRoom.users
      if userInfo.user is userModel.user._id and userInfo.isAdmin
        isAdmin = true
        break
    isAdmin

  $scope.showRoomDeleteConfirm = (ev) ->
    confirm = $mdDialog.confirm()
      .title 'ルームの削除を行います'
      .content '入室中のメンバーは強制的に退出されます'
      .ariaLabel 'Room delete confirm'
      .ok '削除'
      .cancel 'キャンセル'
      .targetEvent ev
    $mdDialog.show confirm
      .then ->
        socketUtil.emit 'room:delete', $scope.activeRoom

  if $scope.isAdminRoom()
    $scope.$watch 'activeRoom', (newVal, oldVal) ->
      if $scope.form.roomForm? and $scope.form.roomForm.$valid
        socketUtil.emit 'room:update:info', newVal
        topNavModel.updateToggleInMenu 'お気に入り', oldVal.name, {name: newVal.name}
    , true

  $scope.sendLog = (ev) ->
    if isNotEmptyLog()
      socketUtil.emit 'room:sendLog', $scope.log
      $scope.log.content = ''
      $scope.log.contentType = 1

  $scope.$on 'socket:room:enter:logs', (ev, logs) ->
    if logs? and logs.length > 0
      $scope.logs = logs.reverse()
      goButtom goButtomSettings, 700, ->
        scrollElement.bind 'scroll', (ev)->
          isLoadScrollPos = ev.target.scrollTop < 20
          if isLoadScrollPos is true
            loadLogs()

  $scope.$on 'socket:room:enter:user', (ev, data) ->
    index = indexOfEnterUser data._id
    if index is -1
      $scope.enterUsers.push data
  $scope.$on 'socket:room:enter:users', (ev, data) ->
    $scope.enterUsers = data
  $scope.$on 'socket:room:leave:user', (ev, data) ->
    index = indexOfEnterUser data.userId
    if index > -1
      $scope.enterUsers.splice index, 1
  $scope.$on 'socket:room:moreLogs', (ev, data) ->
    if data? and data.length > 0
      originHeight = scrollElement.get(0).scrollHeight
      $scope.logs = data.reverse().concat $scope.logs
      $timeout ->
        top = scrollElement.get(0).scrollTop + scrollElement.get(0).scrollHeight - originHeight
        scrollElement.get(0).scrollTop = top
        $timeout ->
          $scope.logsLoadBusy = false
  $scope.$on 'socket:room:sendLog', (ev, data) ->
    $scope.logs.push data
    goButtom goButtomSettings, 0
  $scope.$on 'socket:room:update:info', (ev, data) ->
    oldName = $scope.activeRoom.name
    $scope.activeRoom.name = data.name
    $scope.activeRoom.description = data.description
    topNavModel.updateToggleInMenu 'お気に入り', oldName, {name: data.name}
  $scope.$on 'socket:room:removeLog', (ev, data) ->
    index = -1
    for log, idx in $scope.logs
      if log._id is data.logId
        index = idx
        break
    if index > -1
      $scope.logs.splice index, 1
  $scope.$on 'socket:room:delete', (ev, data) ->
    roomId = data.roomId
    idx = userModel.indexOfFavoriteRoom roomId
    if idx > -1
      userService.removeFavoriteRoom $scope.activeRoom, idx
    socketUtil.emit 'room:leave', $scope.activeRoom
    $state.go ('chat.room')
    $mdToast.show(
      $mdToast.simple()
        .content 'ルームが削除されたため退室しました'
        .position 'bottom left'
        .hideDelay(3000)
    )

  leaveRoom = (event,  toState,  toParams,  fromState,  fromParams) ->
    if fromState.name is 'chat.chatLog'
      socketUtil.emit 'room:leave', $scope.activeRoom
  $rootScope.$on '$stateChangeSuccess', leaveRoom

  socketUtil.emit 'room:enter', $scope.activeRoom
  socketUtil.forward 'room:enter:logs', $scope
  socketUtil.forward 'room:enter:user', $scope
  socketUtil.forward 'room:enter:users', $scope
  socketUtil.forward 'room:leave:user', $scope
  socketUtil.forward 'room:sendLog', $scope
  socketUtil.forward 'room:delete', $scope
  socketUtil.forward 'room:update:info', $scope
  socketUtil.forward 'room:moreLogs', $scope
  socketUtil.forward 'room:removeLog', $scope
