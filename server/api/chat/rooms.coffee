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

add = (req, res, next) ->
  req.checkBody('name',  '不正な値です').notEmpty().isLength(1, 15)
  req.checkBody('users',  '不正な値です').notEmpty().isArray()
  if req.param('description')? and req.param('description') is not ''
    req.checkBody('description',  '不正な値です').optional().isLength(1, 100)
  errors = req.validationErrors(true)
  if errors?
    res.status 400
    return res.send errors
  new Room(req.body).save()
    .then (room) ->
      res.send room
    .onReject (err) ->
      console.log err
      next err

module.exports = {
  getList: getList
  add: add
}
