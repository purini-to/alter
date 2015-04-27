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
  .state 'room',
      url: "/chat/room"
      templateUrl: "views/chat/room.html"
      # controller: "loginCtrl"
      title: "LOGIN.TITLE"
