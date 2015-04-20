###
ユーザー情報API
###
'use strict'

mongoose = require 'mongoose'
User = mongoose.model 'User'

###
ログイン認証API
###
login = (req, res, next) ->
  req.checkBody('id',  '不正な値です').notEmpty().isLength(5, 15).isAlphaNumericSymbol()
  req.checkBody('password',  '不正な値です').notEmpty().isLength(6, 20).isAlphaNumericSymbol()
  errors = req.validationErrors(true)
  if errors?
    res.status 400
    return res.send errors

  options = {
    criteria: {
      id: req.body.id
      password: req.body.password
    }
  }
  User.load options, (err, user) ->
    if err?
      return next err
    if !user?
      res.status 401
      return res.send {
        msg: 'アカウント名またはパスワードが間違ってます'
      }
    res.send user

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

  user = new User req.body
  user.save (err) ->
    if err?
      res.send(err)

    resData = {
      result: 'SUCCESS'
    }
    res.send resData

module.exports = {
  login: login
  save: save
}
