app = angular.module 'alter'

app.controller 'loginCtrl', ($scope, $mdDialog, userService, userModel) ->
  $scope.user = {
    id: ''
    password: ''
  }
  $scope.faiiled = false

  $scope.validators = {
    failledAuth:
      failledAuth: (modelValue, viewValue) ->
        val = modelValue || viewValue
        if $scope.faiiled and $scope.user.password isnt val
          $scope.faiiled = false
        !$scope.faiiled
  }

  $scope.submit = ->
    user = userService.login()
    aa = user.save $scope.user, (successResult) ->
      console.log aa
    , (errorResult) ->
      code = errorResult.status
      global = errorResult.data.global
      if code is 401 and global?
        $scope.user.password = ''
        $scope.faiiled = true
      else
        console.log errorResult
        alert "エラーが発生しました\n管理者に問い合わせてください"

  $scope.showNewAccountDialog = (ev) ->
    $mdDialog.show({
      controller: "newAccountCtrl"
      templateUrl: 'views/login/newAccount.html'
      targetEvent: ev
    })
