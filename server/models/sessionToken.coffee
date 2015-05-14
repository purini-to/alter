###
#セッショントークンモデル
###
'use strict'

uuid = require 'node-uuid'
mongoose = require 'mongoose'
Schema = mongoose.Schema

SessionTokenSchema = new Schema({
  user: {
    type: Schema.Types.ObjectId
    ref: 'User'
    unique: true
  }
  token: {
    type: String
    unique: true
  }
  expire: {
    type: Date
  }
})

load = (criteria) ->
  User = mongoose.model 'User'
  this.findOne criteria
    .select 'token user'
    .populate 'user', 'id name email favoriteRooms avator'
    .exec()
    .then (token) ->
      Room = mongoose.model 'Room'
      User.populate token, {
        path: 'user.favoriteRooms'
        select: 'name'
        model: Room
      }
    .then (token) ->
      Upload = mongoose.model 'Upload'
      User.populate token, {
        path: 'user.avator'
        select: 'tmpName path'
        model: Upload
      }


token = ->
  uuid.v1()

SessionTokenSchema.statics = {
  load: load
  token: token
}

mongoose.model 'SessionToken',  SessionTokenSchema
