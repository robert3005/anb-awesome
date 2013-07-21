`/** @jsx React.DOM */`
define [
    "react"
    "jquery"
    "lodash"
    "moment"
    "app/sequences/sequence-of"
    "app/sequences/display-text"
    "app/sequences/display-image"
    "app/sequences/display-sound"
    "app/sequences/display-grid"
], (React, $, _, moment, SequenceFactory, DisplayText, DisplayImage,
    DisplaySound, DisplayGrid) ->
    SequenceDisplay = React.createClass
        getInitialState: ->
            current: null
            soundCurrent: null
            factory: null
            sound: null
            type: null
            nback: 1
            currentCorrect: no
            soundCorrect: no
            interval: no
            start: no
            currentStreak: 0
            longestStreak: 0
            answered: 0
            duration: 0

        componentDidMount: ->
            window.addEventListener "keydown", @userClick

        componentWillUnmount: ->
            window.removeEventListener "keydown", @userClick

        start: (type, sound, nback) ->
            factory = SequenceFactory[type]()
            soundFactory = SequenceFactory["sounds"]() if sound
            if not @state.start
                @setState start: moment()
            interval = setInterval =>
                $(@refs.duration.getDOMNode()).text(
                    moment().diff(@state.start, "seconds") + "s")
            , 1000

            @setState
                factory: factory
                type: type
                nback: nback
                sound: soundFactory
                interval: interval

            @progress factory, soundFactory

        progress: (factory, soundFactory) ->
            @updateStreaks()
            $current = $ @refs.current.getDOMNode()
            $current.animate {
                marginLeft: -9999
            }, {
                duration: 500
                complete: =>
                    $current.css
                        "margin-left": 0
                        "margin-right": -9999
                    @setState
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
            $node = $ @refs.wrapper.getDOMNode()
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
            match = factory.matchBackN(@state.nback)
            if correct then match is yes else match is no

        updateStreaks: ->
            if @state.current?
                $.post "/record",
                    user: window.userID
                    correct: @state.currentCorrect
                    soundCorrect: @state.soundCorrect
                    history: @state.factory?.generated
                    soundHistory: @state.sound?.generated
                    nback: @state.nback
                    date: moment().valueOf()
                , (data) ->
                    console.log data

            currentStreak = @state.currentStreak
            longestStreak = @state.longestStreak

            console.log @state.currentCorrect, @state.soundCorrect
            if @state.currentCorrect
                if @state.sound?
                    if @state.soundCorrect
                        currentStreak++
                    else
                        currentStreak = 0
                else
                    currentStreak++
            else
                currentStreak = 0

            if currentStreak > longestStreak
                longestStreak = currentStreak

            @setState
                answered: @state.factory?.size()
                longestStreak: longestStreak
                currentStreak: currentStreak

        withSoundValidator: (ev) ->
            if ev.keyCode in [37,38,39,40,65,74,75,83]
                [factory, match] = switch ev.keyCode
                    # Left arrow
                    when 37 then [@state.factory, yes]
                    # Up arrow
                    when 38 then [@state.sound, yes]
                    # Right arrow
                    when 39 then [@state.factory, no]
                    # Bottom arrow
                    when 40 then [@state.sound, no]
                    # A
                    when 65 then [@state.sound, yes]
                    # J
                    when 74 then [@state.factory, yes]
                    # K
                    when 75 then [@state.factory, no]
                    # S
                    when 83 then [@state.sound, no]


                correct = @match factory, match
                if not correct
                    if factory is @state.factory
                        @displayMainResult no
                    else
                        @displaySoundResult no

                    @progress @state.factory, @state.sound
                else
                    if factory is @state.factory
                        @setState currentCorrect: yes
                        @displayMainResult yes
                    else
                        @setState soundCorrect: yes
                        @displaySoundResult yes

                    if @state.soundCorrect and @state.currentCorrect
                        @progress @state.factory, @state.sound

        withoutSoundValidator: (ev) ->
            if ev.keyCode in [37,39,74,75]
                [factory, match] = switch ev.keyCode
                    # Left arrow
                    when 37 then [@state.factory, yes]
                    # Right arrow
                    when 39 then [@state.factory, no]
                    # J
                    when 74 then [@state.factory, yes]
                    # K
                    when 75 then [@state.factory, no]

                correct = @match factory, match
                @setState currentCorrect: correct
                @displayMainResult correct
                @progress @state.factory, @state.sound

        userClick: (ev) ->
            if @state.sound?
                @withSoundValidator ev
            else
                @withoutSoundValidator ev


        reset: ->
            clearInterval @state.interval
            @setState @getInitialState()

        shouldComponentUpdate: (nextProps, nextState) ->
            @state.current isnt nextState.current or
            @state.soundCurrent isnt nextState.soundCurrent or
            @state.answered isnt nextState.answered

        render: ->
            classes =
                "current-element": yes
            classes[@state.type] = yes

            seqClasses =
                sequence: yes
                empty: not (@state.current?)

            classFromObj = (obj) ->
                _(obj).map((isSet, cssClass) ->
                    if isSet then cssClass else null
                ).filter().value().join " "

            if @state.type is "images"
                element = `<DisplayImage element={this.state.current} />`
            else if @state.type is "grids"
                element = `<DisplayGrid element={this.state.current} />`
            else
                element = `<DisplayText element={this.state.current} />`

            if @state.soundCurrent?
                soundElem = `<DisplaySound element={this.state.soundCurrent}
                    current={this.state.current} >
                    {this.state.soundCurrent}
                </DisplaySound>`

            return `<div class="game">
                <div class="stats" style={{display: !this.state.factory ? "none" : ""}}>
                    <div class="row">
                        <div class="col-lg-3">
                            <span>Duration</span>
                            <span ref="duration" class="statistic label label-success">
                                {this.state.duration}s
                            </span>
                        </div>
                        <div class="col-lg-3">
                            <span>Current Streak</span>
                            <span class="statistic label label-success">
                                {this.state.currentStreak}
                            </span>
                        </div>
                        <div class="col-lg-3">
                            <span>Longest Streak</span>
                            <span class="statistic label label-success">
                                {this.state.longestStreak}
                            </span>
                        </div>
                        <div class="col-lg-3">
                            <span>Done</span>
                            <span class="statistic label label-success">
                                {this.state.answered}
                            </span>
                        </div>
                    </div>
                </div>
                {soundElem}
                <div ref="wrapper" class={classFromObj(seqClasses)}>
                    <div class="row">
                        <div class="col-lg-12">
                            <div ref="current" class={classFromObj(classes)}>
                                {element}
                            </div>
                        </div>
                    </div>
                </div>
            </div>`