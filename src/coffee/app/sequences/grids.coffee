define ->
    class NumberSource
        constructor: ->
            @content = (a for a in [0..8])

        toArray: ->
            @content
