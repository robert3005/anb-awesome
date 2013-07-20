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
            this.refs.displaySeq.start(type)
            this.setState started: yes

        stop: ->
            this.refs.displaySeq.stop()

        render: ->
            return `<div class="main">
                <div class="row">
                    <div class="col-lg-6">
                        <button type="button"
                            onClick={this.start.bind(this, "letters")}
                            class="btn btn-transparent btn-large btn-block">
                                Letters
                        </button>
                    </div>
                    <div class="col-lg-6">
                        <button type="button"
                            onClick={this.start.bind(this, "numbers")}
                            class="btn btn-transparent btn-large btn-block">
                                Numbers
                        </button>
                    </div>
                </div>
                <DisplaySequence ref="displaySeq" />
                <div class="row">
                    <div class="col-lg-12">
                        <button type="button" onClick={this.stop}
                            class="btn btn-transparent btn-large btn-block">
                                Stop
                        </button>
                    </div>
                </div>
            </div>`
