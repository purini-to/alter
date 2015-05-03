app = angular.module 'alter'

app.factory 'roomModel', ->
  service = {}
  activeRoom = {
    _id: ''
    name: ''
    description: ''
    activeUser: []
  }

  service.setActiveRoom = (_id, name, description = '') ->
    activeRoom._id = _id
    activeRoom.name = name
    activeRoom.description = description

  service.activeRoom = activeRoom

  service
