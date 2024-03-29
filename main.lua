function love.load()
    gridXCount = 20 -- how many cells across
    gridYCount = 15 -- how many cells up and down
    cellSize = 40 -- the size of a cell

    love.window.setMode(gridXCount * cellSize, gridYCount * cellSize) -- set the window size

    snakeSegments = { {x = 3, y = 1}, -- last segment
                      {x = 2, y = 1},
                      {x = 1, y = 1} } -- first (head) segment

    timer = 0 -- time to movement
    directionQueue = {'right'} -- starting direction
    math.randomseed(os.time())

    function moveFood()
        local possibleFoodPositions = {}

        for foodX = 1, gridXCount do
            for foodY = 1, gridYCount do
                local possible = true

                for segmentIndex, segment in ipairs(snakeSegments) do
                    if foodX == segment.x and foodY == segment.y then
                        possible = false
                    end
                end

                if possible then
                    table.insert(possibleFoodPositions, {x = foodX, y = foodY})
                end
            end
        end

        foodPosition = possibleFoodPositions[math.random(#possibleFoodPositions)]
    end

    snakeAlive = true
    moveFood()
end

function love.update(dt)

    timer = timer + dt -- adds the delta time to timer

    if snakeAlive then

        local timerLimit = 0.15 --
        if timer >= timerLimit then
            timer = timer - timerLimit

            if #directionQueue > 1 then
                table.remove(directionQueue, 1)
            end

            local nextXPosition = snakeSegments[1].x -- adjusting the next X
            local nextYPosition = snakeSegments[1].y -- adjusting the next Y

            if directionQueue[1] == 'right' then
                nextXPosition = nextXPosition + 1
                if nextXPosition > gridXCount then
                    nextXPosition = 1
                end
            elseif directionQueue[1] == 'left' then
                nextXPosition = nextXPosition - 1
                if nextXPosition < 1 then
                    nextXPosition = gridXCount
                end
            elseif directionQueue[1] == 'down' then
                nextYPosition = nextYPosition + 1
                if nextYPosition > gridYCount then
                    nextYPosition = 1
                end
            elseif directionQueue[1] == 'up' then
                nextYPosition = nextYPosition - 1
                if nextYPosition < 1 then
                    nextYPosition = gridYCount
                end
            end

            local canMove = true

            for segmentIndex, segment in ipairs(snakeSegments) do
                if segmentIndex ~= #snakeSegments and nextXPosition == segment.x and nextYPosition == segment.y then
                    canMove = false
                end
            end

            if canMove then
                table.insert(snakeSegments, 1, {x = nextXPosition, y = nextYPosition})
                if snakeSegments[1].x == foodPosition.x and snakeSegments[1].y == foodPosition.y then
                    moveFood()
                else
                    table.remove(snakeSegments)
                end
            else
                snakeAlive = false
            end
        end
    elseif timer >= 2 then
      reset()
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
        drawCell(segment.x, segment.y)
    end

    love.graphics.setColor(1, .3, .3)
    drawCell(foodPosition.x, foodPosition.y)
end

function love.keypressed(key)
    if key == 'right'
        and directionQueue[#directionQueue] ~= 'right'
        and directionQueue[#directionQueue] ~= 'left' then
            table.insert(directionQueue, 'right')

    elseif key == 'left'
        and directionQueue[#directionQueue] ~= 'left'
        and directionQueue[#directionQueue] ~= 'right' then
            table.insert(directionQueue, 'left')

    elseif key == 'up'
        and directionQueue[#directionQueue] ~= 'up'
        and directionQueue[#directionQueue] ~= 'down' then
            table.insert(directionQueue, 'up')

    elseif key == 'down'
        and directionQueue[#directionQueue] ~= 'down'
        and directionQueue[#directionQueue] ~= 'up' then
            table.insert(directionQueue, 'down')

    elseif key == 'escape' then -- end game with escape
        love.event.push("quit")
    end
end

function drawCell(x, y)
    love.graphics.rectangle('fill', (x-1) * cellSize, (y-1) * cellSize, cellSize - 1, cellSize - 1)
end
