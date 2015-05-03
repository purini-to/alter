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

load = (criteria, select) ->
  select = if select? then select else 'content contentType user room createdAt'
  this.find(criteria)
    .select(select)
    .populate 'user', 'id name'
    .populate 'room', ''
    .sort {createdAt: 'asc'}
    .exec()

ChatLogSchema.statics = {
  load: load
}

mongoose.model 'ChatLog', ChatLogSchema
