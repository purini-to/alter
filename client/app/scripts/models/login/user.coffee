app = angular.module 'alter'

app.factory 'userModel', () ->
  service = {}
  service.user = {}

  service.clear = ->
    service.user = {
      _id: ''
      id: ''
      name: ''
      email: ''
      favoriteRooms: []
      avator: {}
    }

  service.set = (_id, id = '', name = '', email = '', favoriteRooms = [], avator = {}) ->
    service.user._id = _id
    service.user.id = id
    service.user.name = name
    service.user.email = email
    service.user.favoriteRooms = favoriteRooms
    service.user.avator = avator
    service.user

  service.indexOfFavoriteRoom = (roomId) ->
    service.user.favoriteRooms.indexOf roomId

  service.isFavoriteRoom = (roomId) ->
    idx = service.indexOfFavoriteRoom roomId
    idx > -1

  service.clear()

  service
