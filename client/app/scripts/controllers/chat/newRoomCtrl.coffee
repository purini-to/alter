app = angular.module 'alter'

app.controller 'newRoomCtrl', ($scope, $mdDialog, userModel, roomService) ->
  $scope.room = {
    name: ''
    discription: ''
  }

  $scope.hide = ->
    $mdDialog.hide()

  $scope.cancel = ->
    $mdDialog.cancel()

  $scope.submit = (ev) ->
