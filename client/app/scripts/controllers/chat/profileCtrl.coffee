app = angular.module 'alter'

###
# プロフィール編集コントローラー
###
app.controller 'profileCtrl', ($scope, $mdDialog, $mdMedia, $mdToast, $timeout, Upload, userModel, userService) ->
  # ユーザー情報の格納
  $scope.user = {
    _id: userModel.user._id
    id: userModel.user.id
    name: userModel.user.name
    email: userModel.user.email
    password: ''
    avator: userModel.user.avator
  }
  # 新しいアバター格納変数
  $scope.avator = null
  # 元アバター格納変数
  $scope.originalAvator = null
  # 画面サイズにより、レイアウトを変更する判定関数
  $scope.screenIsOverlap = ->
    $mdMedia('md') || $mdMedia('sm')

  # パスワードの確認バリデーション
  $scope.validators = {
    password_confirm:
      confirm: (modelValue,  viewValue) ->
        user = $scope.user || {}
        val = modelValue || viewValue
        user.password is '' || user.password is val
  }

  # パスワードの入力を監視して、パスワード確認のバリデーションを行う
  $scope.$watch 'user.password', ->
    $scope.accountForm.conf.$validate()

  # submitイベントハンドラ
  $scope.submit = (ev) ->
    userService.update $scope.user
      .then (result) ->
        # diffデータのみ反映する
        angular.extend userModel.user, result.diff
        $scope.hide()
        $mdToast.show(
          $mdToast.simple()
            .content 'プロフィールを更新しました'
            .position 'bottom left'
            .hideDelay(3000)
        )
        result
        result
      .catch (error) ->
        console.log error
        alert "エラーが発生しました\n管理者に問い合わせてください"

  $scope.hide = ->
    $mdDialog.hide()

  $scope.cancel = ->
    $mdDialog.cancel()
