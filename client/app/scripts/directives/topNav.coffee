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

app.controller 'topNavCtrl', ($rootScope, $scope, $mdSidenav, $state, sessionService, topNavModel, userModel) ->
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
    $state.go 'login'

  $rootScope.sideNavToggle = ->
    $mdSidenav('siteNav').toggle()
