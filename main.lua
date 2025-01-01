local GAME_STATES = {
    MENU = 1,
    PLAY = 2
}

local MOUSE_BUTTON = {
    LEFT = 1,
    RIGHT = 2
}

function love.load()
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

    score = 0
    timer = 0
    gameState = GAME_STATES.MENU

    guiOffsetSize = 5

    gameFont = love.graphics.newFont(40)
    love.mouse.setVisible(false)
end

function love.update(dt)
    updateTimer(dt)
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print("Score: " .. score, guiOffsetSize, guiOffsetSize)
    love.graphics.print("Timer: " .. math.ceil(timer), love.graphics.getWidth() - 200, guiOffsetSize)

    if gameState == GAME_STATES.MENU then
        love.graphics.printf("Click anywhere to begin!", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
    else
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
        -- 20 is half the width of the crosshairs sprite
        love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameState == GAME_STATES.MENU  and button == MOUSE_BUTTON.LEFT then
        resetDataAndStartNewGame()
    end

    if gameState == GAME_STATES.PLAY then
        isTargetHit = distanceBetween(target.x, target.y, x, y) < target.radius
        if isTargetHit then
            onTargetHit(button)
        elseif not isTargetHit then
            onTargetMiss()
        end
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function updateTimer(dt)
    if timer > 0 then
        timer = timer - dt
    end

    if timer < 0 then
        timer = 0
        gameState = GAME_STATES.MENU
    end
end

function resetDataAndStartNewGame()
    score = 0
    timer = 10
    gameState = GAME_STATES.PLAY
    generateNewTarget()
end

function onTargetHit(mouseButton)
    updateScore(mouseButton)
    generateNewTarget()
end

function onTargetMiss()
    if score > 0 then
        score = score - 1
    end
end

function updateScore(mouseButton)
    if mouseButton == MOUSE_BUTTON.LEFT then
        score = score + 1
    else
        score = score + 2
        timer = timer - 1
    end
end

function generateNewTarget()
    target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
    target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
end