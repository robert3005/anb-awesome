`/** @jsx React.DOM */`
define [
    "react"
], (React) ->
    ImageDisplay = React.createClass

        render: ->
            `<img height="400" src={this.props.element} />`