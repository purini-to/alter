###
ユーザー情報API
###
'use strict'

mongoose = require 'mongoose'
Room = mongoose.model 'Room'

###
ルーム取得(一覧)API
###
getList = (req, res, next) ->
  Room.load {}
    .then (rooms) ->
      res.send rooms
    .onReject (err) ->
      console.log err
      next err

module.exports = {
  getList: getList
}
