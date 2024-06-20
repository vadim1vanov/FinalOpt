local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")


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
    local phase = event.phase
    physics.pause()


    bg = display.newImage(sceneGroup, "lvl2_bg.png", _W/2, _H/2)
    bg.height = 340
    bg.width = 720
    
    local upperLine = display.newRect(_W/2, _H/2-170, 900, 5)
    upperLine.ID = "upperLine"
    physics.addBody(upperLine, "static")


    local underLine = display.newRect(_W/2, _H/2+170, 900, 5)
    underLine.ID = "underLine"
    physics.addBody(underLine, "static")
    

    local rec1 = display.newRect(_W/2-20, _H/2-80, 40, 150)
    physics.addBody(rec1, "static")

    local rec2 = display.newRect(_W/2+140, _H/2+80, 40, 150)
    physics.addBody(rec2, "static")


    local gun = display.newRect(_W/2-350, _H/2, 19,150 )
    gun:setFillColor(0.3, 0.8, 0, 1)
    gun:rotate(90)
  
    local holdStartTime
    local powerLine -- Линия, показывающая силу выстрела
-- Создаем красную линию и добавляем её на экран
    
       
    function RotateOb(event)
        if event.phase == "began" then
            holdStartTime = system.getTimer() -- Запоминаем время начала нажатия
            gun.rotation = math.ceil(math.atan2((event.y - gun.y), (event.x - gun.x)) * 180 / math.pi) + 90
    
           powerLine = display.newLine(_W/2+200, _H/2-100, _W/2+210, _H/2-100)
            powerLine:setStrokeColor(1, 0, 0) -- Красный цвет линии
            powerLine.strokeWidth = 20
    
        elseif event.phase == "moved" then
            gun.rotation = math.ceil(math.atan2((event.y - gun.y), (event.x - gun.x)) * 180 / math.pi) + 90
    
            -- Обновляем положение конца линии в зависимости от текущей позиции мыши
            local holdCurrentTime = system.getTimer()
            local holdDuration = (holdCurrentTime - holdStartTime) / 1000
            local speedMultiplier = math.min(holdDuration, 1) -- Максимум 1
            local lineLength = 100 * speedMultiplier
    
            local angleRad = math.rad(gun.rotation - 90)
            local endX = _W/2+200 + lineLength 
            local endY = _H/2-100 
    
            
            powerLine = display.newLine(_W/2+200, _H/2-100, endX, endY)
            powerLine:setStrokeColor(1, 0, 0) -- Красный цвет линии
            powerLine.strokeWidth = 20
            
    
        elseif event.phase == "ended" or event.phase == "cancelled" then
            local holdEndTime = system.getTimer() -- Определяем время окончания нажатия
            local holdDuration = (holdEndTime - holdStartTime) / 1000 -- Продолжительность нажатия в секундах
    
            local speedMultiplier = math.min(holdDuration, 1) -- Устанавливаем множитель скорости (максимум 1)
            local impulseStrength = 0.08 * speedMultiplier -- Расчёт импульса на основе продолжительности нажатия
    
            local actualX, actualY = gun:localToContent(0, -80)
            local bullet = display.newCircle(actualX, actualY, 6)
            physics.addBody(bullet, "dynamic", {isSensor = false})
            bullet.ID = "bullet"
            bullet:setFillColor(0.7, 0.7, 1, 1)
            
            local angle = -math.rad(gun.rotation + 90)
            local xComp = math.cos(angle)
            local yComp = -math.sin(angle)
            
            bullet:applyLinearImpulse(-impulseStrength * xComp, -impulseStrength * yComp, gun.x, gun.y)
            local function crash(self, event)
                if(event.phase == "began" and event.other.ID == "upperLine") then
                   
                    bullet:removeSelf()
                end
            end
           
    
            
            bullet.collision = crash
            bullet:addEventListener("touch", bullet)
        end
    end

    bg:addEventListener("touch", RotateOb)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    physics.start()

    
    if ( phase == "will" ) then
    
        
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
