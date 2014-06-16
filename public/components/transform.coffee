define [
], () ->

  class Transform
    constructor: ->
      @x = undefined
      @y = undefined
      @rotation = undefined
      @scale = undefined
      @velocity = 1

    facePoint: (x, y) ->
      @rotation = Math.atan2(@y - y, @x - x)

