app = angular.module 'alter'

app.factory 'roomService', ($resource, userModel) ->
  room = {}

  room.get = (roomId) ->
    if roomId?
      url = '/api/chat/rooms/:roomId'
      defaultParams = {roomId: '@roomId'}
    else
      url = '/api/chat/rooms'
      defaultParams = {}
    actions = {}

    $resource url, defaultParams, actions
      .query {userId: userModel.user._id}
      .$promise

  room.add = (params) ->
    url = '/api/chat/rooms'
    defaultParams = {}
    actions = {}

    $resource url, defaultParams, actions
      .save params
      .$promise

  room
