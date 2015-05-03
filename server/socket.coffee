'use strict'

socketio = require 'socket.io'
socketUtil = require './utils/socketUtil'
userInfo = require './socket/store/userInfo'

sio = (server) ->
  io = socketio.listen server

  io.sockets.on 'connection', (socket) ->
    userId = socketUtil.getUserId socket
    userInfo.addUser userId, {
      socketId: socket.id
    }
    console.log "Socket Connected {userId:#{userId}}"

    require('./socket/chat/chatLogs')(io, socket)

    socket.on "disconnect", ->
      userInfo.removeUser userId
      console.log "Socket Disconnected {userId:#{userId}}"

module.exports = sio
