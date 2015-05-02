app = angular.module 'alter'

app.controller 'roomCtrl', ($scope, $mdDialog, roomService, rooms) ->
  $scope.rooms = rooms

  $scope.$on 'event:addedRoom', (event, args) ->
    $scope.rooms.unshift args.room

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
