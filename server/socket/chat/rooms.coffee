'use strict'

mongoose = require 'mongoose'
Room = mongoose.model 'Room'
socketUtil = require '../../utils/socketUtil'
userInfo = require '../store/userInfo'

module.exports = (io, socket) ->
  socket.on "room:add", (room) ->
    io.sockets.emit 'room:add', room
