local composer = require( "composer" )
local physics = require( "physics" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local bg, gg, Circle, SensorRight, SensorUp, SensorLeft
 local testJump = false
 local score
 local scoreText
-- -----------------------------------------------------------------------------------
local lvl4Sound = audio.loadSound("sound/lvl4.mp3")

local coinSound = audio.loadSound("sound/duckCoin.mp3")
local flintSound = audio.loadSound("sound/flint.mp3")


local function remove(self)
    SpawnGround:removeSelf()
end

local function jump(event) 
    if(event.phase == "began") then
        if(event.object1.ID == "Player" and event.object2.ID == "Ground") then
            testJump = true
        end
    end
end

local function moveRight()
    if (testJump) then 
        Circle:setLinearVelocity(100,-250)
        display.remove(SpawnGround)
        testJump = false
    end
end

local function moveLeft()
    if (testJump) then 
        Circle:setLinearVelocity(-100,-250)
        display.remove(SpawnGround)
        testJump = false
    end
end
local function moveUp()
    if (testJump) then 
        Circle:setLinearVelocity(0,-150)
        display.remove(SpawnGround)
        testJump = false
    end
end


local function spawn()
    local y = math.random(150,250)
    local obs = display.newRect(750,y-12,120,1)
    obs:setFillColor(0.1, 0.5, 0.1,0)
    local crash_obs = display.newImageRect("block.png", 120, 45)
    crash_obs.x = 750
    crash_obs.y = y+11
    
    obs.ID = "Ground"
    crash_obs.ID = "Crash"
    physics.addBody(obs, "kinematic", {friction=1.0, bounce=0.0})
    physics.addBody(crash_obs, "kinematic")
    obs:setLinearVelocity(-70,0)
    crash_obs:setLinearVelocity(-70,0)

end

local function crash(self,event)
    if(event.phase == "began") then
        if(event.other.ID == "Crash") then
            local flintS = audio.play(flintSound)
            display.remove(SensorLeft)
            display.remove(SensorUp)
            display.remove(SensorRight)
            if(crash_obs ~= nil) then
                display.remove(SpawnGround)
                display.remove(myCircle)
                display.remove(crash_obs)
            end
            timer.cancel( spawner_timer)
            
            composer.gotoScene("gameOver4" ,{effect = "fade", time = 800} )
        elseif(event.other.ID == "BlackCoin") then
            local coinS = audio.play(coinSound)
            score = score - 1
            scoreText.text = ": "..score
            if(score == 0) then
                display.remove(SensorLeft)
                display.remove(SensorUp)
                display.remove(SensorRight)
                timer.cancel( spawner_timer)
                display.remove(SpawnGround)
                display.remove(myCircle)
                display.remove(crash_obs)
                composer.gotoScene("lvl_5_transition" ,{effect = "fade", time = 2000} )
            end
        end
    end
end
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    local lvl4S = audio.play(lvl4Sound)
    score = 10
    -- Code here runs when the scene is first created but has not yet appeared on screen
    _W = display.contentWidth
    _H = display.contentHeight
    bg = display.newImage(sceneGroup, "back_4.png", _W/2, _H/2)
    bg.height = 340
    bg.width = 720

    scoreText = display.newText(sceneGroup, ": "..score, -60, 50, "RubikWetPaint-Regular.ttf", 25 )
    local scoreImg = display.newImageRect(sceneGroup, "coin.png",30, 30)
    scoreImg.x = -90
    scoreImg.y = 50



    

    local gg = display.newRect(0, 400, 1600, 20)
    gg.ID = "Crash"
    gg.isSensor = true
    physics.addBody(gg, "static")
    
    Circle = display.newImageRect("player.png",50,50)
    Circle.x = 100
    Circle.y = 150
    Circle.ID = "Player"
    physics.addBody(Circle,"dynamic", {friction=1.0, bounce=0.0})

    Circle.collision = crash
    Circle:addEventListener("collision",myCircle)
        
    SensorRight = display.newImageRect("right_4.png",45,45)
    SensorRight.x =0
    SensorRight.y =290
    SensorRight.isSensor = true
    physics.addBody(SensorRight,"kinematic")    

    SensorUp = display.newImageRect("up_4.png",45,45)
    SensorUp.x =-38
    SensorUp.y = 240
    SensorUp.isSensor = true
    physics.addBody(SensorUp,"kinematic")

    SensorLeft = display.newImageRect("left_4.png",45,45)
    SensorLeft.x =-76
    SensorLeft.y = 290
    SensorLeft.isSensor = true
    physics.addBody(SensorLeft,"kinematic")

    SpawnGround = display.newImageRect("block.png", 120, 45)
    SpawnGround.x = 100
    SpawnGround.y = 180
    SpawnGround.ID = "Ground"
    physics.addBody(SpawnGround,"static", {friction=1.0, bounce=0.0})

    Runtime:addEventListener("collision", jump)
    SensorRight:addEventListener("tap", moveRight)
    SensorUp:addEventListener("tap", moveUp)
    SensorLeft:addEventListener("tap", moveLeft)


    local function spawnBlackCoin()
            local coin = display.newImageRect("coin.png", 30, 30)
            coin.x = 700
            coin.y = math.random( 100, 150 )
            coin.ID = "BlackCoin"
            physics.addBody(coin,"dynamic")
            coin.isSensor = true
            coin.gravityScale = 0
            coin:setLinearVelocity(-100,0)

            local function deleteCoin(self, event)
                if (event.phase == "began" and event.other.ID == "Player") then
                    local collectSound = audio.play(blackCoinSound)
                    coin:removeSelf()
                end
            end
            coin.collision = deleteCoin
            coin:addEventListener("collision", coin)
        end
    blackCoinTimer = timer.performWithDelay(4000, spawnBlackCoin, 0)



end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then


    elseif ( phase == "did" ) then
        physics.start()
        composer.removeScene("levels")
        composer.removeScene("menu")     
        composer.removeScene("gameOver4")  
        spawner_timer = timer.performWithDelay(math.random(2300,3300), spawn, 0)
        
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        Runtime:removeEventListener("collision", jump)
        SensorRight:removeEventListener("tap", moveRight)
        SensorUp:removeEventListener("tap", moveUp)
        SensorLeft:removeEventListener("tap", moveLeft)
       Circle:removeEventListener("collision",myCircle)
        
        local bg, gg, Circle, SensorRight, SensorUp, SensorLeft = nil
        display.remove(bg)
        display.remove(gg)
        display.remove(Circle)
        display.remove(SensorRight)
        display.remove(SensorUp)
        display.remove(SensorLeft)

        timer.cancel(spawner_timer)
        timer.cancel(blackCoinTimer)
       
        audio.stop()
        
    elseif ( phase == "did" ) then
        composer.removeScene( "lvl4", {effect = "fade", time = 800} )
       
 
    end
end
 

 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene