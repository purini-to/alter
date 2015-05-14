app = angular.module 'alter'

app.factory 'userModel', () ->
  service = {}
  user = {
    _id: ''
    id: ''
    name: ''
    email: ''
    favoriteRooms: []
    avator: {}
  }

  service.set = (_id, id = '', name = '', email = '', favoriteRooms = [], avator = {}) ->
    user._id = _id
    user.id = id
    user.name = name
    user.email = email
    user.favoriteRooms = favoriteRooms
    user.avator = avator
    user

  service.indexOfFavoriteRoom = (roomId) ->
    user.favoriteRooms.indexOf roomId

  service.isFavoriteRoom = (roomId) ->
    idx = service.indexOfFavoriteRoom roomId
    idx > -1

  service.user = user

  service
