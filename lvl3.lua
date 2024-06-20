local composer = require( "composer" )
local physics = require ("physics")
local scene = composer.newScene()
local widget = require "widget"
physics.start()

local gravityTimer
local pipeTimer
local blackCoinTimer
local returnButton
local winButton
local coinTimer
local winTimer
local coinY
local checkSpawn = { false, false, true, false, false }
local lvl3Sound = audio.loadSound("sound/lvl3.mp3")
local birdSound = audio.loadSound( "sound/wing1.mp3" )
local coinSound = audio.loadSound( "sound/coinBird.mp3" )
local blackCoinSound = audio.loadSound( "sound/flint.mp3" )


function scene:create(event)
    local sceneGroup = self.view

    local lvl3S = audio.play(lvl3Sound)
    local top = display.newRect(sceneGroup, 320/2, -100, 500, 10)
    physics.addBody(top,"static")

    local bottom = display.newRect(sceneGroup, 320/2, 600, 500, 10)
    physics.addBody(bottom,"static")
   

    local back = display.newImageRect(sceneGroup, "city.png", _W/2, _H/2)
    back.height = 680
    back.width = 1250


    local colCoin = display.newImageRect(sceneGroup, "plash.png", 40, 60)
    colCoin.x = -50
    colCoin.y = 30

    local bird = display.newImageRect(sceneGroup, "duckPlane.png", 80, 70)
    bird.x = _H/2 - 170
    bird.y = _W/2 - 80
    bird:setFillColor (1,1,2,1)
    bird.ID = "Player"
    physics.addBody(bird,"dynamic")
    bird.gravityScale = 0

    local moneyCount = math.random(1, 3)
    local moneyText = display.newText(sceneGroup, ": "..moneyCount, 20,30,  "BalsamiqSans-Bold.ttf", 35)
    moneyText:setFillColor (1,0,0)
    moneyText.x = -5
    moneyText.y = 30

    local function push()
        bird:applyLinearImpulse(0,-0.01, bird.x, bird.y)
        local flyChannel = audio.play(birdSound)
    end
    back:addEventListener("touch", push)

    local function birdGravity()
        bird.gravityScale = 1
    end
    gravityTimer = timer.performWithDelay(500, birdGravity, 1)

    local function onReturnButton()
        audio.stop()
        composer.removeScene("lvl3")
        composer.gotoScene("menu", "fade", 500 )
        display.remove(returnButton)
    end

    local function onWinButton()
        audio.stop()
        composer.removeScene("lvl3")
        composer.gotoScene("menu", "fade", 500 )
        display.remove(winButton)
    end

    local function spawnPipes()
        local y = math.random(-200, -100)
        coinY = y
        

        local pipe = display.newImageRect(sceneGroup, "pipe1.png", 40, 500)
        pipe.x = 700
        pipe.y = y
        pipe.yScale = -1
        pipe.ID = "GameOver"
        physics.addBody(pipe,"dynamic")
        pipe.isSensor = true
        pipe.gravityScale = 0
        pipe:setFillColor(0.928,0.228,0.928, 1)

        local pipe2 = display.newImageRect(sceneGroup, "pipe1.png", 40, 500)
        pipe2.x = 700
        pipe2.y = y + 650
        pipe2.ID = "GameOver"
        physics.addBody(pipe2,"dynamic")
        pipe2.isSensor = true
        pipe2.gravityScale = 0
        pipe2:setFillColor(0.928,0.228,0.928, 1)
        pipe:setLinearVelocity(-100,0)
        pipe2:setLinearVelocity(-100,0)
        colCoin:toFront()
        moneyText:toFront()
    end
    pipeTimer = timer.performWithDelay(2000, spawnPipes, 0)

    local function spawnCoin()
        local coin = display.newImageRect(sceneGroup, "plash.png", 90, 100)
        coin.x = 700
        coin.y = coinY + 320
        coin.ID = "Coin"
        physics.addBody(coin,"dynamic")
        coin.isSensor = true
        coin.gravityScale = 0
        coin:setLinearVelocity(-100,0)

        local function deleteCoin(self, event)
            if (event.phase == "began" and event.other.ID == "Player") then
                local collectSound = audio.play(coinSound)
                coin:removeSelf()
            end
        end
        coin.collision = deleteCoin
        coin:addEventListener("collision", coin)
    end
    coinTimer = timer.performWithDelay(6000, spawnCoin, 0)

    local function spawnBlackCoin()
        if (checkSpawn[math.random(1,5)]) then
            local coin = display.newImageRect(sceneGroup, "bread.png", 80, 60)
            coin.x = 700
            coin.y = coinY + 320
            coin.ID = "BlackCoin"
            physics.addBody(coin,"dynamic")
            coin.isSensor = true
            coin.gravityScale = 0
            coin:setLinearVelocity(-200,0)

            local function deleteCoin(self, event)
                if (event.phase == "began" and event.other.ID == "Player") then
                    local collectSound = audio.play(blackCoinSound)
                    coin:removeSelf()
                end
            end
            coin.collision = deleteCoin
            coin:addEventListener("collision", coin)
        end
    end
    blackCoinTimer = timer.performWithDelay(4000, spawnBlackCoin, 0)

    local function onCollision(self, event)
        if (event.phase == "began" and event.other.ID == "Coin") then
            moneyCount = moneyCount - 1
            moneyText.text = ":"..moneyCount
        end
        if (event.phase == "began" and event.other.ID == "BlackCoin") then
            moneyCount = moneyCount + 1
            print(moneyCount)
            moneyText.text = ":"..moneyCount
        end
        if (event.phase == "began" and event.other.ID == "GameOver") then
            timer.cancel( pipeTimer )
            timer.cancel( gravityTimer )
            timer.cancel( coinTimer )
            timer.cancel( blackCoinTimer )
            timer.cancel( winTimer )
            display.remove(bird)
            display.remove(pipe)
            display.remove(pipe2)
            display.remove(coin)
            back:removeEventListener("touch", push)

            local backOver = display.newRect( sceneGroup, 0, 0, display.actualContentWidth, display.actualContentHeight )
            backOver.x = display.contentCenterX
            backOver.y = display.contentCenterY
            backOver:setFillColor(0)
            backOver.alpha = 0.8

            local endText = display.newText( sceneGroup, "Игра окончена", 100, 200, "BalsamiqSans-Bold.ttf", 42)
            endText.x = display.contentCenterX
            endText.y = 110
            endText:setFillColor(0.7,0.1,0.1,1)

            returnButton = widget.newButton{
                label = "Меню",
                labelColor = { default={ 1.0 }, over={ 0.5 } },
                defaultFile = "button.png",
                font = "BalsamiqSans-Bold.ttf",
                width = 180,
                height = 70,
                fontSize = 24,
                onRelease = onReturnButton
            }
            returnButton.x = display.contentCenterX
            returnButton.y = display.contentHeight -130
            return sceneGroup
        end
    end
    bird.collision = onCollision
    bird:addEventListener("collision", bird)

    local function win(event)
        if (moneyCount == 0) then
            timer.cancel( pipeTimer )
            timer.cancel( gravityTimer )
            timer.cancel( coinTimer )
            timer.cancel( blackCoinTimer )
            timer.cancel( winTimer )
            display.remove(bird)
            back:removeEventListener("touch", push)

            local backOver = display.newRect( sceneGroup, 0, 0, display.actualContentWidth, display.actualContentHeight )
            backOver.x = display.contentCenterX
            backOver.y = display.contentCenterY
            backOver:setFillColor(0)
            backOver.alpha = 0.8



            local endText = display.newText( sceneGroup, "Поздравляем!", 100, 200, "BalsamiqSans-Bold.ttf", 42)
            endText.x = display.contentCenterX
            endText.y = 110
            endText:setFillColor(1,1,0,1)

            winButton = widget.newButton{
                label = "Меню",
                labelColor = { default={ 1.0 }, over={ 0.5 } },
                defaultFile = "button.png",
                font = "BalsamiqSans-Bold.ttf",
                width = 180,
                height = 70,
                fontSize = 24,
                onRelease = onWinButton
            }
            winButton.x = display.contentCenterX
            winButton.y = display.contentHeight -130


            return sceneGroup
        end
    end
    winTimer = timer.performWithDelay(100, win, 0)
end

function scene:show(event)
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

        audio.stop()
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        physics.pause()
        composer.removeScene( "lvl3", {effect = "fade", time = 800}  )
    end
end

function scene:destroy(event)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene