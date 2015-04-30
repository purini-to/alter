###
ルーム情報モデル
###
'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

RoomSchema = new Schema({
  name: {
    type: String
  }
  description: {
    type: String
  }
  users: [{
    type: Schema.Types.ObjectId
    ref: 'User'
    unique: true
  }]
  createdAt: {
    type: Date
    default: Date.now
  }
})

load = (criteria, select) ->
  select = if select? then select else 'name description users createdAt'
  this.find(criteria)
    .select(select)
    .populate 'users', 'id name email'
    .sort {createdAt: 'desc'}
    .exec()

RoomSchema.statics = {
  load: load
}

mongoose.model 'Room',  RoomSchema
