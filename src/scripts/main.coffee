require.config
  baseUrl: '/scripts'
  paths:
    'jQuery': '../vendors/jquery/jquery'
    'angular': '../vendors/angular/angular'
    'angular-resource': '../vendors/angular-resource/angular-resource'
  shim:
    'angular': {'exports' : 'angular'}
    'angular-resource': { deps: ['angular']}
    'jQuery': {'exports': 'jQuery'}

require ['jQuery', 'app', 'routes'], ($) ->
  $ ->
    angular.bootstrap document, ['sktApp']