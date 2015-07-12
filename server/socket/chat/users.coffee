'use strict'

mongoose = require 'mongoose'
User = mongoose.model 'User'
socketUtil = require '../../utils/socketUtil'
userInfo = require '../store/userInfo'

module.exports = (io, socket) ->
  # ユーザーの一覧を取得する
  socket.on "user:get", ->
    User.loads()
      .then (users) ->
        if users?.length > 0
          socket.emit 'user:get', users: users
      .onReject (err) ->
        console.log err
