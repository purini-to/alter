app = angular.module 'alter'

app.controller 'newAccountCtrl', ($scope, $mdDialog, userModel, userService) ->
  $scope.user = {
    id: ''
    name: ''
    email: ''
    password: ''
  }
  $scope.conf = ''

  $scope.validators = {
    password_confirm:
      confirm: (modelValue,  viewValue) ->
        user = $scope.user || {}
        val = modelValue || viewValue
        user.password is val
  }

  $scope.hide = ->
    $mdDialog.hide()

  $scope.cancel = ->
    $mdDialog.cancel()

  $scope.submit = ->
    user = userService.save()
    aa = user.save $scope.user, (successResult) ->
      console.log aa
    , (errorResult) ->
      console.log errorResult
