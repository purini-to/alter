'use strict'

express = require 'express'
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

module.exports = (app) =>
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
