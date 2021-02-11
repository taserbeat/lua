local MHS_ADDRESS = 0x009A3C16

local window = wgui.info()
wgui.resize(window.width * 1.3, window.height)
emu.atstop(function() OnStop() end)

local rdram_address = emu.getaddress("rdram")
local rupee_address = MHS_ADDRESS - rdram_address

function OnStop()
    -- 終了時の処理
    wgui.resize(window.width, window.height)
end

function OnUpdate()
    -- 情報取得
    local value = memory.readdword(rupee_address)
    local rupee_text = string.format("value: %d", value)
    DrawText(window.width, 20, rupee_text)

    local rupee_address_text = string.format("rupee_address: %x", rupee_address)
    DrawText(window.width, 40, rupee_address_text)

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

emu.atvi(OnUpdate)
