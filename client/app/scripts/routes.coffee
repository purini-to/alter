angular.module 'alter'
    .config ($stateProvider, $urlRouterProvider) =>
        $urlRouterProvider.otherwise '/login'
        $stateProvider.state 'login',
            url: "/login"
            templateUrl: "views/login/login.html"
            controller: "loginCtrl"
            title: "LOGIN.TITLE"
