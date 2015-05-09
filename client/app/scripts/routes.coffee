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
  .state 'chat',
      templateUrl: "views/main.html"
      title: "CHAT.TITLE"
  .state 'chat.room',
      url: "/chat/room"
      templateUrl: "views/chat/room.html"
      controller: "roomCtrl"
      resolve: {
        rooms: (roomService) ->
          roomService.get()
      }
      title: "CHAT.ROOM.TITLE"
      auth: true
  .state 'chat.chatLog',
      url: "/chat/room/{roomId}"
      templateUrl: "views/chat/chatLog.html"
      controller: "chatLogCtrl"
      resolve: {
        activeRoom: ($stateParams, roomService, roomModel) ->
          roomId = $stateParams.roomId
          if roomModel.activeRoom._id is '' or roomModel.activeRoom._id isnt roomId
            roomService.get roomId
              .then (result) ->
                roomModel.setActiveRoom result._id, result.name, result.description, result.users
                result
      }
      title: "CHAT.CHAT-LOG.TITLE"
      auth: true
