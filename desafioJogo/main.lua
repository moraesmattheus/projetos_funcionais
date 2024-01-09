local physics = require("physics")
physics.start()
physics.setGravity (0,0)
physics.setDrawMode("hybrid")


display.setStatusBar(display.HiddenStatusBar)


local groupBg = display.newGroup()
local groupMain = display.newGroup()
local groupUI = display.newGroup()

local pontos = 0
local vidas = 2

local bg = display.newImageRect(groupBg, "imagens/bg.jpg", 1400*0.5,1400*0.5)
bg.x = 150
bg.y = display.contentCenterY

local pontosText = display.newText(groupUI, "Pontos " .. pontos, 70, -80, native.systemFont, 20)
pontosText:setFillColor(255, 252, 245)

local vidasText = display.newText(groupUI, "Vidas " .. vidas, 250, -80, native.systemFont, 20)
vidasText:setFillColor(255, 252, 245)

local hero = display.newImageRect(groupMain,"imagens/hero2.png", 110, 110)
hero.x = 50
hero.y = 530
hero.myName = "wiz" 
physics.addBody(hero, "dianmic")
hero.rotation = -360
