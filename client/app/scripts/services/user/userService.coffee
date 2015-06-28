app = angular.module 'alter'

app.factory 'userService', ($resource, $state, sessionService, userModel, topNavModel) ->
  user = {}

  user.login =  (user) ->
    url = '/api/users/login'
    defaultParams = {}
    actions = {}

    $resource url, defaultParams, actions
      .save user
      .$promise
      .then (result) ->
        token = result.token
        user = result.user
        sessionService.create token, user
        user

  user.save = (user) ->
    url = '/api/users'
    defaultParams = {}
    actions = {}

    $resource url, defaultParams, actions
      .save user
      .$promise

  user.update = (user) ->
    url = '/api/users/:userId'
    defaultParams = {userId: user._id}
    actions = {}

    $resource url, defaultParams, actions
      .save user
      .$promise
        
  user.loadByToken = (token) ->
    url = '/api/users/token'
    defaultParams = {}
    actions = {}

    $resource url, defaultParams, actions
      .save {token: token}
      .$promise
      .then (user) ->
        if user?
          sessionService.create token, user
        else
          sessionService.destroy()
          $state.go 'login'
        user
      .catch (err) ->
        console.log err
        sessionService.destroy()
        $state.go 'login'

  user.isLogged = ->
    token = sessionService.get 'token'
    logged = token?
    if logged is true and userModel.user._id.trim() is ''
      userModel.set sessionService.get 'userId'
      user.loadByToken token
    logged

  user.addFavoriteRoom = (room) ->
    url = '/api/users/addFavoriteRoom/:userId'
    defaultParams = {userId: userModel.user._id}
    actions = {}

    $resource url, defaultParams, actions
      .save room
      .$promise
      .then (user) ->
        userModel.user.favoriteRooms.push room._id
        topNavModel.addToggleInMenu 'お気に入り', room.name, "chat.chatLog({roomId:'#{room._id}'})"

  user.removeFavoriteRoom = (room, idx) ->
    url = '/api/users/removeFavoriteRoom/:userId'
    defaultParams = {userId: userModel.user._id}
    actions = {}

    $resource url, defaultParams, actions
      .save room
      .$promise
      .then (user) ->
        userModel.user.favoriteRooms.splice idx, 1
        topNavModel.removeToggleInMenu 'お気に入り', room.name

  user
