app = angular.module 'alter'

###
# サムネイルの設定
###
app.config (ThumbnailServiceProvider) ->
  ThumbnailServiceProvider.defaults.width = 150
  ThumbnailServiceProvider.defaults.height = 150
