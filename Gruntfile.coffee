"use strict"
lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # configurable paths
  yeomanConfig =
    app: "app"
    vendor: "app/vendor"
    build: "build"
    dist: "dist"

  try
    yeomanConfig.src = require("./bower.json").appPath or yeomanConfig.src

  grunt.initConfig

    yo: yeomanConfig

    watch:
      options:
        livereload: true
        nospawn: true
      coffee:
        files: ["<%= yo.app %>/scripts/**/{,*/}*.coffee"]
        tasks: ["coffee:build"]
        options:
          events: ['changed', 'added']
      coffeeTest:
        files: ["test/spec/{,*/}*.coffee"]
        tasks: ["coffee:test", "karma:unit:run"]
      compass:
        files: ["<%= yo.app %>/styles/{,*/}*.{scss,sass}"]
        tasks: ["compass"]
      statics:
        files: ["<%= yo.app %>/{,*/}*.html", "<%= yo.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"]

    connect:
      options:
        port: 9000
        # Change this to '0.0.0.0' to access the server from outside.
        hostname: "localhost"
      livereload:
        options:
          middleware: (connect) ->
            [lrSnippet, mountFolder(connect, yeomanConfig.build), mountFolder(connect, yeomanConfig.app)]
      production:
        options:
          middleware: (connect) ->
            [mountFolder(connect, yeomanConfig.dist)]

    open:
      server:
        url: "http://<%= connect.options.hostname %>:<%= connect.options.port %>"

    clean:
      dist: "<%= yo.dist %>"
      build: "<%= yo.build %>"

    coffee:
      # options:
      #   sourceMap: yes
      #   sourceRoot: './'
      build:
        expand: true
        cwd: "<%= yo.app %>/scripts"
        src: "**/{,*/}*.coffee"
        dest: "<%= yo.build %>/scripts"
        ext: ".js"
      test:
        expand: true
        cwd: "test"
        src: "**/{,*/}*.coffee"
        dest: "<%= yo.build %>"
        ext: ".js"

    compass:
      options:
        sassDir: "<%= yo.app %>/styles"
        cssDir: "<%= yo.build %>/styles"
        # imagesDir: "<%= yo.app %>/images"
        # javascriptsDir: "<%= yo.app %>/scripts"
        # fontsDir: "<%= yo.app %>/styles/fonts"
        # importPath: "<%= yo.vendor %>/foundation/scss"
        relativeAssets: true
      dev:
        options:
          debugInfo: true

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yo.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yo.dist %>/images"
        ]

    cssmin:
      dist:
        files:
          "<%= yo.dist %>/styles/main.css": [
            "<%= yo.build %>/styles/{,*/}*.css",
            "<%= yo.app %>/styles/{,*/}*.css"
          ]

    htmlmin:
      dist:
        removeCommentsFromCDATA: true
        # https://github.com/yeoman/grunt-usemin/issues/44
        collapseWhitespace: true
        collapseBooleanAttributes: true
        removeAttributeQuotes: true
        removeRedundantAttributes: true
        useShortDoctype: true
        removeEmptyAttributes: true
        removeOptionalTags: true
        files: [
          expand: true
          cwd: "<%= yo.app %>"
          src: ["*.html", "views/**/*.html"]
          dest: "<%= yo.dist %>"
        ]

    ngmin:
      dist:
        files: [
          expand: true,
          src: ["<%= yo.build %>/scripts/**/*.js"]
        ]

    requirejs:
      compile:
        options:
          name: "main"
          baseUrl: "<%= yo.build %>/scripts"
          mainConfigFile: "<%= yo.build %>/scripts/main.js"
          out: "<%= yo.dist %>/scripts/main.js"

    useminPrepare:
      html: "<%= yo.build %>/index.html"
      dest: "<%= yo.dist %>"

    usemin:
      html: ["<%= yo.dist %>/{,*/}*.html"]
      css: ["<%= yo.dist %>/styles/{,*/}*.{/}*.css"]

    rev:
      dist:
        files:
          src: [
            "<%= yo.dist %>/scripts/{,*/}*.js"
            "<%= yo.dist %>/styles/{,*/}*.css"
            "<%= yo.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
            "<%= yo.dist %>/styles/fonts/*"
          ]

    copy:
      build:
        files: [
            expand: true, dot: false, cwd: "<%= yo.app %>", dest: "<%= yo.build %>",
            src: [
              "index.html", "vendor/pure/**/*.css",
              "vendor/*/*.js", "vendor/json3/lib/*.js",
              "!vendor/**/*.min.js", "!vendor/**/Gruntfile.js"
            ]
        ]
      test:
        files: [
          expand: true, dot: false, cwd: "<%= yo.app %>", dest: "<%= yo.build %>",
          src: [
            "vendor/*/*.js", "vendor/json3/lib/*.js",
            "!vendor/**/*.min.js", "!vendor/**/Gruntfile.js",
          ]
        ]
      dist:
        files: [
            expand: true, dot: false, cwd: "<%= yo.app %>", dest: "<%= yo.dist %>",
            src: ["*.{ico,txt}", "images/{,*/}*.{gif,webp}", "styles/fonts/*", "vendor/requirejs/require.js"]
        ]

    karma:
      options:
        basePath: "<%= yo.build %>"
        configFile: "karma.conf.js"
      unit:
        background: true
        browsers: ['Chrome']
      ci:
        singleRun: true
        browsers: ["PhantomJS"]


  # just recreate changed coffee file
  changedFiles = Object.create(null);
  onChange = grunt.util._.debounce(->
    grunt.config 'coffee.build.src', Object.keys(changedFiles)
    changedFiles = Object.create(null);
  , 200);
  grunt.event.on 'watch', (action, filepath, target) ->
    if grunt.file.isMatch grunt.config('watch.coffee.files'), filepath
      filepath = filepath.replace( grunt.config('coffee.build.cwd')+'/', '' );
      changedFiles[filepath] = action;
      onChange();


  # compile coffeescript, scss
  grunt.registerTask "compile", ["coffee", "compass"]
  # build all stuff for development and ready for production
  grunt.registerTask "build", ["clean:build", "compile"]
  # build production stuff
  grunt.registerTask "min", ["useminPrepare", "imagemin", "concat", "cssmin", "htmlmin", "ngmin", "requirejs", "rev", "usemin"]

  # for travis, CI testing
  grunt.registerTask "ci", ["build", "copy:test", "karma:ci"]
  # run testing while there is any things be changed
  grunt.registerTask "autotest", ["karma:unit", "watch"]

  # setup development env, autocompile, livereload and open the browers.
  grunt.registerTask "dev", ["build", "connect:livereload", "open", "watch"]
  # simulate production env.
  grunt.registerTask "dist", ["clean:dist", "build", "copy:build", "min", "copy:dist", "connect:production", "open", "watch"]

  grunt.registerTask "default", ["dev"]
