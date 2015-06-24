app = angular.module 'alter'

app.factory 'stateService', ($state, $stateParams, $rootScope) ->
  service = {}

  service.go = (state,  params,  options) ->
    destroyListener = $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      $.extend(true, toParams, params)
      destroyListener()

    $state.go state, params, options

  service
