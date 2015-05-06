###
ユーザー情報モデル
###
'use strict'

_ = require 'lodash'
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
  favoriteRooms: [
    type: Schema.Types.ObjectId
    ref: 'Room'
  ]
  createdAt: {
    type: Date
    default: Date.now
  }
})

load = (options) ->
  options.select = options.select || 'id name email favoriteRooms'
  options.populate = options.populate || {}
  query = this.findOne(options.criteria)
    .select(options.select)
  _.each options.populate, (value, key) ->
    query.populate key, value
  query.exec()
loads = (options) ->
  options.select = options.select || 'id name email'
  this.find(options.criteria)
    .select(options.select)
    .exec()

UserSchema.statics = {
  load: load
  loads: loads
}

mongoose.model 'User',  UserSchema
