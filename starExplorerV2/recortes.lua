
local composer = require("composer")

local scene = composer.newScene()

function scene:create(event)
local sceneGroup = self.view
-- Código aqui será executado quando a cena for criada, mas ainda não tiver aparecido na tela
end

function scene:show(event)
local sceneGroup = self.view
local phase = event.phase

if (phase == "will") then
-- Código aqui será executado quando a cena estiver prestes a aparecer na tela
elseif (phase == "did") then
-- Código aqui será executado quando a cena estiver completamente na tela
end
end

function scene:hide(event)
local sceneGroup = self.view
local phase = event.phase

if (phase == "will") then
-- Código aqui será executado quando a cena estiver prestes a sair da tela
elseif (phase == "did") then
-- Código aqui será executado quando a cena estiver completamente fora da tela
end
end

function scene:destroy(event)
local sceneGroup = self.view
-- Código aqui será executado antes da remoção da visualização da cena
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene