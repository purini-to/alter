app = angular.module 'alter'

app.factory 'roomModel', ->
  service = {}
  activeRoom = {
    _id: ''
    name: ''
    description: ''
    users: []
  }

  service.setActiveRoom = (_id, name, description = '', users = []) ->
    activeRoom._id = _id
    activeRoom.name = name
    activeRoom.description = description
    activeRoom.users = users

  service.activeRoom = activeRoom

  service
