`/** @jsx React.DOM */`
define [
    "react"
    "jquery"
    "button"
], (React, $) ->
    ButtonToggle = React.createClass
        componentDidMount: ->
            $(@getDOMNode()).button()

        toggle: ->
            $(@getDOMNode()).button("toggle")
            $(@getDOMNode()).blur()
            if @props.toggle?
                @props.toggle()

        render: ->
            return `<button type="button"
                onClick={this.toggle}
                class="btn btn-default btn-large btn-block">
                    {this.props.children}
            </button>`