-- 依存モジュール
local mhs = require("mhs")
local mupen = require("mupen")

local link = {}

-- 最大体力
link.getMaxHp = function()
    -- integer
    return mupen.readdword_as_mhs(mhs.address.MaxHp)
end

-- 魔力
link.getMagic = function()
    -- integer
    return mupen.readdword_as_mhs(mhs.address.Magic)
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

--
-- 
return link
