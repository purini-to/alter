app = angular.module 'alter'

app.controller 'newAccountCtrl', ($scope, $mdDialog) =>
  $scope.user = {
    id: ''
    name: ''
    email: ''
    password: ''
    conf: ''
  }

  $scope.validators = {
    password_confirm:
      confirm: (modelValue,  viewValue) =>
        user = $scope.user || {}
        val = modelValue || viewValue
        user.password is val
  }

  $scope.hide = =>
    $mdDialog.hide()

  $scope.cancel = =>
    $mdDialog.cancel()

  $scope.submit = =>
    $mdDialog.cancel()
