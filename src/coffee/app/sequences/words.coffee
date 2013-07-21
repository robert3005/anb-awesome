define [
    "jquery",
    "lodash"
], ($, _) ->
    class WordSource
        constructor: ->
            wordnik5RandomWordsUrl = "http://api.wordnik.com/v4/words.json/" +
            "randomWords?api_key=a706397025ec79be5cb5f44c1ee066b88e3c5b151a" +
            "444ca99&hasDictionaryDef=true&minCorpusCount=0&maxCorpusCount=" +
            "-1&minDictionaryCount=20&maxDictionaryCount=-1&minLength=1&" +
            "maxLength=11&limit=5"

            result = $.ajax
                dataType: "json"
                url: wordnik5RandomWordsUrl
                async: false

            @content = _.pluck result.responseJSON, "word"

        toArray: ->
            @content
