'use strict'

define ['app'], ->

  angular.module('sktApp').controller 'MainCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS!!!',
      'RequireJS',
      'Foundation',
      'Karma'
    ]
