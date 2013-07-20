define ->
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

            @content = initial.filter ->
                Math.random() > 0.5

        toArray: ->
            @content

    LetterSource