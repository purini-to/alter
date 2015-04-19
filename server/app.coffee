'use strict'

express = require 'express'
app = express()

require('./config/application')(app)
require('./routes')(app)

# catch 404 and forward to error handler
app.use (req, res, next) =>
  err = new Error 'Not Found'
  err.status = 404
  next err

# error handlers
# development error handler
# will print stacktrace
if app.get('env') is 'development'
  app.use (err, req, res, next) =>
    res.status err.status || 500
    res.render 'error', {
      message: err.message
      error: err
    }

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) =>
  res.status err.status || 500
  res.render 'error', {
    message: err.message
    error: {}
  }

module.exports = app
