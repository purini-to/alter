###
サーバー側のルーティング設定
###
'use strict'
requireDir = require('require-dir')

module.exports = (app) ->
  api = requireDir('./api',  {recurse: true})

  # ログインAPI
  app.route('/api/users/login').post(api.users.users.login)
  # ユーザー情報取得(トークン)API
  app.route('/api/users/token').post(api.users.users.getUserByToken)
  # アカウント新規登録API
  app.route('/api/users').post(api.users.users.save)
