local composer = require( "composer" )
local physics = require( "physics" )
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
   
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        _W = display.contentWidth
        _H = display.contentHeight
        bg = display.newImage(sceneGroup, "back_4.png", _W/2, _H/2)
        bg.height = 340
        bg.width = 720    
        

        physics.start()

local testJump = false

local Circle = display.newImageRect("player.png",50,50)
Circle.x = 100
Circle.y = 150
Circle.ID = "Player"
physics.addBody(Circle,"dynamic", {friction=1.0, bounce=0.0})

local SensorRight = display.newImageRect("right_4.png",45,45)
SensorRight.x =0
SensorRight.y =290
SensorRight.isSensor = true
physics.addBody(SensorRight,"kinematic")

local SensorUp = display.newImageRect("up_4.png",45,45)
SensorUp.x =-38
SensorUp.y = 240
SensorUp.isSensor = true

physics.addBody(SensorUp,"kinematic")

local SensorLeft = display.newImageRect("left_4.png",45,45)
SensorLeft.x =-76
SensorLeft.y = 290
SensorLeft.isSensor = true
physics.addBody(SensorLeft,"kinematic")

local SpawnGround = display.newRect(100,180,120,25)
SpawnGround.ID = "Ground"
physics.addBody(SpawnGround,"static", {friction=1.0, bounce=0.0})
timer.performWithDelay(100, remove, 1)

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
    Runtime:addEventListener("collision", jump)

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
        Circle:setLinearVelocity(0,-250)
        display.remove(SpawnGround)
        testJump = false
    end
end
SensorRight:addEventListener("tap", moveRight)
SensorUp:addEventListener("tap", moveUp)
SensorLeft:addEventListener("tap", moveLeft)

local function spawn()
    local y = math.random(150,250)
    local obs = display.newRect(550,y-12,120,1)
    obs:setFillColor(0.1, 0.5, 0.1,0)
    local crash_obs = display.newImageRect("block.png", 120, 45)
    crash_obs.x = 550
    crash_obs.y = y+11
    
    obs.ID = "Ground"
    crash_obs.ID = "Crash"
    physics.addBody(obs, "kinematic", {friction=1.0, bounce=0.0})
    physics.addBody(crash_obs, "kinematic")
    obs:setLinearVelocity(-70,0)
    crash_obs:setLinearVelocity(-70,0)

local function crash(self,event)
    if(event.phase == "began") then
        if(event.other.ID == "Crash") then
            display.remove(SensorLeft)
            display.remove(SensorUp)
            display.remove(SensorRight)
            crash_obs:removeSelf()
            
            timer.cancel( spawner_timer)
            composer.removeScene( "lvl4", {effect = "fade", time = 800} )
            composer.gotoScene("gameOver4" ,{effect = "fade", time = 800} )
        end 
    end
end

Circle.collision = crash
Circle:addEventListener("collision",myCircle)

end
spawner_timer = timer.performWithDelay(math.random(2300,3300), spawn, 0)


 
    elseif ( phase == "did" ) then
      
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
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