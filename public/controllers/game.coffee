define [
], () ->

  class Game
    constructor: (@canvas) ->
      @context = @canvas.getContext '2d'

      @player = {
        x:@canvas.width/2
        y:@canvas.height/2
        dx: 0
        dy: 0
        walk_frame: 0
        is_slashing: 0
        slash_frame: 0
      }

      
      # load textures
      @tx = {}
      img = new Image
      img.src = 'walk.png'
      @tx.walk = {
        image: img
        frames: [
          {x:0, y:0, cx:2.5, cy:1.5, w:6, h:4 }
          {x:6, y:0, cx:2.5, cy:1.5, w:6, h:4 }
          {x:12, y:0, cx:2.5, cy:1.5, w:6, h:4 }
          {x:18, y:0, cx:2.5, cy:1.5, w:6, h:4 }
        ]
      }

      img = new Image
      img.src = 'slash.png'
      @tx.slash = {
        image: img
        frames: [
          {x:0, y:0, cx:7.5, cy:18, w:16, h:16 }
          {x:16, y:0, cx:7.5, cy:18, w:16, h:16 }
          {x:32, y:0, cx:7.5, cy:18, w:16, h:16 }
          {x:48, y:0, cx:7.5, cy:18, w:16, h:16 }
          {x:0, y:16, cx:7.5, cy:18, w:16, h:16 }
          {x:16, y:16, cx:7.5, cy:18, w:16, h:16 }
          {x:32, y:16, cx:7.5, cy:18, w:16, h:16 }
          {x:48, y:16, cx:7.5, cy:18, w:16, h:16 }
          {x:0, y:32, cx:7.5, cy:18, w:16, h:16 }
          {x:16, y:32, cx:7.5, cy:18, w:16, h:16 }
          {x:32, y:32, cx:7.5, cy:18, w:16, h:16 }
          {x:48, y:32, cx:7.5, cy:18, w:16, h:16 }
        ]
      }


      @mouse = {x:0, y:0}

      @keys = {
        38: @up  
        40: @down
        37: @left
        39: @right

        69: @up  
        68: @down
        83: @left
        70: @right
      }

      @held = {}

      document.addEventListener 'keydown', (evt) =>
        pressed = evt.keyCode
        console.log pressed
        #@keys[pressed]?.apply this
        @held[pressed] = true

      document.addEventListener 'keyup', (evt) =>
        pressed = evt.keyCode
        @held[pressed] = false

      @canvas.addEventListener 'mousemove', (evt) =>
        @mouse.x = evt.clientX
        @mouse.y = evt.clientY


      @canvas.addEventListener 'click', =>
        @player.is_slashing = true

      tickLoop = =>
        @tick()
        window.setTimeout tickLoop, 15

      tickLoop()

      drawLoop = =>
        @draw()
        window.requestAnimationFrame drawLoop

      drawLoop()

    resetDimensions: ->
      console.log 'resizing to', @canvas.clientWidth, @canvas.clientHeight
      @canvas.width = @canvas.clientWidth
      @canvas.height = @canvas.clientHeight      

    up: ->
      @player.dy = -1
    down: ->
      @player.dy = +1
    left: ->
      @player.dx = -1
    right: ->
      @player.dx = +1

    tick: =>
      for key of @keys
        (@keys[key]?.apply this) if @held[key] 

      @player.walk_frame = (@player.walk_frame + 1) % 4
      if @player.is_slashing
        @player.slash_frame = (@player.slash_frame + 1) % 12

        @player.is_slashing = false if @player.slash_frame == 0
      
      @player.x += @player.dx
      @player.y += @player.dy

      @player.dx *= 0.9
      @player.dy *= 0.9

    drawTexture: (texture, index, x, y, facing) ->
      @context.save()
      @context.translate x, y 
      @context.rotate facing
      @context.translate -x, -y
      @context.drawImage( 
        texture.image, 
        texture.frames[index].x,
        texture.frames[index].y,
        texture.frames[index].w,
        texture.frames[index].h,
        x - texture.frames[index].cx,
        y - texture.frames[index].cy,
        texture.frames[index].w,
        texture.frames[index].h
      )     
      @context.restore()

    draw: ->

      facing = Math.atan2 @player.y - @mouse.y, @player.x - @mouse.x
      facing -= Math.PI/2
      #console.log facing

      # @context.fillStyle = "rgba(255,255,255,1.0)"
      # @context.fillRect @player.x, @player.y, 10, 10
      @context.clearRect 0, 0, @canvas.width, @canvas.height

      @drawTexture @tx.walk, @player.walk_frame, @player.x, @player.y, facing
      @drawTexture @tx.slash, @player.slash_frame, @player.x, @player.y, facing if @player.is_slashing

  return Game

