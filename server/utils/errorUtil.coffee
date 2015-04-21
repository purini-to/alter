'use strict'

utils = {}

utils.addError = (errId, errMsg, errParam, errValue, err) ->
  err = err || {}
  errParam = errParam || ''
  errValue = errValue || ''
  err[errId] = {
    msg: errMsg
    param: errParam
    value: errValue
  }
  err

module.exports = utils
