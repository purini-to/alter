app = angular.module 'alter'

app.controller 'profileCtrl', ($rootScope, $scope, $mdDialog, $mdMedia, $timeout, Upload, userModel, roomService) ->
  $scope.user = userModel.user
  $scope.avator = null
  $scope.avatorPre = null
  $scope.screenIsOverlap = ->
    $mdMedia('md') || $mdMedia('sm')

  $scope.hide = ->
    $mdDialog.hide()

  $scope.cancel = ->
    $mdDialog.cancel()

  $timeout ->
    angular.element('[ng-model="avator"]').bind 'paste', (ev) ->
      console.log "aaaaa"
      items = ev.originalEvent.clipboardData.items
      for item in items
        if item.type.indexOf("image") isnt -1
          file = item.getAsFile()
          reader = new FileReader()
          $timeout ->
            reader.onload = (ev) ->
              $scope.avatorPre = ev.target.result
            reader.readAsDataURL file
          $scope.avator = [file]
    angular.element('[ng-model="avator"]').bind 'focus', (ev) ->
      $timeout ->
        $scope.avator = null
        $scope.avatorPre = null
