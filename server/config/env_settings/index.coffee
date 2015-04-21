'use strict'

path = require 'path'
_ = require 'lodash'

requiredProcessEnv = (name) ->
  if process.env[name]?
    throw new Error "You must set the #{name} environment variable"
  process.env[name]

process.env.NODE_ENV = process.env.NODE_ENV || 'development'
# All configurations will extend these options
# ============================================
all = {
  # 実行環境(本番、開発、テスト等)
  env: process.env.NODE_ENV

  # アプリケーションのルートディレクトリ
  root: path.normalize "#{__dirname}/../../.."

  # 起動ポート(デフォルト:3000)
  port: process.env.PORT || 3000
}

# Export the config object based on the NODE_ENV
# ==============================================
module.exports = _.merge(
  all,
  require "./#{process.env.NODE_ENV}.js" || {}
)
