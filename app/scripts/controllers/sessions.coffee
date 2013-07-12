'use strict'

define ['controllers/base'], ->

  angular.module('controllers').controller('sessions.SignupCtrl', ($scope) ->
    $scope.create = (user) ->
      console.log user

    $scope.user =
      email: "example@hello.com"
      password: "123456"

  ).controller('sessions.SigninCtrl', ($scope) ->
    $scope.post = (user) ->
      console.log user
  )
