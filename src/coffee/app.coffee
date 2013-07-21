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
        "bootstrap-slider": ["jquery"]
        "jquery.cookie": ["jquery"]
        "jquery.joyride": ["jquery", "jquery.cookie"]
        button: ["jquery"]
        grid:
            exports: "Grid"

requirejs ["app/main"]
