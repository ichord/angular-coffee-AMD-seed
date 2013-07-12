require.config
  baseUrl: '/scripts'
  paths:
    'jQuery': '../vendor/jquery/jquery'
    'angular': '../vendor/angular/angular'
    'angular-resource': '../vendor/angular-resource/angular-resource'
    'firebase': 'https://cdn.firebase.com/v0/firebase'
    'angularFire': '../vendor/angular-fire/angularFire'
  shim:
    'angular': {'exports' : 'angular'}
    'angular-resource': { deps: ['angular']}
    'jQuery': {'exports': 'jQuery'}
    'firebase': {exports: 'firebase'}
    'angularFire': {deps: ['angular', 'firebase']}

require ['jQuery', 'routes'], ($) ->
  $ ->
    angular.bootstrap document, ['sevless']