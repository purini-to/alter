'use strict'

_ = require 'lodash'

store = {}
users = {}

store.addUser = (userId, socketId, data = {}) ->
  if users[userId]? is false
    users[userId] = {}
    users[userId].sockets = []
  if users[userId].data? and data.length > 0
    users[userId].data = data
  users[userId].sockets.push socketId
  store

store.updateUser = (userId, data = {}) ->
  origin = users[userId].data
  users[userId].data = _.merge origin, data
  store

store.removeUser = (userId, socketId) ->
  sockets = users[userId].sockets
  _.pull sockets, socketId
  if sockets.length is 0
    delete users[userId]
  store

store.getUser = (userId) ->
  users[userId]

store.getRoomUser = (socket, roomId) ->
  socketIdList = _.keys socket.adapter.rooms[roomId]
  roomUsers = _.reduce users, (result, val, key) ->
    sockets = val.sockets
    if _.intersection(socketIdList, sockets).length is 0
      return result
    result.push key
    result
  , []

store.isOtherEntryRoomSocket = (socket, userId, roomId) ->
  socketIdList = _.keys socket.adapter.rooms[roomId]
  userOtherSockets = _.without users[userId].sockets, socket.id
  _.intersection(socketIdList, userOtherSockets).length > 0

module.exports = store
