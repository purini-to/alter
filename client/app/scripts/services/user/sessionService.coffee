app = angular.module 'alter'

app.factory 'sessionService', ($cookieStore, $cookies, userModel) ->
  session = {}

  session.create = (token, user) ->
    userModel.set user._id, user.id, user.name, user.email
    $cookieStore.put 'token', token
    $cookieStore.put 'userId', userModel.user._id
    session

  session.destroy = ->
    userModel.set '', '', '', ''
    $cookieStore.remove 'token'
    $cookieStore.remove 'userId'
    session

  session.get = (name) ->
    if (name of $cookies) is false
      return null
    $cookieStore.get name

  session
