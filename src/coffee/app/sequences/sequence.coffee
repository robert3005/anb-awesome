define ->
    class Sequence
        constructor: (@source) ->
            @generated = []
            @sourceAsList = @source.toArray()
            @totalLength = @sourceAsList.length

        history: (n) ->
            @generated[@generated.length - n - 1]

        matchBackN: (n) ->
            (@history n) is @current()

        choose: ->
            elem = @sourceAsList[Math.floor Math.random() * @totalLength]

        current: ->
            @generated[@generated.length - 1]

        next: ->
            elem = @choose()
            @generated.push elem
            elem