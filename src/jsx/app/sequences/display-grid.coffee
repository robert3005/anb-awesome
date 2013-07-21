`/** @jsx React.DOM */`
define [
    "react"
    "grid"
], (React, Grid) ->
    DisplayGrid = React.createClass

        componentDidUpdate: ->
            @draw()

        componentDidMount: ->
            @draw()

        draw: ->
            canvas = document.getElementById "grid"
            context = canvas.getContext "2d"

            context.beginPath()
            context.rect 0, 0, 390, 390
            context.fillStyle = "white"
            context.fill()
            context.lineWidth = 2
            context.strokeStyle = "black"
            context.stroke()

            side = 130
            lineWidth = 5

            opts =
              distance: side
              lineWidth: lineWidth
              gridColor: "#0080c9"
              caption: false

            new Grid(opts).draw context

            [row, col] = @position this.props.element

            actualSide = side + lineWidth / 2

            context.beginPath()
            context.rect row * side + 10, col * side + 10, side - 20, side - 20
            context.fillStyle = "#4858a4"
            context.fill()

        position: (number) ->
            [Math.floor(number / 3), number % 3]

        render: ->
            `<canvas id="grid" width="390" height="390" />`