shared.hitman = {
    silent = {
        enabled = true,
        key = "c",
        prediction = 0,
        hitpart = "Head",
        mode = "sticky"
    },
    visuals = {
        snaplines = {
            enabled = true,
            position = "mouse",
            color = Color3.fromRGB(255, 255, 255),
            thickness = 1
        },
        targetinfo = {
            enabled = true,
            color = Color3.fromRGB(255, 200, 100),
            textcolor = Color3.fromRGB(255, 255, 255)
        }
    },
    checks = {
        knock = true,
        wall = true,
        protected = true 
    },
    misc = {
        desync = {
            enabled = false,
            mode = "Void",
            randomamount = 20
        },
        cframefly = {
            enabled = false,
            key = "t",
            speed = 350
        },
        fullauto = {
            enabled = true,
            delay = 0.01
        },
        strafe = {
            enabled = false,
            target = nil,
            mode = "Orbit",
            speed = 50,
            distance = 10,
            height = 2,
            randomamount = 10,
            visualize = false,
            visualizecolor = Color3.fromRGB(255, 255, 255),
            spoof = false
        }
    }
}

local _47 = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local _48 = loadstring(game:HttpGet(_47 .. 'Library.lua'))()
local _49 = loadstring(game:HttpGet(_47 .. 'addons/ThemeManager.lua'))()
local _50 = loadstring(game:HttpGet(_47 .. 'addons/SaveManager.lua'))()

local _51 = game:GetService("Players")

-- LPH_NO_VIRTUALIZE macro for Luraph obfuscation optimization
pcall(function()
    loadstring([[
        function LPH_NO_VIRTUALIZE(f) return f end;
    ]])();
end)


local _52 = game:GetService("RunService")
local _53 = game:GetService("Workspace")
local _54 = game:GetService("UserInputService")
local _55 = game:GetService("ReplicatedStorage")

local _56 = _51.LocalPlayer
if not _56 then
    repeat wait() until _51.LocalPlayer
    _56 = _51.LocalPlayer
end

local _57 = _56:GetMouse()
local _58 = _53.CurrentCamera

local _59 = _48:CreateWindow({
    Title = '                              hitman',
    Center = true,
    AutoShow = true,
    TabPadding = 2,
    MenuFadeTime = 0.2
})

local _60 = {
    Main = _59:AddTab('main'),
    ['UI Settings'] = _59:AddTab('UI Settings'),
}

local _61 = _60.Main:AddLeftTabbox()
local _62 = _61:AddTab('main')

local _63 = _62:AddToggle('Enabled', {
    Text = 'enabled',
    Default = false,
})

local _64 = _63:AddKeyPicker('EnabledKeybind', {
    Default = 'C',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'keybind',
    NoUI = false
})

local _65 = _62:AddDropdown('Mode', {
    Values = { 'sticky', 'auto select', 'target all' },
    Default = 1,
    Text = 'mode',
})

_62:AddToggle('ManipulatedText', {
    Text = 'manipulated text',
    Default = false,
})

_62:AddToggle('TargetInfo', {
    Text = 'target info',
    Default = false,
})

local _66 = _60.Main:AddLeftTabbox()
local _67 = _66:AddTab('target')

local _68 = _67:AddToggle('Spectate', {
    Text = 'spectate',
    Default = false,
})

local _69 = _67:AddToggle('Highlight', {
    Text = 'highlight',
    Default = false,
})

local _70 = _69:AddColorPicker('HighlightFillColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'highlight fill color',
    Transparency = 0.5
})

local _71 = _69:AddColorPicker('HighlightOutlineColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'highlight outline color',
    Transparency = 0
})

local _72 = _67:AddToggle('Line', {
    Text = 'line',
    Default = false,
})

local _73 = _72:AddColorPicker('LineColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'line color',
    Transparency = 1
})


local _74 = _67:AddToggle('AutoShoot', {
    Text = 'auto shoot',
    Default = false,
})

-- Target Player Dropdown
local _ManualTarget = nil
local _TargetDropdownRefreshConn = nil

local function _GetPlayerNames()
    local names = { 'No One' }
    for _, player in ipairs(_51:GetPlayers()) do
        if player ~= _56 then
            table.insert(names, player.Name)
        end
    end
    return names
end

local _TargetDropdown = _67:AddDropdown('TargetPlayer', {
    Values = _GetPlayerNames(),
    Default = 1,
    Text = 'target player',
})

local function _RefreshTargetDropdown()
    local current = Options.TargetPlayer.Value
    local names = _GetPlayerNames()

    Options.TargetPlayer:SetValues(names)

    if current and current ~= 'No One' then
        local stillHere = false
        for _, name in ipairs(names) do
            if name == current then
                stillHere = true
                break
            end
        end
        if not stillHere then
            Options.TargetPlayer:SetValue('No One')
            _ManualTarget = nil
        end
    end
end

_TargetDropdownRefreshConn = _51.PlayerAdded:Connect(_RefreshTargetDropdown)
_51.PlayerRemoving:Connect(function(removed)
    if _ManualTarget == removed then
        _ManualTarget = nil
    end
    _RefreshTargetDropdown()
end)

task.spawn(function()
    task.wait(1)
    _RefreshTargetDropdown()
end)



local _StompToggle = _67:AddToggle('AutoStomp', {
    Text = 'auto stomp',
    Default = false,
})

local _StompSpinToggle = _67:AddToggle('StompSpin', {
    Text = 'spin',
    Default = false,
})

local _StompSpinSpeed = _67:AddSlider('StompSpinSpeed', {
    Text = 'spin speed',
    Default = 200,
    Min = 1,
    Max = 1000,
    Rounding = 0,
})



local _75 = _60.Main:AddLeftTabbox()
local _76 = _75:AddTab('checks')

_76:AddToggle('KnockCheck', {
    Text = 'knock check',
    Default = true,
})

_76:AddToggle('ProtectedCheck', {
    Text = 'protected check',
    Default = true,
})



-- ============================================
-- BUY GROUPBOX
-- ============================================

local _BuyBox = _60.Main:AddRightGroupbox('buy')

local _ArmorToggle = _BuyBox:AddToggle('AutoArmor', {
    Text = 'auto armor',
    Default = false,
})

_ArmorToggle:AddKeyPicker('AutoArmorKeybind', {
    Default = 'V',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'keybind',
    NoUI = false
})

-- ============================================
-- STRAFE GROUPBOX
-- ============================================

local _StrafeBox = _60.Main:AddRightGroupbox('strafe')

local _StrafeToggle = _StrafeBox:AddToggle('TargetStrafe', {
    Text = 'target strafe',
    Default = false,
})

-- Target dropdown for strafe (server players only)
local _StrafeTargetDropdown = _StrafeBox:AddDropdown('StrafeTarget', {
    Values = _GetPlayerNames(),
    Default = 1,
    Text = 'target',
})

local function _RefreshStrafeTargetDropdown()
    local current = Options.StrafeTarget.Value
    local names = _GetPlayerNames()
    Options.StrafeTarget:SetValues(names)
    if current and current ~= 'No One' then
        local stillHere = false
        for _, name in ipairs(names) do
            if name == current then
                stillHere = true
                break
            end
        end
        if not stillHere then
            Options.StrafeTarget:SetValue('No One')
            shared.hitman.misc.strafe.target = nil
        end
    end
end

_51.PlayerAdded:Connect(_RefreshStrafeTargetDropdown)
_51.PlayerRemoving:Connect(function(removed)
    if shared.hitman.misc.strafe.target == removed then
        shared.hitman.misc.strafe.target = nil
        Options.StrafeTarget:SetValue('No One')
    end
    _RefreshStrafeTargetDropdown()
end)

task.spawn(function()
    task.wait(1.1)
    _RefreshStrafeTargetDropdown()
end)

_StrafeBox:AddDropdown('StrafeMode', {
    Values = { 'Orbit', 'Circle', 'Random' },
    Default = 1,
    Text = 'mode',
})

_StrafeBox:AddSlider('StrafeSpeed', {
    Text = 'speed',
    Default = 50,
    Min = 10,
    Max = 150,
    Rounding = 0,
})

_StrafeBox:AddSlider('StrafeDistance', {
    Text = 'distance',
    Default = 10,
    Min = 2,
    Max = 50,
    Rounding = 1,
})

_StrafeBox:AddSlider('StrafeHeight', {
    Text = 'height',
    Default = 2,
    Min = -10,
    Max = 20,
    Rounding = 1,
})

_StrafeBox:AddSlider('StrafeRandom', {
    Text = 'random amount',
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 0,
})

local _StrafeVizToggle = _StrafeBox:AddToggle('StrafeVisualize', {
    Text = 'visualize',
    Default = false,
})

_StrafeVizToggle:AddColorPicker('StrafeVizColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'visualize color',
    Transparency = 0
})

_StrafeBox:AddToggle('StrafeSpoof', {
    Text = 'spoof',
    Default = false,
})



local _77 = _60.Main:AddRightTabbox()
local _78 = _77:AddTab('misc')

local _79 = _78:AddToggle('Desync', {
    Text = 'desync',
    Default = false,
})

_78:AddDropdown('DesyncMode', {
    Values = { 'Void', 'Void Spam' },
    Default = 1,
    Text = 'desync mode',
})

_78:AddSlider('DesyncRandom', {
    Text = 'random amount',
    Default = 20,
    Min = 5,
    Max = 100,
    Rounding = 0,
})

local _247 = _78:AddToggle('CFrameFly', {
    Text = 'cframe fly',
    Default = false,
})

_247:AddKeyPicker('CFrameFlyKeybind', {
    Default = 'T',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'keybind',
    NoUI = false
})

_78:AddSlider('FlySpeed', {
    Text = 'fly speed',
    Default = 350,
    Min = 50,
    Max = 500,
    Rounding = 0,
})

local _81 = _60.Main:AddRightTabbox()
local _82 = _81:AddTab('server finder')

local function _83(tab)
    tab:AddInput('UserIdInput', {
        Default = '',
        Numeric = true,
        Text = 'user id',
        Placeholder = '123456789'
    })

    local _84 = tab:AddLabel('server: not found')
    local _85 = tab:AddLabel('region: not found')

    local function _86()
        local _87 = Options.UserIdInput.Value
        if _87 == "" then 
            _84:SetText('server: not found')
            _85:SetText('region: not found')
            return 
        end

        local _88 = game:GetService("ReplicatedStorage"):FindFirstChild("Servers")
        if not _88 then
            _84:SetText('server: no servers folder')
            _85:SetText('region: n/a')
            return
        end

        local _89 = tostring(_87)
        local _90 = "not found"
        local _91 = "not found"

        for _, _92 in ipairs(_88:GetChildren()) do
            if _92:IsA("IntValue") then
                local _93 = _92:GetAttributes()

                if _93 then
                    local _94 = _93.players

                    if _94 and string.find(tostring(_94), _89) then
                        _90 = _93.name or "unknown"
                        _91 = _93.region or "n/a"
                        if setclipboard then
                            setclipboard(_90)
                        end
                        break
                    end
                end
            end
        end

        _84:SetText('server: ' .. _90)
        _85:SetText('region: ' .. _91)
    end

    Options.UserIdInput:OnChanged(function()
        _86()
    end)

    task.spawn(function()
        task.wait(0.5)
        _86()
    end)

    return {
        Update = _86
    }
end

local _95 = _83(_82)

local _96 = _60['UI Settings']:AddLeftGroupbox('Menu')
_96:AddButton('Unload', function() _48:Unload() end)
_96:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

_48.ToggleKeybind = Options.MenuKeybind

_49:SetLibrary(_48)
_50:SetLibrary(_48)
_50:IgnoreThemeSettings()
_50:SetIgnoreIndexes({ 'MenuKeybind' })
_49:SetFolder('MyScriptHub')
_50:SetFolder('MyScriptHub/specific-game')
_50:BuildConfigSection(_60['UI Settings'])
_49:ApplyToTab(_60['UI Settings'])
_50:LoadAutoloadConfig()

print("[DEBUG] Initializing feature logic...")



local _39 = 0
local _40, _ = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TheRealXORA/Roblox/refs/heads/Main/Scripts%20/Anti-Cheats%20Bypassers%20/Adonis.luau", true))()
end)

local _42; _42 = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(...)
    if checkcaller() then return _42(...) end
    local _43 = {...}
    local self = _43[1]
    local _44 = getnamecallmethod()

    if _44 == "FireServer" and self.Name == "MainRemoteEvent" then
        if _43[2] == "Detection" then
            return coroutine.yield()
        elseif _43[2] == "StompXD" then
            _43[3] = true
            return _42(unpack(_43))
        end
    end

    return _42(...)
end))

wait(1)

local _45 = {
    ["[Revolver]"] = true,
    ["[Double-Barrel SG]"] = true,
    ["[TacticalShotgun]"] = true
}

local _46 = nil
_46 = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(s, ...)
    if getnamecallmethod() == "FireServer" then
        local p = s.Parent
        if p then
            local n = p.Name
            if _45[n] then
                local a = {...}
                if type(a[1]) == "string" and a[1]:lower() == "shoot" then
                    return nil
                end
            end
        end
    end
    return _46(s, ...)
end))

wait(1)

task.wait(1)

setfflag("DebugRunParallelLuaOnMainThread", "true")

local _97 = {}
local _98 = {}

local _104 = {
    enabled = false,
    active = false,
    targetplayer = nil,
    targetpart = nil,
    targetposition = nil,
    keybind = "c",
    hitchance = 100,
    hitpart = "Head",
    lasthealth = {},
    wasknocked = {},
    mode = "sticky",
    autoshoot = false,
    currentmode = "sticky",
    picktime = nil
}

local _105 = false
local _106 = nil
local _107 = nil
local _108 = nil
local _109 = nil
local _110 = nil
local _111 = nil
local _112 = 0
local _113 = 0.1

local _114 = {}
local _115 = {}
local _116 = false
local _117 = false

local _118 = false
local _119 = nil
local _120 = nil
local _121 = nil

local _122 = false
local _123 = shared.hitman.misc.fullauto.delay
local _124 = false
local _125
local _126

local _127 = game:GetService("SoundService")

local _128 = _54.TouchEnabled
local _129 = _54.GamepadEnabled
local _130 = not _128 and not _129

if _128 or _129 then
    shared.hitman.visuals.snaplines.position = "center"
end

local _131 = Instance.new("Sound")
_131.SoundId = "rbxassetid://6534948092"
_131.Volume = 0.5
_131.Parent = _127

local _132 = Instance.new("Sound")
_132.SoundId = "rbxassetid://1255040462"
_132.Volume = 1.0
_132.Parent = _127

local _133 = Instance.new("ScreenGui")
_133.Name = "targetbob"
_133.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_133.DisplayOrder = 9999

if syn and syn.protect_gui then
    syn.protect_gui(_133)
    _133.Parent = game.CoreGui
elseif gethui then
    _133.Parent = gethui()
else
    _133.Parent = game.CoreGui
end

local _134 = Instance.new("TextLabel")
_134.Name = "putthatback"
_134.Parent = _133
_134.BackgroundTransparency = 1
_134.Size = UDim2.new(0, 120, 0, 18)
_134.Text = "manipulated!"
_134.Visible = false
_134.Position = UDim2.new(0, 0, 0, 0)
_134.TextXAlignment = Enum.TextXAlignment.Left
_134.TextYAlignment = Enum.TextYAlignment.Top
_134.Font = Enum.Font.Code
_134.TextColor3 = Color3.fromRGB(255, 255, 255)
_134.TextSize = 13
_134.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
_134.TextStrokeTransparency = 0

local _135 = Instance.new("TextLabel")
_135.Name = "targetskid"
_135.Parent = _133
_135.BackgroundTransparency = 1
_135.Size = UDim2.new(0, 150, 0, 16)
_135.Text = ""
_135.Visible = false
_135.Position = UDim2.new(0, 0, 0, 0)
_135.TextXAlignment = Enum.TextXAlignment.Left
_135.TextYAlignment = Enum.TextYAlignment.Top
_135.Font = Enum.Font.Code
_135.TextColor3 = Color3.fromRGB(255, 200, 100)
_135.TextSize = 11
_135.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
_135.TextStrokeTransparency = 0

local _136 = {}
local _137 = {}

local function _138()
    for i, _139 in ipairs(_136) do
        _139:Remove()
    end
    for i, _140 in ipairs(_137) do
        _140:Remove()
    end
    _136 = {}
    _137 = {}
end

_138()



local function _141()
    if not _130 then return end

    local _142 = _54:GetMouseLocation()
    if Toggles.ManipulatedText.Value and _134.Visible then
        _134.Position = UDim2.new(0, _142.X + 10, 0, _142.Y + 10)
    end
    if Toggles.TargetInfo.Value and _135.Visible then
        _135.Position = UDim2.new(0, _142.X + 10, 0, _142.Y + 30)
    end
end

local function _143()
    local _144 = _56.Character
    if _144 then
        for _, _145 in ipairs(_144:GetChildren()) do
            if _145:IsA("Tool") and _145:FindFirstChild("Ammo") then
                _55.MainEvent:FireServer("Reload", _145)
            end
        end
    end
end

local function _146()
    local _144 = _56.Character
    if _144 then
        for _, _145 in ipairs(_144:GetChildren()) do
            if _145:IsA("Tool") then
                _145.Parent = _56.Backpack
            end
        end
    end
end

-- ============================================
-- DESYNC SYSTEM (from Vearware - Void & Void Spam only)
-- ============================================

local BodyCloneDesync = nil
local BodyCloneDesyncHighlight = nil
local GlowLight = nil
local desync_setback = nil

function SetupDesyncVisuals()
    if BodyCloneDesync then BodyCloneDesync:Destroy() end

    BodyCloneDesync = game:GetObjects('rbxassetid://8246626421')[1]
    BodyCloneDesync.Parent = workspace
    BodyCloneDesync.Humanoid:Destroy()
    BodyCloneDesync.Head.Face:Destroy()

    for _, v in pairs(BodyCloneDesync:GetDescendants()) do
        if v:IsA('BasePart') or v:IsA('MeshPart') then
            v.CanCollide = false
            v.Transparency = 0
        end
    end

    BodyCloneDesync.HumanoidRootPart.Transparency = 0.5
    BodyCloneDesync.HumanoidRootPart.Velocity = Vector3.zero
    BodyCloneDesync.HumanoidRootPart.CFrame = CFrame.new(9999, 9999, 9999)

    BodyCloneDesyncHighlight = Instance.new('Highlight')
    BodyCloneDesyncHighlight.Enabled = false
    BodyCloneDesyncHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    BodyCloneDesyncHighlight.FillColor = Color3.fromRGB(0, 255, 0)
    BodyCloneDesyncHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    BodyCloneDesyncHighlight.FillTransparency = 0.3
    BodyCloneDesyncHighlight.OutlineTransparency = 0
    BodyCloneDesyncHighlight.Adornee = BodyCloneDesync
    BodyCloneDesyncHighlight.Parent = BodyCloneDesync

    GlowLight = Instance.new('PointLight')
    GlowLight.Color = Color3.fromRGB(0, 255, 100)
    GlowLight.Brightness = 4
    GlowLight.Range = 2
    GlowLight.Parent = BodyCloneDesync.HumanoidRootPart

    desync_setback = Instance.new('Part')
    desync_setback.Name = 'DesyncSetback'
    desync_setback.Size = Vector3.new(2, 2, 1)
    desync_setback.CanCollide = false
    desync_setback.Anchored = true
    desync_setback.Transparency = 1
    desync_setback.Parent = workspace
end

function ResetDesyncCamera()
    if _56.Character then
        _58.CameraSubject = _56.Character:FindFirstChild('Humanoid')
    end
end

function DestroyDesyncVisuals()
    if BodyCloneDesync then
        BodyCloneDesync:Destroy()
        BodyCloneDesync = nil
    end
    if BodyCloneDesyncHighlight then
        BodyCloneDesyncHighlight:Destroy()
        BodyCloneDesyncHighlight = nil
    end
    if GlowLight then
        GlowLight:Destroy()
        GlowLight = nil
    end
    if desync_setback then
        desync_setback:Destroy()
        desync_setback = nil
    end
end

-- ============================================
-- CFRAME FLY (preserved from original)
-- ============================================

local _243 = { enabled = false, master = false, keys = {}, connection = nil }
local _246 = {}
local _248 = nil
local _254 = nil
local _255 = nil

local function _244()
    if not _243.enabled then return end
    local _144 = _56.Character
    if not _144 then return end
    local _148 = _144:FindFirstChildOfClass("Humanoid")
    local _120 = _144:FindFirstChild("HumanoidRootPart")
    if not _148 or not _120 then return end

    _148:ChangeState(Enum.HumanoidStateType.Freefall)
    local _249 = Vector3.zero
    local _58 = workspace.CurrentCamera

    if _243.keys[Enum.KeyCode.W] then _249 = _249 + _58.CFrame.LookVector end
    if _243.keys[Enum.KeyCode.S] then _249 = _249 - _58.CFrame.LookVector end
    if _243.keys[Enum.KeyCode.A] then _249 = _249 - _58.CFrame.RightVector end
    if _243.keys[Enum.KeyCode.D] then _249 = _249 + _58.CFrame.RightVector end
    if _243.keys[Enum.KeyCode.Space] then _249 = _249 + Vector3.new(0, 1, 0) end
    if _243.keys[Enum.KeyCode.LeftControl] then _249 = _249 - Vector3.new(0, 1, 0) end

    if _249.Magnitude > 0 then _249 = _249.Unit end
    _120.AssemblyLinearVelocity = _249 * Options.FlySpeed.Value
end

local function _245()
    local master = Toggles.CFrameFly.Value
    local active = Options.CFrameFlyKeybind:GetState()
    _243.enabled = master and active

    if _243.enabled then
        if not _243.connection then 
            _243.connection = _52.RenderStepped:Connect(function() _244() end) 
        end
    else
        if _243.connection then 
            _243.connection:Disconnect() 
            _243.connection = nil 
            local _144 = _56.Character
            if _144 then
                local _148 = _144:FindFirstChildOfClass("Humanoid")
                if _148 then _148:ChangeState(Enum.HumanoidStateType.GettingUp) end
            end
        end
    end
end

_254 = _54.InputBegan:Connect(function(_252, _253)
    if _253 then return end
    _243.keys[_252.KeyCode] = true
end)

_255 = _54.InputEnded:Connect(function(_252)
    _243.keys[_252.KeyCode] = false
end)



local function _149()
    if _105 then return end
    if not _104.active then return end
    if _104.mode == "auto select" or _104.mode == "target all" then return end
    if not _104.targetplayer then return end

    _105 = true
    _109 = _104.targetplayer
    _111 = _104.targetplayer

    _110 = _58.CameraSubject

    if _109 and _109.Character then
        _58.CameraSubject = _109.Character

        if _107 then
            _107:Disconnect()
        end

        _107 = _109.CharacterAdded:Connect(function(_144)
            task.wait(1)
            if _105 and _109 == _104.targetplayer then
                _58.CameraSubject = _144
            end
        end)
    end

    if _108 then
        _108:Disconnect()
    end

    _108 = _56.CharacterAdded:Connect(function(_144)
        task.wait(1)
        if _105 and _109 and _109.Character then
            _58.CameraSubject = _109.Character
        end
    end)

    _112 = tick()
end

local function _150()
    _105 = false
    _109 = nil
    _111 = nil

    if _106 then
        _106:Disconnect()
        _106 = nil
    end

    if _107 then
        _107:Disconnect()
        _107 = nil
    end

    if _108 then
        _108:Disconnect()
        _108 = nil
    end

    if _56.Character then
        _58.CameraSubject = _56.Character
    elseif _110 then
        _58.CameraSubject = _110
    end
end

local function _151()
    if not _105 then return end
    if not _109 then return end

    local _152 = tick()
    if _152 - _112 < _113 then
        return
    end

    _112 = _152

    if _109 and _109.Character then
        _58.CameraSubject = _109.Character
    elseif _105 and _56.Character then
        _58.CameraSubject = _56.Character
    end
end

local function _153(_154)
    if not _154 or not _154.Character then return nil end

    local _155 = Options.HighlightFillColor.Value
    local _156 = Options.HighlightOutlineColor.Value
    local _157 = Options.HighlightFillColor.Transparency
    local _158 = Options.HighlightOutlineColor.Transparency

    local _159 = Instance.new("Highlight")
    _159.Name = "TargetHighlight_" .. _154.Name
    _159.FillColor = _155
    _159.OutlineColor = _156
    _159.FillTransparency = _157
    _159.OutlineTransparency = _158
    _159.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    _159.Parent = _154.Character

    local _160 = _154.CharacterAdded:Connect(function(_144)
        task.wait(1)
        if _159 and _159.Parent then
            _159.Parent = _144
        end
    end)

    return {highlight = _159, connection = _160}
end

local function _161()
    for _162, _163 in pairs(_114) do
        if _163.highlight then
            _163.highlight:Destroy()
        end
        if _163.connection then
            _163.connection:Disconnect()
        end
    end
    _114 = {}

    for _, _164 in pairs(_115) do
        _164:Disconnect()
    end
    _115 = {}
end

local function _165()
    if not Toggles.Highlight.Value then
        _161()
        return
    end

    if not _104.active then
        _161()
        return
    end

    if _104.mode == "target all" then
        local _166 = _51:GetPlayers()
        local _167 = {}

        for _, _154 in ipairs(_166) do
            if _154 == _56 then continue end
            if _39 > 0 and _154.UserId == _39 then continue end
            if _154 and _154.Character then
                local _162 = _154.Name
                if _114[_162] then
                    _167[_162] = _114[_162]
                    _114[_162] = nil
                else
                    local _163 = _153(_154)
                    if _163 then
                        _167[_162] = _163
                    end
                end
            end
        end

        for _162, _163 in pairs(_114) do
            if _163.highlight then
                _163.highlight:Destroy()
            end
            if _163.connection then
                _163.connection:Disconnect()
            end
        end

        _114 = _167
    elseif _104.mode == "auto select" then
        _161()

        if _104.targetplayer and _104.targetplayer.Character then
            if _39 > 0 and _104.targetplayer.UserId == _39 then
                return
            end
            local _162 = _104.targetplayer.Name
            local _163 = _153(_104.targetplayer)
            if _163 then
                _114[_162] = _163
            end
        end
    else
        _161()

        if _104.targetplayer and _104.targetplayer.Character then
            if _39 > 0 and _104.targetplayer.UserId == _39 then
                return
            end
            local _162 = _104.targetplayer.Name
            local _163 = _153(_104.targetplayer)
            if _163 then
                _114[_162] = _163
            end
        end
    end
end

local function _168(_169)
    if _169 and _130 then
        _141()
    end

    if Toggles.ManipulatedText.Value and _169 then
        _134.Visible = true
    else
        _134.Visible = false
    end

    if Toggles.TargetInfo.Value and _169 then
        _135.Visible = true
    else
        _135.Visible = false
    end
end

local function _170()
    if _130 and shared.hitman.visuals.snaplines.position == "mouse" then
        return _54:GetMouseLocation()
    else
        local _171 = _58.ViewportSize
        return Vector2.new(_171.X / 2, _171.Y / 2)
    end
end

local function _172()
    local _144 = _56.Character
    if not _144 then return false end
    local _148 = _144:FindFirstChildOfClass("Humanoid")
    if not _148 or _148.Health <= 0 then return false end
    return true
end

local function _173()
    local _174 = {}
    local _175 = _51:GetPlayers()

    for _, _154 in ipairs(_175) do
        if _154 == _56 then continue end
        if _39 > 0 and _154.UserId == _39 then continue end
        table.insert(_174, _154)
    end

    return _174
end

local function _176()
    local _177 = {}
    local _175 = _51:GetPlayers()

    for _, _154 in ipairs(_175) do
        if _154 == _56 then continue end
        if _39 > 0 and _154.UserId == _39 then continue end
        if _154.Character then
            table.insert(_177, _154.Character)
        end
    end

    return _177
end

local function _178(_154)
    if not Toggles.ProtectedCheck.Value then return false end
    local _144 = _154.Character
    if _144 then
        local _179 = _144:FindFirstChildOfClass("ForceField")
        if _179 then
            return true
        end
    end
    return false
end

local function _180(_154)
    if not Toggles.KnockCheck.Value then return false end
    local _144 = _154.Character
    if _144 then
        local _181 = _144:FindFirstChild("BodyEffects")
        if _181 and _181:FindFirstChild("K.O") then
            return _181["K.O"].Value
        end
    end
    return false
end

local function _182(_154)
    if not _154 then return false end
    if _39 > 0 and _154.UserId == _39 then return false end
    local _144 = _154.Character
    if not _144 then return false end
    local _148 = _144:FindFirstChildOfClass("Humanoid")
    if not _148 or _148.Health <= 0 then return false end
    if _180(_154) then return false end
    if _178(_154) then return false end
    return true
end

local function _183(_184)
    local _185 = nil
    local _186 = math.huge

    for _, _154 in pairs(_51:GetPlayers()) do
        if _154 == _56 then continue end
        if _39 > 0 and _154.UserId == _39 then continue end
        if not _154.Character then continue end

        local _144 = _154.Character
        local _148 = _144:FindFirstChildOfClass("Humanoid")
        if not _148 or _148.Health <= 0 then continue end
        if _180(_154) then continue end
        if _178(_154) then continue end

        local _187 = _144:FindFirstChild("Head")
        if _187 then
            local _188, _189 = _58:WorldToScreenPoint(_187.Position)
            if _189 then
                local _190 = Vector2.new(_188.X, _188.Y)
                local _191 = (_184 - _190).Magnitude
                if _191 < _186 then
                    _186 = _191
                    _185 = _154
                end
            end
        end
    end
    return _185
end

local function _192()
    if _ManualTarget and _ManualTarget.Parent and _182(_ManualTarget) then
        return _ManualTarget
    end

    local _184
    if _130 then
        _184 = _54:GetMouseLocation()
    else
        local _171 = _58.ViewportSize
        _184 = Vector2.new(_171.X / 2, _171.Y / 2)
    end

    return _183(_184)
end

local function _193()
    _104.active = false
    _104.targetplayer = nil
    _104.targetpart = nil
    _104.targetposition = nil
    _168(false)

    for i, _139 in ipairs(_136) do
        _139.Visible = false
    end
    for i, _140 in ipairs(_137) do
        _140.Visible = false
    end

    if _105 then
        _150()
    end
    _161()
end

local function _194()
    if not _104.active then
        _135.Text = ""
        return
    end

    if _104.mode == "target all" then
        local _174 = _173()
        local _195 = 0
        for _, _154 in ipairs(_174) do
            if _182(_154) then
                _195 = _195 + 1
            end
        end
        if #_174 > 0 then
            _135.Text = string.format("everyone [%d/%d]", _195, #_174)
        else
            _135.Text = "no players"
        end
    elseif _104.targetplayer then
        local _154 = _104.targetplayer
        if not _154 then
            _135.Text = ""
            return
        end

        local _144 = _154.Character
        if _144 then
            local _148 = _144:FindFirstChildOfClass("Humanoid")
            if _148 and _148.Health > 0 and not _180(_154) and not _178(_154) then
                if not _180(_154) and _104.lasthealth[_154] then
                    local _196 = _104.lasthealth[_154]
                    if _148.Health < _196 then
                        _131:Play()
                    end
                end

                _104.lasthealth[_154] = _148.Health

                _135.Text = string.format("%s  %.0f/%.0f", 
                    _154.DisplayName, 
                    math.floor(_148.Health), 
                    math.floor(_148.MaxHealth)
                )
            else
                _135.Text = _154.DisplayName .. " (invalid)"
                _104.lasthealth[_154] = nil
                _104.wasknocked[_154] = nil
            end
        else
            _135.Text = _154.DisplayName .. " (no char)"
            _104.lasthealth[_154] = nil
            _104.wasknocked[_154] = nil
        end
    else
        _135.Text = ""
    end
end

local function _197()
    if not _104.enabled then return end

    if _104.active then
        _193()
    else
        if not _172() then return end

        if _104.mode == "target all" then
            local _174 = _173()
            if #_174 > 0 then
                _104.active = true
                _104.targetplayer = _174[1]
                if _174[1].Character then
                    _104.targetpart = _174[1].Character:FindFirstChild("Head")
                    if _104.targetpart then
                        _104.targetposition = _104.targetpart.Position
                    end
                    _104.wasknocked[_174[1]] = false

                    local _148 = _174[1].Character:FindFirstChildOfClass("Humanoid")
                    if _148 then
                        _104.lasthealth[_174[1]] = _148.Health
                    end
                end

                _168(true)
                _194()

                if Toggles.Highlight.Value then
                    _165()
                end

                if Toggles.Spectate.Value and _105 then
                    _150()
                end
            else
                _104.active = true
                _104.targetplayer = nil
                _104.targetpart = nil
                _104.targetposition = nil
                _168(false)
            end
        elseif _104.mode == "auto select" then
            local _185 = _192()
            if _185 and _182(_185) then
                _104.active = true
                _104.targetplayer = _185
                _104.targetpart = _185.Character:FindFirstChild("Head")
                _104.wasknocked[_185] = false

                if _104.targetpart then
                    _104.targetposition = _104.targetpart.Position
                end

                if _185.Character then
                    local _148 = _185.Character:FindFirstChildOfClass("Humanoid")
                    if _148 then
                        _104.lasthealth[_185] = _148.Health
                    end
                end

                _168(true)
                _194()

                if Toggles.Highlight.Value then
                    _165()
                end

                if Toggles.Spectate.Value and _105 then
                    _150()
                end
            else
                _104.active = true
                _104.targetplayer = nil
                _104.targetpart = nil
                _104.targetposition = nil
                _168(false)
            end
        else
            local _185 = _192()
            if _185 and _182(_185) then
                _104.active = true
                _104.targetplayer = _185
                _104.targetpart = _185.Character:FindFirstChild("Head")
                _104.wasknocked[_185] = false

                if _104.targetpart then
                    _104.targetposition = _104.targetpart.Position
                end

                if _185.Character then
                    local _148 = _185.Character:FindFirstChildOfClass("Humanoid")
                    if _148 then
                        _104.lasthealth[_185] = _148.Health
                    end
                end

                _168(true)
                _194()

                if Toggles.Highlight.Value then
                    _165()
                end

                if Toggles.Spectate.Value then
                    _149()
                end
            else
                _104.active = true
                _104.targetplayer = nil
                _104.targetpart = nil
                _104.targetposition = nil
                _168(false)
            end
        end
    end
end



local function _198()
    if not Toggles.Line.Value then
        for i, _139 in ipairs(_136) do
            _139.Visible = false
        end
        for i, _140 in ipairs(_137) do
            _140.Visible = false
        end
        return
    end

    if not _104.active then
        for i, _139 in ipairs(_136) do
            _139.Visible = false
        end
        for i, _140 in ipairs(_137) do
            _140.Visible = false
        end
        return
    end

    local _199 = _170()

    local _117 = Options.LineColor.Value
    local _200 = Options.LineColor.Transparency

    if _104.mode == "target all" then
        local _166 = _51:GetPlayers()

        while #_136 < #_166 do
            local _139 = Drawing.new("Line")
            _139.Color = _117
            _139.Thickness = shared.hitman.visuals.snaplines.thickness
            _139.Transparency = _200
            _139.Visible = false
            _139.ZIndex = 3
            table.insert(_136, _139)

            local _140 = Drawing.new("Line")
            _140.Color = Color3.new(0, 0, 0)
            _140.Thickness = shared.hitman.visuals.snaplines.thickness + 2
            _140.Transparency = _200
            _140.Visible = false
            _140.ZIndex = 2
            table.insert(_137, _140)
        end

        local _201 = 1
        for _, _154 in ipairs(_166) do
            if _154 == _56 then continue end
            if _39 > 0 and _154.UserId == _39 then continue end

            if _136[_201] and _137[_201] then
                local _144 = _154.Character
                if _144 then
                    local _202 = _144:FindFirstChild("HumanoidRootPart")
                    if _202 then
                        local _203, _204 = _58:WorldToViewportPoint(_202.Position)

                        if _204 then
                            _136[_201].From = _199
                            _136[_201].To = Vector2.new(_203.X, _203.Y)
                            _136[_201].Visible = true

                            _137[_201].From = _199
                            _137[_201].To = Vector2.new(_203.X, _203.Y)
                            _137[_201].Visible = true
                        else
                            _136[_201].Visible = false
                            _137[_201].Visible = false
                        end
                    else
                        _136[_201].Visible = false
                        _137[_201].Visible = false
                    end
                else
                    _136[_201].Visible = false
                    _137[_201].Visible = false
                end
            end
            _201 = _201 + 1
        end

        for i = _201, #_136 do
            if _136[i] then _136[i].Visible = false end
            if _137[i] then _137[i].Visible = false end
        end
    elseif _104.mode == "auto select" then
        for i, _139 in ipairs(_136) do
            _139.Visible = false
        end
        for i, _140 in ipairs(_137) do
            _140.Visible = false
        end

        if _104.targetplayer then
            local _144 = _104.targetplayer.Character
            if not _144 then return end

            local _202 = _144:FindFirstChild("HumanoidRootPart")
            if _202 then
                local _203, _204 = _58:WorldToViewportPoint(_202.Position)

                if _204 then
                    if #_136 < 1 then
                        local _139 = Drawing.new("Line")
                        _139.Color = _117
                        _139.Thickness = shared.hitman.visuals.snaplines.thickness
                        _139.Transparency = _200
                        _139.Visible = true
                        _139.ZIndex = 3
                        table.insert(_136, _139)

                        local _140 = Drawing.new("Line")
                        _140.Color = Color3.new(0, 0, 0)
                        _140.Thickness = shared.hitman.visuals.snaplines.thickness + 2
                        _140.Transparency = _200
                        _140.Visible = true
                        _140.ZIndex = 2
                        table.insert(_137, _140)
                    end

                    _136[1].From = _199
                    _136[1].To = Vector2.new(_203.X, _203.Y)
                    _136[1].Visible = true

                    _137[1].From = _199
                    _137[1].To = Vector2.new(_203.X, _203.Y)
                    _137[1].Visible = true
                else
                    if _136[1] then _136[1].Visible = false end
                    if _137[1] then _137[1].Visible = false end
                end
            else
                if _136[1] then _136[1].Visible = false end
                if _137[1] then _137[1].Visible = false end
            end
        end
    else
        for i, _139 in ipairs(_136) do
            _139.Visible = false
        end
        for i, _140 in ipairs(_137) do
            _140.Visible = false
        end

        if _104.targetplayer then
            local _144 = _104.targetplayer.Character
            if not _144 then return end

            local _202 = _144:FindFirstChild("HumanoidRootPart")
            if _202 then
                local _203, _204 = _58:WorldToViewportPoint(_202.Position)

                if _204 then
                    if #_136 < 1 then
                        local _139 = Drawing.new("Line")
                        _139.Color = _117
                        _139.Thickness = shared.hitman.visuals.snaplines.thickness
                        _139.Transparency = _200
                        _139.Visible = true
                        _139.ZIndex = 3
                        table.insert(_136, _139)

                        local _140 = Drawing.new("Line")
                        _140.Color = Color3.new(0, 0, 0)
                        _140.Thickness = shared.hitman.visuals.snaplines.thickness + 2
                        _140.Transparency = _200
                        _140.Visible = true
                        _140.ZIndex = 2
                        table.insert(_137, _140)
                    end

                    _136[1].From = _199
                    _136[1].To = Vector2.new(_203.X, _203.Y)
                    _136[1].Visible = true

                    _137[1].From = _199
                    _137[1].To = Vector2.new(_203.X, _203.Y)
                    _137[1].Visible = true
                else
                    if _136[1] then _136[1].Visible = false end
                    if _137[1] then _137[1].Visible = false end
                end
            else
                if _136[1] then _136[1].Visible = false end
                if _137[1] then _137[1].Visible = false end
            end
        end
    end
end

local function _205()
    if not _104.active then return end

    if _104.mode == "auto select" then
        if _ManualTarget and _ManualTarget.Parent and _182(_ManualTarget) then
            if _104.targetplayer ~= _ManualTarget then
                _104.targetplayer = _ManualTarget
                _104.targetpart = _ManualTarget.Character:FindFirstChild("Head")
                _104.wasknocked[_ManualTarget] = false
                if _104.targetpart then
                    _104.targetposition = _104.targetpart.Position
                end
                local _148 = _ManualTarget.Character:FindFirstChildOfClass("Humanoid")
                if _148 then
                    _104.lasthealth[_ManualTarget] = _148.Health
                end
                _168(true)
                _194()
                if Toggles.Highlight.Value then
                    _165()
                end
                if Toggles.Spectate.Value and _105 then
                    _150()
                end
            else
                if _104.targetplayer.Character then
                    _104.targetpart = _104.targetplayer.Character:FindFirstChild("Head")
                    if _104.targetpart then
                        _104.targetposition = _104.targetpart.Position
                    end
                end
            end
        else
            local _184
            if _130 and shared.hitman.visuals.snaplines.position == "mouse" then
                _184 = _54:GetMouseLocation()
            else
                local _171 = _58.ViewportSize
                _184 = Vector2.new(_171.X / 2, _171.Y / 2)
            end

            local _185 = _183(_184)

            if _185 and _182(_185) then
                if _104.targetplayer ~= _185 then
                    _104.targetplayer = _185
                    _104.targetpart = _185.Character:FindFirstChild("Head")
                    _104.wasknocked[_185] = false

                    if _104.targetpart then
                        _104.targetposition = _104.targetpart.Position
                    end

                    if _185.Character then
                        local _148 = _185.Character:FindFirstChildOfClass("Humanoid")
                        if _148 then
                            _104.lasthealth[_185] = _148.Health
                        end
                    end

                    _168(true)
                    _194()

                    if Toggles.Highlight.Value then
                        _165()
                    end

                    if Toggles.Spectate.Value and _105 then
                        _150()
                    end
                else
                    if _104.targetplayer.Character then
                        _104.targetpart = _104.targetplayer.Character:FindFirstChild("Head")
                        if _104.targetpart then
                            _104.targetposition = _104.targetpart.Position
                        end
                    end
                end
            else
                _104.targetplayer = nil
                _104.targetpart = nil
                _104.targetposition = nil
                _168(false)

                if Toggles.Spectate.Value and _105 then
                    _150()
                end
            end
        end
    elseif _104.mode == "target all" then
        local _174 = _173()
        if #_174 > 0 then
            if _ManualTarget and _ManualTarget.Parent and _182(_ManualTarget) then
                _104.targetplayer = _ManualTarget
                _104.wasknocked[_ManualTarget] = false
                _104.picktime = tick()
            else
                if _104.targetplayer and not _104.picktime then
                    _104.picktime = tick()
                end

                if _104.targetplayer and _104.picktime and tick() - _104.picktime > 10 then
                    _104.targetplayer = nil
                    _104.picktime = nil
                end

                if not _104.targetplayer or not _182(_104.targetplayer) then
                    _104.targetplayer = _174[math.random(#_174)]
                    if _104.targetplayer then
                        _104.wasknocked[_104.targetplayer] = false
                        _104.picktime = tick()
                    end
                end
            end

            if _104.targetplayer and _104.targetplayer.Character then
                _104.targetpart = _104.targetplayer.Character:FindFirstChild("Head")
                if _104.targetpart then
                    _104.targetposition = _104.targetpart.Position
                end
            end

            _194()

            if Toggles.Highlight.Value then
                _165()
            end

            if Toggles.Spectate.Value and _105 then
                _150()
            end
        else
            _104.targetplayer = nil
            _104.targetpart = nil
            _104.targetposition = nil
            _168(false)

            _161()

            if Toggles.Spectate.Value and _105 then
                _150()
            end
        end
    else
        if _ManualTarget and _ManualTarget.Parent and _182(_ManualTarget) then
            if _104.targetplayer ~= _ManualTarget then
                _104.targetplayer = _ManualTarget
                _104.wasknocked[_ManualTarget] = false
                local _148 = _ManualTarget.Character:FindFirstChildOfClass("Humanoid")
                if _148 then
                    _104.lasthealth[_ManualTarget] = _148.Health
                end
                _168(true)
                _194()
                if Toggles.Highlight.Value then
                    _165()
                end
                if Toggles.Spectate.Value then
                    _149()
                end
            end
        end
        if _104.targetplayer and _104.targetplayer.Character then
            _104.targetpart = _104.targetplayer.Character:FindFirstChild("Head")
            if _104.targetpart then
                _104.targetposition = _104.targetpart.Position
            end
        end
    end
end

local function _206()
    if not _104.autoshoot then return end
    if not _104.active then return end

    local _145 = _56.Character and _56.Character:FindFirstChildOfClass("Tool")
    if not _145 then return end

    local _207 = _145:FindFirstChild("Ammo")
    if _207 and _207.Value <= 0 then return end

    if _104.mode == "target all" then
        local _174 = _173()
        if #_174 == 0 then return end

        local _208 = false
        for _, _154 in ipairs(_174) do
            if _182(_154) then
                _208 = true
                break
            end
        end

        if _208 then
            _145:Activate()
            task.wait(0.1)
        end
    else
        if not _104.targetplayer then return end
        if not _182(_104.targetplayer) then return end

        _145:Activate()
        task.wait(0.1)
    end
end

local _209 = {}
_209.getgun = function()
    if not _56.Character then return nil end
    for _, _145 in next, _56.Character:GetChildren() do
        if _145:IsA("Tool") and _145:FindFirstChild("Ammo") then 
            return _145 
        end
    end
    return nil
end

_209.rapid = function(_145)
    if _145 and _145:IsA("Tool") then
        _145:Activate()
    end
end

local function _210()
    if _125 then
        _125:Disconnect()
    end
    if _126 then
        _126:Disconnect()
    end

    _125 = _54.InputBegan:Connect(function(i)
        if (_130 and i.UserInputType == Enum.UserInputType.MouseButton1) or
           (_128 and i.UserInputType == Enum.UserInputType.Touch) then
            local _211 = _209.getgun()
            if _122 and _211 and not _124 then
                _124 = true
                task.spawn(function()
                    while _124 and _122 do
                        if _56.Character and _56.Character:FindFirstChildOfClass("Humanoid") then
                            if _56.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                                _209.rapid(_211)
                                task.wait(_123)
                            else
                                _124 = false
                                break
                            end
                        else
                            _124 = false
                            break
                        end
                    end
                end)
            end
        end
    end)

    _126 = _54.InputEnded:Connect(function(input)
        if (_130 and input.UserInputType == Enum.UserInputType.MouseButton1) or
           (_128 and input.UserInputType == Enum.UserInputType.Touch) then
            _124 = false
        end
    end)
end

local function _215()
    local _213 = Options.EnabledKeybind.Value
    if _213 then
        local _214 = tostring(_213):lower():gsub("enum.keycode.", "")
        _104.keybind = _214
        shared.hitman.silent.key = _214
    end
end

_215()

Options.EnabledKeybind:OnChanged(function()
    _215()
end)

local function _216(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode[_104.keybind:upper()] then
        print("[DEBUG] Aim key pressed:", _104.keybind)
        _197()
    end
end

if _130 then
    _54.InputBegan:Connect(_216)
end

if _128 then
    local _218 = Instance.new("TextButton")
    _218.Name = "SkidCheese"
    _218.Parent = _133
    _218.Size = UDim2.new(0, 100, 0, 50)
    _218.Position = UDim2.new(1, -110, 1, -60)
    _218.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    _218.BackgroundTransparency = 0.5
    _218.Text = "Toggle Aim"
    _218.TextColor3 = Color3.fromRGB(255, 255, 255)
    _218.Visible = true

    local _219 = false
    local _220, _221, _222

    _218.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            _219 = true
            _221 = input.Position
            _222 = _218.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    _219 = false
                end
            end)
        end
    end)

    _218.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            _220 = input
        end
    end)

    _54.InputChanged:Connect(function(input)
        if _219 and input == _220 then
            local _223 = input.Position - _221
            _218.Position = UDim2.new(_222.X.Scale, _222.X.Offset + _223.X, _222.Y.Scale, _222.Y.Offset + _223.Y)
        end
    end)

    _218.Activated:Connect(function()
        print("[DEBUG] Mobile Aim button pressed")
        _197()
    end)
end

local _229; _229 = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(...)
    if checkcaller() then return _229(...) end
    local _230 = {...}
    local _231 = _230[1]
    local _44 = getnamecallmethod()

    if not _104.active then
        return _229(...)
    end

    if math.random(100) > _104.hitchance then
        return _229(...)
    end

    if _44:lower() == "raycast" and select(1, ...) == workspace then
        if _104.mode == "target all" then
            if _104.targetplayer and _104.targetpart then
                local _232 = _104.targetposition - _230[2]
                return {
                    Instance = _104.targetpart,
                    Position = _104.targetposition,
                    Normal = _232.Unit,
                    Distance = _232.Magnitude,
                    Material = _104.targetpart.Material
                }
            end
        elseif _104.targetposition then
            local _232 = _104.targetposition - _230[2]
            return {
                Instance = _104.targetpart,
                Position = _104.targetposition,
                Normal = _232.Unit,
                Distance = _232.Magnitude,
                Material = _104.targetpart.Material
            }
        end
    end

    return _229(...)
end))

if _130 then
    local _57 = _56:GetMouse()
    local _233 = getrawmetatable(game)
    local _234 = _233.__index
    setreadonly(_233, false)

    _233.__index = newcclosure(LPH_NO_VIRTUALIZE(function(self, key)
        if self == _57 and (key == "Hit" or key == "Target") then
            if _104.active and _104.mode == "target all" then
                if _104.targetplayer and _104.targetpart then
                    if key == "Hit" then
                        return CFrame.new(_104.targetposition)
                    elseif key == "Target" then
                        return _104.targetpart
                    end
                end
            elseif _104.active and _104.targetplayer and _104.targetposition then
                if key == "Hit" then
                    return CFrame.new(_104.targetposition)
                elseif key == "Target" and _104.targetpart then
                    return _104.targetpart
                end
            end
        end

        if self == _57 and (key == "X" or key == "Y") and _104.active then
            local _235
            if _104.mode == "target all" then
                if _104.targetplayer and _104.targetplayer.Character then
                    local _187 = _104.targetplayer.Character:FindFirstChild("Head")
                    if _187 then
                        _235 = _187.Position
                    end
                end
            elseif _104.targetposition then
                _235 = _104.targetposition
            end

            if _235 then
                local _236 = _58:WorldToViewportPoint(_235)
                return _236[key == "X" and "X" or "Y"]
            end
        end

        return _234(self, key)
    end))

    setreadonly(_233, true)
end



-- ============================================
-- PSALMS CSYNC SYSTEM (Ported to Hitman)
-- ============================================

-- CSync settings table (replaces strafe settings)
shared.hitman.misc.csync = {
    enabled = false,
    type = "Orbit",
    distance = 10,
    height = 2,
    speed = 10,
    randomamount = 10,
    color = Color3.fromRGB(255, 255, 255),
    visualize = false,
    spoof = false
}

-- Create setback part ONCE at script load (like Psalms does)
local _CSyncSetback = Instance.new("Part")
_CSyncSetback.Name = "CSyncSetback"
_CSyncSetback.Parent = workspace
_CSyncSetback.Size = Vector3.new(2, 2, 1)
_CSyncSetback.CanCollide = false
_CSyncSetback.Anchored = true
_CSyncSetback.Transparency = 1

-- Create IgnoreFolder for visualizer (like Psalms)
local _CSyncIgnoreFolder = Instance.new("Folder")
_CSyncIgnoreFolder.Name = "CSyncIgnore"
_CSyncIgnoreFolder.Parent = workspace

-- Create CFrame Visualizer (character clone like Psalms)
local _CSyncVizClone = nil
local _CSyncVizHighlight = nil

local function _CSyncCreateVisualizer()
    if _CSyncVizClone then return end
    if not _56.Character then return end

    local char = _56.Character
    char.Archivable = true
    local clone = char:Clone()
    char.Archivable = false
    clone.Name = "CSyncViz"

    -- Clean up clone (remove scripts, face, etc.)
    for _, v in pairs(clone:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("LuaSourceContainer") then
            v:Destroy()
        elseif v:IsA("BasePart") or v:IsA("MeshPart") then
            v.CanCollide = false
            v.Transparency = 0.70
            v.Material = Enum.Material.ForceField
            v.Color = shared.hitman.misc.csync.color
        elseif v.Name == "face" then
            v:Destroy()
        end
    end

    -- Make HRP invisible
    local hrp = clone:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.Transparency = 1 end

    -- Remove humanoid
    local hum = clone:FindFirstChild("Humanoid")
    if hum then hum:Destroy() end

    clone.Parent = _CSyncIgnoreFolder
    _CSyncVizClone = clone
end

local function _CSyncDestroyVisualizer()
    if _CSyncVizClone then
        _CSyncVizClone:Destroy()
        _CSyncVizClone = nil
    end
end

-- Get target for CSync (uses the current target from aim system)
local function _CSyncGetTarget()
    if _104.targetplayer and _104.targetplayer.Character then
        return _104.targetplayer
    end
    return nil
end

-- Calculate CFrame (exact Psalms logic)
local function _CSyncCalculateCFrame(targetPos)
    local csyncType = shared.hitman.misc.csync.type
    local dist = shared.hitman.misc.csync.distance
    local height = shared.hitman.misc.csync.height
    local speed = shared.hitman.misc.csync.speed
    local randomAmt = shared.hitman.misc.csync.randomamount
    local currentTime = tick()

    if csyncType == "Random" then
        return CFrame.new(
            targetPos + Vector3.new(
                math.random(-randomAmt, randomAmt),
                math.random(0, randomAmt),
                math.random(-randomAmt, randomAmt)
            )
        ) * CFrame.Angles(
            math.rad(math.random(0, 360)),
            math.rad(math.random(0, 360)),
            math.rad(math.random(0, 360))
        )
    elseif csyncType == "Orbit" then
        return CFrame.new(targetPos) *
            CFrame.Angles(0, 2 * math.pi * currentTime * speed % (2 * math.pi), 0) *
            CFrame.new(0, height, dist)
    elseif csyncType == "Spiral" then
        local angle = 2 * math.pi * currentTime * speed % (2 * math.pi)
        local spiralRadius = dist + math.sin(currentTime) * randomAmt
        return CFrame.new(targetPos) *
            CFrame.Angles(0, angle, 0) *
            CFrame.new(spiralRadius, height, 0)
    elseif csyncType == "Spherical" then
        local radius = dist
        local sphericalX = radius * math.sin(currentTime) * math.cos(currentTime * speed)
        local sphericalY = radius * math.sin(currentTime) * math.sin(currentTime * speed)
        local sphericalZ = radius * math.cos(currentTime)
        return CFrame.new(targetPos + Vector3.new(sphericalX, sphericalY, sphericalZ))
    elseif csyncType == "Attach" then
        -- Attach to target's predicted position
        if _104.targetplayer and _104.targetplayer.Character then
            local targetPart = _104.targetplayer.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                return targetPart.CFrame
            end
        end
        return CFrame.new(targetPos)
    end
    return CFrame.new(targetPos)
end

-- ============================================
-- PSALMS SPOOF METHOD (Exact copy)
-- ============================================

-- Heartbeat loop (main spoof logic - EXACTLY like Psalms)
local _CSyncHeartbeatConn = nil
local _CSyncRenderConn = nil
local _CSyncSaved = nil

-- This is the EXACT Psalms Heartbeat logic
local function _CSyncOnHeartbeat()
    -- Handle visualizer parent
    if shared.hitman.misc.csync.enabled then
        if _CSyncVizClone then
            _CSyncVizClone.Parent = _CSyncIgnoreFolder
        end
    else
        if _CSyncVizClone then
            _CSyncVizClone.Parent = nil
        end
    end

    -- Main spoof logic (only when visualize is ON - this is the SPOOF mode in Psalms)
    if shared.hitman.misc.csync.enabled and shared.hitman.misc.csync.spoof then
        local target = _CSyncGetTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = _56.Character and _56.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local targetPos = target.Character.HumanoidRootPart.Position
                local Saved = humanoidRootPart.CFrame
                local FakeCFrame = _CSyncCalculateCFrame(targetPos)

                -- Update visualizer
                if _CSyncVizClone then
                    _CSyncVizClone:SetPrimaryPartCFrame(FakeCFrame)
                    for _, Part in pairs(_CSyncVizClone:GetChildren()) do
                        if Part:IsA("BasePart") then
                            Part.Color = shared.hitman.misc.csync.color
                        end
                    end
                end

                -- Set HRP to fake position
                humanoidRootPart.CFrame = FakeCFrame

                -- Wait for render
                _52.RenderStepped:Wait()

                -- Move setback to saved position (this is what the camera sees)
                _CSyncSetback.Position = Saved.Position + Vector3.new(0, 1.5, 0)

                -- Camera looks at setback (original position) so screen is normal
                _58.CameraSubject = _CSyncSetback

                -- Restore HRP to original
                humanoidRootPart.CFrame = Saved
            end
        end
    end
end

-- RenderStepped for non-spoof mode (when visualize is OFF but CSync is ON)
-- This is the "silent" strafe from Psalms
local _CSyncLastPosition = nil

local function _CSyncOnRenderStepped()
    local target = _CSyncGetTarget()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        if shared.hitman.misc.csync.enabled and not shared.hitman.misc.csync.spoof then
            local humanoidRootPart = _56.Character and _56.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local targetPos = target.Character.HumanoidRootPart.Position
                local SigmaCFrame = _CSyncCalculateCFrame(targetPos)
                humanoidRootPart.CFrame = SigmaCFrame
                _CSyncLastPosition = targetPos
            end
        end
    elseif not target and _CSyncLastPosition then
        local humanoidRootPart = _56.Character and _56.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(_CSyncLastPosition)
            _CSyncLastPosition = nil
        end
    end
end

-- Bind/Unbind functions
local function _CSyncBind()
    if _CSyncHeartbeatConn then _CSyncHeartbeatConn:Disconnect() end
    if _CSyncRenderConn then _CSyncRenderConn:Disconnect() end

    _CSyncHeartbeatConn = _52.Heartbeat:Connect(_CSyncOnHeartbeat)
    _CSyncRenderConn = _52.RenderStepped:Connect(_CSyncOnRenderStepped)
end

local function _CSyncUnbind()
    if _CSyncHeartbeatConn then
        _CSyncHeartbeatConn:Disconnect()
        _CSyncHeartbeatConn = nil
    end
    if _CSyncRenderConn then
        _CSyncRenderConn:Disconnect()
        _CSyncRenderConn = nil
    end

    -- Reset camera
    if _56.Character then
        local hum = _56.Character:FindFirstChild('Humanoid')
        if hum then _58.CameraSubject = hum end
    end

    -- Hide visualizer
    if _CSyncVizClone then
        _CSyncVizClone.Parent = nil
    end
end



-- ============================================
-- CSYNC CALLBACKS (Replaces Strafe Callbacks)
-- ============================================

Toggles.TargetStrafe:OnChanged(function(value)
    print("[DEBUG] CSync toggled:", value)
    shared.hitman.misc.csync.enabled = value
    if value then
        _CSyncBind()
    else
        _CSyncUnbind()
        _CSyncDestroyVisualizer()
        if _56.Character then
            local hum = _56.Character:FindFirstChild('Humanoid')
            if hum then _58.CameraSubject = hum end
        end
    end
end)

Options.StrafeTarget:OnChanged(function(value)
    print("[DEBUG] CSync Target changed:", value)
    if value == 'No One' or not value then
        -- No target needed, CSync uses the current aim target
    else
        -- Try to find and set as target
        for _, plr in ipairs(_51:GetPlayers()) do
            if plr.Name == value then
                if _104.active then
                    _104.targetplayer = plr
                end
                break
            end
        end
    end
end)

Options.StrafeMode:OnChanged(function(value)
    print("[DEBUG] CSync Type changed:", value)
    -- Map strafe modes to CSync types
    local modeMap = {
        Orbit = "Orbit",
        Circle = "Orbit",
        Random = "Random"
    }
    shared.hitman.misc.csync.type = modeMap[value] or "Orbit"
end)

Options.StrafeSpeed:OnChanged(function(value)
    print("[DEBUG] CSync Speed changed:", value)
    shared.hitman.misc.csync.speed = value / 10  -- Scale down for Psalms logic
end)

Options.StrafeDistance:OnChanged(function(value)
    print("[DEBUG] CSync Distance changed:", value)
    shared.hitman.misc.csync.distance = value
end)

Options.StrafeHeight:OnChanged(function(value)
    print("[DEBUG] CSync Height changed:", value)
    shared.hitman.misc.csync.height = value
end)

Options.StrafeRandom:OnChanged(function(value)
    print("[DEBUG] CSync Random changed:", value)
    shared.hitman.misc.csync.randomamount = value
end)

Toggles.StrafeVisualize:OnChanged(function(value)
    print("[DEBUG] CSync Visualize toggled:", value)
    shared.hitman.misc.csync.visualize = value
    if value then
        _CSyncCreateVisualizer()
    else
        if _CSyncVizClone then
            _CSyncVizClone.Parent = nil
        end
    end
end)

Options.StrafeVizColor:OnChanged(function(value)
    print("[DEBUG] CSync Color changed")
    shared.hitman.misc.csync.color = value
    if _CSyncVizClone then
        for _, Part in pairs(_CSyncVizClone:GetChildren()) do
            if Part:IsA("BasePart") then
                Part.Color = value
            end
        end
    end
end)

Toggles.StrafeSpoof:OnChanged(function(value)
    print("[DEBUG] CSync Spoof toggled:", value)
    shared.hitman.misc.csync.spoof = value
    if not value then
        -- Reset camera when spoof is turned off
        if _56.Character then
            local hum = _56.Character:FindFirstChild('Humanoid')
            if hum then _58.CameraSubject = hum end
        end
    end
end)



-- ============================================
-- DESYNC HEARTBEAT LOOP (from Vearware)
-- ============================================

local _mainHeartbeatSkip = 0
_52.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    _mainHeartbeatSkip = _mainHeartbeatSkip + 1
    if _mainHeartbeatSkip >= 2 then _mainHeartbeatSkip = 0 end

    if shared.hitman.misc.desync.enabled and _56.Character then
        local hrp = _56.Character:FindFirstChild('HumanoidRootPart')
        if hrp then
            local oldCFrame = hrp.CFrame
            local desyncCFrame = oldCFrame

            if shared.hitman.misc.desync.mode == 'Void Spam' then
                desyncCFrame = math.random(1, 2) == 1 and oldCFrame or CFrame.new(math.random(10000, 50000), math.random(10000, 50000), math.random(10000, 50000)) * oldCFrame.Rotation
            elseif shared.hitman.misc.desync.mode == 'Void' then
                desyncCFrame = oldCFrame + Vector3.new(math.random(-444444, 444444), math.random(-444444, 444444), math.random(-44444, 44444))
                desyncCFrame = desyncCFrame * oldCFrame.Rotation
            end

            hrp.CFrame = desyncCFrame
            _58.CameraSubject = desync_setback
            _52.RenderStepped:Wait()
            if desync_setback then
                desync_setback.CFrame = oldCFrame * CFrame.new(0, hrp.Size.Y / 2 + 0.5, 0)
            end
            hrp.CFrame = oldCFrame
        end
    end

    if _56.Character then
        local hrp = _56.Character:FindFirstChild('HumanoidRootPart')
        if hrp then
            local visualizeCFrame = hrp.CFrame
            if shared.hitman.misc.desync.enabled then
                if shared.hitman.misc.desync.mode == 'Void Spam' then
                    visualizeCFrame = math.random(1, 2) == 1 and hrp.CFrame or CFrame.new(math.random(10000, 50000), math.random(10000, 50000), math.random(10000, 50000)) * hrp.CFrame.Rotation
                elseif shared.hitman.misc.desync.mode == 'Void' then
                    visualizeCFrame = hrp.CFrame + Vector3.new(math.random(-444444, 444444), math.random(-444444, 444444), math.random(-44444, 44444))
                    visualizeCFrame = visualizeCFrame * hrp.CFrame.Rotation
                end
            end

            if BodyCloneDesync then
                if shared.hitman.misc.desync.enabled then
                    BodyCloneDesync:SetPrimaryPartCFrame(visualizeCFrame)
                    if BodyCloneDesyncHighlight then BodyCloneDesyncHighlight.Enabled = true end
                else
                    BodyCloneDesync:SetPrimaryPartCFrame(CFrame.new(9999, 9999, 9999))
                    if BodyCloneDesyncHighlight then BodyCloneDesyncHighlight.Enabled = false end
                end
            end
        else
            if BodyCloneDesync then
                BodyCloneDesync:SetPrimaryPartCFrame(CFrame.new(9999, 9999, 9999))
                if BodyCloneDesyncHighlight then BodyCloneDesyncHighlight.Enabled = false end
            end
        end
    else
        if BodyCloneDesync then
            BodyCloneDesync:SetPrimaryPartCFrame(CFrame.new(9999, 9999, 9999))
            if BodyCloneDesyncHighlight then BodyCloneDesyncHighlight.Enabled = false end
        end
    end
end))




-- ============================================
-- STOMP ANIMATION SPOOFER MODULE
-- ============================================

local StompAnimSpoofer = {}
StompAnimSpoofer.AnimationId = "rbxassetid://11710443895"
StompAnimSpoofer.PlaySpeed = 1.8
StompAnimSpoofer.Track = nil

local function FindGameStompAnimation()
    local searchLocations = {
        game:GetService("ReplicatedStorage"),
        game:GetService("StarterPlayer"):FindFirstChild("StarterCharacterScripts"),
        workspace
    }
    for _, loc in ipairs(searchLocations) do
        if loc then
            for _, obj in ipairs(loc:GetDescendants()) do
                if obj:IsA("Animation") then
                    local name = obj.Name:lower()
                    if name:find("stomp") or name:find("kickdown") or name:find("finish") then
                        return obj.AnimationId
                    end
                end
            end
        end
    end
    return nil
end

local detectedId = FindGameStompAnimation()
if detectedId then
    StompAnimSpoofer.AnimationId = detectedId
    print("[StompSpoof] Detected game stomp animation:", detectedId)
end

function StompAnimSpoofer:Play(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end
    if self.Track then
        pcall(function() self.Track:Stop(0.1) end)
        self.Track = nil
    end
    local anim = Instance.new("Animation")
    anim.AnimationId = self.AnimationId
    anim.Name = "SpoofedStomp"
    local track = animator:LoadAnimation(anim)
    if track then
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = false
        track:Play(0.05, 1, self.PlaySpeed)
        self.Track = track
        task.delay(track.Length / self.PlaySpeed + 0.2, function()
            pcall(function()
                if track and track.IsPlaying then track:Stop(0.1) end
            end)
            anim:Destroy()
        end)
    else
        anim:Destroy()
    end
end

function StompAnimSpoofer:Stop()
    if self.Track then
        pcall(function() self.Track:Stop(0.1) end)
        self.Track = nil
    end
end

local function FireStompRemote(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local mainEvent = game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent")
    if mainEvent then
        local variants = {"Stomp", "StompXD", "stomp", "STOMP", "Finish"}
        for _, v in ipairs(variants) do
            local succ = pcall(function()
                mainEvent:FireServer(v, targetHRP)
            end)
            if succ then break end
        end
    end
end

shared.StompAnimSpoofer = StompAnimSpoofer
shared.FireStompRemote = FireStompRemote

-- ============================================
-- AUTO STOMP LOGIC (Teleport + E Key)
-- ============================================

local _StompCooldown = 0
local _StompStateThrottle = 0
local _StompTpThrottle = 0




-- ============================================
-- INDEPENDENT AUTO STOMP LOOP (always active)
-- ============================================

local _StompActive = false
local _StompTarget = nil
local _StompStartTime = 0

local _StompEThread = nil
local _StompESpamming = false

local _StompLoop = _52.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    if not Toggles.AutoStomp.Value then return end

    local target = _104.targetplayer
    if not target then
        local targetName = Options.TargetPlayer.Value
        if targetName and targetName ~= 'No One' then
            for _, plr in ipairs(_51:GetPlayers()) do
                if plr.Name == targetName then
                    target = plr
                    break
                end
            end
        end
    end

    if not target or not target.Character then
        _StompESpamming = false
        return
    end

    local targetChar = target.Character
    local bodyEffects = targetChar:FindFirstChild("BodyEffects")
    if not bodyEffects then
        _StompESpamming = false
        return
    end

    local ko = bodyEffects:FindFirstChild("K.O")
    if not ko then
        _StompESpamming = false
        return
    end
    local dead = bodyEffects:FindFirstChild("Dead")

    if ko.Value == true and (not dead or not dead.Value) then
        local myChar = _56.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar and myChar:FindFirstChildWhichIsA("Humanoid")
        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        local targetUT = targetChar:FindFirstChild("UpperTorso")
        local targetPart = targetUT or targetHRP

        if myChar and myHRP and myHum and targetPart then
            -- Stabilize character (throttled so humanoid doesnt freeze)
            myHum.Sit = false
            myHum.PlatformStand = false
            if tick() - _StompStateThrottle > 0.3 then
                _StompStateThrottle = tick()
                myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            myHRP.Velocity = Vector3.new()
            pcall(function() myHRP.AssemblyLinearVelocity = Vector3.zero end)

            -- Stand ON TOP of target (throttled)
            if tick() - _StompTpThrottle > 0.08 then
                _StompTpThrottle = tick()
                local charHeight = myHRP.Size.Y / 2
                local targetHeight = targetPart.Size and targetPart.Size.Y / 2 or 1
                local standPos = targetPart.Position + Vector3.new(0, charHeight + targetHeight, 0)

                if Toggles.StompSpin.Value then
                    local spinSpeed = Options.StompSpinSpeed.Value
                    local angle = tick() * spinSpeed * 2
                    myHRP.CFrame = CFrame.new(standPos) * CFrame.Angles(0, math.rad(angle), 0)
                    myHum.AutoRotate = false
                else
                    myHRP.CFrame = CFrame.new(standPos)
                    myHum.AutoRotate = true
                end
            end

            -- Start stomp spoof thread ONCE (not every frame)
            if not _StompESpamming then
                _StompESpamming = true
                task.spawn(function()
                    local vim = game:GetService("VirtualInputManager")
                    while _StompESpamming and Toggles.AutoStomp.Value do
                        -- Check if target still knocked
                        local stillKnocked = false
                        if target and target.Character then
                            local be = target.Character:FindFirstChild("BodyEffects")
                            if be then
                                local koCheck = be:FindFirstChild("K.O")
                                if koCheck and koCheck.Value then
                                    stillKnocked = true
                                end
                            end
                        end
                        if not stillKnocked then break end

                        -- Play spoofed stomp animation locally
                        local myChar = _56.Character
                        if myChar then
                            StompAnimSpoofer:Play(myChar)
                        end

                        -- Fire stomp remote directly to server
                        FireStompRemote(target)

                        -- Fallback E-spam for stubborn games
                        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(0.005)
                        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                        task.wait(0.05)
                    end
                    _StompESpamming = false
                    StompAnimSpoofer:Stop()
                end)
            end
        end
    else
        _StompESpamming = false
        if _StompActive and _StompTarget == target then
            _StompActive = false
            _StompTarget = nil
        end
        -- Reset character state so you can move/shoot normally
        local myChar = _56.Character
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if myHum then
            myHum.AutoRotate = true
            myHum.PlatformStand = false
        end
    end
end))

local _237 = _52.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    if _104.active then
        _205()
        _194()
        _198()

        if _130 then
            _141()
        end

        _206()

        _151()
    else
        _134.Visible = false
        _135.Visible = false
    end
end))

Toggles.Enabled:OnChanged(function(value)
    print("[DEBUG] Enabled toggled:", value)
    _104.enabled = value
    shared.hitman.silent.enabled = value
    if not value then
        _104.active = false
        _104.targetplayer = nil
        _104.targetpart = nil
        _104.targetposition = nil

        if _105 then
            _150()
        end
        _161()
    end
end)

Options.Mode:OnChanged(function(value)
    print("[DEBUG] Mode changed:", value)
    _104.mode = value
    _104.currentmode = value
    shared.hitman.silent.mode = value

    if _104.active then
        _198()
        _165()
    end

    if (value == "auto select" or value == "target all") and _105 then
        _150()
        if Toggles.Spectate.Value then
            Toggles.Spectate:SetValue(false)
        end
    end
end)

Toggles.AutoShoot:OnChanged(function(value)
    print("[DEBUG] AutoShoot toggled:", value)
    _104.autoshoot = value
end)

Options.TargetPlayer:OnChanged(function(value)
    print("[DEBUG] TargetPlayer changed:", value)
    if value == 'No One' or value == nil or value == '' then
        _ManualTarget = nil
        if _104.active and _104.mode ~= 'target all' then
            _193()
        end
    else
        for _, player in ipairs(_51:GetPlayers()) do
            if player.Name == value then
                _ManualTarget = player
                if _104.active and _104.mode ~= 'target all' then
                    if _182(player) then
                        _104.targetplayer = player
                        _104.targetpart = player.Character and player.Character:FindFirstChild("Head")
                        if _104.targetpart then
                            _104.targetposition = _104.targetpart.Position
                        end
                        _104.wasknocked[player] = false
                        local _148 = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                        if _148 then
                            _104.lasthealth[player] = _148.Health
                        end
                        _168(true)
                        _194()
                        if Toggles.Highlight.Value then
                            _165()
                        end
                        if Toggles.Spectate.Value and _104.mode == 'sticky' then
                            _149()
                        end
                    end
                end
                break
            end
        end
    end
end)

Toggles.ManipulatedText:OnChanged(function(value)
    print("[DEBUG] ManipulatedText toggled:", value)
    if not value then
        _134.Visible = false
    elseif _104.active then
        _134.Visible = true
    end
end)

Toggles.TargetInfo:OnChanged(function(value)
    print("[DEBUG] TargetInfo toggled:", value)
    if not value then
        _135.Visible = false
    elseif _104.active then
        _135.Visible = true
        _194()
    end
end)

Toggles.Line:OnChanged(function(value)
    print("[DEBUG] Line toggled:", value)
    if not value then
        for i, _139 in ipairs(_136) do
            _139.Visible = false
        end
        for i, _140 in ipairs(_137) do
            _140.Visible = false
        end
    elseif _104.active then
        _198()
    end
end)

Toggles.Spectate:OnChanged(function(value)
    print("[DEBUG] Spectate toggled:", value)
    if value then
        if _104.active and _104.mode == "sticky" then
            _149()
        end
    else
        _150()
    end
end)

Toggles.Highlight:OnChanged(function(value)
    print("[DEBUG] Highlight toggled:", value)
    if value then
        if _104.active then
            _165()
        end
    else
        _161()
    end
end)

Toggles.KnockCheck:OnChanged(function(value)
    print("[DEBUG] KnockCheck toggled:", value)
    shared.hitman.checks.knock = value
end)

Toggles.ProtectedCheck:OnChanged(function(value)
    print("[DEBUG] ProtectedCheck toggled:", value)
    shared.hitman.checks.protected = value
end)


Toggles.AutoStomp:OnChanged(function(value)
    print("[DEBUG] AutoStomp toggled:", value)
end)








-- Desync callbacks
Toggles.Desync:OnChanged(function(value)
    print("[DEBUG] Desync toggled:", value)
    shared.hitman.misc.desync.enabled = value
    if value then
        if not BodyCloneDesync then SetupDesyncVisuals() end
    else
        ResetDesyncCamera()
        if BodyCloneDesync then
            BodyCloneDesync:SetPrimaryPartCFrame(CFrame.new(9999, 9999, 9999))
            if BodyCloneDesyncHighlight then BodyCloneDesyncHighlight.Enabled = false end
        end
    end
end)

Options.DesyncMode:OnChanged(function(value)
    print("[DEBUG] Desync mode changed:", value)
    shared.hitman.misc.desync.mode = value
end)

Options.DesyncRandom:OnChanged(function(value)
    print("[DEBUG] Desync random amount changed:", value)
    shared.hitman.misc.desync.randomamount = value
end)

Toggles.CFrameFly:OnChanged(function(value)
    print("[DEBUG] CFrameFly toggled:", value)
    _243.master = value
    if not value then
        _243.enabled = false
        _245()
    else
        _243.enabled = false
        _245()
    end
end)

Options.CFrameFlyKeybind:OnClick(function()
    print("[DEBUG] CFrameFly keybind clicked")
    if _243.master then
        _243.enabled = not _243.enabled
        _245()
    end
end)

-- ============================================
-- AUTO ARMOR SYSTEM
-- ============================================

local function _LocateArmor()
    if not Toggles.AutoArmor.Value then return end
    local _144 = _56.Character
    if not _144 then return end
    local _120 = _144:FindFirstChild("HumanoidRootPart")
    local _148 = _144:FindFirstChildOfClass("Humanoid")
    if not _120 or not _148 or _148.Health <= 0 then return end

    local _savedpos = _120.CFrame

    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ClickDetector") and v.Parent and v.Parent.Name:match("Armor") then
            local _head = v.Parent:FindFirstChild("Head")
            if _head then
                _120.CFrame = _head.CFrame
                task.wait(0.2)
                fireclickdetector(v)
                task.wait(0.1)
                _120.CFrame = _savedpos
                print("[DEBUG] Auto Armor purchased")
                return
            end
        end
    end

    print("[DEBUG] No armor found")
end

Toggles.AutoArmor:OnChanged(function(value)
    print("[DEBUG] Auto Armor toggled:", value)
end)

Options.AutoArmorKeybind:OnClick(function()
    print("[DEBUG] Auto Armor keybind clicked")
    _LocateArmor()
end)

_54.InputBegan:Connect(function(input, processed)
    if processed then return end
    if not Toggles.AutoArmor.Value then return end
    local _key = Options.AutoArmorKeybind.Value
    if _key and input.KeyCode == _key then
        _LocateArmor()
    end
end)



Options.HighlightFillColor:OnChanged(function()
    print("[DEBUG] HighlightFillColor changed")
    for _, _163 in pairs(_114) do
        if _163.highlight then
            _163.highlight.FillColor = Options.HighlightFillColor.Value
            _163.highlight.FillTransparency = Options.HighlightFillColor.Transparency
        end
    end
end)

Options.HighlightOutlineColor:OnChanged(function()
    print("[DEBUG] HighlightOutlineColor changed")
    for _, _163 in pairs(_114) do
        if _163.highlight then
            _163.highlight.OutlineColor = Options.HighlightOutlineColor.Value
            _163.highlight.OutlineTransparency = Options.HighlightOutlineColor.Transparency
        end
    end
end)

Options.LineColor:OnChanged(function()
    print("[DEBUG] LineColor changed")
    local _238 = Options.LineColor.Value
    local _239 = Options.LineColor.Transparency
    for i, _139 in ipairs(_136) do
        if _139 then
            _139.Color = _238
            _139.Transparency = _239
        end
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function(_154)
    if _154 == _104.targetplayer then
        _104.targetplayer = nil
        _104.targetpart = nil
        _104.targetposition = nil
        _168(false)

        if _109 == _154 and _105 then
            _150()
        end
    end

    if _154 == _109 then
        _150()
    end

    if _ManualTarget == _154 then
        _ManualTarget = nil
        Options.TargetPlayer:SetValue('No One')
    end

    _104.lasthealth[_154] = nil
    _104.wasknocked[_154] = nil

    if _114[_154.Name] then
        local _163 = _114[_154.Name]
        if _163.highlight then
            _163.highlight:Destroy()
        end
        if _163.connection then
            _163.connection:Disconnect()
        end
        _114[_154.Name] = nil
    end
end)

_48:OnUnload(function()
    _150()
    _161()
    _193()
    _243.enabled = false
    _245()
    if _254 then _254:Disconnect() end
    if _255 then _255:Disconnect() end
    if _237 then
        _237:Disconnect()
    end
    if _TargetDropdownRefreshConn then
        _TargetDropdownRefreshConn:Disconnect()
    end
    _CSyncUnbind()
    _CSyncDestroyVisualizer()
    if _CSyncSetback then
        _CSyncSetback:Destroy()
        _CSyncSetback = nil
    end
    if _CSyncIgnoreFolder then
        _CSyncIgnoreFolder:Destroy()
        _CSyncIgnoreFolder = nil
    end
    DestroyDesyncVisuals()
    if _133 then
        _133:Destroy()
    end
    if _StompLoop then _StompLoop:Disconnect() end
    if StompAnimSpoofer then StompAnimSpoofer:Stop() end
    _138()
end)

print("[DEBUG] Script fully loaded! All features initialized.")

return {
    targetaim = _104,
    togglefullauto = function()
        _122 = not _122
        if _122 then
            _210()
        else
            if _125 then
                _125:Disconnect()
            end
            if _126 then
                _126:Disconnect()
            end
            _124 = false
        end
    end,
    setfullautodelay = function(_240)
        _123 = _240
    end,
    setmode = function(_241)
        if _241 == "sticky" or _241 == "auto select" or _241 == "target all" then
            _104.mode = _241
            _104.currentmode = _241
            shared.hitman.silent.mode = _241
            Options.Mode:SetValue(_241)
        end
    end,
    desktop = _130,
    console = _129,
    specting = _149,
    nonspect = _150,
    updhigh = _165,
    removeskidlights = _161
}

