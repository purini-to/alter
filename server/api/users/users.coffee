###
ユーザー情報API
###
'use strict'

module.exports = {
  login: (req, res, next) =>
    resData = {
      user:
        id: 2133212
        name: 'オレオレ'
        token: 'efoij2109fj2o3u0fj320rf0'
    }
    res.send resData

  save: (req, res, next) =>
    resData = {
      result: 'SUCCESS'
    }
    res.send resData
}
