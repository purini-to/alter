'use strict'
app = angular.module 'alter'

app.directive 'ngEnter', ->
  {
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.bind "keydown keypress", (event) ->
        if event.which is 13
          scope.$apply ->
            scope.$eval attrs.ngEnter, {'event': event}
          event.preventDefault()
  }
