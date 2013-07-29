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
        tasks: ['coffee']

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
  grunt.registerTask 'production', ['default', 'clean:sourceMaps']
  grunt.registerTask 'default', ['cs', 'less:prod']
  grunt.registerTask 'heroku', ['default']
