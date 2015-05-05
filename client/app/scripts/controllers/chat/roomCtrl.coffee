app = angular.module 'alter'

app.controller 'roomCtrl', ($scope, $mdDialog, $state, $q, roomService, userModel, roomModel, topNavModel, rooms) ->
  $scope.rooms = rooms

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
      userModel.favoriteRooms.splice idx, 1
      topNavModel.removeToggleInMenu 'お気に入り', room.name
    else
      userModel.favoriteRooms.push room._id
      topNavModel.addToggleInMenu 'お気に入り', room.name, "chat.chatLog({roomId:'#{room._id}'})"

  $scope.inRoom = (event, index) ->
    room = $scope.rooms[index]
    isExist = false
    for user in room.users
      if user.user._id is userModel.user._id
        isExist = true
        break
    d = $q.defer()
    if isExist is true
      d.resolve room
    else 
      roomService.in room._id, {userId:userModel.user._id}
        .then (result) ->
          d.resolve room
    d.promise
      .then (result) ->
        roomModel.setActiveRoom result._id, result.name, result.description
        $state.go 'chat.chatLog', {roomId: result._id}


  $scope.showNewRoomDialog = (ev) ->
    $mdDialog.show({
      controller: "newRoomCtrl"
      templateUrl: 'views/chat/newRoom.html'
      targetEvent: ev
    })
