-- Nyxn Hub V1.0 for Blox Fruits
-- Author: Nyxn Hub Team
-- Version: 1.0 (September 2025, Update 24/25 Compatible)
-- Description: Advanced script with auto-farm, aimbot, ESP, teleports, and cinematic UI
-- Key: Hidden (NYXN) | Discord: https://discord.gg/bYxcFhy8R
-- Warning: Violates Roblox ToS. Use alt accounts in private servers.

-- Initialize Roblox services for game interaction
local Players = game:GetService("Players") -- Manages player data
local UserInputService = game:GetService("UserInputService") -- Handles user inputs
local RunService = game:GetService("RunService") -- Manages game loop
local TweenService = game:GetService("TweenService") -- Handles UI animations
local ReplicatedStorage = game:GetService("ReplicatedStorage") -- Accesses remote events
local Workspace = game:GetService("Workspace") -- Interacts with game world
local VirtualUser = game:GetService("VirtualUser") -- Simulates user inputs
local SoundService = game:GetService("SoundService") -- Manages sound effects
local LocalPlayer = Players.LocalPlayer -- References local player
local Camera = Workspace.CurrentCamera -- Controls camera perspective

-- Configuration settings for script behavior
local Settings = {
    JoinTeam = "Pirates", -- Default team for auto-join
    FarmSpeed = 0.3, -- Speed of farming loop (seconds)
    AimbotRange = 100, -- Aimbot maximum distance (studs)
    ESPRefresh = 2, -- ESP update interval (seconds)
    AutoStatPoints = 3, -- Points per auto-stat upgrade
    WalkSpeed = 16, -- Default walk speed
    JumpPower = 50, -- Default jump power
    KillAuraRange = 20 -- Kill aura radius (studs)
}

-- Global toggles to control feature states
getgenv().NyxnHubToggles = {
    AutoFarmLevel = false, -- Auto farm level (melee, fly)
    AutoFarmBoss = false, -- Auto farm bosses
    AutoFruitSniper = false, -- Auto collect fruits
    AutoMastery = false, -- Auto mastery for gun/fruit
    AutoQuest = false, -- Auto accept quests
    AutoAwaken = false, -- Auto awaken fruits
    AutoChest = false, -- Auto collect chests
    Aimbot = false, -- Click-based aimbot
    ESP = false, -- Player ESP
    ESPEnemies = false, -- Enemy NPC ESP
    ESPItems = false, -- Fruit/chest ESP
    AutoRaid = false, -- Auto join raids
    AutoSkills = false, -- Auto use skills
    NoStun = false, -- Disable stun/knockback
    KillAura = false, -- Melee kill aura
    AutoStats = false, -- Auto upgrade stats
    AutoRaceV4 = false, -- Auto Race V4
    AutoSeaEvents = false, -- Auto sea events
    AutoTiki = false, -- Auto Tiki Outpost
    AutoVolcano = false, -- Auto Volcano event
    InfiniteYield = false, -- Infinite yield commands
    SpeedHack = false, -- Speed hack
    JumpHack = false, -- Jump hack
    NoClip = false, -- No clip through walls
    InfStamina = false, -- Infinite stamina
    WalkOnWater = false, -- Walk on water
    Invisible = false, -- Invisibility
    Fullbright = false, -- Fullbright lighting
    ShowHitboxes = false, -- Show enemy hitboxes
    AutoDodge = false, -- Auto dodge attacks
    ESPFruits = false, -- Fruit-specific ESP
    ESPChests = false -- Chest-specific ESP
}

-- Teleport locations (CFrames for precise positioning)
local Teleports = {
    ["Battle of the Gods"] = CFrame.new(-4600, 20, -3600),
    ["Campfire"] = CFrame.new(-1660, 15, 1040),
    ["Castle on the Sea"] = CFrame.new(-5080, 314, -3100),
    ["Cave Island"] = CFrame.new(-4500, 20, -4300),
    ["Celestial Domain"] = CFrame.new(-7900, 5634, -380),
    ["Colosseum (First Sea)"] = CFrame.new(-1428, 7, -3017),
    ["Cursed Ship"] = CFrame.new(923, 125, 32885),
    ["Dark Arena"] = CFrame.new(3870, 5, -3850),
    ["Desert"] = CFrame.new(944, 7, 4375),
    ["Dojo Vault"] = CFrame.new(-5070, 314, -3150),
    ["Floating Turtle"] = CFrame.new(-13250, 332, -7770),
    ["Forgotten Island"] = CFrame.new(-3050, 10, -10150),
    ["Fountain City"] = CFrame.new(5127, 2, 4008),
    ["Freezing Hydra Island"] = CFrame.new(5250, 602, -700),
    ["Frozen Dimension"] = CFrame.new(4000, 20, -4000),
    ["Frozen Village"] = CFrame.new(1047, 7, 1100),
    ["Graveyard Island"] = CFrame.new(-5410, 7, -750),
    ["Great Tree"] = CFrame.new(-6500, 332, -8600),
    ["Green Zone"] = CFrame.new(-2448, 73, -3215),
    ["Haunted Castle"] = CFrame.new(-9515, 142, -5600),
    ["Haunted Shipwreck"] = CFrame.new(-970, 10, -6000),
    ["Hot and Cold"] = CFrame.new(-5900, 15, -5000),
    ["Hydra Island"] = CFrame.new(5225, 602, -650),
    ["Ice Castle"] = CFrame.new(5500, 40, -6100),
    ["Indra Island"] = CFrame.new(-2700, 10, -2700),
    ["Jean-Luc Island"] = CFrame.new(-2000, 10, -2000),
    ["Jungle"] = CFrame.new(-1600, 37, 150),
    ["Kingdom of Rose"] = CFrame.new(-750, 8, -1300),
    ["Kitsune Island"] = CFrame.new(-9500, 20, -9500),
    ["Liberation of Tiki Outpost"] = CFrame.new(-6500, 10, -6500),
    ["Magma Village"] = CFrame.new(-5240, 8, 4300),
    ["Marine Fortress"] = CFrame.new(-4800, 20, 4370),
    ["Marine Starter"] = CFrame.new(980, 7, 4375),
    ["Middle Town"] = CFrame.new(-650, 7, 1600),
    ["Mirage Island"] = CFrame.new(-6500, 10, -6500),
    ["North Pole"] = CFrame.new(1000, 10, -1000),
    ["Party Realm"] = CFrame.new(-2000, 10, -2000),
    ["Pirate Starter"] = CFrame.new(-425, 7, 1830),
    ["Pirate Village"] = CFrame.new(-1120, 4, 3850),
    ["Port Town"] = CFrame.new(-310, 7, 5300),
    ["Prehistoric Island"] = CFrame.new(-2500, 10, -2500),
    ["Prison"] = CFrame.new(4875, 5, 735),
    ["Remote Island"] = CFrame.new(-650, 20, -5700),
    ["Rip Family x Red Legion Arena"] = CFrame.new(-3000, 10, -3000),
    ["Sea of Treats"] = CFrame.new(-2000, 10, -6725),
    ["Skylands"] = CFrame.new(-7902, 5634, -383),
    ["Snow Mountain"] = CFrame.new(560, 400, -5350),
    ["Submerged Island"] = CFrame.new(-2500, -10, -2500),
    ["Swan's Room"] = CFrame.new(2280, 15, 905),
    ["Tiki Outpost"] = CFrame.new(-16500, 10, -16500),
    ["Treasure Island"] = CFrame.new(-3000, 10, -3000),
    ["Underwater City"] = CFrame.new(2260, 2, 4000),
    ["Upper Skylands"] = CFrame.new(-7900, 5634, -400),
    ["Whirlpool"] = CFrame.new(-4000, 0, -4000)
}

-- Key system variables
local KeyFile = "NyxnHubKeyV1.txt" -- File to store key
local CorrectKey = "NYXN" -- Hidden key for authentication

-- Create main ScreenGui for UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NyxnHubV1"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- Cutscene frame for welcome animation
local CutsceneFrame = Instance.new("Frame")
CutsceneFrame.Name = "CutsceneFrame"
CutsceneFrame.Size = UDim2.new(1, 0, 1, 0)
CutsceneFrame.Position = UDim2.new(0, 0, 0, 0)
CutsceneFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CutsceneFrame.BackgroundTransparency = 0
CutsceneFrame.BorderSizePixel = 0
CutsceneFrame.ClipsDescendants = true
CutsceneFrame.Parent = ScreenGui

-- Welcome logo for cutscene
local Logo = Instance.new("TextLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 300, 0, 100)
Logo.Position = UDim2.new(0.5, -150, 0.5, -50)
Logo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "Nyxn Hub V1.0"
Logo.TextColor3 = Color3.fromRGB(0, 255, 255)
Logo.TextScaled = true
Logo.TextWrapped = true
Logo.Font = Enum.Font.GothamBlack
Logo.TextTransparency = 1
Logo.TextStrokeTransparency = 0.8
Logo.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Logo.Parent = CutsceneFrame

-- Stroke for logo text
local LogoStroke = Instance.new("UIStroke")
LogoStroke.Name = "LogoStroke"
LogoStroke.Color = Color3.fromRGB(255, 255, 255)
LogoStroke.Thickness = 1.5
LogoStroke.Transparency = 0
LogoStroke.Parent = Logo

-- Startup sound for cutscene
local StartupSound = Instance.new("Sound")
StartupSound.Name = "StartupSound"
StartupSound.SoundId = "rbxasset://sounds/uuhhh.wav"
StartupSound.Volume = 0.5
StartupSound.Looped = false
StartupSound.Parent = CutsceneFrame

-- Function to play cutscene animation
local function PlayCutscene()
    pcall(function()
        print("Starting cutscene animation")
        StartupSound:Play()
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0)
        TweenService:Create(Logo, tweenInfo, {TextTransparency = 0}):Play()
        TweenService:Create(CutsceneFrame, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 1), {BackgroundTransparency = 1}):Play()
        wait(2.5)
        CutsceneFrame:Destroy()
        print("Cutscene animation completed")
    end)
end

-- Toggle button for showing/hiding UI
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.02, 0, 0.02, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ToggleButton.BackgroundTransparency = 0
ToggleButton.Text = "NH"
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.TextWrapped = true
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.TextTransparency = 0
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.Name = "ToggleCorner"
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Name = "ToggleStroke"
ToggleStroke.Color = Color3.fromRGB(0, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Transparency = 0
ToggleStroke.Parent = ToggleButton

-- Hover effect for toggle button
ToggleButton.MouseEnter:Connect(function()
    pcall(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        print("Toggle button hover started")
    end)
end)
ToggleButton.MouseLeave:Connect(function()
    pcall(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(10, 10, 10)}):Play()
        print("Toggle button hover ended")
    end)
end)

-- Main UI frame (mobile-optimized)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.Name = "MainCorner"
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Name = "MainStroke"
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0
MainStroke.Parent = MainFrame

-- Title bar for main UI
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BackgroundTransparency = 0
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.Name = "TitleCorner"
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Nyxn Hub V1.0"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.TextWrapped = true
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextTransparency = 0
TitleLabel.TextStrokeTransparency = 0.8
TitleLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Parent = TitleBar

-- Close button for main UI
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BackgroundTransparency = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.TextWrapped = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextTransparency = 0
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.Name = "CloseCorner"
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Key input frame
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 250, 0, 180)
KeyFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
KeyFrame.BackgroundTransparency = 0.1
KeyFrame.BorderSizePixel = 0
KeyFrame.Visible = true
KeyFrame.ClipsDescendants = true
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.Name = "KeyCorner"
KeyCorner.CornerRadius = UDim.new(0, 10)
KeyCorner.Parent = KeyFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Name = "KeyStroke"
KeyStroke.Color = Color3.fromRGB(0, 255, 255)
KeyStroke.Thickness = 1
KeyStroke.Transparency = 0
KeyStroke.Parent = KeyFrame

-- Key input label
local KeyLabel = Instance.new("TextLabel")
KeyLabel.Name = "KeyLabel"
KeyLabel.Size = UDim2.new(1, 0, 0, 30)
KeyLabel.Position = UDim2.new(0, 0, 0, 0)
KeyLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "Enter Nyxn Hub Key"
KeyLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
KeyLabel.TextScaled = true
KeyLabel.TextWrapped = true
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.TextTransparency = 0
KeyLabel.TextStrokeTransparency = 0.8
KeyLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
KeyLabel.Parent = KeyFrame

-- Key input box
local KeyInput = Instance.new("TextBox")
KeyInput.Name = "KeyInput"
KeyInput.Size = UDim2.new(0.9, 0, 0, 30)
KeyInput.Position = UDim2.new(0.05, 0, 0.25, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInput.BackgroundTransparency = 0
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter key..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextScaled = true
KeyInput.TextWrapped = true
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextTransparency = 0
KeyInput.BorderSizePixel = 0
KeyInput.Parent = KeyFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.Name = "KeyInputCorner"
KeyInputCorner.CornerRadius = UDim.new(0, 6)
KeyInputCorner.Parent = KeyInput

-- Submit key button
local SubmitKey = Instance.new("TextButton")
SubmitKey.Name = "SubmitKey"
SubmitKey.Size = UDim2.new(0.9, 0, 0, 30)
SubmitKey.Position = UDim2.new(0.05, 0, 0.45, 0)
SubmitKey.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
SubmitKey.BackgroundTransparency = 0
SubmitKey.Text = "Submit"
SubmitKey.TextColor3 = Color3.fromRGB(0, 0, 0)
SubmitKey.TextScaled = true
SubmitKey.TextWrapped = true
SubmitKey.Font = Enum.Font.GothamBold
SubmitKey.TextTransparency = 0
SubmitKey.BorderSizePixel = 0
SubmitKey.Parent = KeyFrame

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.Name = "SubmitCorner"
SubmitCorner.CornerRadius = UDim.new(0, 6)
SubmitCorner.Parent = SubmitKey

-- Get key button
local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Name = "GetKeyButton"
GetKeyButton.Size = UDim2.new(0.9, 0, 0, 30)
GetKeyButton.Position = UDim2.new(0.05, 0, 0.65, 0)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
GetKeyButton.BackgroundTransparency = 0
GetKeyButton.Text = "Get Key"
GetKeyButton.TextColor3 = Color3.fromRGB(0, 255, 255)
GetKeyButton.TextScaled = true
GetKeyButton.TextWrapped = true
GetKeyButton.Font = Enum.Font.GothamBold
GetKeyButton.TextTransparency = 0
GetKeyButton.BorderSizePixel = 0
GetKeyButton.Parent = KeyFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.Name = "GetKeyCorner"
GetKeyCorner.CornerRadius = UDim.new(0, 6)
GetKeyCorner.Parent = GetKeyButton

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Name = "GetKeyStroke"
GetKeyStroke.Color = Color3.fromRGB(0, 255, 255)
GetKeyStroke.Thickness = 1
GetKeyStroke.Transparency = 0
GetKeyStroke.Parent = GetKeyButton

-- Gear icon for Get Key button
local GearIcon = Instance.new("ImageLabel")
GearIcon.Name = "GearIcon"
GearIcon.Size = UDim2.new(0, 20, 0, 20)
GearIcon.Position = UDim2.new(0, 5, 0, 5)
GearIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
GearIcon.BackgroundTransparency = 1
GearIcon.Image = "rbxassetid://107349498"
GearIcon.ImageTransparency = 0
GearIcon.Parent = GetKeyButton

-- Hover effect for Get Key button
GetKeyButton.MouseEnter:Connect(function()
    pcall(function()
        TweenService:Create(GetKeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        TweenService:Create(GetKeyStroke, TweenInfo.new(0.2), {Thickness = 2}):Play()
        print("Get Key button hover started")
    end)
end)
GetKeyButton.MouseLeave:Connect(function()
    pcall(function()
        TweenService:Create(GetKeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        TweenService:Create(GetKeyStroke, TweenInfo.new(0.2), {Thickness = 1}):Play()
        print("Get Key button hover ended")
    end)
end)

-- Tab frame for navigation
local TabFrame = Instance.new("Frame")
TabFrame.Name = "TabFrame"
TabFrame.Size = UDim2.new(0, 120, 1, -40)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabFrame.BackgroundTransparency = 0
TabFrame.BorderSizePixel = 0
TabFrame.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Name = "TabList"
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 4)
TabList.FillDirection = Enum.FillDirection.Vertical
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabList.VerticalAlignment = Enum.VerticalAlignment.Top
TabList.Parent = TabFrame

-- Create tabs for feature categories
local Tabs = {"Farm", "Combat", "Visual", "Teleport", "Events", "Settings", "Scripts", "Misc"}
local TabContents = {}

-- Function to tween UI elements
local function TweenFrame(frame, size, pos, duration)
    pcall(function()
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)
        local tween = TweenService:Create(frame, tweenInfo, {Size = size, Position = pos})
        tween:Play()
        print("Tweening frame: " .. frame.Name .. " to Size: " .. tostring(size) .. ", Pos: " .. tostring(pos))
    end)
end

-- Function to play click sound
local function PlayClickSound(parent)
    local sound = Instance.new("Sound")
    sound.Name = "ClickSound"
    sound.SoundId = "rbxasset://sounds/click.wav"
    sound.Volume = 0.3
    sound.Looped = false
    sound.Parent = parent
    sound:Play()
    wait(0.5)
    sound:Destroy()
    print("Played click sound for: " .. parent.Name)
end

-- Function to create toggle UI element
local function CreateToggle(parent, text, toggleVar)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame_" .. toggleVar
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextScaled = true
    Label.TextWrapped = true
    Label.Font = Enum.Font.Gotham
    Label.TextTransparency = 0
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextStrokeTransparency = 0.8
    Label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    Label.Parent = ToggleFrame

    local Toggle = Instance.new("TextButton")
    Toggle.Name = "Toggle"
    Toggle.Size = UDim2.new(0, 50, 0, 20)
    Toggle.Position = UDim2.new(0.85, -25, 0, 5)
    Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Toggle.BackgroundTransparency = 0
    Toggle.Text = "OFF"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.TextScaled = true
    Toggle.TextWrapped = true
    Toggle.Font = Enum.Font.GothamBold
    Toggle.TextTransparency = 0
    Toggle.BorderSizePixel = 0
    Toggle.Parent = ToggleFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.Name = "ToggleCorner"
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = Toggle

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Name = "ToggleStroke"
    ToggleStroke.Color = Color3.fromRGB(0, 255, 255)
    ToggleStroke.Thickness = 1
    ToggleStroke.Transparency = 0
    ToggleStroke.Parent = Toggle

    Toggle.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().NyxnHubToggles[toggleVar] = not getgenv().NyxnHubToggles[toggleVar]
            Toggle.BackgroundColor3 = getgenv().NyxnHubToggles[toggleVar] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            Toggle.Text = getgenv().NyxnHubToggles[toggleVar] and "ON" or "OFF"
            PlayClickSound(Toggle)
            print("Toggled " .. toggleVar .. ": " .. tostring(getgenv().NyxnHubToggles[toggleVar]))
        end)
    end)

    Toggle.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Thickness = 2}):Play()
            print("Toggle hover started: " .. toggleVar)
        end)
    end)
    Toggle.MouseLeave:Connect(function()
        pcall(function()
            TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Thickness = 1}):Play()
            print("Toggle hover ended: " .. toggleVar)
        end)
    end)

    parent.CanvasSize = UDim2.new(0, 0, 0, parent.UIListLayout.AbsoluteContentSize.Y)
    print("Created toggle: " .. toggleVar)
end

-- Function to create button UI element
local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Button_" .. text
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.BackgroundTransparency = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(0, 255, 255)
    Button.TextScaled = true
    Button.TextWrapped = true
    Button.Font = Enum.Font.GothamBold
    Button.TextTransparency = 0
    Button.BorderSizePixel = 0
    Button.Parent = parent

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.Name = "BtnCorner"
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Name = "BtnStroke"
    BtnStroke.Color = Color3.fromRGB(0, 255, 255)
    BtnStroke.Thickness = 1
    BtnStroke.Transparency = 0
    BtnStroke.Parent = Button

    Button.MouseButton1Click:Connect(function()
        pcall(function()
            callback()
            PlayClickSound(Button)
            print("Clicked button: " .. text)
        end)
    end)

    Button.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            print("Button hover started: " .. text)
        end)
    end)
    Button.MouseLeave:Connect(function()
        pcall(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            print("Button hover ended: " .. text)
        end)
    end)

    parent.CanvasSize = UDim2.new(0, 0, 0, parent.UIListLayout.AbsoluteContentSize.Y)
    print("Created button: " .. text)
end

-- Function to create slider UI element
local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "SliderFrame_" .. text
    SliderFrame.Size = UDim2.new(1, 0, 0, 45)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, 0, 0, 15)
    Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextScaled = true
    Label.TextWrapped = true
    Label.Font = Enum.Font.Gotham
    Label.TextTransparency = 0
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextStrokeTransparency = 0.8
    Label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    Label.Parent = SliderFrame

    local Slider = Instance.new("TextButton")
    Slider.Name = "Slider"
    Slider.Size = UDim2.new(1, 0, 0, 8)
    Slider.Position = UDim2.new(0, 0, 0, 25)
    Slider.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Slider.BackgroundTransparency = 0
    Slider.Text = ""
    Slider.TextColor3 = Color3.fromRGB(0, 0, 0)
    Slider.TextScaled = true
    Slider.TextWrapped = true
    Slider.Font = Enum.Font.Gotham
    Slider.TextTransparency = 1
    Slider.BorderSizePixel = 0
    Slider.Parent = SliderFrame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.Name = "SliderCorner"
    SliderCorner.CornerRadius = UDim.new(0, 4)
    SliderCorner.Parent = Slider

    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    Fill.BackgroundTransparency = 0
    Fill.BorderSizePixel = 0
    Fill.Parent = Slider

    local FillCorner = Instance.new("UICorner")
    FillCorner.Name = "FillCorner"
    FillCorner.CornerRadius = UDim.new(0, 4)
    FillCorner.Parent = Fill

    local draggingSlider = false
    Slider.InputBegan:Connect(function(input)
        pcall(function()
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = true
                print("Started dragging slider: " .. text)
            end
        end)
    end)

    Slider.InputEnded:Connect(function(input)
        pcall(function()
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
                print("Stopped dragging slider: " .. text)
            end
        end)
    end)

    UserInputService.InputChanged:Connect(function(input)
        pcall(function()
            if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local mouseX = input.Position.X
                local sliderX = Slider.AbsolutePosition.X
                local sliderWidth = Slider.AbsoluteSize.X
                local t = math.clamp((mouseX - sliderX) / sliderWidth, 0, 1)
                local value = math.floor(min + (max - min) * t + 0.5)
                Fill.Size = UDim2.new(t, 0, 1, 0)
                Label.Text = text .. ": " .. value
                callback(value)
                print("Slider " .. text .. " set to: " .. value)
            end
        end)
    end)

    parent.CanvasSize = UDim2.new(0, 0, 0, parent.UIListLayout.AbsoluteContentSize.Y)
    print("Created slider: " .. text)
end

-- Create tabs and content frames
for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.BackgroundColor3 = tabName == "Farm" and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(25, 25, 25)
    TabButton.BackgroundTransparency = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextScaled = true
    TabButton.TextWrapped = true
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextTransparency = 0
    TabButton.BorderSizePixel = 0
    TabButton.Parent = TabFrame

    local TabCorner = Instance.new("UICorner")
    TabCorner.Name = "TabCorner"
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton

    local TabStroke = Instance.new("UIStroke")
    TabStroke.Name = "TabStroke"
    TabStroke.Color = Color3.fromRGB(0, 255, 255)
    TabStroke.Thickness = 1
    TabStroke.Transparency = 0
    TabStroke.Parent = TabButton

    local Content = Instance.new("ScrollingFrame")
    Content.Name = tabName .. "Content"
    Content.Size = UDim2.new(1, -130, 1, -50)
    Content.Position = UDim2.new(0, 130, 0, 50)
    Content.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Content.BackgroundTransparency = 1
    Content.Visible = tabName == "Farm"
    Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    Content.ScrollBarThickness = 4
    Content.ScrollBarImageTransparency = 0
    Content.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
    Content.BorderSizePixel = 0
    Content.Parent = MainFrame

    local ContentList = Instance.new("UIListLayout")
    ContentList.Name = "ContentList"
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 6)
    ContentList.FillDirection = Enum.FillDirection.Vertical
    ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    ContentList.VerticalAlignment = Enum.VerticalAlignment.Top
    ContentList.Parent = Content

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.Name = "ContentPadding"
    ContentPadding.PaddingLeft = UDim.new(0, 6)
    ContentPadding.PaddingRight = UDim.new(0, 6)
    ContentPadding.PaddingTop = UDim.new(0, 6)
    ContentPadding.PaddingBottom = UDim.new(0, 6)
    ContentPadding.Parent = Content

    TabContents[tabName] = Content

    TabButton.MouseButton1Click:Connect(function()
        pcall(function()
            for _, t in ipairs(Tabs) do
                TabContents[t].Visible = t == tabName
                local btn = TabFrame:FindFirstChild(t)
                btn.BackgroundColor3 = t == tabName and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(25, 25, 25)
                print("Switched to tab: " .. t)
            end
            PlayClickSound(TabButton)
        end)
    end)

    TabButton.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            print("Tab hover started: " .. tabName)
        end)
    end)
    TabButton.MouseLeave:Connect(function()
        pcall(function()
            if tabName ~= Tabs[1] or not TabContents[tabName].Visible then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                print("Tab hover ended: " .. tabName)
            end
        end)
    end)
end

-- Key system logic
local function CheckKey(input)
    return input == CorrectKey
end

SubmitKey.MouseButton1Click:Connect(function()
    pcall(function()
        if CheckKey(KeyInput.Text) then
            print("Valid key entered, saving to file")
            writefile(KeyFile, KeyInput.Text)
            KeyFrame.Visible = false
            MainFrame.Visible = true
            TweenFrame(MainFrame, UDim2.new(0, 500, 0, 400), UDim2.new(0.5, -250, 0.5, -200), 0.5)
            PlayCutscene()
            print("Key accepted, showing main UI")
        else
            KeyInput.Text = "Invalid Key!"
            wait(1)
            KeyInput.Text = ""
            print("Invalid key entered")
        end
    end)
end)

GetKeyButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/bYxcFhy8R")
        KeyInput.Text = "Copied Discord link!"
        wait(1)
        KeyInput.Text = ""
        print("Copied Discord link to clipboard")
    end)
end)

if pcall(function() return readfile(KeyFile) == CorrectKey end) then
    KeyFrame.Visible = false
    MainFrame.Visible = true
    PlayCutscene()
    print("Valid key found, bypassing key prompt")
end

-- Dragging logic (mobile-friendly)
local dragging, dragStart, startPos
local function StartDrag(input)
    pcall(function()
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            print("Started dragging UI")
        end
    end)
end

local function UpdateDrag(input)
    pcall(function()
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            print("Dragging UI to: " .. tostring(MainFrame.Position))
        end
    end)
end

local function EndDrag(input)
    pcall(function()
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            print("Stopped dragging UI")
        end
    end)
end

TitleBar.InputBegan:Connect(StartDrag)
TitleBar.InputChanged:Connect(UpdateDrag)
TitleBar.InputEnded:Connect(EndDrag)

-- Toggle button logic
ToggleButton.MouseButton1Click:Connect(function()
    pcall(function()
        MainFrame.Visible = not MainFrame.Visible
        local size = MainFrame.Visible and UDim2.new(0, 500, 0, 400) or UDim2.new(0, 0, 0, 0)
        local pos = MainFrame.Visible and UDim2.new(0.5, -250, 0.5, -200) or UDim2.new(0.5, 0, 0.5, 0)
        TweenFrame(MainFrame, size, pos, 0.4)
        ToggleButton.Text = MainFrame.Visible and "X" or "NH"
        PlayClickSound(ToggleButton)
        print("Toggled UI visibility: " .. tostring(MainFrame.Visible))
    end)
end)

CloseButton.MouseButton1Click:Connect(function()
    pcall(function()
        TweenFrame(MainFrame, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0), 0.4)
        wait(0.4)
        MainFrame.Visible = false
        ToggleButton.Text = "NH"
        PlayClickSound(CloseButton)
        print("Closed UI")
    end)
end)

-- Farm Tab Content
CreateToggle(TabContents.Farm, "Auto Farm Level (Melee/Fly)", "AutoFarmLevel")
CreateToggle(TabContents.Farm, "Auto Farm Boss", "AutoFarmBoss")
CreateToggle(TabContents.Farm, "Auto Fruit Sniper", "AutoFruitSniper")
CreateToggle(TabContents.Farm, "Auto Mastery (Gun/Fruit)", "AutoMastery")
CreateToggle(TabContents.Farm, "Auto Quest (Main Story)", "AutoQuest")
CreateToggle(TabContents.Farm, "Auto Awaken Fruits", "AutoAwaken")
CreateToggle(TabContents.Farm, "Auto Chest Collector", "AutoChest")
CreateButton(TabContents.Farm, "Claim Daily Rewards", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("ClaimDailyRewards")
        print("Claimed daily rewards")
    end)
end)
CreateButton(TabContents.Farm, "Auto Buy Fruits", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("PurchaseFruit", "Random")
        print("Purchased random fruit")
    end)
end)
CreateButton(TabContents.Farm, "Store All Fruits", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit")
        print("Stored all fruits")
    end)
end)
CreateButton(TabContents.Farm, "Auto Haki", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("KenTalk", "Start")
        print("Activated haki")
    end)
end)
CreateSlider(TabContents.Farm, "Farm Speed", 0.1, 1, Settings.FarmSpeed, function(value)
    Settings.FarmSpeed = value
    print("Set farm speed: " .. value)
end)

-- Combat Tab Content
CreateToggle(TabContents.Combat, "Aimbot (Click-Based)", "Aimbot")
CreateToggle(TabContents.Combat, "Auto Raid", "AutoRaid")
CreateToggle(TabContents.Combat, "Auto Skills (Fruit/Gun)", "AutoSkills")
CreateToggle(TabContents.Combat, "No Stun/Knockback", "NoStun")
CreateToggle(TabContents.Combat, "Kill Aura (Melee)", "KillAura")
CreateButton(TabContents.Combat, "Auto Equip Best Weapon", function()
    pcall(function()
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
                print("Equipped weapon: " .. tool.Name)
                break
            end
        end
    end)
end)
CreateButton(TabContents.Combat, "Auto V2 Fighting Style", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBlackLeg")
        print("Purchased V2 fighting style")
    end)
end)
CreateButton(TabContents.Combat, "Auto Buy Cyborg", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyCyborg")
        print("Purchased Cyborg")
    end)
end)
CreateSlider(TabContents.Combat, "Aimbot Range", 50, 500, Settings.AimbotRange, function(value)
    Settings.AimbotRange = value
    print("Set aimbot range: " .. value)
end)
CreateSlider(TabContents.Combat, "Kill Aura Range", 10, 50, Settings.KillAuraRange, function(value)
    Settings.KillAuraRange = value
    print("Set kill aura range: " .. value)
end)

-- Visual Tab Content
CreateToggle(TabContents.Visual, "ESP (Players)", "ESP")
CreateToggle(TabContents.Visual, "ESP (NPCs/Enemies)", "ESPEnemies")
CreateToggle(TabContents.Visual, "ESP (Fruits/Chests)", "ESPItems")
CreateToggle(TabContents.Visual, "Fullbright", "Fullbright")
CreateToggle(TabContents.Visual, "Show Hitboxes", "ShowHitboxes")
CreateToggle(TabContents.Visual, "ESP (Devil Fruits)", "ESPFruits")
CreateToggle(TabContents.Visual, "ESP (Chests)", "ESPChests")
CreateButton(TabContents.Visual, "Remove Fog", function()
    pcall(function()
        game.Lighting.FogEnd = 100000
        print("Removed fog")
    end)
end)
CreateSlider(TabContents.Visual, "ESP Refresh Rate", 1, 10, Settings.ESPRefresh, function(value)
    Settings.ESPRefresh = value
    print("Set ESP refresh rate: " .. value)
end)

-- Teleport Tab Content
local TeleportList = Instance.new("TextButton")
TeleportList.Name = "TeleportList"
TeleportList.Size = UDim2.new(1, 0, 0, 35)
TeleportList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TeleportList.BackgroundTransparency = 0
TeleportList.Text = "Select Location"
TeleportList.TextColor3 = Color3.fromRGB(0, 255, 255)
TeleportList.TextScaled = true
TeleportList.TextWrapped = true
TeleportList.Font = Enum.Font.GothamBold
TeleportList.TextTransparency = 0
TeleportList.BorderSizePixel = 0
TeleportList.Parent = TabContents.Teleport

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.Name = "TeleportCorner"
TeleportCorner.CornerRadius = UDim.new(0, 6)
TeleportCorner.Parent = TeleportList

local TeleportStroke = Instance.new("UIStroke")
TeleportStroke.Name = "TeleportStroke"
TeleportStroke.Color = Color3.fromRGB(0, 255, 255)
TeleportStroke.Thickness = 1
TeleportStroke.Transparency = 0
TeleportStroke.Parent = TeleportList

local TeleportDrop = Instance.new("ScrollingFrame")
TeleportDrop.Name = "TeleportDrop"
TeleportDrop.Size = UDim2.new(1, 0, 0, 300)
TeleportDrop.Position = UDim2.new(0, 0, 1, 0)
TeleportDrop.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TeleportDrop.BackgroundTransparency = 0
TeleportDrop.Visible = false
TeleportDrop.CanvasSize = UDim2.new(0, 0, 0, #Teleports * 35)
TeleportDrop.ScrollBarThickness = 4
TeleportDrop.ScrollBarImageTransparency = 0
TeleportDrop.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
TeleportDrop.BorderSizePixel = 0
TeleportDrop.Parent = TabContents.Teleport

local TeleportListLayout = Instance.new("UIListLayout")
TeleportListLayout.Name = "TeleportListLayout"
TeleportListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TeleportListLayout.Padding = UDim.new(0, 4)
TeleportListLayout.FillDirection = Enum.FillDirection.Vertical
TeleportListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TeleportListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
TeleportListLayout.Parent = TeleportDrop

for name, cf in pairs(Teleports) do
    CreateButton(TeleportDrop, name, function()
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = cf
                TeleportDrop.Visible = false
                print("Teleported to: " .. name)
            else
                print("Teleport failed: No HumanoidRootPart")
            end
        end)
    end)
end

TeleportList.MouseButton1Click:Connect(function()
    pcall(function()
        TeleportDrop.Visible = not TeleportDrop.Visible
        print("Toggled teleport dropdown: " .. tostring(TeleportDrop.Visible))
    end)
end)

-- Events Tab Content
CreateToggle(TabContents.Events, "Auto Race V4 (Draco/Dragon)", "AutoRaceV4")
CreateToggle(TabContents.Events, "Auto Sea Events (Kitsune/Mirage)", "AutoSeaEvents")
CreateToggle(TabContents.Events, "Auto Tiki Outpost Liberation", "AutoTiki")
CreateToggle(TabContents.Events, "Auto Volcano Event", "AutoVolcano")
CreateButton(TabContents.Events, "Trigger Full Moon", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TriggerEvent", "FullMoon")
        print("Triggered full moon")
    end)
end)
CreateButton(TabContents.Events, "Join Random Trial", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TrialJoin")
        print("Joined random trial")
    end)
end)
CreateButton(TabContents.Events, "Auto Collect Event Rewards", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("ClaimEventRewards")
        print("Collected event rewards")
    end)
end)
CreateButton(TabContents.Events, "Auto Mirage Island", function()
    pcall(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = Teleports["Mirage Island"]
        print("Teleported to Mirage Island")
    end)
end)
CreateButton(TabContents.Events, "Auto Kitsune Island", function()
    pcall(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = Teleports["Kitsune Island"]
        print("Teleported to Kitsune Island")
    end)
end)

-- Settings Tab Content
CreateButton(TabContents.Settings, "Join Pirates", function()
    pcall(function()
        Settings.JoinTeam = "Pirates"
        ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
        print("Joined Pirates")
    end)
end)
CreateButton(TabContents.Settings, "Join Marines", function()
    pcall(function()
        Settings.JoinTeam = "Marines"
        ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
        print("Joined Marines")
    end)
end)
CreateToggle(TabContents.Settings, "Auto Rejoin on Disconnect", "AutoRejoin")
CreateToggle(TabContents.Settings, "Low CPU Mode", "LowCPU")
CreateButton(TabContents.Settings, "Reset Character", function()
    pcall(function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
            print("Reset character")
        else
            print("Reset failed: No character")
        end
    end)
end)
CreateButton(TabContents.Settings, "Rejoin Server", function()
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        print("Rejoined server")
    end)
end)
CreateButton(TabContents.Settings, "Hide UI", function()
    pcall(function()
        MainFrame.Visible = false
        ToggleButton.Text = "NH"
        print("Hid UI")
    end)
end)
CreateSlider(TabContents.Settings, "UI Scale", 0.8, 1.2, 1, function(value)
    pcall(function()
        MainFrame.Size = UDim2.new(0, 500 * value, 0, 400 * value)
        MainFrame.Position = UDim2.new(0.5, -250 * value, 0.5, -200 * value)
        print("Set UI scale: " .. value)
    end)
end)

-- Scripts Tab Content
local ScriptInput = Instance.new("TextBox")
ScriptInput.Name = "ScriptInput"
ScriptInput.Size = UDim2.new(1, 0, 0, 150)
ScriptInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ScriptInput.BackgroundTransparency = 0
ScriptInput.Text = "-- Enter custom script here"
ScriptInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptInput.TextWrapped = true
ScriptInput.MultiLine = true
ScriptInput.ClearTextOnFocus = false
ScriptInput.Font = Enum.Font.Code
ScriptInput.TextSize = 12
ScriptInput.TextTransparency = 0
ScriptInput.BorderSizePixel = 0
ScriptInput.Parent = TabContents.Scripts

local ScriptCorner = Instance.new("UICorner")
ScriptCorner.Name = "ScriptCorner"
ScriptCorner.CornerRadius = UDim.new(0, 6)
ScriptCorner.Parent = ScriptInput

local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Name = "ExecuteButton"
ExecuteButton.Size = UDim2.new(0.48, 0, 0, 30)
ExecuteButton.Position = UDim2.new(0, 0, 1, 5)
ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ExecuteButton.BackgroundTransparency = 0
ExecuteButton.Text = "Execute"
ExecuteButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ExecuteButton.TextScaled = true
ExecuteButton.TextWrapped = true
ExecuteButton.Font = Enum.Font.GothamBold
ExecuteButton.TextTransparency = 0
ExecuteButton.BorderSizePixel = 0
ExecuteButton.Parent = TabContents.Scripts

local ExecCorner = Instance.new("UICorner")
ExecCorner.Name = "ExecCorner"
ExecCorner.CornerRadius = UDim.new(0, 6)
ExecCorner.Parent = ExecuteButton

local ClearButton = Instance.new("TextButton")
ClearButton.Name = "ClearButton"
ClearButton.Size = UDim2.new(0.48, 0, 0, 30)
ClearButton.Position = UDim2.new(0.52, 0, 1, 5)
ClearButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.BackgroundTransparency = 0
ClearButton.Text = "Clear"
ClearButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ClearButton.TextScaled = true
ClearButton.TextWrapped = true
ClearButton.Font = Enum.Font.GothamBold
ClearButton.TextTransparency = 0
ClearButton.BorderSizePixel = 0
ClearButton.Parent = TabContents.Scripts

local ClearCorner = Instance.new("UICorner")
ClearCorner.Name = "ClearCorner"
ClearCorner.CornerRadius = UDim.new(0, 6)
ClearCorner.Parent = ClearButton

ExecuteButton.MouseButton1Click:Connect(function()
    pcall(function()
        local code = ScriptInput.Text
        local func = loadstring(code)
        if func then
            func()
            print("Executed custom script")
        else
            warn("Script Error: Invalid code")
            print("Failed to execute script: Invalid code")
        end
    end)
end)

ClearButton.MouseButton1Click:Connect(function()
    pcall(function()
        ScriptInput.Text = "-- Enter custom script here"
        print("Cleared script input")
    end)
end)

-- Misc Tab Content
CreateButton(TabContents.Misc, "Travel to First Sea", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
        print("Traveled to First Sea")
    end)
end)
CreateButton(TabContents.Misc, "Travel to Second Sea", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
        print("Traveled to Second Sea")
    end)
end)
CreateButton(TabContents.Misc, "Travel to Third Sea", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
        print("Traveled to Third Sea")
    end)
end)
CreateToggle(TabContents.Misc, "Infinite Yield (Commands)", "InfiniteYield")
CreateToggle(TabContents.Misc, "No Clip", "NoClip")
CreateToggle(TabContents.Misc, "Infinite Stamina", "InfStamina")
CreateToggle(TabContents.Misc, "Walk on Water", "WalkOnWater")
CreateToggle(TabContents.Misc, "Invisible", "Invisible")
CreateToggle(TabContents.Misc, "Auto Dodge Attacks", "AutoDodge")
CreateButton(TabContents.Misc, "Auto Redeem Codes", function()
    pcall(function()
        local codes = {"UPD24", "KITT_RESET", "SUB2GAMERROBOT"}
        for _, code in ipairs(codes) do
            ReplicatedStorage.Remotes.CommF_:InvokeServer("RedeemCode", code)
            print("Redeemed code: " .. code)
        end
    end)
end)
CreateSlider(TabContents.Misc, "Walk Speed", 16, 100, Settings.WalkSpeed, function(value)
    pcall(function()
        Settings.WalkSpeed = value
        if getgenv().NyxnHubToggles.SpeedHack and LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
            print("Set walk speed: " .. value)
        end
    end)
end)
CreateSlider(TabContents.Misc, "Jump Power", 50, 200, Settings.JumpPower, function(value)
    pcall(function()
        Settings.JumpPower = value
        if getgenv().NyxnHubToggles.JumpHack and LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = value
            print("Set jump power: " .. value)
        end
    end)
end)

-- Feature Implementations

-- Auto Farm Level (Melee, Fly, Fast Attack)
spawn(function()
    while wait(Settings.FarmSpeed) do
        if getgenv().NyxnHubToggles.AutoFarmLevel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local playerLevel = LocalPlayer.Data and LocalPlayer.Data.Level and LocalPlayer.Data.Level.Value or 1
                print("Player Level: " .. playerLevel)
                local questData = {
                    {Level = 1, Quest = "BanditQuest1", NPC = "Bandit", Pos = CFrame.new(1059, 16, 1548), QuestGiver = "Bandit Quest Giver", QuestGiverPos = CFrame.new(1030, 10, 1550)},
                    {Level = 15, Quest = "JungleQuest1", NPC = "Monkey", Pos = CFrame.new(-1604, 37, 154), QuestGiver = "Jungle Quest Giver", QuestGiverPos = CFrame.new(-1598, 36, 153)},
                    {Level = 30, Quest = "DesertQuest1", NPC = "Gorilla", Pos = CFrame.new(-1301, 38, -698), QuestGiver = "Desert Quest Giver", QuestGiverPos = CFrame.new(-1260, 10, -600)},
                    {Level = 700, Quest = "RaiderQuest1", NPC = "Raider", Pos = Teleports["Green Zone"], QuestGiver = "Second Sea Quest Giver", QuestGiverPos = Teleports["Kingdom of Rose"]}
                }
                local targetQuest = nil
                for _, q in ipairs(questData) do
                    if playerLevel >= q.Level then
                        targetQuest = q
                    end
                end
                if targetQuest then
                    print("Selected Quest: " .. targetQuest.Quest)
                    if not LocalPlayer.PlayerGui.Main.Quest.Visible then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetQuest.QuestGiverPos
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", targetQuest.Quest, 1)
                        wait(0.5)
                        print("Started quest: " .. targetQuest.Quest)
                    end
                    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and (string.find(tool.Name, "Black Leg") or string.find(tool.Name, "Combat")) then
                            LocalPlayer.Character.Humanoid:EquipTool(tool)
                            print("Equipped melee: " .. tool.Name)
                            break
                        end
                    end
                    local closestEnemy, minDist = nil, math.huge
                    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                        if string.find(enemy.Name, targetQuest.NPC) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            local dist = (enemy.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                closestEnemy = enemy
                            end
                        end
                    end
                    if closestEnemy then
                        local hitbox = closestEnemy.HumanoidRootPart:FindFirstChild("Hitbox")
                        if not hitbox then
                            hitbox = Instance.new("SelectionBox")
                            hitbox.Name = "Hitbox"
                            hitbox.Adornee = closestEnemy.HumanoidRootPart
                            hitbox.LineThickness = 0.05
                            hitbox.Color3 = Color3.fromRGB(0, 255, 255)
                            hitbox.Parent = closestEnemy.HumanoidRootPart
                        end
                        LocalPlayer.Character.HumanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        VirtualUser:ClickButton1(Vector2.new())
                        wait(0.1)
                        print("Attacking enemy: " .. closestEnemy.Name)
                    else
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetQuest.Pos
                        print("No " .. targetQuest.NPC .. " found, moving to quest position")
                    end
                else
                    print("No quest found for level: " .. playerLevel)
                end
            end)
        end
    end
end)

-- Auto Farm Boss
spawn(function()
    while wait(Settings.FarmSpeed) do
        if getgenv().NyxnHubToggles.AutoFarmBoss then
            pcall(function()
                local bosses = {"Thunder God", "Tide Keeper", "Ice Admiral", "Darkbeard"}
                for _, boss in pairs(Workspace.Enemies:GetChildren()) do
                    if table.find(bosses, boss.Name) and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        VirtualUser:ClickButton1(Vector2.new())
                        print("Attacking boss: " .. boss.Name)
                    end
                end
            end)
        end
    end
end)

-- Auto Fruit Sniper
spawn(function()
    while wait(0.5) do
        if getgenv().NyxnHubToggles.AutoFruitSniper then
            pcall(function()
                for _, fruit in pairs(Workspace:GetChildren()) do
                    if string.find(fruit.Name, "Fruit") and fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
                        fireclickdetector(fruit.Handle:FindFirstChildOfClass("ClickDetector"))
                        print("Collected fruit: " .. fruit.Name)
                    end
                end
            end)
        end
    end
end)

-- Auto Mastery
spawn(function()
    while wait(Settings.FarmSpeed) do
        if getgenv().NyxnHubToggles.AutoMastery then
            pcall(function()
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        VirtualUser:ClickButton1(Vector2.new())
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("UseSkill", "Fruit")
                        print("Using fruit skill on: " .. enemy.Name)
                    end
                end
            end)
        end
    end
end)

-- Auto Quest
spawn(function()
    while wait(1) do
        if getgenv().NyxnHubToggles.AutoQuest then
            pcall(function()
                local quests = {"BanditQuest1", "JungleQuest1", "DesertQuest1", "RaiderQuest1"}
                if not LocalPlayer.PlayerGui.Main.Quest.Visible then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", quests[math.random(1, #quests)], 1)
                    print("Started random quest")
                end
            end)
        end
    end
end)

-- Auto Awaken
spawn(function()
    while wait(5) do
        if getgenv().NyxnHubToggles.AutoAwaken then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AwakenFruit")
                print("Attempted to awaken fruit")
            end)
        end
    end
end)

-- Auto Chest Collector
-- Automatically locates and collects chests in the game world
spawn(function()
    while wait(0.5) do
        if getgenv().NyxnHubToggles.AutoChest then
            pcall(function()
                for _, chest in pairs(Workspace:GetChildren()) do
                    if string.find(chest.Name, "Chest") and chest:IsA("Model") and chest:FindFirstChildOfClass("ClickDetector") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = chest:GetPrimaryPartCFrame()
                        fireclickdetector(chest:FindFirstChildOfClass("ClickDetector"))
                        print("Collected chest at: " .. tostring(chest:GetPrimaryPartCFrame()))
                    end
                end
            end)
        end
    end
end)

-- Aimbot (Click-Based)
-- Locks camera onto nearest player's head when clicking, within configured range
UserInputService.InputBegan:Connect(function(input)
    if getgenv().NyxnHubToggles.Aimbot and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        pcall(function()
            local closest, dist = nil, Settings.AimbotRange
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local d = (player.Character.Head.Position - Camera.CFrame.Position).Magnitude
                    if d < dist then
                        dist = d
                        closest = player
                    end
                end
            end
            if closest then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position)
                print("Aimbot locked onto: " .. closest.Name)
            else
                print("Aimbot: No valid target found within range")
            end
        end)
    end
end)

-- ESP (Visuals for Players, Enemies, Fruits, Chests)
-- Highlights objects with customizable refresh rate
spawn(function()
    while wait(Settings.ESPRefresh) do
        pcall(function()
            -- Player ESP
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = player.Character:FindFirstChild("ESPHighlight")
                    if getgenv().NyxnHubToggles.ESP and not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.FillColor = Color3.fromRGB(0, 255, 255)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.7
                        highlight.OutlineTransparency = 0
                        highlight.Parent = player.Character
                        print("Added player ESP for: " .. player.Name)
                    elseif not getgenv().NyxnHubToggles.ESP and highlight then
                        highlight:Destroy()
                        print("Removed player ESP for: " .. player.Name)
                    end
                end
            end
            -- Enemy ESP
            for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                local highlight = enemy:FindFirstChild("ESPHighlight")
                if getgenv().NyxnHubToggles.ESPEnemies and not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.7
                    highlight.OutlineTransparency = 0
                    highlight.Parent = enemy
                    print("Added enemy ESP for: " .. enemy.Name)
                elseif not getgenv().NyxnHubToggles.ESPEnemies and highlight then
                    highlight:Destroy()
                    print("Removed enemy ESP for: " .. enemy.Name)
                end
            end
            -- Fruit/Chest ESP
            for _, item in pairs(Workspace:GetChildren()) do
                local highlight = item:FindFirstChild("ESPHighlight")
                if (getgenv().NyxnHubToggles.ESPItems or getgenv().NyxnHubToggles.ESPFruits) and string.find(item.Name, "Fruit") then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.FillColor = Color3.fromRGB(255, 255, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.7
                        highlight.OutlineTransparency = 0
                        highlight.Parent = item
                        print("Added fruit ESP for: " .. item.Name)
                    end
                elseif (getgenv().NyxnHubToggles.ESPItems or getgenv().NyxnHubToggles.ESPChests) and string.find(item.Name, "Chest") then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.FillColor = Color3.fromRGB(255, 215, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.7
                        highlight.OutlineTransparency = 0
                        highlight.Parent = item
                        print("Added chest ESP for: " .. item.Name)
                    end
                elseif not (getgenv().NyxnHubToggles.ESPItems or getgenv().NyxnHubToggles.ESPFruits or getgenv().NyxnHubToggles.ESPChests) and highlight then
                    highlight:Destroy()
                    print("Removed ESP for: " .. item.Name)
                end
            end
        end)
    end
end)

-- Auto Raid
-- Automatically joins raids and attacks enemies
spawn(function()
    while wait(Settings.FarmSpeed) do
        if getgenv().NyxnHubToggles.AutoRaid then
            pcall(function()
                if Workspace:FindFirstChild("Raids") then
                    for _, enemy in pairs(Workspace.Raids:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            VirtualUser:ClickButton1(Vector2.new())
                            print("Attacking raid enemy: " .. enemy.Name)
                        end
                    end
                else
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Flame")
                    print("Attempted to start Flame raid")
                end
            end)
        end
    end
end)

-- Auto Skills
-- Automatically uses fruit and gun skills
spawn(function()
    while wait(0.2) do
        if getgenv().NyxnHubToggles.AutoSkills then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("UseSkill", "Fruit")
                ReplicatedStorage.Remotes.CommF_:InvokeServer("UseSkill", "Gun")
                print("Used fruit and gun skills")
            end)
        end
    end
end)

-- No Stun/Knockback
-- Prevents player from being stunned or knocked back
spawn(function()
    while wait(0.1) do
        if getgenv().NyxnHubToggles.NoStun and LocalPlayer.Character then
            pcall(function()
                LocalPlayer.Character.Humanoid.Sit = false
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                print("Prevented stun/knockback")
            end)
        end
    end
end)

-- Kill Aura
-- Automatically attacks nearby enemies within configured range
spawn(function()
    while wait(0.1) do
        if getgenv().NyxnHubToggles.KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and (enemy.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < Settings.KillAuraRange then
                        VirtualUser:ClickButton1(Vector2.new())
                        print("Kill aura attacking: " .. enemy.Name)
                    end
                end
            end)
        end
    end
end)

-- Auto Stats
-- Automatically allocates stat points to random attributes
spawn(function()
    while wait(5) do
        if getgenv().NyxnHubToggles.AutoStats then
            pcall(function()
                local stats = {"Melee", "Defense", "Fruit", "Gun", "Sword"}
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", stats[math.random(1, #stats)], Settings.AutoStatPoints)
                print("Allocated " .. Settings.AutoStatPoints .. " stat points")
            end)
        end
    end
end)

-- Auto Race V4
-- Automates progression for Race V4 (Draco/Dragon)
spawn(function()
    while wait(30) do
        if getgenv().NyxnHubToggles.AutoRaceV4 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = Teleports["Green Zone"]
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and obj:FindFirstChildOfClass("ClickDetector") then
                        fireclickdetector(obj:FindFirstChildOfClass("ClickDetector"))
                        print("Interacted with Race V4 object")
                    end
                end
            end)
        end
    end
end)

-- Auto Sea Events
-- Automatically participates in Kitsune/Mirage events
spawn(function()
    while wait(45) do
        if getgenv().NyxnHubToggles.AutoSeaEvents and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local targets = {Teleports["Mirage Island"], Teleports["Kitsune Island"]}
                LocalPlayer.Character.HumanoidRootPart.CFrame = targets[math.random(1, #targets)]
                for _, obj in pairs(Workspace:GetChildren()) do
                    if (obj.Name == "KitsuneStatue" or obj.Name == "MirageTotem") and obj:FindFirstChildOfClass("ClickDetector") then
                        fireclickdetector(obj:FindFirstChildOfClass("ClickDetector"))
                        print("Interacted with sea event: " .. obj.Name)
                    end
                end
            end)
        end
    end
end)

-- Auto Tiki Outpost
-- Automates liberation of Tiki Outpost
spawn(function()
    while wait(30) do
        if getgenv().NyxnHubToggles.AutoTiki and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = Teleports["Tiki Outpost"]
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and obj:FindFirstChildOfClass("ClickDetector") then
                        fireclickdetector(obj:FindFirstChildOfClass("ClickDetector"))
                        print("Interacted with Tiki Outpost")
                    end
                end
            end)
        end
    end
end)

-- Auto Volcano Event
-- Automates participation in Volcano event
spawn(function()
    while wait(30) do
        if getgenv().NyxnHubToggles.AutoVolcano and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = Teleports["Hot and Cold"]
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and obj:FindFirstChildOfClass("ClickDetector") then
                        fireclickdetector(obj:FindFirstChildOfClass("ClickDetector"))
                        print("Interacted with Volcano event")
                    end
                end
            end)
        end
    end
end)

-- Fullbright
-- Enhances visibility by adjusting lighting settings
spawn(function()
    while wait(0.1) do
        if getgenv().NyxnHubToggles.Fullbright then
            pcall(function()
                game.Lighting.Brightness = 2
                game.Lighting.FogEnd = 100000
                game.Lighting.GlobalShadows = false
                print("Applied fullbright settings")
            end)
        end
    end
end)

-- Show Hitboxes
-- Displays hitboxes on enemies for better targeting
spawn(function()
    while wait(0.3) do
        if getgenv().NyxnHubToggles.ShowHitboxes then
            pcall(function()
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") then
                        local box = enemy.HumanoidRootPart:FindFirstChild("Hitbox")
                        if not box then
                            box = Instance.new("SelectionBox")
                            box.Name = "Hitbox"
                            box.Adornee = enemy.HumanoidRootPart
                            box.LineThickness = 0.05
                            box.Color3 = Color3.fromRGB(0, 255, 255)
                            box.Parent = enemy.HumanoidRootPart
                            print("Added hitbox for: " .. enemy.Name)
                        end
                    end
                end
            end)
        else
            pcall(function()
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy.HumanoidRootPart and enemy.HumanoidRootPart:FindFirstChild("Hitbox") then
                        enemy.HumanoidRootPart.Hitbox:Destroy()
                        print("Removed hitbox for: " .. enemy.Name)
                    end
                end
            end)
        end
    end
end)

-- Infinite Yield
-- Loads Infinite Yield admin commands if toggled
spawn(function()
    if getgenv().NyxnHubToggles.InfiniteYield then
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            print("Loaded Infinite Yield")
        end)
    end
end)

-- No Clip
-- Allows player to pass through walls
spawn(function()
    while wait(0.1) do
        if getgenv().NyxnHubToggles.NoClip and LocalPlayer.Character then
            pcall(function()
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                print("Enabled no clip")
            end)
        end
    end
end)

-- Infinite Stamina
-- Grants infinite stamina for character actions
spawn(function()
    while wait(0.1) do
        if getgenv().NyxnHubToggles.InfStamina and LocalPlayer.Character then
            pcall(function()
                LocalPlayer.Character.Humanoid:SetAttribute("Stamina", math.huge)
                print("Set infinite stamina")
            end)
        end
    end
end)

-- Walk on Water
-- Prevents player from falling into water
spawn(function()
    while wait(0.1) do
        if getgenv().NyxnHubToggles.WalkOnWater and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                if LocalPlayer.Character.HumanoidRootPart.Position.Y < 0 then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position.X, 0, LocalPlayer.Character.HumanoidRootPart.Position.Z)
                    print("Walking on water")
                end
            end)
        end
    end
end)

-- Invisibility
-- Makes player character invisible
spawn(function()
    while wait(0.3) do
        if getgenv().NyxnHubToggles.Invisible and LocalPlayer.Character then
            pcall(function()
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Transparency = 1
                    end
                end
                print("Enabled invisibility")
            end)
        else
            pcall(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.Transparency = 0
                        end
                    end
                    print("Disabled invisibility")
                end
            end)
        end
    end
end)

-- Auto Dodge
-- Automatically jumps to dodge attacks
spawn(function()
    while wait(0.1) do
        if getgenv().NyxnHubToggles.AutoDodge and LocalPlayer.Character then
            pcall(function()
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                print("Auto dodging")
            end)
        end
    end
end)

-- Speed and Jump Hacks
-- Applies custom walk speed and jump power
spawn(function()
    while wait(0.1) do
        if LocalPlayer.Character then
            pcall(function()
                if getgenv().NyxnHubToggles.SpeedHack then
                    LocalPlayer.Character.Humanoid.WalkSpeed = Settings.WalkSpeed
                    print("Set walk speed: " .. Settings.WalkSpeed)
                else
                    LocalPlayer.Character.Humanoid.WalkSpeed = 16
                    print("Reset walk speed to default")
                end
                if getgenv().NyxnHubToggles.JumpHack then
                    LocalPlayer.Character.Humanoid.JumpPower = Settings.JumpPower
                    print("Set jump power: " .. Settings.JumpPower)
                else
                    LocalPlayer.Character.Humanoid.JumpPower = 50
                    print("Reset jump power to default")
                end
            end)
        end
    end
end)

-- Auto Rejoin on Disconnect
-- Rejoins server if disconnected
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if getgenv().NyxnHubToggles.AutoRejoin and child.Name == "ErrorPrompt" then
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
            print("Auto rejoining server due to disconnect")
        end)
    end
end)

-- Low CPU Mode
-- Optimizes game for lower performance devices
spawn(function()
    while wait(1) do
        if getgenv().NyxnHubToggles.LowCPU then
            pcall(function()
                game:GetService("Lighting").GlobalShadows = false
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Material = Enum.Material.SmoothPlastic
                        v.Reflectance = 0
                    end
                end
                print("Applied low CPU mode settings")
            end)
        end
    end
end)

-- Auto-Join Team
-- Automatically joins configured team on character spawn
LocalPlayer.CharacterAdded:Connect(function()
    wait(5)
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", Settings.JoinTeam)
        print("Auto joined team: " .. Settings.JoinTeam)
    end)
end)

-- Anti-AFK
-- Prevents player from being kicked for inactivity
VirtualUser:CaptureController()
spawn(function()
    while wait(60) do
        pcall(function()
            VirtualUser:ClickButton1(Vector2.new())
            print("Anti-AFK: Simulated click")
        end)
    end
end)

-- Script Loaded Message
print("Nyxn Hub V1.0 Loaded! Key: Hidden (Obtain via Discord) | Check output for debug info.")