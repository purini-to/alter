app = angular.module 'alter'

app.factory 'socketUtil', (socketFactory, roomModel) ->
  socket = io()
  sio = socketFactory {
    ioSocket: socket
  }
