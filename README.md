# Poisson Disc Sampling Implementation for Lua

Lua implementation of the [Poisson Disc Sampling](https://en.wikipedia.org/wiki/Supersampling#Poisson_disk) algorithm.

## Usage
1. Clone the repo.
```sh
$ git clone https://github.com/quebn/poisson-disc-sampling-lua pds
```

2.  Use the module
```lua
local pds = require("pds")

-- Generate points on 800 width by 600 height with 40 distance betweens points and 25 tries on point generation
local points = pds.generate(800, 600, 40, 25)
-- Points are list of Vectors with struct of { x:number, y:number }
```

## Example (using love2d)

```lua
local pds = require("pds")
local points = {}

function love.load()
    points = pds.generate(800, 600, 40, 25)
end

function love.draw()
    for i = 1, #points do
        local point = points[i]
        love.graphics.circle("fill", point.x, point.y, 5)
    end
end
```

## Acknowledgments

[Poisson Disk Sampling Tutorial](http://devmag.org.za/2009/05/03/poisson-disk-sampling). Implemented the algorithm following this article.

## LICENSE
MIT License
