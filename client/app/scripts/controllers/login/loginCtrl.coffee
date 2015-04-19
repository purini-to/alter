app = angular.module 'alter'

app.controller 'loginCtrl', ($scope, $mdDialog, userService, userModel) =>
  $scope.user = {
    id: ''
    password: ''
  }

  $scope.submit = =>
    user = userService.login()
    aa = user.save $scope.user, (successResult) =>
      console.log aa
    , (errorResult) =>
      console.log errorResult

  $scope.showNewAccountDialog = (ev) =>
    $mdDialog.show({
      controller: "newAccountCtrl"
      templateUrl: 'views/login/newAccount.html'
      targetEvent: ev 
    })
