app = angular.module 'alter'

###
ページごとのタイトルを設定するディレクティブ
###
app.directive 'myTopNav', ($rootScope, $translate) ->
  return {
    restrict: 'E'
    templateUrl:'views/directives/top-nav.tpl.html'
    replace: true
    transclude: true
    controller:'topNavCtrl'
    controllerAs:'vm'
    scope:{}
  }

app.controller 'topNavCtrl', ->
  vm = this

  vm.collased = true
