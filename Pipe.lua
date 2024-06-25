Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('images/pipe.png')
PIPE_SCROLL = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(type, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.type = type

end

function Pipe:update(dt)
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
                (self.type == 'top' and self.y + PIPE_HEIGHT or self.y), 0 , 1,
                    self.type =='top' and -1 or 1)
end