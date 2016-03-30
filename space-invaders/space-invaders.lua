-- space invaders - PICO-8 tutorial
-- https://github.com/bbgs/pico-8-tutorials

-- Multi-dimensional array with alien objecs - index column row.
-- Alien object
--   x      x coordiate
--   y      y coordinate
--   sprite sprite index (see sprite sheet)
--   dead   boolean - true if dead
aliens = {}

-- Alien collective display x and y offset in pixels.
collective_y = 0
collective_x = 0

-- Alien direction : 1=right, -1=left.
collective_dir = 1

-- Number of ticks between alien movements.
collective_speed = 4

-- Number of pixels aliens collective move.
collective_x_step = 3
collective_y_step = 9

-- Cannon position.
cannon_x = 64

-- Bullet postion. 
-- Note : if bullet_y == -1 cannon is unfired.
bullet_x = -1
bullet_y = -1

-- Number of pixels bullet move each tick.
bullet_step = 8

bomb_x = -1
bomb_y = -1
bomb_step = 4

-- Tick - updated every 1/30 second.
tick = 0

-- Player score and lives.
score = 0
lives = 3

-- Game running or not?
running = false

-- Draw all aliens (note each alien is drawn with collective_x / collective_y offset).
function draw_aliens()

  -- if bit 3 == 1 show 1st animation frame, otherwise show 2nd animation frame.
  frame = shr(band(tick,4),2)

  for col=1,10 do
    for row=1,5 do
      alien = aliens[col][row]
      if not alien.dead then
        spr(alien.sprite+frame*16,alien.x+collective_x,alien.y+collective_y)
      end 
    end
  end
end

-- Draw bombs.
function draw_bomb()
  if bomb_y ~= -1 then
    spr(33,bomb_x,bomb_y)
  end
end

-- Draw cannon.
function draw_cannon()
  spr(16,cannon_x,120)
end

-- Draw bullet.
function draw_bullet()
  if bullet_y ~= -1 then
    spr(32,bullet_x,bullet_y)
  end
end

-- Move all aliens.
function move_aliens()
  collective_x += collective_dir*collective_x_step
  -- if aliens reached end of line; move down and change direction
  if collective_x >= 30 or collective_x <= 0 then
    collective_y += collective_y_step -- move down
    collective_dir *= -1  -- change direction
  end
end

-- Move bullet. 
function move_bullet()
  if bullet_y ~= -1 then
    bullet_y -= bullet_step
  end
  if bullet_y < 0 then
    bullet_y = -1
  end
end

-- Move bomb.
function move_bomb()
  if bomb_y ~= -1 then
    bomb_y += bomb_step
  end
  if bomb_y > 128 then
    bomb_y = -1
  end
end

-- Add bomb (only sometimes and in random column).
function add_bomb()
  if flr(rnd(10)) == 0 then
    -- Which column?
    column = flr(rnd(10))+1
    row = 5
    while bomb_y == -1 and row>0 do
      if not aliens[column][row].dead then
        bomb_y = aliens[column][row].y+collective_y+10
        bomb_x = aliens[column][row].x+collective_x+3
      end
      row-=1
    end
  end
end

-- Check hit box (does rectangles overlap).
-- x1,y1 and x2,y2 - top left corner
-- w1,h1 and w2,h2 - width and height
function check_hb(x1,y1,w1,h1,x2,y2,w2,h2)

  if x1<(x2+w2) and (x1+w1)>x2 and y1<(y2+h2) and (y1+h1)>y2 then
    return true
  end

  return false
end

-- Check bullet / alien collision. 
function check_bullet()

  if bullet_y == -1 then
    return
  end

  for col=1,10 do
    for row=5,1,-1 do
      if not aliens[col][row].dead then 
        alien_x = aliens[col][row].x+collective_x
        alien_y = aliens[col][row].y+collective_y
        if check_hb(bullet_x,bullet_y,2,5,alien_x,alien_y,8,8) then
          aliens[col][row].dead = true
          bullet_y = -1
          bullet_x = -1
          score += 10
          return
        end
      end
    end
  end
end

function check_bomb()

  if bomb_y==-1 then
    return
  end

  if check_hb(bomb_x,bomb_y+3,2,5,cannon_x,120,8,8) then
    die()
  end
end

function die()
    lives-=1
    bomb_y=-1
    bomb_x=-1
    if lives==0 then
      running = false
      lives=3
    end
    _init()
end

function check_alien()
  for col=1,10 do
    for row=5,1,-1 do
      if not aliens[col][row].dead then
        if aliens[col][row].y+collective_y > 120 then
          die()
        end
      end
    end
  end
end

function all_dead()
  for col=1,10 do
    for row=1,5 do
      if not aliens[col][row].dead then
        return false
      end
    end
  end

  return true
end

function _update()
  tick += 1

  if running then

    -- Move aliens every collective_speed ticks (to get that jerky space invaders
    -- movement).
    if tick % collective_speed == 0 then
      move_aliens()
    end

    move_bomb()
    move_bullet()

    check_bullet()
    check_bomb()
    check_alien()

    add_bomb()

    -- Move cannon.
    if btn(0) and cannon_x > 0 then
      cannon_x -= 2
    elseif btn(1) and cannon_x < 120 then
      cannon_x += 2
    end

    -- Fire cannon.
    if btn(4) and bullet_y == -1 then
      bullet_y = 116
      bullet_x = cannon_x+3
    end
  
    if all_dead() then
      _init()
    end

  else
    if btn(5) then
      running = true
      score = 0
    end
  end
end

function _draw()
  rectfill(0,0,127,127,0)

  draw_aliens()
  draw_cannon()
  draw_bullet()
  draw_bomb()

  print(score,2,2,14)
  print("LIVES "..lives,100,2,14)

  if not running then
    print("PRESS X TO START",32,80,4)
  end
end

function _init()
  aliens = {}
  collective_x = 0
  collective_y = 0
  collective_dir = 1
  for col=1,10 do
    aliens[col] = {}
    for row=1,5 do
      add(aliens[col], {sprite=row,x=(col-1)*10,y=row*10,dead=false})
    end
  end
end
