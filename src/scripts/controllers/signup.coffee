'use strict'

define ['app'], ->

  angular.module('sktApp').controller 'SignupCtrl', ($scope) ->
    $scope.create = (user) ->
      console.log user

    $scope.user =
      email: "example@hello.com"
      password: "123456"
