define ->
    class NumberSource
        constructor: ->
            initial = (100 for a in [0..4])
            @content = initial.map (elem, idx) ->
                Math.floor elem * Math.random()

        toArray: ->
            @content
