-- space invaders - PICO-8 tutorial
-- https://github.com/bbgs/pico-8-tutorials

aliens = {}

-- alien collective display x and y offset in pixels
a_y_offset = 0
a_x_offset = 0

-- alien direction : 1=right, -1=left
a_dir = 1

-- number of ticks between alien movements
a_speed = 4

-- number of pixels aliens move 
a_x_step = 2
a_y_step = 8

-- tick - updated every 1/30 second
tick = 0

function draw_aliens()
  for col=1,10 do
    for row=1,5 do
      spr(aliens[col][row].sprite,(col-1)*10+a_x_offset,row*10+a_y_offset)
    end
  end
end

function move_aliens()
  a_x_offset += a_dir*a_x_step
  -- if aliens reached end of line; move down and change direction
  if a_x_offset >= 30 or a_x_offset <= 0 then
    a_y_offset += a_y_step -- move down
    a_dir *= -1  -- change direction
  end
end

function _update()
  tick += 1

  if tick % a_speed == 0 then
    move_aliens()
  end
end

function _draw()
  rectfill(0,0,127,127,0)
  draw_aliens()
end

function _init()
  for col=1,10 do
    aliens[col] = {}
    for row=1,5 do
      add(aliens[col], {sprite=row})
    end
  end
end
