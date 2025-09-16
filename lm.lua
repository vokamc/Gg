-- V550

repeat task.wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.PlayerGui.Interface.FishingCatchFrame.TimingBar.SuccessArea:GetPropertyChangedSignal("Size"):Connect(function()
    game:GetService("Players").LocalPlayer.PlayerGui.Interface.FishingCatchFrame.TimingBar.SuccessArea.Position = UDim2.new(0.5,0,0,0)
    game:GetService("Players").LocalPlayer.PlayerGui.Interface.FishingCatchFrame.TimingBar.SuccessArea.Size = UDim2.new(1,0,1,0)
end)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local effect = Lighting:FindFirstChild("VibrantEffect")
local vibrantEffect = Lighting:FindFirstChild("VibrantEffect")
local RunService = game:GetService("RunService")

Lighting.ClockTime = 14
Lighting.GlobalShadows = false

WindUI:AddTheme({
    Name = "Dark",
    Accent = "#18181b",
    Dialog = "#18181b", 
    Outline = "#FFFFFF",
    Text = "#FFFFFF",
    Placeholder = "#999999",
    Background = "#0e0e10",
    Button = "#52525b",
    Icon = "#a1a1aa",
})

WindUI:AddTheme({
    Name = "Light",
    Accent = "#f4f4f5",
    Dialog = "#f4f4f5",
    Outline = "#000000", 
    Text = "#000000",
    Placeholder = "#666666",
    Background = "#ffffff",
    Button = "#e4e4e7",
    Icon = "#52525b",
})

WindUI:AddTheme({
    Name = "Gray",
    Accent = "#374151",
    Dialog = "#374151",
    Outline = "#d1d5db", 
    Text = "#f9fafb",
    Placeholder = "#9ca3af",
    Background = "#1f2937",
    Button = "#4b5563",
    Icon = "#d1d5db",
})

WindUI:AddTheme({
    Name = "Blue",
    Accent = "#1e40af",
    Dialog = "#1e3a8a",
    Outline = "#93c5fd", 
    Text = "#f0f9ff",
    Placeholder = "#60a5fa",
    Background = "#1e293b",
    Button = "#3b82f6",
    Icon = "#93c5fd",
})

WindUI:AddTheme({
    Name = "Green",
    Accent = "#059669",
    Dialog = "#047857",
    Outline = "#6ee7b7", 
    Text = "#ecfdf5",
    Placeholder = "#34d399",
    Background = "#064e3b",
    Button = "#10b981",
    Icon = "#6ee7b7",
})

WindUI:AddTheme({
    Name = "Purple",
    Accent = "#7c3aed",
    Dialog = "#6d28d9",
    Outline = "#c4b5fd", 
    Text = "#faf5ff",
    Placeholder = "#a78bfa",
    Background = "#581c87",
    Button = "#8b5cf6",
    Icon = "#c4b5fd",
})

WindUI:SetNotificationLower(true)

local themes = {"Dark", "Light", "Gray", "Blue", "Green", "Purple"}
local currentThemeIndex = 1

if not getgenv().TransparencyEnabled then
    getgenv().TransparencyEnabled = true
end

-- combat

local scan_map = false

local killAuraToggle = false
local chopAuraToggle = false
local auraRadius = 50
local currentammount = 0

local toolsDamageIDs = {
    ["Old Axe"] = "3_7367831688",
    ["Good Axe"] = "112_7367831688",
    ["Strong Axe"] = "116_7367831688",
    ["Ice Axe"] = "116_7367831688",
    ["Admin Axe"] = "116_7367831688",
    ["Morningstar"] = "116_7367831688",
    ["Laser Sword"] = "116_7367831688",
    ["Ice Sword"] = "116_7367831688",
    ["Katana"] = "116_7367831688",
    ["Trident"] = "116_7367831688",
    ["Poison Spear"] = "116_7367831688",
    ["Chainsaw"] = "647_8992824875",
    ["Spear"] = "196_8999010016"
}

-- auto food

local autoFeedToggle = false
local selectedFood = {}
local hungerThreshold = 75
local alwaysFeedEnabledItems = {}
local alimentos = {
    "Apple",
    "Berry",
    "Carrot",
    "Cake",
    "Chili",
	"Cooked Clownfish", 
	"Cooked Swordfish", 
	"Cooked Jellyfish", 
	"Cooked Char", 
	"Cooked Eel", 
	"Cooked Shark"
    "Cooked Ribs",
    "Cooked Mackerel",
    "Cooked Salmon",
    "Cooked Morsel",
    "Cooked Steak"
}

-- esp

local ie = {
    "Bandage", "Bolt", "Broken Fan", "Broken Microwave", "Cake", "Carrot", "Chair", "Coal", "Coin Stack",
    "Cooked Morsel", "Cooked Steak", "Fuel Canister", "Iron Body", "Leather Armor", "Log", "MadKit", "Metal Chair",
    "MedKit", "Old Car Engine", "Old Flashlight", "Old Radio", "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo",
    "Morsel", "Sheet Metal", "Steak", "Tyre", "Washing Machine", "Cultist Gem", "Gem of the Forest Fragment", "Frozen Shuriken",
	"Tactical Shotgun", "Snowball", "Kunai"
}
local me = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Crossbow Cultist", "Alien", "Alien Elite", "Polar Bear", "Arctic Fox", "Mammoth", "Cultist", "Cultist Melee", "Cultist Crossbow", "Cultist Juggernaut"}

-- bring
local BlueprintItems = {"Crafting Blueprint", "Defense Blueprint", "Furniture Blueprint"}
local selectedBlueprintItems = {}
local PeltsItems = {"Bunny Foot", "Wolf Pelt", "Alpha Wolf Pelt", "Bear Pelt", "Arctic Fox Pelt", "Polar Bear Pelt"}
local selectedPeltsItems = {}
local junkItems = {"Bolt", "Sheet Metal", "UFO Junk", "UFO Component", "Broken Fan", "Old Radio", "Broken Microwave", "Tyre", "Metal Chair", "Old Car Engine", "Washing Machine", "Cultist Experiment", "Cultist Prototype", "UFO Scrap", "Cultist Gem", "Gem of the Forest Fragment", "Feather", "Old Boot"}
local selectedJunkItems = {}
local fuelItems = {"Log", "Chair", "Coal", "Fuel Canister", "Oil Barrel"}
local selectedFuelItems = {}
local foodItems = {"Cake", "Cooked Steak", "Cooked Morsel", "Ribs", "Salmon", "Cooked Salmon", "Cooked Ribs", "Mackerel", "Cooked Mackerel", "Steak", "Morsel", "Berry", "Carrot", "Stew", "Hearty Stew", "Corn", "Pumpkin", "Meat? Sandwich", "Pumpkin", "Seafood Chowder", "Steak Dinner", "Pumpkin Soup", "BBQ Ribs", "Carrot Cake", "Jar o’ Jelly", "Mackerel", "Salmon", "Clownfish", "Swordfish", "Jellyfish", "Char", "Eel", "Shark"	"Cooked Clownfish", "Cooked Swordfish", "Cooked Jellyfish", "Cooked Char", "Cooked Eel", "Cooked Shark"}
local selectedFoodItems = {}
local medicalItems = {"Bandage", "MedKit"}
local selectedMedicalItems = {}
local equipmentItems = {"Revolver", "Rifle", "Revolver Ammo", "Rifle Ammo", "Giant Sack", "Good Sack", "Strong Axe", "Good Axe", "Frozen Shuriken", "Tactical Shotgun", "Snowball", "Kunai", "Leather Body", "Poison Armour", "Iron Body", "Thorn Body", "Riot Shield", "Alien Armour", "Red Key", "Blue Key", "Yellow Key", "Grey Key", "Frog Key", "Chili Seeds", "Flower Seeds", "Berry Seeds", "Firefly Seeds", "Old Rod", "Good Rod", "Strong Rod"}
local selectedEquipmentItems = {}

local isCollecting = false
local originalPosition = nil
local autoBringEnabled = false

-- Toggle states for each category
local BlueprintToggleEnabled = false
local PeltsToggleEnabled = false
local junkToggleEnabled = false
local fuelToggleEnabled = false
local foodToggleEnabled = false
local medicalToggleEnabled = false
local equipmentToggleEnabled = false

-- Loop control variables to properly stop threads
local BlueprintLoopRunning = false
local PeltsLoopRunning = false
local junkLoopRunning = false
local fuelLoopRunning = false
local foodLoopRunning = false
local medicalLoopRunning = false
local equipmentLoopRunning = false

-- Enhanced smooth pulling movement with easing
local function smoothPullToItem(startPos, endPos, duration)
    local player = game.Players.LocalPlayer
    local hrp = player.Character.HumanoidRootPart
    
    local startTime = tick()
    local distance = (endPos.Position - startPos.Position).Magnitude
    local direction = (endPos.Position - startPos.Position).Unit
    
    -- Create smooth pulling effect with easing
    spawn(function()
        while tick() - startTime < duration do
            local elapsed = tick() - startTime
            local progress = elapsed / duration
            
            -- Ease-in-out function for smooth acceleration and deceleration
            local easedProgress = progress < 0.5 
                and 2 * progress * progress 
                or 1 - math.pow(-2 * progress + 2, 2) / 2
            
            local currentPos = startPos.Position:lerp(endPos.Position, easedProgress)
            local lookDirection = endPos.Position - currentPos
            
            if lookDirection.Magnitude > 0 then
                hrp.CFrame = CFrame.lookAt(currentPos, currentPos + lookDirection.Unit)
            else
                hrp.CFrame = CFrame.new(currentPos)
            end
            
            wait()
        end
        
        -- Ensure exact final position
        hrp.CFrame = endPos
    end)
    
    wait(duration)
end

-- Enhanced item pulling effect
local function createItemPullEffect(itemPart, targetPos, duration)
    if not itemPart or not itemPart.Parent then return end
    
    local startPos = itemPart.Position
    local startTime = tick()
    
    spawn(function()
        while tick() - startTime < duration do
            if not itemPart or not itemPart.Parent then break end
            
            local elapsed = tick() - startTime
            local progress = elapsed / duration
            
            -- Ease-out effect for item pulling
            local easedProgress = 1 - math.pow(1 - progress, 3)
            
            local currentPos = Vector3.new(
                startPos.X + (targetPos.X - startPos.X) * easedProgress,
                startPos.Y + (targetPos.Y - startPos.Y) * easedProgress,
                startPos.Z + (targetPos.Z - startPos.Z) * easedProgress
            )
            
            pcall(function()
                itemPart.CFrame = CFrame.new(currentPos)
                itemPart.Velocity = Vector3.new(0, 0, 0)
                itemPart.AngularVelocity = Vector3.new(0, 0, 0)
            end)
            
            wait()
        end
        
        -- Final position
        pcall(function()
            itemPart.CFrame = CFrame.new(targetPos)
            itemPart.Velocity = Vector3.new(0, 0, 0)
            itemPart.AngularVelocity = Vector3.new(0, 0, 0)
        end)
    end)
    
    wait(duration)
end

-- Enhanced bypass system with smooth pulling (no noclip)
local function bypassBringSystem(items, stopFlag)
    if isCollecting then 
        return 
    end
    
    isCollecting = true
    local player = game.Players.LocalPlayer
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then 
        isCollecting = false
        return 
    end
    
    local hrp = player.Character.HumanoidRootPart
    originalPosition = hrp.CFrame
    
    for _, itemName in ipairs(items) do
        -- Check if we should stop
        if stopFlag and not stopFlag() then
            break
        end
        
        local itemsFound = {}
        
        -- Find all items with this name
        for _, item in ipairs(workspace:GetDescendants()) do
            if item.Name == itemName and (item:IsA("BasePart") or item:IsA("Model")) then
                local itemPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
                if itemPart and itemPart.Parent ~= player.Character then
                    table.insert(itemsFound, {item = item, part = itemPart})
                end
            end
        end
        
        -- Process each found item
        for _, itemData in ipairs(itemsFound) do
            -- Check if we should stop again
            if stopFlag and not stopFlag() then
                break
            end
            
            local item = itemData.item
            local itemPart = itemData.part
            
            if itemPart and itemPart.Parent then
                -- Step 1: Smooth pull to item location with anticipation
                local itemPos = itemPart.CFrame + Vector3.new(0, 5, 0)
                smoothPullToItem(hrp.CFrame, itemPos, 1.2) -- Smooth 1.2 second pull
                
                -- Step 2: Create magnetic pull effect for item
                local playerPos = hrp.Position + Vector3.new(0, -1, 0)
                createItemPullEffect(itemPart, playerPos, 0.8)
                
                -- Step 3: Smooth return journey with item following
                local keepAttached = true
                spawn(function()
                    while keepAttached do
                        if stopFlag and not stopFlag() then
                            keepAttached = false
                            break
                        end
                        
                        if itemPart and itemPart.Parent and hrp and hrp.Parent then
                            pcall(function()
                                local offset = Vector3.new(
                                    math.sin(tick() * 2) * 0.5, -- Slight floating motion
                                    -1 + math.cos(tick() * 3) * 0.2,
                                    math.cos(tick() * 2) * 0.5
                                )
                                itemPart.CFrame = CFrame.new(hrp.Position + offset)
                                itemPart.Velocity = Vector3.new(0, 0, 0)
                                itemPart.AngularVelocity = Vector3.new(0, 0, 0)
                            end)
                        end
                        wait(0.03)
                    end
                end)
                
                -- Smooth return to original position
                smoothPullToItem(hrp.CFrame, originalPosition, 1.0)
                
                -- Stop attachment and place item nearby with gentle landing
                keepAttached = false
                wait(0.1)
                
                pcall(function()
                    local landingPos = originalPosition.Position + Vector3.new(
                        math.random(-4, 4), 
                        2, 
                        math.random(-4, 4)
                    )
                    
                    -- Gentle item placement
                    createItemPullEffect(itemPart, landingPos, 0.5)
                end)
            end
            
            wait(0.5) -- Pause between items
        end
    end
    
    -- Ensure player is at original position
    if originalPosition then
        hrp.CFrame = originalPosition
    end
    
    isCollecting = false
end

-- auto upgrade campfire

local campfireFuelItems = {"Log", "Coal", "Chair", "Fuel Canister", "Oil Barrel", "Biofuel"}
local campfireDropPos = Vector3.new(0, 19, 0)
local selectedCampfireItem = nil -- Single item storage
local autoUpgradeCampfireEnabled = false

-- Added New
local scrapjunkItems = {"Log", "Chair", "Tyre", "Bolt", "Broken Fan", "Broken Microwave", "Sheet Metal", "Old Radio", "Washing Machine", "Old Car Engine", "Cultist Gem", "Gem of the Forest Fragment"}
local autoScrapPos = Vector3.new(21, 20, -5)
local selectedScrapItem = nil
local autoScrapItemsEnabled = false
-- auto cook

local autocookItems = {"Morsel", "Steak", "Ribs", "Salmon", "Mackerel"}
local autoCookEnabledItems = {}
local autoCookEnabled = false

local function getAnyToolWithDamageID(isChopAura)
    for toolName, damageID in pairs(toolsDamageIDs) do
        if isChopAura and toolName ~= "Old Axe" and toolName ~= "Good Axe" and toolName ~= "Strong Axe" and toolName ~= "Ice Axe" and toolName ~= "Chainsaw" then
            continue
        end
        local tool = LocalPlayer:FindFirstChild("Inventory") and LocalPlayer.Inventory:FindFirstChild(toolName)
        if tool then
            return tool, damageID
        end
    end
    return nil, nil
end

local function equipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").EquipItemHandle:FireServer("FireAllClients", tool)
    end
end

local function unequipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").UnequipItemHandle:FireServer("FireAllClients", tool)
    end
end

local function killAuraLoop()
    while killAuraToggle do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, damageID = getAnyToolWithDamageID(false)
            if tool and damageID then
                equipTool(tool)
                for _, mob in ipairs(Workspace.Characters:GetChildren()) do
                    if mob:IsA("Model") then
                        local part = mob:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= auraRadius then
                            pcall(function()
                                ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                    mob,
                                    tool,
                                    damageID,
                                    CFrame.new(part.Position)
                                )
                            end)
                        end
                    end
                end
                task.wait(0.1)
            else
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end

local AutoPlantToggle = false

local function autoplant()
    while AutoPlantToggle do
        local args = {
            Instance.new("Model"),
            Vector3.new(-41.2053, 1.0633, 29.2236)
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("RemoteEvents")
            :WaitForChild("RequestPlantItem")
            :InvokeServer(unpack(args))
        task.wait(1)
    end
end

local function chopAuraLoop()
    while chopAuraToggle do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, baseDamageID = getAnyToolWithDamageID(true)
            if tool and baseDamageID then
                equipTool(tool)
                currentammount = currentammount + 1
                local trees = {}
                local map = Workspace:FindFirstChild("Map")
                if map then
                    if map:FindFirstChild("Foliage") then
                        for _, obj in ipairs(map.Foliage:GetChildren()) do
                            if obj:IsA("Model") and (obj.Name == "Small Tree" or obj.Name == "Snowy Small Tree") then
                                table.insert(trees, obj)
                            end
                        end
                    end
                    if map:FindFirstChild("Landmarks") then
                        for _, obj in ipairs(map.Landmarks:GetChildren()) do
                            if obj:IsA("Model") and obj.Name == "Small Tree" then
                                table.insert(trees, obj)
                            end
                        end
                    end
                end
                for _, tree in ipairs(trees) do
                    local trunk = tree:FindFirstChild("Trunk")
                    if trunk and trunk:IsA("BasePart") and (trunk.Position - hrp.Position).Magnitude <= auraRadius then
                        local alreadyammount = false
                        task.spawn(function()
                            while chopAuraToggle and tree and tree.Parent and not alreadyammount do
                                alreadyammount = true
                                currentammount = currentammount + 1
                                pcall(function()
                                    ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                        tree,
                                        tool,
                                        tostring(currentammount) .. "_7367831688",
                                        CFrame.new(-2.962610244751, 4.5547881126404, -75.950843811035, 0.89621275663376, -1.3894891459643e-08, 0.44362446665764, -7.994568895775e-10, 1, 3.293635941759e-08, -0.44362446665764, -2.9872644802253e-08, 0.89621275663376)
                                    )
                                end)
                                task.wait(0.5)
                            end
                        end)
                    end
                end
                task.wait(0.1)
            else
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end

function wiki(nome)
    local c = 0
    for _, i in ipairs(Workspace.Items:GetChildren()) do
        if i.Name == nome then
            c = c + 1
        end
    end
    return c
end

function ghn()
    return math.floor(LocalPlayer.PlayerGui.Interface.StatBars.HungerBar.Bar.Size.X.Scale * 100)
end

function feed(nome)
    for _, item in ipairs(Workspace.Items:GetChildren()) do
        if item.Name == nome then
            ReplicatedStorage.RemoteEvents.RequestConsumeItem:InvokeServer(item)
            break
        end
    end
end

function notifeed(nome)
    WindUI:Notify({
        Title = "Auto Food Paused",
        Content = "The food is gone",
        Duration = 3
    })
end

local function moveItemToPos(item, position)
    if not item or not item:IsDescendantOf(workspace) or not item:IsA("BasePart") and not item:IsA("Model") then return end
    local part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")) or item
    if not part or not part:IsA("BasePart") then return end

    if item:IsA("Model") and not item.PrimaryPart then
        pcall(function() item.PrimaryPart = part end)
    end

    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents").RequestStartDraggingItem:FireServer(item)
        if item:IsA("Model") then
            item:SetPrimaryPartCFrame(CFrame.new(position))
        else
            part.CFrame = CFrame.new(position)
        end
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents").StopDraggingItem:FireServer(item)
    end)
end

local function getChests()
    local chests = {}
    local chestNames = {}
    local index = 1
    for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
        if item.Name:match("^Item Chest") and not item:GetAttribute("8721081708ed") then
            table.insert(chests, item)
            table.insert(chestNames, "Chest " .. index)
            index = index + 1
        end
    end
    return chests, chestNames
end

local currentChests, currentChestNames = getChests()
local selectedChest = currentChestNames[1] or nil

local function getMobs()
    local mobs = {}
    local mobNames = {}
    local index = 1
    for _, character in ipairs(workspace:WaitForChild("Characters"):GetChildren()) do
        if character.Name:match("^Lost Child") and character:GetAttribute("Lost") == true then
            table.insert(mobs, character)
            table.insert(mobNames, character.Name)
            index = index + 1
        end
    end
    return mobs, mobNames
end

local currentMobs, currentMobNames = getMobs()
local selectedMob = currentMobNames[1] or nil

function tp1()
	(game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart").CFrame =
CFrame.new(0.43132782, 15.77634621, -1.88620758, -0.270917892, 0.102997094, 0.957076371, 0.639657021, 0.762253821, 0.0990355015, -0.719334781, 0.639031112, -0.272391081)
end

local function tp2()
    local targetPart = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Landmarks")
        and workspace.Map.Landmarks:FindFirstChild("Stronghold")
        and workspace.Map.Landmarks.Stronghold:FindFirstChild("Functional")
        and workspace.Map.Landmarks.Stronghold.Functional:FindFirstChild("EntryDoors")
        and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors:FindFirstChild("DoorRight")
        and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors.DoorRight:FindFirstChild("Model")
    if targetPart then
        local children = targetPart:GetChildren()
        local destination = children[5]
        if destination and destination:IsA("BasePart") then
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = destination.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end

local flyToggle = false
local flySpeed = 1
local FLYING = false
local flyKeyDown, flyKeyUp, mfly1, mfly2
local IYMouse = game:GetService("UserInputService")

-- Fly pc
local function sFLY()
    repeat task.wait() until Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    repeat task.wait() until IYMouse
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect(); flyKeyUp:Disconnect() end

    local T = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = flySpeed

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while FLYING do
                task.wait()
                if not flyToggle and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                    Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
                end
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = flySpeed
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                BG.CFrame = workspace.CurrentCamera.CoordinateFrame
            end
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()
            if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
            end
        end)
    end
    flyKeyDown = IYMouse.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local KEY = input.KeyCode.Name
            if KEY == "W" then
                CONTROL.F = flySpeed
            elseif KEY == "S" then
                CONTROL.B = -flySpeed
            elseif KEY == "A" then
                CONTROL.L = -flySpeed
            elseif KEY == "D" then 
                CONTROL.R = flySpeed
            elseif KEY == "E" then
                CONTROL.Q = flySpeed * 2
            elseif KEY == "Q" then
                CONTROL.E = -flySpeed * 2
            end
            pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
        end
    end)
    flyKeyUp = IYMouse.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local KEY = input.KeyCode.Name
            if KEY == "W" then
                CONTROL.F = 0
            elseif KEY == "S" then
                CONTROL.B = 0
            elseif KEY == "A" then
                CONTROL.L = 0
            elseif KEY == "D" then
                CONTROL.R = 0
            elseif KEY == "E" then
                CONTROL.Q = 0
            elseif KEY == "Q" then
                CONTROL.E = 0
            end
        end
    end)
    FLY()
end

-- Fly mobile
local function NOFLY()
    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp then flyKeyUp:Disconnect() end
    if mfly1 then mfly1:Disconnect() end
    if mfly2 then mfly2:Disconnect() end
    if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
    end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local function UnMobileFly()
    pcall(function()
        FLYING = false
        local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        if root:FindFirstChild("BodyVelocity") then root:FindFirstChild("BodyVelocity"):Destroy() end
        if root:FindFirstChild("BodyGyro") then root:FindFirstChild("BodyGyro"):Destroy() end
        if Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
            Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
        end
        if mfly1 then mfly1:Disconnect() end
        if mfly2 then mfly2:Disconnect() end
    end)
end

local function MobileFly()
    UnMobileFly()
    FLYING = true

    local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    local v3none = Vector3.new()
    local v3zero = Vector3.new(0, 0, 0)
    local v3inf = Vector3.new(9e9, 9e9, 9e9)

    local controlModule = require(Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    local bv = Instance.new("BodyVelocity")
    bv.Name = "BodyVelocity"
    bv.Parent = root
    bv.MaxForce = v3zero
    bv.Velocity = v3zero

    local bg = Instance.new("BodyGyro")
    bg.Name = "BodyGyro"
    bg.Parent = root
    bg.MaxTorque = v3inf
    bg.P = 1000
    bg.D = 50

    mfly1 = Players.LocalPlayer.CharacterAdded:Connect(function()
        local newRoot = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        local newBv = Instance.new("BodyVelocity")
        newBv.Name = "BodyVelocity"
        newBv.Parent = newRoot
        newBv.MaxForce = v3zero
        newBv.Velocity = v3zero

        local newBg = Instance.new("BodyGyro")
        newBg.Name = "BodyGyro"
        newBg.Parent = newRoot
        newBg.MaxTorque = v3inf
        newBg.P = 1000
        newBg.D = 50
    end)

    mfly2 = game:GetService("RunService").RenderStepped:Connect(function()
        root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        camera = workspace.CurrentCamera
        if Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild("BodyVelocity") and root:FindFirstChild("BodyGyro") then
            local humanoid = Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            local VelocityHandler = root:FindFirstChild("BodyVelocity")
            local GyroHandler = root:FindFirstChild("BodyGyro")

            VelocityHandler.MaxForce = v3inf
            GyroHandler.MaxTorque = v3inf
            humanoid.PlatformStand = true
            GyroHandler.CFrame = camera.CoordinateFrame
            VelocityHandler.Velocity = v3none

            local direction = controlModule:GetMoveVector()
            if direction.X > 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * (flySpeed * 50))
            end
            if direction.X < 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * (flySpeed * 50))
            end
            if direction.Z > 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * (flySpeed * 50))
            end
            if direction.Z < 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * (flySpeed * 50))
            end
        end
    end)
end

-- Player TP to Items Bring System
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Function to teleport player to item, pick it up, then return with item
local function bringItemsByPlayerTP(itemNames, originalPosition)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return 
    end
    
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local itemsFound = {}
    
    -- Collect all matching items first
    for _, itemName in ipairs(itemNames) do
        for _, item in ipairs(workspace:GetDescendants()) do
            if item.Name == itemName and (item:IsA("BasePart") or item:IsA("Model")) then
                local part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
                if part and part:IsA("BasePart") then
                    table.insert(itemsFound, {item = item, part = part})
                end
            end
        end
    end
    
    -- Process each item
    for i, itemData in ipairs(itemsFound) do
        local item = itemData.item
        local part = itemData.part
        
        -- Check if item still exists
        if item and item.Parent and part then
            -- Step 1: Teleport player to the item
            local itemPosition = part.Position + Vector3.new(0, 3, 0) -- Slightly above item
            hrp.CFrame = CFrame.new(itemPosition)
            
            task.wait(0.2) -- Wait a moment for teleport to register
            
            -- Step 2: Start dragging the item (this attaches it to player)
            pcall(function()
                ReplicatedStorage:WaitForChild("RemoteEvents").RequestStartDraggingItem:FireServer(item)
            end)
            
            task.wait(0.3) -- Wait for item to attach
            
            -- Step 3: Teleport back to original position with the item
            hrp.CFrame = CFrame.new(originalPosition)
            
            task.wait(0.2) -- Wait for teleport
            
            -- Step 4: Stop dragging to drop the item at original position
            pcall(function()
                ReplicatedStorage:WaitForChild("RemoteEvents").StopDraggingItem:FireServer(item)
            end)
            
            task.wait(0.5) -- Wait between items to avoid spam detection
        end
    end
    
    -- Final teleport back to original position
    hrp.CFrame = CFrame.new(originalPosition)
end

local Window = WindUI:CreateWindow({
    Title = "DYHUB",
    Icon = "rbxassetid://104487529937663", 
    Author = "99 Night in the Forest | Free Version",
    Folder = "AxsHub",
    Size = UDim2.fromOffset(500, 350),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
           
            WindUI:Notify({
                Title = "Theme Changed",
                Content = "Switched to " .. newTheme .. " theme!",
                Duration = 2,
                Icon = "palette"
            })
            print("Switched to " .. newTheme .. " theme")
        end,
    },
    
})

Window:SetToggleKey(Enum.KeyCode.V)

pcall(function()
    Window:CreateTopbarButton("TransparencyToggle", "eye", function()
        if getgenv().TransparencyEnabled then
            getgenv().TransparencyEnabled = false
            pcall(function() Window:ToggleTransparency(false) end)
            
            WindUI:Notify({
                Title = "Transparency", 
                Content = "Transparency disabled",
                Duration = 3,
                Icon = "eye"
            })
            print("Transparency = false")
        else
            getgenv().TransparencyEnabled = true
            pcall(function() Window:ToggleTransparency(true) end)
            
            WindUI:Notify({
                Title = "Transparency",
                Content = "Transparency enabled", 
                Duration = 3,
                Icon = "eye-off"
            })
            print(" Transparency = true")
        end
        
        -- Debug: Print current state
        print("Debug - Current Transparency state:", getgenv().TransparencyEnabled)
    end, 990)
end)

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Tabs = {}

Tabs.Info = Window:Tab({
    Title = "Information",
    Icon = "badge-info",
    Desc = "DYHUB"
})

Tabs.Main = Window:Tab({
    Title = "Main",
    Icon = "rocket",
    Desc = "DYHUB"
})
Tabs.Auto = Window:Tab({
    Title = "Auto",
    Icon = "wrench",
    Desc = "DYHUB"
})
Tabs.br = Window:Tab({
    Title = "Bring",
    Icon = "package",
    Desc = "DYHUB"
})

Tabs.Combat = Window:Tab({
    Title = "Combat",
    Icon = "sword",
    Desc = "DYHUB"
})
Tabs.Fly = Window:Tab({
    Title = "Player",
    Icon = "user",
    Desc = "DYHUB"
})
Tabs.esp = Window:Tab({
    Title = "Esp",
    Icon = "eye",
    Desc = "DYHUB"
})
Tabs.Tp = Window:Tab({
    Title = "Teleport",
    Icon = "map",
    Desc = "DYHUB"
})

Tabs.More = Window:Tab({
    Title = "Farm",
    Icon = "crown",
    Desc = "DYHUB"
})

Tabs.Anti = Window:Tab({
    Title = "Anti",
    Icon = "shield",
    Desc = "DYHUB"
})

Tabs.Vision = Window:Tab({
    Title = "Settings",
    Icon = "settings",
    Desc = "DYHUB"
})

Window:SelectTab(1)

Tabs.Combat:Section({ Title = "Aura", Icon = "star" })

Tabs.Combat:Toggle({
    Title = "Kill Aura",
    Value = false,
    Callback = function(state)
        killAuraToggle = state
        if state then
            task.spawn(killAuraLoop)
        else
            local tool, _ = getAnyToolWithDamageID(false)
            unequipTool(tool)
        end
    end
})

Tabs.Combat:Toggle({
    Title = "Chop Aura",
    Value = false,
    Callback = function(state)
        chopAuraToggle = state
        if state then
            task.spawn(chopAuraLoop)
        else
            local tool, _ = getAnyToolWithDamageID(true)
            unequipTool(tool)
        end
    end
})

Tabs.Combat:Section({ Title = "Plant Settings", Icon = "axe" })

Tabs.Combat:Toggle({
    Title = "Auto Plant",
    Value = false,
    Callback = function(state)
        AutoPlantToggle = state
        if state then
            task.spawn(autoplant)
        end
    end
})

Tabs.Combat:Section({ Title = "Settings", Icon = "settings" })

Tabs.Combat:Slider({
    Title = "Aura Radius",
    Value = { Min = 20, Max = 800, Default = 50 },
    Callback = function(value)
        auraRadius = math.clamp(value, 10, 800)
    end
})

Tabs.Main:Section({ Title = "Auto Feed", Icon = "utensils" })

Tabs.Main:Dropdown({
    Title = "Select Food",
    Desc = "Choose the food",
    Values = alimentos,
    Value = selectedFood,
    Multi = true,
    Callback = function(value)
        selectedFood = value
    end
})

Tabs.Main:Input({
    Title = "Feed Amount",
    Desc = "Eat when hunger reaches this %",
    Value = tostring(hungerThreshold),
    Placeholder = "Ex: 50",
    Numeric = true,
    Callback = function(value)
        local n = tonumber(value)
        if n then
            hungerThreshold = math.clamp(n, 0, 100)
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Feed",
    Value = false,
    Callback = function(state)
        autoFeedToggle = state
        if state then
            task.spawn(function()
                while autoFeedToggle do
                    task.wait(0.075)
                    if wiki(selectedFood) == 0 then
                        autoFeedToggle = false
                        Tabs.Combat:Find("Auto Feed"):SetValue(false)
                        notifeed(selectedFood)
                        break
                    end
                    if ghn() <= hungerThreshold then
                        feed(selectedFood)
                    end
                end
            end)
        end
    end
})

Tabs.Auto:Section({ Title = "Auto Upgrade Campfire", Icon = "flame" })

Tabs.Auto:Dropdown({
    Title = "Auto Upgrade Campfire",
    Desc = "Choose the items",
    Values = campfireFuelItems,
    Multi = false, -- Keep as false
    AllowNone = true,
    Callback = function(option)
        selectedCampfireItem = option -- Store single selected item
    end
})

Tabs.Auto:Toggle({
    Title = "Auto Upgrade Campfire",
    Value = false,
    Callback = function(checked)
        autoUpgradeCampfireEnabled = checked
        if checked then
            task.spawn(function()
                while autoUpgradeCampfireEnabled do
                    if selectedCampfireItem then
                        local items = {}
                        
                        -- เก็บ item ที่ตรงชื่อไว้ในตาราง
                        for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
                            if item.Name == selectedCampfireItem then
                                table.insert(items, item)
                            end
                        end

                        -- ดึงทีละ 10 (หรือถ้ามีน้อยกว่าก็ดึงทั้งหมด)
                        local count = math.min(10, #items)
                        for i = 1, count do
                            moveItemToPos(items[i], campfireDropPos)
                        end
                    end

                    task.wait(1) -- รอ 2 วิ ก่อนวนใหม่
                end
            end)
        end
    end
})

Tabs.Auto:Section({ Title = "Auto Scrap Items", Icon = "cog" })

Tabs.Auto:Dropdown({
    Title = "Auto Scrap Items",
    Desc = "Choose the items",
    Values = scrapjunkItems,
    Multi = false, -- Keep as false
    AllowNone = true,
    Callback = function(option)
        selectedScrapItem = option
    end
})

Tabs.Auto:Toggle({
    Title = "Auto Scrap Item",
    Value = false,
    Callback = function(checked)
        autoScrapItemsEnabled = checked
        if checked then
            task.spawn(function()
                while autoScrapItemsEnabled do
                    if selectedScrapItem then
                        local items = {}
                        
                        -- เก็บ item ที่ตรงชื่อไว้ในตาราง
                        for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
                            if item.Name == selectedScrapItem then
                                table.insert(items, item)
                            end
                        end

                        -- ดึงทีละ 10 (หรือถ้ามีน้อยกว่าก็ดึงทั้งหมด)
                        local count = math.min(10, #items)
                        for i = 1, count do
                            moveItemToPos(items[i], autoScrapPos)
                        end
                    end
                    
                    task.wait(1) -- รอ 2 วิ ก่อนวนใหม่
                end
            end)
        end
    end
})

Tabs.Auto:Section({ Title = "Auto Cook Food", Icon = "flame" })

Tabs.Auto:Dropdown({
    Title = "Auto Cook Food",
    Values = autocookItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        for _, itemName in ipairs(autocookItems) do
            autoCookEnabledItems[itemName] = table.find(options, itemName) ~= nil
        end
    end
})

Tabs.Auto:Toggle({
    Title = "Auto Cook Food",
    Value = false,
    Callback = function(state)
        autoCookEnabled = state
    end
})

coroutine.wrap(function()
    while true do
        if autoCookEnabled then
            for itemName, enabled in pairs(autoCookEnabledItems) do
                if enabled then
                    for _, item in ipairs(Workspace:WaitForChild("Items"):GetChildren()) do
                        if item.Name == itemName then
                            moveItemToPos(item, campfireDropPos)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)()

Tabs.Tp:Section({ Title = "Scan Map", Icon = "map" })

Tabs.Tp:Toggle({
    Title = "Scan Map (Essential)",
    Default = false,
    Callback = function(state)
        scan_map = state

        if not state then
            -- ตรวจสอบว่ามีการเปิด toggle ก่อนแล้วค่อยเรียก tp1()
            if type(tp1) == "function" and scan_map_was_on then
                tp1()
            end
            scan_map_was_on = false
            return
        else
            scan_map_was_on = true
        end

        task.spawn(function()
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 3)
            if not hrp then return end

            local map = workspace:FindFirstChild("Map")
            if not map then return end

            local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
            if not foliage then return end

            while scan_map do
                local trees = {}
                for _, obj in ipairs(foliage:GetChildren()) do
                    if obj.Name == "Small Tree" and obj:IsA("Model") then
                        local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                        if trunk then
                            table.insert(trees, trunk)
                        end
                    end
                end

                for _, trunk in ipairs(trees) do
                    if not scan_map then break end
                    if trunk and trunk.Parent then
                        local treeCFrame = trunk.CFrame
                        local rightVector = treeCFrame.RightVector
                        local targetPosition = treeCFrame.Position + rightVector * 69 + Vector3.new(0, 15, 69)
                        
                        hrp.CFrame = CFrame.new(targetPosition)

                        local footPart = Instance.new("Part")
                        footPart.Size = Vector3.new(10, 1, 10)
                        footPart.Anchored = true
                        footPart.CanCollide = true
                        footPart.Transparency = 1
                        footPart.BrickColor = BrickColor.new("Bright yellow")
                        footPart.CFrame = CFrame.new(targetPosition - Vector3.new(0, 3, 0))
                        footPart.Parent = workspace

                        game.Debris:AddItem(footPart, 1)

                        task.wait(0.01)
                    end
                end
                task.wait(0.25)
            end
        end)
    end
})

Tabs.Tp:Section({ Title = "Teleport", Icon = "map" })

Tabs.Tp:Button({
    Title = "Teleport to Campfire",
    Locked = false,
    Callback = function()
        tp1()
    end
})

Tabs.Tp:Button({
    Title = "Teleport to Stronghold",
    Locked = false,
    Callback = function()
        tp2()
    end
})

Tabs.Tp:Button({
    Title = "Teleport to Safe Zone",
    Callback = function()
        if not workspace:FindFirstChild("SafeZonePart") then
            local createpart = Instance.new("Part")
            createpart.Name = "SafeZonePart"
            createpart.Size = Vector3.new(30, 3, 30)
            createpart.Position = Vector3.new(0, 350, 0)
            createpart.Anchored = true
            createpart.CanCollide = true
            createpart.Transparency = 0.8
            createpart.Color = Color3.fromRGB(255, 0, 0)
            createpart.Parent = workspace
        end
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(0, 360, 0)
    end
})

Tabs.Tp:Button({
    Title = "Teleport to Trader (Bunny Foot)",
    Callback = function()
        local pos = Vector3.new(-37.08, 3.98, -16.33)
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end
})

Tabs.Tp:Section({ Title = "Tree", Icon = "tree-deciduous" })

Tabs.Tp:Button({
    Title = "Teleport to Random Tree",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart", 3)
        if not hrp then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end

        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end

        local trees = {}
        for _, obj in ipairs(foliage:GetChildren()) do
            if obj.Name == "Small Tree" and obj:IsA("Model") then
                local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                if trunk then
                    table.insert(trees, trunk)
                end
            end
        end

        if #trees > 0 then
            local trunk = trees[math.random(1, #trees)]
            local treeCFrame = trunk.CFrame
            local rightVector = treeCFrame.RightVector
            local targetPosition = treeCFrame.Position + rightVector * 3
            hrp.CFrame = CFrame.new(targetPosition)
        end
    end
})

Tabs.Tp:Section({ Title = "Children", Icon = "eye" })

local MobDropdown = Tabs.Tp:Dropdown({
    Title = "Select Child",
    Values = currentMobNames,
    Multi = false,
    AllowNone = true,
    Callback = function(options)
        selectedMob = options[#options] or currentMobNames[1] or nil
    end
})

Tabs.Tp:Button({
    Title = "Refresh List",
    Locked = false,
    Callback = function()
        currentMobs, currentMobNames = getMobs()
        if #currentMobNames > 0 then
            selectedMob = currentMobNames[1]
            MobDropdown:Refresh(currentMobNames)
        else
            selectedMob = nil
            MobDropdown:Refresh({ "No child found" })
        end
    end
})

Tabs.Tp:Button({
    Title = "Teleport to Child",
    Locked = false,
    Callback = function()
        if selectedMob and currentMobs then
            for i, name in ipairs(currentMobNames) do
                if name == selectedMob then
                    local targetMob = currentMobs[i]
                    if targetMob then
                        local part = targetMob.PrimaryPart or targetMob:FindFirstChildWhichIsA("BasePart")
                        if part and game.Players.LocalPlayer.Character then
                            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                            end
                        end
                    end
                    break
                end
            end
        end
    end
})


Tabs.Tp:Section({ Title = "Chest", Icon = "box" })

local ChestDropdown = Tabs.Tp:Dropdown({
    Title = "Select Chest",
    Values = currentChestNames,
    Multi = false,
    AllowNone = true,
    Callback = function(options)
        selectedChest = options[#options] or currentChestNames[1] or nil
    end
})

Tabs.Tp:Button({
    Title = "Refresh List",
    Locked = false,
    Callback = function()
        currentChests, currentChestNames = getChests()
        if #currentChestNames > 0 then
            selectedChest = currentChestNames[1]
            ChestDropdown:Refresh(currentChestNames)
        else
            selectedChest = nil
            ChestDropdown:Refresh({ "No chests found" })
        end
    end
})

Tabs.Tp:Button({
    Title = "Teleport to Chest",
    Locked = false,
    Callback = function()
        if selectedChest and currentChests then
            local chestIndex = 1
            for i, name in ipairs(currentChestNames) do
                if name == selectedChest then
                    chestIndex = i
                    break
                end
            end
            local targetChest = currentChests[chestIndex]
            if targetChest then
                local part = targetChest.PrimaryPart or targetChest:FindFirstChildWhichIsA("BasePart")
                if part and game.Players.LocalPlayer.Character then
                    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end
})

Tabs.br:Section({ Title = "Blue Print", Icon = "hammer" })

Tabs.br:Dropdown({
    Title = "Select Blue Print Items",
    Desc = "Choose items to bring",
    Values = selectedBlueprintItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedBlueprintItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Blue Print Items",
    Desc = "Before you Bring Unlocked 1 zone first!",
    Default = false,
    Callback = function(value)
        BlueprintToggleEnabled = value
        
        if value then
            if #selectedBlueprintItems > 0 then
                BlueprintLoopRunning = true
                spawn(function()
                    while BlueprintLoopRunning and BlueprintToggleEnabled do
                        if #selectedBlueprintItems > 0 and BlueprintToggleEnabled then
                            bypassBringSystem(selectedBlueprintItems, function() return BlueprintToggleEnabled end)
                        end
                        
                        -- Wait with proper stop checking
                        local waitTime = 0
                        while waitTime < 3 and BlueprintToggleEnabled and BlueprintLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    BlueprintLoopRunning = false
                end)
            else
                BlueprintToggleEnabled = false
            end
        else
            BlueprintLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Pelts", Icon = "shirt" })

Tabs.br:Dropdown({
    Title = "Select Pelts Items",
    Desc = "Choose items to bring",
    Values = PeltsItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedPeltsItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Pelts Items",
    Desc = "Before you Bring Unlocked 1 zone first!",
    Default = false,
    Callback = function(value)
        PeltsToggleEnabled = value
        
        if value then
            if #selectedPeltsItems > 0 then
                PeltsLoopRunning = true
                spawn(function()
                    while PeltsLoopRunning and PeltsToggleEnabled do
                        if #selectedPeltsItems > 0 and PeltsToggleEnabled then
                            bypassBringSystem(selectedPeltsItems, function() return PeltsToggleEnabled end)
                        end
                        
                        -- Wait with proper stop checking
                        local waitTime = 0
                        while waitTime < 3 and PeltsToggleEnabled and PeltsLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    PeltsLoopRunning = false
                end)
            else
                PeltsToggleEnabled = false
            end
        else
            PeltsLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Junk", Icon = "box" })

Tabs.br:Dropdown({
    Title = "Select Junk Items",
    Desc = "Choose items to bring",
    Values = junkItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedJunkItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Junk Items",
    Desc = "Before you Bring Unlocked 1 zone first!",
    Default = false,
    Callback = function(value)
        junkToggleEnabled = value
        
        if value then
            if #selectedJunkItems > 0 then
                junkLoopRunning = true
                spawn(function()
                    while junkLoopRunning and junkToggleEnabled do
                        if #selectedJunkItems > 0 and junkToggleEnabled then
                            bypassBringSystem(selectedJunkItems, function() return junkToggleEnabled end)
                        end
                        
                        -- Wait with proper stop checking
                        local waitTime = 0
                        while waitTime < 3 and junkToggleEnabled and junkLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    junkLoopRunning = false
                end)
            else
                junkToggleEnabled = false
            end
        else
            junkLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Fuel", Icon = "flame" })

Tabs.br:Dropdown({
    Title = "Select Fuel Items",
    Desc = "Choose items to bring",
    Values = fuelItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedFuelItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Fuel Items",
    Desc = "Before you Bring Unlocked 1 Zone First!",
    Default = false,
    Callback = function(value)
        fuelToggleEnabled = value
        
        if value then
            if #selectedFuelItems > 0 then
                fuelLoopRunning = true
                spawn(function()
                    while fuelLoopRunning and fuelToggleEnabled do
                        if #selectedFuelItems > 0 and fuelToggleEnabled then
                            bypassBringSystem(selectedFuelItems, function() return fuelToggleEnabled end)
                        end
                        
                        -- Wait with proper stop checking
                        local waitTime = 0
                        while waitTime < 3 and fuelToggleEnabled and fuelLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    fuelLoopRunning = false
                end)
            else
                fuelToggleEnabled = false
            end
        else
            fuelLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Food", Icon = "utensils" })

Tabs.br:Dropdown({
    Title = "Select Food Items",
    Desc = "Choose items to bring",
    Values = foodItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedFoodItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Food items",
    Desc = "Before you Bring Unlocked 1 Zone First!",
    Default = false,
    Callback = function(value)
        foodToggleEnabled = value
        
        if value then
            if #selectedFoodItems > 0 then
                foodLoopRunning = true
                spawn(function()
                    while foodLoopRunning and foodToggleEnabled do
                        if #selectedFoodItems > 0 and foodToggleEnabled then
                            bypassBringSystem(selectedFoodItems, function() return foodToggleEnabled end)
                        end
                        
                        -- Wait with proper stop checking
                        local waitTime = 0
                        while waitTime < 3 and foodToggleEnabled and foodLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    foodLoopRunning = false                 
                end)
            else                
                foodToggleEnabled = false
            end
        else
            foodLoopRunning = false          
        end
    end
})

Tabs.br:Section({ Title = "Medicine", Icon = "bandage" })

Tabs.br:Dropdown({
    Title = "Select Medical Items",
    Desc = "Choose items to bring",
    Values = medicalItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedMedicalItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Medical Items",
    Desc = "Before you Bring Unlocked 1 Zone First!",
    Default = false,
    Callback = function(value)
        medicalToggleEnabled = value
        
        if value then
            if #selectedMedicalItems > 0 then
                medicalLoopRunning = true
                spawn(function()
                    while medicalLoopRunning and medicalToggleEnabled do
                        if #selectedMedicalItems > 0 and medicalToggleEnabled then
                            bypassBringSystem(selectedMedicalItems, function() return medicalToggleEnabled end)
                        end
                        
                        -- Wait with proper stop checking
                        local waitTime = 0
                        while waitTime < 3 and medicalToggleEnabled and medicalLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    medicalLoopRunning = false
                end)
            else
                medicalToggleEnabled = false
            end
        else
            medicalLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Equipment", Icon = "sword" })

Tabs.br:Dropdown({
    Title = "Select Equipment Items",
    Desc = "Choose items to bring",
    Values = equipmentItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedEquipmentItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Equipment Items",
    Desc = "Before you Bring Unlocked 1 Zone First!",
    Default = false,
    Callback = function(value)
        equipmentToggleEnabled = value
        
        if value then
            if #selectedEquipmentItems > 0 then
                equipmentLoopRunning = true
                spawn(function()
                    while equipmentLoopRunning and equipmentToggleEnabled do
                        if #selectedEquipmentItems > 0 and equipmentToggleEnabled then
                            bypassBringSystem(selectedEquipmentItems, function() return equipmentToggleEnabled end)
                        end
                        
                        -- Wait with proper stop checking
                        local waitTime = 0
                        while waitTime < 3 and equipmentToggleEnabled and equipmentLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    equipmentLoopRunning = false
                end)
            else
                equipmentToggleEnabled = false
            end
        else
            equipmentLoopRunning = false
        end
    end
})

Tabs.Fly:Section({ Title = "Player Settings", Icon = "user" })

Tabs.Fly:Slider({
    Title = "Fly Speed",
    Value = { Min = 1, Max = 20, Default = 1 },
    Callback = function(value)
        flySpeed = value
        if FLYING then
            task.spawn(function()
                while FLYING do
                    task.wait(0.1)
                    if game:GetService("UserInputService").TouchEnabled then
                        local root = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root and root:FindFirstChild("BodyVelocity") then
                            local bv = root:FindFirstChild("BodyVelocity")
                            bv.Velocity = bv.Velocity.Unit * (flySpeed * 50) -- Adjust velocity magnitude
                        end
                    end
                end
            end)
        end
    end
})

Tabs.Fly:Toggle({
    Title = "Enable Fly",
    Value = false,
    Callback = function(state)
        flyToggle = state
        if flyToggle then
            if game:GetService("UserInputService").TouchEnabled then
                MobileFly()
            else
                sFLY()
            end
        else
            NOFLY()
            UnMobileFly()
        end
    end
})

local Players = game:GetService("Players")
local speed = 16

local function setSpeed(val)
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = val end
end


Tabs.Fly:Slider({
    Title = "Speed",
    Value = { Min = 16, Max = 150, Default = 16 },
    Callback = function(value)
        speed = value
    end
})

Tabs.Fly:Toggle({
    Title = "Enable Speed",
    Value = false,
    Callback = function(state)
        setSpeed(state and speed or 16)
    end
})

Tabs.Fly:Section({ Title = "Power Settings", Icon = "flame" })

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local noclipConnection

Tabs.Fly:Toggle({
    Title = "No Clip",
    Value = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = Players.LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
    end
})

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local infJumpConnection

Tabs.Fly:Toggle({
    Title = "Inf Jump",
    Value = false,
    Callback = function(state)
        if state then
            infJumpConnection = UserInputService.JumpRequest:Connect(function()
                local char = Players.LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConnection then
                infJumpConnection:Disconnect()
                infJumpConnection = nil
            end
        end
    end
})

function createESPText(part, text, color)
    if part:FindFirstChild("ESPTexto") then return end

    local esp = Instance.new("BillboardGui")
    esp.Name = "ESPTexto"
    esp.Adornee = part
    esp.Size = UDim2.new(0, 100, 0, 20)
    esp.StudsOffset = Vector3.new(0, 2.5, 0)
    esp.AlwaysOnTop = true
    esp.MaxDistance = 300

    local label = Instance.new("TextLabel")
    label.Parent = esp
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255,255,0)
    label.TextStrokeTransparency = 0.2
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold

    esp.Parent = part
end

local function Aesp(nome, tipo)
    local container
    local color
    if tipo == "item" then
        container = workspace:FindFirstChild("Items")
        color = Color3.fromRGB(0, 255, 0)
    elseif tipo == "mob" then
        container = workspace:FindFirstChild("Characters")
        color = Color3.fromRGB(255, 255, 0)
    else
        return
    end
    if not container then return end

    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == nome then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                createESPText(part, obj.Name, color)
            end
        end
    end
end

local function Desp(nome, tipo)
    local container
    if tipo == "item" then
        container = workspace:FindFirstChild("Items")
    elseif tipo == "mob" then
        container = workspace:FindFirstChild("Characters")
    else
        return
    end
    if not container then return end

    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == nome then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                for _, gui in ipairs(part:GetChildren()) do
                    if gui:IsA("BillboardGui") and gui.Name == "ESPTexto" then
                        gui:Destroy()
                    end
                end
            end
        end
    end
end

local selectedItems = {}
local selectedMobs = {}
local espItemsEnabled = false
local espMobsEnabled = false
local espConnections = {}

Tabs.esp:Section({ Title = "Esp Items", Icon = "package" })

Tabs.esp:Dropdown({
    Title = "Esp Items",
    Values = ie,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedItems = options
        if espItemsEnabled then
            for _, name in ipairs(ie) do
                if table.find(selectedItems, name) then
                    Aesp(name, "item")
                else
                    Desp(name, "item")
                end
            end
        else
            for _, name in ipairs(ie) do
                Desp(name, "item")
            end
        end
    end
})

Tabs.esp:Toggle({
    Title = "Enable Esp",
    Value = false,
    Callback = function(state)
        espItemsEnabled = state
        for _, name in ipairs(ie) do
            if state and table.find(selectedItems, name) then
                Aesp(name, "item")
            else
                Desp(name, "item")
            end
        end

        if state then
            if not espConnections["Items"] then
                local container = workspace:FindFirstChild("Items")
                if container then
                    espConnections["Items"] = container.ChildAdded:Connect(function(obj)
                        if table.find(selectedItems, obj.Name) then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                createESP(part, obj.Name, Color3.fromRGB(0, 255, 0))
                            end
                        end
                    end)
                end
            end
        else
            if espConnections["Items"] then
                espConnections["Items"]:Disconnect()
                espConnections["Items"] = nil
            end
        end
    end
})

Tabs.esp:Section({ Title = "Esp Entity", Icon = "user" })

Tabs.esp:Dropdown({
    Title = "Esp Entity",
    Values = me,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedMobs = options
        if espMobsEnabled then
            for _, name in ipairs(me) do
                if table.find(selectedMobs, name) then
                    Aesp(name, "mob")
                else
                    Desp(name, "mob")
                end
            end
        else
            for _, name in ipairs(me) do
                Desp(name, "mob")
            end
        end
    end
})

Tabs.esp:Toggle({
    Title = "Enable Esp",
    Value = false,
    Callback = function(state)
        espMobsEnabled = state
        for _, name in ipairs(me) do
            if state and table.find(selectedMobs, name) then
                Aesp(name, "mob")
            else
                Desp(name, "mob")
            end
        end

        if state then
            if not espConnections["Mobs"] then
                local container = workspace:FindFirstChild("Characters")
                if container then
                    espConnections["Mobs"] = container.ChildAdded:Connect(function(obj)
                        if table.find(selectedMobs, obj.Name) then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                createESP(part, obj.Name, Color3.fromRGB(255, 255, 0))
                            end
                        end
                    end)
                end
            end
        else
            if espConnections["Mobs"] then
                espConnections["Mobs"]:Disconnect()
                espConnections["Mobs"] = nil
            end
        end
    end
})

Tabs.Main:Section({ Title = "Misc", Icon = "settings" })

local instantInteractEnabled = false
local instantInteractConnection
local originalHoldDurations = {}

Tabs.Main:Toggle({
    Title = "Instant Interact",
    Value = false,
    Callback = function(state)
        instantInteractEnabled = state

        if state then
            originalHoldDurations = {}
            instantInteractConnection = task.spawn(function()
                while instantInteractEnabled do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            if originalHoldDurations[obj] == nil then
                                originalHoldDurations[obj] = obj.HoldDuration
                            end
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(5)
                end
            end)
        else
            if instantInteractConnection then
                instantInteractEnabled = false
            end
            for obj, value in pairs(originalHoldDurations) do
                if obj and obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = value
                end
            end
            originalHoldDurations = {}
        end
    end
})

Tabs.Anti:Section({ Title = "Anti Monster", Icon = "skull" })

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local torchLoop = nil

Tabs.Anti:Toggle({
    Title = "Auto Stun Deer (Need Flashlight)",
    Value = false,
    Callback = function(state)
        if state then
            torchLoop = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local remote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                        and ReplicatedStorage.RemoteEvents:FindFirstChild("DeerHitByTorch")
                    local deer = workspace:FindFirstChild("Characters")
                        and workspace.Characters:FindFirstChild("Deer")
                    if remote and deer then
                        remote:InvokeServer(deer)
                    end
                end)
                task.wait(0.1)
            end)
        else
            if torchLoop then
                torchLoop:Disconnect()
                torchLoop = nil
            end
        end
    end
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- ตั้งค่าแต่ละตัว
local ESCAPE_DISTANCE_OWL = 80
local ESCAPE_SPEED_OWL = 5

local ESCAPE_DISTANCE_DEER = 60
local ESCAPE_SPEED_DEER = 4

local escapeLoopOwl
local escapeLoopDeer

-- Toggle หนี Owl
Tabs.Anti:Toggle({
    Title = "Escape From Owl", 
    Value = false,
    Callback = function(state)
        if state then
            escapeLoopOwl = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local owl = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild("Owl")
                    if owl and owl:FindFirstChild("HumanoidRootPart") then
                        local myPos = HumanoidRootPart.Position
                        local owlPos = owl.HumanoidRootPart.Position
                        local distance = (myPos - owlPos).Magnitude

                        if distance < ESCAPE_DISTANCE_OWL then
                            local direction = (myPos - owlPos).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_OWL
                        end
                    end
                end)
            end)
        else
            if escapeLoopOwl then
                escapeLoopOwl:Disconnect()
                escapeLoopOwl = nil
            end
        end
    end
})

-- Toggle หนี Deer
Tabs.Anti:Toggle({
    Title = "Escape From Deer", 
    Value = false,
    Callback = function(state)
        if state then
            escapeLoopDeer = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local deer = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild("Deer")
                    if deer and deer:FindFirstChild("HumanoidRootPart") then
                        local myPos = HumanoidRootPart.Position
                        local deerPos = deer.HumanoidRootPart.Position
                        local distance = (myPos - deerPos).Magnitude

                        if distance < ESCAPE_DISTANCE_DEER then
                            local direction = (myPos - deerPos).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_DEER
                        end
                    end
                end)
            end)
        else
            if escapeLoopDeer then
                escapeLoopDeer:Disconnect()
                escapeLoopDeer = nil
            end
        end
    end
})


Tabs.Vision:Section({ Title = "Vision", Icon = "eye" })

-- Variable

-- Store original parents for restoration
local originalParents = {
    Sky = nil,
    Bloom = nil,
    CampfireEffect = nil
}

-- Function to store original parents
local function storeOriginalParents()
    local Lighting = game:GetService("Lighting")
    
    local sky = Lighting:FindFirstChild("Sky")
    local bloom = Lighting:FindFirstChild("Bloom")
    local campfireEffect = Lighting:FindFirstChild("CampfireEffect")
    
    if sky and not originalParents.Sky then
        originalParents.Sky = sky.Parent
    end
    if bloom and not originalParents.Bloom then
        originalParents.Bloom = bloom.Parent
    end
    if campfireEffect and not originalParents.CampfireEffect then
        originalParents.CampfireEffect = campfireEffect.Parent
    end
end

-- Store the original parents when script loads
storeOriginalParents()

local originalColorCorrectionParent = nil

-- Function to store original ColorCorrection parent
local function storeColorCorrectionParent()
    local Lighting = game:GetService("Lighting")
    local colorCorrection = Lighting:FindFirstChild("ColorCorrection")
    
    if colorCorrection and not originalColorCorrectionParent then
        originalColorCorrectionParent = colorCorrection.Parent
    end
end

-- Store the original parent when script loads
storeColorCorrectionParent()

Tabs.Vision:Toggle({
    Title = "Disable Fog",
    Desc = "",
    Value = false,
    Callback = function(state)
        local Lighting = game:GetService("Lighting")
        
        if state then
            -- Disable effects by setting parent to nil
            local sky = Lighting:FindFirstChild("Sky")
            local bloom = Lighting:FindFirstChild("Bloom")
            local campfireEffect = Lighting:FindFirstChild("CampfireEffect")
            
            if sky then
                sky.Parent = nil
            end
            if bloom then
                bloom.Parent = nil
            end
            if campfireEffect then
                campfireEffect.Parent = nil
            end
            

        else
            -- Re-enable effects by restoring original parents
            -- First check if effects exist anywhere (they might be parented to nil)
            local sky = game:FindFirstChild("Sky", true)
            local bloom = game:FindFirstChild("Bloom", true) 
            local campfireEffect = game:FindFirstChild("CampfireEffect", true)
            
            -- If they don't exist, try to find them in Lighting's descendants
            if not sky then sky = Lighting:FindFirstChild("Sky") end
            if not bloom then bloom = Lighting:FindFirstChild("Bloom") end
            if not campfireEffect then campfireEffect = Lighting:FindFirstChild("CampfireEffect") end
            
            -- Restore to Lighting (original parent)
            if sky then
                sky.Parent = originalParents.Sky or Lighting
            end
            if bloom then
                bloom.Parent = originalParents.Bloom or Lighting
            end
            if campfireEffect then
                campfireEffect.Parent = originalParents.CampfireEffect or Lighting
            end
            

        end
    end
})

-- Store original lighting values
local originalLightingValues = {
    Brightness = nil,
    Ambient = nil,
    OutdoorAmbient = nil,
    ShadowSoftness = nil,
    GlobalShadows = nil,
    Technology = nil
}

-- Function to store original lighting values
local function storeOriginalLighting()
    local Lighting = game:GetService("Lighting")
    
    if not originalLightingValues.Brightness then
        originalLightingValues.Brightness = Lighting.Brightness
        originalLightingValues.Ambient = Lighting.Ambient
        originalLightingValues.OutdoorAmbient = Lighting.OutdoorAmbient
        originalLightingValues.ShadowSoftness = Lighting.ShadowSoftness
        originalLightingValues.GlobalShadows = Lighting.GlobalShadows
        originalLightingValues.Technology = Lighting.Technology
    end
end

-- Store original values when script loads
storeOriginalLighting()

Tabs.Vision:Toggle({
    Title = "Disable NightCampFire Effect",
    Desc = "",
    Value = false,
    Callback = function(state)
        local Lighting = game:GetService("Lighting")
        
        if state then
            -- Disable ColorCorrection by setting parent to nil
            local colorCorrection = Lighting:FindFirstChild("ColorCorrection")
            
            if colorCorrection then
                -- Store original parent before disabling (if not already stored)
                if not originalColorCorrectionParent then
                    originalColorCorrectionParent = colorCorrection.Parent
                end
                colorCorrection.Parent = nil
            end
        else
            -- Re-enable ColorCorrection by restoring original parent
            -- Search everywhere for the ColorCorrection object
            local colorCorrection = nil
            
            -- First check if it's already in Lighting
            colorCorrection = Lighting:FindFirstChild("ColorCorrection")
            
            -- If not found, search the entire game
            if not colorCorrection then
                colorCorrection = game:FindFirstChild("ColorCorrection", true)
            end
            
            -- Restore to Lighting
            if colorCorrection then
                colorCorrection.Parent = Lighting
            end
        end
    end
})

Tabs.Vision:Section({ Title = "Visual", Icon = "lightbulb" })

Tabs.Vision:Toggle({
    Title = "Full Bright",
    Desc = "",
    Value = false,
    Callback = function(state)
        if state then
            Lighting.ClockTime = 14
            Lighting.Brightness = 2.2
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.ShadowSoftness = 0
            Lighting.GlobalShadows = false
            Lighting.Technology = Enum.Technology.Compatibility
        else
            -- Restore original lighting
            Lighting.Brightness = originalLightingValues.Brightness
            Lighting.Ambient = originalLightingValues.Ambient
            Lighting.OutdoorAmbient = originalLightingValues.OutdoorAmbient
            Lighting.ShadowSoftness = originalLightingValues.ShadowSoftness
            Lighting.GlobalShadows = originalLightingValues.GlobalShadows
            Lighting.Technology = originalLightingValues.Technology
        end
    end
})


local NoFogToggle = false
local OriginalFogStart = Lighting.FogStart
local OriginalFogEnd = Lighting.FogEnd

Tabs.Vision:Toggle({
    Title = "No Fog",
    Desc = "",
    Value = false,
    Callback = function(state)
        NoFogToggle = state
        
        if not state then
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogStart = OriginalFogStart
            Lighting.FogEnd = OriginalFogEnd
        end
    end
})

RunService.Heartbeat:Connect(function()
    if NoFogToggle then
        if Lighting.FogStart ~= 100000 or Lighting.FogEnd ~= 100000 then
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogStart = 100000
            Lighting.FogEnd = 100000
            print("[DYHUB] hi 3")
        end
    end
end)

if not vibrantEffect then
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    vibrantEffect = Instance.new("ColorCorrectionEffect")
    vibrantEffect.Name = "VibrantEffect"
    vibrantEffect.Saturation = 0.5
    vibrantEffect.Contrast = 0.2
    vibrantEffect.Brightness = 0.1
    vibrantEffect.Enabled = false   -- ปิดไว้เฉย ๆ
    vibrantEffect.Parent = Lighting
end

Tabs.Vision:Toggle({
    Title = "Vibrant Colors",
    Value = false,
    Callback = function(state)
        if state then
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)
            Lighting.ColorShift_Bottom = Color3.fromRGB(200, 240, 255)
            if effect then
                effect.Enabled = true
            end
        else
            -- ปิดโหมด กลับค่าดั้งเดิม แต่ **ไม่รีเซ็ตทันทีตอนสคริปต์รัน**
            if effect then
                effect.Enabled = false
            end
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            print("[DYHUB] hi 1")
        end
    end
})

Tabs.Vision:Section({ Title = "Low Graphic", Icon = "user-cog" })

Tabs.Vision:Button({
    Title = "FPS Boost (By Roblox)",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 1
            lighting.FogEnd = 1000000
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        print("[Roblox] FPS Boost Applied")
    end
})

-- สร้างแท็บก่อน
Tabs.Vision:Button({
    Title = "FPS Boost (By DYHUB)",
    Callback = function()
        print("[DYHUB] FPS Boost Applied")

        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/Nigga.lua"))()
        end)

        if success then
            print("[DYHUB] Script loaded successfully")
        else
            warn("[DYHUB] Failed to load script: " .. tostring(err))
            print("[DYHUB] hi 1")
        end
    end
})


local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Camera = workspace.CurrentCamera

-- Settings
local showFPS, showPing = true, true
local fpsCounter, fpsLastUpdate, fpsValue = 0, tick(), 0

-- Drawing setup
local function createText(yOffset)
    local textObj = Drawing.new("Text")
    textObj.Size = 16
    textObj.Position = Vector2.new(Camera.ViewportSize.X - 110, yOffset)
    textObj.Color = Color3.fromRGB(0, 255, 0)
    textObj.Center = false
    textObj.Outline = true
    textObj.Visible = true
    return textObj
end

local fpsText = createText(10)
local msText = createText(30)

-- Adjust position when screen size changes
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    fpsText.Position = Vector2.new(Camera.ViewportSize.X - 110, 10)
    msText.Position = Vector2.new(Camera.ViewportSize.X - 110, 30)
end)

-- Main update loop
RunService.RenderStepped:Connect(function()
    fpsCounter += 1

    if tick() - fpsLastUpdate >= 1 then
        fpsValue = fpsCounter
        fpsCounter = 0
        fpsLastUpdate = tick()

        -- FPS Display
        if showFPS then
            fpsText.Text = string.format("FPS: %d", fpsValue)
            fpsText.Color = fpsValue >= 50 and Color3.fromRGB(0, 255, 0)
                or fpsValue >= 30 and Color3.fromRGB(255, 165, 0)
                or Color3.fromRGB(255, 0, 0)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end

        -- Ping Display
        if showPing then
            local pingStat = Stats.Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            local color, label = Color3.fromRGB(0, 255, 0), "Ping: "

            if ping > 120 then
                color, label = Color3.fromRGB(255, 0, 0), "Ew Wifi Ping: "
            elseif ping > 60 then
                color = Color3.fromRGB(255, 165, 0)
            end

            msText.Text = string.format("%s%d ms", label, ping)
            msText.Color = color
            msText.Visible = true
        else
            msText.Visible = false
        end
    end
end)

Tabs.Vision:Section({ Title = "Show Status", Icon = "settings-2" })

-- UI Toggles
Tabs.Vision:Toggle({
    Title = "Show FPS",
    Default = true,
    Callback = function(val)
        showFPS = val
        fpsText.Visible = val
    end
})
Tabs.Vision:Toggle({
    Title = "Show Ping",
    Default = true,
    Callback = function(val)
        showPing = val
        msText.Visible = val
    end
})

Tabs.More:Section({ Title = "Auto Farm", Icon = "gem" })
Tabs.More:Section({ Title = "Feature: Auto Exe, Auto Server-Hop", Icon = "info" })

-- ปุ่มในแท็บ More
Tabs.More:Button({
    Title = "Auto Farm (Cào Mod)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/kuy/refs/heads/main/dyhub99night.lua"))()
    end
})

-- Replace the problematic section with this fixed version:

Info = Tabs["Info"]  -- This correctly references your existing Info tab

if not ui then ui = {} end
if not ui.Creator then ui.Creator = {} end

-- Define the Request function that mimics ui.Creator.Request
ui.Creator.Request = function(requestData)
    local HttpService = game:GetService("HttpService")
    
    -- Try different HTTP methods
    local success, result = pcall(function()
        if HttpService.RequestAsync then
            -- Method 1: Use RequestAsync if available
            local response = HttpService:RequestAsync({
                Url = requestData.Url,
                Method = requestData.Method or "GET",
                Headers = requestData.Headers or {}
            })
            return {
                Body = response.Body,
                StatusCode = response.StatusCode,
                Success = response.Success
            }
        else
            -- Method 2: Fallback to GetAsync
            local body = HttpService:GetAsync(requestData.Url)
            return {
                Body = body,
                StatusCode = 200,
                Success = true
            }
        end
    end)
    
    if success then
        return result
    else
        error("HTTP Request failed: " .. tostring(result))
    end
end

-- Remove this line completely: Info = InfoTab
-- The Info variable is already correctly set above

local InviteCode = "jWNDPNMmyB"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local function LoadDiscordInfo()
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
            Url = DiscordAPI,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "RobloxBot/1.0",
                ["Accept"] = "application/json"
            }
        }).Body)
    end)

    if success and result and result.guild then
        local DiscordInfo = Info:Paragraph({
            Title = result.guild.name,
            Desc = ' <font color="#52525b">●</font> Member Count : ' .. tostring(result.approximate_member_count) ..
                '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(result.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=1024",
            ImageSize = 42,
        })

        Info:Button({
            Title = "Update Info",
            Callback = function()
                local updated, updatedResult = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
                        Url = DiscordAPI,
                        Method = "GET",
                    }).Body)
                end)

                if updated and updatedResult and updatedResult.guild then
                    DiscordInfo:SetDesc(
                        ' <font color="#52525b">●</font> Member Count : ' .. tostring(updatedResult.approximate_member_count) ..
                        '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(updatedResult.approximate_presence_count)
                    )
                    
                    WindUI:Notify({
                        Title = "Discord Info Updated",
                        Content = "Successfully refreshed Discord statistics",
                        Duration = 2,
                        Icon = "refresh-cw",
                    })
                else
                    WindUI:Notify({
                        Title = "Update Failed",
                        Content = "Could not refresh Discord info",
                        Duration = 3,
                        Icon = "alert-triangle",
                    })
                end
            end
        })

        Info:Button({
            Title = "Copy Discord Invite",
            Callback = function()
                setclipboard("https://discord.gg/" .. InviteCode)
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Discord invite copied to clipboard",
                    Duration = 2,
                    Icon = "clipboard-check",
                })
            end
        })
    else
        Info:Paragraph({
            Title = "Error fetching Discord Info",
            Desc = "Unable to load Discord information. Check your internet connection.",
            Image = "triangle-alert",
            ImageSize = 26,
            Color = "Red",
        })
        print("Discord API Error:", result) -- Debug print
    end
end

LoadDiscordInfo()

Info:Divider()
Info:Section({ 
    Title = "DYHUB Information",
    TextXAlignment = "Center",
    TextSize = 17,
})
Info:Divider()

local Owner = Info:Paragraph({
    Title = "Main Owner",
    Desc = "@dyumraisgoodguy#8888",
    Image = "rbxassetid://119789418015420",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
})

local Social = Info:Paragraph({
    Title = "Social",
    Desc = "Copy link social media for follow!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://guns.lol/DYHUB")
                print("Copied social media link to clipboard!")
            end,
        }
    }
})

local Discord = Info:Paragraph({
    Title = "Discord",
    Desc = "Join our discord for more scripts!",
    Image = "rbxassetid://104487529937663",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 0,
    Locked = false,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://discord.gg/jWNDPNMmyB")
                print("Copied discord link to clipboard!")
            end,
        }
    }
})