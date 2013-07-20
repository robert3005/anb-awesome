`/** @jsx React.DOM */`
define [
    "react",
    "backbone",
    "lodash",
    "app/n-back-app"
], (React, Backbone, _, App) ->
    content = document.getElementById "content"
    React.renderComponent `<App/>`, content