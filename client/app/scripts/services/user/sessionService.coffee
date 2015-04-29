app = angular.module 'alter'

app.factory 'sessionService', ($cookieStore, userModel) ->
  session = {}
  sessionData = {
    token: ''
  }

  session.create = (token, user) ->
    sessionData.token = token
    userModel.set user._id, user.id, user.name, user.email
    $cookieStore.put 'token', sessionData.token
    session

  session.destroy = ->
    sessionData.id = null
    userModel.set '', '', '', ''
    $cookieStore.remove 'token'
    session

  session.get = (name) ->
    if (name of sessionData) is false
      return null
    sessionData[name]

  session
