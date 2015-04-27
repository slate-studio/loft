module.exports = (grunt) ->
  # Project configuration
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffee:
      compileBare:
        options:
          bare: true
        files:
          'build/loft.js': [
            # core
            'app/assets/javascripts/loft/group-actions.coffee'
            'app/assets/javascripts/loft/asset-item.coffee'
            'app/assets/javascripts/loft/module.coffee'
            # redactor
            'app/assets/javascripts/loft/redactor-loft.coffee'
            # inputs
            'app/assets/javascripts/loft/input-loft-asset.coffee'
            'app/assets/javascripts/loft/input-loft-image.coffee'
          ]

    concat:
      loft:
        src: [
          'build/loft.js'
        ]
        dest: 'dist/loft.js'

    clean: [
      'build'
    ]

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-clean')

  grunt.registerTask('default', ['coffee', 'concat', 'clean'])




