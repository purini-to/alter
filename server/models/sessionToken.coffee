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
  }
  expire: {
    type: Date
  }
})

load = (user) ->
  this.findOne {user: user}
    .select 'token'
    .populate 'user', 'id name email'
    .exec()

token = ->
  uuid.v1()

SessionTokenSchema.statics = {
  load: load
  token: token
}

mongoose.model 'SessionToken',  SessionTokenSchema
