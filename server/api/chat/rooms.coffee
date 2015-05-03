###
ユーザー情報API
###
'use strict'

errUtil = require '../../utils/errorUtil'
mongoose = require 'mongoose'
Room = mongoose.model 'Room'

###
ルーム取得(単一)API
###
get = (req, res, next) ->
  roomId = req.param "roomId"
  Room.load {_id: roomId}
    .then (rooms) ->
      if rooms? and rooms.length > 0
        res.send rooms[0]
      else
        res.status 400
        errData = errUtil.addError 'global', 'ルームが存在しません'
        res.send errors
    .onReject (err) ->
      console.log err
      next err

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
  if req.body.description? and req.body.description is not ''
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

join = (req, res, next) ->
  req.checkBody('userId',  '不正な値です').notEmpty().isMongoId()
  errors = req.validationErrors(true)
  if errors?
    res.status 400
    return res.send errors
  roomId = req.param "roomId"
  userId = req.body.userId
  Room.join roomId, userId
    .then (room) ->
      if room?
        res.send room
      else
        res.status 400
        errData = errUtil.addError 'global', 'ルームまたはユーザーが存在しません'
        res.send errors
    .onReject (err) ->
      console.log err
      next err

module.exports = {
  get: get
  getList: getList
  add: add
  join: join
}
