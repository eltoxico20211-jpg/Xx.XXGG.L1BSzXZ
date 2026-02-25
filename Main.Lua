local IsoneUI = {
    Theme = {
        Main = Color3.fromRGB(0, 0, 0),
        Secondary = Color3.fromRGB(15, 15, 15),
        DarkRed = Color3.fromRGB(0, 0, 0),
        ElementsDark = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(255, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        Placeholder = Color3.fromRGB(150, 150, 150),
        Stroke = Color3.fromRGB(40, 40, 45),
    },
    Services = {
        TS = game:GetService("TweenService"),
        UIS = game:GetService("UserInputService"),
        Run = game:GetService("RunService"),
        CoreGui = game:GetService("CoreGui")
    }
}

IsoneUI.Icons = {
    ["Home"] = "rbxassetid://138635394134543",
    ["Crosshair"] = "rbxassetid://128826705904909",
    ["Settings"] = "rbxassetid://110104900682978",
    ["Scheck"] = "rbxassetid://125834515260940",
    ["Box"] = "rbxassetid://116389200520923",
    ["Eye"] = "rbxassetid://70829415657717",
    ["Zap"] = "rbxassetid://116065554792972",
    ["Key"] = "rbxassetid://102150703754287",
    ["Gem"] = "rbxassetid://89116087127715",
    ["Link"] = "rbxassetid://80640582703367",
    ["Info"] = "rbxassetid://115433979237671",
    ["People"] = "rbxassetid://78731454631758",
    ["Rocket"] = "rbxassetid://125983293411235",
    ["Sword"] = "rbxassetid://120479974631658",
    ["Map-Pin"] = "rbxassetid://112046003587634",
    ["Webh"] = "rbxassetid://103022949626394",
    ["Logo"] = "rbxassetid://134754437419894",
}

local function Create(class, props)
    local obj = Instance.new(class)
    for prop, val in pairs(props) do
        obj[prop] = val
    end
    return obj
end

function IsoneUI:Tween(obj, time, prop)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local anim = self.Services.TS:Create(obj, info, prop)
    anim:Play()
    return anim
end

-- DRAG --

function IsoneUI:MakeDraggable(gui, dragPart)
    local dragging, dragStart, startPos
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, input.Position, gui.Position
        end
    end)
    self.Services.UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    self.Services.UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragging = false 
        end
    end)
end

-- ANIMATIONS --

IsoneUI.Fluid = function(obj, targetSize, duration, style)
    local RunService = game:GetService("RunService")
    local startSize = obj.Size
    local startTime = tick()
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local alpha = math.clamp(elapsed / duration, 0, 1)

        local f = (alpha - 1)
        local back = f * f * ((1.70158 + 1) * f + 1.70158) + 1
        local quart = 1 - ((1 - alpha) ^ 4)
        
        local selectedAlpha = (style == "Back" and back or quart)
        
        obj.Size = UDim2.new(
            0, startSize.Width.Offset + (targetSize.Width.Offset - startSize.Width.Offset) * selectedAlpha,
            0, startSize.Height.Offset + (targetSize.Height.Offset - startSize.Height.Offset) * selectedAlpha
        )
        
        if alpha >= 1 then
            connection:Disconnect()
            obj.Size = targetSize
        end
    end)
    return connection
end

IsoneUI.ToggleUI = function(self, state)
    local Main = self.Main
    local OpenBtn = self.OpenBtn
    
    if state then
        Main.Visible = true
        Main.Position = UDim2.new(0.5, -200, 1.5, 0) 
        Main.BackgroundTransparency = 0

        self:Tween(Main, 0.5, {
            Position = UDim2.new(0.5, -200, 0.5, -130), 
            BackgroundTransparency = 0
        })
        OpenBtn.Visible = false
    else
        local Anim = self:Tween(Main, 0.4, {
            Position = UDim2.new(0.5, -200, 1.5, 0),
            BackgroundTransparency = 1
        })
        
        Anim.Completed:Connect(function()
            Main.Visible = false
            OpenBtn.Visible = true
        end)
    end
end

-- PARTE 3 --

IsoneUI.Windows = {
    CurrentWindow = nil,
    Create = function(self, TitleText)
        local Screen = Create("ScreenGui", {Name = "Isone_Root", Parent = IsoneUI.Services.CoreGui, IgnoreGuiInset = true, ResetOnSpawn = false})
        local Main = Create("Frame", {Name = "MainFrame", Parent = Screen, BackgroundColor3 = IsoneUI.Theme.DarkRed, BackgroundTransparency = 0, Position = UDim2.new(0.5, -200, 0.5, -130), Size = UDim2.new(0, 400, 0, 260)})
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
        Create("UIStroke", {Color = IsoneUI.Theme.Stroke, Thickness = 1, Parent = Main})
        Create("UIAspectRatioConstraint", {AspectRatio = 1.538, AspectType = "ScaleWithParentSize", Parent = Main})

        local Shadow = Create("ImageLabel", {Name = "Shadow", Parent = Main, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 45, 1, 45), ZIndex = -1, Image = "rbxassetid://100288537660010", ImageColor3 = Color3.fromRGB(0, 0, 0), ImageTransparency = 0.5, ScaleType = "Slice", SliceCenter = Rect.new(49, 49, 450, 450)})
        
        local Header = Create("Frame", {Name = "Header", Parent = Main, BackgroundColor3 = IsoneUI.Theme.DarkRed, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 35)})
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Header})
        local Title = Create("TextLabel", {Name = "Title", Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0.5, 0, 1, 0), Font = "GothamBold", Text = TitleText, TextColor3 = IsoneUI.Theme.Text, TextSize = 14, TextXAlignment = "Left"})

        local OpenBtn = Create("TextButton", {Name = "OpenBtn", Parent = Screen, BackgroundColor3 = IsoneUI.Theme.Secondary, BackgroundTransparency = 0.3, Size = UDim2.new(0.15, 40, 0.05, 0), Position = UDim2.new(0.5, 0, 0.05, 0), AnchorPoint = Vector2.new(0.5, 0.5), Visible = false, Text = TitleText, Font = "GothamBold", TextColor3 = IsoneUI.Theme.Accent, TextSize = 13, TextScaled = true})
        Create("UICorner", {CornerRadius = UDim.new(0, 15), Parent = OpenBtn}); Create("UIStroke", {Color = IsoneUI.Theme.Accent, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = OpenBtn})
         Create("UIAspectRatioConstraint", {Parent = OpenBtn, AspectRatio = 2.667})
        IsoneUI:MakeDraggable(OpenBtn, OpenBtn)

        IsoneUI.Main = Main
        IsoneUI.OpenBtn = OpenBtn

        local Close = Create("TextButton", {Name = "Close", Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(1, -30, 0, 0), Size = UDim2.new(0, 30, 1, 0), Text = "×", Font = "GothamMedium", TextColor3 = IsoneUI.Theme.Text, TextSize = 20})
        Create("UIStroke", {Color = IsoneUI.Theme.Stroke, Thickness = 1, Parent = Close})
        local Min = Create("TextButton", {Name = "Min", Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(1, -60, 0, 0), Size = UDim2.new(0, 30, 1, 0), Text = "-", Font = "GothamMedium", TextColor3 = IsoneUI.Theme.Text, TextSize = 20})
        Create("UIStroke", {Color = IsoneUI.Theme.Stroke, Thickness = 1, Parent = Min})

        Close.MouseButton1Click:Connect(function() Screen:Destroy() end)
        Min.MouseButton1Click:Connect(function() IsoneUI:ToggleUI(false) end)
OpenBtn.MouseButton1Click:Connect(function() IsoneUI:ToggleUI(true) end)

        IsoneUI:MakeDraggable(Main, Header)

        local Sidebar = Create("Frame", {Name = "Sidebar", Parent = Main, BackgroundColor3 = IsoneUI.Theme.DarkRed, BackgroundTransparency = 0.2, Position = UDim2.new(0, 0, 0, 37), Size = UDim2.new(0, 130, 1, -38), ClipsDescendants = true})
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Sidebar})
        local Container = Create("Frame", {Name = "Container", Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 140, 0, 40), Size = UDim2.new(1, -145, 1, -45), ClipsDescendants = true})
        
        self.CurrentWindow = {Main = Main, Container = Container, Sidebar = Sidebar, Screen = Screen}
        return self.CurrentWindow
    end
}

-- PARTE 4 --

IsoneUI.KeySystem = {
    Verify = function(self, Config)
        local CorrectKey, Callback = Config.Key, Config.Callback
        local KeyWin = IsoneUI.Windows:Create(Config.Title or "Security Check")
        
        KeyWin.Main.Size = UDim2.new(0, 320, 0, 180)
        KeyWin.Main.Position = UDim2.new(0.5, -160, 0.5, -90)
        KeyWin.Sidebar.Visible = false
        KeyWin.Container.Position = UDim2.new(0, 10, 0, 40)
        KeyWin.Container.Size = UDim2.new(1, -20, 1, -50)
        
        local InputBox = Create("TextBox", {
            Parent = KeyWin.Container,
            BackgroundColor3 = IsoneUI.Theme.Secondary,
            Size = UDim2.new(1, 0, 0, 35),
            Position = UDim2.new(0, 0, 0.1, 0),
            Font = Enum.Font.Gotham,
            PlaceholderText = "Enter Key...",
            Text = "",
            TextColor3 = IsoneUI.Theme.Text,
            TextSize = 14
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = InputBox})
        
        local VerifyBtn = Create("TextButton", {
            Parent = KeyWin.Container,
            BackgroundColor3 = IsoneUI.Theme.Accent,
            Size = UDim2.new(1, 0, 0, 35),
            Position = UDim2.new(0, 0, 0.55, 0),
            Font = Enum.Font.GothamBold,
            Text = "VERIFY",
            TextColor3 = IsoneUI.Theme.Text,
            TextSize = 14,
            AutoButtonColor = false
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = VerifyBtn})
        
        VerifyBtn.MouseButton1Click:Connect(function()
            if InputBox.Text == CorrectKey then
                VerifyBtn.Text = "SUCCESS"
                VerifyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                task.wait(0.6)
                KeyWin.Screen:Destroy()
                if Callback then Callback() end
            else
                VerifyBtn.Text = "WRONG KEY"
                VerifyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                task.wait(1)
                VerifyBtn.Text = "VERIFY"
                VerifyBtn.BackgroundColor3 = IsoneUI.Theme.Accent
            end
        end)
    end
}

-- PARTE 5 --

IsoneUI.Tabs = {
    CurrentTab = nil,
    CurrentBtn = nil,
    CreateTab = function(self, Window, Name, IconName)
        local TabHolder = Window.Sidebar:FindFirstChild("TabHolder") or Create("ScrollingFrame", {Name = "TabHolder", Parent = Window.Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -10), Position = UDim2.new(0, 0, 0, 5), ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y})
        if not TabHolder:FindFirstChild("UIListLayout") then 
            Create("UIListLayout", {Parent = TabHolder, Padding = UDim.new(0, 5), HorizontalAlignment = "Center", SortOrder = Enum.SortOrder.LayoutOrder})
Create("UIPadding", {Parent = TabHolder, PaddingTop = UDim.new(0, 5)})
end

local IconData = IsoneUI.Icons[IconName] or "0"
local IconID = string.find(tostring(IconData), "rbxassetid://") and IconData or "rbxassetid://"..tostring(IconData)
        
        local TabBtn = Create("TextButton", {Name = Name.."_Tab", Parent = TabHolder, BackgroundColor3 = IsoneUI.Theme.Main, BackgroundTransparency = 0, Size = UDim2.new(0.9, 0, 0, 32), Font = "GothamMedium", Text = "", TextColor3 = IsoneUI.Theme.Placeholder, TextSize = 13, AutoButtonColor = false, ZIndex = 10})
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TabBtn})

        local Icon = Create("ImageLabel", {
        Name = "Icon",
        Parent = TabBtn,
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 7, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Image = IconID,
        ZIndex = 11,
        ImageColor3 = IsoneUI.Theme.Text
    })

        local Label = Create("TextLabel", {
        Parent = TabBtn,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        BackgroundTransparency = 1,
        Text = Name,
        Font = "GothamMedium",
        TextColor3 = IsoneUI.Theme.Text,
        TextSize = 12,
        ZIndex = 11,
        TextXAlignment = "Left"
    })
        
        local TabPage = Create("ScrollingFrame", {Name = Name.."_Page", Parent = Window.Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y})
        Create("UIListLayout", {Parent = TabPage, Padding = UDim.new(0, 7), HorizontalAlignment = "Center", SortOrder = Enum.SortOrder.LayoutOrder})
        Create("UIPadding", {Parent = TabPage, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
        
        TabBtn.MouseButton1Click:Connect(function()
            if IsoneUI.Tabs.CurrentTab == TabPage then return end
            if IsoneUI.Tabs.CurrentTab then
                IsoneUI.Tabs.CurrentTab.Visible = false
                IsoneUI:Tween(IsoneUI.Tabs.CurrentBtn, 0.3, {TextColor3 = IsoneUI.Theme.Placeholder, BackgroundColor3 = IsoneUI.Theme.Main})
            end
            IsoneUI.Tabs.CurrentTab, IsoneUI.Tabs.CurrentBtn, TabPage.Visible = TabPage, TabBtn, true
            IsoneUI:Tween(TabBtn, 0.3, {TextColor3 = IsoneUI.Theme.Text, BackgroundColor3 = IsoneUI.Theme.Accent})
        end)
        
        if IsoneUI.Tabs.CurrentTab == nil then 
            IsoneUI.Tabs.CurrentTab, IsoneUI.Tabs.CurrentBtn, TabPage.Visible, TabBtn.TextColor3 = TabPage, TabBtn, true, IsoneUI.Theme.Text
            TabBtn.BackgroundColor3 = IsoneUI.Theme.Accent
        end
        return TabPage
    end
}

-- PARTE 6 --

IsoneUI.Elements = {
    CreateButton = function(self, Tab, Name, Callback)
        local Callback = Callback or function() end
        local ButtonFrame = Create("TextButton", {
            Name = Name .. "_Btn",
            Parent = Tab,
            BackgroundColor3 = IsoneUI.Theme.Secondary,
            BackgroundTransparency = 0,
            Size = UDim2.new(0.95, 0, 0, 38),
            AutoButtonColor = false,
            Font = Enum.Font.GothamMedium,
            Text = "",
            ClipsDescendants = true
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = ButtonFrame})
        
        local Text = Create("TextLabel", {
            Parent = ButtonFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -24, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = Name,
            TextColor3 = IsoneUI.Theme.Text,
            TextSize = 13,
            TextXAlignment = "Left"
        })
        
        local Icon = Create("ImageLabel", {
            Parent = ButtonFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -28, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            Image = "rbxassetid://93705744092948",
            ImageColor3 = IsoneUI.Theme.Placeholder
        })
        
        ButtonFrame.MouseButton1Down:Connect(function()
            IsoneUI:Tween(ButtonFrame, 0.1, {BackgroundColor3 = IsoneUI.Theme.Accent, BackgroundTransparency = 0})
        end)
        
        local function ResetButton()
            IsoneUI:Tween(ButtonFrame, 0.2, {BackgroundColor3 = IsoneUI.Theme.Secondary, BackgroundTransparency = 0})
        end
        
        ButtonFrame.MouseButton1Up:Connect(function()
            ResetButton()
            task.spawn(pcall, Callback)
        end)
        
        ButtonFrame.MouseLeave:Connect(ResetButton)
        
        return ButtonFrame
    end
}

IsoneUI.Elements.CreateToggle = function(self, Tab, Name, Default, Callback)
    local Callback = Callback or function() end
    local Toggled = Default or false
    
    local ToggleFrame = Create("TextButton", {
        Name = Name .. "_Toggle",
        Parent = Tab,
        BackgroundColor3 = IsoneUI.Theme.Secondary,
        BackgroundTransparency = 0,
        Size = UDim2.new(0.95, 0, 0, 38),
        AutoButtonColor = false,
        Font = Enum.Font.GothamMedium,
        Text = "",
        ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = ToggleFrame})

    local Text = Create("TextLabel", {
        Parent = ToggleFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = Name,
        TextColor3 = IsoneUI.Theme.Text,
        TextSize = 13,
        TextXAlignment = "Left"
    })

    local SwitchBg = Create("Frame", {
        Parent = ToggleFrame,
        BackgroundColor3 = Toggled and IsoneUI.Theme.Accent or Color3.fromRGB(40, 40, 45),
        Position = UDim2.new(1, -50, 0.5, -10),
        Size = UDim2.new(0, 38, 0, 20)
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SwitchBg})

    local Slider = Create("Frame", {
        Parent = SwitchBg,
        BackgroundColor3 = IsoneUI.Theme.Text,
        Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16)
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Slider})

    ToggleFrame.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        
        if Toggled then
            IsoneUI:Tween(SwitchBg, 0.2, {BackgroundColor3 = IsoneUI.Theme.Accent})
            IsoneUI:Tween(Slider, 0.2, {Position = UDim2.new(1, -18, 0.5, -8)})
        else
            IsoneUI:Tween(SwitchBg, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)})
            IsoneUI:Tween(Slider, 0.2, {Position = UDim2.new(0, 2, 0.5, -8)})
        end
        
        task.spawn(pcall, Callback, Toggled)
    end)

    return ToggleFrame
end

IsoneUI.Elements.CreateSlider = function(self, Tab, Name, Min, Max, Default, Callback)
    local Callback = Callback or function() end
    local Value = Default or Min
    local Dragging = false

    local SliderFrame = Create("Frame", {
        Name = Name .. "_Slider",
        Parent = Tab,
        BackgroundColor3 = IsoneUI.Theme.Secondary,
        BackgroundTransparency = 0,
        Size = UDim2.new(0.95, 0, 0, 45),
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = SliderFrame})

    local Text = Create("TextLabel", {
        Parent = SliderFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 5),
        Size = UDim2.new(1, -24, 0, 20),
        Font = "GothamMedium",
        Text = Name,
        TextColor3 = IsoneUI.Theme.Text,
        TextSize = 13,
        TextXAlignment = "Left"
    })

    local ValueLabel = Create("TextLabel", {
        Parent = SliderFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -50, 0, 5),
        Size = UDim2.new(0, 40, 0, 20),
        Font = "GothamBold",
        Text = tostring(Value),
        TextColor3 = IsoneUI.Theme.Accent,
        TextSize = 13,
        TextXAlignment = "Right"
    })

    local SlideBar = Create("Frame", {
        Parent = SliderFrame,
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        Position = UDim2.new(0, 12, 1, -12),
        Size = UDim2.new(1, -24, 0, 4)
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SlideBar})

    local Fill = Create("Frame", {
        Parent = SlideBar,
        BackgroundColor3 = IsoneUI.Theme.Accent,
        Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})

    local function UpdateSlider(input)
        local Size = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
        Value = math.floor(Min + (Max - Min) * Size)
        ValueLabel.Text = tostring(Value)
        IsoneUI:Tween(Fill, 0.1, {Size = UDim2.new(Size, 0, 1, 0)})
        task.spawn(pcall, Callback, Value)
    end

    SlideBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            UpdateSlider(input)
        end
    end)

    IsoneUI.Services.UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    IsoneUI.Services.UIS.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)

    return SliderFrame
end

function IsoneUI:AddTextTitle(ParentPage, Text)
    local TextTitle = Create("TextLabel", {
        Name = Text .. "_Title",
        Parent = ParentPage,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = Text:upper(),
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    Create("UIPadding", {
        Parent = TextTitle,
        PaddingLeft = UDim.new(0, 10)
    })

    return TextTitle
end

IsoneUI.Elements.CreateDropdown = function(self, Tab, Name, Options, Callback)
    local Callback = Callback or function() end
    local Dropped = false
    local Selected = Options[1] or "None"
    
    local DropdownFrame = Create("Frame", {
        Name = Name .. "_Dropdown",
        Parent = Tab,
        BackgroundColor3 = IsoneUI.Theme.Secondary,
        BackgroundTransparency = 0,
        Size = UDim2.new(0.95, 0, 0, 38),
        ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = DropdownFrame})

    local DropBtn = Create("TextButton", {
        Parent = DropdownFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 38),
        Font = "GothamMedium",
        Text = "",
        AutoButtonColor = false
    })

    local Title = Create("TextLabel", {
        Parent = DropBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = "GothamMedium",
        Text = Name .. ": " .. Selected,
        TextColor3 = IsoneUI.Theme.Text,
        TextSize = 13,
        TextXAlignment = "Left"
    })

    local Arrow = Create("ImageLabel", {
        Parent = DropBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -28, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = "rbxassetid://95772441625675",
        ImageColor3 = IsoneUI.Theme.Placeholder,
        Rotation = 0
    })

    local OptionHolder = Create("Frame", {
        Parent = DropdownFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 38),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    local Layout = Create("UIListLayout", {
        Parent = OptionHolder,
        Padding = UDim.new(0, 4),
        HorizontalAlignment = "Center"
    })

    DropBtn.MouseButton1Click:Connect(function()
        Dropped = not Dropped
        local TargetSize = Dropped and UDim2.new(0.95, 0, 0, Layout.AbsoluteContentSize.Y + 45) or UDim2.new(0.95, 0, 0, 38)
        local TargetRotation = Dropped and 180 or 0
        
        IsoneUI:Tween(DropdownFrame, 0.3, {Size = TargetSize})
        IsoneUI:Tween(Arrow, 0.3, {Rotation = TargetRotation})
    end)

    for _, opt in pairs(Options) do
        local OptBtn = Create("TextButton", {
            Parent = OptionHolder,
            BackgroundColor3 = IsoneUI.Theme.Main,
            BackgroundTransparency = 0.7,
            Size = UDim2.new(0.92, 0, 0, 28),
            Font = "Gotham",
            Text = opt,
            TextColor3 = IsoneUI.Theme.Placeholder,
            TextSize = 12,
            AutoButtonColor = false
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = OptBtn})
        Create("UIStroke", {Color = IsoneUI.Theme.Accent, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = OptBtn})

        OptBtn.MouseButton1Click:Connect(function()
            local currentOpt = opt -- Capturamos el valor exacto de esta vuelta del bucle
            Selected = currentOpt
            Title.Text = Name .. ": " .. Selected
            Dropped = false
            
            IsoneUI:Tween(DropdownFrame, 0.3, {Size = UDim2.new(0.95, 0, 0, 38)})
            IsoneUI:Tween(Arrow, 0.3, {Rotation = 0})

            task.spawn(function()
                Callback(currentOpt)
            end)
        end)

        OptBtn.MouseEnter:Connect(function() IsoneUI:Tween(OptBtn, 0.2, {TextColor3 = IsoneUI.Theme.Text}) end)
        OptBtn.MouseLeave:Connect(function() IsoneUI:Tween(OptBtn, 0.2, {TextColor3 = IsoneUI.Theme.Placeholder}) end)
    end

    return DropdownFrame
end

IsoneUI.Elements.CreateInput = function(self, Tab, Name, Placeholder, Callback)
    local Callback = Callback or function() end
    
    local InputFrame = Create("Frame", {
        Name = Name .. "_Input",
        Parent = Tab,
        BackgroundColor3 = IsoneUI.Theme.Secondary,
        BackgroundTransparency = 0,
        Size = UDim2.new(0.95, 0, 0, 38)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = InputFrame})

    local Text = Create("TextLabel", {
        Parent = InputFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0.4, 0, 1, 0),
        Font = "GothamMedium",
        Text = Name,
        TextColor3 = IsoneUI.Theme.Text,
        TextSize = 13,
        TextXAlignment = "Left"
    })

    local Box = Create("TextBox", {
        Parent = InputFrame,
        BackgroundColor3 = IsoneUI.Theme.Main,
        Position = UDim2.new(1, -135, 0.5, -11),
        Size = UDim2.new(0, 125, 0, 22),
        Font = "Gotham",
        PlaceholderText = Placeholder or "Type here...",
        Text = "",
        TextColor3 = IsoneUI.Theme.Text,
        PlaceholderColor3 = IsoneUI.Theme.Placeholder,
        TextSize = 12,
        ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Box})
    Create("UIStroke", {Color = IsoneUI.Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = Box})

    Box.Focused:Connect(function()
        IsoneUI:Tween(BoxStroke, 0.3, {Color = IsoneUI.Theme.Accent})
        IsoneUI:Tween(Stroke, 0.3, {Color = IsoneUI.Theme.Accent})
    end)

    Box.FocusLost:Connect(function(enterPressed)
        IsoneUI:Tween(BoxStroke, 0.3, {Color = IsoneUI.Theme.Stroke})
        IsoneUI:Tween(Stroke, 0.3, {Color = IsoneUI.Theme.Stroke})
        task.spawn(pcall, Callback, Box.Text)
    end)

    return InputFrame
end

IsoneUI.Elements.CreateColorPicker = function(self, Tab, Name, Default, Callback)
    local Callback = Callback or function() end
    local ColorValue = Default or Color3.fromRGB(120, 130, 255)
    local Dropped = false
    local Picking = false

    local PickerFrame = Create("Frame", {
        Name = Name .. "_Picker",
        Parent = Tab,
        BackgroundColor3 = IsoneUI.Theme.Secondary,
        BackgroundTransparency = 0,
        Size = UDim2.new(0.95, 0, 0, 38),
        ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = PickerFrame})

    local MainBtn = Create("TextButton", {
        Parent = PickerFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 38),
        Text = ""
    })

    local Title = Create("TextLabel", {
        Parent = MainBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = "GothamMedium",
        Text = Name,
        TextColor3 = IsoneUI.Theme.Text,
        TextSize = 13,
        TextXAlignment = "Left"
    })

    local ColorPreview = Create("Frame", {
        Parent = MainBtn,
        BackgroundColor3 = ColorValue,
        Position = UDim2.new(1, -45, 0.5, -10),
        Size = UDim2.new(0, 32, 0, 20)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = ColorPreview})

    local PickerContent = Create("Frame", {
        Parent = PickerFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 38),
        Size = UDim2.new(1, 0, 0, 60)
    })

    local HueRailing = Create("ImageButton", {
        Parent = PickerContent,
        Position = UDim2.new(0.05, 0, 0, 15),
        Size = UDim2.new(0.9, 0, 0, 20),
        Image = "rbxassetid://2320468349",
        AutoButtonColor = false
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = HueRailing})

    local Selector = Create("Frame", {
        Parent = HueRailing,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 4, 1, 4),
        Position = UDim2.new(0.5, -2, 0, -2)
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Selector})

    MainBtn.MouseButton1Click:Connect(function()
        Dropped = not Dropped
        IsoneUI:Tween(PickerFrame, 0.3, {Size = Dropped and UDim2.new(0.95, 0, 0, 110) or UDim2.new(0.95, 0, 0, 38)})
    end)

    local function UpdateColor(input)
        local Percentage = math.clamp((input.Position.X - HueRailing.AbsolutePosition.X) / HueRailing.AbsoluteSize.X, 0, 1)
        IsoneUI:Tween(Selector, 0.1, {Position = UDim2.new(Percentage, -2, 0, -2)})
        ColorValue = Color3.fromHSV(Percentage, 1, 1)
        ColorPreview.BackgroundColor3 = ColorValue
        task.spawn(pcall, Callback, ColorValue)
    end

    HueRailing.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Picking = true
            UpdateColor(input)
        end
    end)

    IsoneUI.Services.UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Picking = false
        end
    end)

    IsoneUI.Services.UIS.InputChanged:Connect(function(input)
        if Picking and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateColor(input)
        end
    end)

    return PickerFrame
end

print("UI LOADED SUCCESSFULLY")

return IsoneUI
