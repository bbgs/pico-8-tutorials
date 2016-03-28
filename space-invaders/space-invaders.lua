-- space invaders - PICO-8 tutorial
-- https://github.com/bbgs/pico-8-tutorials

aliens = {}

-- alien collective display x and y offset in pixels
alien_y = 0
alien_x = 0

-- alien direction : 1=right, -1=left
alient_dir = 1

-- number of ticks between alien movements
alien_speed = 4

-- number of pixels aliens move 
alien_x_step = 2
alien_y_step = 8

-- canon position
canon_x = 64

-- bullet postion
bullet_x = -1
bullet_y = -1

-- number of pixels bullet move each tick
bullet_step = 8

-- tick - updated every 1/30 second
tick = 0

function draw_aliens()
  for col=1,10 do
    for row=1,5 do
      spr(aliens[col][row].sprite,(col-1)*10+alien_x,row*10+alien_y)
    end
  end
end

function move_aliens()
  alien_x += alient_dir*alien_x_step
  -- if aliens reached end of line; move down and change direction
  if alien_x >= 30 or alien_x <= 0 then
    alien_y += alien_y_step -- move down
    alient_dir *= -1  -- change direction
  end
end

function move_bullet()
  if bullet_y ~= -1 then
    bullet_y -= bullet_step
  end
  if bullet_y < 0 then
    bullet_y = -1
  end
end

function _update()
  tick += 1

  if tick % alien_speed == 0 then
    move_aliens()
  end

  move_bullet()

  if btn(0) and canon_x > 0 then
    canon_x -= 2
  elseif btn(1) and canon_x < 120 then
    canon_x += 2
  end

  if btn(4) and bullet_y == -1 then
    bullet_y = 116
    bullet_x = canon_x
  end
end

function _draw()
  rectfill(0,0,127,127,0)
  draw_aliens()
  spr(16,canon_x,120)
  if bullet_y ~= -1 then
    spr(32,bullet_x,bullet_y)
  end
end

function _init()
  for col=1,10 do
    aliens[col] = {}
    for row=1,5 do
      add(aliens[col], {sprite=row})
    end
  end
end
