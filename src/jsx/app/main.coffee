`/** @jsx React.DOM */`
define [
    "react",
    "backbone",
    "lodash",
    "app/n-back-app",
    "jquery",
    "jquery.joyride"
], (React, Backbone, _, App, $) ->
    content = document.getElementById "content"
    React.renderComponent `<App/>`, content

    $("#intro").joyride
        autoStart: true
        modal: true
        expose: true
        cookieMonster: true
        cookiePath: "/"