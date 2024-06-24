local composer = require("composer")
local scene = composer.newScene()


local gameOverSound = audio.loadSound("sound/gameOver.mp3")

local function push_menu( event )
        composer.gotoScene("menu", {effect = "fade", time = 500} ) 
end

local function push_again( event )
        composer.gotoScene("lvl_4_transition", {effect = "fade", time = 800} ) 
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


        local gOver = audio.play(gameOverSound, {loops = -1})
        local gOverVolume = audio.getVolume(0.25, gOver)

        _W = display.contentWidth
        _H = display.contentHeight
        bg = display.newImage(sceneGroup, "gameOver.png", _W/2, _H/2)
        bg.height = 340
        bg.width = 720

        local gameOver = display.newText("GAME OVER", _W/2, _H/2-80, "BalsamiqSans-Bold.ttf", 70)
        gameOver:setFillColor(1, 0.6,0.6,1) 

        local menu_btn = widget.newButton(
        {
           shape = "roundedRect",
           radius = 10,
           width = 170,
           height = 60,
           x = _W/2 - 100, y = _H/2 + 50,
           fontSize = 40,
           fillColor = {default={100/255, 0/255, 240/255}, over={ 90/255, 10/255, 60/255}},
           labelColor = {default={250/255, 250/255, 250/255}, over={237/255, 238/255, 240/255}},
           label = "Меню",
           font = "BalsamiqSans-Bold.ttf",
           onPress = function(event)
                timer.performWithDelay(100, push_menu)
           end
           
        }

    )
        local again = widget.newButton(
                {
                   shape = "roundedRect",
                   radius = 10,
                   width = 170,
                   height = 60,
                   x = _W/2 + 100, y = _H/2 + 50,
                   fontSize = 35,
                   fillColor = {default={200/255, 60/255, 40/255}, over={ 90/255, 10/255, 60/255}},
                   labelColor = {default={250/255, 250/255, 250/255}, over={237/255, 238/255, 240/255}},
                   label = "Eщё раз",
                   font = "BalsamiqSans-Bold.ttf",
                   onPress = function(event)
                        timer.performWithDelay(100, push_again)
                   end
                   
                }
        )
    sceneGroup:insert(menu_btn)
    sceneGroup:insert(gameOver)
    sceneGroup:insert(again)
        
end

function scene:show( event )
        local phase = event.phase
        if( phase == "will" ) then
        end
        if( phase == "did" ) then 
                composer.removeScene("menu", {effect = "fade", time = 800} )
                composer.removeScene("levels", {effect = "fade", time = 800} )
                composer.removeScene("lvl4", {effect = "fade", time = 800} )
        end

end


function scene:hide( event )
        local phase = event.phase
        if( phase == "will" ) then
                audio.stop()
        end
        if( phase == "did" ) then
               composer.removeScene( "gameOver", {effect = "fade", time = 800}  )
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