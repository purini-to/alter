###
チャットログ情報モデル
###
'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ChatLogSchema = new Schema({
  content: {}
  contentType: {
    type: Number
    default: 1
  }
  user: {
    type: Schema.Types.ObjectId
    ref: 'User'
  }
  room: {
    type: Schema.Types.ObjectId
    ref: 'Room'
  }
  createdAt: {
    type: Date
    default: Date.now
  }
})

load = (criteria, option = {}) ->
  select = if option.select? then option.select else 'content contentType user room createdAt'
  limit = if option.limit? then option.limit else 30
  offset = if option.offset? then option.offset else 0
  this.find(criteria)
    .select(select)
    .populate 'user', 'id name'
    .sort {createdAt: 'desc'}
    .skip offset
    .limit limit
    .exec()

ChatLogSchema.pre 'remove', (next) ->
  if this.contentType is 2 or this.contentType is 3
    this.model('Upload').findOne {tmpName: this.content.tmpName}
      .then (upload) ->
        if upload?
          upload.remove(next)
        else
          next()
  else
    next()

ChatLogSchema.statics = {
  load: load
}

mongoose.model 'ChatLog', ChatLogSchema
