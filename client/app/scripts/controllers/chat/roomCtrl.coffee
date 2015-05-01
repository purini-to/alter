app = angular.module 'alter'

app.controller 'roomCtrl', ($scope, $mdDialog, roomService, rooms) ->
  $scope.rooms = rooms

  $scope.showNewRoomDialog = (ev) ->
    $mdDialog.show({
      controller: "newRoomCtrl"
      templateUrl: 'views/chat/newRoom.html'
      targetEvent: ev
    })
