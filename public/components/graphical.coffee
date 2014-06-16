define [
], () ->

  class Graphical
    constructor: ->
      @frameNumber = 0
      @maxFrames = 0
      @textureName = undefined
      @lastFrame = new Date
      @frameTime = 30

    nextFrame: ->
      @frameNumber = (@frameNumber + 1) % @maxFrames
