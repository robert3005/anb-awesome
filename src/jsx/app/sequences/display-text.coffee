`/** @jsx React.DOM */`
define [
    "react"
], (React) ->
    DisplayText = React.createClass

        render: ->
            `<span>{this.props.element}</span>`