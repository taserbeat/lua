-- 依存モジュール
local mhs = require("libs.mhs_mupen_oot_v10")
local mupen = require("libs.mupen")

local link = {}

----- パラメータ取得関連 -----

link.getExitId = function()
    -- integer
    return mupen.readdword_as_mhs(mhs.address.ExitId)
end

-- 最大体力
link.getMaxHp = function()
    -- integer
    return mupen.readdword_as_mhs(mhs.address.MaxHp)
end

-- 魔力
link.getMagic = function()
    -- integer
    return mupen.readdword_as_mhs(mhs.address.MP)
end

-- 体力
link.getHP = function()
    -- integer
    return mupen.readdword_as_mhs(mhs.address.HP)
end

-- ルピー
link.getRupee = function()
    -- integer
    return mupen.readdword_as_mhs(mhs.address.Rupee)
end

-- X座標
link.getX = function()
    -- float
    return mupen.readfloat_as_mhs(mhs.address.X)
end

-- Y座標
link.getY = function()
    -- float
    return mupen.readfloat_as_mhs(mhs.address.Y)
end

-- Z座標
link.getZ = function()
    -- float
    return mupen.readfloat_as_mhs(mhs.address.Z)
end

link.getAngle = function()
    -- float
    -- 南: 0,東: 16384, 北: 32768, 西: 49152
    -- 角度1°あたり182.044...
    local angleOrigin = mupen.readdword_as_mhs(mhs.address.Angle)
    -- local angle = angleOrigin / 182.044
    return angleOrigin
end

-- 残像剣状態
link.getIsISG = function()
    -- boolean
    return mupen.readdword_as_mhs(mhs.address.isISG) == 1
end

-- 速度
link.getSpeed = function()
    -- float
    return mupen.readfloat_as_mhs(mhs.address.Speed)
end

-- ホバーブーツの残り時間
link.getHoverTimer = function()
    -- integer
    return mupen.readdword_as_mhs(mhs.address.HoverTimer)
end

----- チート関連 -----

link.setExitId = function(value)
    mupen.writedword_as_mhs(mhs.address.ExitId, value)
end

link.moonJump = function()
    local z = link.getZ()
    mupen.writefloat_as_mhs(mhs.address.Z, z + 13)
    return
end

link.highSpeed = function()
    -- 
    mupen.writefloat_as_mhs(mhs.address.Speed, 35)
end

link.healHP = function()
    -- 
    mupen.writedword_as_mhs(mhs.address.HP, link.getMaxHp())
end

link.dyingHp = function()
    -- 
    mupen.writedword_as_mhs(mhs.address.HP, 4)
end

link.outOfBounds = function()
    -- 
    mupen.writedword_as_mhs(mhs.address.HP, 48)
    mupen.writefloat_as_mhs(mhs.address.NonSolidGround, -2000)
end

--
-- 
return link
