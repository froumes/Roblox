-- NPCFinderGUI.lua
-- GUI to scroll, search, and teleport to any NPC in workspace

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NPCFinderGUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1001
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
mainFrame.ZIndex = 10
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(120, 120, 200)
mainStroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 44)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "NPC Finder"
title.TextColor3 = Color3.fromRGB(180, 200, 255)
title.TextStrokeTransparency = 0.7
title.TextStrokeColor3 = Color3.fromRGB(60, 60, 120)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame
title.ZIndex = 11

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 32)
searchBox.Position = UDim2.new(0, 10, 0, 54)
searchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
searchBox.Text = ""
searchBox.PlaceholderText = "Search NPCs..."
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.TextScaled = true
searchBox.Font = Enum.Font.Gotham
searchBox.ClearTextOnFocus = false
searchBox.Parent = mainFrame
searchBox.ZIndex = 12
local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = searchBox

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -110)
scrollFrame.Position = UDim2.new(0, 10, 0, 96)
scrollFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
scrollFrame.BackgroundTransparency = 0.1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 8
scrollFrame.ZIndex = 13
scrollFrame.Parent = mainFrame
local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollFrame


-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 32, 0, 32)
minimizeButton.Position = UDim2.new(1, -80, 0, 8)
minimizeButton.AnchorPoint = Vector2.new(0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextStrokeTransparency = 0.5
minimizeButton.TextStrokeColor3 = Color3.fromRGB(60, 60, 60)
minimizeButton.TextScaled = true
minimizeButton.Font = Enum.Font.GothamBlack
minimizeButton.ZIndex = 30
minimizeButton.Parent = mainFrame
local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 12)
minimizeCorner.Parent = minimizeButton
local minimizeStroke = Instance.new("UIStroke")
minimizeStroke.Thickness = 2
minimizeStroke.Color = Color3.fromRGB(255, 255, 255)
minimizeStroke.Parent = minimizeButton

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -40, 0, 8)
closeButton.AnchorPoint = Vector2.new(0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextStrokeTransparency = 0.5
closeButton.TextStrokeColor3 = Color3.fromRGB(60, 60, 60)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBlack
closeButton.ZIndex = 30
closeButton.Parent = mainFrame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeButton
local closeStroke = Instance.new("UIStroke")
closeStroke.Thickness = 2
closeStroke.Color = Color3.fromRGB(255, 255, 255)
closeStroke.Parent = closeButton
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Minimize logic
local minimized = false
local function setMinimized(state)
    minimized = state
    searchBox.Visible = not minimized
    scrollFrame.Visible = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 400, 0, 56)
    else
        mainFrame.Size = UDim2.new(0, 400, 0, 500)
    end
end
minimizeButton.MouseButton1Click:Connect(function()
    setMinimized(not minimized)
end)
setMinimized(false)

-- Helper: get all NPCs in workspace (Models or BaseParts with Humanoid or HumanoidRootPart)
local function getAllNPCs()
    local npcs = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            table.insert(npcs, obj)
        elseif obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") and obj.Parent:FindFirstChildOfClass("Humanoid") then
            -- skip, already added as model
        end
    end
    return npcs
end

local function getNPCDisplayName(npc)
    if npc.Name ~= "" then return npc.Name end
    return npc:GetFullName()
end

local function teleportToNPC(npc)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local cf
    if npc:IsA("Model") then
        if npc.PrimaryPart then
            cf = npc.PrimaryPart.CFrame
        else
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:IsA("BasePart") then
                cf = hrp.CFrame
            else
                local firstPart = npc:FindFirstChildWhichIsA("BasePart")
                if firstPart then
                    cf = firstPart.CFrame
                end
            end
        end
    elseif npc:IsA("BasePart") then
        cf = npc.CFrame
    end
    if cf then
        root.CFrame = cf + Vector3.new(0, 3, 0)
    end
end

local function refreshNPCList(filter)
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local npcs = getAllNPCs()
    local y = 0
    local found = 0
    for _, npc in ipairs(npcs) do
        local name = getNPCDisplayName(npc)
        if not filter or filter == "" or string.find(string.lower(name), string.lower(filter), 1, true) then
            found = found + 1
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 36)
            btn.Position = UDim2.new(0, 4, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextScaled = true
            btn.Font = Enum.Font.GothamBold
            btn.ZIndex = 14
            btn.Parent = scrollFrame
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            btn.MouseButton1Click:Connect(function()
                teleportToNPC(npc)
            end)
            y = y + 40
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y)
    if found == 0 then
        local noResult = Instance.new("TextLabel")
        noResult.Size = UDim2.new(1, -8, 0, 36)
        noResult.Position = UDim2.new(0, 4, 0, 0)
        noResult.BackgroundTransparency = 1
        noResult.Text = "No NPCs found."
        noResult.TextColor3 = Color3.fromRGB(255, 180, 180)
        noResult.TextScaled = true
        noResult.Font = Enum.Font.Gotham
        noResult.ZIndex = 14
        noResult.Parent = scrollFrame
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshNPCList(searchBox.Text)
end)

-- Initial population
refreshNPCList("")

-- Optionally, you can add a hotkey to toggle this GUI
-- Example: open with RightShift
--[[
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)
]]
