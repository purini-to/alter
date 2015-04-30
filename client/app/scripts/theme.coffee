app = angular.module 'alter'

###
テーマ設定
###
app.config ($mdThemingProvider) ->
  $mdThemingProvider.theme 'default'
    .primaryPalette 'blue-grey', {
      'default': '700'
      'hue-1': '300'
      'hue-2': '900'
      'hue-3': '200'
    }
    .accentPalette 'teal', {
      'default': 'A400'
    }
