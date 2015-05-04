###
アプリケーションのAngularJS依存関係設定
###
angular.module 'alter', ['ui.router', 'ngMaterial', 'ngMessages', 'ngResource', 'ngCookies', 'angular-loading-bar', 'pascalprecht.translate', 'alAngularHero', 'ngMdIcons', 'btford.socket-io', 'monospaced.elastic']
  .constant 'AUTH_EVENTS',
    loginSuccess: 'auth-login-success'
    loginFailed: 'auth-login-failed'
    logoutSuccess: 'auth-logout-success'
    sessionTimeout: 'auth-session-timeout'
    notAuthenticated: 'auth-not-authenticated'
    notAuthorized: 'auth-not-authorized'
  .run ($rootScope, $state, AUTH_EVENTS, userService) ->
    $rootScope.$on '$stateChangeStart', (event, next) ->
      isAuth = next.auth
      if isAuth? and isAuth is true
        if userService.isLogged() is false
          event.preventDefault()
          $state.go 'login'
