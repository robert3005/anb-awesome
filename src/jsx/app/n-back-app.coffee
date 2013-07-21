`/** @jsx React.DOM */`
define [
    "react",
    "jquery",
    "app/sequences/display-sequence",
    "bootstrap-slider"
], (React, $, DisplaySequence) ->
    NBackApp = React.createClass
        getInitialState: ->
            return started: no

        componentDidMount: ->
            $(this.refs.slider.getDOMNode()).slider
                min: 1
                max: 20

        start: (type) ->
            if not this.state.started
                nback = $(this.refs.slider.getDOMNode()).data('slider').getValue()
                this.refs.displaySeq.start type, nback
                this.setState started: yes
            $(this.refs[type].getDOMNode()).blur()

        reset: ->
            if this.state.started
                this.refs.displaySeq.reset()
                this.setState started: no

        render: ->
            return `<div class="main">
                <div class="row">
                    <div class="col-lg-4">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="instructions lead">
                                    <p>Use &larr; or j to indicate a match</p>
                                    <p>and &rarr; or k for lack of it</p>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12" id="slider">
                                <input type="text" ref="slider"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-8" id="controls">
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
                            <div class="col-lg-6">
                                <button type="button"
                                    ref="images"
                                    onClick={this.start.bind(this, "images")}
                                    class="btn btn-transparent btn-large btn-block">
                                        Images
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <DisplaySequence ref="displaySeq" />
                <div class="row reset" style={{display: !this.state.started ? "none" : ""}}>
                    <div class="col-lg-12">
                        <button type="button" onClick={this.reset}
                            class="btn btn-transparent btn-large btn-block">
                                Reset
                        </button>
                    </div>
                </div>
            </div>`
