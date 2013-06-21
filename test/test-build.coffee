tests = Object.keys(window.__karma__.files).filter (file) -> /Spec.js$/.test(file);

requirejs.config
  deps: tests
  # Karma serves files from '/base'
  baseUrl: '/base/scripts',
  paths:
    'jQuery': '../vendors/jquery/jquery'
    'angular': '../vendors/angular/angular'
    'angular-resource': '../vendors/angular-resource/angular-resource'
    'angularMocks': '../vendors/angular-mocks/angular-mocks'
  shim:
    'angular': {'exports' : 'angular'}
    'angular-resource': { deps: ['angular'] }
    'angularMocks': { exports: 'angular.mock', deps: ['angular']}
    'jQuery': {'exports': 'jQuery'}

  # start test run, once Require.js is done
  callback: window.__karma__.start