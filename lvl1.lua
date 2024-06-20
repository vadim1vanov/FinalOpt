local composer = require("composer")
local scene = composer.newScene()

local life = 3
local timer_bomb
local timer_coin
local timer_fastBomb
local timer_bad
local score = 0
local score_title
local dron
local bomb
local fastBomb

local lvl1Sound = audio.loadSound("sound/lvl1.mp3")
local bombSound = audio.loadSound("sound/bomb.mp3")
local fastBombSound = audio.loadSound("sound/fastBomb.mp3")
local coinSound = audio.loadSound("sound/coin.mp3")
local badCoinSound = audio.loadSound("sound/badCoin.mp3")


local function next_lvl( event )
        composer.gotoScene("lvl_2_transition", {effect = "fade", time = 800} ) 
end

local function removeAll()
    composer.removeScene('lvl1')
end

local function spawnBomb ()
    bomb = display.newImageRect("bomb.png", 80, 50)
    bomb.x = 800
    bomb.y = math.random(0, 350)
    bomb.xScale = -1

   
    physics.addBody(bomb, "dynamic")
    bomb.gravityScale = 0
    bomb.ID = "crash"
    bomb.isSensor = true
    bomb.myName = "bomb"
    bomb:applyLinearImpulse(-0.9, 0, bomb.x, bomb.y)
    local bombS = audio.play(bombSound)
    
end

local function spawnFastBomb ()
    fastBomb = display.newImageRect("bomb.png", 70, 40)
    fastBomb:setFillColor(1, 0, 0, 0.8)
    fastBomb.x = 800
    fastBomb.y = math.random(0, 350)
    fastBomb.xScale = -1
    physics.addBody(fastBomb, "dynamic")
    fastBomb.gravityScale = 0
    fastBomb.ID = "crash2"
    fastBomb.isSensor = true
    fastBomb.myName = "bomb2"
    fastBomb:applyLinearImpulse(-1.4, 0, fastBomb.x, fastBomb.y)
    local fastBombS = audio.play(fastBombSound)
end


local function spawnCoin ()
    local coin = display.newImageRect("coin.png", 30, 30)
    
    coin.x = 800
    coin.y = math.random(0, 350)
   

   
    physics.addBody(coin, "dynamic")
    coin.gravityScale = 0
    coin.ID = "target"
    coin.isSensor = true
    coin.myName = "coin"
    coin:applyLinearImpulse(-0.15, 0, coin.x, coin.y)

end

local function spawnBad ()
    local bad = display.newImageRect("bad.png", 30, 30)
    
    bad.x = 800
    bad.y = math.random(0, 350)
   
    physics.addBody(bad, "dynamic")
    bad.gravityScale = 0
    bad.ID = "badIs"
    bad.isSensor = true
    bad.myName = "bad"
    bad:applyLinearImpulse(-0.15, 0, bad.x, bad.y)

end

local function removeAllObj()
    

    
    display.remove(fastBomb)
    display.remove(bomb)
    display.remove(dron)
    timer.cancel(timer_fastBomb)
    timer.cancel(timer_bomb)
    timer.cancel(timer_coin)
    timer.cancel(timer_bad)
    
    local life = nil
    local timer_bomb = nil
    local timer_coin = nil
    local timer_fastBomb = nil
    local timer_bad = nil
    local score = nil
    local score_title = nil
    local dron = nil
    local bomb = nil
    local fastBomb = nil

end

local function crash(event)
    if(event.phase == "began") then
        local obj1 = event.object1
        local obj2 = event.object2
        if((obj1.myName =="bomb" and obj2.myName == "dron") or
            (obj2.myName =="bomb" and obj1.myName == "dron") or
            (obj2.myName =="bomb2" and obj1.myName == "dron") or
            (obj1.myName =="bomb2" and obj2.myName == "dron")) then
                life = life - 1
                display.remove(obj2)
                if(life == 0) then
                    removeAllObj()
                    
                    composer.removeScene( "lvl1", {effect = "fade", time = 800} )
                    composer.gotoScene("gameOver" ,{effect = "fade", time = 800} )
                    
                    
                end
        end
        if((obj1.myName =="coin" and obj2.myName == "dron") or
            (obj2.myName =="coin" and obj1.myName == "dron")) then
                local coinS = audio.play(coinSound)
                
                display.remove(obj2)
                score = score + 1
                score_title.text = ": ".. score 
                if(score == 10) then
                    score = 0
                    timer.cancel(timer_coin)
                    timer.cancel(timer_bomb)
                    timer.cancel(timer_bad)
                    
                    next_lvl()
                    
                   
                end
        end
        if((obj1.myName =="bad" and obj2.myName == "dron") or
            (obj2.myName =="bad" and obj1.myName == "dron")) then
                local badCoinS = audio.play(badCoinSound)
                   
                display.remove(obj2)
               
                timer_fastBomb = timer.performWithDelay(1000, spawnFastBomb, 1 )
                
        end
    end 
end



local function dragPlane(event)
    local dron = event.target
    local phase = event.phase

    if("began" == phase) then
        display.currentStage:setFocus(dron)
        dron.touchOffsetX = event.x - dron.x
        dron.touchOffsetY = event.y - dron.y

     
    elseif("moved" == phase) then
        if (dron.touchOffsetX ~= nil) then
            dron.x = event.x - dron.touchOffsetX
            dron.y = event.y - dron.touchOffsetY
        end
    elseif("ended" or "cancelled" == phase) then
        display.currentStage:setFocus(nil)
    end
end


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )
        local sceneGroup = self.view
        widget = require("widget")
        physics = require("physics")
        physics.pause()


        local lvl1S = audio.play(lvl1Sound, {loops = -1})
        local lvl1SVolume = audio.setVolume(1, lvl1S)
        life = 3
        score = 0

        bg = display.newImage(sceneGroup, "night-town.jpg", _W/2, _H/2)
        bg.height = 340
        bg.width = 720

        bg5 = display.newImage(sceneGroup, "night-town.png", _W/2, _H/2)
        bg5.height = 340
        bg5.width = 750
        bg5.x = 959
        bg5.y = 190
        bg5.speed = 2

        bg6 = display.newImage(sceneGroup, "night-town.png", _W/2, _H/2)
        bg6.height = 340
        bg6.width = 750
        bg6.x = 1
        bg6.y = 190
        bg6.speed = 2
        bg1 = display.newImage(sceneGroup, "night-town.png", _W/2, _H/2)
        bg1.height = 340
        bg1.width = 750
        bg1.x = 1
        bg1.y = 170
        bg1.speed = 3

        bg2 = display.newImage(sceneGroup, "night-town.png", _W/2, _H/2)
        bg2.height = 340
        bg2.width = 750
        bg2.x = 959
        bg2.y = 170
        bg2.speed = 3

        bg3 = display.newImage(sceneGroup, "night-town.png", _W/2, _H/2)
        bg3.height = 340
        bg3.width = 750
        bg3.x = 1
        bg3.y = 190
        bg3.speed = 4

        bg4 = display.newImage(sceneGroup, "night-town.png", _W/2, _H/2)
        bg4.height = 340
        bg4.width = 750
        bg4.x = 959
        bg4.y = 190
        bg4.speed = 4

        local lifeImg = display.newImageRect(sceneGroup, "life.png",50, 30)
        lifeImg.x = -50
        lifeImg.y = 40
        lifeImg.ID = "img1"
        local lifeImg2 = display.newImageRect(sceneGroup, "life.png",50, 30)
        lifeImg2.x = -20
        lifeImg2.y = 40
        lifeImg2.ID = "img2"
        local lifeImg3 = display.newImageRect(sceneGroup, "life.png",50, 30)
        lifeImg3.x = 10
        lifeImg3.y = 40
        lifeImg3.ID = "img3"

        local coinImg = display.newImageRect(sceneGroup, "coin.png", 27, 27)
        coinImg.x = 100
        coinImg.y = 40
        score_title = display.newText(sceneGroup, ": ".. score ,143, 39, "PermanentMarker-Regular.ttf", 30)
       
        local targetImg = display.newImageRect(sceneGroup, "coin.png", 27, 27)
        targetImg.x = 540
        targetImg.y = 43

        local target = display.newText(sceneGroup, "Цель: " ,433, 39, "BalsamiqSans-Bold.ttf", 35)
        local target_x = display.newText(sceneGroup, "10" ,506, 43, "PermanentMarker-Regular.ttf", 29)
        target_x:setFillColor(1, 1, 0, 1)
        dron = display.newImage(sceneGroup,"duckPlane.png", _W/2 - 190, _H/2)
        dron.height = 100
        dron.width = 150
        dron.ID = "player"
        physics.addBody(dron, "static")
        dron.isSensor = true
        dron.myName = "dron"

   
        

        dron:addEventListener("touch", dragPlane)
        dron.collision = crash
        dron:addEventListener("collision", dron)
        

        

        local function checkLife(self, event)
            if(score == 10) then
                removeAllObj()
            end
            if(life == 2) then
                display.remove(lifeImg3)
            elseif(life == 1) then
                display.remove(lifeImg2)
            elseif(life == 0) then
                display.remove(lifeImg)
                display.remove(coinImg)
            end
        end

      

        function scrollCity(self, event)
            if(self.x < -800) then
                self.x = 960
            else self.x = self.x - self.speed
            end
        end

        bg1.enterFrame = scrollCity
        Runtime:addEventListener("enterFrame", bg1)

        bg2.enterFrame = scrollCity
        Runtime:addEventListener("enterFrame", bg2)

        bg3.enterFrame = scrollCity
        Runtime:addEventListener("enterFrame", bg3)

        bg4.enterFrame = scrollCity
        Runtime:addEventListener("enterFrame", bg4)

        bg5.enterFrame = scrollCity
        Runtime:addEventListener("enterFrame", bg5)

        bg6.enterFrame = scrollCity
        Runtime:addEventListener("enterFrame", bg6)

        lifeImg3.enterFrame = checkLife
        Runtime:addEventListener("enterFrame", lifeImg3)
end

function scene:show( event )
        local sceneGroup = self.view
        local phase = event.phase

        if( phase == "will" ) then

        
        elseif( phase == "did" ) then
    
            physics.start()

            Runtime:addEventListener("collision", crash)
            composer.removeScene("levels")
            composer.removeScene("menu")     
            composer.removeScene("gameOver")    
            
            timer_bomb = timer.performWithDelay(1500, spawnBomb, 0)
            timer_coin = timer.performWithDelay(3500, spawnCoin, 0)
            timer_bad = timer.performWithDelay(12000, spawnBad, 0)
            timer_fastBomb = timer.performWithDelay(1000000, spawnFastBomb, 1)
        end

        
end


function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
        if( phase == "will" ) then  
            
            dron:removeEventListener("touch", dragPlane)
            dron:removeEventListener("collision", dron)
            Runtime:removeEventListener("collision", crash)
            Runtime:removeEventListener("enterFrame", bg1)
            Runtime:removeEventListener("enterFrame", bg2)
            Runtime:removeEventListener("enterFrame", bg3)
            Runtime:removeEventListener("enterFrame", bg4)
            Runtime:removeEventListener("enterFrame", bg5)
            Runtime:removeEventListener("enterFrame", bg6)
            Runtime:removeEventListener("enterFrame", lifeImg3)

            removeAllObj()
            audio.stop()
       
        elseif( phase == "did" ) then
                physics.pause()
               composer.removeScene( "lvl1", {effect = "fade", time = 800}  )
               
        end
end


  ---------------------------------------------------------------------------------
  -- END OF YOUR IMPLEMENTATION
  ---------------------------------------------------------------------------------

 -- "createScene" event is dispatched if scene's view does not exist
  scene:addEventListener( "create", scene )

  scene:addEventListener( "show", scenes )

  scene:addEventListener("hide", scene)
  ---------------------------------------------------------------------------------

  return scene