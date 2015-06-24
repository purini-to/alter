app = angular.module 'alter'

###
TODO: いらないかも
コンテンツごとのタイトルを設定するディレクティブ
###
app.directive 'contentTitle', ($rootScope, $translate, $state, stateUtil) ->
  return {
    restrict: 'A'
    link : (scope, element) ->
      listener = (event,  toState,  toParams,  fromState,  fromParams) ->
        event.preventDefault()
        element.html ''
        if toParams.title?
          element.html "#{toParams.title}"
        else if toState.title?
          setPageTitle = (translateValue) ->
            element.html "#{translateValue}"

          $translate(toState.title).then(setPageTitle)

      scope.$on '$stateChangeSuccess',  listener
  }
