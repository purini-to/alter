'use strict'
app = angular.module 'alter'

app.directive 'ngDownload', ($timeout) ->
  {
    restrict: 'A'
    link: (scope, element, attrs) ->
      downloadName = attrs.ngDownload
      if downloadName?
        $timeout ->
          element.attr 'download', downloadName
  }
