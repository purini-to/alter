app = angular.module 'alter'

app.controller 'chatLogCtrl', ($rootScope, $scope, $location, $anchorScroll, $timeout, socketUtil, roomModel, userModel) ->
  $scope.activeRoom = roomModel.activeRoom
  $scope.enterUsers = []
  $scope.logs = []
  $scope.log = {
    content: ''
    contentType: 1
    user: userModel.user
    room: roomModel.activeRoom
  }

  goButtomSettings = {
    container: '.main-content'
    duration: 700
    easing: 'swing'
  }

  goButtom = (settings, timout = 700) ->
    $timeout ->
      scrollPane = angular.element(settings.container)
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

  $scope.isContinuation = (index, corre) ->
    if index is 0 and corre < 0
      return false
    pre = index + corre
    l = $scope.logs[index].user._id 
    lp = $scope.logs[pre].user._id
    l is lp

  $scope.sendLog = (ev) ->
    socketUtil.emit 'room:sendLog', $scope.log
    $scope.log.content = ''
    $scope.log.contentType = 1

  $scope.$on 'socket:room:enter:logs', (ev, logs) ->
    $scope.logs = logs
    goButtom goButtomSettings
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
  $scope.$on 'socket:room:sendLog', (ev, data) ->
    $scope.logs.push data
    goButtom goButtomSettings, 0

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
