push = require "push"
Class = require "class"

require "Bird"
require "Pipe"
require "PipePair"
require "StateMachine"
require "states/BaseState"
require "states/PlayState"
require "states/TitleScreenState"
require "states/ScoreState"
require "states/CountdownState"
require "AudioPlayer"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

BACKGROUND_SCROLL_SPEED = 30
GROUND_SCROLL_SPEED = 60

LOOPBACK_POINT = 413

local background = love.graphics.newImage('images/background.png')
backgroundScroll = 0

local ground = love.graphics.newImage('images/ground.png')
groundScroll = 0

function love.conf(t)
    t.console = true
end

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Yiggity Bird')

    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false, vsync = true, resizable = true
    })
    math.randomseed(os.time())

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end,
    }

    sounds = {
        ['score'] = "Sounds/Score.wav",
        ['flap'] = "Sounds/Jump.wav",
        ['crash'] = "Sounds/Death.wav",
        ['countdown'] = "Sounds/Countdown.wav",
    }

    AudioPlayer = AudioPlayer(sounds)

    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == "escape" then  -- Fixed the escape key check
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key) 
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % LOOPBACK_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    
    -- Draw background first
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    -- Draw ground last
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
