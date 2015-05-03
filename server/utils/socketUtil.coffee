'use strict'

getUserId = (socket) ->
  cookie = require('cookie').parse socket.request.headers.cookie
  cookie.userId.replace('"', '').replace('"', '')

module.exports = {
  getUserId: getUserId
}
