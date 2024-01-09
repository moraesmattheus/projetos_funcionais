local physics = require("physics")-- chamar biblioteca de fisica 
physics.start()--iniciar o motor de fisica 
--physics.setGravity()-- definir a gravidade
physics.setGravity (0,0)
physics.setDrawMode("hybrid")-- definir o modo de renderizaçao(hybrid,debug)

--remover a barra de notificaçao 
display.setStatusBar(display.HiddenStatusBar)

--criar os grupos de exibiçao 

local groupBg = display.newGroup() --objetos ddecorativos, cenario ( nao tem interaçao)
local groupMain = display.newGroup()--Bloco principal (tudo que precisar interagir com o player fica nesse grupo)
local groupUI = display.newGroup()--interface do usuario (placares,botoes...)

--Criar variaveis de pontos e vida para atribuicao de valor

local pontos = 0
local vidas = 4


-- add bg ( colocar fisica no bg para o chao nao da certo, a fisica ativa em todo bg)
-- (largura altura)
local bg = display.newImageRect(groupBg,"imagens/bg.jpg",158*2,418*2)
bg.x=display.contentCenterX
bg.y = 300

-- add chao ( posicionamento x,y,largura e altura)
local chao = display.newRect(groupBg, 100, 585, 500, 20)
chao:setFillColor(0, 0, 0)
physics.addBody(chao, "staticBody")



-- add placar screen
--(grupo"seu texto aqui", localizaçao x, y fonte e tamanho da fonte )
local pontosText = display.newText(groupUI, "Pontos " .. pontos, 70, -80, native.systemFont, 20)
pontosText:setFillColor(255, 252, 245)


local vidasText = display.newText(groupUI, "Vidas " .. vidas, 250, -80, native.systemFont, 20)
vidasText:setFillColor(255, 252, 245)

-- add hero
local player = display.newImageRect(groupMain,"imagens/pngaaa.com-99006.png", 110, 110)
player.x = 70
player.y = 500
player.myName = "Richard" -- usar para nomear nas colisoes 
physics.addBody(player, "dianmic") -- kinematic nao cai com a gravidade apenas interage, porem se add um impulso ou qualquer outra força ele sofre a reaçao 


--criando botao 
local botaoCima = display.newImageRect(groupMain, "imagens/cima branco.png", 50, 50)
botaoCima.x = 40
botaoCima.y = 150
botaoCima:setFillColor(255, 252, 245)

-- x = horizontal
-- y = vertical
local botaoBaixo = display.newImageRect(groupMain, "imagens/cima branco.png", 50, 50)
botaoBaixo.x = 100
botaoBaixo.y = 150
botaoBaixo.rotation = -180
botaoBaixo:setFillColor(255, 255, 255)

--add botao de tiro
local botaoTiro = display.newImageRect(groupMain, "imagens/botao tiro.png", 80, 80)
botaoTiro.x = 60
botaoTiro.y = 220



    -- add func mov

local function cima()
    player.y = player.y - 10
end
local function baixo()
    player.y = player.y + 10
end



-- add o ouvinte e a funcao do botao (tap,colisao)
botaoCima:addEventListener("touch",cima)
botaoBaixo:addEventListener("touch",baixo)
--caso queira que o persoagem nao ultrapasse o limite da tela criar uma funcao ou uma fisica para isso



--funcao para atirar:
local function atirar()
    -- toda vez que a afunçao for executada criasse um tiro 
    local projetil = display.newImageRect(groupMain, "imagens/projetil.png", 20, 20)
    -- a localixaçao e a mesma do pleyer ( caso queria arrumar para ficar na posicao correta fazer as conatas corretas, tipo aloc.y + a0 por exemplo )
    projetil.rotation = 90
    projetil.x =player.x
    projetil.y = player.y+15
    physics.addBody(projetil, "dynamic", { isSensor = true }) -- determinamos que o projetil e um sensor que ativa a dtecçao contínua de colisao
    --trasiçao do projetil para a linha x=450 para 1000 milisegundos 
    transition.to(projetil,{x=450,time=1000,onComplete=function () display.remove (projetil)
        end})
    projetil.myName = "bala"
    projetil:toBack() -- jogo o elemento para tras dentro do grupo de exibiçao dele


    end
--onComplete=quando completar a transiçao vai remover a transiçao 

botaoTiro:addEventListener("tap", atirar)


-- add inimigo
local inimigo = display.newImageRect(groupMain,"imagens/inimigo.png", 130, 130)
inimigo.x=290
inimigo.y = 500
inimigo.myName = "malvadao"
physics.addBody(inimigo, "kinematic")
local direcaoInimigo = "cima"

-- Funcao para atirar do inimigo 
local function inimigoAtirar()
    local tiroInimigo = display.newImageRect("imagens/bola de fogo inimigo.png", 50, 50)
    tiroInimigo.x = inimigo.x -30
    tiroInimigo.y = inimigo.y + 28
    physics.addBody(tiroInimigo, "dynamic", { isSensor = true })
    transition.to(tiroInimigo, { x = -700, time = 1000, onComplete = function() display.remove(tiroInimigo) end })
    tiroInimigo.myName = "Bola de fogo"
    tiroInimigo.rotation = 138
end

--criando o timer de disparo do inimigo
inimigo.timer = timer.performWithDelay(math.random(1000, 1500), inimigoAtirar, 0)


-- Movimentação do inimigo:
    local function movimentarInimigo ()
        -- Se a localização x não for igual a nulo então 
            if not (inimigo.x == nil ) then
        -- Quando a direção do inimigo for cima
                if (direcaoInimigo == "cima") then
                    inimigo.y = inimigo.y - 1
        --  Se a localização y do inimigo for menor ou igual
                    if (inimigo.y <= 50 ) then
                        -- altera a variável para "baixo"
                        direcaoInimigo = "baixo"
                    end -- if (inimigo.y .....)
        -- Se a direção do inimigo for igual a baixo então
                elseif (direcaoInimigo == "baixo" ) then
                    inimigo.y = inimigo.y + 1
        -- Se a localização y do inimigo for maior ou igual a 400 então
                    if (inimigo.y >= 400 ) then
                        direcaoInimigo = "cima"
                    end
                end

            else
                print("Inimigo morreu!")

                Runtime:removeEventListener ("enterFrame", movimentarInimigo)
            end
        end

Runtime:addEventListener("enterFrame", movimentarInimigo)
        
--representa todo o jogo fps

local function onCollision(event)
    if (event.phase == "began") then
        local obj1 = event.object1
        local obj2 = event.object2

        if ((obj1.myName == "bala" and obj2.myName == "malvadao") or (obj1.myName == "malvadao" and obj2.myName == "bala")) then
            if (obj1.myName == "bala") then
                display.remove(obj1)
            else
                display.remove(obj2)
            end
            pontos = pontos + 10
            pontosText.text = "Pontos" .. pontos
        elseif ((obj1.myName == "Richard" and obj2.myName == "Bola de fogo") or (obj1.myName == "Bola de fogo" and obj2.myName == "Richard")) then
            if (obj1.myName == "Bola de fogo") then
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

-- Carregar áudio de fundo
local audioBg = audio.loadStream("audio/bg.mp3")

-- Configurar volume do áudio de fundo
audio.setVolume(0.5, { channel = 1 })

-- Reproduzir áudio de fundo em loop
audio.play(audioBg, { channel = 1, loops = -1 })

-- Carregar áudio da colisão do projétil com o jogador
local audioColisao = audio.loadSound("audio/feitico.mp3")

-- Função para tratar a colisão do projétil com o jogador
local function colisaoJogador(event)
    if (event.phase == "began") then
        local obj1 = event.object1
        local obj2 = event.object2

        if ((obj1.myName == "bala" and obj2.myName == "malvadao") or (obj1.myName == "malvadao" and obj2.myName == "bala")) then
            -- Tocar o áudio da colisão
            audio.play(audioColisao)
            -- Resto do seu código de tratamento da colisão...
        end
    end
end
Runtime:addEventListener("collision", colisaoJogador)

-- Carregar áudio de colisão com bola de fogo
local audioColisaoBolaFogo = audio.loadSound("audio/feitico.mp3")

-- Função para tratar a colisão da bola de fogo com o jogador
local function colisaoBolaFogo(event)
    if (event.phase == "began") then
        local obj1 = event.object1
        local obj2 = event.object2

        if ((obj1.myName == "Bola de fogo" and obj2.myName == "Richard") or (obj1.myName == "Richard" and obj2.myName == "Bola de fogo")) then
            -- Tocar o áudio de colisão com bola de fogo
            audio.play(audioColisaoBolaFogo)
            -- Resto do seu código de tratamento da colisão...
        end
    end
end
Runtime:addEventListener("collision", colisaoBolaFogo)

