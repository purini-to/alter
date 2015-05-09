app = angular.module 'alter'

app.controller 'newRoomCtrl', ($rootScope, $scope, $mdDialog, userModel, roomService) ->
  $scope.room = {
    name: ''
    description: ''
    users: [{
      user: userModel.user._id
      isAdmin: true
    }]
  }

  $scope.hide = ->
    $mdDialog.hide()

  $scope.cancel = ->
    $mdDialog.cancel()

  $scope.submit = (ev) ->
    roomService.add $scope.room
      .then (room) ->
        room.users = $scope.room.users
        $rootScope.$broadcast 'event:addedRoom',  room: room
        $mdDialog.hide()
      .catch (err) ->
        console.log error
        alert "エラーが発生しました\n管理者に問い合わせてください"
