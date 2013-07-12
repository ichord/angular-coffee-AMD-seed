'use strict'
define ['app', 'controllers/home', 'controllers/sessions'], ->

  angular.module('sevless').config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/home.html', controller: 'HomeCtrl'
      .when '/signup',
        templateUrl: 'views/sessions/signup.html', controller: 'sessions.SignupCtrl'
      .when '/signin',
        templateUrl: 'views/sessions/signin.html', controller: 'sessions.SigninCtrl'
      .otherwise
        redirectTo: '/'
