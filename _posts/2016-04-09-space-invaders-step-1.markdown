---
layout: post
title:  "PICO-8 tutorial - space invaders - step 1"
date:   2016-04-09 08:16
categories: pico-8 tutorial
---

Quote from [the PICO-8 site](http://www.lexaloffle.com/pico-8.php).

> PICO-8 is a fantasy console for making, sharing and playing tiny games and other computer programs. When you turn it on, the machine greets you with a shell for typing in Lua commands and provides simple built-in tools for creating your own cartridges.

Seems like a nice platform to encourage my children to start programming! Let's try to make a simple Space Invaders clone.

Any game (or program for that matter) should be built on strong foundations. I start the Space Invaders clone by adding the standard PICO-8 callbacks (see the [PICO-8 manual for details](http://www.lexaloffle.com/pico-8.php?page=manual)). Since PICO-8 has no support for timeouts I add a variable called tick that is increased with 1 every 1/30 second (forming the base of all animations / movements etc).

{% highlight lua %}
-- space invaders - PICO-8 tutorial
-- https://github.com/bbgs/pico-8-tutorials

-- Tick - updated every 1/30 second.
tick = 0

function _update()
  tick += 1
end

function _draw()
  rectfill(0,0,127,127,0)
end

function _init()
end 
{% endhighlight %}

Add some aliens. I've added 5 types of aliens at PICO-8 sprite index 1-5 with a second animation frame at sprite index + 16.

![](/pico-8-tutorials/img/space-invaders-001.png)

Let's try to draw the aliens to the screen. 

Start by adding a global variable to hold the aliens.

{% highlight lua %}
aliens = {}
{% endhighlight %}

Each alien is represented by a Lua table (which is an associative array) and will contain the following keys : 

    sprite - PICO-8 sprite index
    x      - X position of sprite (left)
    y      - Y position of sprite (top)

So to draw a single alien I can use the following syntax.

{% highlight lua %}
 spr(alien.sprite,alien.x,alien.y)
{% endhighlight %}

Create all aliens in the _init function (which is called when the game is started). The aliens are added in a multidimensional array with the first index being the column and the second index being the row. The top left alien is accessible at aliens[1][1].

{% highlight lua %}
function _init()
  aliens = {}
  for col=1,10 do
    aliens[col] = {}
    for row=1,5 do
      add(aliens[col], {sprite=row,x=(col-1)*10,y=row*10})
    end
  end
end
{% endhighlight %}

To draw the aliens use the following helper function.

{% highlight lua %}
-- Draw all aliens.
function draw_aliens()
  for col=1,10 do
    for row=1,5 do
      alien = aliens[col][row]
      spr(alien.sprite,alien.x,alien.y)
    end
  end
end
{% endhighlight %}

And don't forget to call it in the _draw callback.

{% highlight lua %}
function _draw()
  rectfill(0,0,127,127,0)
  draw_aliens()
end
{% endhighlight %}

And you should get something like this...

![](/pico-8-tutorials/img/space-invaders-002.png)


[github]: https://github.com/bbgs/pico-8-tutorials
