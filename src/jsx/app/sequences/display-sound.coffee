`/** @jsx React.DOM */`
define [
    "react"
    "Howler"
], (React, Howler) ->
    DisplaySound = React.createClass
        getInitialState: ->
            sound: null

        componentDidMount: ->
            @stream @props.element

        componentDidUpdate: ->
            @stream @props.element

        stream: (track) ->
            if @state.sound?
                @state.sound.stop()

            sound = new Howler.Howl
                urls: [track]
                buffer: true
                format: "mp3"
                sprite:
                    clip: [0, 800]

            sound.play "clip"
            @setState sound: sound

        shouldComponentUpdate: (nextProps, nextState) ->
            nextProps.element isnt @props.element or
            nextProps.current isnt @props.current

        render: ->
            `<div class="sound">{this.props.children}</div>`