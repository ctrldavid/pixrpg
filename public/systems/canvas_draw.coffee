define [
], () ->

  class CanvasDraw
    constructor: (@entities, @canvas) ->
      @context = @canvas.getContext '2d'
      @loadTextures()
      @drawLoop()

    loadTextures: ->
      @textures = {}
      img = new Image
      img.src = 'walk.png'
      @textures.walk = {
        image: img
        facing: Math.PI/2        
        frames: [
          {x:1, y:1, cx:2.5, cy:1.5, w:6, h:4 }
          {x:8, y:1, cx:2.5, cy:1.5, w:6, h:4 }
          {x:15, y:1, cx:2.5, cy:1.5, w:6, h:4 }
          {x:22, y:1, cx:2.5, cy:1.5, w:6, h:4 }
        ]
      }

      img = new Image
      img.src = 'slash.png'
      @textures.slash = {
        image: img
        facing: Math.PI/2        
        frames: [
          {x:1, y:1, cx:7.5, cy:18, w:16, h:16 }
          {x:18, y:1, cx:7.5, cy:18, w:16, h:16 }
          {x:35, y:1, cx:7.5, cy:18, w:16, h:16 }
          {x:52, y:1, cx:7.5, cy:18, w:16, h:16 }
          {x:1, y:18, cx:7.5, cy:18, w:16, h:16 }
          {x:18, y:18, cx:7.5, cy:18, w:16, h:16 }
          {x:35, y:18, cx:7.5, cy:18, w:16, h:16 }
          {x:52, y:18, cx:7.5, cy:18, w:16, h:16 }
          {x:1, y:35, cx:7.5, cy:18, w:16, h:16 }
          {x:18, y:35, cx:7.5, cy:18, w:16, h:16 }
          {x:35, y:35, cx:7.5, cy:18, w:16, h:16 }
          {x:52, y:35, cx:7.5, cy:18, w:16, h:16 }
        ]
      }      
    
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

    drawLoop: =>
      @context.clearRect 0, 0, @canvas.width, @canvas.height

      time = new Date

      for entity in @entities
        continue unless entity.component.graphical?
        texture = @textures[entity.component.graphical.textureName]
        index = entity.component.graphical.frameNumber
        x = entity.component.transform.x
        y = entity.component.transform.y
        rotation = entity.component.transform.rotation - texture.facing
        @context.save()
        @context.translate x, y 
        @context.rotate rotation
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

        if time - entity.component.graphical.lastFrame > entity.component.graphical.frameTime
          entity.component.graphical.nextFrame()
          entity.component.graphical.lastFrame = time


      window.requestAnimationFrame @drawLoop
