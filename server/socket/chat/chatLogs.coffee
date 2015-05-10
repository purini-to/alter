'use strict'

mongoose = require 'mongoose'
User = mongoose.model 'User'
ChatLog = mongoose.model 'ChatLog'
Room = mongoose.model 'Room'
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

findOneRoom = (roomId) ->
  Room.load {_id: roomId}
    .then (rooms) ->
      room = null
      if rooms.length > 0
        room = rooms[0]
      room

isAdminRoom = (room, userId) ->
  adminUsers = room.users.filter (val) ->
    val.isAdmin
  .map (val) ->
    String(val.user)
  adminUsers.indexOf(userId) > -1

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

  socket.on "room:update:info", (data) ->
    _id = data._id
    name = data.name
    description = data.description
    if _id? and name? and description?
      findOneRoom _id
        .then (room) ->
          if room?
            room.name = name
            room.description = description
            room = room.save()
          room
        .then (room) ->
          socket.broadcast.to(_id).emit 'room:update:info', room

  socket.on "room:delete", (data) ->
    roomId = data._id
    userId = socketUtil.getUserId socket
    findOneRoom roomId
      .then (room) ->
        if room? and isAdminRoom(room, userId)
          room = room.remove()
        room
      .then (room) ->
        if room?
          io.sockets.to(roomId).emit 'room:delete', {roomId: roomId}
      .onReject (err) ->
        console.log err
