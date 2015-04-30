app = angular.module 'alter'

app.controller 'roomCtrl', ($scope, roomService, rooms) ->
  $scope.rooms = rooms
