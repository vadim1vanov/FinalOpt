local composer = require( "composer" )
local physics = require ("physics")
local scene = composer.newScene()

local block
local blockStart
testJump = true
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
local function spawnBlocks ()
    block = display.newImageRect("block.png", 140, 50)
    block.x = 800
    block.y = math.random(150, 300)
   

   
    physics.addBody(block, "dynamic")
    block.gravityScale = 0
    block.ID = "crash"
    block.isSensor = false
    block.myName = "block"
    block:applyLinearImpulse(-0.2, 0, block.x, block.y)
      
end


  

 

local function crush(event)
    local obj1 = event.object1
    local obj2 = event.object2
    if(event.phase == "began") then
        if(obj1.myName == "block" and obj2.myName == "blockStart") or
            (obj2.myName == "block" and obj1.myName == "blockStart") then
            display.remove(obj1)
            display.remove(obj2)
        end
    end
end




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    local myRec = display.newRect(-10, 170, 60, 60)
    myRec:setFillColor(0,0.5, 1, 1)
   
    physics.addBody( myRec, "static")
    myRec.isSensor =true
    
   -- local function upper(event) 
     --   if(event.phase == "began") then
      --     if(event.object1.myName == "player" and event.object2.myName == "Ground") or
     --         (event.object1.myName == "player" and event.object2.myName == "block") then
     --           testJump = true
     --       end
   --     end
    --end 
    
 --  Runtime:addEventListener("collision", upper)
    
    local function jump()
        if(testJump) then
            player:setLinearVelocity(50, -300)
            
        end
    end
    myRec:addEventListener("tap", jump)    


    blockStart = display.newImageRect("block.png", 340, 50)
    blockStart.x = 0
    blockStart.y = 250
   

   
    physics.addBody(blockStart, "static")
    blockStart.gravityScale = 0
    
    blockStart.isSensor = false
    blockStart.myName = "blockStart"
    blockStart:applyLinearImpulse(-0.34, 0, blockStart.x, blockStart.y)

    blockStart.collision = crush
    blockStart:addEventListener("collision", blockStart)


    player = display.newImageRect("player.png", 60, 70)
    player.x = 100
    player.y = 180

    physics.addBody(player, "static")
    player.ID = "player"
    player.isSensor = false

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
        

        



    elseif ( phase == "did" ) then
        Runtime:addEventListener("collision", crush)

        timer_block = timer.performWithDelay(2600, spawnBlocks, 0)
        timer_block = timer.performWithDelay(0, startBlock, 1)
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
 

 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

-- -----------------------------------------------------------------------------------
 
return scene