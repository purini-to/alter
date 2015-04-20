###
ユーザー情報モデル
###
'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

UserSchema = new Schema({
  id: String
  name: String
  password: String
  email: String
})

module.exports = mongoose.model 'User',  UserSchema
