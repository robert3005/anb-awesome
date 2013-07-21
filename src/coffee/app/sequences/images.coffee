define [
    "jquery",
    "lodash"
], ($, _) ->
    class ImageSource
        constructor: ->
            editors5pictures500px = "https://api.500px.com/v1/photos?" +
            "feature=editors&consumer_key=7XLtOwVIuezh32SH79YcXxq1eUsq" +
            "TLNuWjuQjmlt&rpp=5&image_size=4&page=" +
            Math.floor(1455 * Math.random())

            result = $.ajax
                dataType: "json"
                url: editors5pictures500px
                async: false

            @content = _(result.responseJSON.photos).pluck("images")
                .map((elem) ->
                    elem[0].url
                ).value()

        toArray: ->
            @content
