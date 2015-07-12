'use strict'

_ = require 'lodash'

mongoose = require 'mongoose'
Room = mongoose.model 'Room'
Invitation = mongoose.model 'Invitation'
socketUtil = require '../../utils/socketUtil'
userInfo = require '../store/userInfo'

invitationUserEmit = (socket, users, room) ->
  userIdList = _.map _.pluck(users, 'user'), (item) ->
    item.toString()
  targetSockets = userInfo.getUserSockets userIdList
  _.each targetSockets, (socketId) ->
    socket.to(socketId).emit 'room:notify:invitations', room: room

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
            # socket.broadcast.emit 'room:notify:invitations', room: room
            invitationUserEmit socket, invitation.users, room
        .onReject (err) ->
          console.log err
