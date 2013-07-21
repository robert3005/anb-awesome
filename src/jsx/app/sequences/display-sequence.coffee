`/** @jsx React.DOM */`
define [
    "react",
    "jquery",
    "lodash",
    "app/sequences/sequenceOf"
    "app/sequences/display-text"
    "app/sequences/display-image"
], (React, $, _, SequenceFactory, DisplayText, DisplayImage) ->
    SequenceDisplay = React.createClass
        getInitialState: ->
            return {
                current: null
                factory: null
                type: null
                nback: 1
            }

        componentDidMount: ->
            window.addEventListener "keydown", this.userClick

        componentWillUnmount: ->
            window.removeEventListener "keydown", this.userClick

        start: (type, nback) ->
            factory = SequenceFactory[type]()
            this.setState
                factory: factory
                type: type
                nback: nback

            @progress factory

        progress: (factory) ->
            $current = $ this.refs.current.getDOMNode()
            $current.animate {
                marginLeft: -9999
            }, {
                duration: 500
                complete: =>
                    $current.css
                        "margin-left": 0
                        "margin-right": -9999
                    this.setState current: factory.next()
            }

            $current.animate {
                marginRight: 0
            }, {
                duration: 200
            }

        displayResult: (correct) ->
            if correct
                colour = "rgba(137,185,8, 0.6)"
            else
                colour = "rgba(195,2,2,0.6)"

            $node = $ this.getDOMNode()
            $node.css "background-color": colour
            $node.on "transitionend", ->
                $node.attr "style", ""
                $node.off "transitionend"

        userClick: (ev) ->
            if ev.keyCode is 37 or ev.keyCode is 74
                @displayResult(this.state.factory.matchBackN(this.state.nback) is yes)
                @progress this.state.factory

            else if ev.keyCode is 39 or ev.keyCode is 75
                @displayResult((not this.state.factory.matchBackN(this.state.nback)) is yes)
                @progress this.state.factory

        reset: ->
            this.setState
                current: null
                type: null
                nback: 1

        render: ->
            classes = "current-element": yes
            classes[this.state.type] = yes

            seqClasses =
                sequence: yes
                empty: not (this.state.current?)


            classFromObj = (obj) ->
                _(obj).map((isSet, cssClass) ->
                    if isSet then cssClass else null
                ).filter().value().join " "

            if this.state.type is "images"
                element = `<DisplayImage element={this.state.current} />`
            else if this.state.type is "sounds"
                element = `<PlaySound element={this.state.current} />`
            else
                element = `<DisplayText element={this.state.current} />`


            return `<div class={classFromObj(seqClasses)}>
                <div class="row">
                    <div class="col-lg-12">
                        <div ref="current" class={classFromObj(classes)}>
                            {element}
                        </div>
                    </div>
                </div>
            </div>`