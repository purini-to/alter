app = angular.module 'alter'

###
コンテンツごとのタイトルを設定するディレクティブ
###
app.directive 'contentTitle', ($rootScope, $translate, $state, stateUtil) ->
  return {
    restrict: 'A'
    link : (scope, element) ->
      listener = (event,  toState,  toParams,  fromState,  fromParams) ->
        element.html ''
        parentsState = stateUtil.getCurrentParentsState()
        for s in parentsState
          if s.title?
            setPageTitle = (translateValue) ->
              element.html "#{translateValue} <i class=\"fa fa-angle-right fa-lg title-separator\"></i> #{element.text()}"

            $translate(s.title).then(setPageTitle)

      scope.$on '$stateChangeSuccess',  listener
  }
