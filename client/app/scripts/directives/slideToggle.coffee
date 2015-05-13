'use strict'
app = angular.module 'alter'

app.directive 'slideToggle', ->
  {
    restrict: 'A'
    scope: {
      isOpen: "=slideToggle"
      startShown: "@"
    }
    link: (scope, element, attrs) ->
      isShown = if scope.startShown is 'false' then false else Boolean(scope.startShown)
      if isShown is false
        element.hide()

      duration = parseInt(attrs.slideToggleDuration,  10)
      slideDuration = duration || 400
      scope.$watch 'isOpen', (newVal, oldVal) ->
        if newVal isnt oldVal
          element.stop().slideToggle(slideDuration)
  }
