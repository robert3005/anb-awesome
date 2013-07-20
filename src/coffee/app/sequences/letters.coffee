define [
    "lodash"
], (_) ->
    class LetterSource
        constructor: ->
            initial = [
                "A", "B", "C",
                "D", "E", "F",
                "G", "H", "I",
                "J", "K", "L",
                "M", "N", "O",
                "P", "Q", "R",
                "S", "T", "U",
                "V", "W", "X",
                "Y", "Z"
            ]

            @content = _(initial).shuffle().first(5).value()

        toArray: ->
            @content

    LetterSource