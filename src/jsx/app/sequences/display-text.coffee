`/** @jsx React.DOM */`
define [
    "react"
], (React) ->
    TextDisplay = React.createClass

        render: ->
            `<span>{this.props.element}</span>`