'use strict'
app = angular.module 'alter'

app.directive 'listActions', ->
  {
    restrict: 'E',
    controller: 'MdListController',
    link: ($scope, $element, $attr, ctrl) ->
      element = angular.element $element
      secondaryItem = element.children()
      parentList = element.closest 'md-list-item'

      parentList.append secondaryItem
      $element.remove()
  }
