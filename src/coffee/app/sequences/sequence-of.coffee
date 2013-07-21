define [
    "app/sequences/sequence"
    "app/sequences/letters"
    "app/sequences/numbers"
    "app/sequences/words"
    "app/sequences/images"
    "app/sequences/sounds"
    "app/sequences/grids"
], (Sequence, LetterSource, NumberSource, WordsSource,
        ImageSource, SoundSource, GridSource) ->
    class SequenceFactory
        constructor: ->

        numbers: ->
            new Sequence(new NumberSource)

        letters: ->
            new Sequence(new LetterSource)

        words: ->
            new Sequence(new WordsSource)

        images: ->
            new Sequence(new ImageSource)

        sounds: ->
            new Sequence(new SoundSource)

        grids: ->
            new Sequence(new GridSource)

    new SequenceFactory()