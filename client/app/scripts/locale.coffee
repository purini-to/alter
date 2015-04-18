angular.module 'alter'
    .config ($translateProvider) =>
      $translateProvider.useStaticFilesLoader {
        prefix: 'assets/i18n/locale-'
        suffix: '.json'
      }
      $translateProvider.preferredLanguage 'ja'
      $translateProvider.fallbackLanguage 'en'
      $translateProvider.useMissingTranslationHandlerLog()
      $translateProvider.useLocalStorage()
