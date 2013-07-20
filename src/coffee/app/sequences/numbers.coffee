define ->
    class NumberSource
        constructor: ->
            initial = (100 for a in [0..9])
            @content = initial.map (elem, idx) ->
                Math.floor elem * Math.random()

        toArray: ->
            @content

    NumberSource
