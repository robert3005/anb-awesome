requirejs.config
    baseUrl: "/js/lib"
    paths:
        app: "../app",
        jquery: "//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min"

    shim:
        lodash:
            exports: "_"
        react:
            exports: "React"
        backbone:
            deps: ["jquery", "lodash"]
            exports: "Backbone"


requirejs ["app/main"]
