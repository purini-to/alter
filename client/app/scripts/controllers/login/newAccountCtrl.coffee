app = angular.module 'alter'

app.controller 'newAccountCtrl', ($scope, $mdDialog, userModel, userService) ->
  $scope.user = {
    id: ''
    name: ''
    email: ''
    password: ''
  }
  $scope.isSuccess = false

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

  $scope.submit = (ev) ->
    user = userService.save()
    user.save $scope.user, (successResult) ->
      $mdDialog.show({
        controller: "newAccountSuccessCtrl"
        templateUrl: 'views/login/newAccountSuccess.html'
        targetEvent: ev 
      })
    , (errorResult) ->
      console.log errorResult
