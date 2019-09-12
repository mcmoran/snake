function love.load()
    gridXCount = 20
    gridYCount = 10
    cellSize = 30

    love.window.setMode(gridXCount * cellSize, gridYCount * cellSize)

    snakeSegments = { {x = 3, y = 1},
                      {x = 2, y = 1},
                      {x = 1, y = 1} }

    timer = 0
    direction = 'right'
end

function love.update(dt)

    timer = timer + dt
    local timerLimit = 0.15
    if timer >= timerLimit then
        timer = timer - timerLimit

        local nextXPosition = snakeSegments[1].x
        local nextYPosition = snakeSegments[1].y

        if direction == 'right' then
            nextXPosition = nextXPosition + 1
        elseif direction == 'left' then
            nextXPosition = nextXPosition - 1
        elseif direction == 'down' then
            nextYPosition = nextYPosition + 1
        elseif direction == 'up' then
            nextYPosition = nextYPosition - 1
        end

        table.insert(snakeSegments, 1, {x = nextXPosition, y = nextYPosition})
        table.remove(snakeSegments)
    end


end

function love.draw()

    love.graphics.setColor(.28, .28, .28)
    love.graphics.rectangle('fill', 0, 0, gridXCount * cellSize, gridYCount * cellSize)

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
