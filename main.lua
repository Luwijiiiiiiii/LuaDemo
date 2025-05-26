function love.load()
    -- Game settings
    game = {
        width = 800,
        height = 600,
        scoreLeft = 0,
        scoreRight = 0,
        winningScore = 5
    }
    
    -- Paddles
    paddle = {
        width = 15,
        height = 100,
        speed = 500
    }
    
    leftPaddle = {
        x = 50,
        y = game.height/2 - paddle.height/2
    }
    
    rightPaddle = {
        x = game.width - 50 - paddle.width,
        y = game.height/2 - paddle.height/2
    }
    
    -- Ball
    ball = {
        x = game.width/2,
        y = game.height/2,
        radius = 10,
        speed = 400,
        dx = 0,
        dy = 0
    }
    
    -- Start the game
    resetBall()
    
    -- Controls
    leftUp = false
    leftDown = false
    rightUp = false
    rightDown = false
end

function love.update(dt)
    if game.gameOver then return end
    
    -- Move paddles
    if leftUp then
        leftPaddle.y = math.max(0, leftPaddle.y - paddle.speed * dt)
    end
    if leftDown then
        leftPaddle.y = math.min(game.height - paddle.height, leftPaddle.y + paddle.speed * dt)
    end
    if rightUp then
        rightPaddle.y = math.max(0, rightPaddle.y - paddle.speed * dt)
    end
    if rightDown then
        rightPaddle.y = math.min(game.height - paddle.height, rightPaddle.y + paddle.speed * dt)
    end
    
    -- Move ball
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt
    
    -- Ball collision with top and bottom
    if ball.y - ball.radius < 0 then
        ball.y = ball.radius
        ball.dy = -ball.dy
    elseif ball.y + ball.radius > game.height then
        ball.y = game.height - ball.radius
        ball.dy = -ball.dy
    end
    
    -- Ball collision with paddles
    -- Left paddle
    if ball.x - ball.radius < leftPaddle.x + paddle.width and
       ball.x - ball.radius > leftPaddle.x and
       ball.y + ball.radius > leftPaddle.y and
       ball.y - ball.radius < leftPaddle.y + paddle.height then
       
        ball.x = leftPaddle.x + paddle.width + ball.radius
        ball.dx = -ball.dx * 1.1 -- Increase speed slightly
        -- Add some angle based on where it hits the paddle
        local hitPosition = (ball.y - leftPaddle.y) / paddle.height
        ball.dy = (hitPosition - 0.5) * ball.speed
    end
    
    -- Right paddle
    if ball.x + ball.radius > rightPaddle.x and
       ball.x + ball.radius < rightPaddle.x + paddle.width and
       ball.y + ball.radius > rightPaddle.y and
       ball.y - ball.radius < rightPaddle.y + paddle.height then
       
        ball.x = rightPaddle.x - ball.radius
        ball.dx = -ball.dx * 1.1 -- Increase speed slightly
        -- Add some angle based on where it hits the paddle
        local hitPosition = (ball.y - rightPaddle.y) / paddle.height
        ball.dy = (hitPosition - 0.5) * ball.speed
    end
    
    -- Scoring
    if ball.x - ball.radius < 0 then
        game.scoreRight = game.scoreRight + 1
        resetBall()
    elseif ball.x + ball.radius > game.width then
        game.scoreLeft = game.scoreLeft + 1
        resetBall()
    end
    
    -- Check for winner
    if game.scoreLeft >= game.winningScore or game.scoreRight >= game.winningScore then
        game.gameOver = true
    end
end

function love.draw()
    -- Draw background
    love.graphics.clear(0, 0, 0)
    
    -- Draw center line
    love.graphics.setLineWidth(2)
    for y = 0, game.height, 20 do
        love.graphics.line(game.width/2, y, game.width/2, y + 10)
    end
    
    -- Draw paddles
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", leftPaddle.x, leftPaddle.y, paddle.width, paddle.height)
    love.graphics.rectangle("fill", rightPaddle.x, rightPaddle.y, paddle.width, paddle.height)
    
    -- Draw ball
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)
    
    -- Draw scores
    love.graphics.print(game.scoreLeft, game.width/4, 20)
    love.graphics.print(game.scoreRight, game.width*3/4, 20)
    
    -- Draw game over message
    if game.gameOver then
        love.graphics.printf("GAME OVER\n" .. 
                           (game.scoreLeft > game.scoreRight and "LEFT PLAYER WINS!" or "RIGHT PLAYER WINS!") .. 
                           "\nPress R to restart", 
                           0, game.height/2 - 30, game.width, "center")
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "r" and game.gameOver then
        love.load()
    elseif key == "w" then
        leftUp = true
    elseif key == "s" then
        leftDown = true
    elseif key == "up" then
        rightUp = true
    elseif key == "down" then
        rightDown = true
    end
end

function love.keyreleased(key)
    if key == "w" thenS
        leftUp = false
    elseif key == "s" then
        leftDown = false
    elseif key == "up" then
        rightUp = false
    elseif key == "down" then
        rightDown = false
    end
end

function resetBall()
    ball.x = game.width/2
    ball.y = game.height/2
    ball.dx = math.random(2) == 1 and ball.speed or -ball.speed
    ball.dy = (math.random() - 0.5) * ball.speed
end