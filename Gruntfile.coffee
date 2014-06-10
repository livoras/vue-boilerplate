module.exports = (grunt)->

  coffeeify = require 'coffeeify'
  stringify = require 'stringify'

  grunt.initConfig
    connect:
      server:
        options:
          port: 3000
          base: '.'

    clean: 
      bin: ['bin']

    browserify: 
      common:
        options:
          preBundleCB: (b)->
            b.transform(coffeeify)
            b.transform(stringify({extensions: ['.hbs', '.html', '.tpl', '.txt']}))
        expand: true
        flatten: true
        src: ['src/common/common.coffee']
        dest: 'bin/js/'
        ext: '.js'

      components: 
        options:
          preBundleCB: (b)->
            b.transform(coffeeify)
            b.transform(stringify({extensions: ['.hbs', '.html', '.tpl', '.txt']}))
        expand: true
        flatten: true
        src: ['src/components/**/*.coffee']
        dest: 'bin/js/components/'
        ext: '.js'

    watch:
      compile:
        options:
          livereload: true
        files: ["src/**/*.coffee", "src/**/*.less", "src/**/*.hbs"]
        tasks: ["browserify", "less:dev", "concat:less"]

    less:    
      dev:
        expand: true
        flatten: true
        cwd: 'src/'
        src: ['**/*.less']
        dest: 'bin/css/'
        ext: '.css'

      build:
        options:
          compress: true
        expand: true
        flatten: true
        cwd: 'src/'
        src: ['**/*.less']
        dest: 'bin/css/'
        ext: '.css'

    uglify:
      build:
        expand: true
        cwd: 'bin/js/'
        src: '**/*.js'
        dest: 'bin/js/'

    concat:    
      less:
        options:
          separator: '/*========================*/'
        src: ['bin/css/**/*.css']  
        dest: 'bin/style.css'

  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-browserify"
  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-concat"

  grunt.registerTask "default", ->
    grunt.task.run [
      "connect"
      "clean:bin"
      "browserify"
      "less:dev"
      "concat:less"
      "watch"
    ]

  grunt.registerTask "build", ['clean:bin', 'browserify', 'less:build', 'uglify']
