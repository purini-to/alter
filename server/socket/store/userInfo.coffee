'use strict'

_ = require 'lodash'

store = {}
users = {}

store.addUser = (userId, data = {}) ->
  users[userId] = data
  store

store.updateUser = (userId, data = {}) ->
  origin = users[userId]
  users[userId] = _.merge origin, data
  store

store.removeUser = (userId) ->
  delete users[userId]
  store

store.getUser = (userId) ->
  users[userId]

store.getRoomUser = (socket, roomId) ->
  socketIdList = _.keys socket.adapter.rooms[roomId]
  roomUsers = _.reduce users, (result, val, key) ->
    socketId = val.socketId
    index = socketIdList.indexOf socketId
    if index is -1
      return result
    result.push key
    result
  , []

module.exports = store
