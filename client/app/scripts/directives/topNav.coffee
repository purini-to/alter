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

app.controller 'topNavCtrl', ($rootScope, $scope, $mdSidenav) ->
  $rootScope.sideNavToggle = ->
    $mdSidenav('siteNav').toggle()
