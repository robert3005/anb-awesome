`/** @jsx React.DOM */`
define [
    "react"
    "jquery"
    "button"
], (React, $) ->
    ButtonToggle = React.createClass
        componentDidMount: ->
            $(this.getDOMNode()).button()

        toggle: ->
            $(this.getDOMNode()).button("toggle")
            $(this.getDOMNode()).blur()
            if this.props.toggle?
                this.props.toggle()

        render: ->
            return `<button type="button"
                onClick={this.toggle}
                class="btn btn-default btn-large btn-block">
                    {this.props.children}
            </button>`