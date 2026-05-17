game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Executor",
    Text = "Waiting...",
    Duration = 2
})

task.spawn(function()
    Services = {
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        Stats = game:GetService("Stats"),
        CoreGui = game:GetService("CoreGui"),
        StarterGui = game:GetService("StarterGui"),
        TweenService = game:GetService("TweenService")
    }
end)

task.spawn(function()
    ToggleKey = Enum.KeyCode.U
    KillKey = Enum.KeyCode.P
    Destroyed = false
    GuiEnabled = true
    Connections = {}
end)

task.spawn(function()
    FpsRefreshInterval = 1.0
    PingRefreshInterval = 0.4
end)

task.spawn(function()
    local OldGui = Services.CoreGui:FindFirstChild("StatusGUI")
    if OldGui then
        OldGui:Destroy()
    end
end)

task.spawn(function()
    function Notify(text, duration)
        if Destroyed then return end
        pcall(function()
            Services.StarterGui:SetCore("SendNotification", {
                Title = "Executor",
                Text = text,
                Duration = duration or 2
            })
        end)
    end
end)

task.spawn(function()
    StatusGui = Instance.new("ScreenGui")
    StatusGui.Name = "StatusGUI"
    StatusGui.ResetOnSpawn = false
    StatusGui.DisplayOrder = 999999 
    StatusGui.Parent = Services.CoreGui

    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = StatusGui
    MainFrame.Size = UDim2.new(0, 260, 0, 165)
    MainFrame.Position = UDim2.new(0, 20, 0, 20)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true 
    MainFrame.ZIndex = 2

    UICorner = Instance.new("UICorner")
    UICorner.Parent = MainFrame
    UICorner.CornerRadius = UDim.new(0, 12)

    UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Thickness = 1.5
    UIStroke.Color = Color3.fromRGB(0, 102, 204)
end)

task.spawn(function()
    TopBar = Instance.new("Frame")
    TopBar.Parent = MainFrame
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundTransparency = 1
    TopBar.ZIndex = 3

    RedButton = Instance.new("TextButton")
    RedButton.Parent = TopBar
    RedButton.Size = UDim2.new(0, 12, 0, 12)
    RedButton.Position = UDim2.new(0, 12, 0, 12)
    RedButton.Text = ""
    RedButton.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
    RedButton.BorderSizePixel = 0
    RedButton.ZIndex = 4

    RedCorner = Instance.new("UICorner")
    RedCorner.Parent = RedButton
    RedCorner.CornerRadius = UDim.new(1, 0)

    YellowButton = Instance.new("TextButton")
    YellowButton.Parent = TopBar
    YellowButton.Size = UDim2.new(0, 12, 0, 12)
    YellowButton.Position = UDim2.new(0, 30, 0, 12)
    YellowButton.Text = ""
    YellowButton.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
    YellowButton.BorderSizePixel = 0
    YellowButton.ZIndex = 4

    YellowCorner = Instance.new("UICorner")
    YellowCorner.Parent = YellowButton
    YellowCorner.CornerRadius = UDim.new(1, 0)

    GreenButton = Instance.new("TextButton")
    GreenButton.Parent = TopBar
    GreenButton.Size = UDim2.new(0, 12, 0, 12)
    GreenButton.Position = UDim2.new(0, 48, 0, 12)
    GreenButton.Text = ""
    GreenButton.BackgroundColor3 = Color3.fromRGB(39, 201, 63)
    GreenButton.BorderSizePixel = 0
    GreenButton.ZIndex = 4

    GreenCorner = Instance.new("UICorner")
    GreenCorner.Parent = GreenButton
    GreenCorner.CornerRadius = UDim.new(1, 0)

    Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 70, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Status"
    Title.TextColor3 = Color3.fromRGB(240, 244, 255)
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Right
    Title.ZIndex = 4
end)

task.spawn(function()
    TabBar = Instance.new("Frame")
    TabBar.Parent = MainFrame
    TabBar.Position = UDim2.new(0, 0, 0, 35)
    TabBar.Size = UDim2.new(1, 0, 0, 26)
    TabBar.BackgroundTransparency = 1
    TabBar.ZIndex = 3

    LineTop = Instance.new("Frame")
    LineTop.Parent = TabBar
    LineTop.Size = UDim2.new(1, 0, 0, 2)
    LineTop.Position = UDim2.new(0, 0, 0, 0)
    LineTop.BackgroundColor3 = Color3.fromRGB(55, 75, 105)
    LineTop.BorderSizePixel = 0
    LineTop.ZIndex = 4

    LineBottom = Instance.new("Frame")
    LineBottom.Parent = TabBar
    LineBottom.Size = UDim2.new(1, 0, 0, 2)
    LineBottom.Position = UDim2.new(0, 0, 1, -2)
    LineBottom.BackgroundColor3 = Color3.fromRGB(55, 75, 105)
    LineBottom.BorderSizePixel = 0
    LineBottom.ZIndex = 4

    LineCenter = Instance.new("Frame")
    LineCenter.Parent = TabBar
    LineCenter.Size = UDim2.new(0, 2, 1, 0)
    LineCenter.Position = UDim2.new(0.5, -1, 0, 0)
    LineCenter.BackgroundColor3 = Color3.fromRGB(55, 75, 105)
    LineCenter.BorderSizePixel = 0
    LineCenter.ZIndex = 4

    Tab1Btn = Instance.new("TextButton")
    Tab1Btn.Parent = TabBar
    Tab1Btn.Size = UDim2.new(0.5, -2, 1, -4)
    Tab1Btn.Position = UDim2.new(0, 0, 0, 2)
    Tab1Btn.BackgroundTransparency = 1
    Tab1Btn.Font = Enum.Font.GothamBold
    Tab1Btn.Text = "Data"
    Tab1Btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    Tab1Btn.TextSize = 13
    Tab1Btn.ZIndex = 4

    Tab2Btn = Instance.new("TextButton")
    Tab2Btn.Parent = TabBar
    Tab2Btn.Size = UDim2.new(0.5, -2, 1, -4)
    Tab2Btn.Position = UDim2.new(0.5, 2, 0, 2)
    Tab2Btn.BackgroundTransparency = 1
    Tab2Btn.Font = Enum.Font.GothamBold
    Tab2Btn.Text = "Settings"
    Tab2Btn.TextColor3 = Color3.fromRGB(110, 125, 145)
    Tab2Btn.TextSize = 13
    Tab2Btn.ZIndex = 4
end)

task.spawn(function()
    Tab1Page = Instance.new("Frame")
    Tab1Page.Parent = MainFrame
    Tab1Page.Position = UDim2.new(0, 0, 0, 65)
    Tab1Page.Size = UDim2.new(1, 0, 1, -65)
    Tab1Page.BackgroundTransparency = 1
    Tab1Page.Visible = true
    Tab1Page.ZIndex = 3

    Tab2Page = Instance.new("Frame")
    Tab2Page.Parent = MainFrame
    Tab2Page.Position = UDim2.new(0, 0, 0, 65)
    Tab2Page.Size = UDim2.new(1, 0, 1, -65)
    Tab2Page.BackgroundTransparency = 1
    Tab2Page.Visible = false
    Tab2Page.ZIndex = 3
end)

task.spawn(function()
    Connections.Tab1Click = Tab1Btn.MouseButton1Click:Connect(function()
        Services.TweenService:Create(Tab1Btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(0, 170, 255)}):Play()
        Services.TweenService:Create(Tab2Btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(110, 125, 145)}):Play()
        Tab1Page.Visible = true
        Tab2Page.Visible = false
    end)

    Connections.Tab2Click = Tab2Btn.MouseButton1Click:Connect(function()
        Services.TweenService:Create(Tab1Btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(110, 125, 145)}):Play()
        Services.TweenService:Create(Tab2Btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(0, 170, 255)}):Play()
        Tab1Page.Visible = false
        Tab2Page.Visible = true
    end)
end)

task.spawn(function()
    Ping = Instance.new("TextLabel")
    Ping.Parent = Tab1Page
    Ping.Position = UDim2.new(0, 16, 0, 15)
    Ping.Size = UDim2.new(1, -32, 0, 25)
    Ping.BackgroundTransparency = 1
    Ping.Font = Enum.Font.GothamMedium
    Ping.Text = "Ping : Calculations..."
    Ping.TextColor3 = Color3.fromRGB(225, 235, 255)
    Ping.TextSize = 14
    Ping.TextXAlignment = Enum.TextXAlignment.Left
    Ping.ZIndex = 4

    FPS = Instance.new("TextLabel")
    FPS.Parent = Tab1Page
    FPS.Position = UDim2.new(0, 16, 0, 45)
    FPS.Size = UDim2.new(1, -32, 0, 25)
    FPS.BackgroundTransparency = 1
    FPS.Font = Enum.Font.GothamMedium
    FPS.Text = "FPS : Calculations..."
    FPS.TextColor3 = Color3.fromRGB(225, 235, 255)
    FPS.TextSize = 14
    FPS.TextXAlignment = Enum.TextXAlignment.Left
    FPS.ZIndex = 4
end)

task.spawn(function()
    function CreateSlider(parent, labelText, yPosition)
        local Label = Instance.new("TextLabel")
        Label.Parent = parent
        Label.Position = UDim2.new(0, 16, 0, yPosition)
        Label.Size = UDim2.new(1, -32, 0, 15)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamSemibold
        Label.Text = labelText .. " Interval Speed"
        Label.TextColor3 = Color3.fromRGB(140, 155, 175)
        Label.TextSize = 11
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.ZIndex = 4

        local SliderBar = Instance.new("Frame")
        SliderBar.Parent = parent
        SliderBar.Position = UDim2.new(0, 16, 0, yPosition + 18)
        SliderBar.Size = UDim2.new(1, -32, 0, 4)
        SliderBar.BackgroundColor3 = Color3.fromRGB(28, 36, 48) 
        SliderBar.BorderSizePixel = 0
        SliderBar.ZIndex = 4

        local SliderBarCorner = Instance.new("UICorner")
        SliderBarCorner.CornerRadius = UDim.new(1, 0)
        SliderBarCorner.Parent = SliderBar

        local FillTrack = Instance.new("Frame")
        FillTrack.Parent = SliderBar
        FillTrack.Size = UDim2.new(0.3, 0, 1, 0)
        FillTrack.BackgroundColor3 = Color3.fromRGB(0, 136, 255) 
        FillTrack.BorderSizePixel = 0
        FillTrack.ZIndex = 5

        local FillTrackCorner = Instance.new("UICorner")
        FillTrackCorner.CornerRadius = UDim.new(1, 0)
        FillTrackCorner.Parent = FillTrack

        local SliderButton = Instance.new("TextButton")
        SliderButton.Parent = SliderBar
        SliderButton.Position = UDim2.new(0.3, -6, 0.5, -6)
        SliderButton.Size = UDim2.new(0, 12, 0, 12)
        SliderButton.BackgroundColor3 = Color3.fromRGB(0, 185, 255) 
        SliderButton.Text = ""
        SliderButton.ZIndex = 6

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(1, 0)
        ButtonCorner.Parent = SliderButton
        
        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Thickness = 1
        ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
        ButtonStroke.Parent = SliderButton

        return SliderBar, SliderButton, FillTrack
    end
end)

task.spawn(function()
    PingBar, PingBtn, PingFill = CreateSlider(Tab2Page, "Ping Refresh", 5)
    FpsBar, FpsBtn, FpsFill = CreateSlider(Tab2Page, "FPS Refresh", 45)
end)

task.spawn(function()
    MiniButton = Instance.new("TextButton")
    MiniButton.Name = "MiniButton"
    MiniButton.Parent = StatusGui
    MiniButton.Size = UDim2.new(0, 55, 0, 55)
    MiniButton.Position = MainFrame.Position
    MiniButton.Visible = false
    MiniButton.Text = "⚡"
    MiniButton.Font = Enum.Font.GothamBlack
    MiniButton.TextSize = 26
    MiniButton.TextColor3 = Color3.fromRGB(0, 185, 255)
    MiniButton.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
    MiniButton.BorderSizePixel = 0
    MiniButton.ZIndex = 5

    MiniCorner = Instance.new("UICorner")
    MiniCorner.Parent = MiniButton
    MiniCorner.CornerRadius = UDim.new(0, 14)

    MiniStroke = Instance.new("UIStroke")
    MiniStroke.Name = "MiniStroke"
    MiniStroke.Parent = MiniButton
    MiniStroke.Thickness = 1.5
    MiniStroke.Color = Color3.fromRGB(0, 102, 204)
end)

task.spawn(function()
    function CleanUp()
        Destroyed = true
        for _, connection in pairs(Connections) do
            pcall(function() connection:Disconnect() end)
        end
        Connections = {}
        pcall(function() StatusGui:Destroy() end)
        StatusGui = nil; MainFrame = nil; Ping = nil; FPS = nil; MiniButton = nil
    end
end)

task.spawn(function()
    function SetupSliderFunctionality(sliderName, SliderBar, SliderButton, FillTrack, minVal, maxVal, callback)
        local IsSliding = false

        local function UpdateSlider(input)
            local BarAbsoluteSize = SliderBar.AbsoluteSize.X
            if BarAbsoluteSize == 0 then return end
            
            local RelativeX = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, BarAbsoluteSize)
            local Percentage = RelativeX / BarAbsoluteSize

            SliderButton.Position = UDim2.new(Percentage, -6, 0.5, -6)
            FillTrack.Size = UDim2.new(Percentage, 0, 1, 0)

            local CalculatedValue = minVal + (Percentage * (maxVal - minVal))
            callback(CalculatedValue)
        end

        Connections[sliderName .. "Began"] = SliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then IsSliding = true end
        end)

        Connections[sliderName .. "Ended"] = Services.UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then IsSliding = false end
        end)

        Connections[sliderName .. "Changed"] = Services.UserInputService.InputChanged:Connect(function(input)
            if IsSliding and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(input) end
        end)
    end
end)

task.spawn(function()
    SetupSliderFunctionality("PingTrack", PingBar, PingBtn, PingFill, 0.1, 5.0, function(v) PingRefreshInterval = v end)
    SetupSliderFunctionality("FpsTrack", FpsBar, FpsBtn, FpsFill, 0.1, 5.0, function(v) FpsRefreshInterval = v end)
end)

task.spawn(function()
    function HandleDragging(TargetFrame, InputSource)
        local Dragging, DragStart, StartPos
        
        Connections[TargetFrame.Name.."DragStart"] = TargetFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                DragStart = input.Position
                StartPos = TargetFrame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then Dragging = false end
                end)
            end
        end)

        Connections[TargetFrame.Name.."DragMove"] = InputSource.InputChanged:Connect(function(input)
            if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local Delta = input.Position - DragStart
                TargetFrame.Position = UDim2.new(
                    StartPos.X.Scale, StartPos.X.Offset + Delta.X,
                    StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
                )
                if TargetFrame == MainFrame and not MiniButton.Visible then
                    MiniButton.Position = MainFrame.Position
                elseif TargetFrame == MiniButton and not MainFrame.Visible then
                    MainFrame.Position = MiniButton.Position
                end
            end
        end)
    end
end)

task.spawn(function()
    HandleDragging(MainFrame, Services.UserInputService)
    HandleDragging(MiniButton, Services.UserInputService)
end)

task.spawn(function()
    function MinimizeGui()
        MainFrame.Visible = false
        
        MiniButton.Position = MainFrame.Position
        MiniButton.Size = UDim2.new(0, 260, 0, 165)
        MiniButton.TextTransparency = 1 
        MiniButton.BackgroundTransparency = 0.15
        MiniButton.MiniStroke.Transparency = 0
        MiniButton.Visible = true
        
        local ShrinkTween = Services.TweenService:Create(MiniButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 55, 0, 55)
        })
        
        ShrinkTween:Play()
        ShrinkTween.Completed:Wait()
        
        Services.TweenService:Create(MiniButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            BackgroundTransparency = 0
        }):Play()
        
        Notify("Minimized", 2)
    end

    function OpenGui()
        local FadeTween = Services.TweenService:Create(MiniButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 1
        })
        FadeTween:Play()
        FadeTween.Completed:Wait()
        
        local GrowTween = Services.TweenService:Create(MiniButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 260, 0, 165),
            BackgroundTransparency = 0.15
        })
        GrowTween:Play()
        GrowTween.Completed:Wait()
        
        MiniButton.Visible = false
        MainFrame.Position = MiniButton.Position
        MainFrame.Size = UDim2.new(0, 260, 0, 165)
        MainFrame.Visible = true
        
        Notify("Opened", 2)
    end
end)

task.spawn(function()
    Connections.Yellow = YellowButton.MouseButton1Click:Connect(MinimizeGui)
    Connections.Mini = MiniButton.MouseButton1Click:Connect(OpenGui)
    Connections.Red = RedButton.MouseButton1Click:Connect(CleanUp)

    Connections.Green = GreenButton.MouseButton1Click:Connect(function()
        FPS.Text = "FPS : Refreshing..."
        Ping.Text = "Ping : Refreshing..."
        Notify("Refreshed", 2)
    end)
end)

task.spawn(function()
    local Frames = 0
    local Last = os.clock()

    Connections.Render = Services.RunService.RenderStepped:Connect(function()
        if Destroyed then return end
        Frames = Frames + 1

        local RightNow = os.clock()
        local Delta = RightNow - Last
        
        if Delta >= FpsRefreshInterval then
            if FPS and Tab1Page.Visible then 
                local CalculatedFps = Frames / Delta
                FPS.Text = string.format("FPS : %.2f", CalculatedFps)
            end
            Frames = 0
            Last = RightNow
        end
    end)
end)

task.spawn(function()
    while not Destroyed do
        local PingValue = 0.00
        pcall(function()
            local RawPing = Services.Stats.PerformanceStats.Ping:GetValue()
            if RawPing and RawPing > 0 then
                PingValue = RawPing
            end
        end)

        if not Destroyed and Ping and Tab1Page.Visible then
            Ping.Text = string.format("Ping : %.2f ms", PingValue)
        end
        
        task.wait(PingRefreshInterval)
    end
end)

task.spawn(function()
    Connections.Input = Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if Destroyed or gameProcessed then return end

        if input.KeyCode == ToggleKey then
            GuiEnabled = not GuiEnabled
            if MiniButton.Visible then
                MiniButton.Visible = GuiEnabled
            else
                MainFrame.Visible = GuiEnabled
            end
            Notify(GuiEnabled and "GUI Enabled" or "GUI Disabled", 2)
        elseif input.KeyCode == KillKey then
            CleanUp()
        end
    end)
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Executor",
    Text = "Executed",
    Duration = 2
})