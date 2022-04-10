local Games = {
    PhantomForces = {292439477},
    Criminality = {8343259840},
    RogueLineage = {3016661674,5208655184},
}


local Vars = {
    -- rogue settings
    TrinketEsp = false,
    TrinketEspMaxDistance = 5000,
    TrinketEspShowDistance = false,
    TrinketEspAutopickup = false,
    -- phantom settings
    PhantomNoRecoil = false,
    PhantomNoSpread = false,
    PhantomAllFiremodes = false,

    --crim settings
    CrimSilentAim = false,
    CrimSilentAimFov = false,
    CrimSilentAimKeybind = "x",
    CrimSilentAimRadius = 150,
    CrimSilentAimHeadshot = 20,

    -- normal settings
    GeneralChams = false,
    GeneralChamsEnemyOnly = false,
    GeneralChamsTransparencyValue = 0,
    GeneralChamsMaxDistanceValue = 5000,

    GeneralAmbienceValue = false,
    GeneralOutdoorAmbienceValue = false,
}

local Colors = {
    CrimSilentAimFovColor = Color3.fromRGB(255,255,255),

    GeneralChamsColor = Color3.fromRGB(255,255,255),
    GeneralAmbienceColor = Color3.fromRGB(255,255,255),
    GeneralOutdoorAmbienceColor = Color3.fromRGB(255,255,255),

    RogueTrinketColor = Color3.fromRGB(255,255,255),

    UIColor = Color3.fromRGB(255,255,255),
}


function CurrentSettings()
    local Settings = "{"
    local IndexValue = 0

    for i,v in pairs(Vars) do
        IndexValue += 1
        if IndexValue ~= 1 then
            Settings = Settings..","
        end
        Settings = Settings..'"'..tostring(i)..'":'
        if type(v) ~= "string" then
            Settings = Settings..tostring(v)
        else
            Settings = Settings..'"'..tostring(v)..'"'
        end
    end

    for i,v in pairs(Colors) do
        IndexValue += 1
        local Colors = tostring(v):split(",")
        if #Colors == 3 then
            if IndexValue ~= 1 then
                Settings = Settings..","
            end
            Settings = Settings..'"'..tostring(i)..'":'

            Settings = Settings..'{"R":'..tostring(Colors[1])
            Settings = Settings..',"G":'..tostring(Colors[2])
            Settings = Settings..',"B":'..tostring(Colors[3])
            Settings = Settings..'}'
        end
    end

    return Settings.."}"
end

if not isfolder("skid hubs configs") then
    makefolder("skid hubs configs")
end

local LoadVars = {}
local LoadColors = {}

function gameIs(Game)
    if not type(Game) == "table" then return false end
    for i2,v2 in pairs(Game) do
        if v2 == game.placeId then
            return true
        end
    end
    return false
end

function isInTable(Table,Value)
    for i,v in pairs(Table) do
        if v == Value then
            return true
        end
    end
    return false
end

function randomString()
    local rand = ""
    local char = ("qwertyuioplkjhgfdsazxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNM1234567890"):split("")
    for i=1,20 do
        rand = rand..char[math.random(1,#char)]
    end
    return rand
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Http = game:GetService("HttpService")

local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/imnoskid/randomstuff/main/jan_ui_backup.lua"))()

UI.theme.accentcolor = Colors.UIColor
UI.theme.accentcolor2 = Colors.UIColor

local Window = UI:CreateWindow("skid hub", Vector3.new(492, 598), Enum.KeyCode.LeftAlt)

local Visuals = Window:CreateTab("Visuals")
local Chams = Visuals:CreateSector("Chams","Left")

local GeneralChamsToggle = Chams:AddToggle("Enabled",Vars.GeneralChams,function(Enabled)
    if Enabled then
        Vars.GeneralChams = true
    else
        Vars.GeneralChams = false
    end
end)

local GeneralChamsEnemiesOnly = Chams:AddToggle("Enemies Only",Vars.GeneralChamsEnemyOnly,function(Enabled)
    if Enabled then
        Vars.GeneralChamsEnemyOnly = true
    else
        Vars.GeneralChamsEnemyOnly = false
    end
end)

table.insert(LoadVars,{GeneralChamsEnemyOnly = GeneralChamsEnemiesOnly})

table.insert(LoadVars,{GeneralChams = GeneralChamsToggle})

local ChamsRGBColor
ChamsRGBColor = GeneralChamsToggle:AddColorpicker(Colors.GeneralChamsColor,function()
    Colors.GeneralChamsColor = ChamsRGBColor:Get()
end)

table.insert(LoadColors,{GeneralChamsColor = ChamsRGBColor})

local GeneralChamsTransparency
GeneralChamsTransparency = Chams:AddSlider("Transparency",0,Vars.GeneralChamsTransparencyValue,1,20,function()
    Vars.GeneralChamsTransparencyValue = GeneralChamsTransparency:Get(value)
end)

local GeneralChamsMaxDistance
GeneralChamsMaxDistance = Chams:AddSlider("Max Distance",0,Vars.GeneralChamsMaxDistanceValue,30000,1,function()
    Vars.GeneralChamsMaxDistanceValue = GeneralChamsMaxDistance:Get(value)
end)

table.insert(LoadVars,{GeneralChamsMaxDistanceValue = GeneralChamsMaxDistance})

table.insert(LoadVars,{GeneralChamsTransparencyValue = GeneralChamsTransparency})

local BoxHandles = {}
local ChamParts = {"LeftHand","LeftLowerArm","LeftUpperArm","RightHand","RightLowerArm","RightUpperArm","UpperTorso","LeftFoot","LeftLowerLeg","LeftUpperLeg","RightFoot","RightLowerLeg","RightUpperLeg","LowerTorso","Head","Left Leg","Right Leg","Left Arm","Right Arm","Torso"}

if gameIs(Games.Criminality) then
    local Combat = Window:CreateTab("Combat")
    local SilentAimSector = Combat:CreateSector("Silent Aim","Left")
    local CrimSilentAimToggle = SilentAimSector:AddToggle("Enable",Vars.CrimSilentAim,function(Enabled)
        if Enabled then
            Vars.CrimSilentAim = true
        else
            Vars.CrimSilentAim = false
        end
    end)

    local CrimSilentAimKey
    CrimSilentAimKey = CrimSilentAimToggle:AddKeybind("x",function()
        Vars.CrimSilentAimKeybind = CrimSilentAimKey:Get()
    end)

    local CrimSilentAimRadiusSlider
    CrimSilentAimRadiusSlider = CrimSilentAimToggle:AddSlider(50,Vars.CrimSilentAimRadius,750,1,function()
        Vars.CrimSilentAimRadius = CrimSilentAimRadiusSlider:Get(value)
    end)

    local CrimSilentAimFovToggle = SilentAimSector:AddToggle("Show Fov",Vars.CrimSilentAimFov,function(Enabled)
        if Enabled then
            Vars.CrimSilentAimFov = true
        else
            Vars.CrimSilentAimFov = false
        end
    end)

    local CrimSilentAimFovColorpicker
    CrimSilentAimFovColorpicker = CrimSilentAimFovToggle:AddColorpicker(Vars.CrimSilentAimFovColor,function()
        Colors.CrimSilentAimFovColor = CrimSilentAimFovColorpicker:Get(value)
    end)

    local CrimSilentAimHeadshotSlider
    CrimSilentAimHeadshotSlider = SilentAimSector:AddSlider("Headshot Chance",0,Vars.CrimSilentAimHeadshot,100,1,function()
        Vars.CrimSilentAimHeadshot = CrimSilentAimHeadshotSlider:Get(value)
    end)

    table.insert(LoadVars,{CrimSilentAimHeadshot = CrimSilentAimHeadshotSlider})

    table.insert(LoadVars,{CrimSilentAimFov = CrimSilentAimFovToggle})

    table.insert(LoadVars,{CrimSilentAimRadius = CrimSilentAimRadiusSlider})

    table.insert(LoadVars,{CrimSilentAim = CrimSilentAimToggle})

    table.insert(LoadVars,{CrimSilentAimKeybind = CrimSilentAimKey})

    table.insert(LoadColors,{CrimSilentAimFovColor = CrimSilentAimFovColorpicker})

    local FovCircle = Drawing.new("Circle")
    FovCircle.Visible = false
    FovCircle.Radius = 0
    FovCircle.Thickness = 1
    FovCircle.Color = Colors.CrimSilentAimFovColor
    FovCircle.Transparency = 0.5
    FovCircle.NumSides = 50

    function ClosestToMouse(Distance)
        local TargetPart = nil
        local TargetDistance = Distance
        local TargetFound = false

        local AimPart = "Torso"

        if Vars.CrimSilentAimHeadshot >= math.random(1,100) then
            AimPart = "Head"
        end
    
        for i,v in pairs(Players:GetPlayers()) do
            if v.Character and v ~= Player then
                if v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Torso") then
                    local WorldHeadPosition,HeadVisible = workspace.CurrentCamera:WorldToScreenPoint(v.Character["Torso"].Position)
                    if HeadVisible then
                        local DistanceFromMouse = (Vector2.new(WorldHeadPosition.X,WorldHeadPosition.Y) - Vector2.new(Mouse.X,Mouse.Y + 37)).Magnitude
                        if DistanceFromMouse < TargetDistance then
                            TargetFound = true
                            TargetDistance = DistanceFromMouse
                            TargetPart = v.Character[AimPart]
                        end
                    end
                end
            end
        end
        return {TargetFound,TargetPart}
    end
    
    local PlayerTarget
    game:GetService("RunService").Stepped:Connect(function()
        PlayerTarget = ClosestToMouse(Vars.CrimSilentAimRadius)
        FovCircle.Visible = Vars.CrimSilentAimFov and Vars.CrimSilentAim
        FovCircle.Radius = Vars.CrimSilentAimRadius
        FovCircle.Position = Vector2.new(Mouse.X,Mouse.Y+37)
        FovCircle.Color = Colors.CrimSilentAimFovColor
    end)
    
    local mt = getrawmetatable(game)
    setreadonly(mt,false)
    local old = mt.__namecall
    
    mt.__namecall = function(...)
        local args = {...}
        local method = getnamecallmethod()
    
        if method == "FindPartOnRayWithWhitelist" and #args >= 3 then  
            if PlayerTarget[1] and Vars.CrimSilentAim then
                local Origin = args[2].Origin
                local Direction = (PlayerTarget[2].Position - Origin).Unit * 1000
                args[2] = Ray.new(Origin,Direction)
            end
        end
    
        return old(unpack(args))
    end
    
    setreadonly(mt,true)
end

if gameIs(Games.PhantomForces) then
    function PlayerTeam()
        if Player:FindFirstChild("PlayerGui") then
            if Player.PlayerGui:FindFirstChild("Leaderboard") then
                if Player.PlayerGui.Leaderboard:FindFirstChild("Main") then
                    for i,v in pairs(Player.PlayerGui.Leaderboard.Main:GetDescendants()) do
                        if v:IsA("Frame") and v.Name == Player.Name and v.Parent.Name == "Data" then
                            if v.Parent.Parent.Parent.Name == "Ghosts" or v.Parent.Parent.Parent.Name == "Phantoms" then
                                return v.Parent.Parent.Parent.Name
                            end
                        end
                    end
                end
            end
        end
    end

    function EnemyTeam()
        local MyTeam = "None"
        if Player:FindFirstChild("PlayerGui") then
            if Player.PlayerGui:FindFirstChild("Leaderboard") then
                if Player.PlayerGui.Leaderboard:FindFirstChild("Main") then
                    for i,v in pairs(Player.PlayerGui.Leaderboard.Main:GetDescendants()) do
                        if v:IsA("Frame") and v.Name == Player.Name and v.Parent.Name == "Data" then
                            if v.Parent.Parent.Parent.Name == "Ghosts" or v.Parent.Parent.Parent.Name == "Phantoms" then
                                MyTeam = v.Parent.Parent.Parent.Name
                            end
                        end
                    end
                end
            end
        end
        if MyTeam == "Ghosts" then
            return "Phantoms"
        elseif MyTeam == "Phantoms" then
            return "Ghosts"
        else
            return "None"
        end
    end

    task.spawn(function()
        while task.wait(0.05) do
            for i,v in pairs(BoxHandles) do
                v:Destroy()
            end
    
            BoxHandles = {}

            local PlayerTable = {}

            if workspace:FindFirstChild("Players") then
                if workspace.Players:FindFirstChild("Bright blue") then
                    for i,v in pairs(workspace.Players["Bright blue"]:GetChildren()) do
                        table.insert(PlayerTable,v)
                    end
                end

                if workspace.Players:FindFirstChild("Bright orange") then
                    for i,v in pairs(workspace.Players["Bright orange"]:GetChildren()) do
                        table.insert(PlayerTable,v)
                    end
                end
            end

            if Vars.GeneralChamsEnemyOnly then
                local Enemies = EnemyTeam()
                if Enemies ~= "None" then
                    if Enemies == "Ghosts" then
                        PlayerTable = {}
                        if workspace.Players:FindFirstChild("Bright orange") then
                            for i,v in pairs(workspace.Players["Bright orange"]:GetChildren()) do
                                table.insert(PlayerTable,v)
                            end
                        end
                    elseif Enemies == "Phantoms" then
                        PlayerTable = {}
                        if workspace.Players:FindFirstChild("Bright blue") then
                            for i,v in pairs(workspace.Players["Bright blue"]:GetChildren()) do
                                table.insert(PlayerTable,v)
                            end
                        end
                    end
                end
            end
    
            for i,v in pairs(PlayerTable) do
                if Vars.GeneralChams then
                    for i2,v2 in pairs(v:GetChildren()) do
                        for i3,v3 in pairs(ChamParts) do
                            if v2:IsA("MeshPart") and v3 == v2.Name or v2:IsA("Part") and v3 == v2.Name then
                                if (workspace.CurrentCamera.CFrame.p - v2.Position).Magnitude < Vars.GeneralChamsMaxDistanceValue then
                                    local BoxHandle = Instance.new("BoxHandleAdornment")
                                    table.insert(BoxHandles,BoxHandle)
                                    BoxHandle.Name = randomString()
                                    BoxHandle.Parent = game.CoreGui
                                    BoxHandle.Adornee = v2
                                    BoxHandle.Size = v2.Size + Vector3.new(0.1,0.1,0.1)
                                    BoxHandle.AlwaysOnTop = true
                                    BoxHandle.Visible = true
                                    BoxHandle.Transparency = Vars.GeneralChamsTransparencyValue
                                    BoxHandle.ZIndex = 10
                                    BoxHandle.Color = BrickColor.new(Colors.GeneralChamsColor)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
else
    task.spawn(function()
        while task.wait(0.05) do
            for i,v in pairs(BoxHandles) do
                v:Destroy()
            end

            BoxHandles = {}

            for i,v in pairs(Players:GetPlayers()) do
                if Vars.GeneralChams and v ~= Player and v.Character then
                    if v.Character:FindFirstChild("Humanoid") then
                        if v.Character.Humanoid.Health > 0 then
                            for i2,v2 in pairs(v.Character:GetChildren()) do
                                for i3,v3 in pairs(ChamParts) do
                                    if v2:IsA("MeshPart") and v3 == v2.Name or v2:IsA("Part") and v3 == v2.Name then
                                        if (workspace.CurrentCamera.CFrame.p - v2.Position).Magnitude < Vars.GeneralChamsMaxDistanceValue then
                                            local BoxHandle = Instance.new("BoxHandleAdornment")
                                            table.insert(BoxHandles,BoxHandle)
                                            BoxHandle.Name = randomString()
                                            BoxHandle.Parent = game.CoreGui
                                            BoxHandle.Adornee = v2
                                            BoxHandle.Size = v2.Size + Vector3.new(0.1,0.1,0.1)
                                            BoxHandle.AlwaysOnTop = true
                                            BoxHandle.Visible = false
                                            BoxHandle.Transparency = Vars.GeneralChamsTransparencyValue
                                            BoxHandle.ZIndex = 10
                                            BoxHandle.Color = BrickColor.new(Colors.GeneralChamsColor)
                                        
                                            if Vars.GeneralChamsEnemyOnly then
                                                if v.Team ~= Player.Team then
                                                    BoxHandle.Visible = true
                                                else
                                                    BoxHandle.Visible = false
                                                end
                                            else
                                                BoxHandle.Visible = true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

if gameIs(Games.RogueLineage) then
    function addTrinketEsp(v)
        local TrinketTag = Drawing.new("Text")
        TrinketTag.Visible = false
        TrinketTag.Center = true
        TrinketTag.Text = "Trinket"
        TrinketTag.Size = 20
        TrinketTag.Font = 0
        TrinketTag.Outline = true
    
        local TrinketCheck
        TrinketCheck = game:GetService("RunService").Stepped:Connect(function()
            if v:FindFirstChild("Part") then
                local TrinketPosition,TrinketVisible = workspace.CurrentCamera:WorldToViewportPoint(v.Part.Position)
                if TrinketVisible and Vars.TrinketEsp and (workspace.CurrentCamera.CFrame.p - v.Part.Position).Magnitude <= Vars.TrinketEspMaxDistance then
                    TrinketTag.Visible = true
                    TrinketTag.Color = Colors.RogueTrinketColor
                    TrinketTag.Position = Vector2.new(TrinketPosition.X,TrinketPosition.Y)

                    if Vars.TrinketEspShowDistance then
                        TrinketTag.Text = "Trinket ["..math.floor((workspace.CurrentCamera.CFrame.p - v.Part.Position).Magnitude).."]"
                    else
                        TrinketTag.Text = "Trinket"
                    end
                else
                    TrinketTag.Visible = false
                end
            end
        end)
        
        local TrinketCheck2
        TrinketCheck2 = workspace.ChildRemoved:Connect(function(v2)
            if v2 == v then
                TrinketTag:Remove()
                TrinketCheck:Disconnect()
                TrinketCheck2:Disconnect()
            end
        end)
    end
    
    for i,v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Part") then
            if v.Part:FindFirstChild("ClickDetector") then
                addTrinketEsp(v)
            end
        end
    end
    
    workspace.ChildAdded:Connect(function(v)
        wait()
        if v:FindFirstChild("Part") then
            if v.Part:FindFirstChild("ClickDetector") then
                addTrinketEsp(v)
            end
        end
    end)

    local TrinketEspSector = Visuals:CreateSector("Trinket Esp","Right")
    local TrinketEspToggle = TrinketEspSector:AddToggle("Enabled",Vars.TrinketEsp,function(Enabled)
        if Enabled then
            Vars.TrinketEsp = true
        else
            Vars.TrinketEsp = false
        end
    end)

    local TrinketEspAutopickupToggle = TrinketEspSector:AddToggle("Autopickup",Vars.TrinketEspAutopickup,function(Enabled)
        if Enabled then
            Vars.TrinketEspAutopickup = true
        else
            Vars.TrinketEspAutopickup = false
        end
    end)

    task.spawn(function()
        while true do wait()
            if Vars.TrinketEspAutopickup then
                for i,v in pairs(workspace:GetChildren()) do
                    if v:FindFirstChild("Part") and Player.Character then
                        if v.Part:FindFirstChild("ClickDetector") and Player.Character:FindFirstChild("HumanoidRootPart") then
                            if (Player.Character.HumanoidRootPart.Position - v.Part.Position).Magnitude < v.Part.ClickDetector.MaxActivationDistance then
                                fireclickdetector(v.Part.ClickDetector)
                            end
                        end
                    end
                end
            end
        end
    end)

    local TrinketEspDistanceToggle = TrinketEspSector:AddToggle("Show Distance",Vars.TrinketEspShowDistance,function(Enabled)
        if Enabled then
            Vars.TrinketEspShowDistance = true
        else
            Vars.TrinketEspShowDistance = false
        end
    end)

    table.insert(LoadVars,{TrinketEspShowDistance = TrinketEspDistanceToggle})

    local TrinketEspColor
    TrinketEspColor = TrinketEspToggle:AddColorpicker(Colors.RogueTrinketColor,function()
        Colors.RogueTrinketColor = TrinketEspColor:Get()
    end)

    table.insert(LoadColors,{RogueTrinketColor = TrinketEspColor})

    local TrinketEspMaxDistanceSlider 
    TrinketEspMaxDistanceSlider = TrinketEspSector:AddSlider("Max Distance",0,Vars.TrinketEspMaxDistance,30000,1,function()
        Vars.TrinketEspMaxDistance = TrinketEspMaxDistanceSlider:Get()
    end)

    table.insert(LoadVars,{TrinketEsp = TrinketEspToggle})

    table.insert(LoadVars,{TrinketEspMaxDistance = TrinketEspMaxDistanceSlider})
end

if gameIs(Games.PhantomForces) then
    --[[function ClosestToMouse(Distance)
        local TargetPart = nil
        local TargetDistance = Distance
        local TargetFound = false

        local PlayerTable = nil

        local Enemies = EnemyTeam()
        if Enemies ~= "None" then
            if Enemies == "Ghosts" then
                PlayerTable = {}
                if workspace.Players:FindFirstChild("Bright orange") then
                    for i,v in pairs(workspace.Players["Bright orange"]:GetChildren()) do
                        table.insert(PlayerTable,v)
                    end
                end
            elseif Enemies == "Phantoms" then
                PlayerTable = {}
                if workspace.Players:FindFirstChild("Bright blue") then
                    for i,v in pairs(workspace.Players["Bright blue"]:GetChildren()) do
                        table.insert(PlayerTable,v)
                    end
                end
            end
        end

        if type(PlayerTable) == "table" then
            for i,v in pairs(PlayerTable) do
                if v:FindFirstChild("Head") then
                    local WorldHeadPosition,HeadVisible = workspace.CurrentCamera:WorldToScreenPoint(v.Head.Position)
                    if HeadVisible then
                        local DistanceFromMouse = (Vector2.new(WorldHeadPosition.X,WorldHeadPosition.Y) - Vector2.new(Mouse.X,Mouse.Y + 37)).Magnitude
                        if DistanceFromMouse < TargetDistance then
                            TargetFound = true
                            TargetDistance = DistanceFromMouse
                            TargetPart = v.Head
                        end
                    end
                end
            end
        end
        return {TargetFound,TargetPart}
    end

    local PlayerTarget
    game:GetService("RunService").Stepped:Connect(function()
        PlayerTarget = ClosestToMouse(300)
    end)

    local mt = getrawmetatable(game)
    setreadonly(mt,false)
    local old = mt.__namecall

    mt.__namecall = function(...)
        local args = {...}
        local method = getnamecallmethod()

        --if method == "FindPartOnRayWithIgnoreList" then  
            if PlayerTarget[1] then
                local Origin = args[2].Origin
                local Direction = (PlayerTarget[2].Position - Origin).Unit * 1000
                args[2] = Ray.new(Origin,Direction)
            end
        end

        return old(unpack(args))
    end

    setreadonly(mt,true)]]

    local Combat = Window:CreateTab("Combat")

    local GunMods = Combat:CreateSector("Gun Mods","Left")

    local NoRecoilToggle = GunMods:AddToggle("No Recoil",Vars.PhantomNoRecoil,function(Enabled)
        if Enabled then
            Vars.PhantomNoRecoil = true
        else
            Vars.PhantomNoRecoil = false
        end
    end)

    local NoSpreadToggle = GunMods:AddToggle("No Hipfire Spread",Vars.PhantomNoSpread,function(Enabled)
        if Enabled then
            Vars.PhantomNoSpread = true
        else
            Vars.PhantomNoSpread = false
        end
    end)

    local AllFiremodesToggle = GunMods:AddToggle("All Fire Modes",Vars.PhantomAllFiremodes,function(Enabled)
        if Enabled then
            Vars.PhantomAllFiremodes = true
        else
            Vars.PhantomAllFiremodes = false
        end
    end)

    table.insert(LoadVars,{PhantomNoSpread = NoSpreadToggle})

    table.insert(LoadVars,{PhantomNoRecoil = NoRecoilToggle})

    table.insert(LoadVars,{PhantomAllFiremodes = AllFiremodesToggle})

    for i,v in pairs(game:GetService("ReplicatedStorage").GunModules:GetChildren()) do
        local gun = require(v)

        local old_hipfirestability = gun.hipfirestability
        local old_hipfirespread = gun.hipfirespread
        local old_hipfirespreadrecover = gun.hipfirespreadrecover

        local old_firemodes = gun.firemodes

        local old_camkickmin = gun.camkickmin
        local old_camkickmax = gun.camkickmax
        local old_aimcamkickmin = gun.aimcamkickmin
        local old_aimcamkickmax = gun.aimcamkickmax
        local old_rotkickmin = gun.rotkickmin
        local old_rotkickmax = gun.rotkickmax
        local old_transkickmin = gun.transkickmin
        local old_transkickmax = gun.transkickmax
        local old_aimtranskickmin = gun.aimtranskickmin
        local old_aimtranskickmax = gun.aimtranskickmax

        task.spawn(function()
            while task.wait(1) do
                if Vars.PhantomNoSpread then
                    gun.hipfirestability = 0
                    gun.hipfirespread = 0
                    gun.hipfirespreadrecover = 0
                else
                    gun.hipfirestability = old_hipfirestability
                    gun.hipfirespread = old_hipfirespread
                    hipfirespreadrecover = old_hipfirespreadrecover
                end
            end
        end)

        task.spawn(function()
            while task.wait(1) do
                if Vars.PhantomAllFiremodes then
                    gun.firemodes = {true, 3, 1}
                else
                    gun.firemodes = old_firemodes
                end
            end
        end)

        task.spawn(function()
            while task.wait(1) do
                if Vars.PhantomNoRecoil then
                    gun.camkickmin = Vector3.new(0,0,0)
                    gun.camkickmax = Vector3.new(0,0,0)
                    gun.aimcamkickmin = Vector3.new(0,0,0)
                    gun.aimcamkickmax = Vector3.new(0,0,0)
                    gun.rotkickmin = Vector3.new(0,0,0)
                    gun.rotkickmax = Vector3.new(0,0,0)
                    gun.transkickmin = Vector3.new(0,0,0)
                    gun.transkickmax = Vector3.new(0,0,0)
                    gun.aimtranskickmin = Vector3.new(0,0,0)
                    gun.aimtranskickmax = Vector3.new(0,0,0)
                else
                    gun.camkickmin = old_camkickmin
                    gun.camkickmax = old_camkickmax
                    gun.aimcamkickmin = old_aimcamkickmin
                    gun.aimcamkickmax = old_aimcamkickmax
                    gun.rotkickmin = old_rotkickmin
                    gun.rotkickmax = old_rotkickmax
                    gun.transkickmin = old_transkickmin
                    gun.transkickmax = old_transkickmax
                    gun.aimtranskickmin = old_aimtranskickmin
                    gun.aimtranskickmax = old_aimtranskickmax
                end
            end
        end)
    end
end

--[[local Ambience = Visuals:CreateSector("Ambience","Right")

local AmbienceToggle
local OutdoorAmbienceToggle

local old_ambient = game:GetService("Lighting").Ambient
local old_outdoorambient = game:GetService("Lighting").OutdoorAmbient

local mt = getrawmetatable(game)
setreadonly(mt,false)

local old = mt.__index

mt.__index = function(v1,v2)
    if tostring(v1) == "Lighing" then
        if v2 == "Ambient" then
            return nil
        elseif v2 == "OutdoorAmbient" then
            return nil
        end
    end

    return old(v1,v2)
end

setreadonly(mt,true)

local AmbienceColor
local OutdoorAmbienceColor

AmbienceToggle = Ambience:AddToggle("Ambience",Vars.GeneralAmbienceValue,function(Enabled)
    if Enabled then
        Vars.GeneralAmbienceValue = true
    else
        Vars.GeneralAmbienceValue = false
    end
end)

OutdoorAmbienceToggle = Ambience:AddToggle("Outdoor Ambience",Vars.GeneralOutdoorAmbienceValue,function(Enabled)
    if Enabled then
        Vars.GeneralOutdoorAmbienceValue = true
    else
        Vars.GeneralOutdoorAmbienceValue = false
    end
end)

AmbienceColor = AmbienceToggle:AddColorpicker(Colors.GeneralAmbienceColor)
OutdoorAmbienceColor = OutdoorAmbienceToggle:AddColorpicker(Colors.GeneralOutdoorAmbienceColor)

table.insert(LoadVars,{GeneralAmbienceValue = AmbienceToggle})
table.insert(LoadVars,{GeneralOutdoorAmbienceValue = OutdoorAmbienceToggle})

table.insert(LoadColors,{GeneralAmbienceColor = AmbienceColor})
table.insert(LoadColors,{GeneralOutdoorAmbienceColor = OutdoorAmbienceColor})

game:GetService("RunService").Stepped:Connect(function()
    Colors.GeneralAmbienceColor = AmbienceColor:Get(value)
    Colors.GeneralOutdoorAmbienceColor = OutdoorAmbienceColor:Get(value)

    if Vars.GeneralAmbienceValue then
        game:GetService("Lighting").Ambient = Colors.GeneralAmbienceColor
    else
        game:GetService("Lighting").Ambient = old_ambient
    end

    if Vars.GeneralOutdoorAmbienceValue then
        game:GetService("Lighting").OutdoorAmbient = Colors.GeneralOutdoorAmbienceColor
    else
        game:GetService("Lighting").OutdoorAmbient = old_ambient
    end
end)]]

local Settings = Window:CreateTab("Settings")
local Create = Settings:CreateSector("Create Config","Left")
local Load = Settings:CreateSector("Load Config","Right")
local Customization = Settings:CreateSector("Customization","Left")

local UIColorpicker
UIColorpicker = Customization:AddColorpicker("UI Color",Colors.UIColor,function()
    Colors.UIColor = UIColorpicker:Get(value)
    UI.theme.accentcolor = Colors.UIColor
    UI.theme.accentcolor2 = Colors.UIColor
    Window:UpdateTheme(UI.theme)
end)

table.insert(LoadColors,{UIColor = UIColorpicker})

local CurrentConfig = Load:AddDropdown("Config",{},nil,"")

for i,v in pairs(listfiles("skid hubs configs")) do
    if #v > 23 then
        local ConfigName = string.sub(v,19,#v-5)
        CurrentConfig:Add(ConfigName)
    end
end

local CreateConfig = Create:AddTextbox("Name")
Create:AddButton("Create",function()
    local ConfigName = CreateConfig:Get()
    if #ConfigName > 0 then
        CurrentConfig:Add(tostring(ConfigName))
        --CurrentConfig:updateText(ConfigName)
        CurrentConfig:Set({ConfigName})
        writefile("skid hubs configs/"..tostring(ConfigName)..".json",CurrentSettings())
    end
end)

Load:AddButton("Save Config",function()
    writefile("skid hubs configs/"..tostring(CurrentConfig:Get())..".json",CurrentSettings())
end)

Load:AddButton("Load Config",function()
    if isfile("skid hubs configs/"..tostring(CurrentConfig:Get())..".json") then
        for i,v in pairs(Http:JSONDecode(readfile("skid hubs configs/"..tostring(CurrentConfig:Get())..".json"))) do
            for i2,v2 in pairs(LoadVars) do
                for i3,v3 in pairs(v2) do
                    if tostring(i) == tostring(i3) then
                        v3:Set(v)
                    end
                end
            end
            for i2,v2 in pairs(LoadColors) do
                for i3,v3 in pairs(v2) do
                    if tostring(i) == tostring(i3) then
                        v3:Set(Color3.fromRGB(v.R*255,v.G*255,v.B*255))
                    end
                end
            end
        end
    end
end)

Load:AddButton("Delete Config",function()
    for i,v in pairs(listfiles("skid hubs configs")) do
        if string.sub(v,19,#v-5) == tostring(CurrentConfig:Get()) then
            CurrentConfig:Remove(tostring(CurrentConfig:Get()))
            CurrentConfig:updateText("")
            delfile("skid hubs configs/"..tostring(CurrentConfig:Get())..".json")
        end
    end
end)
