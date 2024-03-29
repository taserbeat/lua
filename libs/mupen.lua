local mupen = {}

-- アドレス
mupen.address = {
    rdram = emu.getaddress("rdram"),
    rdram_register = emu.getaddress("rdram_register"),
    MI_register = emu.getaddress("MI_register"),
    pi_register = emu.getaddress("pi_register"),
    sp_register = emu.getaddress("sp_register"),
    rsp_register = emu.getaddress("rsp_register"),
    si_register = emu.getaddress("si_register"),
    vi_register = emu.getaddress("vi_register"),
    ai_register = emu.getaddress("ai_register"),
    dpc_register = emu.getaddress("dpc_register"),
    dps_register = emu.getaddress("dps_register"),
    DP_DMEM = emu.getaddress("DP_DMEM"),
    PIF_RAM = emu.getaddress("PIF_RAM")
}

-- メモリ関連 --

mupen.readbyte_as_mhs = function(mhs_address)
    local xoredAddress = XOR(mhs_address, 3)
    return memory.readbyte(xoredAddress - mupen.address.rdram)
end

-- mupen.readword_as_mhs = function(mhs_address)
-- TODO: 動作が確認できたらコメントアウトを解除する
--     local xoredAddress = XOR(mhs_address, 0x2)
--     return memory.readdword(xoredAddress - mupen.address.rdram)
-- end

mupen.readdword_as_mhs = function(mhs_address)
    return memory.readdword(mhs_address - mupen.address.rdram)
end

mupen.readfloat_as_mhs = function(mhs_address)
    return memory.readfloat(mhs_address - mupen.address.rdram)
end

mupen.writebyte_as_mhs = function(mhs_address, value)
    local xored_address = XOR(mhs_address, 3)
    memory.writebyte(xored_address - mupen.address.rdram, value)
end

-- mupen.writeword_as_mhs = function(mhs_address, value)
-- TODO: 動作が確認できたらコメントアウトを解除する
--     local xoredAddress = XOR(mhs_address, 0x2)
--     return memory.writeword(xoredAddress - mupen.address.rdram, value)
-- end

mupen.writedword_as_mhs = function(mhs_address, value)
    memory.writedword(mhs_address - mupen.address.rdram, value)
    return
end

mupen.writefloat_as_mhs = function(mhs_address, value)
    memory.writefloat(mhs_address - mupen.address.rdram, value)
    return
end

-- 描画関連 --

local initialWindowInfo = wgui.info()

mupen.drawText = function(width, height, text)
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

-- ウィンドウ関連

mupen.fixFlick = function()
    -- drawTextを行った際の画面ちらつきを防ぐ
    wgui.setcolor("red")
    wgui.text(820, 580, " ")
    wgui.setcolor("white")
    wgui.text(820, 580, " ")
end

mupen.getInitialWindowInfo = function()
    -- wgui.info
    return initialWindowInfo
end

mupen.getCurrentWindowInfo = function()
    -- wgui.info
    return wgui.info()
end

return mupen
