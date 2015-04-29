app = angular.module 'alter'

app.factory 'sessionService', ($cookieStore, userModel) ->
  session = {}
  sessionData = {
    user:
      id: ''
  }

  session.create = (user) ->
    sessionData.user.id = user._id
    userModel.set user._id, user.id, user.name, user.email
    $cookieStore.put 'user', sessionData.user
    session

  session.destroy = ->
    sessionData.id = null
    userModel.set '', '', '', ''
    $cookieStore.remove 'user'
    session

  session.get = (name) ->
    if (name of sessionData) is false
      return null
    sessionData[name]

  session
