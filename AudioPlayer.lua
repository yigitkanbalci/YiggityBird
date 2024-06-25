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
    else
        print('No sound found with name "'.. name.. '"')    
    end
end

function AudioPlayer:stop(name)
    if self.sounds[name] then
        self.sounds[name]:stop()
    else
        print('No sound found with name "'.. name.. '"')
    end
end