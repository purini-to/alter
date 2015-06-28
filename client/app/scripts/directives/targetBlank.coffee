'use strict'
app = angular.module 'alter'

app.directive 'targetBlank', ->
  {
    restrict: 'A'
    link: (scope,  element,  attr) ->
      if element.prop("tagName") is 'A'
        element.attr "target", "_blank"
      else
        elems = element.find('A')
        element.bind 'DOMSubtreeModified', ->
          elems = angular.element(this).find('A')
          elems.attr "target", "_blank"
  }
