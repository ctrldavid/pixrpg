define [
], () ->

  class Transform
    constructor: ->
      @x = undefined
      @y = undefined
      @rotation = 0
      @scale = 1
      @velocity = 1

    facePoint: (x, y) ->
      @rotation = Math.atan2(@y - y, @x - x)

