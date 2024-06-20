local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local coin1
local coin2
local bomb
local bullet

local score1
local score2

local lvl2Sound = audio.loadSound("sound/lvl2.mp3")
local bulletSound = audio.loadSound("sound/bullet.mp3")
local flintSound = audio.loadSound("sound/flint.mp3")
local coinSound = audio.loadSound("sound/duckCoin.mp3")


local function spawnBomb()

    bomb = display.newImageRect("flint.png", 50,70)
    bomb.x = math.random(100, 600)
    bomb.y = -200
    physics.addBody(bomb, "dynamic")
    bomb.gravityScale = 0.7
    bomb.isSensor = true
    bomb.ID = "crush"

end

local function spawnMoney1()

    coin1 = display.newImageRect("duckCoin1.png", 45,45)
    coin1.x = math.random(150, 650)
    coin1.y = -200
    physics.addBody(coin1, "dynamic")
    coin1.gravityScale = 0.3
    coin1.isSensor = true
    coin1.ID = "coin1"

end

local function spawnMoney2()

    coin2 = display.newImageRect("duckCoin2.png", 45,45)
    coin2:setFillColor(0.1, 0.4, 0.1)
    coin2.x = math.random(200, 600)
    coin2.y = -200
    physics.addBody(coin2, "dynamic")
    coin2.gravityScale = 0.3
    coin2.isSensor = true
    coin2.ID = "coin2"
end

local function removeAll()
    display.remove(coin1)
    display.remove(coin2)
    display.remove(bomb)
    timer.cancel(timer_spawnBomb)
    timer.cancel(timer_spawnMoney1)
    timer.cancel(timer_spawnMoney2)
    local coin1 = nil
    local coin2 = nil
    local bomb = nil
   
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )

    local sceneGroup = self.view
    local phase = event.phase
    physics.pause()

   
    life = 5
    
    
    local lvl2S = audio.play(lvl2Sound)
    
    bg = display.newImage(sceneGroup, "lvl2_bg.png", _W/2, _H/2)
    bg.height = 340
    bg.width = 720

    score1 = 10
    score2 = 10
    
    local scoreText1 = display.newText(sceneGroup, ": "..score1, -60, 260, "RubikWetPaint-Regular.ttf", 25 )
    local score1Img = display.newImageRect(sceneGroup, "duckCoin1.png",30, 30)
    score1Img.x = -90
    score1Img.y = 260

    

    local scoreText2 = display.newText(sceneGroup, ": "..score1, -60, 300, "RubikWetPaint-Regular.ttf", 25 )
    local score2Img = display.newImageRect(sceneGroup, "duckCoin2.png",30, 30)
    score2Img.x = -90
    score2Img.y = 300
    score2Img:setFillColor(0.1, 0.4, 0.1)
   

     local lifeImg = display.newImageRect(sceneGroup, "lifeDuck.png",30, 30)
    lifeImg.x = -90
    lifeImg.y = 40
    lifeImg.ID = "img1"
    lifeImg:setFillColor(0.1, 1, 0.1, 1)
    local lifeImg2 = display.newImageRect(sceneGroup, "lifeDuck.png",30, 30)
    lifeImg2.x = -60
    lifeImg2.y = 40
    lifeImg2.ID = "img2"
    lifeImg2:setFillColor(0.1, 1, 0.1, 1)
    local lifeImg3 = display.newImageRect(sceneGroup, "lifeDuck.png",30, 30)
    lifeImg3.x = -30
    lifeImg3.y = 40
    lifeImg3.ID = "img3"
    lifeImg3:setFillColor(0.1, 1, 0.1, 1)
    local lifeImg4 = display.newImageRect(sceneGroup, "lifeDuck.png",30, 30)
    lifeImg4.x = -90
    lifeImg4.y = 75
    lifeImg4.ID = "img3"
    lifeImg4:setFillColor(0.1, 1, 0.1, 1)  
    local lifeImg5 = display.newImageRect(sceneGroup, "lifeDuck.png",30, 30)
    lifeImg5.x = -60
    lifeImg5.y = 75
    lifeImg5.ID = "img3"
    lifeImg5:setFillColor(0.1, 1, 0.1, 1)    
    local gun = display.newImage(sceneGroup,"pngwing.com.png", _W/2 - 270, _H/2)
    gun.height = 120
    gun.width = 100
    local function RotateOb(event) 
        

        if(event.phase == "began") then
            
            gun.rotation = math.ceil( math.atan2((event.y - gun.y), (event.x - gun.x)) * 180 / math.pi) - 29
        end
        if(event.phase == "moved") then
            
            gun.rotation = math.ceil( math.atan2((event.y - gun.y), (event.x - gun.x)) * 180 / math.pi) - 29
        end
        if(event.phase == "ended" or event.phase == "cancelled") then
            
            local actualX, actualY = gun:localToContent(40, 40)

            bullet= display.newImageRect("dollar.png",20,20)
            bullet.x = actualX
            bullet.y = actualY
            physics.addBody(bullet, "dynamic", {isSensor = true})
            bullet.ID = "bullet"
            bullet:setFillColor(0.7, 0.7, 1, 1)
            bullet.gravityScale = 0
            local angle = - math.rad(gun.rotation -155)
            local xComp = math.cos(angle)
            local yComp = - math.sin(angle)
            local bulletS = audio.play(bulletSound)
            
            bullet:applyLinearImpulse(-0.2*xComp, -0.2*yComp, gun.x, gun.y )
            
            local function crash(self, event)
                if(event.phase == "began" and event.other.ID == "crush") then
                    life = life - 1
                    if bullet then
                        local flintS = audio.play(flintSound)
                        bullet:removeSelf()
                        event.other:removeSelf()
                    end
                    if(life == 0 or bulletCount == 0) then
                        composer.removeScene( "lvl2", {effect = "fade", time = 800} )
                        composer.gotoScene("gameOver2" ,{effect = "fade", time = 800} )
                    end
                elseif(event.phase == "began" and event.other.ID == "coin1") then
                    local coinS = audio.play(coinSound)
                    if(score1 == 0) then
                        score1 = 0
                        if bullet then
                            bullet:removeSelf()
                            event.other:removeSelf()
                        end
                    else
                        score1 = score1 - 1
                        scoreText1.text = ": "..score1
                        if bullet then
                            bullet:removeSelf()
                            event.other:removeSelf()
                        end
                    end
                elseif(event.phase == "began" and event.other.ID == "coin2") then
                    local coinS = audio.play(coinSound)
                    if(score2 == 0) then
                        score2 = 0
                        if bullet then
                            bullet:removeSelf()
                            event.other:removeSelf()
                        end
                    else
                        score2 = score2 - 1
                        scoreText2.text = ": "..score2
                        if bullet then
                            bullet:removeSelf()
                            event.other:removeSelf()
                        end
                    end
                end
                if(score1 == 0 and score2 == 0) then
                    removeAll()
                    composer.removeScene( "lvl2", {effect = "fade", time = 800} )
                    composer.gotoScene("lvl_3_transition" ,{effect = "fade", time = 800} )
                end
            end
            
            bullet.collision = crash
            bullet:addEventListener("collision", bullet)
        end 

        
        

    end
    
    bg:addEventListener("touch", RotateOb)

    
    

    
    local function checkLife(self, event)    
        if(life == 4) then
            display.remove(lifeImg5)
        elseif(life == 3) then
            display.remove(lifeImg4)
        elseif(life == 2) then
            display.remove(lifeImg3)
        elseif(life == 1) then
            display.remove(lifeImg2)
        elseif(life == 0) then
            display.remove(lifeImg)
            removeAll()
            
        end
    end

    lifeImg5.enterFrame = checkLife
    Runtime:addEventListener("enterFrame", lifeImg5)
    
    timer_spawnBomb = timer.performWithDelay(1000, spawnBomb, 0)
    timer_spawnMoney1 = timer.performWithDelay(2000, spawnMoney1, 0)
    timer_spawnMoney2 = timer.performWithDelay(1700, spawnMoney2, 0)
end
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    physics.start()

    
    if ( phase == "will" ) then
    
        composer.removeScene("levels")
        composer.removeScene("menu")     
        composer.removeScene("gameOver2")  
    elseif ( phase == "did" ) then
        
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        
        Runtime:removeEventListener("enterFrame", lifeImg5)
        bullet:removeEventListener("collision", bullet)

        audio.stop()
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        physics.pause()
        composer.removeScene( "lvl2", {effect = "fade", time = 800}  )
    end
end
 
 

 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
----------------------------------------
 
return scene
