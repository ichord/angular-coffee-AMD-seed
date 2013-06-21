'use strict'

define ['angular', 'angularMocks', 'controllers/main'], (ng, mock) ->
  describe 'Controller: MainCtrl', () ->
    # load the controller's module
    beforeEach mock.module 'sktApp'
    scope = {}

    # Initialize the controller and a mock scope
    beforeEach mock.inject ($controller, $rootScope) ->
      scope = $rootScope.$new()
      $controller 'MainCtrl', $scope: scope

    it 'should attach a list of awesomeThings to the scope', () ->
      expect(scope.awesomeThings.length).toBe 3
