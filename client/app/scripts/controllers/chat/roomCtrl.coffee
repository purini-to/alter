app = angular.module 'alter'

app.controller 'roomCtrl', ($scope, $mdDialog, $state, $q, roomService, userService, userModel, roomModel, topNavModel, rooms) ->
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
      userService.removeFavoriteRoom room, idx
    else
      userService.addFavoriteRoom room

  $scope.inRoom = (event, index) ->
    room = $scope.rooms[index]
    roomModel.setActiveRoom room._id, room.name, room.description
    $state.go 'chat.chatLog', {roomId: room._id}

  $scope.showNewRoomDialog = (ev) ->
    $mdDialog.show({
      controller: "newRoomCtrl"
      templateUrl: 'views/chat/newRoom.html'
      targetEvent: ev
    })
