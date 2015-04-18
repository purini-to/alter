app = angular.module 'alter'

app.directive 'pageTitle', ($rootScope, $translate) =>
    return {
      restrict: 'A'
      link : (scope, element) =>
        listener = (event,  toState,  toParams,  fromState,  fromParams) =>
          setAppName = (translateValue) =>
            element.text translateValue
          $translate('NAME').then(setAppName)
          if toState.title?
            setPageTitle = (translateValue) =>
              element.text "#{translateValue} | #{element.text()}"
            $translate(toState.title).then(setPageTitle)

        $rootScope.$on '$stateChangeSuccess',  listener
    }
