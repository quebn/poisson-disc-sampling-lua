---@class PoissonDiscSampling
local M = {}
local sqrt = math.sqrt
local rand = math.random
local floor, ceil = math.floor, math.ceil
local cos, sin = math.cos, math.sin
local pi = math.pi

local vector_zero = { x = 0, y = 0 }
vector_zero.__index = vector_zero

---@alias PDSVector2 { x:number, y:number }

---@param x number
---@param y number
---@param size number
local function index_array2D(x, y, size)
    return (x-1) + (y-1) * size + 1
end

---@param v PDSVector2
---@param size number
---@return PDSVector2
local function image_to_grid(v, size)
    return {
        x = floor(v.x / size),
        y = floor(v.y / size),
    }
end

---@param v PDSVector2
---@param dist number
---@return PDSVector2
local function generate_random_point_around(v, dist)
    local r1 = rand()
    local r2 = rand()

    local radius = dist * (r1 + 1)
    local angle = 2 * pi * r2
    return {
        x = v.x + radius * cos(angle),
        y = v.y + radius * sin(angle)
    }
end

---@param width number
---@param height number
---@param point PDSVector2
---@return boolean
local function in_rectangle(width, height, point)
    local x = point.x
    local y = point.y
    return x > 0 and x <= width and y > 0 and y <= height
end

---@param start_point PDSVector2
---@param end_point PDSVector2
---@return number
local function distance(start_point, end_point)
    local dx = end_point.x - start_point.x
    local dy = end_point.y - start_point.y
    return math.sqrt(dx * dx + dy * dy)
end

---@param grid PDSVector2[]
---@param grid_size number
---@param grid_point PDSVector2
---@param size number
---@return PDSVector2[]
local function square_around_point(grid, grid_size, grid_point, size)
    local around = {}
    local gx = grid_point.x
    local gy = grid_point.y
    for x = gx - size, gx + size do
        for y = gy - size, gy + size do
            local index = index_array2D(x, y, grid_size)
            local cell = grid[index]
            if cell ~= nil then
                table.insert(around, cell)
            end
        end
    end
    return around
end

---@param grid PDSVector2[]
---@param grid_size number
---@param point PDSVector2
---@param dist number
---@param cell_size number
---@return boolean
local function in_neighbourhood(grid, grid_size, point, dist, cell_size)
    local grid_point = image_to_grid(point, cell_size)
    local cells_around_point = square_around_point(grid, grid_size, grid_point, 2)
    for i = 1, #cells_around_point do
        local cell = cells_around_point[i]
        if distance(cell, point) < dist then
            return true
        end
    end
    return false
end

---@param point PDSVector2
---@param cell_size number
---@param grid_width number
---@return number index
local function image_grid_index(point, cell_size, grid_width)
    local pos = image_to_grid(point, cell_size)
    return index_array2D(pos.x, pos.y ,grid_width)
end

---@param width number
---@param height number
---@param min_dist number
---@param tries? number defaults to `20` if `nil`
---@return PDSVector2[]
function M.generate(width, height, min_dist, tries)
    assert(min_dist > 0, string.format("PDS.generate: invalid min_dist value of: %s", min_dist))
    tries = tries or 20
    local cell_size = min_dist / sqrt(2)

    local grid_w, grid_h = ceil(width / cell_size), ceil(height / cell_size)
    ---@type PDSVector2[]
    local grid = {}
    for i = 1, grid_w * grid_h do
        grid[i] = setmetatable({}, vector_zero)
    end

    local process_list = {}
    local sample_points = {}

    local first_point = { x = rand(width), y = rand(height) }
    table.insert(process_list, first_point)
    table.insert(sample_points, first_point)
    local index = image_grid_index(first_point, cell_size, grid_w)
    grid[index] = first_point

    while #process_list ~= 0 do
        local point = table.remove(process_list, rand(#process_list))
        for _ = 1, tries do
            local new_point = generate_random_point_around(point, min_dist)
            if in_rectangle(width, height, new_point) and not in_neighbourhood(grid, grid_w, new_point, min_dist, cell_size) then
                table.insert(process_list, new_point)
                table.insert(sample_points, new_point)
                index = image_grid_index(new_point, cell_size, grid_w)
                grid[index] = new_point
            end
        end
    end
    return sample_points
end

return M
