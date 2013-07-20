define ->
    class Sequence
        constructor: (@source) ->
            @history = []
            @totalLength = @source.length

        history: (n) ->
            @history[@history.length - n]

        matchBackN: (elem, n) ->
            (@history n) is elem

        choose: ->
            elem = @source[Math.floor Math.random() * @totalLength]

        current: ->
            @history[@history.length - 1]

        next: ->
            elem = @choose()
            @history.push elem
            elem
