-- barycenter: fluctuating relationships 
-- 
-- v0.2.0 @echophon
--
-- ENC 1 - offset horizon
-- ENC 2 - adjust space
-- KEY 2 - cycle space focus
-- ENC 3 - adjust speed
-- KEY 3 - cycle speed focus


engine.name = 'PolyPerc'

viewport   = { width = 128, height = 64 }
inner      = { space = 4+math.random(2,20), speed = math.random(1,10)*0.1, dirty=0 }
middle     = { space = 4+math.random(2,20), speed = math.random(1,10)*0.1, dirty=0 }
outer      = { space = 4+math.random(2,20), speed = math.random(1,10)*0.1, dirty=0 }

innerOrbit = {{x=0,y=0}
             ,{x=0,y=0}}

middleOrbit= {{x=0,y=0}
             ,{x=0,y=0}
             ,{x=0,y=0}
             ,{x=0,y=0}}

outerOrbit = {{x=0,y=0,note=0,dirty=0}
             ,{x=0,y=0,note=0,dirty=0}
             ,{x=0,y=0,note=0,dirty=0}
             ,{x=0,y=0,note=0,dirty=0}
             ,{x=0,y=0,note=0,dirty=0}
             ,{x=0,y=0,note=0,dirty=0}
             ,{x=0,y=0,note=0,dirty=0}
             ,{x=0,y=0,note=0,dirty=0}}

spaceFocus = 0
speedFocus = 0
frame      = 0
horizon    = 32
txt        = 'hello'
drawOrbits = 0
editCounter= 0
useMidi    = 0
channel    = 1
m          = midi.connect()


params:add_number("useMidi","useMidi",0,1,0)
params:set_action("useMidi", function(x) useMidi = x end)

params:add_number("channel","channel",1,16,1)
params:set_action("channel", function(x) channel = x end)


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
    end
  elseif id == 3 and state == 1 then
    speedFocus = (speedFocus + 1)%3
    if speedFocus == 0 then
      txt = 'innerSpeed'
    elseif speedFocus == 1 then
      txt = 'middleSpeed'
    elseif speedFocus == 2 then
      txt = 'outerSpeed'
    end
  end
end

function enc(id,delta)
  if id == 2 and spaceFocus == 0 then
    inner.space = util.clamp(inner.space + (delta*0.1),4,40)
    editCounter = 0
    drawOrbits = 1
    txt = inner.space
  elseif id == 2 and spaceFocus == 1 then
    middle.space = util.clamp(middle.space + (delta*0.1),4,40)
    editCounter = 0
    drawOrbits = 1
    txt = middle.space
  elseif id == 2 and spaceFocus == 2 then
    outer.space = util.clamp(outer.space + (delta*0.1),4,40)
    editCounter = 0
    drawOrbits = 1
    txt = outer.space
  
  elseif id == 3 and speedFocus == 0 then
    inner.speed = util.clamp(inner.speed + (delta*0.01),-10,10)
    editCounter = 0
    drawOrbits = 1
    txt = inner.speed
  elseif id == 3 and speedFocus == 1 then
    middle.speed = util.clamp(middle.speed + (delta*0.01),-10,10)
    editCounter = 0
    drawOrbits = 1
    txt = middle.speed
  elseif id == 3 and speedFocus == 2 then
    outer.speed = util.clamp(outer.speed + (delta*0.01),-10,10)
    editCounter = 0
    drawOrbits = 1
    txt = outer.speed

  elseif id == 1 then
    horizon = util.clamp(horizon + delta,4,60)
    editCounter = 0
    drawOrbits = 1
    txt = horizon -32
  end
  redraw()
end

function redraw()
  screen.clear()

  if drawOrbits == 1 then
    draw_horizon(horizon)
    draw_text(txt)
  end

  --inner inner
  draw_circle(viewport.width/2, viewport.height/2, inner.space, drawOrbits)

  --inner
  draw_circle(innerOrbit[1].x, innerOrbit[1].y, middle.space, drawOrbits)
  draw_circle(innerOrbit[2].x, innerOrbit[2].y, middle.space, drawOrbits)

  --middle
  draw_circle(middleOrbit[1].x, middleOrbit[1].y, outer.space, drawOrbits)
  draw_circle(middleOrbit[2].x, middleOrbit[2].y, outer.space, drawOrbits)
  draw_circle(middleOrbit[3].x, middleOrbit[3].y, outer.space, drawOrbits)
  draw_circle(middleOrbit[4].x, middleOrbit[4].y, outer.space, drawOrbits)
  
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
  -- if math.floor(orb.y) == horizon and orb.dirty == 0 then
  if distance(0, orb.y, 0, horizon) < 2 and orb.dirty == 0 then
    orb.dirty = 1
  end
    
  if orb.dirty == 1 and useMidi == 0 then 
    engine.release(outer.space * 0.005)
    engine.cutoff(inner.space * 50)
    engine.pan((math.random()*2)-1)
    engine.hz(midi_to_hz( util.clamp(orb.x,1,viewport.width)))
    orb.dirty = 2
  elseif orb.dirty == 1 and useMidi == 1 then
    orb.note = util.clamp(math.floor(orb.x),1,viewport.width)
    -- m:note_on(orb.note,util.clamp(math.floor(outer.space+middle.space)*2,1,127),1)
    m:note_on(orb.note,util.clamp(127-(math.floor(distance(orb.x, orb.y, viewport.width/2, viewport.height/2))*2),1,127),channel)
    orb.dirty = 2
  end
  
  if distance(0, orb.y, 0, horizon) > 2  and orb.dirty == 2 then
    if useMidi == 1 then
      m:note_off(orb.note,util.clamp(127-(math.floor(distance(orb.x, orb.y, viewport.width/2, viewport.height/2))*2),1,127),channel)
    end
    orb.dirty = 0
  end
end

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

-- Interval
re = metro.init()
re.time = 0.05
re.event = function()
  frame = frame + 1
  editCounter = editCounter + 1
  if editCounter > 50 then
    drawOrbits = 0
  end

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

