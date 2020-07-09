-- phaaze v0.0.1
-- fluctuating relationships
--
-- ENC 2 - adjust width
-- KEY 2 - toggle width focus
-- ENC 3 - adjust speed
-- KEY 3 - toggle speed focus


engine.name = 'PolyPerc'

viewport   = { width = 128, height = 64, frame = 0 }
base       = { width = 5, speed = 0.05 }
orbit      = { width = 5, speed = 0.05 }
focus      = { x = 0, y = 0 }
focus2     = { x = 0, y = 0 }
focus3     = { x = 0, y = 0 }
focus4     = { x = 0, y = 0 }
focus5     = { x = 0, y = 0 }
focus6     = { x = 0, y = 0 }
widthFocus = 0
speedFocus = 0

function draw_circle(x, y, r, l)
  screen.level(l)
  screen.circle(x,y,r)
  screen.stroke()
end

function key(id,state)
  if id == 2 and state == 1 then
    widthFocus = (widthFocus + 1)%2
  elseif id == 3 and state == 1 then
    speedFocus = (speedFocus + 1)%2
  end
end

function enc(id,delta)
  if id == 2 and widthFocus == 0 then
    base.width = util.clamp(base.width + delta,4,45)
  elseif id == 2 and widthFocus == 1 then
    orbit.width =  util.clamp(orbit.width + delta,2,50)
  elseif id == 3 and speedFocus == 0 then
    base.speed = util.clamp(base.speed + (delta*0.001),-1,1)
  elseif id == 3 and speedFocus == 1 then
    orbit.speed = util.clamp(orbit.speed + (delta*0.001),-1,1)
  end
  redraw()
end

function redraw()
  screen.clear()
  draw_circle(focus.x,focus.y,orbit.width,1)
  draw_circle(focus2.x,focus2.y,orbit.width,1)
  
  draw_circle(focus3.x,focus3.y,1,15)
  draw_circle(focus4.x,focus4.y,1,15)
  draw_circle(focus5.x,focus5.y,1,15)
  draw_circle(focus6.x,focus6.y,1,15)

  screen.update()
end

function play(orb)
  if math.floor(orb.y) == viewport.height/2 then
    engine.release(orbit.width * 0.1)
    engine.hz(midi_to_hz(orb.x))
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
  viewport.frame = viewport.frame + 1
  focus.x =  viewport.width/2 + (math.cos(viewport.frame * base.speed) * base.width)
  focus.y =  viewport.height/2 + (math.sin(viewport.frame * base.speed) * base.width)
  focus2.x = viewport.width/2 + (1 - math.cos(viewport.frame * base.speed) * base.width)
  focus2.y = viewport.height/2 + (1 - math.sin(viewport.frame * base.speed) * base.width)
  
  focus3.x = focus.x + (math.cos(viewport.frame * orbit.speed) * orbit.width)
  focus3.y = focus.y + (math.sin(viewport.frame * orbit.speed) * orbit.width)
  focus4.x = focus.x + (1 - math.cos(viewport.frame * orbit.speed) * orbit.width)
  focus4.y = focus.y + (1 - math.sin(viewport.frame * orbit.speed) * orbit.width)
  focus5.x = focus2.x + (math.cos(viewport.frame * orbit.speed) * orbit.width)
  focus5.y = focus2.y + (math.sin(viewport.frame * orbit.speed) * orbit.width)
  focus6.x = focus2.x + (1 - math.cos(viewport.frame * orbit.speed) * orbit.width)
  focus6.y = focus2.y + (1 - math.sin(viewport.frame * orbit.speed) * orbit.width)
  
  play(focus3)
  play(focus4)
  play(focus5)
  play(focus6)
  redraw()
end
re:start()
