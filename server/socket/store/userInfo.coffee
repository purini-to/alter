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
# store.pushRoom = (roomId) ->
#   index = -1
#   for room, idx in rooms
#     if room.roomId is roomId
#       index = idx
#       break
#   if index is -1
#     rooms.push {
#       roomId: roomId
#       users: []
#     }
#     index = rooms.length - 1
#   index
#
# store.pushUser = (roomIndex, userId) ->
#   room = rooms[roomIndex]
#   index = room.users.indexOf userId
#   if index is -1
#     room.users.push userId
#     index = room.users.length - 1
#   index
#
# store.removeUser = (roomId, userId) ->
#   index = -1
#   for room, idx in rooms
#     if room.roomId is roomId
#       index = idx
#       break
#   if index is -1
#     return
#   else
#     room = rooms[index]
#     index = room.users.indexOf userId
#     if index > -1
#       room.users.splice index, 1
