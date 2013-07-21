`/** @jsx React.DOM */`
define [
    "react"
    "Howler"
], (React, Howler) ->
    DisplaySound = React.createClass
        getInitialState: ->
            sound: null

        componentDidMount: ->
            this.stream this.props.element

        componentDidUpdate: ->
            this.stream this.props.element

        stream: (track) ->
            if this.state.sound?
                this.state.sound.stop()

            sound = new Howler.Howl
                urls: [track]
                buffer: true
                format: "mp3"
                sprite:
                    clip: [0, 800]

            sound.play "clip"
            this.setState sound: sound

        shouldComponentUpdate: (nextProps, nextState) ->
            nextProps.element isnt this.props.element or
            nextProps.current isnt this.props.current

        render: ->
            `<div class="sound">{this.props.children}</div>`