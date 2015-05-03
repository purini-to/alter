app = angular.module 'alter'

app.controller 'roomCtrl', ($scope, $mdDialog, roomService, rooms, userModel) ->
  $scope.rooms = rooms

  $scope.$on 'event:addedRoom', (event, args) ->
    $scope.rooms.unshift args.room

  $scope.getFavoriteColor = (room) ->
    favorited = userModel.isFavoriteRoom room._id
    if favorited is true
      '#F06292'
    else
      '#90A4AE'

  $scope.toggleFavorite = (event, room) ->
    idx = userModel.indexOfFavoriteRoom room._id
    if idx > -1
      userModel.favoriteRooms.splice idx, 1
    else
      userModel.favoriteRooms.push room._id


  $scope.showDetailRoom = (event) ->
    test = $mdDialog.alert()
      .title('Navigating')
      .content('Inspect')
      .ariaLabel('Person inspect demo')
      .ok('Neat!')
      .targetEvent(event)
    $mdDialog.show test

  $scope.showNewRoomDialog = (ev) ->
    $mdDialog.show({
      controller: "newRoomCtrl"
      templateUrl: 'views/chat/newRoom.html'
      targetEvent: ev
    })
