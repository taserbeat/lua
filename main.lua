local framework = require("libs.framework")
local mupen = require("libs.mupen")
local link = require("libs.link")

---------- 1. 初期化処理を定義するならばコメントアウトを解除して実装する ----------

-- function OnInitialize()
--   -- 初期化処理...
-- end
-- framework.setOnInitialize(OnInitialize)

---------------------------------------------------------------------

---------- 2. Luaスクリプト終了前に呼ばれる処理を定義するならばコメントアウトを解除して実装する ----------
-- function OnStop()
--   --Luaスクリプト終了前に呼ばれる処理...
-- end
-- framework.setOnStop(OnStop)

----------------------------------------------------------------------------------------------

-- 毎フレーム実行される更新処理を実装する
local initialWindowInfo = mupen.getInitialWindowInfo()
function OnUpdate()
    -- 
    local speed_text = string.format("spped: %.1f", link.getSpeed())
    mupen.drawText(initialWindowInfo.width, 0, speed_text)

    local x_text = string.format("X: %f", link.getX())
    mupen.drawText(initialWindowInfo.width, 25, x_text)

    local y_text = string.format("Y: %f", link.getY())
    mupen.drawText(initialWindowInfo.width, 50, y_text)

    local z_text = string.format("Z: %f", link.getZ())
    mupen.drawText(initialWindowInfo.width, 75, z_text)

    local angle_text = string.format("Angle: %x", link.getAngle())
    mupen.drawText(initialWindowInfo.width, 100, angle_text)
end

framework.setOnUpdate(OnUpdate)

framework.run()
