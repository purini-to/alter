app = angular.module 'alter'

app.controller 'newRoomCtrl', ($rootScope, $scope, $mdDialog, socketUtil, userModel, roomService, topNavModel) ->
  $scope.room = {
    name: ''
    description: ''
    users: [{
      user: userModel.user._id
      isAdmin: true
    }]
    isPrivate: false
  }
  $scope.invitations = []
  $scope.allUser = []

  # ユーザー一覧取得要求
  socketUtil.emit 'user:get'
  # ユーザー一覧から自分以外をフィルタリングしてスコープに格納
  $scope.$on 'socket:user:get', (event, data) ->
    if data.users? and data.users.length > 0
      $scope.allUser = data.users.filter (user) ->
        user._id isnt userModel.user._id
      .map (user) ->
        user._lowerName = user.name.toLowerCase()
        user._path = user.avator.path
        user.avator
        user
  socketUtil.forward 'user:get', $scope

  # ユーザー名でフィルタリングを行う
  createFilterForName = (queryStr) ->
    lowercaseQuery = angular.lowercase(queryStr)
    (user) ->
      user._lowerName.indexOf(lowercaseQuery) > -1
  # 入力された名前から対象ユーザーをフィルタリングする
  $scope.querySearch = (queryStr) ->
    result = if queryStr?.trim() then $scope.allUser.filter(createFilterForName(queryStr)) else []
    result

  $scope.hide = ->
    $mdDialog.hide()

  $scope.cancel = ->
    $mdDialog.cancel()

  # プライベートルームの場合は招待ユーザーを登録する
  registInvitations = (invitations, room) ->
    socketUtil.emit 'room:regist:invitations', {room: room, invitations: invitations}
    topNavModel.addToggleInMenu 'プライベート', room.name, "chat.chatLog({roomId:'#{room._id}'})"
  $scope.submit = (ev) ->
    roomService.add $scope.room
      .then (room) ->
        room.users = $scope.room.users
        if room.isPrivate
          registInvitations $scope.invitations, room
        else
          socketUtil.emit 'room:add', room: room
        $mdDialog.hide()
      .catch (err) ->
        console.log error
        alert "エラーが発生しました\n管理者に問い合わせてください"

