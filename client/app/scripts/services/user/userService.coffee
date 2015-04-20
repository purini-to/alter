app = angular.module 'alter'

app.factory 'userService', ($resource) =>
  user = {}

  user.login =  =>
    url = '/api/users/login'
    defaultParams = {}
    actions = {}

    $resource url, defaultParams, actions

  user.save =  =>
    url = '/api/users'
    defaultParams = {}
    actions = {}

    $resource url, defaultParams, actions

  user
