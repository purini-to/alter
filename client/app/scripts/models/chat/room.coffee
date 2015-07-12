app = angular.module 'alter'

app.factory 'roomModel', ->
  service = {}
  service.activeRoom = {}

  service.clear = ->
    service.activeRoom = {
      _id: ''
      name: ''
      description: ''
      users: []
    }

  service.setActiveRoom = (_id, name, description = '', users = []) ->
    service.activeRoom._id = _id
    service.activeRoom.name = name
    service.activeRoom.description = description
    service.activeRoom.users = users

  service.clear()

  service
