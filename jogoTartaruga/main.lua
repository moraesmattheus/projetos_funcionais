local physics = require("physics")
local widget = require("widget")

physics.start()
physics.setGravity(0, 0)

local larguraTela = display.actualContentWidth
local alturaTela = display.actualContentHeight

local usarFundo = true
local bg

local grupoObjetos = display.newGroup()

local imagensFundo = {
    "imagens/bg.png"
}
local imagemJogador = "imagens/tarta.png"
local imagemCesto = "imagens/cesta.png"

local gameOver = false
local pontuacao = 0
local vidas = 3

-- Criar a variável jogador e cesto no escopo global
local jogador
local cesto

local function moverJogador(evento)
    local alvo = evento.target
    if evento.phase == "began" then
        if alvo.id == "botaoEsquerda" then
            jogador.x = jogador.x - 10 -- Movendo para a esquerda
        elseif alvo.id == "botaoDireita" then
            jogador.x = jogador.x + 10 -- Movendo para a direita
        end
        cesto.x = jogador.x
    end
end

jogador = display.newImageRect(imagemJogador, larguraTela * 0.1, alturaTela * 0.05)
jogador.x = display.contentCenterX
jogador.y = alturaTela - alturaTela * 0.1

physics.addBody(jogador, "dynamic", { radius = larguraTela * 0.025 })
jogador.isFixedRotation = true

cesto = display.newImageRect(imagemCesto, larguraTela * 0.1, alturaTela * 0.05)
cesto.x = jogador.x
cesto.y = jogador.y + alturaTela * 0.05
physics.addBody(cesto, "static", { radius = larguraTela * 0.04 })

local function criarObjetoCaindo()
    if gameOver then return end

    local opcoesImagensObjetos = {
        "imagens/bala.png",
        "imagens/caixa.png",
        "imagens/cascabanana.png",
        "imagens/garrafa.png",
        "imagens/latalixo.png",
        "imagens/copo.png",
        "imagens/lixo2.png",
        "imagens/lixogg.png",
        "imagens/peixeesqueleto.png",
        "imagens/plastico.png",
        "imagens/radioativo.png",
        "imagens/sacolalixo.png",
        "imagens/lixoggg.png",
        "imagens/restofruta.png"
    }

    local indiceAleatorio = math.random(#opcoesImagensObjetos)
    local imagemObjeto = opcoesImagensObjetos[indiceAleatorio]
    local objeto = display.newImageRect(grupoObjetos, imagemObjeto, larguraTela * 0.08, larguraTela * 0.08)

    -- Define a posição X aleatória dentro da largura da tela
    objeto.x = math.random(larguraTela)

    -- Define a posição Y acima da tela, para que os objetos caiam de cima
    objeto.y = -50

    physics.addBody(objeto, "dynamic", { radius = larguraTela * 0.04 })
end

local botaoEsquerda = widget.newButton({
    x = larguraTela * 0.2,
    y = alturaTela * 0.9,
    width = 80,
    height = 80,
    defaultFile = "imagens/cima branco.png",
    onEvent = moverJogador
})
botaoEsquerda.rotation = 90
botaoEsquerda.id = "botaoEsquerda"

local botaoDireita = widget.newButton({
    x = larguraTela * 0.8,
    y = alturaTela * 0.9,
    width = 80,
    height = 80,
    defaultFile = "imagens/cima branco.png",
    onEvent = moverJogador
})
botaoDireita.rotation = -90
botaoDireita.id = "botaoDireita"

local function atualizarPontuacao(pontos)
    if gameOver then return end

    pontuacao = pontuacao + pontos
    print("Pontuação: " .. pontuacao)

    if pontuacao >= 10 then
        jogador:scale(1.2, 1.2)
    end
end

local function atualizarVidas()
    if gameOver then return end

    vidas = vidas - 1
    print("Vidas restantes: " .. vidas)

    if vidas <= 0 then
        gameOver()
    end
end

local function jogoAcabou()
    gameOver = true
    -- Implemente as ações necessárias quando o jogo termina
end

local function soltarObjetos()
    if gameOver then return end

    criarObjetoCaindo()

    local atraso = math.random(1000, 3000)
    timer.performWithDelay(atraso, soltarObjetos)
end

soltarObjetos()

if usarFundo then
    local indiceAleatorio = math.random(#imagensFundo)
    bg = display.newImageRect(imagensFundo[indiceAleatorio], larguraTela, alturaTela)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY
    bg:toBack()
end

local function reiniciarJogo()
    for i = grupoObjetos.numChildren, 1, -1 do
        display.remove(grupoObjetos[i])
    end

    gameOver = false
    pontuacao = 0
    vidas = 3

    jogador.x = display.contentCenterX
    jogador.y = alturaTela - alturaTela * 0.1

    cesto.x = jogador.x
    cesto.y = jogador.y + alturaTela * 0.05

    soltarObjetos()
end

reiniciarJogo()
