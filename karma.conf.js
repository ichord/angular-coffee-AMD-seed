module.exports = function(karma) {
  karma.configure({
    // base path, that will be used to resolve files and exclude
    frameworks: ['jasmine', 'requirejs'],

    // list of files / patterns to load in the browser
    files: [
      {pattern: 'vendor/angular/angular.js', included: false},
      {pattern: 'vendor/angular-mocks/angular-mocks.js', included: false},
      {pattern: 'vendor/angular-resource/angular-resource.js', included: false},
      {pattern: 'scripts/**/*.js', included: false },
      {pattern: 'spec/**/*Spec.js', included: false},
      'test-build.js'
    ],

    // list of files to exclude
    exclude: [
      'scripts/build.js',
      'scripts/main.js'
    ],

    // use dolts reporter, as travis terminal does not support escaping sequences
    // possible values: 'dots', 'progress', 'junit', 'teamcity'
    // CLI --reporters progress
    reporters: ['progress'],

    // web server port
    // CLI --port 9876
    port: 9876,

    // cli runner port
    // CLI --runner-port 9100
    runnerPort: 9100,

    // enable / disable colors in the output (reporters and logs)
    // CLI --colors --no-colors
    colors: true,

    // level of logging
    // possible values: karma.LOG_DISABLE || karma.LOG_ERROR || karma.LOG_WARN || karma.LOG_INFO || karma.LOG_DEBUG
    // CLI --log-level debug
    logLevel: karma.LOG_INFO,

    // enable / disable watching file and executing tests whenever any file changes
    // CLI --auto-watch --no-auto-watch
    autoWatch: true,

    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera
    // - Safari (only Mac)
    // - PhantomJS
    // - IE (only Windows)
    // CLI --browsers Chrome,Firefox,Safari
    // browsers: [''],

    // If browser does not capture in given timeout [ms], kill it
    // CLI --capture-timeout 5000
    captureTimeout: 5000,

    // Auto run tests on start (when browsers are captured) and exit
    // CLI --single-run --no-single-run
    singleRun: false,

    // report which specs are slower than 500ms
    // CLI --report-slower-than 500
    reportSlowerThan: 500,

    // compile coffee scripts
    // preprocessors: {
    //   '**/*.coffee': 'coffee'
    // },

    plugins: [
      'karma-jasmine',
      'karma-requirejs',
      'karma-phantomjs-launcher',
      'karma-chrome-launcher',
      'karma-firefox-launcher'
    ]
  });
};