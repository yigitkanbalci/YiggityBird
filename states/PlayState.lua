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
end

function PlayState:update(dt)
    self.timer = self.timer + dt

    if self.timer > 2 then
        local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastY + math.random(-30, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y
        table.insert(self.pipePairs, PipePair(y))
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
end