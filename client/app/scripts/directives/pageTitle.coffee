app = angular.module 'alter'

###
ページごとのタイトルを設定するディレクティブ
###
app.directive 'pageTitle', ($rootScope, $translate, $state) ->
  getParentsState = () ->
    result = []
    _state = $state.$current
    loop
      result.push _state.self
      _state = _state.parent
      break unless _state? and _state.parent?
    result.reverse()
  return {
    restrict: 'A'
    link : (scope, element) ->
      listener = (event,  toState,  toParams,  fromState,  fromParams) ->
        parentsState = getParentsState toState.name
        setAppName = (translateValue) ->
          element.text translateValue
        $translate('NAME').then(setAppName)
        for s in parentsState
          if s.title?
            setPageTitle = (translateValue) ->
              element.text "#{translateValue} | #{element.text()}"
            $translate(s.title).then(setPageTitle)

      $rootScope.$on '$stateChangeSuccess',  listener
  }
