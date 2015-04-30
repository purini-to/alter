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
  this.findOne criteria
    .select 'token user'
    .populate 'user', 'id name email'
    .exec()

token = ->
  uuid.v1()

SessionTokenSchema.statics = {
  load: load
  token: token
}

mongoose.model 'SessionToken',  SessionTokenSchema
