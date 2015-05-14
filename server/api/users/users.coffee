###
ユーザー情報API
###
'use strict'

identicon = require 'identicon'
fs = require 'fs'

errUtil = require '../../utils/errorUtil'
mongoose = require 'mongoose'
User = mongoose.model 'User'
Upload = mongoose.model 'Upload'
SessionToken = mongoose.model 'SessionToken'


api = {}

###
ログイン認証API
###
api.login = (req, res, next) ->
  req.checkBody('id',  '不正な値です').notEmpty().isLength(5, 15).isAlphaNumericSymbol()
  req.checkBody('password',  '不正な値です').notEmpty().isLength(6, 20).isAlphaNumericSymbol()
  errors = req.validationErrors(true)
  if errors?
    res.status 401
    errData = errUtil.addError 'global', 'アカウント名またはパスワードが間違ってます'
    return res.send errData

  options = {
    criteria: {
      id: req.body.id
      password: req.body.password
    }
    populate: {
      favoriteRooms: 'name'
      avator: 'tmpName path'
    }
  }
  resultUser = null
  resultToken = null
  tokenCreate = (user) ->
    SessionToken.load {user: user}
      .then (token) ->
        if !token?
          token = new SessionToken({user: resultUser})
        resultToken = SessionToken.token()
        token.token = resultToken
        token.save()

  User.load options
    .then (user) ->
      if user?
        resultUser = user
        user = tokenCreate user
      else
        errData = errUtil.addError 'global', 'アカウント名またはパスワードが間違ってます'
        res.status 401
        res.send errData
      user
    .then ->
      if res.finished is false
        resData = {
          token: resultToken
          user: resultUser
        }
        res.send resData
    .onReject (error) ->
      console.log error
      next error

###
# アクセストークンからユーザー情報を取得する
###
api.getUserByToken = (req, res, next) ->
  req.checkBody('token',  '無効なアクセストークンです').notEmpty().isLength(36, 36)
  errors = req.validationErrors(true)
  if errors?
    res.status 401
    return res.send errors

  SessionToken.load {token: req.body.token}
    .then (token) ->
      if token?
        res.send token.user
      else
        errData = errUtil.addError 'token', '無効なアクセストークンです'
        res.status 401
        res.send errData
      token
    .onReject (error) ->
      console.log error
      next error

###
アカウント新規登録API
###
api.save = (req, res, next) ->
  req.checkBody('id',  '不正な値です').notEmpty().isLength(5, 15).isAlphaNumericSymbol()
  req.checkBody('name',  '不正な値です').notEmpty().isLength(1, 12)
  req.checkBody('password',  '不正な値です').notEmpty().isLength(6, 20).isAlphaNumericSymbol()
  if req.param('email')? and req.param('email') is not ''
    req.checkBody('email',  '不正な値です').optional().isEmail()
  errors = req.validationErrors(true)
  if errors?
    res.status 400
    return res.send errors

  User.load {criteria: {id: req.body.id}}
    .then (user) ->
      if user?
        res.status 400
        errData = errUtil.addError 'id', '既に使用されています', 'id', req.body.id
        res.send errData
      else
        app = require('../../app')
        path = app.get 'appPath'
        fileName = "#{req.body.id}.png"
        filePath = "#{path}/uploads/#{fileName}"
        avator = identicon.generateSync({ id: req.body.id,  size: 60})
        fs.writeFileSync(filePath, avator)
        upload = new Upload {
          tmpName: fileName
          extension: '.png'
          path: filePath.replace("#{path}/", '')
        }
        user = upload.save()
      user
    .then (avator) ->
      if avator?
        user = req.body
        user.avator = avator._id
        avator = new User(user).save()
      avator
    .then (user) ->
      if res.finished is false
        resData = {
          result: 'SUCCESS'
        }
        res.send resData
      user
    .onReject (error) ->
      console.log error
      next error

api.addFavoriteRoom = (req, res, next) ->
  userId = req.param "userId"
  req.checkBody('_id',  '不正な値です').notEmpty().isMongoId()

  User.load {criteria: {_id: userId}}
    .then (user) ->
      if user?
        user.favoriteRooms = if user.favoriteRooms? then user.favoriteRooms else []
        user.favoriteRooms.push req.body._id
        user = user.save()
      user
    .then (user) ->
      res.send user
    .onReject (err) ->
      console.log err
      next err

api.removeFavoriteRoom = (req, res, next) ->
  userId = req.param "userId"
  req.checkBody('_id',  '不正な値です').notEmpty().isMongoId()

  User.load {criteria: {_id: userId}}
    .then (user) ->
      if user?
        roomId = req.body._id
        user.favoriteRooms = if user.favoriteRooms? then user.favoriteRooms else []
        index = user.favoriteRooms.indexOf roomId
        if index > -1
          user.favoriteRooms.splice index, 1
          user = user.save()
      user
    .then (user) ->
      res.send user
    .onReject (err) ->
      console.log err
      next err

module.exports = api
