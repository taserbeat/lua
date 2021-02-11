local frame_count = 0
local window = wgui.info()
wgui.resize(window.width * 1.2, window.height)
emu.atstop(function() OnStop() end)

function OnStop() wgui.resize(window.width, window.height) end

function OnUpdate()
    local msg = string.format("frame: %d", frame_count)
    DrawText(window.width, 20, msg)

    -- 処理
    MushZ()

    -- 表示
    DrawJoyPadAInput(window.width, 0)
    FixFlick()

    -- 更新処理
    frame_count = frame_count + 1
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

function DrawJoyPadAInput(width, height)
    -- ジョイパッドの情報を取得
    local joy = joypad.get()
    local msg = " "
    if joy.Z then msg = "Z" end
    DrawText(width, height, msg)
end

function FixFlick()
    wgui.setcolor("red")
    wgui.text(820, 580, " ")
    wgui.setcolor("white")
    wgui.text(820, 580, " ")
end

function UnregisterFunc(f) gui.register(f, true) end

function MushZ()
    if frame_count % 2 == 0 then
        joypad.set(1, {up = true, Z = true})
    else
        joypad.set(1, {up = true})
    end
end

emu.atvi(OnUpdate)
