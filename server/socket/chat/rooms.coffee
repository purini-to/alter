'use strict'

mongoose = require 'mongoose'
Room = mongoose.model 'Room'
Invitation = mongoose.model 'Invitation'
socketUtil = require '../../utils/socketUtil'
userInfo = require '../store/userInfo'

module.exports = (io, socket) ->
  socket.on "room:add", (room) ->
    io.sockets.emit 'room:add', room

  socket.on "room:regist:invitations", (data) ->
    if data.room? and data.invitations?
      room = data.room
      users = data.invitations.map (user) ->
        user: user
      entity = {
        users: users
        room: room
      }

      new Invitation(entity).save()
        .then (invitation) ->
          if invitation?
            socket.emit 'room:regist:invitations', invitation
        .onReject (err) ->
          console.log err
