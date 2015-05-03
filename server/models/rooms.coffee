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
  users: [
    {
      user: {
        type: Schema.Types.ObjectId
        ref: 'User'
      }
      isAdmin: {
        type: Boolean
        default: false
      }
    }
  ]
  createdAt: {
    type: Date
    default: Date.now
  }
})

load = (criteria, select) ->
  select = if select? then select else 'name description users createdAt'
  this.find(criteria)
    .select(select)
    .populate 'users.user', 'id name email'
    .sort {createdAt: 'desc'}
    .exec()

RoomSchema.statics = {
  load: load
}

mongoose.model 'Room',  RoomSchema
