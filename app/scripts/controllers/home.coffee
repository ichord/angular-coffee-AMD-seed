'use strict'

define ['controllers/base'], ->

  angular.module('controllers').controller 'HomeCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS!!!',
      'RequireJS',
      'Foundation',
      'Karma'
    ]
