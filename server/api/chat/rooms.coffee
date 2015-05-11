###
ユーザー情報API
###
'use strict'

errUtil = require '../../utils/errorUtil'
mongoose = require 'mongoose'
Room = mongoose.model 'Room'
Upload = mongoose.model 'Upload'


roomExists = (res, roomId) ->
  Room.load {_id: roomId}
    .then (rooms) ->
      result = null
      if rooms? and rooms.length > 0
        result = rooms[0]
      else
        res.status 400
        errData = errUtil.addError 'global', 'ルームが存在しません'
        res.send errData
      result

###
ルーム取得(単一)API
###
get = (req, res, next) ->
  roomId = req.param "roomId"
  roomExists res, roomId
    .then (room) ->
      if room?
        res.send room
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

###
#ルーム作成
###
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

###
#ルームに参加
###
join = (req, res, next) ->
  req.checkBody('userId',  '不正な値です').notEmpty().isMongoId()
  errors = req.validationErrors(true)
  if errors?
    res.status 400
    return res.send errors
  roomId = req.param 'roomId'
  userId = req.body.userId
  Room.join roomId, userId
    .then (room) ->
      if room?
        res.send room
      else
        res.status 400
        errData = errUtil.addError 'global', 'ルームまたはユーザーが存在しません'
        res.send errData
    .onReject (err) ->
      console.log err
      next err


###
#ファイルアップロード
###
upload = (req, res, next) ->
  user = req.body.user
  files = req.files
  if user? and files?
    originName = if files.file.originalname is 'undefined' then '' else files.file.originalname
    extension = if files.file.extension is '' then files.file.mimetype else files.file.extension
    path = files.file.path.replace('.tmp/', '')
    upload = new Upload {
      originName: originName
      tmpName: files.file.name
      extension: extension
      path: path
      user: user._id
    }
    upload.save()
      .then (upload) ->
        res.send upload
      .onReject (err) ->
        console.log err
        next err
  else
    res.status 400
    errData = errUtil.addError 'global', 'ルームまたはユーザーが存在しません'
    res.send errData

###
#ルーム削除
###
# remove = (req, res, next) ->
#   req.checkParams('roomId', '存在しないルームです').notEmpty().isMongoId()
#   req.checkQuery('userId', '不正なユーザーです').notEmpty().isMongoId()
#   errors = req.validationErrors(true)
#   if errors?
#     res.status 400
#     return res.send errors
#
#   roomId = req.param 'roomId'
#   userId = req.query.userId
#   roomExists res, roomId
#     .then (room) ->
#       if room?
#         adminUsers = room.users.filter (val) ->
#           val.isAdmin
#         .map (val) ->
#           String(val.user)
#         if adminUsers.indexOf(userId) is -1
#           res.status 400
#           errData = errUtil.addError 'userId', '管理者のユーザーを指定してください'
#           res.send errData
#           room = null
#         room
#     .then (room) ->
#       if room?
#         room.remove()
#     .then (result) ->
#       if result?
#         res.send {roomId: roomId}
#     .onReject (err) ->
#       console.log err
#       next err

module.exports = {
  get: get
  getList: getList
  add: add
  join: join
  upload: upload
  # remove: remove
}
