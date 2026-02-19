local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Noxium = {}
Noxium.Theme = {
    Main = Color3.fromRGB(10, 10, 10),
    Accent = Color3.fromRGB(80, 0, 255),
    Black = Color3.fromRGB(0, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Placeholder = Color3.fromRGB(150, 150, 150)
}

local function Create(class, props)
    local obj = Instance.new(class)
    for prop, val in pairs(props) do obj[prop] = val end
    return obj
end

function Noxium:CreateWindow(TitleText)
    local Screen = Create("ScreenGui", {Name = "Noxium_Lib", Parent = CoreGui})
    
    local IsMinimized = false
    local FullSize = UDim2.new(0, 350, 0, 250)
    local MinSize = UDim2.new(0, 350, 0, 40)

    local Main = Create("Frame", {
        Name = "Main", Parent = Screen, Size = FullSize,
        Position = UDim2.new(0.5, -175, 0.5, -125),
        BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0,
        Active = true, ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    local Stroke = Create("UIStroke", {Color = self.Theme.Accent, Thickness = 1.5, Parent = Main})

    local MainGrad = Create("UIGradient", {
        Parent = Main, Rotation = 45,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.Theme.Accent),
            ColorSequenceKeypoint.new(1, self.Theme.Black)
        })
    })

    local ToggleBtn = Create("TextButton", {
        Name = "ToggleBtn", Parent = Main, Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5), BackgroundTransparency = 1,
        Text = "▲", Font = "GothamBold", TextSize = 14, TextColor3 = self.Theme.Text, ZIndex = 10
    })

    local TabHolder = Create("Frame", {
        Name = "TabHolder", Parent = Main, BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 35), Position = UDim2.new(0, 5, 0, 5)
    })
    Create("UIListLayout", {Parent = TabHolder, FillDirection = "Horizontal", Padding = UDim.new(0, 8), VerticalAlignment = "Center"})

    local Pages = Create("Frame", {
        Name = "Pages", Parent = Main, BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -60), Position = UDim2.new(0, 10, 0, 50)
    })

    local CurrentTab = nil

    -- Lógica de minimizar
    ToggleBtn.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        TS:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = IsMinimized and MinSize or FullSize}):Play()
        ToggleBtn.Text = IsMinimized and "▼" or "▲"
    end)

    -- Drag System
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not IsMinimized then
            dragging = true dragStart = input.Position startPos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

    -- Animación Gradient
    task.spawn(function()
        TS:Create(MainGrad, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation = 225}):Play()
    end)

    local TabHandler = {}

    function TabHandler:NewTab(name)
        local Page = Create("ScrollingFrame", {
            Parent = Pages, Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 0, 
            CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = "Y"
        })
        Create("UIListLayout", {Parent = Page, Padding = UDim.new(0, 5), HorizontalAlignment = "Center"})

        local TabBtn = Create("TextButton", {
            Parent = TabHolder, Size = UDim2.new(0, 80, 0, 25),
            BackgroundColor3 = Noxium.Theme.Black, BackgroundTransparency = 0.6,
            Text = name, Font = "GothamBold", TextSize = 11, TextColor3 = Noxium.Theme.Placeholder
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

        TabBtn.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Page.Visible = false
                TS:Create(CurrentTab.Btn, TweenInfo.new(0.3), {TextColor3 = Noxium.Theme.Placeholder, BackgroundTransparency = 0.6}):Play()
            end
            Page.Visible = true
            CurrentTab = {Page = Page, Btn = TabBtn}
            TS:Create(TabBtn, TweenInfo.new(0.3), {TextColor3 = Noxium.Theme.Text, BackgroundTransparency = 0.2}):Play()
        end)

        if not CurrentTab then
            Page.Visible = true
            CurrentTab = {Page = Page, Btn = TabBtn}
            TabBtn.TextColor3 = Noxium.Theme.Text
            TabBtn.BackgroundTransparency = 0.2
        end

        local ElementHandler = {}

        function ElementHandler:Button(text, callback)
            local Btn = Create("TextButton", {
                Parent = Page, Size = UDim2.new(0.95, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30), BackgroundTransparency = 0.5,
                Text = text, Font = "GothamBold", TextColor3 = Noxium.Theme.Text, TextSize = 13
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Btn})
            Btn.MouseButton1Click:Connect(callback)
        end

        function ElementHandler:Toggle(text, callback)
            local state = false
            local Tgl = Create("TextButton", {
                Parent = Page, Size = UDim2.new(0.95, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30), BackgroundTransparency = 0.5,
                Text = text .. ": OFF", Font = "GothamBold", TextColor3 = Color3.fromRGB(255, 100, 100), TextSize = 13
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Tgl})
            Tgl.MouseButton1Click:Connect(function()
                state = not state
                Tgl.Text = text .. (state and ": ON" or ": OFF")
                Tgl.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
                callback(state)
            end)
        end

        return ElementHandler
    end

    return TabHandler
end

return Noxium
