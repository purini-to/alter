###
チャットログ情報モデル
###
'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ChatLogSchema = new Schema({
  content: {
    type: String
  }
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

ChatLogSchema.statics = {
  load: load
}

mongoose.model 'ChatLog', ChatLogSchema
