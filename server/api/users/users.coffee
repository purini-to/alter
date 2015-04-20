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
  if req.param('email')?
    req.checkBody('email',  '不正な値です').optional().isEmail()
  errors = req.validationErrors(true)
  if errors?
    res.status 400
    return res.send errors

  resData = {
    result: 'SUCCESS'
  }
  res.send resData

module.exports = {
  login: login
  save: save
}
