define [
    "app/sequences/sequence"
    "app/sequences/letters"
    "app/sequences/numbers"
    "app/sequences/words"
    "app/sequences/images"
    "app/sequences/sounds"
], (Sequence, LetterSource, NumberSource, WordsSource,
        ImageSource, SoundSource) ->
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

    new SequenceFactory()