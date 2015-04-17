app = angular.module 'alter'

app.controller 'loginCtrl', ($scope, userService, userModel) =>
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
