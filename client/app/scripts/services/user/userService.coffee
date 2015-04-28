app = angular.module 'alter'

app.factory 'userService', ($resource, sessionService) ->
  user = {}

  user.login =  ->
    url = '/api/users/login'
    defaultParams = {}
    actions = {}

    $resource url, defaultParams, actions

  user.save =  ->
    url = '/api/users'
    defaultParams = {}
    actions = {}

    $resource url, defaultParams, actions

  user.isLogged = ->
    sessionUser = sessionService.get 'user'
    sessionUser.id?.trim() isnt ''

  user
