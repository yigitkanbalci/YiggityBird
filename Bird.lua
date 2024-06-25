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
    if (self.x + 3) + (self.width - 5) >= pipe.x and self.x + 3 <= pipe.x + pipe.width then
        if (self.y + 3) + (self.height - 5) >= pipe.y and self.y + 3 <= pipe.y + pipe.height then
            return true
        end
    end

    return false
end