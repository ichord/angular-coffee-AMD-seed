"use strict"
lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # configurable paths
  yeomanConfig =
    src: "src"
    vendors: "src/vendors"
    build: "build"
    dist: "dist"

  try
    yeomanConfig.src = require("./bower.json").appPath or yeomanConfig.src

  grunt.initConfig
    yo: yeomanConfig
    watch:
      options:
        livereload: true

      coffee:
        files: ["<%= yo.src %>/scripts/{,*/}*.coffee"]
        tasks: ["coffee:build"]

      coffeeTest:
        files: ["test/spec/{,*/}*.coffee"]
        tasks: ["coffee:test", "karma:unit:run"]

      compass:
        files: ["<%= yo.src %>/styles/{,*/}*.{scss,sass}"]
        tasks: ["compass"]

      statics:
        files: ["<%= yo.src %>/{,*/}*.html", "<%= yo.src %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"]

    connect:
      options:
        port: 9000
        # Change this to '0.0.0.0' to access the server from outside.
        hostname: "localhost"

      livereload:
        options:
          middleware: (connect) ->
            [lrSnippet, mountFolder(connect, yeomanConfig.build), mountFolder(connect, yeomanConfig.src)]

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
      build:
        files: [
          expand: true
          cwd: "<%= yo.src %>/scripts"
          src: "{,*/}*.coffee"
          dest: "<%= yo.build %>/scripts"
          ext: ".js"
        ]
      test:
        files: [
          expand: true
          cwd: "test"
          src: "**/{,*/}*.coffee"
          dest: "<%= yo.build %>"
          ext: ".js"
        ]

    compass:
      options:
        sassDir: "<%= yo.src %>/styles"
        cssDir: "<%= yo.build %>/styles"
        imagesDir: "<%= yo.src %>/images"
        javascriptsDir: "<%= yo.src %>/scripts"
        fontsDir: "<%= yo.src %>/styles/fonts"
        importPath: "<%= yo.vendors %>/foundation/scss"
        relativeAssets: true
      server:
        options:
          debugInfo: true

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yo.src %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yo.dist %>/images"
        ]

    cssmin:
      dist:
        files:
          "<%= yo.dist %>/styles/main.css": ["<%= yo.build %>/styles/{,*/}*.css", "<%= yo.src %>/styles/{,*/}*.css"]

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
          cwd: "<%= yo.src %>"
          src: ["*.html", "views/*.html"]
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
      html: "<%= yo.src %>/index.html"
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
          expand: true, dot: true, cwd: "<%= yo.src %>", dest: "<%= yo.build %>",
          src: ["vendors/*/*.js", "!vendors/**/*.min.js"]
        ]
      dist:
        files: [
            expand: true, cwd: "<%= yo.src %>", dest: "<%= yo.dist %>",
            src: ["*.{ico,txt}", "images/{,*/}*.{gif,webp}", "styles/fonts/*", "vendors/requirejs/require.js"]
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


  # compile coffeescript, scss
  grunt.registerTask "compile", ["coffee", "compass"]
  # build all stuff for development and ready for production
  grunt.registerTask "build", ["clean:build", "compile", "copy:build"]
  # build production stuff
  grunt.registerTask "dist", ["imagemin", "cssmin", "htmlmin", "ngmin", "requirejs", "rev", "usemin"]
  # for travis, CI testing
  grunt.registerTask "ci", ["build", "karma:ci"]
  # run testing while there is any things be changed
  grunt.registerTask "autotest", ["build", "karma:unit", "watch"]
  # setup development env, autocompile, livereload and open the browers.
  grunt.registerTask "development", ["build", "connect:livereload", "open", "watch"]
  # simulate production env.
  grunt.registerTask "production", ["clean:dist", "build", "dist", "connect:production", "open", "watch"]

  grunt.registerTask "default", ["build"]
