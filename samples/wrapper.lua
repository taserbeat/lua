-- 依存モジュール
local mupen = require("mupen")

local wrapper = {}

-- メモリ関連 --

wrapper.readdword_as_mhs = function(mhs_address)
    return memory.readdword(mhs_address - mupen.address.rdram)
end

wrapper.readfloat_as_mhs = function(mhs_address)
    return memory.readfloat(mhs_address - mupen.address.rdram)
end

-- 描画関連 --

wrapper.drawText = function(width, height, text)
    -- 画面にテキストを描画する

    local background_color = "black"
    local text_color = "white"

    local spaces = string.rep("   ", string.len(text))

    -- 前画面を消す
    wgui.setbk(background_color)
    wgui.setcolor(background_color)
    wgui.text(width, height, spaces)

    -- テキスト描画
    wgui.setcolor(text_color)
    wgui.text(width, height, text)
end

wrapper.fixFlick = function()
    -- drawTextを行った際の画面ちらつきを防ぐ
    wgui.setcolor("red")
    wgui.text(820, 580, " ")
    wgui.setcolor("white")
    wgui.text(820, 580, " ")
end

-- ウィンドウ関連

return wrapper
