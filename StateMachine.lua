StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end,
        pause = function() end,
        resume = function() end,
    }
    self.states = states or {}
    self.current = self.empty
    self.currStateName = "empty"
end

function StateMachine:change(state, params)
    assert(self.states[state])
    self.current:exit()
    self.current = self.states[state]()
    self.current:enter(params)
    self.currStateName = state
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end

function StateMachine:pause()
    self.current:pause()
end

function StateMachine:resume()
    self.current:resume()
end

function StateMachine:getCurrentStateName()
    return self.currStateName
end
