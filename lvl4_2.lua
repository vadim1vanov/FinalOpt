local composer = require( "composer" )
local physics = require( "physics" )
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local back = display.newRect(0,100,1000, 1000)
back:setFillColor(0.1, 0.2, 0.2, 1)

local function moveMap()
    targetY = 320/2 - cir.y
    targetX = 480/2 - cir.x
    transition.moveTo(group, {x = targetX, y = targetY, time = 500})
end

local function moveOb(event)
    local eventx = event.x
    local eventy = event.y
    transition.moveTo(cir,{x = eventx, y = eventy, time = 300, onComplete = moveMap} )
    

    --transition.cancel() -- прерывание
end

 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    cir = display.newCircle(160, 520, 20)
    cir:setFillColor(0, 0, 1, 1)
    physics.addBody(cir, "dynamic")
    cir.isSensor = true
    cir.gravityScale = 0

    local group = display.newGroup()
    group:insert(back)
    group:insert(cir)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        back:addEventListener("tap", moveOb)
        -- Code here runs when the scene is entirely on screen
 
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