local pds = require("init")
local points = {}

local distance = 45
love.load = function()
    love.window.setMode(800, 800)
    points = pds.generate(800, 800, distance, 25)
    print("Width: "..love.graphics.getWidth())
    print("Height: "..love.graphics.getHeight())

end

love.keypressed = function(key)
    if key == "return" then
        points = pds.generate(800, 800, distance, 25)
    end
end

local cell_size = distance / math.sqrt(2)
local grid_w, grid_h = math.ceil(800 / cell_size), math.ceil(800 / cell_size)
love.draw = function()
    for i = 1, #points do
        local point = points[i]
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.circle("fill", point.x, point.y, 5)
        love.graphics.setColor(1, 1, 1, 1)
    end
    for y = 0, grid_h-1 do
        for x = 0, grid_w-1 do
            love.graphics.rectangle("line", x * cell_size, y * cell_size, cell_size, cell_size)
        end
    end
end
