-- barycenter: fluctuating relationships 
-- 
-- v0.0.4 @echophon
--
-- ENC 1 - offset horizon
-- ENC 2 - adjust width
-- KEY 2 - toggle width focus
-- ENC 3 - adjust speed
-- KEY 3 - toggle speed focus


engine.name = 'PolyPerc'

viewport   = { width = 128, height = 64, frame = 0 }
base       = { width = 2+math.random(2,20), speed = math.random(1,10)*0.01 }
orbit      = { width = 2+math.random(2,20), speed = math.random(1,10)*0.01 }
focus      = { x = 0, y = 0, dirty = 0 }
focus2     = { x = 0, y = 0, dirty = 0 }
focus3     = { x = 0, y = 0, dirty = 0 }
focus4     = { x = 0, y = 0, dirty = 0 }
focus5     = { x = 0, y = 0, dirty = 0 }
focus6     = { x = 0, y = 0, dirty = 0 }
widthFocus = 0
speedFocus = 0
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
    widthFocus = (widthFocus + 1)%2
  elseif id == 3 and state == 1 then
    speedFocus = (speedFocus + 1)%2
  end
end

function enc(id,delta)
  if id == 2 and widthFocus == 0 then
    base.width = util.clamp(base.width + (delta*0.1),2,50)
    txt = base.width
  elseif id == 2 and widthFocus == 1 then
    orbit.width =  util.clamp(orbit.width + (delta*0.1),2,50)
    txt = orbit.width
  elseif id == 3 and speedFocus == 0 then
    base.speed = util.clamp(base.speed + (delta*0.01),-20,20)
    txt = base.speed
  elseif id == 3 and speedFocus == 1 then
    orbit.speed = util.clamp(orbit.speed + (delta*0.01),-20,20)
    txt = orbit.speed
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
  draw_circle(focus.x,focus.y,orbit.width,1)
  draw_circle(focus2.x,focus2.y,orbit.width,1)
  
  draw_circle(focus3.x,focus3.y,1+focus3.dirty,15)
  draw_circle(focus4.x,focus4.y,1+focus4.dirty,15)
  draw_circle(focus5.x,focus5.y,1+focus5.dirty,15)
  draw_circle(focus6.x,focus6.y,1+focus6.dirty,15)
  screen.update()
end

function distance( x1, y1, x2, y2 )
	return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end

function play(orb)
  if math.floor(orb.y) == horizon and orb.dirty == 0 then
    orb.dirty = 1
    
    if orb.dirty == 1 then 
      engine.release(orbit.width * 0.005)
      engine.cutoff(base.width * 50)
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
  viewport.frame = viewport.frame + 1
  focus.x =  viewport.width/2 + (math.cos(viewport.frame * base.speed * 0.01) * base.width)
  focus.y =  viewport.height/2 + (math.sin(viewport.frame * base.speed * 0.01) * base.width)
  focus2.x = viewport.width/2 + (1 - math.cos(viewport.frame * base.speed * 0.01) * base.width)
  focus2.y = viewport.height/2 + (1 - math.sin(viewport.frame * base.speed * 0.01) * base.width)
  
  focus3.x = focus.x + (math.cos(viewport.frame * orbit.speed * 0.01) * orbit.width)
  focus3.y = focus.y + (math.sin(viewport.frame * orbit.speed * 0.01) * orbit.width)
  focus4.x = focus.x + (1 - math.cos(viewport.frame * orbit.speed * 0.01) * orbit.width)
  focus4.y = focus.y + (1 - math.sin(viewport.frame * orbit.speed * 0.01) * orbit.width)
  focus5.x = focus2.x + (math.cos(viewport.frame * orbit.speed * 0.01) * orbit.width)
  focus5.y = focus2.y + (math.sin(viewport.frame * orbit.speed * 0.01) * orbit.width)
  focus6.x = focus2.x + (1 - math.cos(viewport.frame * orbit.speed * 0.01) * orbit.width)
  focus6.y = focus2.y + (1 - math.sin(viewport.frame * orbit.speed * 0.01) * orbit.width)
  
  play(focus3)
  play(focus4)
  play(focus5)
  play(focus6)
  redraw()
end
re:start()

