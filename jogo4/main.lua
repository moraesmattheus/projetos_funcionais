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

local bg = display.newImageRect(groupBg, "imagens/bg.jpg", 2400,1000)
bg.x = display.contentCenterX
bg.y = display.contentCenterY

local pontosText = display.newText(groupUI, "Pontos " .. pontos, 70, 15, native.systemFont, 20)
pontosText:setFillColor(255, 252, 245)

local vidasText = display.newText(groupUI, "Vidas " .. vidas, 970, 15, native.systemFont, 20)
vidasText:setFillColor(255, 252, 245)

local player = display.newImageRect(groupMain,"imagens/heroi.png", 500,500)
player.x = 50
player.y = 700
player.myName = "wiz" 
physics.addBody(player, "dinamic")


--criando botao 
local botaoDireita = display.newImageRect(groupUI, "imagens/seta.png", 70, 70)
botaoDireita.x = 80
botaoDireita.y = 148


local botaoEsquerda = display.newImageRect(groupUI, "imagens/seta.png", 70, 70)
botaoEsquerda.x = 40
botaoEsquerda.y = 145
botaoEsquerda.rotation = -180


--add botao de tiro
local botaoTiro = display.newImageRect(groupUI, "imagens/fire.png", 80, 80)
botaoTiro.x = 60
botaoTiro.y = 95


local function esquerda ()
    player.x = player.x - 10
end
local function direita()
    player.x = player.x + 10
end

botaoDireita:addEventListener("tap",direita)
botaoEsquerda:addEventListener("tap", esquerda)


local function atirar()
    local magia = display.newImageRect(groupMain, "imagens/magia heroi.png",80,80)

    magia.x = player.x + 25
    magia.y = player.y - 50
    physics.addBody(magia, "dynamic", { isSensor = true })
    transition.to(magia, {
        x = 450,
        time = 1000,
        onComplete = function()
            display.remove(magia)
        end
    })
    magia.myName = "atkpadrao"
    magia:toBack()
end
botaoTiro:addEventListener("tap", atirar)

local inimigo = display.newImageRect(groupMain,"imagens/boss.png", 600, 660)
inimigo.x=900
inimigo.y = 580
inimigo.myName = "malvadao"
physics.addBody(inimigo, "kinematic")
local direcaoInimigo = "lados"

local function inimigoAtirar()
    local tiroInimigo = display.newImageRect("imagens/magia inimigo.png", 80, 80)
    tiroInimigo.x = inimigo.x - 30
    tiroInimigo.y = inimigo.y + 28
    physics.addBody(tiroInimigo, "dynamic", { isSensor = true })
    transition.to(tiroInimigo, { x = -700, time = 1000, onComplete = function() display.remove(tiroInimigo) end })
    tiroInimigo.myName = "poison"
    tiroInimigo.rotation = 138
end

inimigo.timer = timer.performWithDelay(math.random(1000, 1500), inimigoAtirar, 0)
-- Movimentação do inimigo:
    local function movimentarInimigo()
        -- Se a coordenada y do inimigo não for nula
        if inimigo.y ~= nil then
            -- Quando a direção do inimigo for para a esquerda
            if direcaoInimigo == "esquerda" then
                inimigo.x = inimigo.x - 1 -- Movimenta para a esquerda
                if inimigo.x <= 0 then
                    direcaoInimigo = "direita" -- Altera a direção para a direita quando atingir a posição limite esquerda
                end
            -- Quando a direção do inimigo for para a direita
            elseif direcaoInimigo == "direita" then
                inimigo.x = inimigo.x + 1 -- Movimenta para a direita
                if inimigo.x >= 1440 then
                    direcaoInimigo = "esquerda" -- Altera a direção para a esquerda quando atingir a posição limite direita
                end
            end
        else
            print("Inimigo morreu!")
            Runtime:removeEventListener("enterFrame", movimentarInimigo)
        end
    end


    local function onCollision(event)
        if (event.phase == "began") then
            local obj1 = event.object1
            local obj2 = event.object2
    
            if ((obj1.myName == "atkpadrao" and obj2.myName == "malvadao") or (obj1.myName == "malvadao" and obj2.myName == "atkpadrao")) then
                if (obj1.myName == "atkpadrao") then
                    display.remove(obj1)
                else
                    display.remove(obj2)
                end
                pontos = pontos + 10
                pontosText.text = "Pontos" .. pontos
            elseif ((obj1.myName == "wiz" and obj2.myName == "poison") or (obj1.myName == "poison" and obj2.myName == "wiz")) then
                if (obj1.myName == "poison") then
                    display.remove(obj1)
                else
                    display.remove(obj2)
                end
                vidas = vidas - 1
                vidasText.text = "Vidas" .. vidas
            end
        end
    end
    Runtime:addEventListener("collision", onCollision)