app = angular.module 'alter'

###
# サムネイルをクリック時にオリジナル画像をポップアップするディレクティブ
###
app.directive 'alThumnailPopUp', ($timeout, $mdDialog, showOriginalImageModel)->
  return {
    restrict: 'A'
    link : (scope, element, attrs) ->
      if attrs.src?
        element.bind 'click', (ev) ->
          showOriginalImageModel.originalSrc = element.attr 'src'
          showOriginalImageModel.thumbnailElement = element
          $mdDialog.show({
            controller: "showOriginalImageCtrl"
            templateUrl: 'views/directives/showOriginalImage.html'
            targetEvent: ev
          })
  }

app.controller 'showOriginalImageCtrl', ($scope, $mdDialog, showOriginalImageModel) ->
  $scope.originalSrc = showOriginalImageModel.originalSrc
  $scope.hide = ->
    $mdDialog.hide()

app.factory 'showOriginalImageModel', ->
  models =
    originalSrc: ''
    thumbnailElement: null

  models
