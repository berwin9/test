module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    watch:
      grunt:
        files: ['Gruntfile.coffee', 'package.json']
        tasks: 'default'
