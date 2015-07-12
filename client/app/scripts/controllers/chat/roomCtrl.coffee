app = angular.module 'alter'

app.controller 'roomCtrl', ($scope, $mdDialog, $state, $q, socketUtil, stateService, roomService, userService, notifyService, userModel, roomModel, topNavModel, rooms) ->
  notifyService.requestPermission()
  $scope.rooms = rooms
  # 入室ルームの初期化
  roomModel.setActiveRoom '', ''

  $scope.$on 'event:addedRoom', (event, args) ->
    $scope.rooms.unshift args.room

  $scope.getFavoriteColor = (index) ->
    room = $scope.rooms[index]
    favorited = userModel.isFavoriteRoom room._id
    if favorited is true
      '#F06292'
    else
      '#90A4AE'

  $scope.toggleFavorite = (event, index) ->
    room = $scope.rooms[index]
    idx = userModel.indexOfFavoriteRoom room._id
    if idx > -1
      userService.removeFavoriteRoom room, idx
    else
      userService.addFavoriteRoom room

  $scope.inRoom = (event, index) ->
    room = $scope.rooms[index]
    roomModel.setActiveRoom room._id, room.name, room.description, room.users
    stateService.go 'chat.chatLog', {roomId: room._id}

  $scope.showNewRoomDialog = (ev) ->
    $mdDialog.show({
      controller: "newRoomCtrl"
      templateUrl: 'views/chat/newRoom.html'
      targetEvent: ev
    })

  $scope.$on 'socket:room:add', (ev, data) ->
    if data.room?
      $scope.rooms.unshift data.room

  $scope.$on 'socket:room:delete', (ev, data) ->
    if data.room._id?
      room = data.room
      roomId = room._id
      idx = userModel.indexOfFavoriteRoom roomId
      if idx > -1
        userService.removeFavoriteRoom room, idx
      else if room.isPrivate
        topNavModel.removeToggleInMenu 'プライベート', room.name
      _.remove $scope.rooms, (room) ->
        room._id is roomId

  socketUtil.forward 'room:add', $scope
  socketUtil.forward 'room:delete', $scope
