###
ファイルアップロードモデル
###
'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

UploadSchema = new Schema({
  originName: {
    type: String
  }
  tmpName: {
    type: String
  }
  user: {
    type: Schema.Types.ObjectId
    ref: 'User'
  }
  extension: {
    type: String
  }
  size: {
    type: Number
  }
  path: {
    type: String
  }
  createdAt: {
    type: Date
    default: Date.now
  }
})

load = (criteria, option = {}) ->
  select = if option.select? then option.select else 'originName tmpName user mimeType'
  this.find(criteria)
    .select(select)
    .populate 'user', 'id name'
    .exec()

UploadSchema.statics = {
  load: load
}

mongoose.model 'Upload', UploadSchema
