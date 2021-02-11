local mupen = require("mupen")

local framework = {}

function OnInitializeDefault()
    -- 初期化処理
    local windowInfo = mupen.getInitialWindowInfo()
    wgui.resize(windowInfo.width * 1.2, windowInfo.height)
    print("Script is initialized!")
end

function OnStopDefault()
    -- Luaスクリプトのデフォルト終了処理
    local windowInfo = mupen.getInitialWindowInfo()
    wgui.resize(windowInfo.width, windowInfo.height)
    print("Script is stopped!")
end

function OnUpdateDefault()
    -- Luaスクリプトのデフォルト更新処理
    -- 何もしない
end

function OnUpdateWithFixFlip()
    -- Luaスクリプトの更新処理
    mupen.fixFlick()
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

framework.setOnUpdate = function(callback)
    -- 更新処理用のコールバックをセット
    framework.emulatorCallbacks.OnUpdate =
        function()
            callback()
            OnUpdateWithFixFlip()
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
