-- アドレス検索用のスクリプト
local START_ADDRESS = emu.getaddress("rdram")
-- local START_ADDRESS = 0x02176f30
local END_ADDRESS = 0x7FFFFFFF
local ADDRESS_INTERVAL = 0x2
local STATE_FILE_1 = "../../save/states/have_33_rupee.st"
local TARGET_BYTE_VALUE_AT_STATE1 = 33
local STATE_FILE_2 = "../../save/states/have_40_rupee.st"
local TARGET_BYTE_VALUE_AT_STATE2 = 40
local COMPARISON_WAIT_FRAME = 3

function GET_VALUE(address) return memory.readbyte(address) end

local window = wgui.info()
local current_address = START_ADDRESS
local comparison_frame = 0
local is_state1_loaded = true
local is_state2_loaded = false

wgui.resize(window.width * 1.3, window.height)
emu.atstop(function() OnStop() end)

function OnStop()
    wgui.resize(window.width, window.height)
    print("Done!")
end

function OnUpdate()
    local text = string.format("address: %x", current_address)
    DrawText(window.width, 20, text)

    -- 表示
    FixFlick()

    -- 処理
    local value = GET_VALUE(current_address)

    if is_state1_loaded then
        -- state1がロードされている場合
        comparison_frame = comparison_frame + 1
        if comparison_frame < COMPARISON_WAIT_FRAME then return end

        if value == TARGET_BYTE_VALUE_AT_STATE1 then
            savestate.loadfile(STATE_FILE_2)
            is_state1_loaded = false
            is_state2_loaded = true
            comparison_frame = 0
            return
        end
    else
        if is_state2_loaded then
            -- state2がロードされている場合
            comparison_frame = comparison_frame + 1
            if comparison_frame < COMPARISON_WAIT_FRAME then return end

            if value == TARGET_BYTE_VALUE_AT_STATE2 then
                print(string.format("The address : %x", current_address))
            end

            savestate.loadfile(STATE_FILE_1)
            is_state1_loaded = true
            is_state2_loaded = false
            comparison_frame = 0
        end
    end

    -- 更新処理
    current_address = current_address + ADDRESS_INTERVAL
    if current_address > END_ADDRESS then UnregisterFunc(OnUpdate) end
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

gui.register(OnUpdate)
savestate.loadfile(STATE_FILE_1)
