app = angular.module 'alter'

###
ページごとのタイトルを設定するディレクティブ
###
app.directive 'pageTitle', ($rootScope, $translate, $state, stateUtil) ->
  return {
    restrict: 'A'
    link : (scope, element) ->
      listener = (event,  toState,  toParams,  fromState,  fromParams) ->
        parentsState = stateUtil.getCurrentParentsState(true)
        setAppName = (translateValue) ->
          element.text translateValue
        $translate('NAME').then(setAppName)
        for s in parentsState
          if s.title?
            setPageTitle = (translateValue) ->
              element.text "#{translateValue} | #{element.text()}"
            $translate(s.title).then(setPageTitle)

      scope.$on '$stateChangeSuccess',  listener
  }
