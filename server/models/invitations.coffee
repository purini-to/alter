###
# 招待ユーザー情報モデル
###
'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

InvitationSchema = new Schema({
  users: [
    {
      user: {
        type: Schema.Types.ObjectId
        ref: 'User'
      }
      isAccept: {
        type: Boolean
      }
    }
  ]
  room: {
    type: Schema.Types.ObjectId
    ref: 'Room'
    unique: true
  }
  createdAt: {
    type: Date
    default: Date.now
  }
})

load = (room) ->
  this.findOne {room: room}
    .select 'users room createdAt'
    .populate 'users.user'
    .exec()

# 招待されたルーム一覧を検索する
loadInvitationRooms = (userId) ->
  query = {
    users: {
      $elemMatch: {
        user: userId
      }
    }
  }

  this.find query
    .select 'room'
    .populate 'room', 'name description isPrivate createdAt'
    .exec()

InvitationSchema.statics = {
  load: load
  loadInvitationRooms: loadInvitationRooms
}

mongoose.model 'Invitation', InvitationSchema
