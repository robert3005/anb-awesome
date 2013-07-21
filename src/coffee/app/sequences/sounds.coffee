define [
    "jquery",
    "lodash"
], ($, _) ->
    class SoundSource
        constructor: ->
            soundcloud5downloadable = "https://api.soundcloud.com/tracks?" +
            "client_id=6edbdfe1f57f0bccaa8680b61aea0df2&limit=50" +
            "&filter=downloadable&duration[from]=0&duration[to]=20000"

            result = $.ajax
                dataType: "json"
                url: soundcloud5downloadable
                async: false

            @content = _(result.responseJSON)
                .filter((elem) ->
                    elem.original_format is "mp3"
                ).pluck("download_url")
                .first(5)
                .map((elem) ->
                    elem + "?client_id=6edbdfe1f57f0bccaa8680b61aea0df2"
                ).value()

        toArray: ->
            @content

