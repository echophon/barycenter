-- barycenter: fluctuating relationships 
-- 
-- v0.0.6 @echophon
--
-- ENC 1 - offset horizon
-- ENC 2 - adjust space
-- KEY 2 - cycle space focus
-- ENC 3 - adjust speed
-- KEY 3 - cycle speed focus


engine.name = 'PolyPerc'

viewport   = { width = 128, height = 64 }
inner      = { space = 2+math.random(2,20), speed = math.random(1,10)*0.01 }
middle     = { space = 2+math.random(2,20), speed = math.random(1,10)*0.01 }
outer      = { space = 2+math.random(2,20), speed = math.random(1,10)*0.01 }

innerOrbit = {{x=0,y=0,spaceOffset=0,speedOffset=1}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1}}

middleOrbit= {{x=0,y=0,spaceOffset=0,speedOffset=1}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1}}

outerOrbit = {{x=0,y=0,spaceOffset=0,speedOffset=1,dirty=0}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1,dirty=0}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1,dirty=0}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1,dirty=0}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1,dirty=0}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1,dirty=0}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1,dirty=0}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1,dirty=0}}

spaceFocus = 0
speedFocus = 0
frame      = 0
horizon    = 32
txt        = 'hello'

function draw_circle(x, y, r, l)
  screen.level(l)
  screen.circle(x,y,r)
  screen.stroke()
end

function draw_horizon(horizon)
  if horizon == 32 then
    screen.level(3)
  else
    screen.level(1)
  end
  screen.rect(0,horizon,4,0)
  screen.rect(viewport.width-4,horizon,4,0)
  screen.stroke()
end

function draw_text(txt)
  screen.level(1)
  screen.move(2,6)
  screen.text(txt)
  screen.stroke()
end
  

function key(id,state)
  if id == 2 and state == 1 then
    spaceFocus = (spaceFocus + 1)%3
    if spaceFocus == 0 then
      txt = 'innerSpace'
    elseif spaceFocus == 1 then
      txt = 'middleSpace'
    elseif spaceFocus == 2 then
      txt = 'outerSpace'
    -- elseif spaceFocus == 2 then
    --   txt = 'innerOffSpace1'
    -- elseif spaceFocus == 3 then
    --   txt = 'innerOffSpace2'
    -- elseif spaceFocus == 4 then
    --   txt = 'outerOffSpace1'
    -- elseif spaceFocus == 5 then
    --   txt = 'outerOffSpace2'
    end
  elseif id == 3 and state == 1 then
    speedFocus = (speedFocus + 1)%3
    if speedFocus == 0 then
      txt = 'innerSpeed'
    -- elseif speedFocus == 1 then
    --   txt = 'innerMult1'
    -- elseif speedFocus == 2 then
    --   txt = 'innerMult2'
    elseif speedFocus == 1 then
      txt = 'middleSpeed'
    elseif speedFocus == 2 then
      txt = 'outerSpeed'
    -- elseif speedFocus == 4 then
    --   txt = 'outerMult1'
    -- elseif speedFocus == 5 then
    --   txt = 'outerMult2'
    -- elseif speedFocus == 6 then
    --   txt = 'outerMult3'
    -- elseif speedFocus == 7 then
    --   txt = 'outerMult4'
    end
  end
end

function enc(id,delta)
  if id == 2 and spaceFocus == 0 then
    inner.space = util.clamp(inner.space + (delta*0.1),2,50)
    txt = inner.space
  elseif id == 2 and spaceFocus == 1 then
    middle.space = util.clamp(middle.space + (delta*0.1),2,50)
    txt = middle.space
  elseif id == 2 and spaceFocus == 2 then
    outer.space = util.clamp(outer.space + (delta*0.1),2,50)
    txt = outer.space
  -- elseif id == 2 and spaceFocus == 2 then
  --   inOrbit[1].spaceOffset = util.clamp(inOrbit[1].spaceOffset + (delta*0.1),-10,10)
  --   txt = inOrbit[1].spaceOffset
  -- elseif id == 2 and spaceFocus == 3 then
  --   inOrbit[2].spaceOffset = util.clamp(inOrbit[2].spaceOffset + (delta*0.1),-10,10)
  --   txt = inOrbit[2].spaceOffset
  -- elseif id == 2 and spaceFocus == 4 then
  --   outerOrbit[1].spaceOffset = util.clamp(outerOrbit[1].spaceOffset + (delta*0.1),-10,10)
  --   outerOrbit[2].spaceOffset = util.clamp(outerOrbit[2].spaceOffset + (delta*0.1),-10,10)
  --   txt = inOrbit[1].spaceOffset
  -- elseif id == 2 and spaceFocus == 5 then
  --   outerOrbit[3].spaceOffset = util.clamp(outerOrbit[3].spaceOffset + (delta*0.1),-10,10)
  --   outerOrbit[4].spaceOffset = util.clamp(outerOrbit[4].spaceOffset + (delta*0.1),-10,10)
  --   txt = inOrbit[1].spaceOffset
  
  elseif id == 3 and speedFocus == 0 then
    inner.speed = util.clamp(inner.speed + (delta*0.01),-20,20)
    txt = inner.speed
  -- elseif id == 3 and speedFocus == 1 then
  --   inOrbit[1].speedOffset = util.clamp(inOrbit[1].speedOffset + (delta*0.1),-2,2)
  --   txt = inOrbit[1].speedOffset
  -- elseif id == 3 and speedFocus == 2 then
  --   inOrbit[2].speedOffset = util.clamp(inOrbit[2].speedOffset + (delta*0.1),-2,2)
  --   txt = inOrbit[2].speedOffset

  elseif id == 3 and speedFocus == 1 then
    middle.speed = util.clamp(middle.speed + (delta*0.01),-20,20)
    txt = middle.speed
  elseif id == 3 and speedFocus == 2 then
    outer.speed = util.clamp(outer.speed + (delta*0.01),-20,20)
    txt = outer.speed
  -- elseif id == 3 and speedFocus == 4 then
  --   outerOrbit[1].speedOffset = util.clamp(outerOrbit[1].speedOffset + (delta*0.1),-2,2)
  --   txt = outerOrbit[1].speedOffset
  -- elseif id == 3 and speedFocus == 5 then
  --   outerOrbit[2].speedOffset = util.clamp(outerOrbit[2].speedOffset + (delta*0.1),-2,2)
  --   txt = outerOrbit[2].speedOffset
  -- elseif id == 3 and speedFocus == 6 then
  --   outerOrbit[3].speedOffset = util.clamp(outerOrbit[3].speedOffset + (delta*0.1),-2,2)
  --   txt = outerOrbit[3].speedOffset
  -- elseif id == 3 and speedFocus == 7 then
  --   outerOrbit[4].speedOffset = util.clamp(outerOrbit[4].speedOffset + (delta*0.1),-2,2)
  --   txt = outerOrbit[4].speedOffset

  elseif id == 1 then
    horizon = util.clamp(horizon + delta,4,60)
    txt = horizon -32
  end
  redraw()
end

function redraw()
  screen.clear()
  draw_horizon(horizon)
  draw_text(txt)

  --inner
  -- draw_circle(innerOrbit[1].x, innerOrbit[1].y, middle.space,1)
  -- draw_circle(innerOrbit[2].x, innerOrbit[2].y, middle.space,1)
  -- draw_circle(innerOrbit[1].x + outerOrbit[1].spaceOffset,innerOrbit[1].y + outerOrbit[1].spaceOffset,outer.space,1)
  -- draw_circle(innerOrbit[2].x + outerOrbit[2].spaceOffset,innerOrbit[2].y + outerOrbit[1].spaceOffset,outer.space,1)

  --middle
  draw_circle(middleOrbit[1].x, middleOrbit[1].y, outer.space,1)
  draw_circle(middleOrbit[2].x, middleOrbit[2].y, outer.space,1)
  draw_circle(middleOrbit[3].x, middleOrbit[3].y, outer.space,1)
  draw_circle(middleOrbit[4].x, middleOrbit[4].y, outer.space,1)
  
  --outer
  draw_circle(outerOrbit[1].x,outerOrbit[1].y,1+outerOrbit[1].dirty,15)
  draw_circle(outerOrbit[2].x,outerOrbit[2].y,1+outerOrbit[2].dirty,15)
  draw_circle(outerOrbit[3].x,outerOrbit[3].y,1+outerOrbit[3].dirty,15)
  draw_circle(outerOrbit[4].x,outerOrbit[4].y,1+outerOrbit[4].dirty,15)
  draw_circle(outerOrbit[5].x,outerOrbit[5].y,1+outerOrbit[5].dirty,15)
  draw_circle(outerOrbit[6].x,outerOrbit[6].y,1+outerOrbit[6].dirty,15)
  draw_circle(outerOrbit[7].x,outerOrbit[7].y,1+outerOrbit[7].dirty,15)
  draw_circle(outerOrbit[8].x,outerOrbit[8].y,1+outerOrbit[8].dirty,15)

  screen.update()
end

function distance( x1, y1, x2, y2 )
	return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end

function play(orb)
  if math.floor(orb.y) == horizon and orb.dirty == 0 then
    orb.dirty = 1
    
    if orb.dirty == 1 then 
      engine.release(outer.space * 0.005)
      engine.cutoff(inner.space * 50)
      engine.pan((math.random()*2)-1)
      engine.hz(midi_to_hz( util.clamp(orb.x,1,viewport.width)))
      orb.dirty = 2
    end
  end
  
  if distance(0, orb.y, 0, horizon) > 2 or distance(0, orb.y, 0, horizon) < -2 and orb.dirty == 2 then
    orb.dirty = 0
  end
end

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

-- Interval
re = metro.init()
re.time = 0.01
re.event = function()
  frame = frame + 1

  --inner
  innerOrbit[1].x = viewport.width/2  + (math.cos(frame * (inner.speed) * 0.01) * inner.space) 
  innerOrbit[1].y = viewport.height/2 + (math.sin(frame * (inner.speed) * 0.01) * inner.space)
  innerOrbit[2].x = viewport.width/2  + (1 - math.cos(frame * (inner.speed) * 0.01) * inner.space)
  innerOrbit[2].y = viewport.height/2 + (1 - math.sin(frame * (inner.speed) * 0.01) * inner.space)

  --middle
  middleOrbit[1].x = innerOrbit[1].x + (math.cos(frame * (middle.speed) * 0.01) * middle.space)
  middleOrbit[1].y = innerOrbit[1].y + (math.sin(frame * (middle.speed) * 0.01) * middle.space)
  middleOrbit[2].x = innerOrbit[1].x + (1 - math.cos(frame * (middle.speed) * 0.01) * middle.space)
  middleOrbit[2].y = innerOrbit[1].y + (1 - math.sin(frame * (middle.speed) * 0.01) * middle.space)
  middleOrbit[3].x = innerOrbit[2].x + (math.cos(frame * (middle.speed) * 0.01) * middle.space)
  middleOrbit[3].y = innerOrbit[2].y + (math.sin(frame * (middle.speed) * 0.01) * middle.space)
  middleOrbit[4].x = innerOrbit[2].x + (1 - math.cos(frame * (middle.speed) * 0.01) * middle.space)
  middleOrbit[4].y = innerOrbit[2].y + (1 - math.sin(frame * (middle.speed) * 0.01) * middle.space)

  --outer
  outerOrbit[1].x = middleOrbit[1].x + (math.cos(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[1].y = middleOrbit[1].y + (math.sin(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[2].x = middleOrbit[1].x + (1 - math.cos(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[2].y = middleOrbit[1].y + (1 - math.sin(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[3].x = middleOrbit[2].x + (math.cos(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[3].y = middleOrbit[2].y + (math.sin(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[4].x = middleOrbit[2].x + (1 - math.cos(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[4].y = middleOrbit[2].y + (1 - math.sin(frame * (outer.speed) * 0.01) * outer.space)
  
  outerOrbit[5].x = middleOrbit[3].x + (math.cos(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[5].y = middleOrbit[3].y + (math.sin(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[6].x = middleOrbit[3].x + (1 - math.cos(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[6].y = middleOrbit[3].y + (1 - math.sin(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[7].x = middleOrbit[4].x + (math.cos(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[7].y = middleOrbit[4].y + (math.sin(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[8].x = middleOrbit[4].x + (1 - math.cos(frame * (outer.speed) * 0.01) * outer.space)
  outerOrbit[8].y = middleOrbit[4].y + (1 - math.sin(frame * (outer.speed) * 0.01) * outer.space)
  
  for i=1,8 do 
    play(outerOrbit[i])
  end
  redraw()
end
re:start()

