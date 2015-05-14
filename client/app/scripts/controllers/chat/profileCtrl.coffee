app = angular.module 'alter'

app.controller 'profileCtrl', ($rootScope, $scope, $mdDialog, $mdMedia, $timeout, Upload, userModel, roomService) ->
  $scope.user = userModel.user
  $scope.avator = null
  $scope.originalAvator = null
  $scope.screenIsOverlap = ->
    $mdMedia('md') || $mdMedia('sm')

  $scope.hide = ->
    $mdDialog.hide()

  $scope.cancel = ->
    $mdDialog.cancel()
