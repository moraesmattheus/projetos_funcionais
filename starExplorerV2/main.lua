--- AULA DO DIA 12.07.23 ---
local composer = require ("composer")

display.setStatusBar (display.HiddenStatusBar)

math.randomseed (os.time())

-- Comando que inicia a cena principal.
composer.gotoScene("game")