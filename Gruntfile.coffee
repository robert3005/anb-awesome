module.exports = (grunt) ->
    grunt.initConfig
        coffeelint:
            options: grunt.file.readJSON "coffeelint.json"
            app: ["src/coffee/**/*.coffee"]
            server: ["server/**/*.coffee"]

        coffee:
            client:
                options:
                    sourceMap: true
                files: [{
                    expand: true
                    cwd: "src/coffee/"
                    src: ["**/*.coffee"]
                    dest: "public/js/"
                    ext: ".js"
                }]

        stylus:
            development:
                options:
                    paths: ["src/stylus"]
                files: [{
                    expand: true
                    cwd: "src/stylus/"
                    src: ["**/*.styl"]
                    dest: "public/css/"
                    ext: ".css"
                }]

        jade:
            development:
                options:
                    pretty: true
                    client: true
                files: [{
                    expand: true
                    cwd: 'src/jade/'
                    src: ["**/*.jade"]
                    dest: "public/js/app/views/"
                }]

        bgShell:
            _defaults:
                bg: true
            watch:
                cmd: "grunt watch"
            server:
                cmd: "./node_modules/.bin/coffee server/init.coffee"
                bg: false

        watch:
            styl:
                files: ["src/stylus/**/*.styl"]
                tasks: ["stylus"]
            coffee:
                files: ["src/coffee/**/*.coffee"]
                tasks: ["coffeelint", "coffee"]
            jade:
                files: ["src/jade/**/*.jade"]
                tasks: ["jade"]
            reload:
                files: ["public/js/**", "public/css/**"]
                options:
                    livereload: true


        grunt.loadNpmTasks "grunt-coffeelint"
        grunt.loadNpmTasks "grunt-bg-shell"
        grunt.loadNpmTasks "grunt-contrib-coffee"
        grunt.loadNpmTasks "grunt-contrib-jade"
        grunt.loadNpmTasks "grunt-contrib-stylus"
        grunt.loadNpmTasks "grunt-contrib-watch"

        grunt.registerTask "build", ["coffeelint", "coffee", "stylus", "jade"]
        grunt.registerTask "default", ["bgShell"]