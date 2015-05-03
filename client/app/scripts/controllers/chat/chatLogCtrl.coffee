app = angular.module 'alter'

app.controller 'chatLogCtrl', ($rootScope, $scope, $stateParams, socketUtil, roomModel, userModel) ->
  $scope.activeRoom = roomModel.activeRoom
  $scope.enterUsers = []
  $scope.logs = []
  $scope.log = {
    content: ''
    contentType: 1
    user: userModel.user
    room: roomModel.activeRoom
  }

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
  $scope.$on 'socket:room:enter:user', (ev, data) ->
    $scope.enterUsers.push data.userId
  $scope.$on 'socket:room:enter:users', (ev, data) ->
    $scope.enterUsers = data
  $scope.$on 'socket:room:leave:user', (ev, data) ->
    idx = $scope.enterUsers.indexOf data.userId
    if idx > -1
      $scope.enterUsers.splice idx, 1
  $scope.$on 'socket:room:sendLog', (ev, data) ->
    $scope.logs.push data

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