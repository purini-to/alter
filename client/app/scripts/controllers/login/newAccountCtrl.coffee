app = angular.module 'alter'

app.controller 'newAccountCtrl', ($scope, $mdDialog, userModel, userService) ->
  $scope.user = {
    id: ''
    name: ''
    email: ''
    password: ''
  }
  $scope.isExist = false

  $scope.validators = {
    password_confirm:
      confirm: (modelValue,  viewValue) ->
        user = $scope.user || {}
        val = modelValue || viewValue
        user.password is val
    id_exist:
      exist: (modelValue, viewValue) ->
        val = modelValue || viewValue
        $scope.isExist = if $scope.user.id is val then $scope.isExist else false
        !$scope.isExist
  }
  $scope.$watch 'isExist', ->
    $scope.newAccountForm.id.$validate()

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
      code = errorResult.status
      id = errorResult.data.id
      if code is 400 and id?
        $scope.isExist = true
      else
        console.log errorResult
        alert "エラーが発生しました\n管理者に問い合わせてください"
