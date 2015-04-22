app = angular.module 'alter'

app.controller 'newAccountSuccessCtrl', ($scope, $mdDialog) ->
  $scope.hide = ->
    $mdDialog.hide()
