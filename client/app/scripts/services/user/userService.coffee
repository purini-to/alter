app = angular.module 'alter'

app.factory 'userService', ($resource, sessionService) ->
  user = {}

  user.login =  (user) ->
    url = '/api/users/login'
    defaultParams = {}
    actions = {}

    $resource url, defaultParams, actions
      .save user
      .$promise
      .then (result) ->
        sessionService.create result
        result

  user.save = (user) ->
    url = '/api/users'
    defaultParams = {}
    actions = {}

    $resource url, defaultParams, actions
      .save user
      .$promise

  user.isLogged = ->
    sessionUser = sessionService.get 'user'
    sessionUser.id?.trim() isnt ''

  user
