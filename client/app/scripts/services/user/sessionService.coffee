app = angular.module 'alter'

app.factory 'sessionService', (userModel) ->
  session = {}
  sessionData = {
    user:
      id: ''
  }

  session.create = (user) ->
    sessionData.user.id = user._id
    userModel.set user._id, user.id, user.name, user.email
    session

  session.destroy = ->
    sessionData.id = null
    userModel.set '', '', '', ''
    session

  session.get = (name) ->
    if (name of sessionData) is false
      return null
    sessionData[name]

  session
