---
layout: post
title:  "PICO-8 tutorial - space invaders"
date:   2016-03-28 07:58:35 +0200
categories: pico-8 tutorial
---

![screenshot]({{ site.url }}/img/space-invaders-001.png)

{% highlight lua %}
-- space invaders - PICO-8 tutorial
-- https://github.com/bbgs/pico-8-tutorials

aliens = {}

function draw_aliens()
  for col=1,10 do
    for row=1,5 do
      spr(aliens[col][row].sprite,col*10,row*10)
    end
  end
end

function _update()
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
{% endhighlight %}

[github]: https://github.com/bbgs/pico-8-tutorials
