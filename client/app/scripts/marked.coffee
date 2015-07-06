app = angular.module 'alter'

###
# マークダウン変換ライブラリの設定
###
app.config (markedProvider) ->
  marked.setOptions({
    sanitize: true
  })
