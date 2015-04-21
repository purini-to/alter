app = angular.module 'alter'

###
アプリケーション内でのルーティング設定
###
app.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/login'
  $stateProvider.state 'login',
      url: "/login"
      templateUrl: "views/login/login.html"
      controller: "loginCtrl"
      title: "LOGIN.TITLE"
