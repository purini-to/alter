app = angular.module 'alter'

###
ページごとのタイトルを設定するディレクティブ
###
app.directive 'myTopNav', ($rootScope, $translate) ->
  return {
    restrict: 'E'
    templateUrl:'views/directives/topNav.html'
    transclude: true
    controller:'topNavCtrl'
    scope:{}
  }

app.controller 'topNavCtrl', ($rootScope, $scope, $mdSidenav, $state, $mdDialog, sessionService, socketUtil, notifyService, topNavModel, userModel) ->
  $scope.user = userModel.user
  $scope.isOpenProfileMenu = false
  $scope.profileIcon = 'expand_more'
  $scope.staticMenus = topNavModel.staticMenus
  $scope.dynamicMenus = topNavModel.dynamicMenus
  $scope.isLink = (menu) ->
    menu.type is 'link'
  $scope.isToggleMenu = (menu) ->
    menu.type is 'toggle' and menu.items.length > 0
  $scope.setIcon = (menu) ->
    if menu.opened
      menu.iconOpen
    else
      menu.iconClose
  $scope.toggleMenu = (ev, menu) ->
    menu.opened = !menu.opened
  $scope.toggleProfileMenu = (ev) ->
    $scope.isOpenProfileMenu = !$scope.isOpenProfileMenu
    $scope.profileIcon = if $scope.isOpenProfileMenu then 'expand_less' else 'expand_more'
  $scope.close = ->
    $scope.isOpenProfileMenu = false
    $scope.profileIcon = 'expand_more'
    $mdSidenav('siteNav').close()
  $scope.logout = ->
    sessionService.destroy()
    socketUtil.removeAllListeners()
    $state.go 'login'

  $scope.showProfileDialog = (ev) ->
    $mdDialog.show({
      controller: "profileCtrl"
      templateUrl: 'views/chat/profile.html'
      targetEvent: ev
    })

  $rootScope.sideNavToggle = ->
    $mdSidenav('siteNav').toggle()

  # プライベートルームへの招待を受信する
  $scope.$on 'socket:room:notify:invitations', (event, data) ->
    if data.room?
      room = data.room
      topNavModel.addToggleInMenu 'プライベート', room.name, "chat.chatLog({roomId:'#{room._id}'})"
      notifyService.showPrivete room.name
  socketUtil.forward 'room:notify:invitations', $scope

  socketUtil.emit 'room:get:private'
  $scope.$on 'socket:room:get:private', (event, data) ->
    if data.rooms? and data.rooms.length > 0
      _.each data.rooms, (room) ->
        topNavModel.addToggleInMenu 'プライベート', room.name, "chat.chatLog({roomId:'#{room._id}'})"
  socketUtil.forward 'room:get:private', $scope

