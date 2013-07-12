'use strict'

define ['angular', 'angularMocks', 'controllers/home'], (ng, mock) ->
  describe 'Controller: HomeCtrl', () ->
    # load the controller's module
    beforeEach mock.module 'controllers'
    scope = {}

    # Initialize the controller and a mock scope
    beforeEach mock.inject ($controller, $rootScope) ->
      scope = $rootScope.$new()
      $controller 'HomeCtrl', $scope: scope

    it 'should attach a list of awesomeThings to the scope', () ->
      expect(scope.awesomeThings.length).toBe 5
