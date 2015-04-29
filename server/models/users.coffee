###
ユーザー情報モデル
###
'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

UserSchema = new Schema({
  id: {
    type: String
    unique: true
  }
  name: {
    type: String
  }
  password: {
    type: String
  }
  email: {
    type: String
    default: ''
  }
  createdAt: {
    type: Date
    default: Date.now
  }
})

load = (options) ->
  options.select = options.select || 'id name email'
  this.findOne(options.criteria)
    .select(options.select)
    .exec()

UserSchema.statics = {
  load: load
}

mongoose.model 'User',  UserSchema
