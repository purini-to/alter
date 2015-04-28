app = angular.module 'alter'

###
テーマ設定
###
app.config ($mdThemingProvider) ->
  $mdThemingProvider.theme 'default'
    .primaryPalette 'indigo'
    .accentPalette 'pink'
