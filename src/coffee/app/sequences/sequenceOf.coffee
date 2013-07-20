define [
    "app/sequences/sequence"
    "app/sequences/letters"
    "app/sequences/numbers"
    "app/sequences/words"
], (Sequence, LetterSource, NumberSource, WordsSource) ->
    class SequenceFactory
        constructor: ->

        numbers: ->
            new Sequence((new NumberSource).toArray())

        letters: ->
            new Sequence((new LetterSource).toArray())

        words: ->
            new Sequence((new WordsSource).toArray())

    new SequenceFactory()