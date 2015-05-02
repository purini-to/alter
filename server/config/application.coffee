'use strict'

express = require 'express'
expressValidator = require 'express-validator'
path = require 'path'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
ECT = require 'ect'

# 環境に応じた設定を読み込み
config = require './env_settings'

ectRenderer = ECT {
  watch: true
  root: "#{config.root}/server/views"
  ext : '.ect'
}

# カスタムバリデーション定義
customValidators = {
  # 半角英数字と記号
  isAlphaNumericSymbol: (value) ->
    pattern = new RegExp "^[a-zA-Z0-9-/:-@\[-\`\{-\~]+$"
    pattern.test value
  # 配列
  isArray: (value) ->
    Array.isArray value
}

module.exports = (app) ->
  env = config.env

  app.set 'env', env
  app.set 'views', "#{config.root}/server/views"
  app.engine 'ect', ectRenderer.render
  app.set 'view engine', 'ect'
  app.use(bodyParser.urlencoded({
    extended: false
  }))
  app.use bodyParser.json()
  app.use cookieParser()
  app.use(expressValidator({
    customValidators: customValidators
  }))
  if 'production' is env
    # app.use(favicon(path.join(config.root, 'public', 'favicon.ico')));
    app.use express.static path.join(config.root, 'public')
    app.set 'appPath', "#{config.root}/public"
    app.use logger('dev')

  if 'development' is env or 'test' is env
    app.use require('connect-livereload')()
    app.use express.static(path.join(config.root, '/.tmp'))
    app.set 'appPath', '/.tmp'
    app.use logger('dev')
