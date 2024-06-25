AudioPlayer = Class{}

function AudioPlayer:init(sounds)
    self.sounds = {}
    for name, filePath in pairs(sounds) do
        self.sounds[name] = love.audio.newSource(filePath, 'static')
    end
end

function AudioPlayer:play(name)
    if self.sounds[name] then
        self.sounds[name]:stop()
        self.sounds[name]:play()
    end
end

function AudioPlayer:stop(name)
    if self.sounds[name] then
        self.sounds[name]:stop()
    end
end

function AudioPlayer:pause(name)
    if self.sounds[name] then
        self.sounds[name]:pause()
    end
end

function AudioPlayer:resume(name)
    if self.sounds[name] then
        self.sounds[name]:play()
    end
end