'use strict'

mongoose = require 'mongoose'
ChatLog = mongoose.model 'ChatLog'
socketUtil = require '../../utils/socketUtil'
userInfo = require '../store/userInfo'

module.exports = (io, socket) ->
  socket.on "room:enter", (data) ->
    roomId = data._id
    socket.join roomId
    ChatLog.load {room: data}
      .then (logs) ->
        socket.emit 'room:enter:logs', logs
    userId = socketUtil.getUserId socket
    socket.emit 'room:enter:users', userInfo.getRoomUser socket, roomId
    socket.broadcast.to(roomId).emit 'room:enter:user', {userId: userId}

  socket.on "room:leave", (data) ->
    roomId = data._id
    socket.leave roomId
    userId = socketUtil.getUserId socket
    socket.broadcast.to(roomId).emit 'room:leave:user', {userId: userId}
    
  socket.on "room:sendLog", (data) ->
    roomId = data.room._id
    log = new ChatLog(data)
    log.save()
      .then (log) ->
        io.sockets.to(roomId).emit 'room:sendLog', data
      .onReject (err) ->
        console.log err
