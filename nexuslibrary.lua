-- ROBLOX HUB LIBRARY
-- Modern, Animated, Transparent UI Library
-- Author: Custom Script Library
-- Version: 1.0

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {}
Library.__index = Library

-- Configuration
local CONFIG = {
    BackgroundColor = Color3.fromRGB(15, 15, 20),
    BackgroundTransparency = 0.3,
    AccentColor = Color3.fromRGB(120, 120, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    TextTransparency = 0.1,
    IconSize = 40,
    AnimationSpeed = 0.4,
    HoverAnimationSpeed = 0.2,
}

-- Utility Functions
local function CreateTween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or CONFIG.AnimationSpeed,
        easingStyle or Enum.EasingStyle.Quint,
        easingDirection or Enum.EasingDirection.Out
    )
    return TweenService:Create(instance, tweenInfo, properties)
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            CreateTween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1):Play()
        end
    end)
end

local function CreateRoundedFrame(parent, size, position, transparency)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = CONFIG.BackgroundColor
    frame.BackgroundTransparency = transparency or CONFIG.BackgroundTransparency
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    return frame
end

local function CreateGlow(parent)
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1, 40, 1, 40)
    glow.Position = UDim2.new(0, -20, 0, -20)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    glow.ImageColor3 = CONFIG.AccentColor
    glow.ImageTransparency = 0.8
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(10, 10, 118, 118)
    glow.ZIndex = parent.ZIndex - 1
    glow.Parent = parent
    
    return glow
end

-- Main Hub Creation
function Library.new(title)
    local self = setmetatable({}, Library)
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "HubLibrary"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = game.CoreGui
    
    -- Main Frame
    self.MainFrame = CreateRoundedFrame(
        self.ScreenGui,
        UDim2.new(0, 600, 0, 450),
        UDim2.new(0.5, -300, 0.5, -225),
        CONFIG.BackgroundTransparency
    )
    self.MainFrame.ClipsDescendants = true
    
    -- Add Glow Effect
    CreateGlow(self.MainFrame)
    
    -- Add Drop Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ZIndex = self.MainFrame.ZIndex - 2
    shadow.Parent = self.MainFrame
    
    -- Top Bar
    self.TopBar = CreateRoundedFrame(
        self.MainFrame,
        UDim2.new(1, 0, 0, 50),
        UDim2.new(0, 0, 0, 0),
        0.2
    )
    self.TopBar.BackgroundColor3 = CONFIG.AccentColor
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "HUB LIBRARY"
    titleLabel.TextColor3 = CONFIG.TextColor
    titleLabel.TextTransparency = CONFIG.TextTransparency
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.TopBar
    
    -- Close Button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Size = UDim2.new(0, 40, 0, 40)
    self.CloseButton.Position = UDim2.new(1, -45, 0, 5)
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    self.CloseButton.BackgroundTransparency = 0.2
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Text = "X"
    self.CloseButton.TextColor3 = CONFIG.TextColor
    self.CloseButton.TextTransparency = CONFIG.TextTransparency
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.TextSize = 18
    self.CloseButton.Parent = self.TopBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = self.CloseButton
    
    -- Close Button Animations
    self.CloseButton.MouseEnter:Connect(function()
        CreateTween(self.CloseButton, {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 45, 0, 45),
            Rotation = 90
        }, CONFIG.HoverAnimationSpeed):Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        CreateTween(self.CloseButton, {
            BackgroundTransparency = 0.2,
            Size = UDim2.new(0, 40, 0, 40),
            Rotation = 0
        }, CONFIG.HoverAnimationSpeed):Play()
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        CreateTween(self.MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Rotation = 360
        }, CONFIG.AnimationSpeed):Play()
        wait(CONFIG.AnimationSpeed)
        self.ScreenGui:Destroy()
    end)
    
    -- Tab Container
    self.TabContainer = CreateRoundedFrame(
        self.MainFrame,
        UDim2.new(0, 140, 1, -70),
        UDim2.new(0, 10, 0, 60),
        0.4
    )
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = self.TabContainer
    
    -- Content Container
    self.ContentContainer = CreateRoundedFrame(
        self.MainFrame,
        UDim2.new(1, -170, 1, -70),
        UDim2.new(0, 160, 0, 60),
        0.4
    )
    
    -- Make Draggable
    MakeDraggable(self.MainFrame, self.TopBar)
    
    -- Opening Animation
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.Rotation = -180
    CreateTween(self.MainFrame, {
        Size = UDim2.new(0, 600, 0, 450),
        Rotation = 0
    }, 0.6, Enum.EasingStyle.Back):Play()
    
    self.Tabs = {}
    self.CurrentTab = nil
    
    return self
end

-- Tab Creation
function Library:CreateTab(name, icon)
    local tab = {}
    
    -- Tab Button
    tab.Button = Instance.new("TextButton")
    tab.Button.Size = UDim2.new(1, -10, 0, 45)
    tab.Button.BackgroundColor3 = CONFIG.AccentColor
    tab.Button.BackgroundTransparency = 0.7
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = ""
    tab.Button.Parent = self.TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = tab.Button
    
    -- Tab Icon
    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.new(0, CONFIG.IconSize, 0, CONFIG.IconSize)
    iconFrame.Position = UDim2.new(0, 5, 0.5, -CONFIG.IconSize/2)
    iconFrame.BackgroundColor3 = CONFIG.TextColor
    iconFrame.BackgroundTransparency = 0.8
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = tab.Button
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconFrame
    
    -- Tab Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -55, 1, 0)
    label.Position = UDim2.new(0, 50, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = CONFIG.TextColor
    label.TextTransparency = CONFIG.TextTransparency
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab.Button
    
    -- Tab Content
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Size = UDim2.new(1, -20, 1, -20)
    tab.Content.Position = UDim2.new(0, 10, 0, 10)
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.ScrollBarThickness = 4
    tab.Content.ScrollBarImageColor3 = CONFIG.AccentColor
    tab.Content.Visible = false
    tab.Content.Parent = self.ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = tab.Content
    
    -- Auto-resize content
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Tab Button Animations
    tab.Button.MouseEnter:Connect(function()
        CreateTween(iconFrame, {
            Rotation = 360,
            Size = UDim2.new(0, CONFIG.IconSize + 5, 0, CONFIG.IconSize + 5)
        }, CONFIG.HoverAnimationSpeed):Play()
        CreateTween(tab.Button, {
            BackgroundTransparency = 0.5
        }, CONFIG.HoverAnimationSpeed):Play()
    end)
    
    tab.Button.MouseLeave:Connect(function()
        CreateTween(iconFrame, {
            Rotation = 0,
            Size = UDim2.new(0, CONFIG.IconSize, 0, CONFIG.IconSize)
        }, CONFIG.HoverAnimationSpeed):Play()
        if self.CurrentTab ~= tab then
            CreateTween(tab.Button, {
                BackgroundTransparency = 0.7
            }, CONFIG.HoverAnimationSpeed):Play()
        end
    end)
    
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
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
        CreateTween(t.Button, {
            BackgroundTransparency = 0.7
        }, CONFIG.HoverAnimationSpeed):Play()
    end
    
    tab.Content.Visible = true
    CreateTween(tab.Button, {
        BackgroundTransparency = 0.3
    }, CONFIG.HoverAnimationSpeed):Play()
    
    self.CurrentTab = tab
end

-- Button Element
function Library:CreateButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.BackgroundColor3 = CONFIG.AccentColor
    button.BackgroundTransparency = 0.6
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = CONFIG.TextColor
    button.TextTransparency = CONFIG.TextTransparency
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.Parent = tab.Content
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    button.MouseEnter:Connect(function()
        CreateTween(button, {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(1, -5, 0, 45)
        }, CONFIG.HoverAnimationSpeed):Play()
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, {
            BackgroundTransparency = 0.6,
            Size = UDim2.new(1, -10, 0, 40)
        }, CONFIG.HoverAnimationSpeed):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        CreateTween(button, {
            Rotation = 360
        }, CONFIG.AnimationSpeed):Play()
        wait(CONFIG.AnimationSpeed)
        button.Rotation = 0
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Toggle Element
function Library:CreateToggle(tab, text, default, callback)
    local toggled = default or false
    
    local toggleFrame = CreateRoundedFrame(
        tab.Content,
        UDim2.new(1, -10, 0, 40),
        UDim2.new(0, 0, 0, 0),
        0.6
    )
    toggleFrame.BackgroundColor3 = CONFIG.AccentColor
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CONFIG.TextColor
    label.TextTransparency = CONFIG.TextTransparency
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(60, 255, 60) or Color3.fromRGB(255, 60, 60)
    toggleButton.BackgroundTransparency = 0.3
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 21, 0, 21)
    toggleCircle.Position = toggled and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    toggleCircle.BackgroundColor3 = CONFIG.TextColor
    toggleCircle.BackgroundTransparency = 0.1
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        CreateTween(toggleButton, {
            BackgroundColor3 = toggled and Color3.fromRGB(60, 255, 60) or Color3.fromRGB(255, 60, 60)
        }, CONFIG.HoverAnimationSpeed):Play()
        
        CreateTween(toggleCircle, {
            Position = toggled and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        }, CONFIG.HoverAnimationSpeed, Enum.EasingStyle.Back):Play()
        
        if callback then
            callback(toggled)
        end
    end)
    
    toggleFrame.MouseEnter:Connect(function()
        CreateTween(toggleFrame, {
            BackgroundTransparency = 0.4
        }, CONFIG.HoverAnimationSpeed):Play()
    end)
    
    toggleFrame.MouseLeave:Connect(function()
        CreateTween(toggleFrame, {
            BackgroundTransparency = 0.6
        }, CONFIG.HoverAnimationSpeed):Play()
    end)
    
    return toggleFrame
end

-- Slider Element
function Library:CreateSlider(tab, text, min, max, default, callback)
    local value = default or min
    
    local sliderFrame = CreateRoundedFrame(
        tab.Content,
        UDim2.new(1, -10, 0, 55),
        UDim2.new(0, 0, 0, 0),
        0.6
    )
    sliderFrame.BackgroundColor3 = CONFIG.AccentColor
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CONFIG.TextColor
    label.TextTransparency = CONFIG.TextTransparency
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = CONFIG.TextColor
    valueLabel.TextTransparency = CONFIG.TextTransparency
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0, 10, 1, -15)
    sliderBar.BackgroundColor3 = CONFIG.BackgroundColor
    sliderBar.BackgroundTransparency = 0.3
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    sliderFill.BackgroundTransparency = 0.2
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((value - min) / (max - min), -8, 0.5, -8)
    sliderButton.BackgroundColor3 = CONFIG.TextColor
    sliderButton.BackgroundTransparency = 0.1
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = sliderButton
    
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = sliderBar.AbsolutePosition.X
            local barSize = sliderBar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            
            value = math.floor(min + (max - min) * percent)
            valueLabel.Text = tostring(value)
            
            CreateTween(sliderFill, {
                Size = UDim2.new(percent, 0, 1, 0)
            }, 0.1):Play()
            
            CreateTween(sliderButton, {
                Position = UDim2.new(percent, -8, 0.5, -8)
            }, 0.1):Play()
            
            if callback then
                callback(value)
            end
        end
    end)
    
    sliderFrame.MouseEnter:Connect(function()
        CreateTween(sliderFrame, {
            BackgroundTransparency = 0.4
        }, CONFIG.HoverAnimationSpeed):Play()
    end)
    
    sliderFrame.MouseLeave:Connect(function()
        CreateTween(sliderFrame, {
            BackgroundTransparency = 0.6
        }, CONFIG.HoverAnimationSpeed):Play()
    end)
    
    return sliderFrame
end

-- Label Element
function Library:CreateLabel(tab, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 30)
    label.BackgroundColor3 = CONFIG.AccentColor
    label.BackgroundTransparency = 0.8
    label.BorderSizePixel = 0
    label.Text = text
    label.TextColor3 = CONFIG.TextColor
    label.TextTransparency = CONFIG.TextTransparency
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab.Content
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = label
    
    local lblCorner = Instance.new("UICorner")
    lblCorner.CornerRadius = UDim.new(0, 8)
    lblCorner.Parent = label
    
    return label
end

-- Textbox Element
function Library:CreateTextbox(tab, placeholder, callback)
    local textboxFrame = CreateRoundedFrame(
        tab.Content,
        UDim2.new(1, -10, 0, 40),
        UDim2.new(0, 0, 0, 0),
        0.6
    )
    textboxFrame.BackgroundColor3 = CONFIG.AccentColor
    
    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, -20, 1, -10)
    textbox.Position = UDim2.new(0, 10, 0, 5)
    textbox.BackgroundTransparency = 1
    textbox.PlaceholderText = placeholder
    textbox.PlaceholderColor3 = CONFIG.TextColor
    textbox.Text = ""
    textbox.TextColor3 = CONFIG.TextColor
    textbox.TextTransparency = CONFIG.TextTransparency
    textbox.Font = Enum.Font.GothamSemibold
    textbox.TextSize = 14
    textbox.TextXAlignment = Enum.TextXAlignment.Left
    textbox.ClearTextOnFocus = false
    textbox.Parent = textboxFrame
    
    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(textbox.Text)
        end
    end)
    
    textboxFrame.MouseEnter:Connect(function()
        CreateTween(textboxFrame, {
            BackgroundTransparency = 0.4
        }, CONFIG.HoverAnimationSpeed):Play()
    end)
    
    textboxFrame.MouseLeave:Connect(function()
        CreateTween(textboxFrame, {
            BackgroundTransparency = 0.6
        }, CONFIG.HoverAnimationSpeed):Play()
    end)
    
    return textbox
end

return Library
