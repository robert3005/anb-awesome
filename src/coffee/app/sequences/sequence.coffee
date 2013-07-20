define ->
    class Sequence
        constructor: (@source) ->
            @generated = []
            @totalLength = @source.length

        history: (n) ->
            @generated[@generated.length - n - 1]

        matchBackN: (n) ->
            (@history n) is @current()

        choose: ->
            elem = @source[Math.floor Math.random() * @totalLength]

        current: ->
            @generated[@generated.length - 1]

        next: ->
            elem = @choose()
            @generated.push elem
            elem
