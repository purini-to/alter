app = angular.module 'alter'

app.factory 'roomService', ($resource, userModel) ->
  room = {}

  room.get = (roomId) ->
    actions = {}
    if roomId?
      url = '/api/chat/rooms/:roomId'
      defaultParams = {roomId: roomId}
      $resource url, defaultParams, actions
        .get {userId: userModel.user._id}
        .$promise
    else
      url = '/api/chat/rooms'
      defaultParams = {}
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

  room.remove = (roomId, userId) ->
    url = '/api/chat/rooms/:roomId'
    defaultParams = {roomId: roomId}
    actions = {}

    $resource url, defaultParams, actions
      .delete {userId: userId}
      .$promise

  room.in = (roomId, params) ->
    url = '/api/chat/rooms/:roomId'
    defaultParams = {roomId: roomId}
    actions = {}

    $resource url, defaultParams, actions
      .save params
      .$promise

  room
