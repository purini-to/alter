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

  # ルーム取得(一覧)API
  app.route('/api/chat/rooms').get(api.chat.rooms.getList)
  # ルーム取得(ID指定)API
  app.route('/api/chat/rooms/:roomId').get(api.chat.rooms.get)
  # ルームの作成
  app.route('/api/chat/rooms').post(api.chat.rooms.add)
  # ルームに参加
  app.route('/api/chat/rooms/:roomId').post(api.chat.rooms.join)
