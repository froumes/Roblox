local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")



local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")




local CURSE_ASSET_IDS = {
    "rbxassetid://94734246361320",
    "rbxassetid://128960075980851",
    "rbxassetid://131770445081586",
    "rbxassetid://102308191455123",
    "rbxassetid://132403000977312",
    "rbxassetid://105399018590765",
    "rbxassetid://129472130637846",
}



local selectedAssets = {} -- up to 2 selected asset IDs
local minValues = {0, 0} -- min value for icon 1 and icon 2



local FRAME_WIDTH = 500
local FRAME_HEIGHT = 400
local ICON_SIZE = 48
local ICON_SPACING = 12
local ICON_ROW_Y = 60
local ICONS_PER_ROW = 7





local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CurseSelectionGUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1000
screenGui.Parent = playerGui





local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 1
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10,10,118,118)
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.Position = UDim2.new(0, -12, 0, -12)
shadow.ZIndex = 9
shadow.Parent = screenGui




local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, FRAME_WIDTH, 0, FRAME_HEIGHT)
mainFrame.Position = UDim2.new(0.5, -FRAME_WIDTH/2, 0.15, 0)
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

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, FRAME_WIDTH, 0, FRAME_HEIGHT)
mainFrame.Position = UDim2.new(0.5, -FRAME_WIDTH/2, 0.15, 0)
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
title.Text = "Curse Tracker"
title.TextColor3 = Color3.fromRGB(180, 200, 255)
title.TextStrokeTransparency = 0.7
title.TextStrokeColor3 = Color3.fromRGB(60, 60, 120)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame
title.ZIndex = 11




local selectorLabel = Instance.new("TextLabel")
selectorLabel.Size = UDim2.new(1, -20, 0, 28)
selectorLabel.Position = UDim2.new(0, 10, 0, 48)
selectorLabel.BackgroundTransparency = 1
selectorLabel.Text = "Select up to 2 curse icons:"
selectorLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
selectorLabel.TextScaled = true
selectorLabel.Font = Enum.Font.Gotham
selectorLabel.TextXAlignment = Enum.TextXAlignment.Left
selectorLabel.Parent = mainFrame
selectorLabel.ZIndex = 12






local legendLabel = Instance.new("TextLabel")
legendLabel.Size = UDim2.new(1, -120, 0, 20)
legendLabel.Position = UDim2.new(0, 10, 0, 140)
legendLabel.BackgroundTransparency = 1
legendLabel.Text = "Icon 1: Yellow  |  Icon 2: Cyan"
legendLabel.TextColor3 = Color3.fromRGB(220, 220, 180)
legendLabel.TextScaled = false
legendLabel.Font = Enum.Font.Gotham
legendLabel.TextSize = 16
legendLabel.TextXAlignment = Enum.TextXAlignment.Left
legendLabel.ZIndex = 14
legendLabel.Parent = mainFrame

-- Teleport button to the right of the legend
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 130, 0, 20)
tpButton.Position = UDim2.new(1, -160, 0, 140)
tpButton.AnchorPoint = Vector2.new(0, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
tpButton.Text = "Teleport to Curse"
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.TextScaled = false
tpButton.TextSize = 14
tpButton.Font = Enum.Font.GothamBold
tpButton.ZIndex = 15
tpButton.Parent = mainFrame
local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = tpButton
tpButton.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    local target = workspace:FindFirstChild("Lobby")
    if target and target:FindFirstChild("NPC") and target.NPC:FindFirstChild("ApplyCurse") and root then
        local applyCurse = target.NPC.ApplyCurse
        local cf
        if applyCurse:IsA("BasePart") then
            cf = applyCurse.CFrame
        elseif applyCurse:IsA("Model") then
            if applyCurse.PrimaryPart then
                cf = applyCurse.PrimaryPart.CFrame
            else
                local hrp = applyCurse:FindFirstChild("HumanoidRootPart")
                if hrp and hrp:IsA("BasePart") then
                    cf = hrp.CFrame
                else
                    local firstPart = applyCurse:FindFirstChildWhichIsA("BasePart")
                    if firstPart then
                        cf = firstPart.CFrame
                    end
                end
            end
        end
        if cf then
            root.CFrame = cf + Vector3.new(0, 3, 0)
        end
    end
end)




local iconButtons = {}
for i, assetId in ipairs(CURSE_ASSET_IDS) do
    local col = (i-1) % ICONS_PER_ROW
    local row = math.floor((i-1) / ICONS_PER_ROW)
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE)
    btn.Position = UDim2.new(0, 10 + col * (ICON_SIZE + ICON_SPACING), 0, ICON_ROW_Y + row * (ICON_SIZE + ICON_SPACING) + 18)
    btn.Image = assetId
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    btn.BorderSizePixel = 0
    btn.ZIndex = 13
    btn.Parent = mainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    iconButtons[i] = btn
end




local function updateIconSelections()
    for i, btn in ipairs(iconButtons) do
        if table.find(selectedAssets, CURSE_ASSET_IDS[i]) then
            btn.BackgroundColor3 = Color3.fromRGB(120, 200, 120)
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
        end
    end
    if updateCurses then updateCurses() end
end
for i, btn in ipairs(iconButtons) do
    btn.MouseButton1Click:Connect(function()
        local assetId = CURSE_ASSET_IDS[i]
        if table.find(selectedAssets, assetId) then
            for j, v in ipairs(selectedAssets) do
                if v == assetId then table.remove(selectedAssets, j) break end
            end
        else
            if #selectedAssets < 2 then
                table.insert(selectedAssets, assetId)
            else
                selectedAssets[1] = selectedAssets[2]
                selectedAssets[2] = assetId
            end
        end
        updateIconSelections()
    end)
end
updateIconSelections()




local minLabel1 = Instance.new("TextLabel")
minLabel1.Size = UDim2.new(0, 120, 0, 28)
minLabel1.Position = UDim2.new(0, 10, 0, 180)
minLabel1.BackgroundTransparency = 1
minLabel1.Text = "Min Value 1:"
minLabel1.TextColor3 = Color3.fromRGB(200, 200, 255)
minLabel1.TextScaled = true
minLabel1.Font = Enum.Font.Gotham
minLabel1.TextXAlignment = Enum.TextXAlignment.Left
minLabel1.Parent = mainFrame
minLabel1.ZIndex = 12


local minBox1 = Instance.new("TextBox")
minBox1.Size = UDim2.new(0, 60, 0, 28)
minBox1.Position = UDim2.new(0, 130, 0, 180)
minBox1.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
minBox1.Text = tostring(minValues[1])
minBox1.TextColor3 = Color3.fromRGB(255, 255, 255)
minBox1.TextScaled = true
minBox1.Font = Enum.Font.Gotham
minBox1.ClearTextOnFocus = false
minBox1.Parent = mainFrame
minBox1.ZIndex = 12
local minCorner1 = Instance.new("UICorner")
minCorner1.CornerRadius = UDim.new(0, 6)
minCorner1.Parent = minBox1
minBox1.FocusLost:Connect(function()
    local v = tonumber(minBox1.Text)
    if v then
        minValues[1] = v
        minBox1.Text = tostring(minValues[1])
    else
        minBox1.Text = tostring(minValues[1])
    end
end)



local minLabel2 = Instance.new("TextLabel")
minLabel2.Size = UDim2.new(0, 120, 0, 28)
minLabel2.Position = UDim2.new(0, 210, 0, 180)
minLabel2.BackgroundTransparency = 1
minLabel2.Text = "Min Value 2:"
minLabel2.TextColor3 = Color3.fromRGB(200, 200, 255)
minLabel2.TextScaled = true
minLabel2.Font = Enum.Font.Gotham
minLabel2.TextXAlignment = Enum.TextXAlignment.Left
minLabel2.Parent = mainFrame
minLabel2.ZIndex = 12


local minBox2 = Instance.new("TextBox")
minBox2.Size = UDim2.new(0, 60, 0, 28)
minBox2.Position = UDim2.new(0, 330, 0, 180)
minBox2.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
minBox2.Text = tostring(minValues[2])
minBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
minBox2.TextScaled = true
minBox2.Font = Enum.Font.Gotham
minBox2.ClearTextOnFocus = false
minBox2.Parent = mainFrame
minBox2.ZIndex = 12
local minCorner2 = Instance.new("UICorner")
minCorner2.CornerRadius = UDim.new(0, 6)
minCorner2.Parent = minBox2
minBox2.FocusLost:Connect(function()
    local v = tonumber(minBox2.Text)
    if v then
        minValues[2] = v
        minBox2.Text = tostring(minValues[2])
    else
        minBox2.Text = tostring(minValues[2])
    end
end)

-- Curse 1
local stat1Label = Instance.new("TextLabel")
stat1Label.Size = UDim2.new(1, -110, 0, 48)
stat1Label.Position = UDim2.new(0, 90, 0, 230)
stat1Label.BackgroundTransparency = 0.2
stat1Label.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
stat1Label.Text = "Curse 1: ..."
stat1Label.TextColor3 = Color3.fromRGB(255, 255, 255)
stat1Label.TextScaled = true
stat1Label.Font = Enum.Font.Gotham
stat1Label.Parent = mainFrame
stat1Label.ZIndex = 11
local stat1Corner = Instance.new("UICorner")
stat1Corner.CornerRadius = UDim.new(0, 8)
stat1Corner.Parent = stat1Label
local stat1Icon = Instance.new("ImageLabel")
stat1Icon.Size = UDim2.new(0, 64, 0, 64)
stat1Icon.Position = UDim2.new(0, 10, 0, 226)
stat1Icon.BackgroundTransparency = 1
stat1Icon.Image = ""
stat1Icon.ZIndex = 12
stat1Icon.Parent = mainFrame

-- Green indicator for Curse 1
local stat1Indicator = Instance.new("ImageLabel")
stat1Indicator.Size = UDim2.new(0, 28, 0, 28)
stat1Indicator.Position = UDim2.new(0, 70, 0, 238)
stat1Indicator.BackgroundTransparency = 1
stat1Indicator.Image = "rbxassetid://6031094678" -- Roblox green checkmark icon
stat1Indicator.ImageColor3 = Color3.fromRGB(60, 220, 80)
stat1Indicator.Visible = false
stat1Indicator.ZIndex = 31
stat1Indicator.Parent = mainFrame

-- Curse 2
local stat2Label = Instance.new("TextLabel")
stat2Label.Size = UDim2.new(1, -110, 0, 48)
stat2Label.Position = UDim2.new(0, 90, 0, 284)
stat2Label.BackgroundTransparency = 0.2
stat2Label.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
stat2Label.Text = "Curse 2: ..."
stat2Label.TextColor3 = Color3.fromRGB(255, 255, 255)
stat2Label.TextScaled = true
stat2Label.Font = Enum.Font.Gotham
stat2Label.Parent = mainFrame
stat2Label.ZIndex = 11
local stat2Corner = Instance.new("UICorner")
stat2Corner.CornerRadius = UDim.new(0, 8)
stat2Corner.Parent = stat2Label
local stat2Icon = Instance.new("ImageLabel")
stat2Icon.Size = UDim2.new(0, 64, 0, 64)
stat2Icon.Position = UDim2.new(0, 10, 0, 280)
stat2Icon.BackgroundTransparency = 1
stat2Icon.Image = ""
stat2Icon.ZIndex = 12
stat2Icon.Parent = mainFrame
-- Green indicator for Curse 2
local stat2Indicator = Instance.new("ImageLabel")
stat2Indicator.Size = UDim2.new(0, 28, 0, 28)
stat2Indicator.Position = UDim2.new(0, 70, 0, 292)
stat2Indicator.BackgroundTransparency = 1
stat2Indicator.Image = "rbxassetid://6031094678" -- Roblox green checkmark icon
stat2Indicator.ImageColor3 = Color3.fromRGB(60, 220, 80)
stat2Indicator.Visible = false
stat2Indicator.ZIndex = 31
stat2Indicator.Parent = mainFrame

-- Combined indicator
local combinedIndicator = Instance.new("ImageLabel")
combinedIndicator.Size = UDim2.new(0, 44, 0, 44)
combinedIndicator.Position = UDim2.new(0.5, -22, 0, 120)
combinedIndicator.BackgroundTransparency = 1
combinedIndicator.Image = "rbxassetid://6031094678"
combinedIndicator.ImageColor3 = Color3.fromRGB(60, 220, 80)
combinedIndicator.Visible = false
combinedIndicator.ZIndex = 41
combinedIndicator.Parent = mainFrame


-- Start/Stop Button
local isRolling = false
local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0, 100, 0, 36)
startButton.Position = UDim2.new(0.5, -50, 1, -24)
startButton.AnchorPoint = Vector2.new(0, 0)
startButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
startButton.Text = "Start"
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.TextScaled = true
startButton.Font = Enum.Font.GothamBold
startButton.ZIndex = 50
startButton.Parent = mainFrame
local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 10)
startCorner.Parent = startButton

-- Close button (top right X)
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
    isRolling = false
    screenGui:Destroy()
end)

-- Rolling logic
local function getCombinedIndicator()
    -- Use the same logic as combinedIndicator.Visible
    local statsRoot = playerGui:FindFirstChild("ApplyCurse")
    if not statsRoot then return false end
    local statsMain = statsRoot:FindFirstChild("Main")
    if not statsMain then return false end
    local statsBase = statsMain:FindFirstChild("Base")
    if not statsBase then return false end
    local statsStats = statsBase:FindFirstChild("Stats")
    if not statsStats then return false end
    local statsMain2 = statsStats:FindFirstChild("Main")
    if not statsMain2 then return false end
    local found, iconAssets, buffAssets = {},{},{}
    for _, statTemp in ipairs(statsMain2:GetChildren()) do
        if statTemp.Name == "StatTemp" then
            local val = statTemp:FindFirstChild("Value")
            local icon = statTemp:FindFirstChild("StatsIconic")
            local buff = statTemp:FindFirstChild("BuffIconic")
            if val and val:IsA("TextLabel") then
                table.insert(found, val.Text)
                if icon and icon:IsA("ImageLabel") then
                    table.insert(iconAssets, icon.Image)
                else
                    table.insert(iconAssets, "")
                end
                if buff and buff:IsA("ImageLabel") then
                    table.insert(buffAssets, buff.Image)
                else
                    table.insert(buffAssets, "")
                end
            else
                table.insert(iconAssets, "")
                table.insert(buffAssets, "")
            end
        end
    end
    local function isGood(icon, buffIcon, valueText, selIcon, minVal)
        if not icon or not buffIcon or not selIcon then return false end
        if icon ~= selIcon then return false end
        if buffIcon ~= "rbxassetid://73853750530888" then return false end
        local num = tonumber(string.match(valueText or "", "([%d]+)"))
        if not num then return false end
        return num >= minVal
    end
    local good1, good2 = false, false
    if selectedAssets[1] then
        good1 = isGood(iconAssets[1], buffAssets[1], found[1], selectedAssets[1], minValues[1])
        good2 = isGood(iconAssets[2], buffAssets[2], found[2], selectedAssets[1], minValues[1])
    end
    if selectedAssets[2] then
        good1 = good1 or isGood(iconAssets[1], buffAssets[1], found[1], selectedAssets[2], minValues[2])
        good2 = good2 or isGood(iconAssets[2], buffAssets[2], found[2], selectedAssets[2], minValues[2])
    end
    if #selectedAssets == 1 then
        return good1 or good2
    elseif #selectedAssets == 2 then
        local match1 = isGood(iconAssets[1], buffAssets[1], found[1], selectedAssets[1], minValues[1])
        local match2 = isGood(iconAssets[2], buffAssets[2], found[2], selectedAssets[2], minValues[2])
        local match1b = isGood(iconAssets[1], buffAssets[1], found[1], selectedAssets[2], minValues[2])
        local match2b = isGood(iconAssets[2], buffAssets[2], found[2], selectedAssets[1], minValues[1])
        return (match1 and match2) or (match1b and match2b)
    else
        return false
    end
end




local function rollOnce()
    local rollBtn = nil
    pcall(function()
        rollBtn = playerGui.ApplyCurse.Main.Base.Button.Curse
    end)
    if rollBtn and rollBtn:IsA("TextButton") then
        GuiService.SelectedObject = rollBtn
        VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    end
end



local function unselectRollBtn()
    if GuiService.SelectedObject then
        GuiService.SelectedObject = nil
    end
end




local function startRolling()
    if isRolling then return end
    isRolling = true
    startButton.Text = "Stop"
    while isRolling do
        if getCombinedIndicator() then
            isRolling = false
            startButton.Text = "Start"
            break
        end
        rollOnce()
        wait(0.5)
    end
    startButton.Text = "Start"
    unselectRollBtn()
end

startButton.MouseButton1Click:Connect(function()
    if isRolling then
        isRolling = false
        startButton.Text = "Start"
        unselectRollBtn()
    else
        startRolling()
    end
end)




function updateCurses()
    -- Find the relevant UI
    local statsRoot = playerGui:FindFirstChild("ApplyCurse")
    if not statsRoot then print("[CurseGUI] ApplyCurse not found in PlayerGui"); return end
    local statsMain = statsRoot:FindFirstChild("Main")
    if not statsMain then print("[CurseGUI] Main not found under ApplyCurse"); return end
    local statsBase = statsMain:FindFirstChild("Base")
    if not statsBase then print("[CurseGUI] Base not found under Main"); return end
    local statsStats = statsBase:FindFirstChild("Stats")
    if not statsStats then print("[CurseGUI] Stats not found under Base"); return end
    local statsMain2 = statsStats:FindFirstChild("Main")
    if not statsMain2 then print("[CurseGUI] Main not found under Stats"); return end

    local found, valueObjects, iconAssets, buffAssets = {}, {}, {}, {}
    for _, statTemp in ipairs(statsMain2:GetChildren()) do
        if statTemp.Name == "StatTemp" then
            local val = statTemp:FindFirstChild("Value")
            local icon = statTemp:FindFirstChild("StatsIconic")
            local buff = statTemp:FindFirstChild("BuffIconic")
            if val and val:IsA("TextLabel") then
                table.insert(found, val.Text)
                table.insert(valueObjects, val)
                if icon and icon:IsA("ImageLabel") then
                    table.insert(iconAssets, icon.Image)
                else
                    table.insert(iconAssets, "")
                end
                if buff and buff:IsA("ImageLabel") then
                    table.insert(buffAssets, buff.Image)
                else
                    table.insert(buffAssets, "")
                end
            else
                table.insert(iconAssets, "")
                table.insert(buffAssets, "")
            end
        end
    end

    -- Update curse labels and icons
    stat1Label.Text = "Curse 1: " .. (found[1] or "...")
    stat2Label.Text = "Curse 2: " .. (found[2] or "...")
    stat1Icon.Image = iconAssets[1] or ""
    stat2Icon.Image = iconAssets[2] or ""

    -- Helper to check if a curse matches a selected icon, BuffIconic, and min value
    local function isGood(icon, buffIcon, valueText, selIcon, minVal)
        if not icon or not buffIcon or not selIcon then return false end
        if icon ~= selIcon then return false end
        if buffIcon ~= "rbxassetid://73853750530888" then return false end
        local num = tonumber(string.match(valueText or "", "([%d]+)"))
        if not num then return false end
        return num >= minVal
    end

    -- Show which icon is 1 and 2
    for i, btn in ipairs(iconButtons) do
        if selectedAssets[1] == CURSE_ASSET_IDS[i] then
            btn.ImageColor3 = Color3.fromRGB(255, 255, 180) -- highlight icon 1
        elseif selectedAssets[2] == CURSE_ASSET_IDS[i] then
            btn.ImageColor3 = Color3.fromRGB(180, 255, 255) -- highlight icon 2
        else
            btn.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
    end

    -- Individual indicators
    stat1Indicator.Visible = false
    stat2Indicator.Visible = false
    local good1, good2 = false, false
    if selectedAssets[1] then
        good1 = isGood(iconAssets[1], buffAssets[1], found[1], selectedAssets[1], minValues[1])
        good2 = isGood(iconAssets[2], buffAssets[2], found[2], selectedAssets[1], minValues[1])
    end
    if selectedAssets[2] then
        good1 = good1 or isGood(iconAssets[1], buffAssets[1], found[1], selectedAssets[2], minValues[2])
        good2 = good2 or isGood(iconAssets[2], buffAssets[2], found[2], selectedAssets[2], minValues[2])
    end
    stat1Indicator.Visible = good1
    stat2Indicator.Visible = good2

    -- Combined indicator logic
    if #selectedAssets == 1 then
        combinedIndicator.Visible = good1 or good2
    elseif #selectedAssets == 2 then
        -- Both icons must be matched, one per curse (order doesn't matter)
        local match1 = isGood(iconAssets[1], buffAssets[1], found[1], selectedAssets[1], minValues[1])
        local match2 = isGood(iconAssets[2], buffAssets[2], found[2], selectedAssets[2], minValues[2])
        local match1b = isGood(iconAssets[1], buffAssets[1], found[1], selectedAssets[2], minValues[2])
        local match2b = isGood(iconAssets[2], buffAssets[2], found[2], selectedAssets[1], minValues[1])
        combinedIndicator.Visible = (match1 and match2) or (match1b and match2b)
    else
        combinedIndicator.Visible = false
    end

    -- Connect change events for live updates
    if not screenGui._curseConnections then screenGui._curseConnections = {} end
    for _, conn in ipairs(screenGui._curseConnections) do pcall(function() conn:Disconnect() end) end
    screenGui._curseConnections = {}
    for _, valObj in ipairs(valueObjects) do
        local conn = valObj:GetPropertyChangedSignal("Text"):Connect(function()
            print("[CurseGUI] Value.Text changed: ", valObj:GetFullName(), valObj.Text)
            updateCurses()
        end)
        table.insert(screenGui._curseConnections, conn)
    end

    -- Listen for StatTemp children being added/removed
    if screenGui._mainChildConn then pcall(function() screenGui._mainChildConn:Disconnect() end) end
    if screenGui._mainChildConn2 then pcall(function() screenGui._mainChildConn2:Disconnect() end) end
    screenGui._mainChildConn = statsMain2.ChildAdded:Connect(function()
        print("[CurseGUI] StatTemp added, updating curses.")
        updateCurses()
    end)
    screenGui._mainChildConn2 = statsMain2.ChildRemoved:Connect(function()
        print("[CurseGUI] StatTemp removed, updating curses.")
        updateCurses()
    end)
end





-- Initial update
pcall(updateCurses)
