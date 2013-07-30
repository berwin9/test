module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    watch:
      grunt:
        files: ['Gruntfile.coffee', 'package.json']
        tasks: 'default'

    coffee:
      options:
        sourceMap: false
      compile:
        files:
          'src/server/public/js/app.js': ['src/client/coffee/**/*.coffee']
      clientSpecs:
        files: grunt.file.expandMapping(["specs/client/*.coffee"], "specs/client/js/", {
          rename: (destBase, destPath) ->
            destBase + destPath.replace(/\.coffee$/, ".js").replace(/specs\//, "")
        })

    concat:
      js:
        src: ['src/client/js/libs/*.js']
        dest: 'src/server/public/js/libs.js'

    uglify:
      dev:
        options:
          sourceMap: 'src/server/public/js/source.map'
          sourceMapRoot: 'http://localhost:5000'
          sourceMappingURL: '/js/source.map'
        files: 'src/server/public/js/app.min.js': ['src/server/public/js/client.js']
      prod:
        files:
          'src/server/public/js/app.min.js': ['src/server/public/js/client.js']

    copy:
      coffee:
        files: [
          expand: true
          cwd: "src/client"
          src: ["coffee/*.*"]
          dest: "public"
        ]

    clean:
      js: 'src/server/public/js/*'
      sourceMaps: ['src/server/public/coffee', 'src/server/public/js/app.map']

    less:
      prod:
        options:
          yuicompress: true
        files:
          'src/server/public/styles/app.css': [
            'src/client/styles/bootstrap/bootstrap.less'
            'src/client/styles/flatui/flat-ui.less'
          ]

    coffeelint:
      options:
        max_line_length: 120
      app: [
        'src/server/**/*.coffee'
        'src/client/coffee/**/*.coffee'
      ]

    regarde:
      coffee:
        files: ['src/client/coffee/**/*.coffee']
        tasks: ['cs']
      less:
        files: ['src/client/styles/**/*.less']
        tasks: ['less:prod']
      test:
        files: ['specs/client/*.coffee']
        tasks: ['test', 'karma:unit']

    karma:
      options:
        configFile: './config/karma.conf.js'
        runnerPort: 9999
        reporters: ['dots']
        colors: true
      e2e:
        configFile: './config/karma-e2e.conf.js'
        singleRun: true
        autoWatch: true
      e2elive:
        configFile: './config/karma-e2e.conf.js'
      unit:
        singleRun: true
      dev:
        autoWatch: true
        browsers: ['Chrome']

    karma:
      options:
        configFile: './config/karma.conf.js',
        runnerPort: 9999,
        reporters: ['dots']
        colors: true
      e2e:
        configFile: './config/karma-e2e.conf.js',
        singleRun: true,
        autoWatch: true
      e2elive:
        configFile: './config/karma-e2e.conf.js'
      unit:
        singleRun: true
      dev:
        autoWatch: true,
        browsers: ['Chrome']

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-regarde'
  grunt.loadNpmTasks 'grunt-karma'

  grunt.registerTask 'cs', ['copy:coffee', 'coffee', 'concat:js']
  grunt.registerTask 'test', ['default', 'clean:sourceMaps', 'coffee:clientSpecs']
  grunt.registerTask 'production', ['default', 'clean:sourceMaps']
  grunt.registerTask 'default', ['cs', 'less:prod']
  grunt.registerTask 'heroku', ['default']
