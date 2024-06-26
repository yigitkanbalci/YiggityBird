Bird = Class{}

GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    if love.keyboard.wasPressed('space') then
        AudioPlayer:play("flap")
        self.dy = -5
    end

    self.y = self.dy + self.y
end

function Bird:collides(pipe)
    local buffer = 10

    if (self.x + buffer) + (self.width - 2 * buffer) >= pipe.x and self.x + buffer <= pipe.x + pipe.width then
        if (self.y + buffer) + (self.height - 2 * buffer) >= pipe.y and self.y + buffer <= pipe.y + pipe.height then
            return true
        end
    end

    return false
end
