PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    AudioPlayer:play("soundtrack")
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20

    self.score = 0
    self.paused = false
end

function PlayState:update(dt)
    if self.paused then return end


    self.timer = self.timer + dt
    local difficultyFactor = math.min(5, math.floor(self.score / 5) + 1)
    if self.timer > math.random(5 - difficultyFactor, 5) then
        local newY = self.lastY + math.random(-30, 20 * difficultyFactor)

        newY = math.max(-PIPE_HEIGHT + 10, newY)
        newY = math.min(VIRTUAL_HEIGHT - math.random(70, 150) - PIPE_HEIGHT, newY)

        self.lastY = newY
        table.insert(self.pipePairs, PipePair(newY))
        self.timer = 0
    end

    self.bird:update(dt)

    for k, pipes in pairs(self.pipePairs) do
        if not pipes.scored then 
            if pipes.x + PIPE_WIDTH < self.bird.x then
                AudioPlayer:play("score")
                self.score = self.score + 1
                pipes.scored = true
            end
        end

        pipes:update(dt)

        for l, pipe in pairs(pipes.pipes) do
            if self.bird:collides(pipe) then
                AudioPlayer:play("crash")
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
        
        if pipes.x < -PIPE_WIDTH then
            pipes.remove = true
        end
    end
        
    for k, pipes in pairs(self.pipePairs) do     
        if pipes.remove then
            table.remove(self.pipePairs, k)
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        AudioPlayer:play("crash")
        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    self.bird:render()

    if self.paused then
        love.graphics.setFont(flappyFont)
        love.graphics.printf('Paused...', 0, 64, VIRTUAL_WIDTH, "center")
    end
end

function PlayState:pause()
    self.paused = true
end

function PlayState:resume()
    self.paused = false
end