app = angular.module 'alter'

app.factory 'userModel', ->
  service = {}
  user = {
    _id: ''
    id: ''
    name: ''
    email: ''
  }

  service.set = (_id, id, name, email = '') ->
    user._id = _id
    user.id = id
    user.name = name
    user.email = email

  service
