local my_wrapper = require("wrapper")

local SPEED_ADDRESS = 0x00A64A78

local window = wgui.info()
wgui.resize(window.width * 1.2, window.height)
emu.atstop(function() OnStop() end)

function OnStop() wgui.resize(window.width, window.height) end

function OnUpdate()
    -- 情報取得
    local speed = my_wrapper.readfloat_as_mhs(SPEED_ADDRESS)
    local msg = string.format("speed: %f", speed)
    DrawText(window.width, 20, msg)

    -- 表示
    FixFlick()
end

function DrawText(width, height, text)
    local background_color = "black"
    local text_color = "white"

    local spaces = string.rep("  ", string.len(text))

    -- 前画面を消す
    wgui.setbk(background_color)
    wgui.setcolor(background_color)
    wgui.text(width, height, spaces)

    -- テキスト描画
    wgui.setcolor(text_color)
    wgui.text(width, height, text)
end

function FixFlick()
    wgui.setcolor("red")
    wgui.text(820, 580, " ")
    wgui.setcolor("white")
    wgui.text(820, 580, " ")
end

function UnregisterFunc(f) gui.register(f, true) end

-- 毎フレーム指定の関数を呼び出す
-- gui.register(on_update)

emu.atvi(OnUpdate)
