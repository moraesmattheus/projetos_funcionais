local physics = require("physics")
physics.start()
physics.setDrawMode("normal")

--remover a barra de notificaçao
display.setStatusBar(display.HiddenStatusBar)


local bg=display.newImageRect("imagens/background.png",1000,1400)
bg.x=display.contentCenterX
bg.y=display.contentCenterY

local plataforma=display.newImageRect("imagens/platform.png",330,60)
plataforma.x=display.contentCenterX
plataforma.y=display.contentHeight+90
physics.addBody(plataforma,"static")



local balao=display.newImageRect("imagens/balloon.png",120,122)
balao.x=display.contentCenterX
balao.y=display.contentCenterY
balao.alpha=0.8
physics.addBody(balao,"dynamic",{radius=50, bounce=0.6})--metade do raio total do objeto
     -- (bounce:velocidade do retorno depois da colisao)--(radius:defini o corpo fisico)
local numToques = 0

local toquesText = display.newText(numToques,display.contentCenterX,50,native.systemFont,40)
toquesText:setFillColor (0,0,0)

local function cima ()
    --parametros:(impulsoX,impulsoY,objeto.x,objeto.y)
    balao:applyLinearImpulse(0,-0.75,balao.x,balao.y)
    numToques=numToques+1
    toquesText.text=numToques
end
local function zerou ()
    numToques=0
    toquesText.text=numToques
end

plataforma:addEventListener("collision", zerou)
balao:addEventListener("tap",cima)

