local composer = require("composer")
local scene = composer.newScene()

local play_btn, lvl_btn, physics, widget, bg
local menu
local textChange

local menuSound = audio.loadSound( "sound/menu.mp3" )

local function push_lvl( event )
        composer.gotoScene("levels", {effect = "fade", time = 400} ) 
end

local function push_play( event )
        composer.gotoScene("lvl_1_transition", {effect = "fade", time = 800} ) 
end
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )
        local sceneGroup = self.view
        widget = require("widget")
        physics = require("physics")
        physics.start()
        
        
        local mSound = audio.play(menuSound, {loops = -1})
        audio.setVolume( 0.25, mSound) -- Устанавливаем 
        

        _W = display.contentWidth
        _H = display.contentHeight
        bg = display.newImage(sceneGroup, "menu-bg.jpg", _W/2, _H/2)
        bg.height = 340
        bg.width = 720


        local title = display.newText(sceneGroup, "Greatest ducks", _W/2, 50, "PermanentMarker-Regular.ttf", 70)
        
        local colors = {
                {1, 0, 0}, -- Красный
                {0, 1, 0}, -- Зеленый
                {0, 0, 1}, -- Синий
                {1, 1, 0}, -- Желтый
                {1, 0, 1}  -- Фиолетовый
            }
            
            
            local currentColorIndex = 1
            
          
            local function changeTextColor()
                title:setFillColor(unpack(colors[currentColorIndex]))
                currentColorIndex = currentColorIndex + 1
                if currentColorIndex > #colors then
                    currentColorIndex = 1
                end
            end
            
            textChange = timer.performWithDelay(250, changeTextColor, 0)

        local duck = display.newImage(sceneGroup, "duck.png", _W/2 + 200, 220)
        duck.height = 220
        duck.width = 270
        local lvl_btn = widget.newButton(
        {
        shape = "roundedRect",
        radius = 10,
        width = 150,
        height = 50,
        x = _W/2, y = _H/2 + 90,
        fontSize = 25,
        fillColor = {default={190/255, 10/255, 80/255}, over={ 150/255, 0/255, 60/255}},
        labelColor = {default={250/255, 250/255, 250/255}, over={237/255, 238/255, 240/255}},
        label = "Уровни",
        font ="BalsamiqSans-Bold.ttf",
        onPress = function(event)
                timer.performWithDelay(100, push_lvl)
           end
                }
        )

        local play_btn = widget.newButton(
        {
           shape = "roundedRect",
           radius = 10,
           width = 190,
           height = 70,
           x = _W/2, y = _H/2,
           fontSize = 40,
           fillColor = {default={120/255, 0/255, 200/255}, over={ 90/255, 10/255, 60/255}},
           labelColor = {default={250/255, 250/255, 250/255}, over={237/255, 238/255, 240/255}},
           label = "Играть",
           font = "BalsamiqSans-Bold.ttf",
           onPress = function(event)
                timer.performWithDelay(0, push_play)
           end
           
        }
    )

        

        sceneGroup:insert(lvl_btn)
        sceneGroup:insert(play_btn)
end

function scene:show( event )
        local phase = event.phase
        if( phase == "will" ) then
        end
        if( phase == "did" ) then
                composer.removeScene("levels")
                composer.removeScene("lvl1")
                composer.removeScene("gameOver")
                
                composer.removeScene("lvl3")
               
        end

end


function scene:hide( event )
        local phase = event.phase
        if( phase == "will" ) then
                audio.stop()
        end
        if( phase == "did" ) then
               composer.removeScene( "menu" )
               timer.cancel(textChange)
               
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