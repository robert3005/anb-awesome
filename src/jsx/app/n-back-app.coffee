`/** @jsx React.DOM */`
define [
    "react",
    "jquery",
    "app/sequences/display-sequence"
], (React, $, DisplaySequence) ->
    NBackApp = React.createClass
        getInitialState: ->
            return started: no

        start: (type) ->
            if not this.state.started
                this.refs.displaySeq.start(type)
                this.setState started: yes
            $(this.refs[type].getDOMNode()).blur()

        stop: ->
            if this.state.started
                this.refs.displaySeq.stop()
                this.setState started: no

        render: ->
            return `<div class="main">
                <div class="row">
                    <div class="col-lg-4">
                        <div class="instructions lead">
                            <p>Use &larr; to indicate a match</p>
                            <p>and &rarr; for lack of it</p>
                        </div>
                    </div>
                    <div class="col-lg-8">
                        <div class="row">
                            <div class="col-lg-6">
                                <button type="button"
                                    ref="letters"
                                    onClick={this.start.bind(this, "letters")}
                                    class="btn btn-transparent btn-large btn-block">
                                        Letters
                                </button>
                            </div>
                            <div class="col-lg-6">
                                <button type="button"
                                    ref="numbers"
                                    onClick={this.start.bind(this, "numbers")}
                                    class="btn btn-transparent btn-large btn-block">
                                        Numbers
                                </button>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-6">
                                <button type="button"
                                    ref="words"
                                    onClick={this.start.bind(this, "words")}
                                    class="btn btn-transparent btn-large btn-block">
                                        Words
                                </button>
                            </div>
                            <div class="col-lg-6"></div>
                        </div>
                    </div>
                </div>
                <DisplaySequence ref="displaySeq" />
                <div class="row stop" style={{display: !this.state.started ? "none" : ""}}>
                    <div class="col-lg-12">
                        <button type="button" onClick={this.stop}
                            class="btn btn-transparent btn-large btn-block">
                                Stop
                        </button>
                    </div>
                </div>
            </div>`
