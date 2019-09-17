function love.load()
    gridXCount = 20 -- how many cells across
    gridYCount = 15 -- how many cells up and down
    cellSize = 30 -- the size of a cell

    love.window.setMode(gridXCount * cellSize, gridYCount * cellSize) -- set the window size

    snakeSegments = { {x = 3, y = 1}, -- last segment
                      {x = 2, y = 1},
                      {x = 1, y = 1} } -- first (head) segment

    timer = 0 -- time to movement
    direction = 'right' -- starting direction
end

function love.update(dt)

    timer = timer + dt -- adds the delta time to timer
    local timerLimit = 0.15 --
    if timer >= timerLimit then
        timer = timer - timerLimit

        local nextXPosition = snakeSegments[1].x -- adjusting the next X
        local nextYPosition = snakeSegments[1].y -- adjusting the next Y

        if direction == 'right' then
            nextXPosition = nextXPosition + 1
            if nextXPosition > gridXCount then
                nextXPosition = 1
            end
        elseif direction == 'left' then
            nextXPosition = nextXPosition - 1
            if nextXPosition < 1 then
                nextXPosition = gridXCount
            end
        elseif direction == 'down' then
            nextYPosition = nextYPosition + 1
            if nextYPosition > gridYCount then
                nextYPosition = 1
            end
        elseif direction == 'up' then
            nextYPosition = nextYPosition - 1
            if nextYPosition < 1 then
                nextYPosition = gridYCount
            end
        end

        table.insert(snakeSegments, 1, {x = nextXPosition, y = nextYPosition})
        table.remove(snakeSegments)
    end

end

function love.draw()

    love.graphics.setColor(.28, .28, .28)
    love.graphics.rectangle('fill', 0, 0, gridXCount * cellSize, gridYCount * cellSize)

    love.graphics.setColor(1,1,1)
    love.graphics.print(tostring(math.ceil(snakeSegments[1].x)) , 100, 100)
    love.graphics.print(tostring(math.ceil(snakeSegments[1].y)) , 150, 100)

    for segmentIndex, segment in ipairs(snakeSegments) do
        love.graphics.setColor(.6, 1, .32)
        love.graphics.rectangle('fill', (segment.x - 1) * cellSize, (segment.y - 1) * cellSize, cellSize - 1, cellSize - 1)
    end

    function love.keypressed(key)
        if key == 'right' then
            direction = 'right'
        elseif key == 'left' then
            direction = 'left'
        elseif key == 'down' then
            direction = 'down'
        elseif key == 'up' then
            direction = 'up'
        elseif key == 'escape' then -- end game with escape
            love.event.push("quit")
        end
    end

end
