'use strict'

express = require 'express'
mongoose = require 'mongoose'
requireDir = require 'require-dir'
requireDir './models', {recurse: true}
app = express()

conf = require './config/env_settings'
require('./config/application')(app)

connect = ->
  options = 
    server: 
      socketOptions: 
        keepAlive: 1
  mongoose.connect "mongodb://#{conf.mongo.hostname}/#{conf.mongo.dbname}", options
connect()
mongoose.connection.on 'error', console.error.bind console, 'connection error:'
mongoose.connection.on 'disconnected',  connect

require('./routes')(app)

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error 'Not Found'
  err.status = 404
  next err

# error handlers
# development error handler
# will print stacktrace
if app.get('env') is 'development'
  app.use (err, req, res, next) ->
    status = if err.status? then err.status else 500
    res.status status
    res.send err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  status = if err.status? then err.status else 500
  res.status status
  res.send 'Internal Server Error'

module.exports = app
