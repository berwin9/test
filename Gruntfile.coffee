module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    watch:
      grunt:
        files: ['Gruntfile.coffee', 'package.json']
        tasks: 'default'

    coffee:
      options:
        sourceMap: true
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

    exec:
      copyCoffee:
        command: 'mkdir -p public/coffee; cp -R src/client/coffee/ public/coffee/'

    clean:
      js: 'src/server/public/js/*'
      sourceMaps: ['src/server/public/coffee', 'src/server/public/js/app.map']

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-exec'

  grunt.registerTask 'cs', ['exec:copyCoffee', 'coffee', 'concat:js']
  grunt.registerTask 'production', ['default', 'clean:sourceMaps']
  grunt.registerTask 'default', ['cs']
