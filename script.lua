--[[ ═══════════════════════════════════════════════════════════
     THE FORBIDDEN CLIENT — VERSÃO FINAL (DELTA FIX)
     ═══════════════════════════════════════════════════════════ ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

getgenv().Forbidden = getgenv().Forbidden or {}
local F = getgenv().Forbidden

F.Config = {
    F_Quest=false, F_BestFarm=false, F_War=false, F_Ryo=false,
    C_KillAura=false, C_AutoSkill=false, C_GodMode=false, C_Chakra=false, C_NoCooldown=false,
    S_Scrolls=false, S_Aizen=false, S_Emblem=false, S_AutoSpin=false, S_StopTarget=true,
    P_InfJump=false, P_AutoStats=false, P_WalkSpeed=16, P_JumpPower=50,
    M_Fly=false, M_NoClip=false, M_AntiAFK=true, M_AntiDetect=true,
    T_SpinTarget="", T_Webhook=""
}

-- ═══════════════════════════════════════════════════════════
-- 1. INTERFACE
-- ═══════════════════════════════════════════════════════════
local function BuildClient()
    local old = LP.PlayerGui:FindFirstChild("ForbiddenClient") or game.CoreGui:FindFirstChild("ForbiddenClient")
    if old then old:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ForbiddenClient"; ScreenGui.ResetOnSpawn = false; ScreenGui.IgnoreGuiInset = true
    
    -- Força no CoreGui para não bugar
    local ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    if not ok then ScreenGui.Parent = LP:WaitForChild("PlayerGui") end

    local Toggle = Instance.new("TextButton", ScreenGui)
    Toggle.Size = UDim2.new(0, 50, 0, 50); Toggle.Position = UDim2.new(0, 20, 0.3, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(138, 43, 226); Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Font = Enum.Font.GothamBold; Toggle.TextSize = 11; Toggle.Text = "FORBIDDEN"
    Toggle.Draggable = true
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 340, 0, 320); Main.Position = UDim2.new(0.5, -170, 0.5, -160)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Main.Draggable = true; Main.Visible = false
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(138, 43, 226); Stroke.Thickness = 1.5

    local TopBar = Instance.new("Frame", Main); TopBar.Size = UDim2.new(1, 0, 0, 30); TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)
    local Title = Instance.new("TextLabel", TopBar); Title.Size = UDim2.new(1, -40, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1; Title.Text = "THE FORBIDDEN CLIENT"; Title.TextColor3 = Color3.fromRGB(138, 43, 226)
    Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left

    local Close = Instance.new("TextButton", TopBar); Close.Size = UDim2.new(0, 30, 1, 0); Close.Position = UDim2.new(1, -30, 0, 0)
    Close.BackgroundTransparency = 1; Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255, 50, 50); Close.Font = Enum.Font.GothamBold
    Close.MouseButton1Click:Connect(function() Main.Visible = false end)
    Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 85, 1, -30); Sidebar.Position = UDim2.new(0, 0, 0, 30); Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    local SideList = Instance.new("UIListLayout", Sidebar); SideList.SortOrder = Enum.SortOrder.LayoutOrder; SideList.Padding = UDim.new(0, 2)

    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -85, 1, -30); Content.Position = UDim2.new(0, 85, 0, 30); Content.BackgroundTransparency = 1

    local function CreateTab(name)
        local Btn = Instance.new("TextButton", Sidebar); Btn.Size = UDim2.new(1, 0, 0, 30)
        Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        Btn.Font = Enum.Font.GothamSemibold; Btn.TextSize = 11; Btn.Text = name; Btn.BorderSizePixel = 0
        
        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1, -10, 1, 0); Page.Position = UDim2.new(0, 5, 0, 0)
        Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0; Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226); Page.Visible = false
        Page.CanvasSize = UDim2.new(0, 0, 0, 0); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local Layout = Instance.new("UIListLayout", Page); Layout.SortOrder = Enum.SortOrder.LayoutOrder; Layout.Padding = UDim.new(0, 4)
        
        Btn.MouseButton1Click:Connect(function()
            for _, v in ipairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in ipairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(30, 30, 35) end end
            Page.Visible = true; Btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        end)
        return Page
    end

    local function AddToggle(parent, text, flag)
        local Btn = Instance.new("TextButton", parent)
        Btn.Size = UDim2.new(1, 0, 0, 32); Btn.BackgroundColor3 = F.Config[flag] and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(40, 40, 45)
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamSemibold; Btn.TextSize = 11
        Btn.Text = text .. (F.Config[flag] and "  [ ON ]" or "  [ OFF ]"); Btn.BorderSizePixel = 0
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
        Btn.MouseButton1Click:Connect(function()
            F.Config[flag] = not F.Config[flag]
            Btn.BackgroundColor3 = F.Config[flag] and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(40, 40, 45)
            Btn.Text = text .. (F.Config[flag] and "  [ ON ]" or "  [ OFF ]")
        end)
    end

    local function AddBox(parent, placeholder, flag)
        local Box = Instance.new("TextBox", parent)
        Box.Size = UDim2.new(1, 0, 0, 32); Box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Box.TextColor3 = Color3.fromRGB(255, 255, 255); Box.PlaceholderText = placeholder; Box.Text = F.Config[flag]
        Box.Font = Enum.Font.Gotham; Box.TextSize = 11; Box.BorderSizePixel = 0
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
        Box.FocusLost:Connect(function() F.Config[flag] = Box.Text end)
    end

    local function AddButton(parent, text, callback)
        local Btn = Instance.new("TextButton", parent)
        Btn.Size = UDim2.new(1, 0, 0, 32); Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 11
        Btn.Text = text; Btn.BorderSizePixel = 0
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
        Btn.MouseButton1Click:Connect(callback)
    end

    local pFarm = CreateTab("FARM")
    local pCombat = CreateTab("COMBAT")
    local pItems = CreateTab("ITEMS")
    local pPlayer = CreateTab("PLAYER")
    local pTp = CreateTab("TELEPORT")
    local pMisc = CreateTab("MISC")
    pFarm.Visible = true; Sidebar:GetChildren()[1].BackgroundColor3 = Color3.fromRGB(138, 43, 226)

    AddToggle(pFarm, "Auto Quest (Missões)", "F_Quest")
    AddToggle(pFarm, "Auto Farm (Bosses)", "F_BestFarm")
    AddToggle(pFarm, "Auto War & Dungeon", "F_War")
    AddToggle(pFarm, "Auto Ryo Farm", "F_Ryo")

    AddToggle(pCombat, "Kill Aura", "C_KillAura")
    AddToggle(pCombat, "Auto Skill (Spam)", "C_AutoSkill")
    AddToggle(pCombat, "God Mode (Anti-Rag)", "C_GodMode")
    AddToggle(pCombat, "Auto Chakra", "C_Chakra")
    AddToggle(pCombat, "No Cooldown (Skills)", "C_NoCooldown")

    AddToggle(pItems, "Scroll Hunter", "S_Scrolls")
    AddToggle(pItems, "Auto Aizen Masks", "S_Aizen")
    AddToggle(pItems, "Auto Emblem", "S_Emblem")
    AddToggle(pItems, "Auto Spin (Roleta)", "S_AutoSpin")
    AddToggle(pItems, "Parar no Alvo", "S_StopTarget")
    AddBox(pItems, "Alvo do Spin (ex: Rengoku)", "T_SpinTarget")

    AddToggle(pPlayer, "Pulo Infinito", "P_InfJump")
    AddToggle(pPlayer, "Auto Stats", "P_AutoStats")
    
    AddToggle(pMisc, "Modo Voo (WASD)", "M_Fly")
    AddToggle(pMisc, "No Clip", "M_NoClip")
    AddToggle(pMisc, "Anti-AFK", "M_AntiAFK")
    AddToggle(pMisc, "Anti-Detect", "M_AntiDetect")
    AddBox(pMisc, "URL do Webhook (Discord)", "T_Webhook")

    AddButton(pTp, "TP: Folha (Leaf)", function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0) end end)
    AddButton(pTp, "TP: Areia (Sand)", function() if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame = CFrame.new(1000, 50, 1000) end end)

    print("[FORBIDDEN UI] Carregada com sucesso.")
end

-- ═══════════════════════════════════════════════════════════
-- 2. ENGINE (RODA DEPOIS DA UI)
-- ═══════════════════════════════════════════════════════════
local function StartEngine()
    local S = F.Config
    local hrp, hum = nil, nil
    local function updateChar()
        local char = LP.Character
        if char then
            hrp = char:FindFirstChild("HumanoidRootPart")
            hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = S.P_WalkSpeed; hum.JumpPower = S.P_JumpPower end
        end
    end
    LP.CharacterAdded:Connect(updateChar)
    updateChar()

    local function safeFire(remote, ...)
        if not remote then return end
        local args = {...}
        task.spawn(function()
            pcall(function()
                if S.M_AntiDetect then task.wait(math.random(20, 50) / 1000) end
                remote:FireServer(table.unpack(args))
            end)
        end)
    end

    local function sendWebhook(title, msg)
        if S.T_Webhook ~= "" and string.find(S.T_Webhook, "discord") then
            task.spawn(function()
                pcall(function()
                    local req = (syn and syn.request) or (http and http.request) or http_request or request
                    if req then req({Url = S.T_Webhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode({content = "**"..title.."**\n"..msg})}) end
                end)
            end)
        end
    end

    local Flight = { active=false, bv=nil, bg=nil }
    local function stopFlight()
        Flight.active = false
        if Flight.bv then Flight.bv:Destroy(); Flight.bv = nil end
        if Flight.bg then Flight.bg:Destroy(); Flight.bg = nil end
        if hum then pcall(function() hum.PlatformStand = false end) end
    end

    local function flyTo(pos, speed)
        updateChar(); if not hrp then return false end
        if not Flight.active then
            if hum then
                Flight.bv = Instance.new("BodyVelocity", hrp); Flight.bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                Flight.bg = Instance.new("BodyGyro", hrp); Flight.bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6); Flight.bg.P = 3000
                pcall(function() hum.PlatformStand = true end); Flight.active = true
            end
        end
        if not Flight.active then return false end
        local dir = pos - hrp.Position
        if dir.Magnitude <= 10 then if Flight.bv then Flight.bv.Velocity = Vector3.zero end; return true end
        if Flight.bv then Flight.bv.Velocity = dir.Unit * math.min(speed or 150, dir.Magnitude * 5) end
        if Flight.bg then Flight.bg.CFrame = CFrame.new(hrp.Position, pos) end
        return false
    end

    local Cache = { Mobs={}, Scrolls={}, NPCs={}, Masks={}, Portals={}, Emblems={} }
    task.spawn(function()
        while task.wait(3) do
            if not hrp then updateChar() end
            if not hrp then continue end
            local nMob, nScroll, nNPC, nMask, nPortal, nEmblem = {}, {}, {}, {}, {}, {}
            
            local folders = { WS:FindFirstChild("Mobs"), WS:FindFirstChild("Enemies"), WS:FindFirstChild("Bosses"), WS }
            for _, folder in ipairs(folders) do
                if folder then
                    for _, obj in ipairs(folder:GetChildren()) do
                        if obj:IsA("Model") then
                            local h = obj:FindFirstChildOfClass("Humanoid")
                            local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                            local name = obj.Name:lower()
                            if h and root and h.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                                table.insert(nMob, {obj=obj, root=root})
                            elseif obj:FindFirstChildWhichIsA("ClickDetector", true) then
                                if name:find("aizen") or name:find("mask") then table.insert(nMask, {obj=obj, root=root})
                                elseif name:find("emblem") then table.insert(nEmblem, {obj=obj, root=root})
                                else table.insert(nScroll, {obj=obj, root=root}) end
                            elseif name:find("quest") or name:find("mission") then table.insert(nNPC, {obj=obj, root=root})
                            elseif name:find("war") or name:find("dungeon") or name:find("portal") then table.insert(nPortal, {obj=obj, root=root}) end
                        end
                    end
                end
            end
            Cache.Mobs = nMob; Cache.Scrolls = nScroll; Cache.NPCs = nNPC; Cache.Masks = nMask; Cache.Portals = nPortal; Cache.Emblems = nEmblem
        end
    end)

    local Remotes = { Attack=nil, Spin=nil, Chakra=nil, Skill=nil, Stats=nil }
    task.spawn(function()
        while task.wait(5) do
            pcall(function()
                Remotes.Attack = RS:FindFirstChild("AttackRemote", true) or RS:FindFirstChild("CombatRemote", true)
                Remotes.Spin = LP:FindFirstChild("startevent") or RS:FindFirstChild("startevent", true)
                Remotes.Chakra = RS:FindFirstChild("Chakra", true)
                Remotes.Skill = RS:FindFirstChild("Skill", true) or RS:FindFirstChild("UseSkill", true)
                Remotes.Stats = RS:FindFirstChild("Stat", true) or RS:FindFirstChild("Upgrade", true)
            end)
        end
    end)

    local function getClosest(list, maxDist)
        if not hrp then return nil end
        local best, bd = nil, maxDist or 9999
        for _, item in ipairs(list) do
            local d = (item.root.Position - hrp.Position).Magnitude
            if d < bd then best, bd = item, d end
        end
        return best
    end

    task.spawn(function()
        while task.wait(0.2) do
            updateChar(); if not hrp then continue end
            local now = os.clock()

            if S.F_Quest then
                local npc = getClosest(Cache.NPCs, 1500)
                if npc then
                    if (npc.root.Position - hrp.Position).Magnitude > 15 then flyTo(npc.root.Position, 150)
                    else stopFlight(); local pp = npc.obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if pp and fireproximityprompt then pcall(function() fireproximityprompt(pp) end) end
                    end
                end
            end

            if S.F_War then
                local portal = getClosest(Cache.Portals, 2000)
                if portal then
                    if (portal.root.Position - hrp.Position).Magnitude > 15 then flyTo(portal.root.Position, 150)
                    else stopFlight(); local pp = portal.obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if pp and fireproximityprompt then pcall(function() fireproximityprompt(pp) end) end
                    end
                end
            end

            local collectTarget = nil
            if S.S_Aizen then collectTarget = getClosest(Cache.Masks, 3000) end
            if not collectTarget and S.S_Emblem then collectTarget = getClosest(Cache.Emblems, 3000) end
            if collectTarget then
                if (collectTarget.root.Position - hrp.Position).Magnitude > 10 then flyTo(collectTarget.root.Position, 200)
                else stopFlight(); local cd = collectTarget.obj:FindFirstChildWhichIsA("ClickDetector", true)
                    if cd and fireclickdetector then pcall(function() fireclickdetector(cd, 32) end); sendWebhook("Item", "Item coletado!") end
                end
            end

            if S.S_Scrolls then
                local sc = getClosest(Cache.Scrolls, 3000)
                if sc then
                    if (sc.root.Position - hrp.Position).Magnitude > 10 then flyTo(sc.root.Position, 200)
                    else stopFlight(); local cd = sc.obj:FindFirstChildWhichIsA("ClickDetector", true)
                        if cd and fireclickdetector then pcall(function() fireclickdetector(cd, 32) end) end
                    end
                end
            end

            if S.C_KillAura and Remotes.Attack then
                for _, mob in ipairs(Cache.Mobs) do
                    if (mob.root.Position - hrp.Position).Magnitude <= 150 then safeFire(Remotes.Attack, mob.obj) end
                end
            end
            if S.C_AutoSkill then
                if Remotes.Skill then safeFire(Remotes.Skill, 1) 
                else pcall(function() local vim = game:GetService("VirtualInputManager"); vim:SendKeyEvent(true, Enum.KeyCode.E, false, game); vim:SendKeyEvent(false, Enum.KeyCode.E, false, game) end) end
            end
            if S.C_NoCooldown and Remotes.Skill then safeFire(Remotes.Skill, "spam") end

            if S.F_BestFarm or S.F_Ryo then
                local mob = getClosest(Cache.Mobs, 1500)
                if mob then
                    if (mob.root.Position - hrp.Position).Magnitude > 15 then flyTo(mob.root.Position, 150)
                    else stopFlight(); local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
                        if tool then pcall(function() tool:Activate() end)
                        elseif Remotes.Attack then safeFire(Remotes.Attack, mob.obj) end
                    end
                end
            end

            if S.C_GodMode and hum and not Flight.active then pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end) end
            if S.C_Chakra and Remotes.Chakra then safeFire(Remotes.Chakra, "charge") end
            if S.P_AutoStats and Remotes.Stats then safeFire(Remotes.Stats, "Ninjutsu"); safeFire(Remotes.Stats, "Taijutsu") end
        end
    end)

    task.spawn(function()
        while task.wait(0.15) do
            if S.S_AutoSpin and Remotes.Spin then
                safeFire(Remotes.Spin, "spin", "kg1"); safeFire(Remotes.Spin, "spin", "kg2")
                if S.S_StopTarget and S.T_SpinTarget ~= "" then
                    local pg = LP:FindFirstChild("PlayerGui")
                    if pg then
                        for _, gui in ipairs(pg:GetDescendants()) do
                            if (gui:IsA("TextLabel") or gui:IsA("TextButton")) and string.find(string.lower(gui.Text), string.lower(S.T_SpinTarget)) then
                                S.S_AutoSpin = false; sendWebhook("🎯 SPIN ACERTADO", "O item **"..S.T_SpinTarget.."** foi sorteado!"); break
                            end
                        end
                    end
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        updateChar(); if not hum then return end
        if S.P_InfJump and UIS:IsKeyDown(Enum.KeyCode.Spa
