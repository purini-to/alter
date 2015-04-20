'use strict'

express = require 'express'
mongoose = require 'mongoose'
conf = require './config/env_settings'
app = express()

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

requireDir = require 'require-dir'
requireDir './models', {recurse: true}
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
    res.status err.status || 500
    res.send 'error', {
      message: err.message
      error: err
    }

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status || 500
  res.send 'error', {
    message: err.message
    error: {}
  }

module.exports = app
