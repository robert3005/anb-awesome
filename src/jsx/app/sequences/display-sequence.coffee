`/** @jsx React.DOM */`
define [
    "react",
    "jquery",
    "lodash",
    "app/sequences/sequence-of"
    "app/sequences/display-text"
    "app/sequences/display-image"
    "app/sequences/display-sound"
    "app/sequences/display-grid"
], (React, $, _, SequenceFactory, DisplayText, DisplayImage,
    DisplaySound, DisplayGrid) ->
    SequenceDisplay = React.createClass
        getInitialState: ->
            return {
                current: null
                soundCurrent: null
                factory: null
                sound: null
                type: null
                nback: 1
                currentCorrect: no
                soundCorrect: no
            }

        componentDidMount: ->
            window.addEventListener "keydown", this.userClick

        componentWillUnmount: ->
            window.removeEventListener "keydown", this.userClick

        start: (type, sound, nback) ->
            factory = SequenceFactory[type]()
            if sound
                soundFactory = SequenceFactory["sounds"]()
            this.setState
                factory: factory
                type: type
                nback: nback
                sound: soundFactory

            @progress factory, soundFactory

        progress: (factory, soundFactory) ->
            $current = $ this.refs.current.getDOMNode()
            $current.animate {
                marginLeft: -9999
            }, {
                duration: 500
                complete: =>
                    $current.css
                        "margin-left": 0
                        "margin-right": -9999
                    this.setState
                        currentCorrect: no
                        soundCorrect: no
                        current: factory.next()
                        soundCurrent: if soundFactory? then soundFactory.next() else null
            }

            $current.animate {
                marginRight: 0
            }, {
                duration: 200
            }

        displayMainResult: (correct) ->
            $node = $ this.getDOMNode()
            $node.on "transitionend", ->
                $node.attr "style", ""
                $node.off "transitionend"

            if correct
                colour = "rgba(137,185,8, 0.6)"
            else
                colour = "rgba(195,2,2,0.6)"

            $node.css "background-color": colour

        displaySoundResult: (correct) ->
            $body = $ "body"
            $body.on "transitionend", ->
                $body.removeClass "sound-wrong sound-correct"
                $body.off "transitionend"

            if correct
                $body.addClass "sound-correct"
            else
                $body.addClass "sound-wrong"

        match: (factory, correct) ->
            match = factory.matchBackN(this.state.nback)
            if correct then match is yes else match is no

        withSoundValidator: (ev) ->
            if ev.keyCode in [37,38,39,40,65,74,75,83]
                [factory, match] = switch ev.keyCode
                    # Left arrow
                    when 37 then [this.state.factory, yes]
                    # Up arrow
                    when 38 then [this.state.sound, yes]
                    # Right arrow
                    when 39 then [this.state.factory, no]
                    # Bottom arrow
                    when 40 then [this.state.sound, no]
                    # A
                    when 65 then [this.state.sound, yes]
                    # J
                    when 74 then [this.state.factory, yes]
                    # K
                    when 75 then [this.state.factory, no]
                    # S
                    when 83 then [this.state.sound, no]


                correct = @match factory, match
                if not correct
                    if factory is this.state.factory
                        @displayMainResult no
                    else
                        @displaySoundResult no

                    @progress this.state.factory, this.state.sound
                else
                    if factory is this.state.factory
                        this.setState currentCorrect: yes
                        @displayMainResult yes
                    else
                        this.setState soundCorrect: yes
                        @displaySoundResult yes

                    if this.state.soundCorrect and this.state.currentCorrect
                        @progress this.state.factory, this.state.sound

        withoutSoundValidator: (ev) ->
            if ev.keyCode in [37,39,74,75]
                [factory, match] = switch ev.keyCode
                    # Left arrow
                    when 37 then [this.state.factory, yes]
                    # Right arrow
                    when 39 then [this.state.factory, no]
                    # J
                    when 74 then [this.state.factory, yes]
                    # K
                    when 75 then [this.state.factory, no]

                correct = @match factory, match
                @displayMainResult correct
                @progress this.state.factory, this.state.sound

        userClick: (ev) ->
            if this.state.sound?
                @withSoundValidator ev
            else
                @withoutSoundValidator ev


        reset: ->
            this.setState
                current: null
                soundCurrent: null
                type: null
                nback: 1
                currentCorrect: no
                soundCorrect: no

        shouldComponentUpdate: (nextProps, nextState) ->
            console.log nextState, this.state
            this.state.current isnt nextState.current or
            this.state.soundCurrent isnt nextState.soundCurrent

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
            if this.state.type is "grids"
                element = `<DisplayGrid element={this.state.current} />`
            else
                element = `<DisplayText element={this.state.current} />`

            if this.state.soundCurrent?
                soundElem = `<DisplaySound element={this.state.soundCurrent}
                    current={this.state.current} >
                    {this.state.soundCurrent}
                </DisplaySound>`

            return `<div class={classFromObj(seqClasses)}>
                {soundElem}
                <div class="row">
                    <div class="col-lg-12">
                        <div ref="current" class={classFromObj(classes)}>
                            {element}
                        </div>
                    </div>
                </div>
            </div>`