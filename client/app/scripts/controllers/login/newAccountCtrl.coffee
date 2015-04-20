app = angular.module 'alter'

app.controller 'newAccountCtrl', ($scope, $mdDialog) =>
  $scope.user = {
    id: ''
    name: ''
    email: ''
    password: ''
  }

  $scope.hide = =>
    $mdDialog.hide()

  $scope.cancel = =>
    $mdDialog.cancel()

  $scope.submit = =>
    $mdDialog.cancel()
