local week1 = {}
local song = 1
local difficulty

local stageback, stagefront, stagecurtains

function week1:enter(from, song_, diff)
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter()

    enemy = love.filesystem.load("assets/sprites/week1/daddy-dearest.lua")()

    stageback = graphics.newImage(graphics.imagePath("stages/stage/stageback"))
    stagefront = graphics.newImage(graphics.imagePath("stages/stage/stagefront"))
    stagecurtains = graphics.newImage(graphics.imagePath("stages/stage/stagecurtains"))

    stagefront.y = 92
    stagecurtains.y = -23

    girlfriend.y = -30
    boyfriend.y = 35
    boyfriend.x = 85

    enemy.x = -85

    self:load()
end

function week1:load()
    weeks:load()
    if song == 1 then
        inst = love.audio.newSource("assets/songs/week1/bopeebo/Inst" .. (isErect and "-erect" or "") .. ".ogg", "stream")
        voices = love.audio.newSource("assets/songs/week1/bopeebo/Voices" .. (isErect and "-erect" or "") .. ".ogg", "stream")
    elseif song == 2 then
        inst = love.audio.newSource("assets/songs/week1/fresh/Inst" .. (isErect and "-erect" or "") .. ".ogg", "stream")
        voices = love.audio.newSource("assets/songs/week1/fresh/Voices" .. (isErect and "-erect" or "") .. ".ogg", "stream")
    elseif song == 3 then
        inst = love.audio.newSource("assets/songs/week1/dadbattle/Inst" .. (isErect and "-erect" or "") .. ".ogg", "stream")
        voices = love.audio.newSource("assets/songs/week1/dadbattle/Voices" .. (isErect and "-erect" or "") .. ".ogg", "stream")
    end
    
    self:initUI()
end

function week1:initUI()
    weeks:initUI()
    if isErect then
        if difficulty == "-easy" or difficulty == "" then
            difficulty = "-erect"
        else
            difficulty = "-nightmare"
        end
    end

    if song == 1 then
        weeks:generateNotes("assets/data/week1/bopeebo/bopeebo"..difficulty..".lua")
    elseif song == 2 then
        weeks:generateNotes("assets/data/week1/fresh/fresh"..difficulty..".lua")
    elseif song == 3 then
        weeks:generateNotes("assets/data/week1/dadbattle/dadbattle"..difficulty..".lua")
    end
    weeks:setupCountdown()
end

function week1:update(dt)
    weeks:update(dt)
    weeks:updateEvents(dt)

    if not isErect then
        if song == 1 and musicThres ~= oldMusicThres and math.fmod(absMusicTime + 500, 480000 / bpm) < 100 then
            boyfriend:animate("hey", false)
            girlfriend:animate("cheer", false)
        end
    end

    if not countingDown and not inst:isPlaying() then
        song = song + 1
        if song > 3 then
            state.switch(title)
        else
            self:load()
        end
    end
end

function week1:topDraw()
    love.graphics.push()
        love.graphics.translate(200,120)
        

        love.graphics.push()
        love.graphics.translate(camera.x*0.9, camera.y*0.9)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
            stageback:draw()
            stagefront:draw()
            girlfriend:draw()
        love.graphics.pop()
        
        love.graphics.push()
        love.graphics.translate(camera.x, camera.y)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
            boyfriend:draw()
            enemy:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x*1.1, camera.y*1.1)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
            stagecurtains:draw()
        love.graphics.pop()
    love.graphics.pop()
    weeks:topDraw()
end

function week1:bottomDraw()
    weeks:bottomDraw()
end

function week1:exit()
    stageback:release()
    stagefront:release()
    stagecurtains:release()
    weeks:exit()
end

return week1