requirejs.config
    baseUrl: "/public/js/lib"
    paths:
        app: "../app",
        jquery: "//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min"

    shim:
        lodash:
            exports: "_"
        react: ["es5-shim"]
        backbone:
            deps: ["jquery", "lodash"]
            exports: "Backbone"


requirejs ["app/main"]
