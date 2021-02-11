local W = memory.LWU
local analogSize = 128
local analogSize2 = analogSize + 2
local btnSize = math.floor(analogSize / 6)
local barSize = math.floor(analogSize / 8)
local width, height = 1 + analogSize2 + barSize,
                      barSize + 1 + analogSize2 + (btnSize) * 4 + 4
local wnd = wgui.info()
local top = math.floor((wnd.height - height) / 2)

local btns = {}
local lastInput, oldLastInput, orgInput, inputFlag, inputCount = {X = 0, Y = 0},
                                                                 {
    X = 12345,
    Y = 67890
}, {X = 0, Y = 0}, {}, {}
local inp, oinp, cinp = {xmouse = 0, ymouse = 0}, {}, {}
local drawFlag, tasInputUpdateFlag, forceRedraw = true, false, false
local frameAdvance = 0
function MACRO(s)
    s = "local m, org, last = ...\n" .. s
    return {s = s, f = assert(loadstring(s))}
end
local macros = {
    MACRO [[
last.A = m.c%4 == 0
last.start = m.c%2 == 0
last.Z = true
]]
}

function addButton(t, x, y, s, w)
    s = s or t
    w = w or 1
    local h = 1
    btns[t] = {
        x = x * btnSize,
        y = y * btnSize,
        w = w * btnSize,
        h = h * btnSize,
        f = math.min(w * btnSize * 1.2 / #s, (w * btnSize - 2) * 0.6),
        s = s,
        c = t == "X" or t == "Y"
    }
end
function addButtons(t) for i, o in ipairs(t) do addButton(unpack(o)) end end
--[[
	
	[�P�P�P]_    
	|�P�P�P| |
	|  3D  | |
	|�Q�Q�Q|_|
	
	   [D]      [C]
	[D][D][D][C][C][C]
	[L][S][Z][B][A][R]
]]
addButtons {
    {"X", 1, 0, "X:%+4d", 2}, {"Y", 3, 0, "Y:%+4d", 2}, {"up", 0, 0, "Up"},
    {"left", 0, 1, "Lft"}, {"down", 1, 1, "Dwn"}, {"right", 2, 1, "Rgh"},

    {"Cup", 5, 0, "C^"}, {"Cleft", 3, 1, "C<"}, {"Cdown", 4, 1, "Cv"},
    {"Cright", 5, 1, "C>"}, {"L", 0, 2}, {"start", 1, 2, "S"}, {"Z", 2, 2},
    {"B", 3, 2}, {"A", 4, 2}, {"R", 5, 2}, {"M1", 0, 3}, {"M2", 1, 3},
    {"M3", 2, 3}, {"M4", 3, 3}, {"M5", 4, 3}, {"M6", 5, 3}

}

wgui.resize(wnd.width + width, wnd.height)
emu.atstop(function() wgui.resize(wnd.width, wnd.height) end)

local xorigin, yorigin
function drawRect(x, y, w, h)
    if not drawFlag then return end
    local xx, yy = xorigin + x, yorigin + y
    wgui.rect(xx, yy, xx + w, yy + h)
end
function mouseRect(x, y, w, h, c)
    c = c or 0
    drawRect(x, y, w, h)
    local mx, my = inp.xmouse - xorigin, inp.ymouse - yorigin

    if x <= mx and mx < x + w - c and y <= my and my < y + h - c then
        return {x = mx - x, y = my - y}
    end
end
function drawLine(x, y, w, h, f)
    if not drawFlag then return end
    local xx, yy = xorigin + x, yorigin + y
    wgui.line(xx, yy, xx + w, yy + h)
    -- �I�[��`��
    if f then wgui.line(xx + w, yy + h, xx + w + 1, yy + h) end
end
function drawEllipse(x, y, w, h)
    if not drawFlag then return end
    local xx, yy = xorigin + x, yorigin + y
    wgui.ellipse(xx, yy, xx + w, yy + h)
end
function drawText(x, y, w, h, s)
    if not drawFlag then return end
    local xx, yy = xorigin + x, yorigin + y
    wgui.drawtext(s, {l = xx, t = yy, w = w, h = h}, "cv")
end

local floor = math.floor
function range(x, left, right) return math.min(math.max(x, left), right) end

local currentMouseCapture = nil
function setMouseCapture(m, f, c)
    c = c or "leftclick"
    if m and cinp[c] then
        local dx, dy = m.x - inp.xmouse, m.y - inp.ymouse
        currentMouseCapture = {f = f, dx = dx, dy = dy, c = c}
    end
end
function updateMouseCapture()
    local c = currentMouseCapture
    if c then
        if inp[c.c] then
            c.f(c.dx + inp.xmouse, c.dy + inp.ymouse, c)
            tasInputUpdateFlag = true
        else
            currentMouseCapture = nil
        end
    end
end
function tableEqual(x, y)
    if #x ~= #y then return false end
    for i, o in pairs(x) do if o ~= y[i] then return false end end
    return true
end
function tableCopy(x)
    local t = {}
    for i, o in pairs(x) do t[i] = o end
    return t
end

local inputFlagColor = {
    [false] = "#888",
    [0] = "blue",
    [1] = "black",
    [2] = "red",
    [3] = "#0F0"
}
function tasInputUpdate()
    inp = input.get()
    cinp = input.diff(inp, oinp)
    oinp = inp
    local p = lastInput

    drawFlag = not tableEqual(oldLastInput, lastInput) or forceRedraw
    forceRedraw = false
    oldLastInput = tableCopy(lastInput)

    if currentMouseCapture and cinp.rightclick then
        frameAdvance = 1
        cinp.rightclick = false
    end

    xorigin, yorigin = wnd.width, top
    wgui.setbrush("#DDD") -- background color
    wgui.setpen("black")
    drawRect(0, 0, width, height)

    yorigin = yorigin + 1
    xorigin = xorigin + 1
    -- horizonal bar
    wgui.setfont(barSize / 2)
    local anaX, anaY = floor(lastInput.X / 256 * analogSize),
                       floor(-lastInput.Y / 256 * analogSize)
    wgui.setbrush("white")
    wgui.setpen("null")
    drawRect(0, 0, analogSize2, barSize + 1)
    wgui.setpen("red", 3)
    drawLine(1 + analogSize / 2 + anaX, 1, 0, barSize - 2)
    wgui.setbrush("null")
    wgui.setpen("black")
    setMouseCapture(mouseRect(0, 0, analogSize2, barSize + 1), function(x)
        lastInput.X = floor(range(x / (analogSize2 + 1) * 256 - 128, -128, 127))
        inputFlag.X = true
    end)
    -- vertical bar
    wgui.setbrush("white")
    wgui.setpen("null")
    drawRect(analogSize2, barSize, barSize, analogSize2)
    wgui.setpen("red", 3)
    drawLine(analogSize2 + 1, barSize + analogSize / 2 + anaY, barSize - 2, 0)
    wgui.setbrush("null")
    wgui.setpen("black")
    setMouseCapture(mouseRect(analogSize2, barSize, barSize + 1, analogSize2),
                    function(_, y)
        lastInput.Y = floor(range(-(y / (analogSize2 + 1) * 256 - 128), -128,
                                  127))
        inputFlag.Y = true
    end)
    -- Zero/Inv button
    wgui.setbrush("white")
    wgui.setbk("null")
    if mouseRect(analogSize2 - 1, 0, barSize + 1, barSize + 1) then
        if cinp.leftclick then
            lastInput.X = 0
            lastInput.Y = 0
            inputFlag.X = true
            inputFlag.Y = true
            tasInputUpdateFlag = true
        end
        if cinp.rightclick then
            lastInput.X = range(-lastInput.X, -128, 127)
            lastInput.Y = range(-lastInput.Y, -128, 127)
            inputFlag.X = true
            inputFlag.Y = true
            tasInputUpdateFlag = true
        end
    end
    wgui.setfont((barSize + 1) * 0.6)
    drawText(analogSize2 - 1, 0, barSize + 1, barSize + 1, "0")

    yorigin = yorigin + barSize
    -- circle
    wgui.setbrush("null")
    setMouseCapture(mouseRect(0, 0, analogSize2, analogSize2), function(x, y)
        lastInput.X = floor(range(x / (analogSize2 + 1) * 256 - 128, -128, 127))
        lastInput.Y = floor(range(-(y / (analogSize2 + 1) * 256 - 128), -128,
                                  127))
        inputFlag.X = true
        inputFlag.Y = true
    end)
    wgui.setbrush("white")
    drawEllipse(0, 0, analogSize2, analogSize2)
    drawLine(1, analogSize / 2, analogSize, 0)
    drawLine(1 + analogSize / 2, 1, 0, analogSize)
    -- LineTo�ł͏I�[�͕`�悳��Ȃ�((0,0)-(0,2)�Ȃ�[(0,0),(0,1)]�̂ݕ`�悳���)
    wgui.setpen("blue", 3)
    drawLine(1 + analogSize / 2, 1 + analogSize / 2 - 1, anaX, anaY)
    wgui.setpen("red", 5)
    drawLine(1 + analogSize / 2 + anaX, 1 + analogSize / 2 - 1 + anaY, 0, 0)

    yorigin = yorigin + analogSize2 - 1 + 2
    -- buttons
    wgui.setpen("black")
    wgui.setbk("null")

    for i, o in pairs(btns) do
        local f = lastInput[i] and not o.c
        wgui.setbrush(f and (inputFlagColor[inputFlag[i] or false]) or
                          inputFlag[i] == 2 and "#FF8080" or "white")
        if mouseRect(2 + o.x, o.y, o.w + 1, o.h + 1, 1) then
            if i == "X" or i == "Y" then
                if cinp.leftclick then
                    local s = input.prompt("analog " .. i)
                    lastInput[i] = floor(
                                       range(tonumber(s) or lastInput[i], -128,
                                             127))
                    inputFlag[i] = true
                    tasInputUpdateFlag = true
                end
                --[[
				local d = 1
				if inp.control then
					d = 5
				end
				if cinp.leftclick then
					lastInput[i] = floor(range(lastInput[i]+d,-128,127))
					inputFlag[i] = true
					tasInputUpdateFlag = true
				end
				if cinp.rightclick then
					lastInput[i] = floor(range(lastInput[i]-d,-128,127))
					inputFlag[i] = true
					tasInputUpdateFlag = true
				end
]]
            elseif string.sub(i, 1, 1) == "M" then
                local n = tonumber(string.sub(i, 2, -1))
                if not macros[n] then macros[n] = {} end
                local m = macros[n]
                if cinp.leftclick then
                    m.e = not m.e
                    m.c = 0
                    inputFlag[i] = m.e and 3 or false
                    lastInput[i] = m.e
                    tasInputUpdateFlag = true
                elseif cinp.rightclick then
                    local s = input.prompt("script", m.s)
                    if s then
                        local f, err = loadstring(m.s)
                        if f then
                            m.s = s
                            m.f = f
                            m.e = false
                            inputFlag[i] = false
                            lastInput[i] = false
                            tasInputUpdateFlag = true
                        else
                            print("error script: " .. err)
                        end
                    end
                end
            else
                if cinp.leftclick then
                    if not inp.control then
                        if lastInput[i] then
                            inputFlag[i] = false
                        else
                            inputFlag[i] = 1
                        end
                        lastInput[i] = not lastInput[i]
                        tasInputUpdateFlag = true
                    else
                        if inputFlag[i] == 2 then
                            lastInput[i] = false
                            inputFlag[i] = false
                        else
                            lastInput[i] = false
                            inputFlag[i] = 2
                            inputCount[i] = 0
                        end
                        tasInputUpdateFlag = true
                    end
                elseif cinp.rightclick then
                    lastInput[i] = true
                    inputFlag[i] = 0
                    tasInputUpdateFlag = true
                end
            end
        end
        wgui.setfont(o.f, "MS Gothic", #o.s == 1 and "b" or "")
        wgui.setcolor(f and "white" or "black")
        drawText(2 + o.x + 2, o.y + 3, o.w + 1 - 4, o.h + 1 - 4,
                 string.format(o.s, lastInput[i]))
    end

end
emu.atinput(tasInputUpdate)
emu.atwindowmessage(function(_, m)
    if 0x0200 <= m and m <= 0x020E then
        if m ~= 0x200 then tasInputUpdate() end
        updateMouseCapture()
        while tasInputUpdateFlag do
            tasInputUpdateFlag = false
            forceRedraw = true
            tasInputUpdate()
        end
    elseif m == 0x000F then
        forceRedraw = true
        tasInputUpdate()
    end
end)
emu.atinterval(function()
    updateMouseCapture()
    while tasInputUpdateFlag do
        tasInputUpdateFlag = false
        tasInputUpdate()
    end
end)

emu.atinput(function()
    orgInput = joypad.get()
    for i, o in pairs(orgInput) do
        lastInput[i] = inputFlag[i] and lastInput[i] or o
        if (i == "X" or i == "Y") then
            if o ~= 0 then
                inputFlag.X = false
                inputFlag.Y = false
            end
        else
            if inputFlag[i] == 0 then
                inputFlag[i] = false
            elseif inputFlag[i] == 1 and o then
                inputFlag[i] = false
            elseif inputFlag[i] == 2 then
                lastInput[i] = inputCount[i] % 2 == 0
                inputCount[i] = inputCount[i] + 1
            end
        end
    end
    tasInputUpdate()
    for i, o in ipairs(macros) do
        if o.e then
            if o.f then
                local e, err = pcall(o.f, o, orgInput, lastInput)
                if not e then
                    print("script run error:" .. err)
                    o.e = false
                end
                o.c = o.c + 1
            end
        end
    end
    joypad.set(lastInput)
end)

emu.atinterval(function()
    if frameAdvance == 1 and emu.getpause() then emu.pause(true) end
end)
emu.atinput(function()
    if frameAdvance == 1 then
        emu.pause()
        frameAdvance = 0
    end
end)

