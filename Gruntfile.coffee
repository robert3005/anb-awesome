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
                    bare: true
                files: [{
                    expand: true
                    cwd: "src/coffee/"
                    src: ["**/*.coffee"]
                    dest: "public/js"
                    ext: ".js"
                }]
            jsx:
                options:
                    sourceMap: false
                    bare: true
                files: [{
                    expand: true
                    cwd: "src/jsx"
                    src: ["**/*.coffee"]
                    dest: "build"
                    ext: ".jsx"
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

        bgShell:
            _defaults:
                bg: false
            watch:
                cmd: "grunt watch"
                bg: true
            server:
                cmd: "./node_modules/.bin/coffee server/init.coffee"
            jsx:
                cmd: "./node_modules/.bin/jsx -x jsx build/ public/js"

        watch:
            server:
                files: ["server/**/*.coffee"]
                tasks: ["coffeelint:server"]
            styl:
                files: ["src/stylus/**/*.styl"]
                tasks: ["stylus"]
            coffee:
                files: ["src/coffee/**/*.coffee",]
                tasks: ["coffeelint:app", "coffee"]
            jsx:
                files: ["build/jsx/**/*.jsx"]
                tasks: ["coffeelint:app", "bgShell:jsx"]
            reload:
                files: ["public/js/**", "public/css/**"]
                options:
                    livereload: true


        grunt.loadNpmTasks "grunt-coffeelint"
        grunt.loadNpmTasks "grunt-bg-shell"
        grunt.loadNpmTasks "grunt-contrib-coffee"
        grunt.loadNpmTasks "grunt-contrib-stylus"
        grunt.loadNpmTasks "grunt-contrib-watch"

        grunt.registerTask "build", ["coffeelint", "coffee", "stylus", "bgShell:jsx"]
        grunt.registerTask "default", ["bgShell:watch", "bgShell:server"]