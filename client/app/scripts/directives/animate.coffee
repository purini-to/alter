app = angular.module 'alter'

###
アニメーションを動作させるディレクティブ
###
app.directive 'animate', ($timeout)->
  return {
    restrict: 'A'
    link : (scope, element) ->
      element.addClass 'anim'
      $timeout ->
        element.removeClass 'anim'
      , 1000
  }
