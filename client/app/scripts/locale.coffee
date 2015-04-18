app = angular.module 'alter'

###
国際化言語設定
言語設定ファイルのJSONを読み込む
###
app.config ($translateProvider) =>
  $translateProvider.useStaticFilesLoader {
    prefix: 'assets/i18n/locale-'
    suffix: '.json'
  }
  $translateProvider.preferredLanguage 'ja'
  $translateProvider.fallbackLanguage 'en'
  $translateProvider.useMissingTranslationHandlerLog()
  $translateProvider.useLocalStorage()
