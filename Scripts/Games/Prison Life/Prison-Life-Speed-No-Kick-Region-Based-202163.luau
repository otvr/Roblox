-- https://scriptblox.com/script/Prison-Life-Speed-No-Kick-Region-Based-202163

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local subRegions = {
    {cx=752.77,  cz=2571.80, hx=109.93/2, hz=13.60/2},
    {cx=701.15,  cz=2313.70, hx=69.10/2,  hz=163.00/2},
    {cx=917.30,  cz=2392.60, hx=107.00/2, hz=28.00/2},
    {cx=830.30,  cz=2242.55, hx=58.00/2,  hz=34.10/2},
    {cx=748.90,  cz=2340.60, hx=59.40/2,  hz=109.20/2},
    {cx=799.10,  cz=2299.00, hx=14.00/2,  hz=33.99/2},
    {cx=826.69,  cz=2338.60, hx=51.19/2,  hz=12.00/2},
    {cx=799.65,  cz=2269.23, hx=12.90/2,  hz=21.50/2},
    {cx=765.36,  cz=2247.57, hx=59.32/2,  hz=64.82/2},
    {cx=850.20,  cz=2571.80, hx=23.20/2,  hz=13.60/2},
    {cx=779.80,  cz=2479.80, hx=164.00/2, hz=170.40/2},
    {cx=983.35,  cz=2315.15, hx=31.10/2,  hz=58.90/2},
    {cx=916.50,  cz=2225.40, hx=99.00/2,  hz=38.00/2},
    {cx=889.80,  cz=2361.60, hx=220.00/2, hz=34.00/2},
    {cx=915.80,  cz=2456.60, hx=64.00/2,  hz=100.00/2},
    {cx=820.80,  cz=2386.60, hx=82.00/2,  hz=16.00/2},
    {cx=916.90,  cz=2294.50, hx=98.20/2,  hz=100.20/2},
    {cx=836.95,  cz=2296.10, hx=61.70/2,  hz=73.00/2},
    {cx=872.30,  cz=2463.60, hx=19.00/2,  hz=62.00/2},
    {cx=959.30,  cz=2463.60, hx=19.00/2,  hz=62.00/2},
}

local prison = {cx=773.62, cz=2327.43, hx=563.37/2, hz=540.30/2}

local function inBox(x, z, r)
    return math.abs(x - r.cx) <= r.hx and math.abs(z - r.cz) <= r.hz
end

local function isInSubRegion(x, z)
    for _, r in ipairs(subRegions) do
        if inBox(x, z, r) then return true end
    end
    return false
end

-- 1. Delete the Global Anti-Noclip once (this persists locally until you rejoin the game entirely)
local scriptsFolder = ReplicatedStorage:FindFirstChild("Scripts")
if scriptsFolder then
    local CharacterCollision = scriptsFolder:FindFirstChild("CharacterCollision")
    if CharacterCollision then
        CharacterCollision:Destroy()
        print("Successfully Bypassed Global Anti-Noclip! By Tomato")
    else
        print("Global Anti-Noclip Already Bypassed or Failed.")
    end
end

-- 2. Setup the Character Hook
local function SetupCharacter(Character)
    -- Wait for required character parts to load
    local Humanoid = Character:WaitForChild("Humanoid")
    local RootPart = Character:WaitForChild("HumanoidRootPart")
    local Head = Character:WaitForChild("Head")
    
    local originalJumpHeight = Humanoid.JumpHeight

    -- Apply Infinite Stamina Bypass
    task.spawn(function()
        local Jump = Humanoid:GetPropertyChangedSignal("Jump")
        task.wait(1)
        for _, Connection in getconnections(Jump) do
            Connection:Disable()
        end
        print("Infinite Stamina Active for respawned character")
    end)
    
    -- Apply Local Anti-Noclip Bypass on Head
    task.spawn(function()
        for _, Connection in getconnections(Head:GetPropertyChangedSignal("CanCollide")) do
            Connection:Disable()
        end
    end)

    -- Region Speed/Jump Loop
    task.spawn(function()
        -- The loop will naturally break when the character dies because Humanoid.Health goes to 0
        while Character and Character.Parent and Humanoid.Health > 0 do
            task.wait()
            local x, z = RootPart.Position.X, RootPart.Position.Z

            if isInSubRegion(x, z) then
                Humanoid.WalkSpeed = 32
                Humanoid.JumpHeight = originalJumpHeight
            elseif inBox(x, z, prison) then
                Humanoid.WalkSpeed = 50
                Humanoid.JumpHeight = 25
            else
                Humanoid.WalkSpeed = 100
                Humanoid.JumpHeight = 50
            end
        end
    end)
end

-- 3. Connect the Hook to respawns
LocalPlayer.CharacterAdded:Connect(SetupCharacter)

-- 4. Apply to the current character if it already exists
if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end
