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
          {x:1, y:1, cx:3, cy:2, w:6, h:4 }
          {x:8, y:1, cx:3, cy:2, w:6, h:4 }
          {x:15, y:1, cx:3, cy:2, w:6, h:4 }
          {x:22, y:1, cx:3, cy:2, w:6, h:4 }
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
    
      img = new Image
      img.src = 'wave.png'
      @textures.wave = {
        image: img
        facing: Math.PI/2        
        frames: [
          {x:1, y:1, cx:7.5, cy:3, w:16, h:5 }
        ]
      }         

      @textures.wavestream = {
        image: img
        facing: Math.PI/2        
        frames: [
          {x:1, y:7, cx:1.5, cy:2, w:3, h:4 }
          {x:5, y:7, cx:1.5, cy:2, w:3, h:4 }
          {x:9, y:7, cx:1.5, cy:2, w:3, h:4 }
          {x:13, y:7, cx:1.5, cy:2, w:3, h:4 }
        ]
      }         
      @textures.wavespot = {
        image: img
        facing: Math.PI/2        
        frames: [
          {x:1, y:12, cx:1.5, cy:1.5, w:3, h:3 }
          {x:5, y:12, cx:1.5, cy:1.5, w:3, h:3 }
          {x:9, y:12, cx:1.5, cy:1.5, w:3, h:3 }
          {x:13, y:12, cx:1.5, cy:1.5, w:3, h:3 }
        ]
      }

      img = new Image
      img.src = 'bullet.png'
      @textures.bullet = {
        image: img
        facing: Math.PI/2        
        frames: [
          {x:9, y:1, cx:1.5, cy:1.5, w:3, h:8 }
        ]
      }               


    drawLoop: =>
      @context.clearRect 0, 0, @canvas.width, @canvas.height      
      time = new Date

      for entityID, entity of @entities.hashmap
        continue unless entity.component.graphical?
        
        # if entity.component.timed
        #   @context.globalAlpha = 1 - (time - entity.component.timed.birth) / entity.component.timed.ttl
        # else
        #   @context.globalAlpha = 1
        

        texture = @textures[entity.component.graphical.textureName]
        index = entity.component.graphical.frameNumber
        x = entity.component.transform.x
        y = entity.component.transform.y
        scale = entity.component.transform.scale
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
          x - texture.frames[index].cx*scale,
          y - texture.frames[index].cy*scale,
          texture.frames[index].w*scale,
          texture.frames[index].h*scale
        )     
        @context.restore()

        if time - entity.component.graphical.lastFrame > entity.component.graphical.frameTime
          entity.component.graphical.nextFrame()
          entity.component.graphical.lastFrame = time


      window.requestAnimationFrame @drawLoop
