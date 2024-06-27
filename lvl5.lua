local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()


local circle
local bomb
local bg
local coin
local life
local score
local spawnCoin_timer
local spawnBomb_timer

local lvl5Sound = audio.loadSound("sound/lvl5.mp3")
local bombSound = audio.loadSound("sound/bomb.mp3")
local coinSound = audio.loadSound("sound/duckCoin.mp3")
local flintSound = audio.loadSound("sound/flint.mp3")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local function movePers(event)
    local eventx = event.x
    local eventy = event.y
    transition.moveTo(circle, { x = eventx, y = eventy, time = 150 })
end

local function spawnBomb ()
    bomb = display.newImageRect("bomb5.png", 50, 50)
    bomb.ID = "bomb"
    bomb.x = math.random(10,460)
    bomb.y = -200
    bomb.myName = "bomb"
    physics.addBody(bomb, "dynamic", {radius = 20, isSensor = true})
    bomb.gravityScale = 0.5
    bomb.isSensor = true
end

local function spawnCoin ()
    coin = display.newImageRect("stars.png", 40, 40)
    coin.ID = "coin"
    coin.x = math.random(10,460)
    coin.y = -200
    coin.myName = "coin"
    physics.addBody(coin, "dynamic", {radius = 20, isSensor = true})
    coin.gravityScale = 0.2
    coin.isSensor = true
end



local function crash(self,event)
    if(event.phase == "began") then
        if(event.other.ID == "bomb") then
            life = life - 1
            event.other:removeSelf()
            local flintS = audio.play(flintSound)
            if(life == 0 ) then
                display.remove(circle)
                display.remove(coin)
                display.remove(bomb)
                composer.gotoScene("gameOver5" ,{effect = "fade", time = 800} )
            end
        elseif(event.other.ID == "coin") then
            score = score - 1
            event.other:removeSelf()
            local coinS = audio.play(coinSound)
            scoreText.text = ": "..score
            if(score == 0) then
                display.remove(circle)
                display.remove(coin)
                display.remove(bomb)
                composer.gotoScene("menu" ,{effect = "fade", time = 2000} )
            end
        end
    end
end



 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )


 
    local sceneGroup = self.view
    local lvl5S = audio.play(lvl5Sound)
    score = 10
    life = 3
    _W = display.contentWidth
    _H = display.contentHeight
    bg = display.newImage(sceneGroup, "bg_5.jpg", _W/2, _H/2)
    bg.height = 340
    bg.width = 720

    circle = display.newImageRect("car.png", 50, 35)
    circle.x = _W/2
    circle.y = _H/2+100
    physics.addBody(circle, "static")
    circle.isSensor = true
    circle.ID = "player"


    circle.collision = crash
    circle:addEventListener("collision", circle)


    
    scoreText = display.newText(sceneGroup, " : "..score, -60, 50, "RubikWetPaint-Regular.ttf", 25 )
    local scoreImg = display.newImageRect(sceneGroup, "stars.png",40, 40)
    scoreImg.x = -90
    scoreImg.y = 50


    local lifeImg = display.newImageRect(sceneGroup, "life5.png",20, 20)
    lifeImg.x = -90
    lifeImg.y = 90

    local lifeImg2 = display.newImageRect(sceneGroup, "life5.png",20, 20)
    lifeImg2.x = -65
    lifeImg2.y = 90

    local lifeImg3 = display.newImageRect(sceneGroup, "life5.png",20, 20)
    lifeImg3.x = -40
    lifeImg3.y = 90

    local function checkLife(self, event)
        if(score == 0) then
            display.remove(lifeImg3)
            display.remove(lifeImg2)
            display.remove(lifeImg)
            display.remove(scoreImg)
        end
        if(life == 2) then
            display.remove(lifeImg3)
        elseif(life == 1) then
            display.remove(lifeImg2)
        elseif(life == 0) then
            display.remove(lifeImg)
            display.remove(scoreImg)
        end
    end

    lifeImg3.enterFrame = checkLife
    Runtime:addEventListener("enterFrame", lifeImg3)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    physics.start()
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        
    elseif ( phase == "did" ) then
        spawnBomb_timer = timer.performWithDelay (1000,spawnBomb, 0)
        spawnCoin_timer = timer.performWithDelay (1800,spawnCoin, 0)
        bg:addEventListener("tap", movePers)
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        Runtime:removeEventListener("enterFrame", lifeImg3)
        timer.cancel(spawnCoin_timer)
        timer.cancel(spawnBomb_timer)
        bg:removeEventListener("tap", movePers)
        circle:removeEventListener("collision", circle)
        audio.stop()
    elseif ( phase == "did" ) then
        physics.pause()
        composer.removeScene( "lvl5", {effect = "fade", time = 800}  )
 
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