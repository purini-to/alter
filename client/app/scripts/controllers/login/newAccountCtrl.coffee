app = angular.module 'alter'

app.controller 'newAccountCtrl', ($scope, $mdDialog) =>
  $scope.user = {
    id: ''
    password: ''
    name: ''
  }

  $scope.hide = =>
    $mdDialog.hide()

  $scope.cancel = =>
    $mdDialog.cancel()

  $scope.submit = =>
    $mdDialog.cancel()
