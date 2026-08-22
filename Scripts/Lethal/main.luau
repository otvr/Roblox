shared.Lethal = {

    ['Settings'] = {
        ['Target Aim'] = true,
        ['Knock Check'] = false,
        ['Visible Check'] = false,
        ['Self Knock Check'] = false,
        ['Max Range'] = 5000,
    },

    ['Keybinds'] = {
        ['Target Lock'] = {
            ['Key'] = 'C',
            ['Mode'] = 'Toggle',
        },
        ['Trigger Bot'] = {
            ['Key'] = 'V',
            ['Mode'] = 'Hold',
        },
        ['Speed'] = 'Z',
        ['ESP'] = 'Y',
        ['Super Jump'] = 'L',
        ['Infinite Range'] = 'N',
    },

    ['FOV'] = {
        ['Enabled'] = false,
        ['Visible'] = true,
        ['Thickness'] = 4,
        ['Active Color'] = Color3.fromRGB(0, 17, 255),
        ['Size'] = 10,
    },

    ['Target Line'] = {
        ['Enabled'] = true,
        ['Thickness'] = 2,
        ['Transparency'] = 1,
        ['Vulnerable'] = Color3.fromRGB(255, 0, 0),
        ['Invulnerable'] = Color3.fromRGB(250, 0, 0),
    },

    ['Silent Aim'] = {
        ['Enabled'] = true,
        ['Hit Part'] = 'Closest Part',
        ['Use Prediction'] = false,
        ['Prediction'] = {
            ['X'] = 0.133,
            ['Y'] = 0.133,
            ['Z'] = 0.133,
        },
    },

    ['Camera Lock'] = {
        ['Enabled'] = true,
        ['Hit Part'] = 'Closest Part',
        ['Smoothing'] = {
            ['X'] = 20,
            ['Y'] = 20,
            ['Z'] = 20,
        },
        ['Use Prediction'] = false,
        ['Prediction'] = {
            ['X'] = 0.133,
            ['Y'] = 0.133,
            ['Z'] = 0.133,
        },
    },

    ['Trigger Bot'] = {
        ['Enabled'] = true,
        ['Delay'] = 0.01,
        ['Require Target'] = true,
        ['Specific Weapons'] = {
            ['Enabled'] = false,
            ['Weapons'] = {
                '[Double-Barrel SG]',
                '[Revolver]',
                '[TacticalShotgun]',
            },
        },
    },

    ['Spread'] = {
        ['Enabled'] = true,
        ['Amount'] = 10,
        ['Specific Weapons'] = {
            ['Enabled'] = false,
            ['Weapons'] = {
                '[Double-Barrel SG]',
                '[TacticalShotgun]',
            },
        },
    },

    ['Speed'] = {
        ['Enabled'] = true,
        ['Multiplier'] = 50,
        ['Anti Fling'] = false,
    },

    ['Hitbox Expander'] = {
        ['Enabled'] = false,
        ['Size'] = 5,
    },

    ['Rapid Fire'] = {
        ['Enabled'] = false,
        ['Key'] = 'K',
        ['Mode'] = 'Toggle',
        ['Delay'] = 0.01,
        ['Specific Weapons'] = {
            ['Enabled'] = false,
            ['Weapons'] = {
                '[Revolver]',
                '[Double-Barrel SG]',
                '[TacticalShotgun]',
            },
        },
    },

    ['Infinite Range'] = {
        ['Enabled'] = true,
        ['Key'] = 'N',
        ['Max Range'] = 77777,
    },

    ['Force Hit'] = {
        ['Enabled'] = true,
    },

    ['Bullet Teleport'] = {
        ['Enabled'] = false,
        ['Offset'] = 5,
    },

    ['Range Expander'] = {
        ['Enabled'] = true,
        ['Range'] = 999999,
    },

    ['Desync'] = {
        ['Enabled'] = false,
        ['Key'] = 'F',
        ['Mode'] = 'Toggle',
        ['Speed'] = 0.5,
        ['Radius'] = 8,
        ['Visualizer'] = {
            ['Enabled'] = true,
            ['Color'] = Color3.fromRGB(255, 50, 50),
            ['Transparency'] = 0.5,
        },
    },

    ['Visual Awareness'] = {
        ['Enabled'] = true,
        ['Color'] = Color3.fromRGB(255, 255, 255),
        ['Target Color'] = Color3.fromRGB(255, 0, 0),
        ['Use Display Name'] = false,
        ['Name Above'] = false,

        ['Text Size'] = 14,
        ['Text Font'] = Enum.Font.GothamBold,
        ['Text Stroke'] = true,
        ['Text Stroke Color'] = Color3.fromRGB(0, 0, 0),
        ['Text Stroke Transparency'] = 0,
    },

    ['Super Jump'] = {
        ['Enabled'] = true,
        ['Power'] = 265,
        ['Cooldown'] = 0.1,
    },

    ['Skins'] = {
        ['Enabled'] = true,
        ['Weapons'] = {
            ['[Knife]'] = "",
            ['[Bat]'] = "",
            ['[Double-Barrel SG]'] = "",
            ['[Revolver]'] = "",
            ['[TacticalShotgun]'] = "",
            ['[Shotgun]'] = "",
            ['[DrumShotgun]'] = "",
            ['[AK-47]'] = "",
            ['[AR]'] = "",
            ['[Silencer AR]'] = "",
            ['[Drum Gun]'] = "",
            ['[AUG]'] = "",
            ['[P90]'] = "",
            ['[Rifle]'] = "",
            ['[Silencer]'] = "",
            ['[Glock]'] = "",
        },
    },

}

local Config = shared.Lethal
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local currentTarget = nil
local isLocking = false
local triggerEnabled = false
local desyncEnabled = false
local desyncAngle = 0
local lastRapidFire = 0
local isfiring = false
local espLabels = {}
local SpeedEnabled = false
local lastVisibleTarget = nil
local lastTriggerClick = 0
local superJumpActive = false
local infRangeActive = false

local outlinePart = Instance.new("Part")
outlinePart.Anchored = true
outlinePart.CanCollide = false
outlinePart.Transparency = 0.85
outlinePart.BrickColor = BrickColor.new("Grey")
outlinePart.Material = Enum.Material.Neon
outlinePart.Name = "FOVOutline3D"
outlinePart.Parent = Workspace

local desyncPart = Instance.new("Part")
desyncPart.Anchored = true
desyncPart.CanCollide = false
desyncPart.CanQuery = false
desyncPart.CanTouch = false
desyncPart.CastShadow = false
desyncPart.Size = Vector3.new(2, 5, 1)
desyncPart.Material = Enum.Material.Neon
desyncPart.BrickColor = BrickColor.new(Config['Desync']['Visualizer']['Color'])
desyncPart.Transparency = 1
desyncPart.Name = "DesyncVisualizer"
desyncPart.Parent = Workspace

local desyncLabel = Drawing.new("Text")
desyncLabel.Text = "DESYNC"
desyncLabel.Size = 14
desyncLabel.Center = true
desyncLabel.Outline = true
desyncLabel.OutlineColor = Color3.fromRGB(0, 0, 0)
desyncLabel.Color = Config['Desync']['Visualizer']['Color']
desyncLabel.Visible = false
desyncLabel.ZIndex = 999

local targetLine = Drawing.new("Line")
targetLine.Visible = false
targetLine.Thickness = Config['Target Line']['Thickness']
targetLine.Transparency = Config['Target Line']['Transparency']
targetLine.ZIndex = 999

local function elasticOut(t)
    local p = 0.3
    return math.pow(2, -10 * t) * math.sin((t - p / 4) * (2 * math.pi) / p) + 1
end

local function sineInOut(t)
    return -(math.cos(math.pi * t) - 1) / 2
end

local function isPlayerKnockedOrKO(player)
    if not Config['Settings']['Knock Check'] then
        return false
    end

    if player.Character then
        local bodyEffects = player.Character:FindFirstChild("BodyEffects")
        if bodyEffects then
            local ko = bodyEffects:FindFirstChild("K.O")
            if ko and ko.Value == true then
                return true
            end

            local knocked = bodyEffects:FindFirstChild("Knocked")
            if knocked and knocked.Value == true then
                return true
            end
        end
    end

    return false
end

local function isSelfKnocked()
    if not Config['Settings']['Self Knock Check'] then
        return false
    end

    if LocalPlayer.Character then
        local bodyEffects = LocalPlayer.Character:FindFirstChild("BodyEffects")
        if bodyEffects then
            local ko = bodyEffects:FindFirstChild("K.O")
            if ko and ko.Value == true then
                return true
            end

            local knocked = bodyEffects:FindFirstChild("Knocked")
            if knocked and knocked.Value == true then
                return true
            end
        end
    end
    return false
end

local function canSeeTarget(part)
    if not Config['Settings']['Visible Check'] then return true end
    if not part or not part.Parent then return false end
    local character = part.Parent
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * (part.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, character, outlinePart}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    local rayResult = Workspace:Raycast(origin, direction, raycastParams)
    return rayResult == nil or rayResult.Instance:IsDescendantOf(character)
end

local function getBodyParts(character)
    return {
        character:FindFirstChild("Head"),
        character:FindFirstChild("UpperTorso"),
        character:FindFirstChild("HumanoidRootPart"),

        character:FindFirstChild("LowerTorso"),
        character:FindFirstChild("LeftUpperArm"),
        character:FindFirstChild("RightUpperArm"),
        character:FindFirstChild("LeftLowerArm"),
        character:FindFirstChild("RightLowerArm"),
        character:FindFirstChild("LeftHand"),
        character:FindFirstChild("RightHand"),
        character:FindFirstChild("LeftUpperLeg"),
        character:FindFirstChild("RightUpperLeg"),
        character:FindFirstChild("LeftLowerLeg"),
        character:FindFirstChild("RightLowerLeg"),
        character:FindFirstChild("LeftFoot"),
        character:FindFirstChild("RightFoot"),
    }
end

local function getClosestBodyPart(character)
    local closestPart, shortestDist = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, part in pairs(getBodyParts(character)) do
        if part then
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            local dist
            if onScreen then
                dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            else
                dist = (Camera.CFrame.Position - part.Position).Magnitude + 10000
            end
            if dist < shortestDist then
                shortestDist = dist
                closestPart = part
            end
        end
    end
    return closestPart
end

local function isMouseInFOV3D()
    if not Config ['FOV']['Enabled'] then return true end
    local mouse = UserInputService:GetMouseLocation()
    local ray = Camera:ViewportPointToRay(mouse.X, mouse.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filterList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then table.insert(filterList, player.Character) end
    end
    params.FilterDescendantsInstances = filterList
    local hit = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    return hit and hit.Instance == outlinePart
end

local function findClosestTarget()
    local closestTarget, shortestDistance = nil, math.huge
    local maxRange = Config['Settings']['Max Range']
    local mousePos = UserInputService:GetMouseLocation()
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not isPlayerKnockedOrKO(player) then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            if maxRange and maxRange > 0 and localHRP and (localHRP.Position - hrp.Position).Magnitude > maxRange then continue end
            for _, part in pairs(getBodyParts(player.Character)) do
                if part and canSeeTarget(part) then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closestTarget = part
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

local function getPredictedPosition(part, config)
    if not config ['Use Prediction'] then return part.Position end
    local velocity = part.AssemblyLinearVelocity
    local pred = config['Prediction']
    local v = type(pred) == "table" and (pred['X'] or 0.133) or ((pred == 0) and 0.133 or pred)
    return part.Position + Vector3.new(velocity.X * v, velocity.Y * v, velocity.Z * v)
end

local function getTargetForCameraLock()
    if Config['Settings']['Target Aim'] and currentTarget then
        local player = Players:GetPlayerFromCharacter(currentTarget.Parent)
        if player and not isPlayerKnockedOrKO(player) then
            local targetPart = Config['Camera Lock']['Hit Part'] == 'Closest Part'
                and getClosestBodyPart(currentTarget.Parent)
                or currentTarget.Parent:FindFirstChild(Config['Camera Lock']['Hit Part'])
            if targetPart then
                if Config['Camera Lock']['Hit Part'] == 'Closest Part' then
                    currentTarget = targetPart
                end
                if canSeeTarget(targetPart) then
                    lastVisibleTarget = targetPart
                end
                return targetPart
            end
        else
            currentTarget = nil
            isLocking = false
            lastVisibleTarget = nil
            targetLine.Visible = false
        end
        return nil
    end
    return findClosestTarget()
end

local function applyCameraLock()
    if not isLocking then return end
    if isSelfKnocked() then
        currentTarget = nil
        isLocking = false
        lastVisibleTarget = nil
        targetLine.Visible = false
        return
    end
    if Config['FOV']['Enabled'] and not isMouseInFOV3D() then return end
    local target = getTargetForCameraLock()
    if target then
        local targetPos = getPredictedPosition(target, Config['Camera Lock'])
        local cameraCFrame = Camera.CFrame
        local targetCFrame = CFrame.new(cameraCFrame.Position, targetPos)
        local s = Config['Camera Lock']['Smoothing']
        local bx, by, bz = 1/s['X'], 1/s['Y'], 1/s['Z']
        local ex = elasticOut(math.min(bx,1))
        local ey = elasticOut(math.min(by,1))
        local ez = elasticOut(math.min(bz,1))
        local avgE = (ex+ey+ez)/3
        local avgB = (bx+by+bz)/3
        local smoothCFrame = cameraCFrame:Lerp(targetCFrame, avgE * avgB)
        Camera.CFrame = smoothCFrame:Lerp(targetCFrame, sineInOut(math.min(avgB,1)) * avgB)
    elseif lastVisibleTarget then
        local player = Players:GetPlayerFromCharacter(lastVisibleTarget.Parent)
        if player and not isPlayerKnockedOrKO(player) and canSeeTarget(lastVisibleTarget) then
            currentTarget = lastVisibleTarget
        end
    end
end

local function updateDesync(dt)
    local cfg = Config['Desync']
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if not desyncEnabled or not cfg['Enabled'] or not hrp then
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end
        end
        desyncPart.Transparency = 1
        desyncLabel.Visible = false
        return
    end

    desyncAngle = (desyncAngle + cfg['Speed'] * dt * 60) % (2 * math.pi)
    local radius = cfg['Radius']
    local fakeOffset = Vector3.new(
        math.cos(desyncAngle) * radius,
        0,
        math.sin(desyncAngle) * radius
    )
    local fakePos = hrp.Position + fakeOffset

    hrp.CFrame = CFrame.new(fakePos) * (hrp.CFrame - hrp.CFrame.Position)

    if cfg['Visualizer']['Enabled'] then
        desyncPart.CFrame = CFrame.new(fakePos)
        desyncPart.Transparency = cfg['Visualizer']['Transparency']
        desyncPart.BrickColor = BrickColor.new(cfg['Visualizer']['Color'])

        local screenPos, onScreen = Camera:WorldToViewportPoint(fakePos + Vector3.new(0, 3, 0))
        if onScreen and screenPos.Z > 0 then
            desyncLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 20)
            desyncLabel.Visible = true
        else
            desyncLabel.Visible = false
        end
    else
        desyncPart.Transparency = 1
        desyncLabel.Visible = false
    end
end

local function update3DFOVBox()
    if not Config['FOV']['Enabled'] or not Config['FOV']['Visible'] then
        outlinePart.Transparency = 1
        return
    end
    if currentTarget and currentTarget.Parent then
        local rootPart = currentTarget.Parent:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local offset = Config['FOV']['Size']
            outlinePart.Size = rootPart.Size + Vector3.new(offset, offset, offset)
            outlinePart.CFrame = rootPart.CFrame
            outlinePart.Transparency = 0.85
            outlinePart.BrickColor = isMouseInFOV3D()
                and BrickColor.new(Config['FOV']['Active Color'])
                or BrickColor.new("Grey")
            return
        end
    end
    outlinePart.Transparency = 1
end

local function updateTargetLine()
    if not Config['Target Line']['Enabled'] or not currentTarget or not currentTarget.Parent or not isLocking then
        targetLine.Visible = false
        return
    end
    local hrp = currentTarget.Parent:FindFirstChild("HumanoidRootPart")
    if not hrp then targetLine.Visible = false return end
    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if onScreen and screenPos.Z > 0 then
        local mousePos = UserInputService:GetMouseLocation()
        targetLine.From = Vector2.new(mousePos.X, mousePos.Y)
        targetLine.To = Vector2.new(screenPos.X, screenPos.Y)
        targetLine.Color = canSeeTarget(currentTarget) and Config['Target Line']['Vulnerable'] or Config['Target Line']['Invulnerable']
        targetLine.Visible = true
    else
        targetLine.Visible = false
    end
end

local function getrapidgun()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, tool in next, char:GetChildren() do
        if tool:IsA("Tool") and tool:FindFirstChild("Ammo") then
            return tool
        end
    end
    return nil
end

local function patchtool(tool)
    pcall(function()
        for _, conn in pairs(getconnections(tool.Activated)) do
            local info = debug.getinfo(conn.Function)
            for i = 1, info.nups do
                local val = debug.getupvalue(conn.Function, i)
                if type(val) == "number" and val > 0 and val < 10 and math.floor(val) ~= val then
                    debug.setupvalue(conn.Function, i, 0)
                end
            end
        end
    end)
end

local function RapidFire()
    if not Config['Rapid Fire']['Enabled'] then
        isfiring = false
        return
    end

    if not isfiring then return end
    if tick() - lastRapidFire < Config['Rapid Fire']['Delay'] then return end

    local gun = getrapidgun()
    if not gun then return end

    if Config['Rapid Fire']['Specific Weapons']['Enabled'] then
        local valid = false
        for _, name in pairs(Config['Rapid Fire']['Specific Weapons']['Weapons']) do
            local clean = name:gsub("%[", ""):gsub("%]", "")
            if gun.Name == name or gun.Name:find(clean) then valid = true break end
        end
        if not valid then isfiring = false return end
    end

    gun:Activate()
    lastRapidFire = tick()
end

local function TriggerBot()
    if not Config['Trigger Bot']['Enabled'] or not triggerEnabled then return end
    if tick() - lastTriggerClick < Config['Trigger Bot']['Delay'] then return end
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool and (tool.Name == "[Knife]" or tool.Name == "[Bat]") then return end
    if Config['Trigger Bot']['Require Target'] and not currentTarget then return end
    if currentTarget then
        local character = currentTarget.Parent
        if not character then return end
        local player = Players:GetPlayerFromCharacter(character)
        if not player or isPlayerKnockedOrKO(player) or not canSeeTarget(currentTarget) then return end
        if Config['FOV']['Enabled'] and not isMouseInFOV3D() then return end
    end
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool then return end
    if Config['Trigger Bot']['Specific Weapons']['Enabled'] then
        local valid = false
        for _, weaponName in pairs(Config['Trigger Bot']['Specific Weapons']['Weapons']) do
            if tool.Name == weaponName or tool.Name:find(weaponName:gsub("%[",""):gsub("%]","")) then
                valid = true break
            end
        end
        if not valid then return end
    end
    tool:Activate()
    lastTriggerClick = tick()
end

local grm = getrawmetatable(game)
local oldIndex = grm.__index
setreadonly(grm, false)

local rangeParams = RaycastParams.new()
rangeParams.FilterType = Enum.RaycastFilterType.Exclude
rangeParams.IgnoreWater = true

local function getRangeFilterList()
    local list = {LocalPlayer.Character}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            table.insert(list, p.Character)
        end
    end
    return list
end

grm.__index = function(self, key)
    if not checkcaller() and self == Mouse then

        if key == "Hit" or key == "Target" then
            local targetPosition = nil
            local targetPart = nil

            if Config['Force Hit']['Enabled'] and currentTarget and isLocking then
                local character = currentTarget.Parent
                if character then
                    local player = Players:GetPlayerFromCharacter(character)
                    if player and not isPlayerKnockedOrKO(player) then
                        local head = character:FindFirstChild("Head")
                        if head and head:IsA("BasePart") then
                            targetPosition = head.Position
                            targetPart = head
                        end
                    end
                end
            end

            if not targetPosition and Config['Silent Aim']['Enabled'] and currentTarget then
                local character = currentTarget.Parent
                if character then
                    local player = Players:GetPlayerFromCharacter(character)
                    if player
                        and not isPlayerKnockedOrKO(player)
                        and canSeeTarget(currentTarget)
                        and (not Config['FOV']['Enabled'] or isMouseInFOV3D())
                    then
                        targetPosition = getPredictedPosition(currentTarget, Config['Silent Aim'])
                        targetPart = currentTarget
                    end
                end
            end

            if targetPosition and targetPart and Config['Bullet Teleport']['Enabled'] then
                local dirToCamera = (Camera.CFrame.Position - targetPosition).Unit
                local teleportPos = targetPosition + dirToCamera * (Config['Bullet Teleport']['Offset'] or 5)
                if key == "Hit" then return CFrame.new(teleportPos) end
                if key == "Target" then return targetPart end
            end

            if targetPosition then
                if key == "Hit" then return CFrame.new(targetPosition) end
                if key == "Target" then return targetPart end
            end

            if key == "Hit" and (Config['Range Expander']['Enabled'] or (Config['Infinite Range']['Enabled'] and infRangeActive)) then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool.Name ~= "[Knife]" and tool.Name ~= "[Bat]" then
                    local unitRay = oldIndex(self, "UnitRay")
                    if unitRay then
                        local origin = unitRay.Origin
                        local direction = unitRay.Direction
                        local range = Config['Range Expander']['Enabled']
                            and Config['Range Expander']['Range']
                            or 999999
                        local hitParams = RaycastParams.new()
                        hitParams.FilterType = Enum.RaycastFilterType.Exclude
                        hitParams.IgnoreWater = true
                        hitParams.FilterDescendantsInstances = {LocalPlayer.Character}
                        local result = Workspace:Raycast(origin, direction * range, hitParams)
                        local hitPos = result and result.Position or (origin + direction * range)
                        return CFrame.new(hitPos)
                    end
                end
            end
        end

    end
    return oldIndex(self, key)
end

setreadonly(grm, true)

task.spawn(function()
    local rs = game:GetService("ReplicatedStorage")
    local modules = rs:WaitForChild("Modules", 10)
    if not modules then return end
    local gunhandler = modules:WaitForChild("GunHandler", 10)
    if not gunhandler then return end
    local ok, handler = pcall(require, gunhandler)
    if not ok or not handler then return end
    if type(handler) ~= "table" then return end

    local function patchShootFn(original)
        if type(original) ~= "function" then return original end
        return function(t, ...)
            if type(t) == "table" then
                if Config['Range Expander']['Enabled'] or (Config['Infinite Range']['Enabled'] and infRangeActive) then
                    local range = Config['Range Expander']['Enabled'] and Config['Range Expander']['Range'] or Config['Infinite Range']['Max Range']
                    t.Range = range
                    if t.range then t.range = range end
                end
                if currentTarget and isLocking and Config['Force Hit']['Enabled'] then
                    local character = currentTarget.Parent
                    if character then
                        local player = Players:GetPlayerFromCharacter(character)
                        if player and not isPlayerKnockedOrKO(player) then
                            local head = character:FindFirstChild("Head")
                            if head then
                                t.AimPosition = head.Position
                                if t.aimPosition then t.aimPosition = head.Position end
                                if Config['Bullet Teleport']['Enabled'] then
                                    local offset = Config['Bullet Teleport']['Offset'] or 5
                                    local dir = (Camera.CFrame.Position - head.Position).Unit
                                    local origin = head.Position + dir * offset
                                    t.ForcedOrigin = origin
                                    if t.forcedOrigin then t.forcedOrigin = origin end
                                end
                            end
                        end
                    end
                end
            end
            return original(t, ...)
        end
    end

    if handler.Shoot then handler.Shoot = patchShootFn(handler.Shoot) end
    if handler.shoot then handler.shoot = patchShootFn(handler.shoot) end
end)

local oldRandom
oldRandom = hookfunction(math.random, function(...)
    local args = {...}
    if checkcaller() then
        return oldRandom(...)
    end

    if (#args == 0) or (args[1] == -0.05 and args[2] == 0.05) or (args[1] == -0.1) or (args[1] == -0.05) then
        if Config['Spread']['Enabled'] then
            if Config['Spread']['Specific Weapons']['Enabled'] then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    local weaponName = tool.Name
                    local foundWeapon = false

                    for _, weapon in pairs(Config['Spread']['Specific Weapons']['Weapons']) do
                        if weaponName == weapon then
                            foundWeapon = true
                            break
                        end
                    end

                    if foundWeapon then
                        return oldRandom(...) * (Config['Spread']['Amount'] / 100)
                    end
                end
            else
                return oldRandom(...) * (Config['Spread']['Amount'] / 100)
            end
        end
    end

    return oldRandom(...)
end)

local function makeESPBillboard(player)
    local cfg = Config['Visual Awareness']
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_Billboard"
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 200, 0, 30)
    bb.StudsOffset = Vector3.new(0, -3.5, 0)
    bb.Adornee = hrp
    bb.Parent = hrp

    local label = Instance.new("TextLabel")
    label.Name = "NameLabel"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextColor3 = cfg['Color']
    label.TextSize = cfg['Text Size']
    label.Font = cfg['Text Font']
    label.Text = cfg['Use Display Name'] and player.DisplayName or player.Name
    label.TextStrokeTransparency = cfg['Text Stroke'] and cfg['Text Stroke Transparency'] or 1
    label.TextStrokeColor3 = cfg['Text Stroke Color']
    label.TextScaled = false
    label.ZIndex = 10
    label.Parent = bb

    return bb
end

local function addESPToPlayer(player)
    if player == LocalPlayer then return end
    local esp = { player = player, billboard = nil }
    espLabels[player.UserId] = esp

    if player.Character and player.Character:FindFirstChild("Head") then
        esp.billboard = makeESPBillboard(player)
    end
end

local function removeESPFromPlayer(player)
    local esp = espLabels[player.UserId]
    if esp then
        if esp.billboard then esp.billboard:Destroy() end
        espLabels[player.UserId] = nil
    end
end

local function refreshESP()
    local cfg = Config['Visual Awareness']
    for userId, esp in pairs(espLabels) do
        local player = esp.player
        if not player or not player.Parent then
            if esp.billboard then esp.billboard:Destroy() end
            espLabels[userId] = nil
            continue
        end

        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")

        if hrp and (not esp.billboard or not esp.billboard.Parent) then
            esp.billboard = makeESPBillboard(player)
        end

        if not esp.billboard then continue end

        local label = esp.billboard:FindFirstChild("NameLabel")
        if not label then continue end

        if not cfg['Enabled'] or not hrp or not humanoid or humanoid.Health <= 0 then
            esp.billboard.Enabled = false
            continue
        end

        local isCurrentTarget = false
        local isTargetVisible = false
        if currentTarget and currentTarget.Parent == char then
            isCurrentTarget = true
            isTargetVisible = canSeeTarget(currentTarget)
        elseif isLocking and not Config['Settings']['Target Aim'] then
            local closest = findClosestTarget()
            if closest and closest.Parent == char then
                isCurrentTarget = true
                isTargetVisible = true
            end
        end

        label.TextColor3 = (isCurrentTarget and isTargetVisible)
            and cfg['Target Color']
            or  cfg['Color']

        label.TextSize = cfg['Text Size']
        label.Font = cfg['Text Font']
        label.TextStrokeTransparency = cfg['Text Stroke'] and cfg['Text Stroke Transparency'] or 1
        label.TextStrokeColor3 = cfg['Text Stroke Color']
        label.Text = cfg['Use Display Name'] and player.DisplayName or player.Name

        esp.billboard.StudsOffset = Vector3.new(0, -3.5, 0)

        esp.billboard.Enabled = true
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        addESPToPlayer(player)
    end

    player.CharacterAdded:Connect(function(char)
        removeESPFromPlayer(player)
        char:WaitForChild("HumanoidRootPart")
        task.wait(0.1)
        addESPToPlayer(player)
    end)

    player.CharacterRemoving:Connect(function()
        removeESPFromPlayer(player)
    end)
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            removeESPFromPlayer(player)
            char:WaitForChild("HumanoidRootPart")
            task.wait(0.1)
            addESPToPlayer(player)
        end)

        player.CharacterRemoving:Connect(function()
            removeESPFromPlayer(player)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESPFromPlayer(player)
end)

RunService.Heartbeat:Connect(function()
    if not Config['Super Jump']['Enabled'] or not superJumpActive then return end
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    if humanoid:GetState() == Enum.HumanoidStateType.Landed or humanoid.FloorMaterial ~= Enum.Material.Air then
        rootPart.Velocity = Vector3.new(rootPart.Velocity.X, Config['Super Jump']['Power'], rootPart.Velocity.Z)
        task.wait(Config['Super Jump']['Cooldown'])
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if isSelfKnocked() and isLocking then
        currentTarget = nil
        isLocking = false
        lastVisibleTarget = nil
        targetLine.Visible = false
    end

    TriggerBot()
    RapidFire()
    updateDesync(dt)

    if SpeedEnabled and Config['Speed']['Enabled'] then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and not isSelfKnocked() then
            local targetSpeed = 16 * Config['Speed']['Multiplier']
            if humanoid.WalkSpeed ~= targetSpeed then
                humanoid.WalkSpeed = targetSpeed
            end
        end

        if Config['Speed']['Anti Fling'] then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.Velocity
                if vel.Y > 50 or vel.Y < -50 then
                    hrp.Velocity = Vector3.new(vel.X, 0, vel.Z)
                end
            end
        end
    end

    if Config['Hitbox Expander']['Enabled'] then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(Config['Hitbox Expander']['Size'], Config['Hitbox Expander']['Size'], Config['Hitbox Expander']['Size'])

                    if Config['Hitbox Expander']['Visualize'] then
                        hrp.Transparency = 0.7
                        hrp.BrickColor = BrickColor.new("Really blue")
                        hrp.Material = "Neon"
                        hrp.CanCollide = false
                    else
                        hrp.Transparency = 1
                    end
                end
            end
        end
    end

    update3DFOVBox()
    updateTargetLine()
    refreshESP()    if Config['Camera Lock']['Enabled'] then
        applyCameraLock()
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if Config['Rapid Fire']['Enabled'] then
            local gun = getrapidgun()
            if gun then
                patchtool(gun)
                isfiring = true
            end
        end
    end

    if processed then return end

    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Target Lock']['Key']] then
        local mode = Config['Keybinds']['Target Lock']['Mode']

        if mode == 'Toggle' then
            if Config['Settings']['Target Aim'] then
                if isLocking then
                    isLocking = false
                    currentTarget = nil
                    lastVisibleTarget = nil
                    targetLine.Visible = false
                else
                    local target = findClosestTarget()
                    if target then
                        currentTarget = target
                        lastVisibleTarget = target
                        isLocking = true
                        update3DFOVBox()
                    end
                end
            else
                isLocking = not isLocking
                if not isLocking then
                    targetLine.Visible = false
                end
            end
        elseif mode == 'Hold' then
            if Config['Settings']['Target Aim'] then
                local target = findClosestTarget()
                if target then
                    currentTarget = target
                    lastVisibleTarget = target
                    isLocking = true
                    update3DFOVBox()
                end
            else
                isLocking = true
            end
        end
    end

    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Trigger Bot']['Key']] then
        local mode = Config['Keybinds']['Trigger Bot']['Mode']

        if mode == 'Toggle' then
            triggerEnabled = not triggerEnabled
        elseif mode == 'Hold' then
            triggerEnabled = true
        end
    end

    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Speed']] then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            if not SpeedEnabled then
                SpeedEnabled = true
            else
                humanoid.WalkSpeed = humanoid:GetAttribute("DefaultWalkSpeed") or 16
                SpeedEnabled = false
            end
        end
    end

    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['ESP']] then
        Config['Visual Awareness']['Enabled'] = not Config['Visual Awareness']['Enabled']
    end

    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Super Jump']] then
        superJumpActive = not superJumpActive
    end

    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Infinite Range']] then
        infRangeActive = not infRangeActive
    end

    if input.KeyCode == Enum.KeyCode[Config['Desync']['Key']] then
        if Config['Desync']['Mode'] == 'Toggle' then
            desyncEnabled = not desyncEnabled
        elseif Config['Desync']['Mode'] == 'Hold' then
            desyncEnabled = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isfiring = false
    end

    if processed then return end

    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Target Lock']['Key']] then
        local mode = Config['Keybinds']['Target Lock']['Mode']

        if mode == 'Hold' then
            isLocking = false
            currentTarget = nil
            lastVisibleTarget = nil
            targetLine.Visible = false
        end
    end

    if input.KeyCode == Enum.KeyCode[Config['Keybinds']['Trigger Bot']['Key']] then
        if Config['Keybinds']['Trigger Bot']['Mode'] == 'Hold' then
            triggerEnabled = false
        end
    end

    if input.KeyCode == Enum.KeyCode[Config['Desync']['Key']] then
        if Config['Desync']['Mode'] == 'Hold' then
            desyncEnabled = false
        end
    end
end)

local knifedata = {}
local toolregistry = {}
local replicatedstorage = game:GetService("ReplicatedStorage")

local knifeskins = {
    ["Golden Age Tanto"] = {soundid = "rbxassetid://5917819099", animationid = "rbxassetid://13473404819", positionoffset = Vector3.new(0, -0.20, -1.2), rotationoffset = Vector3.new(90, 263.7, 180)},
    ["GPO-Knife"] = {soundid = "rbxassetid://4604390759", animationid = "rbxassetid://14014278925", positionoffset = Vector3.new(0.00, -0.32, -1.07), rotationoffset = Vector3.new(90, -97.4, 90)},
    ["GPO-Knife Prestige"] = {soundid = "rbxassetid://4604390759", animationid = "rbxassetid://14014278925", positionoffset = Vector3.new(0.00, -0.32, -1.07), rotationoffset = Vector3.new(90, -97.4, 90)},
    ["Heaven"] = {soundid = "rbxassetid://14489860007", animationid = "rbxassetid://14500266726", positionoffset = Vector3.new(-0.02, -0.82, 0.20), rotationoffset = Vector3.new(64.42, 3.79, 0.00)},
    ["Love Kukri"] = {soundid = "", animationid = "", positionoffset = Vector3.new(-0.14, 0.14, -1.62), rotationoffset = Vector3.new(-90.00, 180.00, -4.97), particle = true, textureid = "rbxassetid://12124159284"},
    ["Purple Dagger"] = {soundid = "rbxassetid://17822743153", animationid = "rbxassetid://17824999722", positionoffset = Vector3.new(-0.13, -0.24, -1.80), rotationoffset = Vector3.new(89.05, 96.63, 180.00)},
    ["Blue Dagger"] = {soundid = "rbxassetid://17822737046", animationid = "rbxassetid://17824995184", positionoffset = Vector3.new(-0.13, -0.24, -1.80), rotationoffset = Vector3.new(89.05, 96.63, 180.00)},
    ["Green Dagger"] = {soundid = "rbxassetid://17822741762", animationid = "rbxassetid://17825004320", positionoffset = Vector3.new(-0.13, -0.24, -1.07), rotationoffset = Vector3.new(89.05, 96.63, 180.00)},
    ["Red Dagger"] = {soundid = "rbxassetid://17822952417", animationid = "rbxassetid://17825008844", positionoffset = Vector3.new(-0.13, -0.24, -1.07), rotationoffset = Vector3.new(89.05, 96.63, 180.00)},
    ["Portal"] = {soundid = "rbxassetid://16058846352", animationid = "rbxassetid://16058633881", positionoffset = Vector3.new(-0.13, -0.35, -0.57), rotationoffset = Vector3.new(89.05, 96.63, 180.00)},
    ["Emerald Butterfly"] = {soundid = "rbxassetid://14931902491", animationid = "rbxassetid://14918231706", positionoffset = Vector3.new(-0.02, -0.30, -0.65), rotationoffset = Vector3.new(180.00, 90.95, 180.00)},
    ["Boy"] = {soundid = "rbxassetid://18765078331", animationid = "rbxassetid://18789158908", positionoffset = Vector3.new(-0.02, -0.09, -0.73), rotationoffset = Vector3.new(89.05, -88.11, 180.00)},
    ["Girl"] = {soundid = "rbxassetid://18765078331", animationid = "rbxassetid://18789162944", positionoffset = Vector3.new(-0.02, -0.16, -0.73), rotationoffset = Vector3.new(89.05, -88.11, 180.00)},
    ["Dragon"] = {soundid = "rbxassetid://14217789230", animationid = "rbxassetid://14217804400", positionoffset = Vector3.new(-0.02, -0.32, -0.98), rotationoffset = Vector3.new(89.05, 90.95, 180.00)},
    ["Void"] = {soundid = "rbxassetid://14756591763", animationid = "rbxassetid://14774699952", positionoffset = Vector3.new(-0.02, -0.22, -0.85), rotationoffset = Vector3.new(180.00, 90.95, 180.00)},
    ["Wild West"] = {soundid = "rbxassetid://16058689026", animationid = "rbxassetid://16058148839", positionoffset = Vector3.new(-0.02, -0.24, -1.15), rotationoffset = Vector3.new(-91.89, 90.95, 180.00)},
    ["Iced Out"] = {soundid = "rbxassetid://14924261405", animationid = "rbxassetid://18465353361", positionoffset = Vector3.new(0.02, -0.08, 0.99), rotationoffset = Vector3.new(180.00, -90.95, -180.00)},
    ["Reptile"] = {soundid = "rbxassetid://18765103349", animationid = "rbxassetid://18788955930", positionoffset = Vector3.new(-0.03, -0.06, -0.92), rotationoffset = Vector3.new(168.63, 90.00, -180.00)},
    ["Emerald"] = {soundid = "", animationid = "", positionoffset = Vector3.new(-0.03, -0.06, -0.92), rotationoffset = Vector3.new(168.63, 90.00, 108.00)},
    ["Ribbon"] = {soundid = "rbxassetid://130974579277249", animationid = "rbxassetid://124102609796063", positionoffset = Vector3.new(0.02, -0.25, -0.05), rotationoffset = Vector3.new(90.00, 0.00, 180.00)},

}

local function clearmesh(tool, exclude)
    for _, v in ipairs(tool:GetChildren()) do
        if v:IsA("MeshPart") and v ~= exclude then
            v:Destroy()
        end
    end
end

local function applygun(tool, name)
    local orig = tool:FindFirstChildOfClass("MeshPart")
    if not orig then return end
    local skinmodules = replicatedstorage:FindFirstChild("SkinModules")
    if not skinmodules then return end
    local ok, req = pcall(function() return require(skinmodules) end)
    if not ok or not req then return end
    local info = req[tool.Name] and req[tool.Name][name]
    if not info then return end
    clearmesh(tool, orig)
    local skinpart = info.TextureID
    if typeof(skinpart) == "Instance" then
        local clone = skinpart:Clone()
        clone.Parent = tool
        clone.CFrame = orig.CFrame
        clone.Name = "CurrentSkin"
        local w = Instance.new("Weld")
        w.Part0 = clone
        w.Part1 = orig
        w.C0 = info.CFrame:Inverse()
        w.Parent = clone
        orig.Transparency = 1
    else
        orig.TextureID = skinpart
        orig.Transparency = 0
    end
    local handle = tool:FindFirstChild("Handle")
    if not handle then return end
    local shoot = handle:FindFirstChild("ShootSound")
    if shoot then
        local skinassets = replicatedstorage:FindFirstChild("SkinAssets")
        if skinassets then
            local gunsounds = skinassets:FindFirstChild("GunShootSounds")
            if gunsounds then
                local sounds = gunsounds:FindFirstChild(tool.Name)
                local obj = sounds and sounds:FindFirstChild(name)
                if obj then shoot.SoundId = obj.Value end
            end
        end
    end
    local skinassets = replicatedstorage:FindFirstChild("SkinAssets")
    if skinassets then
        local particlefolder = skinassets:FindFirstChild("GunHandleParticle")
        if particlefolder then
            local particlesource = particlefolder:FindFirstChild(name)
            if particlesource then
                local pe = particlesource:FindFirstChild("ParticleEmitter")
                if pe then
                    for _, existing in ipairs(handle:GetChildren()) do
                        if existing:IsA("ParticleEmitter") then existing:Destroy() end
                    end
                    pe:Clone().Parent = handle
                end
            end
        end
    end
    handle:SetAttribute("SkinName", name)
end

local function applybat(tool, name)
    local mesh = nil
    for _, v in ipairs(tool:GetDescendants()) do
        if v:IsA("MeshPart") and v.Transparency == 0 then
            mesh = v
            break
        end
    end
    if not mesh then return end
    local skinmodules = replicatedstorage:FindFirstChild("SkinModules")
    if not skinmodules then return end
    local bats = skinmodules:FindFirstChild("Bats")
    if not bats then return end
    local skin = bats:FindFirstChild(name)
    if not skin then return end
    local clone = skin:Clone()
    clone.Parent = tool
    clone.CFrame = mesh.CFrame
    clone.Name = "CurrentSkin"
    local w = Instance.new("Weld")
    w.Part0 = clone
    w.Part1 = mesh
    w.Parent = clone
    mesh.Transparency = 1
end

local function cleanknife(tool)
    local data = knifedata[tool]
    if data then
        if data.track then data.track:Stop() data.track:Destroy() data.track = nil end
        if data.welds then for _, w in ipairs(data.welds) do if w then w:Destroy() end end end
        if data.sounds then for _, s in ipairs(data.sounds) do if s and s.Parent then s:Destroy() end end end
    end
    local mesh = tool:FindFirstChild("Default")
    if mesh then
        for _, v in ipairs(mesh:GetChildren()) do
            if v.Name == "Handle.R" or v:IsA("Model") or (v:IsA("BasePart") and v.Name ~= "Default") then
                v:Destroy()
            end
        end
        mesh.Transparency = 0
    end
    knifedata[tool] = nil
end

local function applyknife(char, tool, skin)
    local skincfg = knifeskins[skin]
    if not skincfg then return end
    local hum = char:FindFirstChild("Humanoid")
    local rhand = char:FindFirstChild("RightHand")
    if not hum or not rhand then return end
    cleanknife(tool)
    knifedata[tool] = {track = nil, welds = {}, sounds = {}}
    local data = knifedata[tool]
    local mesh = tool:FindFirstChild("Default")
    if not mesh then return end
    mesh.Transparency = 1
    local skinmodules = replicatedstorage:FindFirstChild("SkinModules")
    if not skinmodules then return end
    local knives = skinmodules:FindFirstChild("Knives")
    if not knives then return end
    local skinmodel = knives:FindFirstChild(skin)
    if not skinmodel then return end
    local clone = skinmodel:Clone()
    clone.Name = skin
    local handr = Instance.new("Part")
    handr.Name = "Handle.R"
    handr.Transparency = 1
    handr.CanCollide = false
    handr.Anchored = false
    handr.Size = Vector3.new(0.001, 0.001, 0.001)
    handr.Massless = true
    handr.Parent = mesh
    local m6d = Instance.new("Motor6D")
    m6d.Name = "Handle.R"
    m6d.Part0 = rhand
    m6d.Part1 = handr
    m6d.Parent = handr
    local offset = CFrame.new(skincfg.positionoffset) * CFrame.Angles(math.rad(skincfg.rotationoffset.X), math.rad(skincfg.rotationoffset.Y), math.rad(skincfg.rotationoffset.Z))
    if clone:IsA("Model") then
        if not clone.PrimaryPart then
            for _, c in ipairs(clone:GetChildren()) do
                if c:IsA("BasePart") then clone.PrimaryPart = c break end
            end
        end
        if clone.PrimaryPart then
            for _, p in ipairs(clone:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false p.Massless = true p.Anchored = false
                    local w = Instance.new("Weld")
                    w.Part0 = handr w.Part1 = p
                    w.C0 = offset
                    w.C1 = p.CFrame:ToObjectSpace(clone.PrimaryPart.CFrame)
                    w.Parent = p
                    table.insert(data.welds, w)
                end
            end
        end
        clone.Parent = mesh
    elseif clone:IsA("BasePart") then
        clone.CanCollide = false clone.Massless = true clone.Anchored = false
        if clone:IsA("MeshPart") and skincfg.textureid then clone.TextureID = skincfg.textureid end
        if skincfg.particle then
            local skinassets = replicatedstorage:FindFirstChild("SkinAssets")
            if skinassets then
                local pf = skinassets:FindFirstChild("GunHandleParticle")
                if pf then
                    local ps = pf:FindFirstChild(skin)
                    if ps then
                        local pe = ps:FindFirstChild("ParticleEmitter")
                        if pe then pe:Clone().Parent = clone end
                    end
                end
            end
        end
        clone.Parent = mesh
        local w = Instance.new("Weld")
        w.Part0 = handr w.Part1 = clone w.C0 = offset w.Parent = clone
        table.insert(data.welds, w)
    end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then animator = Instance.new("Animator") animator.Parent = hum end
    if skincfg.animationid and skincfg.animationid ~= "" then
        local anim = Instance.new("Animation")
        anim.AnimationId = skincfg.animationid
        local track = animator:LoadAnimation(anim)
        track.Looped = false track:Play()
        data.track = track anim:Destroy()
        track.Ended:Once(function()
            if data.track == track then data.track = nil end
            track:Destroy()
        end)
    end
    if skincfg.soundid and skincfg.soundid ~= "" then
        local snd = Instance.new("Sound")
        snd.SoundId = skincfg.soundid snd.Parent = Workspace snd:Play()
        table.insert(data.sounds, snd)
        snd.Ended:Connect(function() snd:Destroy() end)
    end
    tool:SetAttribute("CurrentKnifeSkin", skin)
end

local function setuptool(tool)
    if not tool:IsA("Tool") then return end
    if toolregistry[tool] then return end
    toolregistry[tool] = true

    tool.Equipped:Connect(function()
        if not Config['Skins']['Enabled'] then return end
        local char = tool.Parent
        if char ~= LocalPlayer.Character then return end
        local skin = Config['Skins']['Weapons'][tool.Name]
        if not skin or skin == "" then return end
        if tool.Name == "[Knife]" then
            applyknife(char, tool, skin)
        elseif tool.Name == "[Bat]" then
            applybat(tool, skin)
        else
            applygun(tool, skin)
        end
    end)

    tool.Unequipped:Connect(function()
        if tool.Name == "[Knife]" then
            local data = knifedata[tool]
            if not data then return end
            if data.welds then
                for _, w in ipairs(data.welds) do if w then w:Destroy() end end
                data.welds = {}
            end
            if data.sounds then
                for _, s in ipairs(data.sounds) do if s and s.Parent then s:Destroy() end end
                data.sounds = {}
            end
            local mesh = tool:FindFirstChild("Default")
            if mesh then
                for _, v in ipairs(mesh:GetChildren()) do
                    if v.Name == "Handle.R" or v:IsA("Model") or (v:IsA("MeshPart") and v.Name ~= "Default") then
                        v:Destroy()
                    end
                end
                mesh.Transparency = 0
            end
        end
    end)

    if tool.Parent == LocalPlayer.Character then
        if not Config['Skins']['Enabled'] then return end
        local skin = Config['Skins']['Weapons'][tool.Name]
        if skin and skin ~= "" then
            task.spawn(function()
                if tool.Name == "[Knife]" then
                    applyknife(LocalPlayer.Character, tool, skin)
                elseif tool.Name == "[Bat]" then
                    applybat(tool, skin)
                else
                    applygun(tool, skin)
                end
            end)
        end
    end
end

local function watchchar(char)
    if not char then return end
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("Tool") then setuptool(v) end
    end
    char.ChildAdded:Connect(function(v)
        if v:IsA("Tool") then setuptool(v) end
    end)
end

if LocalPlayer.Character then
    watchchar(LocalPlayer.Character)
    if Config['Rapid Fire']['Enabled'] then
        local gun = getrapidgun()
        if gun then patchtool(gun) end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    SpeedEnabled = false
    task.wait(0.5)
    watchchar(char)
    char.ChildAdded:Connect(function(tool)
        if tool:IsA("Tool") and Config['Rapid Fire']['Enabled'] then
            task.wait(0.1)
            patchtool(tool)
        end
    end)
end)
