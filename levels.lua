local composer = require("composer")
local scene = composer.newScene()
widget = require("widget")



local lvlsSound = audio.loadSound( "sound/lvls.mp3" )
local function push_menu()
        composer.gotoScene("menu", {effect = "fade", time = 400} ) 
end

local function push_1()
    composer.gotoScene("lvl1" ,{effect = "fade", time = 400} )
end

local function push_2()
   composer.gotoScene("lvl_2_transition" ,{effect = "fade", time = 800} )
end

local function push_3()
   composer.gotoScene("lvl_3_transition" ,{effect = "fade", time = 800} )
end

local function push_4()
   composer.gotoScene("lvl_4_transition" ,{effect = "fade", time = 800} )
end
-----------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )
        local sceneGroup = self.view
        physics = require("physics")
        physics.start()
        local lvlsS = audio.play(lvlsSound, {loops = -1})
        audio.setVolume( 0.25, lvlsS) -- Устанавливаем 
 
end

function scene:show( event )
        local sceneGroup = self.view

        bg = display.newImage(sceneGroup, "menu-bg.jpg", _W/2, _H/2)
        bg.height = 340
        bg.width = 720
        
        local title = display.newText(sceneGroup, "Levels", _W/2, 50, "PermanentMarker-Regular.ttf", 70)
        title:setFillColor(0.7,0.9,0.1,1)
        local menu_btn = widget.newButton(
        {
           shape = "roundedRect",
           radius = 10,
           width = 170,
           height = 60,
           x = _W/2, y = _H/2 + 110,
           fontSize = 30,
           fillColor = {default={130/255, 10/255, 90/255}, over={ 90/255, 10/255, 60/255}},
           labelColor = {default={250/255, 250/255, 250/255}, over={237/255, 238/255, 240/255}},
           label = "Меню",
           font = "BalsamiqSans-Bold.ttf",
           onPress = function(event)
                timer.performWithDelay(50, push_menu)
           end
           
        }
        )


        local first_lvl = widget.newButton(
        {
           shape = "roundedRect",
           radius = 10,
           width = 70,
           height = 70,
           x = _W/2 - 100, y = _H/2 - 10,
           fontSize = 40,
           fillColor = {default={120/255, 10/255, 210/255}, over={ 90/255, 10/255, 60/255}},
           labelColor = {default={250/255, 250/255, 250/255}, over={237/255, 238/255, 240/255}},
           label = "1",
           font = "BalsamiqSans-Bold.ttf",
           onPress = function(event)
                timer.performWithDelay(0, push_1)
           end
           
        }
        )
        
        local second_lvl = widget.newButton(
        {
           shape = "roundedRect",
           radius = 10,
           width = 70,
           height = 70,
           x = _W/2, y = _H/2 - 10,
           fontSize = 40,
           fillColor = {default={120/255, 10/255, 210/255}, over={ 90/255, 10/255, 60/255}},
           labelColor = {default={250/255, 250/255, 250/255}, over={237/255, 238/255, 240/255}},
           label = "2",
           font = "BalsamiqSans-Bold.ttf",
           onPress = function(event)
                timer.performWithDelay(100, push_2)
           end
           
        }
        )

        local third_lvl = widget.newButton(
        {
           shape = "roundedRect",
           radius = 10,
           width = 70,
           height = 70,
           x = _W/2 + 100, y = _H/2 - 10,
           fontSize = 40,
           fillColor = {default={255/255, 105/255, 0/255}, over={237/255, 238/255, 240/255}},
           labelColor = {default={245/255, 235/255, 0/255}, over={237/255, 238/255, 240/255}},
           label = "3",
           font = "BalsamiqSans-Bold.ttf",
           onPress = function(event)
                timer.performWithDelay(100, push_3)
           end
           
        }
        )

        local fourth_lvl = widget.newButton(
        {
           shape = "roundedRect",
           radius = 10,
           width = 70,
           height = 70,
           x = _W/2 + 200, y = _H/2 - 10,
           fontSize = 40,
           fillColor = {default={120/255, 10/255, 210/255}, over={ 90/255, 10/255, 60/255}},
           labelColor = {default={250/255, 250/255, 250/255}, over={237/255, 238/255, 240/255}},
           label = "4",
           font = "BalsamiqSans-Bold.ttf",
           onPress = function(event)
                timer.performWithDelay(0, push_4)
           end
           
        }
        )




        

        sceneGroup:insert(menu_btn)
        sceneGroup:insert(first_lvl)
        sceneGroup:insert(second_lvl)
        sceneGroup:insert(third_lvl)
        sceneGroup:insert(fourth_lvl)

      
end


function scene:hide( event )
        local phase = event.phase
        if( phase == "will" ) then
            audio.stop()
        end
        if( phase == "did" ) then
            
               composer.removeScene( "levels" )
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