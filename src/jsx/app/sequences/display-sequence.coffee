`/** @jsx React.DOM */`
define [
    "react",
    "jquery",
    "lodash",
    "app/sequences/sequenceOf"
], (React, $, _, SequenceFactory) ->
    SequenceDisplay = React.createClass
        getInitialState: ->
            return {
                current: null
                factory: null
                timeoutId: null
            }

        start: (type) ->
            factory = SequenceFactory[type]()
            this.setState factory: factory
            @progress()
            @animateProgressBar()

        animateProgressBar: ->
            $progress = $ this.refs.progress.getDOMNode()
            $progress.animate {
                width: "100%"
            }, {
                duration: 2000
                complete: ->
                    $progress.css width: "0"
            }

        progress: ->
            timeoutID = setTimeout =>
                this.setState current: this.state.factory.next()
                @animateProgressBar()
                @progress()
            , 2000

            this.setState timeoutId: timeoutID

        stop: ->
            clearTimeout this.state.timeoutId
            $(this.refs.progress.getDOMNode()).stop(yes, yes)
            this.setState
                current: null
                timeoutId: null

        render: ->
            return `<div class="sequence">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="current-element">{this.state.current}</div>
                    </div>
                </div>
                <div class="progress">
                    <div class="progress-bar transparent" ref="progress" style={{width: "0"}}></div>
                </div>
            </div>`