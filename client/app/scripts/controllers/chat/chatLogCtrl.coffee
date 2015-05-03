app = angular.module 'alter'

app.controller 'chatLogCtrl', ($scope, $stateParams, roomModel) ->
  $scope.activeRoom = roomModel.activeRoom
