tests = Object.keys(window.__karma__.files).filter (file) -> /Spec.js$/.test(file);

requirejs.config
  deps: tests
  # Karma serves files from '/base'
  baseUrl: '/base/scripts',
  paths:
    'jQuery': '../vendor/jquery/jquery'
    'angular': '../vendor/angular/angular'
    'angular-resource': '../vendor/angular-resource/angular-resource'
    'angularMocks': '../vendor/angular-mocks/angular-mocks'
  shim:
    'angular': {'exports' : 'angular'}
    'angular-resource': { deps: ['angular'] }
    'angularMocks': { exports: 'angular.mock', deps: ['angular']}
    'jQuery': {'exports': 'jQuery'}

  # start test run, once Require.js is done
  callback: window.__karma__.start