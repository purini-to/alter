app = angular.module 'alter'

app.factory 'userService', ($resource, sessionService, userModel) ->
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

  user.isLogged = ->
    token = sessionService.get 'token'
    token?.trim() isnt ''

  user
