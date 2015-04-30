###
ユーザー情報API
###
'use strict'

errUtil = require '../../utils/errorUtil'
mongoose = require 'mongoose'
User = mongoose.model 'User'
SessionToken = mongoose.model 'SessionToken'

###
ログイン認証API
###
login = (req, res, next) ->
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
getUserByToken = (req, res, next) ->
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
save = (req, res, next) ->
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
        user = new User(req.body).save()
      user
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

module.exports = {
  login: login
  getUserByToken: getUserByToken
  save: save
}
