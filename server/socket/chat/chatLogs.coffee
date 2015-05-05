'use strict'

mongoose = require 'mongoose'
User = mongoose.model 'User'
ChatLog = mongoose.model 'ChatLog'
socketUtil = require '../../utils/socketUtil'
userInfo = require '../store/userInfo'

loadUser = (criteria, isArray = false) ->
  options = {
    criteria: criteria
  }
  if isArray is true
    User.loads options
  else
    User.load options

emitEnterUsers = (socket, roomId) ->
  users = userInfo.getRoomUser socket, roomId
  loadUser {_id: {$in: users}}, true
    .then (users) ->
      if users? and users.length > 0
        socket.emit 'room:enter:users', users
    .onReject (err) ->
      console.log err

broadcastEnterUser = (socket, roomId, userId) ->
  loadUser {_id: userId}
    .then (user) ->
      if user?
        socket.broadcast.to(roomId).emit 'room:enter:user', user
    .onReject (err) ->
      console.log err

module.exports = (io, socket) ->
  roomId = null
  socket.on "room:enter", (data) ->
    roomId = data._id
    socket.join roomId
    ChatLog.load {room: data}
      .then (logs) ->
        socket.emit 'room:enter:logs', logs
    userId = socketUtil.getUserId socket
    emitEnterUsers socket, roomId
    broadcastEnterUser socket, roomId, userId

  socket.on "room:leave", (data) ->
    roomId = data._id
    socket.leave roomId
    userId = socketUtil.getUserId socket
    socket.broadcast.to(roomId).emit 'room:leave:user', {userId: userId}
    roomId = null

  socket.on "disconnect", ->
    if roomId?
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
