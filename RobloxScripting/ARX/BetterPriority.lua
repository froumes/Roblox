-- Better Priority GUI for Unit Upgrades
-- Auto re-execute on teleport (executor environments)
if queue_on_teleport and game:GetService("Players").LocalPlayer then
    local url = "https://raw.githubusercontent.com/froumes/VSC/refs/heads/Roblox/RobloxScripting/ARX/BetterPriority.lua"
    queue_on_teleport(("loadstring(game:HttpGet('%s'))()") :format(url))
end
-- Place this as a LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local unitsFolder = player:WaitForChild("UnitsFolder")

-- Create GUI

-- Remove old GUI if it exists
local playerGui = player:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("BetterPriorityGUI")
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BetterPriorityGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui


local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 448)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -224)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Notification label for save errors
local notifLabel = Instance.new("TextLabel")
notifLabel.Size = UDim2.new(1, 0, 0, 20)
notifLabel.Position = UDim2.new(0, 0, 1, -20)
notifLabel.BackgroundTransparency = 1
notifLabel.Text = ""
notifLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
notifLabel.TextScaled = true
notifLabel.Font = Enum.Font.GothamBold
notifLabel.Parent = mainFrame

-- Fast Retry Button
local fastRetryOn = false
local fastRetryThread = nil
local retryButton = Instance.new("TextButton")
retryButton.Size = UDim2.new(0, 120, 0, 32)
retryButton.Position = UDim2.new(1, -132, 1, -40)
retryButton.AnchorPoint = Vector2.new(0, 0)
retryButton.BackgroundColor3 = Color3.fromRGB(120, 120, 200)
retryButton.Text = "Fast Retry: OFF"
retryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
retryButton.TextScaled = true
retryButton.Font = Enum.Font.GothamBold
retryButton.ZIndex = 3
retryButton.Parent = mainFrame
local retryCorner = Instance.new("UICorner")
retryCorner.CornerRadius = UDim.new(0, 8)
retryCorner.Parent = retryButton

local function setRetryButtonState(on)
    fastRetryOn = on
    if on then
        retryButton.Text = "Fast Retry: ON"
        retryButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    else
        retryButton.Text = "Fast Retry: OFF"
        retryButton.BackgroundColor3 = Color3.fromRGB(120, 120, 200)
    end
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local voteRetryRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteRetry")

local function startFastRetry()
    if fastRetryThread then return end
    fastRetryThread = coroutine.create(function()
        while fastRetryOn do
            pcall(function()
                voteRetryRemote:FireServer()
            end)
            task.wait(0.05)
        end
        fastRetryThread = nil
    end)
    coroutine.resume(fastRetryThread)
end

local function stopFastRetry()
    fastRetryOn = false
    fastRetryThread = nil
end

retryButton.MouseButton1Click:Connect(function()
    if not fastRetryOn then
        setRetryButtonState(true)
        startFastRetry()
    else
        setRetryButtonState(false)
    end
end)

-- Stop fast retry if GUI is destroyed
screenGui.AncestryChanged:Connect(function(_, parent)
    if not parent then
        fastRetryOn = false
    end
end)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(120, 120, 200)
mainStroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 48)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Upgrade Priority"
title.TextColor3 = Color3.fromRGB(180, 200, 255)
title.TextStrokeTransparency = 0.7
title.TextStrokeColor3 = Color3.fromRGB(60, 60, 120)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -24, 1, -118)
scrolling.Position = UDim2.new(0, 12, 0, 56)
scrolling.BackgroundTransparency = 1
scrolling.BorderSizePixel = 0
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolling.ScrollBarThickness = 8
scrolling.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.Parent = scrolling

local unitButtons = {}
local priorities = {}
local unitRows = {} -- Track GUI rows for each unit

-- File config helpers (for exploit/executor environments)
local configFile = "unit_priority_config.txt"
local function saveConfig()
    if writefile then
        local data = ""
        -- Save in GUI order, always include all units, use tab as delimiter
        for _, unitFolder in ipairs(unitsFolder:GetChildren()) do
            if unitFolder:IsA("Folder") then
                local unit = unitFolder.Name
                local prio = priorities[unit] or 0
                data = data .. unit .. "\t" .. tostring(prio) .. "\n"
            end
        end
        local ok, err = pcall(function()
            writefile(configFile, data)
        end)
        if not ok then
            notifLabel.Text = "[Priority] Save failed! " .. tostring(err)
            task.spawn(function()
                wait(2)
                notifLabel.Text = ""
            end)
        else
            notifLabel.Text = ""
        end
    end
end

local function loadConfig()
    if readfile and isfile and isfile(configFile) then
        local data = readfile(configFile)
        for line in string.gmatch(data, "[^\n]+") do
            local unit, prio = line:match("^(.-)\t(.+)$")
            if unit and prio then
                if unitsFolder:FindFirstChild(unit) then
                    if tonumber(prio) then
                        priorities[unit] = tonumber(prio)
                    else
                        priorities[unit] = 0
                    end
                end
            end
        end
    end
end

-- Wait for all units to exist before loading config and building GUI
-- (If units can be added dynamically, consider listening for ChildAdded)

loadConfig()

local function createUnitRow(unitFolder)
    if not unitFolder:IsA("Folder") then return end
    local unitName = unitFolder.Name
    -- Remove any existing row for this unit
    if unitRows[unitName] then
        unitRows[unitName]:Destroy()
        unitRows[unitName] = nil
        unitButtons[unitName] = nil
    end
    local upgradeFolder = unitFolder:FindFirstChild("Upgrade_Folder")

    local price = "?"
    local upgradeCostObj = nil
    if upgradeFolder and upgradeFolder:FindFirstChild("Upgrade_Cost") then
        upgradeCostObj = upgradeFolder.Upgrade_Cost
        price = tostring(upgradeCostObj.Value)
    end

    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 44)
    holder.BackgroundTransparency = 0.15
    holder.BackgroundColor3 = Color3.fromRGB(50, 55, 80)
    holder.Parent = scrolling
    local holderCorner = Instance.new("UICorner")
    holderCorner.CornerRadius = UDim.new(0, 8)
    holderCorner.Parent = holder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = unitName .. " | $" .. price
    nameLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
    nameLabel.TextStrokeTransparency = 0.7
    nameLabel.TextStrokeColor3 = Color3.fromRGB(60, 60, 120)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Parent = holder

    -- Listen for price changes
    if upgradeCostObj then
        upgradeCostObj.Changed:Connect(function(newVal)
            nameLabel.Text = unitName .. " | $" .. tostring(upgradeCostObj.Value)
        end)
    end

    local priorityButton = Instance.new("TextButton")
    priorityButton.Size = UDim2.new(0.5, -10, 1, 0)
    priorityButton.Position = UDim2.new(0.5, 10, 0, 0)
    priorityButton.BackgroundColor3 = Color3.fromRGB(120, 120, 200)
    priorityButton.Text = "Set Priority"
    priorityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    priorityButton.TextStrokeTransparency = 0.6
    priorityButton.TextStrokeColor3 = Color3.fromRGB(60, 60, 120)
    priorityButton.TextScaled = true
    priorityButton.Font = Enum.Font.GothamBold
    priorityButton.Parent = holder
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = priorityButton

    unitButtons[unitName] = priorityButton
    unitRows[unitName] = holder
    if priorities[unitName] == nil then priorities[unitName] = 0 end

    if priorities[unitName] == 0 then
        priorityButton.Text = "Set Priority"
        priorityButton.BackgroundColor3 = Color3.fromRGB(120, 120, 200)
    else
        priorityButton.Text = "Priority: " .. priorities[unitName]
        priorityButton.BackgroundColor3 = Color3.fromHSV(priorities[unitName]/7, 0.5, 1)
    end

    priorityButton.MouseButton1Click:Connect(function()
        if priorities[unitName] == 0 then
            priorities[unitName] = 1
            priorityButton.Text = "Priority: 1"
            priorityButton.BackgroundColor3 = Color3.fromHSV(1/7, 0.5, 1)
            priorityButton.AutoButtonColor = true
            priorityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        elseif priorities[unitName] < 6 then
            priorities[unitName] = priorities[unitName] + 1
            priorityButton.Text = "Priority: " .. priorities[unitName]
            priorityButton.BackgroundColor3 = Color3.fromHSV(priorities[unitName]/7, 0.5, 1)
        else
            priorities[unitName] = 0
            priorityButton.Text = "Set Priority"
            priorityButton.BackgroundColor3 = Color3.fromRGB(120, 120, 200)
            priorityButton.AutoButtonColor = true
            priorityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        saveConfig()
    end)
end

-- Initial population
for _, unitFolder in ipairs(unitsFolder:GetChildren()) do
    createUnitRow(unitFolder)
end

-- Listen for units being added/removed
unitsFolder.ChildAdded:Connect(function(child)
    -- Wait for Upgrade_Folder to exist if needed
    task.wait(0.1)
    createUnitRow(child)
    scrolling.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

unitsFolder.ChildRemoved:Connect(function(child)
    local unitName = child.Name
    if unitRows[unitName] then
        unitRows[unitName]:Destroy()
        unitRows[unitName] = nil
        unitButtons[unitName] = nil
    end
    scrolling.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

scrolling.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)


-- === AUTO-UPGRADE LOGIC ===
local yenValuePath = player.PlayerGui:WaitForChild("HUD"):WaitForChild("InGame"):WaitForChild("Main"):WaitForChild("Stats"):WaitForChild("Yen"):WaitForChild("YenValue")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local upgradeRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("Units"):WaitForChild("Upgrade")

local maxedUnits = {}
local autoUpgradeThread = nil

local function getPriorityOrder()
    -- Returns a list of unit names sorted by priority (1-6), lowest first
    local prioList = {}
    for unit, prio in pairs(priorities) do
        if prio > 0 and not maxedUnits[unit] then
            table.insert(prioList, {unit=unit, prio=prio})
        end
    end
    table.sort(prioList, function(a, b)
        return a.prio < b.prio
    end)
    local ordered = {}
    for _, v in ipairs(prioList) do table.insert(ordered, v.unit) end
    return ordered
end

local function getUpgradeCost(unitName)
    local unitFolder = unitsFolder:FindFirstChild(unitName)
    if not unitFolder then return math.huge end
    local upgradeFolder = unitFolder:FindFirstChild("Upgrade_Folder")
    if not upgradeFolder then return math.huge end
    local upgradeCostObj = upgradeFolder:FindFirstChild("Upgrade_Cost")
    if not upgradeCostObj then return math.huge end
    return upgradeCostObj.Value
end

local function setMaxed(unitName)
    maxedUnits[unitName] = true
    if unitRows[unitName] then
        local nameLabel = unitRows[unitName]:FindFirstChildOfClass("TextLabel")
        if nameLabel then
            nameLabel.Text = unitName .. " | MAX"
        end
    end
end


local function startAutoUpgrade()
    if autoUpgradeThread then
        autoUpgradeThread:Disconnect()
    end
    autoUpgradeThread = coroutine.create(function()
        while true do
            local yen = yenValuePath.Value or 0
            local ordered = getPriorityOrder()
            if #ordered > 0 then
                local unitName = ordered[1] -- Only consider the highest-priority unit
                if not maxedUnits[unitName] then
                    local cost = getUpgradeCost(unitName)
                    if cost ~= math.huge and yen >= cost then
                        local unitFolder = unitsFolder:FindFirstChild(unitName)
                        if unitFolder then
                            local before = cost
                            local args = {unitFolder}
                            upgradeRemote:FireServer(unpack(args))
                            task.wait(0.15)
                            local after = getUpgradeCost(unitName)
                            local yenAfter = yenValuePath.Value or 0
                            -- Only mark as maxed if cost didn't change AND you still have enough yen
                            if after == before and yenAfter >= before then
                                setMaxed(unitName)
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
    coroutine.resume(autoUpgradeThread)
end

startAutoUpgrade()

-- Reset maxedUnits and restart auto-upgrade when units are added/removed
local function resetAutoUpgrade()
    maxedUnits = {}
    startAutoUpgrade()
end

unitsFolder.ChildAdded:Connect(function(child)
    -- Wait for Upgrade_Folder to exist if needed
    task.wait(0.1)
    createUnitRow(child)
    scrolling.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    resetAutoUpgrade()
end)

unitsFolder.ChildRemoved:Connect(function(child)
    local unitName = child.Name
    if unitRows[unitName] then
        unitRows[unitName]:Destroy()
        unitRows[unitName] = nil
        unitButtons[unitName] = nil
    end
    scrolling.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    resetAutoUpgrade()
end)
