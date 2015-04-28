app = angular.module 'alter'

app.controller 'loginCtrl', ($rootScope, $scope, $state, $mdDialog, AUTH_EVENTS, userService, sessionService) ->
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
    user.save $scope.user, (successResult) ->
      sessionService.create successResult
      $rootScope.$broadcast AUTH_EVENTS.loginSuccess
      $state.go 'chat.room'
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
