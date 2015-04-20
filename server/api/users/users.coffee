###
ユーザー情報API
###
'use strict'

###
ログイン認証API
###
login = (req, res, next) =>
  req.checkBody('id',  '不正な値です').notEmpty().isLength(5, 15).isAlphaNumericSymbol()
  req.checkBody('password',  '不正な値です').notEmpty().isLength(6, 20).isAlphaNumericSymbol()
  errors = req.validationErrors(true)
  if errors?
    res.status 400
    return res.send errors

  resData = {
    user:
      id: 2133212
      name: 'オレオレ'
      token: 'efoij2109fj2o3u0fj320rf0'
  }
  res.send resData

###
アカウント新規登録API
###
save = (req, res, next) =>
  req.checkBody('id',  '不正な値です').notEmpty().isLength(5, 15).isAlphaNumericSymbol()
  req.checkBody('name',  '不正な値です').notEmpty().isLength(1, 12)
  req.checkBody('password',  '不正な値です').notEmpty().isLength(6, 20).isAlphaNumericSymbol()
  if req.param('email')? and req.param('email') is not ''
    req.checkBody('email',  '不正な値です').optional().isEmail()
  errors = req.validationErrors(true)
  if errors?
    res.status 400
    return res.send errors

  User = require('../../models/users')
  user = new User()
  user.id = req.param 'id'
  user.name = req.param 'name'
  user.password = req.param 'password'
  user.email = req.param 'email'
  user.save (err) =>
    console.log err
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
