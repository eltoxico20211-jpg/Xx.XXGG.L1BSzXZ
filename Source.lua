local IsoneUI = {
    Theme = {
        Main = Color3.fromRGB(5, 5, 5),
        Secondary = Color3.fromRGB(12, 12, 12),
        Accent = Color3.fromRGB(255, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Stroke = Color3.fromRGB(35, 35, 35),
        Header = Color3.fromRGB(10, 10, 10)
    },
    Services = {
        TS = game:GetService("TweenService"),
        UIS = game:GetService("UserInputService"),
        Run = game:GetService("RunService"),
        CoreGui = game:GetService("CoreGui")
    }
}

local Elements = {}

local function Create(class, props)
    local obj = Instance.new(class)
    for prop, val in pairs(props) do obj[prop] = val end
    return obj
end

function IsoneUI:Tween(obj, time, prop)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local anim = self.Services.TS:Create(obj, info, prop)
    anim:Play()
    return anim
end

function IsoneUI:CreateWindow(Name, Version)

    local Title = string.format("%s <font color='#FF0000'>%s</font>", Name or "ISONE", Version or "V2")
    
    local Screen = Create("ScreenGui", {Name = "Isone_Radical", Parent = IsoneUI.Services.CoreGui, IgnoreGuiInset = true})
    
    local Main = Create("Frame", {
        Name = "Main",
        Parent = Screen,
        BackgroundColor3 = self.Theme.Main,
        Size = UDim2.new(0, 500, 0, 300),
        Position = UDim2.new(0.5, -250, 0.5, -150),
        ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Main})
    Create("UIStroke", {Color = self.Theme.Stroke, Thickness = 1.2, Parent = Main})

    local Navbar = Create("Frame", {
        Name = "Navbar",
        Parent = Main,
        BackgroundColor3 = self.Theme.Header,
        Size = UDim2.new(1, 0, 0, 45)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Navbar})

    local OpenBtn = Create("TextButton", {
    Name = "OpenButton",
    Parent = Screen,
    Size = UDim2.new(0, 45, 0, 45),
    Position = UDim2.new(0, 10, 0.5, -22),
    BackgroundColor3 = IsoneUI.Theme.Main,
    Text = "I", -- Inicial de Isone
    TextColor3 = IsoneUI.Theme.Accent,
    Font = "GothamBold",
    TextSize = 20,
    Visible = false,
    ZIndex = 10
})

Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = OpenBtn})
Create("UIStroke", {Color = IsoneUI.Theme.Accent, Thickness = 1.5, Parent = OpenBtn})
    
    local Logo = Create("TextLabel", {
        Parent = Navbar,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundTransparency = 1,
        Text = Title,
        RichText = true,
        Font = "GothamBold",
        TextColor3 = self.Theme.Text,
        TextSize = 18,
        TextXAlignment = "Left"
    })

    local clicks = 0
local lastClick = 0
local startPos = nil

Logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startPos = input.Position
    end
end)

Logo.InputEnded:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and startPos then
        local endPos = input.Position
        local distance = (endPos - startPos).Magnitude

        if distance < 5 then
            local now = tick()
            if now - lastClick > 0.5 then clicks = 0 end
            
            clicks = clicks + 1
            lastClick = now
            
            if clicks == 3 then
                clicks = 0
                Main.Visible = false
              OpenBtn.Visible = true
            end
        end
        startPos = nil
    end
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

IsoneUI.Services.UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

    local TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Parent = Navbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 120, 0, 0),
        Size = UDim2.new(1, -130, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarThickness = 0,
        ClipsDescendants = true
    })

    Create("UIListLayout", {
        Parent = TabList,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    Create("UIPadding", {
        Parent = TabList,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })

    local Container = Create("Frame", {
        Name = "PageContainer",
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 55),
        Size = UDim2.new(1, -20, 1, -65)
    })

    local isDragging, dragInput, dragStartPos, mainStartPos
    
    Navbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStartPos = input.Position
            mainStartPos = Main.Position
        end
    end)

    self.Services.UIS.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartPos
            Main.Position = UDim2.new(
                mainStartPos.X.Scale, 
                mainStartPos.X.Offset + delta.X, 
                mainStartPos.Y.Scale, 
                mainStartPos.Y.Offset + delta.Y
            )
        end
    end)

    self.Services.UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            isDragging = false 
        end
    end)

    local Window = {
        Screen = Screen,
        Main = Main,
        Container = Container,
        TabList = TabList,
        CurrentTab = nil,
        CurrentPage = nil
    }

function Window:CreateTab(Name)
    local TabBtn = Create("TextButton", {
        Parent = TabList,
        BackgroundColor3 = IsoneUI.Theme.Secondary,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 85, 0, 30),
        Text = "",
        AutoButtonColor = false
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = TabBtn})
    
    local TabLabel = Create("TextLabel", {
        Parent = TabBtn,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = Name,
        Font = "GothamMedium",
        TextColor3 = IsoneUI.Theme.TextDark,
        TextSize = 12
    })

    local Page = Create("Frame", {
        Parent = Container,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false
    })
    
    local LeftCol = Create("Frame", {
        Name = "LeftColumn",
        Parent = Page,
        Size = UDim2.new(0.5, -5, 1, 0),
        BackgroundTransparency = 1
    })
    
    local RightCol = Create("Frame", {
        Name = "RightColumn",
        Parent = Page,
        Position = UDim2.new(0.5, 5, 0, 0),
        Size = UDim2.new(0.5, -5, 1, 0),
        BackgroundTransparency = 1
    })

    for _, col in pairs({LeftCol, RightCol}) do
        Create("UIListLayout", {Parent = col, Padding = UDim.new(0, 10), HorizontalAlignment = "Center"})
    end

    TabBtn.MouseButton1Click:Connect(function()
        if Window.CurrentPage then
            Window.CurrentPage.Visible = false
            IsoneUI:Tween(Window.CurrentTab:FindFirstChildOfClass("TextLabel"), 0.2, {TextColor3 = IsoneUI.Theme.TextDark})
            IsoneUI:Tween(Window.CurrentTab, 0.2, {BackgroundTransparency = 1})
        end
        Window.CurrentPage, Window.CurrentTab, Page.Visible = Page, TabBtn, true
        IsoneUI:Tween(TabLabel, 0.2, {TextColor3 = IsoneUI.Theme.Accent})
        IsoneUI:Tween(TabBtn, 0.2, {BackgroundTransparency = 0.8})
    end)

    local TabContent = {Left = LeftCol, Right = RightCol}
    
    function TabContent:CreateGroupbox(Side, GroupName)
        local ParentCol = (Side == "Left" and LeftCol or RightCol)
        
        local GroupFrame = Create("Frame", {
            Name = GroupName .. "_Group",
            Parent = ParentCol,
            BackgroundColor3 = IsoneUI.Theme.Secondary,
            Size = UDim2.new(1, 0, 0, 235),
            BackgroundTransparency = 0.5
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = GroupFrame})
        Create("UIStroke", {Color = IsoneUI.Theme.Stroke, Thickness = 0.8, Parent = GroupFrame})

        local GroupTitle = Create("TextLabel", {
            Parent = GroupFrame,
            Size = UDim2.new(1, -10, 0, 25),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = GroupName:upper(),
            Font = "GothamBold",
            TextColor3 = IsoneUI.Theme.Accent,
            TextSize = 11,
            TextXAlignment = "Left"
        })

        local GroupScroll = Create("ScrollingFrame", {
            Parent = GroupFrame,
            Position = UDim2.new(0, 5, 0, 25),
            Size = UDim2.new(1, -10, 1, -30),
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            ScrollBarImageColor3 = IsoneUI.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = "Y"
        })
        Create("UIListLayout", {Parent = GroupScroll, Padding = UDim.new(0, 5), HorizontalAlignment = "Center"})

        local GroupHandler = {}
    
    function GroupHandler:CreateCheckbox(t, d, c)
    return Elements.CreateCheckbox(Elements, GroupScroll, t, d, c)
end

    function GroupHandler:CreateDropdown(t, o, d, c)
    return Elements.CreateDropdown(Elements, GroupScroll, t, o, d, c)
end

    function GroupHandler:CreateSlider(t, min, max, d, c)
    return Elements.Slider(Elements, GroupScroll, t, min, max, d, c)
end

    function GroupHandler:CreateInput(t, p, c)
    return Elements.CreateInput(Elements, GroupScroll, t, p, c)
end

    function GroupHandler:CreateLabel(t)
    return Elements.CreateLabel(Elements, GroupScroll, t)
end
    
    return GroupHandler
end

    if not Window.CurrentPage then
        Window.CurrentPage, Window.CurrentTab, Page.Visible = Page, TabBtn, true
        TabLabel.TextColor3 = IsoneUI.Theme.Accent
        TabBtn.BackgroundTransparency = 0.8
    end
    return TabContent
end

    return Window
end

Elements = {}

function Elements:CreateCheckbox(Parent, Text, Default, Callback)
    local Checkbox = {
        Value = Default or false,
        Callback = Callback or function() end
    }
    
    local MainBtn = Create("TextButton", {
        Parent = Parent,
        Size = UDim2.new(1, -10, 0, 32),
        BackgroundColor3 = IsoneUI.Theme.Main,
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainBtn})
    local Stroke = Create("UIStroke", {Color = IsoneUI.Theme.Stroke, Thickness = 0.8, Parent = MainBtn})

    local Box = Create("Frame", {
        Parent = MainBtn,
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -26, 0.5, -9),
        BackgroundColor3 = IsoneUI.Theme.Secondary,
        BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Box})
    local BoxStroke = Create("UIStroke", {Color = IsoneUI.Theme.Stroke, Thickness = 1.5, Parent = Box})

    local Indicator = Create("Frame", {
        Parent = Box,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = IsoneUI.Theme.Accent,
        BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Indicator})

    local Label = Create("TextLabel", {
        Parent = MainBtn,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = Text,
        Font = "GothamMedium",
        TextColor3 = Checkbox.Value and IsoneUI.Theme.Text or IsoneUI.Theme.TextDark,
        TextSize = 12,
        TextXAlignment = "Left"
    })

    local function Update()
        local TargetSize = Checkbox.Value and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 0, 0, 0)
        local TargetPos = Checkbox.Value and UDim2.new(0, 0, 0, 0) or UDim2.new(0.5, 0, 0.5, 0)
        local LabelColor = Checkbox.Value and IsoneUI.Theme.Text or IsoneUI.Theme.TextDark

        IsoneUI:Tween(Indicator, 0.15, {Size = TargetSize, Position = TargetPos})
        IsoneUI:Tween(Label, 0.15, {TextColor3 = LabelColor})
        IsoneUI:Tween(BoxStroke, 0.15, {Color = StrokeColor})
        task.spawn(Checkbox.Callback, Checkbox.Value)
    end

    MainBtn.MouseButton1Click:Connect(function()
        Checkbox.Value = not Checkbox.Value
        Update()
    end)

    function Checkbox:Set(v)
        self.Value = v
        Update()
    end

    if Checkbox.Value then Update() end
    return Checkbox
end

   function Elements:CreateDropdown(Parent, Text, Options, Default, Callback)
    local Dropdown = {
        Value = Default or Options[1],
        Options = Options or {},
        Callback = Callback or function() end,
        Open = false
    }
    
    local DropMain = Create("Frame", {
        Parent = Parent,
        Size = UDim2.new(1, -10, 0, 32),
        BackgroundTransparency = 1,
        ClipsDescendants = false
    })

    local Label = Create("TextLabel", {
        Parent = DropMain,
        Size = UDim2.new(1, -120, 0, 32),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = Text,
        Font = "GothamMedium",
        TextColor3 = IsoneUI.Theme.Text,
        TextSize = 12,
        TextXAlignment = "Left"
    })

    local DropContainer = Create("Frame", {
        Parent = DropMain,
        Size = UDim2.new(0, 100, 0, 24),
        Position = UDim2.new(1, -108, 0, 4),
        BackgroundColor3 = IsoneUI.Theme.Secondary,
        ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DropContainer})
    local DropStroke = Create("UIStroke", {Color = IsoneUI.Theme.Stroke, Thickness = 0.8, Parent = DropContainer})

    local SelectedBtn = Create("TextButton", {
        Parent = DropContainer,
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = ""
    })

    local SelectedLabel = Create("TextLabel", {
        Parent = SelectedBtn,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = Dropdown.Value,
        Font = "GothamMedium",
        TextColor3 = IsoneUI.Theme.Accent,
        TextSize = 11,
        TextTruncate = "AtEnd"
    })

    local OptionList = Create("Frame", {
        Parent = DropContainer,
        Size = UDim2.new(1, -10, 0, 0),
        Position = UDim2.new(0, 5, 0, 28),
        BackgroundTransparency = 1
    })
    local Layout = Create("UIListLayout", {
        Parent = OptionList,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local function Update()
        local ListSize = Layout.AbsoluteContentSize.Y
        -- Altura del cuadro de la derecha
        local TargetDropSize = Dropdown.Open and UDim2.new(0, 100, 0, ListSize + 35) or UDim2.new(0, 100, 0, 24)
        local TargetMainHeight = Dropdown.Open and (ListSize + 40) or 32

        IsoneUI:Tween(DropContainer, 0.25, {Size = TargetDropSize})
        IsoneUI:Tween(DropMain, 0.25, {Size = UDim2.new(1, -10, 0, TargetMainHeight)})
        IsoneUI:Tween(DropStroke, 0.25, {Color = Dropdown.Open and IsoneUI.Theme.Accent or IsoneUI.Theme.Stroke})
    end

    for _, v in pairs(Dropdown.Options) do
        local Opt = Create("TextButton", {
            Parent = OptionList,
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundColor3 = IsoneUI.Theme.Main,
            BackgroundTransparency = 0.2,
            Text = v,
            Font = "GothamMedium",
            TextColor3 = IsoneUI.Theme.TextDark,
            TextSize = 10,
            AutoButtonColor = false
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Opt})

        Opt.MouseButton1Click:Connect(function()
            Dropdown.Value = v
            SelectedLabel.Text = v
            Dropdown.Open = false
            Update()
            task.spawn(Dropdown.Callback, v)
        end)
    end

    SelectedBtn.MouseButton1Click:Connect(function()
        Dropdown.Open = not Dropdown.Open
        Update()
    end)

    return Dropdown
end

   function Elements:Slider(Parent, Text, Min, Max, Default, Callback)
    local Slider = {
        Value = Default or Min,
        Min = Min or 0,
        Max = Max or 100,
        Callback = Callback or function() end,
        Dragging = false
    }

    local SliderMain = Create("Frame", {
        Parent = Parent,
        Size = UDim2.new(1, -10, 0, 35),
        BackgroundTransparency = 1,
    })

    local Label = Create("TextLabel", {
        Parent = SliderMain,
        Size = UDim2.new(1, -180, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = Text,
        Font = "GothamMedium",
        TextColor3 = IsoneUI.Theme.Text,
        TextSize = 12,
        TextXAlignment = "Left"
    })

    local SliderBack = Create("Frame", {
        Parent = SliderMain,
        Size = UDim2.new(0, 90, 0, 4),
        Position = UDim2.new(1, -125, 0.5, -2),
        BackgroundColor3 = IsoneUI.Theme.Secondary,
        BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderBack})

    local SliderFill = Create("Frame", {
        Parent = SliderBack,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = IsoneUI.Theme.Accent,
        BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderFill})

    Create("UIGradient", {
        Parent = SliderFill,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, IsoneUI.Theme.Accent)
        })
    })

    local Knob = Create("Frame", {
        Parent = SliderFill,
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -6, 0.5, -6),
        BackgroundColor3 = IsoneUI.Theme.Accent,
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})

    local ValueLabel = Create("TextLabel", {
        Parent = SliderMain,
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(Slider.Value),
        Font = "GothamBold",
        TextColor3 = IsoneUI.Theme.Accent,
        TextSize = 11
    })

    local function Update(input)
        local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        Slider.Value = math.floor(((Slider.Max - Slider.Min) * pos) + Slider.Min)
        
        ValueLabel.Text = tostring(Slider.Value)
        -- Tween super fluido para el relleno y el knob
        IsoneUI:Tween(SliderFill, 0.1, {Size = UDim2.new(pos, 0, 1, 0)})
        
        task.spawn(Slider.Callback, Slider.Value)
    end

    SliderMain.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Slider.Dragging = true
            IsoneUI:Tween(Knob, 0.15, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -7, 0.5, -7)})
            Update(input)
        end
    end)

    IsoneUI.Services.UIS.InputChanged:Connect(function(input)
        if Slider.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input)
        end
    end)

    IsoneUI.Services.UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Slider.Dragging = false
            IsoneUI:Tween(Knob, 0.15, {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -6, 0.5, -6)})
        end
    end)

    local initPos = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
    SliderFill.Size = UDim2.new(initPos, 0, 1, 0)

    return Slider
end

function Elements:CreateInput(Parent, Text, Placeholder, Callback)
    local Input = {
        Value = "",
        Callback = Callback or function() end
    }

    local InputMain = Create("Frame", {
        Parent = Parent,
        Size = UDim2.new(1, -10, 0, 35),
        BackgroundTransparency = 1,
    })

    local Label = Create("TextLabel", {
        Parent = InputMain,
        Size = UDim2.new(1, -160, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = Text,
        Font = "GothamMedium",
        TextColor3 = IsoneUI.Theme.Text,
        TextSize = 12,
        TextXAlignment = "Left"
    })

    local InputFrame = Create("Frame", {
        Parent = InputMain,
        Size = UDim2.new(0, 120, 0, 24),
        Position = UDim2.new(1, -127, 0.5, -12),
        BackgroundColor3 = IsoneUI.Theme.Secondary,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = InputFrame})
    local InputStroke = Create("UIStroke", {Color = IsoneUI.Theme.Stroke, Thickness = 0.8, Parent = InputFrame})

    local TextBox = Create("TextBox", {
        Parent = InputFrame,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = Placeholder or "Escribe aquí...",
        PlaceholderColor3 = IsoneUI.Theme.TextDark,
        Font = "GothamMedium",
        TextColor3 = IsoneUI.Theme.Text,
        TextSize = 11,
        ClearTextOnFocus = false,
        TextXAlignment = "Left"
    })

    TextBox.Focused:Connect(function()
        IsoneUI:Tween(InputStroke, 0.2, {Color = IsoneUI.Theme.Accent, Thickness = 1.2})
    end)

    TextBox.FocusLost:Connect(function(EnterPressed)
        IsoneUI:Tween(InputStroke, 0.2, {Color = IsoneUI.Theme.Stroke, Thickness = 0.8})
        Input.Value = TextBox.Text
        task.spawn(Input.Callback, Input.Value, EnterPressed)
    end)

    function Input:Set(v)
        Input.Value = v
        TextBox.Text = v
        task.spawn(Input.Callback, v, false)
    end

    return Input
end

function Elements:CreateLabel(Parent, Text)
    local Label = {
        Value = Text
    }

    local LabelMain = Create("Frame", {
        Parent = Parent,
        Size = UDim2.new(1, -10, 0, 25),
        BackgroundTransparency = 1,
    })

    local TextLabel = Create("TextLabel", {
        Parent = LabelMain,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = Text,
        Font = "GothamMedium",
        TextColor3 = IsoneUI.Theme.TextDark,
        TextSize = 11,
        RichText = true,
        TextXAlignment = "Left",
        TextWrapped = true
    })

    function Label:Set(NewText)
        Label.Value = NewText
        TextLabel.Text = NewText
    end

    return Label
end
    
return IsoneUI
