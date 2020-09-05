-- barycenter: fluctuating relationships 
-- 
-- v0.0.5 @echophon
--
-- ENC 1 - offset horizon
-- ENC 2 - adjust space
-- KEY 2 - cycle space focus
-- ENC 3 - adjust speed
-- KEY 3 - cycle speed focus


engine.name = 'PolyPerc'

viewport   = { width = 128, height = 64 }
inner      = { space = 2+math.random(2,20), speed = math.random(1,10)*0.01 }
outer      = { space = 2+math.random(2,20), speed = math.random(1,10)*0.01 }

inOrbit    = {{x=0,y=0,spaceOffset=0,speedOffset=1}
             ,{x=0,y=0,spaceOffset=0,speedOffset=1}}

outOrbit   = {{x=0,y=0,spaceOffset=0,speedOffset=1,dirty=0}
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
    spaceFocus = (spaceFocus + 1)%2
    if spaceFocus == 0 then
      txt = 'innerSpaceAll'
    elseif spaceFocus == 1 then
      txt = 'outerSpaceAll'
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
    speedFocus = (speedFocus + 1)%8
    if speedFocus == 0 then
      txt = 'innerSpeed'
    elseif speedFocus == 1 then
      txt = 'innerMult1'
    elseif speedFocus == 2 then
      txt = 'innerMult2'
    elseif speedFocus == 3 then
      txt = 'outerSpeed'
    elseif speedFocus == 4 then
      txt = 'outerMult1'
    elseif speedFocus == 5 then
      txt = 'outerMult2'
    elseif speedFocus == 6 then
      txt = 'outerMult3'
    elseif speedFocus == 7 then
      txt = 'outerMult4'
    end
  end
end

function enc(id,delta)
  if id == 2 and spaceFocus == 0 then
    inner.space = util.clamp(inner.space + (delta*0.1),2,50)
    txt = inner.space
  elseif id == 2 and spaceFocus == 1 then
    outer.space = util.clamp(outer.space + (delta*0.1),2,50)
    txt = outer.space
  -- elseif id == 2 and spaceFocus == 2 then
  --   inOrbit[1].spaceOffset = util.clamp(inOrbit[1].spaceOffset + (delta*0.1),-10,10)
  --   txt = inOrbit[1].spaceOffset
  -- elseif id == 2 and spaceFocus == 3 then
  --   inOrbit[2].spaceOffset = util.clamp(inOrbit[2].spaceOffset + (delta*0.1),-10,10)
  --   txt = inOrbit[2].spaceOffset
  -- elseif id == 2 and spaceFocus == 4 then
  --   outOrbit[1].spaceOffset = util.clamp(outOrbit[1].spaceOffset + (delta*0.1),-10,10)
  --   outOrbit[2].spaceOffset = util.clamp(outOrbit[2].spaceOffset + (delta*0.1),-10,10)
  --   txt = inOrbit[1].spaceOffset
  -- elseif id == 2 and spaceFocus == 5 then
  --   outOrbit[3].spaceOffset = util.clamp(outOrbit[3].spaceOffset + (delta*0.1),-10,10)
  --   outOrbit[4].spaceOffset = util.clamp(outOrbit[4].spaceOffset + (delta*0.1),-10,10)
  --   txt = inOrbit[1].spaceOffset
  
  elseif id == 3 and speedFocus == 0 then
    inner.speed = util.clamp(inner.speed + (delta*0.01),-20,20)
    txt = inner.speed
  elseif id == 3 and speedFocus == 1 then
    inOrbit[1].speedOffset = util.clamp(inOrbit[1].speedOffset + (delta*0.1),-2,2)
    txt = inOrbit[1].speedOffset
  elseif id == 3 and speedFocus == 2 then
    inOrbit[2].speedOffset = util.clamp(inOrbit[2].speedOffset + (delta*0.1),-2,2)
    txt = inOrbit[2].speedOffset

  elseif id == 3 and speedFocus == 3 then
    outer.speed = util.clamp(outer.speed + (delta*0.01),-20,20)
    txt = outer.speed
  elseif id == 3 and speedFocus == 4 then
    outOrbit[1].speedOffset = util.clamp(outOrbit[1].speedOffset + (delta*0.1),-2,2)
    txt = outOrbit[1].speedOffset
  elseif id == 3 and speedFocus == 5 then
    outOrbit[2].speedOffset = util.clamp(outOrbit[2].speedOffset + (delta*0.1),-2,2)
    txt = outOrbit[2].speedOffset
  elseif id == 3 and speedFocus == 6 then
    outOrbit[3].speedOffset = util.clamp(outOrbit[3].speedOffset + (delta*0.1),-2,2)
    txt = outOrbit[3].speedOffset
  elseif id == 3 and speedFocus == 7 then
    outOrbit[4].speedOffset = util.clamp(outOrbit[4].speedOffset + (delta*0.1),-2,2)
    txt = outOrbit[4].speedOffset

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
  draw_circle(inOrbit[1].x, inOrbit[1].y, outer.space,1)
  draw_circle(inOrbit[2].x, inOrbit[2].y, outer.space,1)
  -- draw_circle(inOrbit[1].x + outOrbit[1].spaceOffset,inOrbit[1].y + outOrbit[1].spaceOffset,outer.space,1)
  -- draw_circle(inOrbit[2].x + outOrbit[2].spaceOffset,inOrbit[2].y + outOrbit[1].spaceOffset,outer.space,1)
  
  --outer
  draw_circle(outOrbit[1].x,outOrbit[1].y,1+outOrbit[1].dirty,15)
  draw_circle(outOrbit[2].x,outOrbit[2].y,1+outOrbit[2].dirty,15)
  draw_circle(outOrbit[3].x,outOrbit[3].y,1+outOrbit[3].dirty,15)
  draw_circle(outOrbit[4].x,outOrbit[4].y,1+outOrbit[4].dirty,15)

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
  inOrbit[1].x = viewport.width/2  + (math.cos(frame * (inner.speed * inOrbit[1].speedOffset) * 0.01) * inner.space) 
  inOrbit[1].y = viewport.height/2 + (math.sin(frame * (inner.speed * inOrbit[1].speedOffset) * 0.01) * inner.space)
  inOrbit[2].x = viewport.width/2  + (1 - math.cos(frame * (inner.speed * inOrbit[2].speedOffset) * 0.01) * inner.space)
  inOrbit[2].y = viewport.height/2 + (1 - math.sin(frame * (inner.speed * inOrbit[2].speedOffset) * 0.01) * inner.space)

  --outer
  outOrbit[1].x = inOrbit[1].x + (math.cos(frame * (outer.speed * outOrbit[1].speedOffset) * 0.01) * outer.space)
  outOrbit[1].y = inOrbit[1].y + (math.sin(frame * (outer.speed * outOrbit[1].speedOffset) * 0.01) * outer.space)
  outOrbit[2].x = inOrbit[1].x + (1 - math.cos(frame * (outer.speed * outOrbit[2].speedOffset) * 0.01) * outer.space)
  outOrbit[2].y = inOrbit[1].y + (1 - math.sin(frame * (outer.speed * outOrbit[2].speedOffset) * 0.01) * outer.space)
  outOrbit[3].x = inOrbit[2].x + (math.cos(frame * (outer.speed * outOrbit[3].speedOffset) * 0.01) * outer.space)
  outOrbit[3].y = inOrbit[2].y + (math.sin(frame * (outer.speed * outOrbit[3].speedOffset) * 0.01) * outer.space)
  outOrbit[4].x = inOrbit[2].x + (1 - math.cos(frame * (outer.speed * outOrbit[4].speedOffset) * 0.01) * outer.space)
  outOrbit[4].y = inOrbit[2].y + (1 - math.sin(frame * (outer.speed * outOrbit[4].speedOffset) * 0.01) * outer.space)
  
  for i=1,4 do 
    play(outOrbit[i])
  end
  redraw()
end
re:start()

