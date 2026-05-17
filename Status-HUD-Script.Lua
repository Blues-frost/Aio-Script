game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Executor",
    Text = "Waiting...",
    Duration = 2
})

task.spawn(function()
    local Services = {
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        Stats = game:GetService("Stats"),
        CoreGui = game:GetService("CoreGui"),
        StarterGui = game:GetService("StarterGui"),
        TweenService = game:GetService("TweenService"),
        HttpService = game:GetService("HttpService"),
        GuiService = game:GetService("GuiService"),
        LogService = game:GetService("LogService"),
        Players = game:GetService("Players")
    }

    local ToggleKey = Enum.KeyCode.U
    local KillKey = Enum.KeyCode.P
    local Destroyed = false
    local GuiEnabled = true
    local Connections = {}

    local FpsRefreshInterval = 1.0
    local PingRefreshInterval = 0.4
    local DiscordWebhookURL = ""
    local ConfigFileName = "StatusGUI_AutoConfig.json"
    local HasSentDisconnect = false
    local WebBox = nil
    local IsAttemptingLeave = false
    local IsAltF4 = false

    local function FormatGMT8Time()
        local currentUnix = os.time()
        local gmt8Unix = currentUnix + (8 * 3600)
        return os.date("!%I:%M:%S %p", gmt8Unix)
    end

    local function SendDiscordWebhook(eventReason, isTesting)
        if DiscordWebhookURL == "" or not string.match(DiscordWebhookURL, "^https://") then return end
        local requestFunc = syn and syn.request or http and http.request or request
        if not requestFunc then return end
        
        if not isTesting then
            HasSentDisconnect = true
        end

        local localPlayer = Services.Players.LocalPlayer
        local accountName = localPlayer and ("@" .. localPlayer.Name) or "@UnknownUser"
        local timeString = FormatGMT8Time()
        local statusString = isTesting and "Testing" or "Not In Game"

        local contentString = string.format(
            "# Status Bot\nAccount name: %s\nTime: %s\nStatus: %s\nReason: %s",
            accountName,
            timeString,
            statusString,
            eventReason
        )

        pcall(function()
            requestFunc({
                Url = DiscordWebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = Services.HttpService:JSONEncode({
                    username = "Status Bot",
                    content = contentString
                })
            })
        end)
    end

    local function SaveConfig()
        if Destroyed then return end
        task.spawn(function()
            pcall(function()
                local data = {
                    FpsInterval = FpsRefreshInterval,
                    PingInterval = PingRefreshInterval,
                    Webhook = DiscordWebhookURL
                }
                writefile(ConfigFileName, Services.HttpService:JSONEncode(data))
            end)
        end)
    end

    local function LoadConfig()
        pcall(function()
            if isfile and isfile(ConfigFileName) then
                local rawData = readfile(ConfigFileName)
                local decoded = Services.HttpService:JSONDecode(rawData)
                if decoded then
                    if decoded.FpsInterval then FpsRefreshInterval = decoded.FpsInterval end
                    if decoded.PingInterval then PingRefreshInterval = decoded.PingInterval end
                    if decoded.Webhook then 
                        DiscordWebhookURL = decoded.Webhook 
                        if WebBox then
                            WebBox.Text = decoded.Webhook
                        end
                    end
                end
            end
        end)
    end

    task.spawn(function()
        local OldGui = Services.CoreGui:FindFirstChild("StatusGUI")
        if OldGui then
            pcall(function() OldGui:Destroy() end)
        end
    end)

    local function Notify(text, duration)
        if Destroyed then return end
        task.spawn(function()
            pcall(function()
                Services.StarterGui:SetCore("SendNotification", {
                    Title = "Executor",
                    Text = text,
                    Duration = duration or 2
                })
            end)
        end)
    end

    local StatusGui = Instance.new("ScreenGui")
    StatusGui.Name = "StatusGUI"
    StatusGui.ResetOnSpawn = false
    StatusGui.IgnoreGuiInset = true 
    StatusGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 
    StatusGui.DisplayOrder = 2147483647 
    
    task.spawn(function()
        StatusGui.Parent = Services.CoreGui
    end)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 260, 0, 165)
    MainFrame.Position = UDim2.new(0, 20, 0, 40) 
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true 
    MainFrame.ZIndex = 2

    task.spawn(function()
        MainFrame.Parent = StatusGui
    end)

    task.spawn(function()
        local UICorner = Instance.new("UICorner")
        UICorner.Parent = MainFrame
        UICorner.CornerRadius = UDim.new(0, 12)
    end)

    task.spawn(function()
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Parent = MainFrame
        UIStroke.Thickness = 1.5
        UIStroke.Color = Color3.fromRGB(0, 102, 204)
    end)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundTransparency = 1
    TopBar.ZIndex = 3

    task.spawn(function()
        TopBar.Parent = MainFrame
    end)

    task.spawn(function()
        local RedButton = Instance.new("TextButton")
        RedButton.Parent = TopBar
        RedButton.Size = UDim2.new(0, 12, 0, 12)
        RedButton.Position = UDim2.new(0, 12, 0, 12)
        RedButton.Text = ""
        RedButton.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
        RedButton.BorderSizePixel = 0
        RedButton.ZIndex = 4

        local RedCorner = Instance.new("UICorner")
        RedCorner.Parent = RedButton
        RedCorner.CornerRadius = UDim.new(1, 0)
        
        Connections.Red = RedButton.MouseButton1Click:Connect(function()
            task.spawn(CleanUp)
        end)
    end)

    local YellowButton = Instance.new("TextButton")
    task.spawn(function()
        YellowButton.Parent = TopBar
        YellowButton.Size = UDim2.new(0, 12, 0, 12)
        YellowButton.Position = UDim2.new(0, 30, 0, 12)
        YellowButton.Text = ""
        YellowButton.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
        YellowButton.BorderSizePixel = 0
        YellowButton.ZIndex = 4

        local YellowCorner = Instance.new("UICorner")
        YellowCorner.Parent = YellowButton
        YellowCorner.CornerRadius = UDim.new(1, 0)
    end)

    local GreenButton = Instance.new("TextButton")
    task.spawn(function()
        GreenButton.Parent = TopBar
        GreenButton.Size = UDim2.new(0, 12, 0, 12)
        GreenButton.Position = UDim2.new(0, 48, 0, 12)
        GreenButton.Text = ""
        GreenButton.BackgroundColor3 = Color3.fromRGB(39, 201, 63)
        GreenButton.BorderSizePixel = 0
        GreenButton.ZIndex = 4

        local GreenCorner = Instance.new("UICorner")
        GreenCorner.Parent = GreenButton
        GreenCorner.CornerRadius = UDim.new(1, 0)
    end)

    task.spawn(function()
        local Title = Instance.new("TextLabel")
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

    local TabBar = Instance.new("Frame")
    TabBar.Position = UDim2.new(0, 0, 0, 35)
    TabBar.Size = UDim2.new(1, 0, 0, 26)
    TabBar.BackgroundTransparency = 1
    TabBar.ZIndex = 3

    task.spawn(function()
        TabBar.Parent = MainFrame
    end)

    task.spawn(function()
        local LineTop = Instance.new("Frame")
        LineTop.Parent = TabBar
        LineTop.Size = UDim2.new(1, 0, 0, 2)
        LineTop.Position = UDim2.new(0, 0, 0, 0)
        LineTop.BackgroundColor3 = Color3.fromRGB(55, 75, 105)
        LineTop.BorderSizePixel = 0
        LineTop.ZIndex = 4
    end)

    task.spawn(function()
        local LineBottom = Instance.new("Frame")
        LineBottom.Parent = TabBar
        LineBottom.Size = UDim2.new(1, 0, 0, 2)
        LineBottom.Position = UDim2.new(0, 0, 1, -2)
        LineBottom.BackgroundColor3 = Color3.fromRGB(55, 75, 105)
        LineBottom.BorderSizePixel = 0
        LineBottom.ZIndex = 4
    end)

    task.spawn(function()
        local LineCenter = Instance.new("Frame")
        LineCenter.Parent = TabBar
        LineCenter.Size = UDim2.new(0, 2, 1, 0)
        LineCenter.Position = UDim2.new(0.5, -1, 0, 0)
        LineCenter.BackgroundColor3 = Color3.fromRGB(55, 75, 105)
        LineCenter.BorderSizePixel = 0
        LineCenter.ZIndex = 4
    end)

    local Tab1Btn = Instance.new("TextButton")
    Tab1Btn.Size = UDim2.new(0.5, -2, 1, -4)
    Tab1Btn.Position = UDim2.new(0, 0, 0, 2)
    Tab1Btn.BackgroundTransparency = 1
    Tab1Btn.Font = Enum.Font.GothamBold
    Tab1Btn.Text = "Data"
    Tab1Btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    Tab1Btn.TextSize = 13
    Tab1Btn.ZIndex = 4

    task.spawn(function()
        Tab1Btn.Parent = TabBar
    end)

    local Tab2Btn = Instance.new("TextButton")
    Tab2Btn.Size = UDim2.new(0.5, -2, 1, -4)
    Tab2Btn.Position = UDim2.new(0.5, 2, 0, 2)
    Tab2Btn.BackgroundTransparency = 1
    Tab2Btn.Font = Enum.Font.GothamBold
    Tab2Btn.Text = "Settings"
    Tab2Btn.TextColor3 = Color3.fromRGB(110, 125, 145)
    Tab2Btn.TextSize = 13
    Tab2Btn.ZIndex = 4

    task.spawn(function()
        Tab2Btn.Parent = TabBar
    end)

    local Tab1Page = Instance.new("Frame")
    Tab1Page.Position = UDim2.new(0, 0, 0, 65)
    Tab1Page.Size = UDim2.new(1, 0, 1, -65)
    Tab1Page.BackgroundTransparency = 1
    Tab1Page.Visible = true
    Tab1Page.ZIndex = 3

    task.spawn(function()
        Tab1Page.Parent = MainFrame
    end)

    local Tab2Page = Instance.new("ScrollingFrame")
    Tab2Page.Position = UDim2.new(0, 0, 0, 65)
    Tab2Page.Size = UDim2.new(1, 0, 1, -65)
    Tab2Page.BackgroundTransparency = 1
    Tab2Page.Visible = false
    Tab2Page.ZIndex = 3
    Tab2Page.CanvasSize = UDim2.new(0, 0, 0, 205)
    Tab2Page.ScrollBarThickness = 4
    Tab2Page.ScrollBarImageColor3 = Color3.fromRGB(0, 136, 255)

    task.spawn(function()
        Tab2Page.Parent = MainFrame
    end)

    task.spawn(function()
        Connections.Tab1Click = Tab1Btn.MouseButton1Click:Connect(function()
            task.spawn(function()
                Services.TweenService:Create(Tab1Btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(0, 170, 255)}):Play()
                Services.TweenService:Create(Tab2Btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(110, 125, 145)}):Play()
                Tab1Page.Visible = true
                Tab2Page.Visible = false
            end)
        end)
    end)

    task.spawn(function()
        Connections.Tab2Click = Tab2Btn.MouseButton1Click:Connect(function()
            task.spawn(function()
                Services.TweenService:Create(Tab1Btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(110, 125, 145)}):Play()
                Services.TweenService:Create(Tab2Btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(0, 170, 255)}):Play()
                Tab1Page.Visible = false
                Tab2Page.Visible = true
            end)
        end)
    end)

    local Ping = Instance.new("TextLabel")
    task.spawn(function()
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
    end)

    local FPS = Instance.new("TextLabel")
    task.spawn(function()
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

    local function CreateSlider(parent, labelText, yPosition, startValue)
        local SliderBar = Instance.new("Frame")
        local SliderButton = Instance.new("TextButton")
        local FillTrack = Instance.new("Frame")
        
        local initialPercentage = math.clamp((startValue - 0.1) / (5.0 - 0.1), 0, 1)

        task.spawn(function()
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
        end)

        task.spawn(function()
            SliderBar.Parent = parent
            SliderBar.Position = UDim2.new(0, 16, 0, yPosition + 18)
            SliderBar.Size = UDim2.new(1, -32, 0, 4)
            SliderBar.BackgroundColor3 = Color3.fromRGB(28, 36, 48) 
            SliderBar.BorderSizePixel = 0
            SliderBar.ZIndex = 4

            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
        end)

        task.spawn(function()
            FillTrack.Parent = SliderBar
            FillTrack.Size = UDim2.new(initialPercentage, 0, 1, 0)
            FillTrack.BackgroundColor3 = Color3.fromRGB(0, 136, 255) 
            FillTrack.BorderSizePixel = 0
            FillTrack.ZIndex = 5

            local FillTrackCorner = Instance.new("UICorner")
            FillTrackCorner.CornerRadius = UDim.new(1, 0)
            FillTrackCorner.Parent = FillTrack
        end)

        task.spawn(function()
            SliderButton.Parent = SliderBar
            SliderButton.Position = UDim2.new(initialPercentage, -6, 0.5, -6)
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
        end)

        return SliderBar, SliderButton, FillTrack
    end

    local PingBar, PingBtn, PingFill
    local FpsBar, FpsBtn, FpsFill

    task.spawn(function()
        PingBar, PingBtn, PingFill = CreateSlider(Tab2Page, "Ping Refresh", 5, PingRefreshInterval)
    end)

    task.spawn(function()
        FpsBar, FpsBtn, FpsFill = CreateSlider(Tab2Page, "FPS Refresh", 45, FpsRefreshInterval)
    end)

    task.spawn(function()
        local BoxLabel = Instance.new("TextLabel")
        BoxLabel.Parent = Tab2Page
        BoxLabel.Position = UDim2.new(0, 16, 0, 85)
        BoxLabel.Size = UDim2.new(1, -32, 0, 15)
        BoxLabel.BackgroundTransparency = 1
        BoxLabel.Font = Enum.Font.GothamSemibold
        BoxLabel.Text = "Discord Status Webhook URL"
        BoxLabel.TextColor3 = Color3.fromRGB(140, 155, 175)
        BoxLabel.TextSize = 11
        BoxLabel.TextXAlignment = Enum.TextXAlignment.Left
        BoxLabel.ZIndex = 4

        local InputFrame = Instance.new("Frame")
        InputFrame.Parent = Tab2Page
        InputFrame.Position = UDim2.new(0, 16, 0, 103)
        InputFrame.Size = UDim2.new(1, -42, 0, 24)
        InputFrame.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
        InputFrame.BorderSizePixel = 0
        InputFrame.ZIndex = 4

        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 6)
        BoxCorner.Parent = InputFrame

        local BoxStroke = Instance.new("UIStroke")
        BoxStroke.Thickness = 1
        BoxStroke.Color = Color3.fromRGB(45, 55, 75)
        BoxStroke.Parent = InputFrame

        WebBox = Instance.new("TextBox")
        WebBox.Parent = InputFrame
        WebBox.Size = UDim2.new(1, -10, 1, 0)
        WebBox.Position = UDim2.new(0, 5, 0, 0)
        WebBox.BackgroundTransparency = 1
        WebBox.Font = Enum.Font.Gotham
        WebBox.Text = "Paste Discord Webhook..."
        WebBox.TextColor3 = Color3.fromRGB(220, 230, 245)
        WebBox.PlaceholderColor3 = Color3.fromRGB(75, 85, 105)
        WebBox.TextSize = 10
        WebBox.TextXAlignment = Enum.TextXAlignment.Left
        WebBox.ClearTextOnFocus = false
        WebBox.ZIndex = 5

        WebBox.FocusLost:Connect(function(enterPressed)
            DiscordWebhookURL = WebBox.Text
            SaveConfig()
            Notify("Webhook Saved!", 1.5)
        end)

        local TestBtn = Instance.new("TextButton")
        TestBtn.Parent = Tab2Page
        TestBtn.Position = UDim2.new(0, 16, 0, 134)
        TestBtn.Size = UDim2.new(1, -42, 0, 22)
        TestBtn.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
        TestBtn.Font = Enum.Font.GothamBold
        TestBtn.Text = "Test Webhook"
        TestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TestBtn.TextSize = 11
        TestBtn.BorderSizePixel = 0
        TestBtn.ZIndex = 4

        local TestCorner = Instance.new("UICorner")
        TestCorner.CornerRadius = UDim.new(0, 6)
        TestCorner.Parent = TestBtn

        TestBtn.MouseButton1Click:Connect(function()
            if DiscordWebhookURL ~= "" and string.match(DiscordWebhookURL, "^https://") then
                SendDiscordWebhook("X", true)
                Notify("Test Sent!", 1.5)
            else
                Notify("Invalid Webhook!", 1.5)
            end
        end)

        LoadConfig()
    end)

    local MiniButton = Instance.new("TextButton")
    MiniButton.Name = "MiniButton"
    MiniButton.Size = UDim2.new(0, 55, 0, 55)
    MiniButton.Visible = false
    MiniButton.Text = "⚡"
    MiniButton.Font = Enum.Font.GothamBlack
    MiniButton.TextSize = 26
    MiniButton.TextColor3 = Color3.fromRGB(0, 185, 255)
    MiniButton.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
    MiniButton.BorderSizePixel = 0
    MiniButton.ZIndex = 5

    task.spawn(function()
        MiniButton.Parent = StatusGui
        MiniButton.Position = MainFrame.Position
    end)

    task.spawn(function()
        local MiniCorner = Instance.new("UICorner")
        MiniCorner.Parent = MiniButton
        MiniCorner.CornerRadius = UDim.new(0, 14)
    end)

    task.spawn(function()
        local MiniStroke = Instance.new("UIStroke")
        MiniStroke.Name = "MiniStroke"
        MiniStroke.Parent = MiniButton
        MiniStroke.Thickness = 1.5
        MiniStroke.Color = Color3.fromRGB(0, 102, 204)
    end)

    function CleanUp()
        Destroyed = true
        for _, connection in pairs(Connections) do
            pcall(function() connection:Disconnect() end)
        end
        Connections = {}
        pcall(function() StatusGui:Destroy() end)
        StatusGui = nil; MainFrame = nil; Ping = nil; FPS = nil; MiniButton = nil
    end

    local function SetupSliderFunctionality(sliderName, SliderBar, SliderButton, FillTrack, minVal, maxVal, callback)
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
            SaveConfig()
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

    task.spawn(function()
        task.wait(0.2)
        SetupSliderFunctionality("PingTrack", PingBar, PingBtn, PingFill, 0.1, 5.0, function(v) PingRefreshInterval = v end)
    end)

    task.spawn(function()
        task.wait(0.2)
        SetupSliderFunctionality("FpsTrack", FpsBar, FpsBtn, FpsFill, 0.1, 5.0, function(v) FpsRefreshInterval = v end)
    end)

    local function HandleDragging(TargetFrame, InputSource)
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

    task.spawn(function()
        HandleDragging(MainFrame, Services.UserInputService)
    end)

    task.spawn(function()
        HandleDragging(MiniButton, Services.UserInputService)
    end)

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

    task.spawn(function()
        Connections.Yellow = YellowButton.MouseButton1Click:Connect(function()
            task.spawn(MinimizeGui)
        end)
    end)

    task.spawn(function()
        Connections.Mini = MiniButton.MouseButton1Click:Connect(function()
            task.spawn(OpenGui)
        end)
    end)

    task.spawn(function()
        Connections.Green = GreenButton.MouseButton1Click:Connect(function()
            task.spawn(function()
                FPS.Text = "FPS : Refreshing..."
                Ping.Text = "Ping : Refreshing..."
                Notify("Refreshed", 2)
            end)
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
            task.spawn(function()
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
    end)

    task.spawn(function()
        Connections.DisconnectWatch = Services.GuiService.ErrorMessageChanged:Connect(function(message, errorType)
            if HasSentDisconnect then return end
            if IsAltF4 then
                SendDiscordWebhook("get forceclosed")
                return
            end
            if IsAttemptingLeave then 
                SendDiscordWebhook("leave game")
                return 
            end
            
            local msgLower = string.lower(message)
            if string.find(msgLower, "kick") or string.find(msgLower, "ban") then
                SendDiscordWebhook("get kicked (" .. message .. ")")
            else
                SendDiscordWebhook("get disconnected (" .. message .. ")")
            end
        end)
    end)

    task.spawn(function()
        Connections.CrashWatch = Services.LogService.MessageOut:Connect(function(message, messageType)
            if HasSentDisconnect then return end
            if messageType == Enum.MessageType.MessageError then
                local msgLower = string.lower(message)
                if string.find(msgLower, "crash") or string.find(msgLower, "fatal") or string.find(msgLower, "out of memory") then
                    SendDiscordWebhook("get forceclosed")
                end
            end
        end)
    end)

    task.spawn(function()
        local function TrackNativeLeaveButton()
            local robloxGui = Services.CoreGui:FindFirstChild("RobloxGui")
            if robloxGui then
                local gameMenu = robloxGui:FindFirstChild("GameMenu", true) or robloxGui:FindFirstChild("SettingsMenu", true) or robloxGui:FindFirstChild("InGameMenu", true)
                if gameMenu then
                    local leaveBtn = gameMenu:FindFirstChild("LeaveGame", true) or gameMenu:FindFirstChild("LeaveButton", true) or gameMenu:FindFirstChild("LeaveGameButton", true)
                    if leaveBtn and leaveBtn:IsA("GuiButton") then
                        Connections.NativeLeaveClick = leaveBtn.MouseButton1Click:Connect(function()
                            IsAttemptingLeave = true
                            SendDiscordWebhook("leave game")
                        end)
                        return true
                    end
                end
            end
            return false
        end

        if not TrackNativeLeaveButton() then
            task.spawn(function()
                while not Destroyed and not IsAttemptingLeave do
                    if TrackNativeLeaveButton() then break end
                    task.wait(1)
                end
            end)
        end
    end)

    task.spawn(function()
        Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.KeyCode == Enum.KeyCode.L or input.KeyCode == Enum.KeyCode.Return then
                if Services.GuiService.MenuIsOpen then
                    IsAttemptingLeave = true
                end
            end
        end)
    end)

    task.spawn(function()
        Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
            local isAltDown = Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or Services.UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
            if input.KeyCode == Enum.KeyCode.F4 and isAltDown then
                IsAltF4 = true
                SendDiscordWebhook("get forceclosed")
            end
        end)
    end)

    task.spawn(function()
        game.AncestryChanged:Connect(function(_, parent)
            if not parent and not HasSentDisconnect then
                if IsAltF4 then
                    SendDiscordWebhook("get forceclosed")
                elseif IsAttemptingLeave then
                    SendDiscordWebhook("leave game")
                else
                    SendDiscordWebhook("get disconnected")
                end
            end
        end)
    end)

    task.spawn(function()
        game:BindToClose(function()
            if not HasSentDisconnect then
                if IsAltF4 then
                    SendDiscordWebhook("get forceclosed")
                else
                    IsAttemptingLeave = true
                    SendDiscordWebhook("leave game")
                end
                local timer = os.clock()
                while os.clock() - timer < 0.8 do
                    task.wait()
                end
            end
        end)
    end)
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Executor",
    Text = "Executed",
    Duration = 2
})
