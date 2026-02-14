-- VOIDWARE STYLE HUB LIBRARY
-- Premium Transparent Theme
-- Version: 2.0 Fixed

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = {}
Library.__index = Library

-- Configuration
local CONFIG = {
    MainColor = Color3.fromRGB(20, 20, 25),
    SecondaryColor = Color3.fromRGB(25, 25, 30),
    AccentColor = Color3.fromRGB(255, 255, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    
    MainTransparency = 0.08,
    ElementTransparency = 0.12,
    
    CornerRadius = 12,
    IconSize = 20,
    
    AnimationSpeed = 0.35,
    FastAnimation = 0.15,
    SlowAnimation = 0.5
}

-- Icons
local ICONS = {
    Home = "rbxassetid://10734950309",
    Combat = "rbxassetid://10747374131",
    Player = "rbxassetid://10734949856",
    Visual = "rbxassetid://10747372992",
    Settings = "rbxassetid://10734920149",
    Misc = "rbxassetid://10734920149",
    Close = "rbxassetid://10747384394"
}

-- Utility: Tween
local function Tween(instance, properties, duration, style, direction)
    local info = TweenInfo.new(
        duration or CONFIG.AnimationSpeed,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

-- Utility: Draggable
local function MakeDraggable(frame, handle)
    local dragging, dragInput, mousePos, framePos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            Tween(frame, {Size = frame.Size - UDim2.new(0, 4, 0, 4)}, CONFIG.FastAnimation, Enum.EasingStyle.Quad)
        end
    end)
    
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            Tween(frame, {Size = frame.Size + UDim2.new(0, 4, 0, 4)}, CONFIG.FastAnimation, Enum.EasingStyle.Back)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - mousePos
            Tween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.08, Enum.EasingStyle.Linear)
        end
    end)
end

-- Create Main Hub
function Library.new(title)
    local self = setmetatable({}, Library)
    
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "VoidHubLibrary"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.IgnoreGuiInset = true
    
    if gethui then
        self.ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
        self.ScreenGui.Parent = game.CoreGui
    else
        self.ScreenGui.Parent = game.CoreGui
    end
    
    -- Main Container
    self.Main = Instance.new("Frame")
    self.Main.Name = "MainContainer"
    self.Main.Size = UDim2.new(0, 0, 0, 0)
    self.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Main.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Main.BackgroundColor3 = CONFIG.MainColor
    self.Main.BackgroundTransparency = CONFIG.MainTransparency
    self.Main.BorderSizePixel = 0
    self.Main.ClipsDescendants = true
    self.Main.Parent = self.ScreenGui
    
    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, CONFIG.CornerRadius)
    
    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(40, 40, 40)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = self.Main
    
    -- Glow
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 60, 1, 60)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://4996891970"
    glow.ImageColor3 = CONFIG.MainColor
    glow.ImageTransparency = 0.85
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(128, 128, 128, 128)
    glow.ZIndex = 0
    glow.Parent = self.Main
    
    -- Top Bar
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Size = UDim2.new(1, 0, 0, 45)
    self.TopBar.BackgroundColor3 = CONFIG.SecondaryColor
    self.TopBar.BackgroundTransparency = 0.3
    self.TopBar.BorderSizePixel = 0
    self.TopBar.Parent = self.Main
    
    Instance.new("UICorner", self.TopBar).CornerRadius = UDim.new(0, CONFIG.CornerRadius)
    
    -- Title
    self.Title = Instance.new("TextLabel")
    self.Title.Size = UDim2.new(1, -60, 1, 0)
    self.Title.Position = UDim2.new(0, 15, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = title or "VOID HUB"
    self.Title.TextColor3 = CONFIG.TextColor
    self.Title.Font = Enum.Font.GothamBold
    self.Title.TextSize = 16
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.TextTransparency = 0
    self.Title.Parent = self.TopBar
    
    -- Close Button
    self.CloseBtn = Instance.new("ImageButton")
    self.CloseBtn.Name = "CloseButton"
    self.CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    self.CloseBtn.Position = UDim2.new(1, -30, 0.5, -10)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.CloseBtn.BackgroundTransparency = 0.4
    self.CloseBtn.Image = ICONS.Close
    self.CloseBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    self.CloseBtn.Parent = self.TopBar
    
    Instance.new("UICorner", self.CloseBtn).CornerRadius = UDim.new(1, 0)
    
    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = Color3.fromRGB(60, 60, 60)
    closeStroke.Thickness = 1
    closeStroke.Transparency = 0.5
    closeStroke.Parent = self.CloseBtn
    
    -- Close Animations
    self.CloseBtn.MouseEnter:Connect(function()
        Tween(self.CloseBtn, {
            Size = UDim2.new(0, 24, 0, 24),
            BackgroundTransparency = 0.1,
            Rotation = 90
        }, CONFIG.FastAnimation, Enum.EasingStyle.Back)
        Tween(self.CloseBtn, {ImageColor3 = Color3.fromRGB(255, 85, 85)}, CONFIG.FastAnimation)
    end)
    
    self.CloseBtn.MouseLeave:Connect(function()
        Tween(self.CloseBtn, {
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundTransparency = 0.4,
            Rotation = 0
        }, CONFIG.FastAnimation)
        Tween(self.CloseBtn, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, CONFIG.FastAnimation)
    end)
    
    self.CloseBtn.MouseButton1Click:Connect(function()
        Tween(self.CloseBtn, {Rotation = 180}, CONFIG.AnimationSpeed)
        Tween(self.Main, {
            Size = UDim2.new(0, 0, 0, 0),
            Rotation = 15
        }, CONFIG.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(CONFIG.AnimationSpeed)
        self.ScreenGui:Destroy()
    end)
    
    -- Navigation Bar
    self.NavBar = Instance.new("Frame")
    self.NavBar.Name = "Navigation"
    self.NavBar.Size = UDim2.new(0, 55, 1, -55)
    self.NavBar.Position = UDim2.new(0, 10, 0, 50)
    self.NavBar.BackgroundColor3 = CONFIG.SecondaryColor
    self.NavBar.BackgroundTransparency = 0.35
    self.NavBar.BorderSizePixel = 0
    self.NavBar.Parent = self.Main
    
    Instance.new("UICorner", self.NavBar).CornerRadius = UDim.new(0, CONFIG.CornerRadius)
    
    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 6)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.Parent = self.NavBar
    
    local navPadding = Instance.new("UIPadding")
    navPadding.PaddingTop = UDim.new(0, 8)
    navPadding.Parent = self.NavBar
    
    -- Content Container
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, -75, 1, -55)
    self.ContentFrame.Position = UDim2.new(0, 70, 0, 50)
    self.ContentFrame.BackgroundColor3 = CONFIG.SecondaryColor
    self.ContentFrame.BackgroundTransparency = 0.35
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Parent = self.Main
    
    Instance.new("UICorner", self.ContentFrame).CornerRadius = UDim.new(0, CONFIG.CornerRadius)
    
    -- Opening Animation
    Tween(self.Main, {
        Size = UDim2.new(0, 650, 0, 480),
        Rotation = 0
    }, CONFIG.SlowAnimation, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    MakeDraggable(self.Main, self.TopBar)
    
    self.Tabs = {}
    self.CurrentTab = nil
    
    return self
end

-- Create Tab
function Library:CreateTab(name, iconId)
    local tab = {}
    
    -- Tab Button
    tab.Button = Instance.new("ImageButton")
    tab.Button.Name = name
    tab.Button.Size = UDim2.new(0, 42, 0, 42)
    tab.Button.BackgroundColor3 = CONFIG.SecondaryColor
    tab.Button.BackgroundTransparency = 0.5
    tab.Button.BorderSizePixel = 0
    tab.Button.Image = iconId or ICONS.Home
    tab.Button.ImageColor3 = Color3.fromRGB(180, 180, 180)
    tab.Button.ScaleType = Enum.ScaleType.Fit
    tab.Button.Parent = self.NavBar
    
    Instance.new("UICorner", tab.Button).CornerRadius = UDim.new(0, 10)
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(50, 50, 50)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.7
    btnStroke.Parent = tab.Button
    
    local btnPadding = Instance.new("UIPadding")
    btnPadding.PaddingTop = UDim.new(0, 8)
    btnPadding.PaddingBottom = UDim.new(0, 8)
    btnPadding.PaddingLeft = UDim.new(0, 8)
    btnPadding.PaddingRight = UDim.new(0, 8)
    btnPadding.Parent = tab.Button
    
    -- Tooltip
    local tooltip = Instance.new("TextLabel")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, 0, 0, 25)
    tooltip.Position = UDim2.new(1, 10, 0.5, -12.5)
    tooltip.BackgroundColor3 = CONFIG.MainColor
    tooltip.BackgroundTransparency = 0.1
    tooltip.BorderSizePixel = 0
    tooltip.Text = name
    tooltip.TextColor3 = CONFIG.TextColor
    tooltip.Font = Enum.Font.GothamSemibold
    tooltip.TextSize = 12
    tooltip.TextXAlignment = Enum.TextXAlignment.Left
    tooltip.Visible = false
    tooltip.Parent = tab.Button
    
    Instance.new("UICorner", tooltip).CornerRadius = UDim.new(0, 6)
    
    local tooltipPadding = Instance.new("UIPadding")
    tooltipPadding.PaddingLeft = UDim.new(0, 8)
    tooltipPadding.PaddingRight = UDim.new(0, 8)
    tooltipPadding.Parent = tooltip
    
    -- Tab Content
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Name = name .. "Content"
    tab.Content.Size = UDim2.new(1, -20, 1, -20)
    tab.Content.Position = UDim2.new(0, 10, 0, 10)
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.ScrollBarThickness = 3
    tab.Content.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    tab.Content.ScrollBarImageTransparency = 0.7
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.Visible = false
    tab.Content.Parent = self.ContentFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = tab.Content
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 15)
    end)
    
    -- Hover Animation
    tab.Button.MouseEnter:Connect(function()
        tooltip.Visible = true
        Tween(tooltip, {Size = UDim2.new(0, #name * 8 + 16, 0, 25)}, CONFIG.FastAnimation, Enum.EasingStyle.Back)
        
        Tween(tab.Button, {
            BackgroundTransparency = 0.2,
            Size = UDim2.new(0, 46, 0, 46)
        }, CONFIG.FastAnimation, Enum.EasingStyle.Back)
        Tween(tab.Button, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, CONFIG.FastAnimation)
        Tween(btnStroke, {Transparency = 0.3}, CONFIG.FastAnimation)
    end)
    
    tab.Button.MouseLeave:Connect(function()
        Tween(tooltip, {Size = UDim2.new(0, 0, 0, 25)}, CONFIG.FastAnimation)
        task.wait(CONFIG.FastAnimation)
        tooltip.Visible = false
        
        if self.CurrentTab ~= tab then
            Tween(tab.Button, {
                BackgroundTransparency = 0.5,
                Size = UDim2.new(0, 42, 0, 42)
            }, CONFIG.FastAnimation)
            Tween(tab.Button, {ImageColor3 = Color3.fromRGB(180, 180, 180)}, CONFIG.FastAnimation)
            Tween(btnStroke, {Transparency = 0.7}, CONFIG.FastAnimation)
        end
    end)
    
    -- Click Event
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
        Tween(tab.Button, {Rotation = 360}, CONFIG.AnimationSpeed)
        task.wait(CONFIG.AnimationSpeed)
        tab.Button.Rotation = 0
    end)
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

-- Select Tab
function Library:SelectTab(tab)
    for _, t in pairs(self.Tabs) do
        t.Content.Visible = false
        Tween(t.Button, {
            BackgroundTransparency = 0.5,
            ImageColor3 = Color3.fromRGB(180, 180, 180)
        }, CONFIG.FastAnimation)
    end
    
    tab.Content.Visible = true
    Tween(tab.Button, {
        BackgroundTransparency = 0.15,
        ImageColor3 = Color3.fromRGB(255, 255, 255)
    }, CONFIG.FastAnimation)
    
    self.CurrentTab = tab
end

-- Button Element
function Library:CreateButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 38)
    button.BackgroundColor3 = CONFIG.MainColor
    button.BackgroundTransparency = CONFIG.ElementTransparency
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = CONFIG.TextColor
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 13
    button.AutoButtonColor = false
    button.Parent = tab.Content
    
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = button
    
    button.MouseEnter:Connect(function()
        Tween(button, {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(1, -8, 0, 40)
        }, CONFIG.FastAnimation, Enum.EasingStyle.Back)
        Tween(stroke, {Transparency = 0.3}, CONFIG.FastAnimation)
    end)
    
    button.MouseLeave:Connect(function()
        Tween(button, {
            BackgroundTransparency = CONFIG.ElementTransparency,
            Size = UDim2.new(1, -10, 0, 38)
        }, CONFIG.FastAnimation)
        Tween(stroke, {Transparency = 0.6}, CONFIG.FastAnimation)
    end)
    
    button.MouseButton1Click:Connect(function()
        Tween(button, {BackgroundTransparency = 0}, 0.05)
        task.wait(0.05)
        Tween(button, {BackgroundTransparency = CONFIG.ElementTransparency}, 0.1)
        
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Toggle Element
function Library:CreateToggle(tab, text, default, callback)
    local toggled = default or false
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -10, 0, 38)
    toggleFrame.BackgroundColor3 = CONFIG.MainColor
    toggleFrame.BackgroundTransparency = CONFIG.ElementTransparency
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = tab.Content
    
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CONFIG.TextColor
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleOuter = Instance.new("Frame")
    toggleOuter.Size = UDim2.new(0, 44, 0, 22)
    toggleOuter.Position = UDim2.new(1, -54, 0.5, -11)
    toggleOuter.BackgroundColor3 = toggled and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(40, 40, 40)
    toggleOuter.BorderSizePixel = 0
    toggleOuter.Parent = toggleFrame
    
    Instance.new("UICorner", toggleOuter).CornerRadius = UDim.new(1, 0)
    
    local toggleInner = Instance.new("Frame")
    toggleInner.Size = UDim2.new(0, 18, 0, 18)
    toggleInner.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    toggleInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleInner.BorderSizePixel = 0
    toggleInner.Parent = toggleOuter
    
    Instance.new("UICorner", toggleInner).CornerRadius = UDim.new(1, 0)
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = toggleFrame
    
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        Tween(toggleOuter, {
            BackgroundColor3 = toggled and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(40, 40, 40)
        }, CONFIG.FastAnimation)
        
        Tween(toggleInner, {
            Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }, CONFIG.AnimationSpeed, Enum.EasingStyle.Back)
        
        if callback then
            callback(toggled)
        end
    end)
    
    toggleFrame.MouseEnter:Connect(function()
        Tween(toggleFrame, {BackgroundTransparency = 0.15}, CONFIG.FastAnimation)
        Tween(stroke, {Transparency = 0.3}, CONFIG.FastAnimation)
    end)
    
    toggleFrame.MouseLeave:Connect(function()
        Tween(toggleFrame, {BackgroundTransparency = CONFIG.ElementTransparency}, CONFIG.FastAnimation)
        Tween(stroke, {Transparency = 0.6}, CONFIG.FastAnimation)
    end)
    
    return toggleFrame
end

-- Slider Element
function Library:CreateSlider(tab, text, min, max, default, callback)
    local value = default or min
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 50)
    sliderFrame.BackgroundColor3 = CONFIG.MainColor
    sliderFrame.BackgroundTransparency = CONFIG.ElementTransparency
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = tab.Content
    
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 18)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CONFIG.TextColor
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 18)
    valueLabel.Position = UDim2.new(1, -60, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = CONFIG.TextColor
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, -24, 0, 4)
    sliderBack.Position = UDim2.new(0, 12, 1, -14)
    sliderBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = sliderFrame
    
    Instance.new("UICorner", sliderBack).CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    local sliderButton = Instance.new("Frame")
    sliderButton.Size = UDim2.new(0, 12, 0, 12)
    sliderButton.Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderBack
    
    Instance.new("UICorner", sliderButton).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * percent)
            valueLabel.Text = tostring(value)
            
            Tween(sliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.05)
            Tween(sliderButton, {Position = UDim2.new(percent, -6, 0.5, -6)}, 0.05)
            
            if callback then
                callback(value)
            end
        end
    end)
    
    sliderFrame.MouseEnter:Connect(function()
        Tween(sliderFrame, {BackgroundTransparency = 0.15}, CONFIG.FastAnimation)
        Tween(stroke, {Transparency = 0.3}, CONFIG.FastAnimation)
        Tween(sliderButton, {Size = UDim2.new(0, 14, 0, 14)}, CONFIG.FastAnimation, Enum.EasingStyle.Back)
    end)
    
    sliderFrame.MouseLeave:Connect(function()
        Tween(sliderFrame, {BackgroundTransparency = CONFIG.ElementTransparency}, CONFIG.FastAnimation)
        Tween(stroke, {Transparency = 0.6}, CONFIG.FastAnimation)
        Tween(sliderButton, {Size = UDim2.new(0, 12, 0, 12)}, CONFIG.FastAnimation)
    end)
    
    return sliderFrame
end

-- Label Element
function Library:CreateLabel(tab, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 28)
    label.BackgroundColor3 = CONFIG.MainColor
    label.BackgroundTransparency = 0.4
    label.BorderSizePixel = 0
    label.Text = text
    label.TextColor3 = CONFIG.TextColor
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab.Content
    
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.Parent = label
    
    return label
end

-- Textbox Element
function Library:CreateTextbox(tab, placeholder, callback)
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Size = UDim2.new(1, -10, 0, 38)
    textboxFrame.BackgroundColor3 = CONFIG.MainColor
    textboxFrame.BackgroundTransparency = CONFIG.ElementTransparency
    textboxFrame.BorderSizePixel = 0
    textboxFrame.Parent = tab.Content
    
    Instance.new("UICorner", textboxFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = textboxFrame
    
    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, -24, 1, 0)
    textbox.Position = UDim2.new(0, 12, 0, 0)
    textbox.BackgroundTransparency = 1
    textbox.PlaceholderText = placeholder
    textbox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    textbox.Text = ""
    textbox.TextColor3 = CONFIG.TextColor
    textbox.Font = Enum.Font.GothamSemibold
    textbox.TextSize = 13
    textbox.TextXAlignment = Enum.TextXAlignment.Left
    textbox.ClearTextOnFocus = false
    textbox.Parent = textboxFrame
    
    textbox.Focused:Connect(function()
        Tween(stroke, {
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 0.2
        }, CONFIG.FastAnimation)
    end)
    
    textbox.FocusLost:Connect(function(enterPressed)
        Tween(stroke, {
            Color = Color3.fromRGB(50, 50, 50),
            Transparency = 0.6
        }, CONFIG.FastAnimation)
        
        if enterPressed and callback then
            callback(textbox.Text)
        end
    end)
    
    textboxFrame.MouseEnter:Connect(function()
        Tween(textboxFrame, {BackgroundTransparency = 0.15}, CONFIG.FastAnimation)
    end)
    
    textboxFrame.MouseLeave:Connect(function()
        Tween(textboxFrame, {BackgroundTransparency = CONFIG.ElementTransparency}, CONFIG.FastAnimation)
    end)
    
    return textbox
end

return Library
