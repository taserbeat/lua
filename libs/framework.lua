local mupen = require("libs.mupen")
local cheat = require("libs.cheat")

local framework = {}

local initialWindowInfo = mupen.getInitialWindowInfo()

function OnInitializeDefault()
    -- 初期化処理
    local windowInfo = mupen.getInitialWindowInfo()
    wgui.resize(windowInfo.width * 1.2, windowInfo.height)
    joypad.register(cheat.listener)
    print("Script is initialized!")
end

function OnStopDefault()
    -- Luaスクリプトのデフォルト終了処理
    local windowInfo = mupen.getInitialWindowInfo()
    wgui.resize(windowInfo.width, windowInfo.height)
    emu.speed(100)
    print("Script is stopped!")
end

function OnUpdateDefault()
    -- Luaスクリプトのデフォルト更新処理
    -- 何もしない
end

function OnUpdateWithFixFlip()
    -- Luaスクリプトの更新処理
    -- mupen.fixFlick()
end

framework.emulatorCallbacks = {
    OnInitialize = OnInitializeDefault,
    OnStop = OnStopDefault,
    OnUpdate = OnUpdateWithFixFlip
}

framework.setOnInitialize = function(callback)
    -- 初期化用のコールバックをセット
    framework.emulatorCallbacks.OnInitialize = callback
end

framework.setOnStop = function(callback)
    -- 終了処理用のコールバックをセット
    framework.emulatorCallbacks.OnStop = callback
end

function ClearExtendedScreen()
    -- X方向正の向きにwgui.resize()で拡張された領域を黒く塗りつぶす
    local windowInfo = wgui.info()
    wgui.setbrush("black")
    wgui.rect(initialWindowInfo.width, 0, windowInfo.width, windowInfo.height)
end

framework.setOnUpdate = function(callback)
    -- 更新処理用のコールバックをセット
    framework.emulatorCallbacks.OnUpdate =
        function()
            -- Note: ClearExtendedScreenを実行することで謎の白い焼付けが直る
            ClearExtendedScreen()

            callback()

            -- Note: (Mupen Ver1.0.6から?)画面のちらつきがなくなっていたのでコメントアウトにする
            -- OnUpdateWithFixFlip()
        end
end

framework.run = function()
    -- Luaスクリプトを開始する
    framework.emulatorCallbacks.OnInitialize()
    -- emu.atstop(function() emulatorCallbacks.OnStop() end)
    emu.atstop(framework.emulatorCallbacks.OnStop)
    emu.atvi(framework.emulatorCallbacks.OnUpdate)
end

framework.unregister = function()
    -- 更新処理を解除する
    emu.atvi(framework.emulatorCallbacks.OnUpdate, true)
    print("Script is registered")
end

return framework
