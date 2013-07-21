`/** @jsx React.DOM */`
define [
    "react"
], (React) ->
    DisplayImage = React.createClass

        render: ->
            `<img height="400" src={this.props.element} />`