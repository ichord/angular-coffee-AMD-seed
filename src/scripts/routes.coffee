'use strict'
define ['controllers/main', 'controllers/signup'], ->
  angular.module('sktApp').config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html', controller: 'MainCtrl'
      .when '/signup',
        templateUrl: 'views/signup.html', controller: 'SignupCtrl'
      .otherwise
        redirectTo: '/'
