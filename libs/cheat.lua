local link = require("libs.link")

local cheat = {}

function OnJoyPadUpDefault()
    -- ジョイパッドで"up"が押されたときのデフォルトのコールバック
    link.highSpeed()
end

function OnJoyPadDownDefault()
    -- ジョイパッドで"down"が押されたときのデフォルトのコールバック
    link.moonJump()
end

function OnJoyPadLeftDefault()
    -- ジョイパッドで"left"が押されたときのデフォルトのコールバック
    link.healHP()
end

function OnJoyPadRightDefault()
    -- ジョイパッドで"right"が押されたときのデフォルトのコールバック
    link.dyingHp()
end

cheat.handler = {
    OnJoyPadUp = OnJoyPadUpDefault,
    OnJoyPadDown = OnJoyPadDownDefault,
    OnJoyPadLeft = OnJoyPadLeftDefault,
    OnJoyPadRight = OnJoyPadRightDefault
}

cheat.setOnJoypadUp = function(callback)
    -- ジョイパッド"up"が押されたときのコールバックをセット
    cheat.handler.OnJoyPadUp = callback
end

cheat.setOnJoypadDown = function(callback)
    -- ジョイパッド"down"が押されたときのコールバックをセット
    cheat.handler.OnJoyPadDown = callback
end

cheat.setOnJoypadLeft = function(callback)
    -- ジョイパッド"left"が押されたときのコールバックをセット
    cheat.handler.OnJoyPadLeft = callback
end

cheat.setOnJoypadRight = function(callback)
    -- ジョイパッド"right"が押されたときのコールバックをセット
    cheat.handler.OnJoyPadRight = callback
end

cheat.listener = function()
    local joy = joypad.get()
    if joy.up then cheat.handler.OnJoyPadUp() end
    if joy.down then cheat.handler.OnJoyPadDown() end
    if joy.left then cheat.handler.OnJoyPadLeft() end
    if joy.right then cheat.handler.OnJoyPadRight() end
end

return cheat
