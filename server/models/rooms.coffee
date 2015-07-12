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
  isPrivate: {
    type: Boolean
    default: false
  }
  createdAt: {
    type: Date
    default: Date.now
  }
})

load = (criteria, select) ->
  select = if select? then select else 'name description users createdAt'
  this.find(criteria)
    .select(select)
    # .populate 'users.user', 'id name email'
    .sort {createdAt: 'desc'}
    .exec()

join = (roomId, userId) ->
  this.findOne {_id: roomId}
    .select '_id users'
    .populate 'users'
    .exec()
    .then (room) ->
      if room?
        user = {
          user:
            _id: userId
        }
        room.users.push user
        room = room.save()
      room

RoomSchema.pre 'remove', (next) ->
  self = this
  self.model('ChatLog').remove {room: self._id}, ->
    self.model('Invitation').remove {room: self._id}, next
                                        
RoomSchema.statics = {
  load: load
  join: join
}

mongoose.model 'Room',  RoomSchema
