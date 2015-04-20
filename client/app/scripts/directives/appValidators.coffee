app = angular.module 'alter'

###
アプリケーション定義のバリデーションを行う
###
app.directive 'appValidators', =>
  return {
    restrict: 'A'
    require: 'ngModel'
    scope: {
      appValidators: '='
    }
    link : (scope, element, attrs, ctrl) =>
      validators = scope.appValidators || {}
      angular.forEach validators, (val,  key) =>
        ctrl.$validators[key] = val
  }
