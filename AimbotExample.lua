--[[
    AimbotExample.lua — السكربت المتكامل: الإيمبوت + كل المميزات الحصرية مع مكتبة Cyan

    أساسي:
        • Aimbot / Aimlock / Silent Aim / Prediction / Trigger Bot / Auto Shoot
        • Target Lock (قفل هدف واحد) / Target Priority / Body Part Selection
        • ESP متقدم: Boxes, Names, Distance, Health, Chams, Glow, Rainbow, Radar
        • No Recoil / No Spread / Rapid Fire / Instant Reload / Infinite Ammo

    حصري (1):
        • Magic Bullet (انحناء الرصاص + Wallbang) / Kill Aura (نطاق)
        • Player List GUI (قائمة لاعبين للقفل السريع)
        • Auto Heal / Auto Respawn / Instant Respawn + موقع مخصص
        • Invisibility (تخفي Client-Side) / Teleport (ماوس/إحداثيات/غطاء)
        • Spinbot بمحور قابل للتخصيص / Anti-Aim Jitter / No Animation
        • No Fall Damage / FOV Changer / Chat Spam / Anti-AFK
        • Auto Bunny Hop / Time Scale (تأثير محلي) / Custom Crosshair
        • Sound Amplifier / Third Person / No Weapon Bob / Auto Reload
        • Aimbot Alert (تنبيه عند تصويب عدو عليك) / Auto Collect (تجريبي)

    ذكاء اصطناعي (AI):
        • AIPriority (اختيار الهدف بالتهديد) / Adaptive Smoothness (نعومة متكيفة)
        • AI Prediction 2.0 (سرعة + تسارع + سقوط حر) / Auto-Dodge / Dynamic FOV
        • Chat AI (رد تلقائي) / Auto-Pilot (Pathfinding) / Smart Triggerbot

    ميزات شائعة وخارقة:
        • Auto Clicker / Macro Recorder / Gravity / Infinite Jump / Zoom Hack
        • Hit/Kill Sound / Character Resizer / Rainbow Char / Name Hider
        • No Screen Effects / Auto-Equip Best / Command Bar / NoClip 2.0
        • Kill All (ريموت) / Lag Switch / FPS Unlocker / Rage Mode
        • Auto-Switch Weapon / Bullet Tracers / Enemy Weapon ESP / Health Alert
        • Auto-Revive Teammates / Bullet Track Visuals

    الربط مع Cyan:
        كل عنصر UI يربط بجدول Settings عبر Callback، ويمكن استدعاء كل شيء
        خارجياً عبر _G.ExclusiveFeatures (أو _G.AimbotFeatures للتوافق).

    ملاحظات:
        • الميزات المعتمدة على ريموتات اللعبة (Kill Aura الفوري، Auto Respawn،
          Auto Reload) تستخدم هيكلاً عاماً: محاكاة تصويب+إطلاق، أو إرسال ريموت
          يُبحث عنه بالاسم تلقائياً. عدّل الأسماء لتناسب "اللواء" إن لزم.
        • Radar و Crosshair مبنيان بعناصر GUI عادية (تعمل في كل الإكسكيوتورات)
          بدل مكتبة Drawing.
        • استخدام هذه المميزات يخالف شروط خدمة روبلوكس وقد يؤدي إلى حظر الحساب.
          الملف لأغراض تعليمية وتجريبية فقط.
--]]

-- ==============================
-- تحميل المكتبة (Cyan)
-- ==============================
local repo = "https://raw.githubusercontent.com/EhabYT/cyan/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

-- ==============================
-- الخدمات والمتغيرات الأساسية
-- ==============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TextChatService = game:GetService("TextChatService")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==============================
-- الإعدادات (مصدر الحقيقة الوحيد للمحركات)
-- ==============================
local Settings = {
    -- الإيمبوت
    Aimbot = false,
    Smoothness = 3,
    FOV = 200,
    SilentAim = false,
    Prediction = false,
    PredictionAmount = 0.15,
    Aimlock = false,
    WallCheck = false,
    TeamCheck = true,
    FOVCircle = false,                 -- دائرة الـ FOV حول المؤشر
    TargetPriority = "الأقرب للمؤشر", -- "الأقرب للمؤشر" | "الأقرب مسافة" | "أقل صحة"
    HitPart = "الرأس",                 -- "الرأس" | "الجذع" | "الأرجل" | "عشوائي"
    LockTarget = nil,                  -- قفل الهدف (Target Lock)

    -- الإطلاق
    TriggerBot = false,
    TriggerDelay = 0.08,
    AutoShoot = false,
    KillAura = false,
    KillAuraRange = 30,
    KillAuraDelay = 0.1,

    -- الرصاص
    MagicBullet = false,               -- انحناء الرصاص + تجاهل الجدران (Wallbang)
    NoSpread = false,
    RapidFire = false,
    RapidFireMultiplier = 5,
    InstantReload = false,
    AutoReload = false,

    -- ESP
    ESP = false,
    ESPBoxes = false,
    ESPNames = false,
    ESPDistance = false,
    ESPHealth = false,
    ESPChams = false,
    ESPGlow = false,
    ESPRadar = false,
    RadarSize = 150,
    RadarPos = Vector2.new(130, 130),
    ESPColor = Color3.fromRGB(255, 0, 0),
    RainbowESP = false,

    -- الأسلحة
    NoRecoil = false,
    InfiniteAmmo = false,
    NoAnimation = false,
    NoWeaponBob = false,

    -- الحركة
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    SpeedHack = false,
    SpeedMultiplier = 2,
    BunnyHop = false,
    NoFallDamage = false,
    Spinbot = false,
    SpinSpeed = 5,                     -- دورات في الثانية
    SpinAxis = "Y",                    -- "X" | "Y" | "Z"
    AntiAimJitter = false,
    JitterAngle = 15,
    ThirdPerson = false,
    ThirdPersonDistance = 10,

    -- تخفي ونقل
    Invisibility = false,
    SpawnLocation = nil,               -- إحداثيات لإعادة الظهور المخصصة

    -- أخرى
    FOVChanger = false,
    FOVValue = 70,
    TimeScale = 1,                     -- محلي (يؤثر على الأصوات فقط)
    SoundAmplifier = false,
    ChatSpam = false,
    ChatMessage = "أنا الأفضل في اللواء!",
    ChatDelay = 2,
    AntiAFK = false,
    AutoHeal = false,
    HealThreshold = 50,
    AutoRespawn = false,
    InstantRespawn = false,
    AimbotAlert = false,
    Crosshair = false,
    CrosshairSize = 10,
    CrosshairColor = Color3.fromRGB(0, 255, 0),
    PlayerList = false,
    AutoCollect = false,               -- تجريبي: يعتمد على أسماء الأجزاء في اللعبة

    -- AI (ذكاء اصطناعي)
    AIPriority = false,                -- أولوية الهدف بالتهديد (من يصوب عليك أولاً)
    AdaptiveSmoothness = false,        -- نعومة تتكيف مع المسافة
    AIPrediction = false,              -- توقع متقدم: سرعة + تسارع + حالة حركة
    AutoDodge = false,                 -- تحرك جانبي لتفادي التصويب
    DynamicFOV = false,                -- FOV يتسع حسب كثافة الأعداء
    ChatAI = false,                    -- رد تلقائي في الشات
    AutoPilot = false,                 -- تحرك تلقائي نحو أقرب عدو (Pathfinding)
    SmartTrigger = false,              -- التريقر لا يطلق إلا على هدف مرئي قريب

    -- ميزات شائعة
    AutoClicker = false,
    ClickRate = 10,                    -- نقرة في الثانية
    GravityEnabled = false,
    Gravity = 196.2,
    InfiniteJump = false,
    ZoomHack = false,
    ZoomLevel = 2,
    HitSound = false,
    HitSoundId = "",                   -- ضع rbxassetid:// هنا
    KillSound = false,
    KillSoundId = "",                  -- ضع rbxassetid:// هنا
    CharacterResizer = false,
    CharacterSize = 1,
    RainbowChar = false,
    NameHider = false,
    NoScreenEffects = false,
    AutoEquipBest = false,
    Noclip2 = false,                   -- NoClip أثناء الحركة فقط

    -- ميزات خارقة
    LagSwitch = false,
    FPSUnlocker = false,
    AutoSwitchWeapon = false,          -- تبديل أفضل سلاح بعد القتل
    BulletTracers = false,             -- خط مسار الرصاص (يتطلب Drawing)
    EnemyWeaponESP = false,            -- عرض سلاح العدو في الـ ESP
    HealthAlert = false,
    HealthAlertThreshold = 30,
    AutoRevive = false,                -- إحياء الزملاء (يبحث عن ريموت revive)
}

-- ==============================
-- أدوات مساعدة
-- ==============================
local Connections = {} -- كل الاتصالات ليتم فصلها عند الإلغاء
local Unloaded = false -- علم عام لإيقاف الحلقات

local FOVCircleFrame = nil
local CrosshairGui = nil
local RadarFrame = nil
local RadarDots = {} -- [plr] = Frame
local PlayerListGui = nil
local HealthAlertWarned = false
local PlayerListFrame = nil
local PlayerListButtons = {} -- [plr] = TextButton
local LastPlayerListCount = 0

local function IsAlive(character)
    if not character or not character.Parent then
        return false
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return false
    end

    local ok, alive = pcall(function()
        return humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead
    end)

    return ok and alive
end

local function IsEnemy(plr)
    if plr == LocalPlayer then
        return false
    end

    if Settings.TeamCheck and LocalPlayer.Team ~= nil and plr.Team == LocalPlayer.Team then
        return false
    end

    return true
end

local function GetLocalTool()
    local character = LocalPlayer.Character
    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Tool")
end

local function FindWeaponValue(tool, names)
    if not tool then
        return nil
    end

    for _, name in ipairs(names) do
        local value = tool:FindFirstChild(name)
        if value and (value:IsA("NumberValue") or value:IsA("IntValue")) then
            return value
        end
    end

    return nil
end

-- جزء الإصابة المحدد من الهدف (رأس/جذع/أرجل/عشوائي)
local function GetAimPart(plr)
    local char = plr and plr.Character
    if not char then
        return nil
    end

    local part = Settings.HitPart

    if part == "الجذع" or part == "Torso" then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    elseif part == "الأرجل" or part == "Leg" or part == "Legs" then
        return char:FindFirstChild("Left Leg")
            or char:FindFirstChild("Right Leg")
            or char:FindFirstChild("HumanoidRootPart")
    elseif part == "عشوائي" or part == "Random" then
        local names = { "Head", "HumanoidRootPart", "Left Leg", "Right Leg" }
        return char:FindFirstChild(names[math.random(1, #names)]) or char:FindFirstChild("Head")
    end

    return char:FindFirstChild("Head")
end

-- محاكاة ضغطة فأرة (مع تحذير مرة واحدة إذا كانت الدوال غير متوفرة)
local ClickWarned = false

local function ClickMouse()
    local ok = pcall(function()
        mouse1press()
        task.wait(0.05)
        mouse1release()
    end)

    if not ok and not ClickWarned then
        ClickWarned = true
        Library:Notify({
            Title = "تنبيه",
            Description = "دوال mouse1press/mouse1release غير متوفرة في هذا الإكسكيوتور.",
            Time = 5,
        })
    end
end

local function TeleportTo(position)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(position)
    end
end

-- خط مسار الرصاص (يتطلب مكتبة Drawing في الإكسكيوتور)
local function CreateTracer(fromWorld, toWorld)
    if not Settings.BulletTracers then
        return
    end

    pcall(function()
        local line = Drawing.new("Line")
        line.From = Camera:WorldToViewportPoint(fromWorld)
        line.To = Camera:WorldToViewportPoint(toWorld)
        line.Color = Color3.new(1, 1, 0)
        line.Thickness = 1
        line.Visible = true

        task.delay(0.1, function()
            pcall(function()
                line:Remove()
            end)
        end)
    end)
end

-- ==============================
-- اختيار الهدف (قفل + أولوية + جدران)
-- ==============================
local RaycastParamsCache = RaycastParams.new()

local function GetClosestTarget(fromPosition)
    -- Target Lock: الهدف المقفل له الأولوية المطلقة (حتى لو خارج الـ FOV)
    if Settings.LockTarget then
        local locked = Settings.LockTarget
        if locked ~= LocalPlayer
            and IsEnemy(locked)
            and locked.Character
            and IsAlive(locked.Character)
            and locked.Character:FindFirstChild("Head")
        then
            return locked
        end

        -- الهدف المقفل مات أو غادر: نلغي القفل
        Settings.LockTarget = nil
    end

    local from = fromPosition or Vector2.new(Mouse.X, Mouse.Y)
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local origin = Camera.CFrame.Position

    local nearest, bestScore = nil, math.huge
    local priority = Settings.TargetPriority

    for _, plr in ipairs(Players:GetPlayers()) do
        if IsEnemy(plr) then
            local char = plr.Character
            local head = char and char:FindFirstChild("Head")
            if head and IsAlive(char) then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local screenDist = (from - Vector2.new(pos.X, pos.Y)).Magnitude
                    if screenDist <= Settings.FOV then
                        local blocked = false

                        -- Magic Bullet يعمل كـ Wallbang: يتجاهل الجدران
                        if Settings.WallCheck and not Settings.MagicBullet then
                            local direction = head.Position - origin
                            if direction.Magnitude > 0.1 then
                                local filter = { char }
                                if localChar then
                                    table.insert(filter, localChar)
                                end

                                RaycastParamsCache.FilterType = Enum.RaycastFilterType.Blacklist
                                RaycastParamsCache.FilterDescendantsInstances = filter
                                local hit = Workspace:Raycast(origin, direction, RaycastParamsCache)
                                blocked = hit ~= nil
                            end
                        end

                        if not blocked then
                            local score

                            if Settings.AIPriority then
                                -- ذكاء اصطناعي: درجة التهديد = من يصوب عليك (-250) + القرب + الصحة
                                score = screenDist

                                local toMe = (origin - head.Position).Unit
                                if toMe:Dot(head.CFrame.LookVector) > 0.93 then
                                    score = score - 250
                                end

                                local hum = char:FindFirstChildOfClass("Humanoid")
                                if hum then
                                    score = score + hum.Health * 0.1
                                end
                            elseif priority == "أقل صحة" then
                                local hum = char:FindFirstChildOfClass("Humanoid")
                                score = hum and hum.Health or math.huge
                            elseif priority == "الأقرب مسافة" then
                                local root = char:FindFirstChild("HumanoidRootPart")
                                score = (root and localRoot)
                                    and (root.Position - localRoot.Position).Magnitude
                                    or screenDist
                            else
                                score = screenDist
                            end

                            if score < bestScore then
                                bestScore = score
                                nearest = plr
                            end
                        end
                    end
                end
            end
        end
    end

    return nearest
end

-- ==============================
-- Silent Aim (خطاف metamethod)
-- ==============================
local SilentAimTarget = nil
local SilentAimPosition = nil
local SilentAimHooked = false
local SilentAimOldIndex = nil

local function InstallSilentAimHook()
    if SilentAimHooked then
        return true
    end

    local success = pcall(function()
        local mt = getrawmetatable(game)
        SilentAimOldIndex = mt.__index
        if typeof(SilentAimOldIndex) ~= "function" then
            error("__index is not hookable", 0)
        end

        local closure = newcclosure or function(fn)
            return fn
        end

        setreadonly(mt, false)
        mt.__index = closure(function(self, key)
            if Settings.SilentAim and SilentAimTarget and self == Mouse then
                if key == "Hit" then
                    return CFrame.lookAt(Camera.CFrame.Position, SilentAimPosition or SilentAimTarget.Position)
                elseif key == "Target" then
                    return SilentAimTarget
                end
            end

            return SilentAimOldIndex(self, key)
        end)
        setreadonly(mt, true)
        SilentAimHooked = true
    end)

    if not success then
        Library:Notify({
            Title = "Silent Aim",
            Description = "الإكسكيوتور لا يدعم خطاف metamethod — تم تعطيل الميزة.",
            Time = 5,
        })
    end

    return success
end

local function UninstallSilentAimHook()
    if not SilentAimHooked then
        return
    end

    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        mt.__index = SilentAimOldIndex
        setreadonly(mt, true)
    end)

    SilentAimHooked = false
    SilentAimOldIndex = nil
    SilentAimTarget = nil
    SilentAimPosition = nil
end

-- ==============================
-- حلقة الإيمبوت (Aimbot + Aimlock + Prediction)
-- ==============================
local function IsAimlockActive()
    if Settings.Aimlock then
        return true
    end

    local picker = Options.AimlockKeybind
    if not picker then
        return false
    end

    local ok, state = pcall(function()
        return picker:GetState()
    end)

    return ok and state == true
end

table.insert(Connections, RunService.RenderStepped:Connect(function()
    -- دائرة الـ FOV حول المؤشر
    if FOVCircleFrame then
        FOVCircleFrame.Visible = Settings.FOVCircle
        if FOVCircleFrame.Visible then
            local size = Settings.FOV * 2
            FOVCircleFrame.Size = UDim2.fromOffset(size, size)
            FOVCircleFrame.Position = UDim2.fromOffset(Mouse.X, Mouse.Y)
        end
    end

    local aimlockActive = IsAimlockActive()
    local aimActive = Settings.Aimbot or aimlockActive

    local target = GetClosestTarget()
    if not aimActive or not target then
        SilentAimTarget = nil
        SilentAimPosition = nil
        return
    end

    local part = GetAimPart(target)
    if not part then
        return
    end

    local aimPos = part.Position
    if Settings.AIPrediction then
        -- AI Prediction 2.0: السرعة + التسارع + نمط الحركة
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local velocity = root.Velocity
            local acceleration = root.AssemblyLinearVelocity - velocity
            local dist = (Camera.CFrame.Position - aimPos).Magnitude
            local travelTime = dist / 800 -- سرعة رصاص افتراضية

            aimPos = aimPos + velocity * travelTime + 0.5 * acceleration * travelTime * travelTime

            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local ok, state = pcall(function()
                    return hum:GetState()
                end)

                if ok and state == Enum.HumanoidStateType.Freefall then
                    aimPos = aimPos + Vector3.new(0, -1, 0) -- تصحيح السقوط الحر
                end
            end
        end
    elseif Settings.Prediction then
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        if root then
            aimPos = aimPos + root.Velocity * Settings.PredictionAmount
        end
    end

    if Settings.SilentAim and SilentAimHooked then
        SilentAimTarget = part
        SilentAimPosition = aimPos
        return
    end

    SilentAimTarget = nil
    SilentAimPosition = nil

    local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, aimPos)

    if aimlockActive then
        Camera.CFrame = targetCFrame -- Aimlock: فوري بدون نعومة
    else
        -- Adaptive Smoothness: ناعم جداً عن قرب، سريع عن بعد
        local smoothness = Settings.Smoothness

        if Settings.AdaptiveSmoothness then
            local dist = (Camera.CFrame.Position - aimPos).Magnitude
            if dist < 20 then
                smoothness = 10
            elseif dist < 50 then
                smoothness = 5
            else
                smoothness = 2
            end
        end

        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / math.max(smoothness, 1))
    end
end))

-- ==============================
-- الإطلاق التلقائي: Trigger Bot + Auto Shoot + Kill Aura
-- ==============================
local LastShotTime = 0
local LastKillAuraShot = 0

table.insert(Connections, RunService.RenderStepped:Connect(function()
    local now = os.clock()

    -- Trigger Bot + Auto Shoot
    local wantFire = Settings.TriggerBot
        or (Settings.AutoShoot and (Settings.Aimbot or IsAimlockActive()))

    if wantFire then
        local center = Camera.ViewportSize / 2
        local target = GetClosestTarget(center)
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local screenDist = (center - Vector2.new(pos.X, pos.Y)).Magnitude

            -- Smart Trigger: منطقة أصغر + يتطلب رؤية مباشرة
            local radius = Settings.SmartTrigger
                and math.max(Settings.FOV / 6, 8)
                or math.max(Settings.FOV / 3, 15)

            if onScreen and screenDist <= radius and now - LastShotTime >= Settings.TriggerDelay then
                local fire = true

                if Settings.SmartTrigger then
                    local direction = head.Position - Camera.CFrame.Position
                    if direction.Magnitude > 0.1 then
                        local filter = { target.Character }
                        local localChar = LocalPlayer.Character
                        if localChar then
                            table.insert(filter, localChar)
                        end

                        RaycastParamsCache.FilterType = Enum.RaycastFilterType.Blacklist
                        RaycastParamsCache.FilterDescendantsInstances = filter
                        local hit = Workspace:Raycast(Camera.CFrame.Position, direction, RaycastParamsCache)
                        fire = hit == nil
                    end
                end

                if fire then
                    LastShotTime = now

                    if Settings.BulletTracers then
                        CreateTracer(Camera.CFrame.Position, head.Position)
                    end

                    task.spawn(ClickMouse)
                end
            end
            end
        end
    end

    -- Kill Aura: تصويب + إطلاق على كل هدف داخل النطاق (بديل عام للقتل الفوري)
    if Settings.KillAura and now - LastKillAuraShot >= Settings.KillAuraDelay then
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local target, bestDist = nil, Settings.KillAuraRange

        for _, plr in ipairs(Players:GetPlayers()) do
            if IsEnemy(plr) then
                local char = plr.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root and IsAlive(char) then
                    local dist = myRoot and (root.Position - myRoot.Position).Magnitude or math.huge
                    if dist <= bestDist then
                        bestDist = dist
                        target = plr
                    end
                end
            end
        end

        if target then
            LastKillAuraShot = now
            local part = GetAimPart(target)
            if part then
                if Settings.SilentAim and SilentAimHooked then
                    SilentAimTarget = part
                    SilentAimPosition = part.Position
                else
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, part.Position)
                end
            end

            task.spawn(ClickMouse)
        end
    end
end))

-- ==============================
-- Magic Bullet (انحناء الرصاص نحو الهدف)
-- ==============================
local LastBulletScan = 0

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.MagicBullet then
        return
    end

    local now = os.clock()
    if now - LastBulletScan < 0.1 then
        return
    end
    LastBulletScan = now

    pcall(function()
        local target = GetClosestTarget()
        if not target then
            return
        end

        local part = GetAimPart(target)
        if not part then
            return
        end

        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart")
                and v:GetAttribute("Creator") == LocalPlayer
                and string.find(string.lower(v.Name), "bullet", 1, true)
            then
                local direction = part.Position - v.Position
                if direction.Magnitude > 0.5 then
                    local speed = math.max(v.Velocity.Magnitude, 50)
                    v.Velocity = direction.Unit * speed
                    v.CFrame = CFrame.lookAt(v.Position, part.Position)
                end
            end
        end
    end)
end))

-- ==============================
-- تعديلات السلاح: No Spread + Rapid Fire + Instant Reload
-- ==============================
local SpreadNames = { "Spread", "BulletSpread", "SpreadValue" }
local FireRateNames = { "FireRate", "RPM", "FireDelay" }
local ReloadNames = { "ReloadTime", "ReloadSpeed" }

local WeaponBackups = {} -- [tool] = { Spread?, FireRate?, ReloadTime? }

local function ApplyWeaponMods()
    if not (Settings.NoSpread or Settings.RapidFire or Settings.InstantReload) then
        return
    end

    local tool = GetLocalTool()
    if not tool then
        return
    end

    local backup = WeaponBackups[tool]
    if not backup then
        backup = {}

        local spread = FindWeaponValue(tool, SpreadNames)
        if spread then
            backup.Spread = spread.Value
        end

        local fireRate = FindWeaponValue(tool, FireRateNames)
        if fireRate then
            backup.FireRate = fireRate.Value
        end

        local reload = FindWeaponValue(tool, ReloadNames)
        if reload then
            backup.ReloadTime = reload.Value
        end

        WeaponBackups[tool] = backup
    end

    local spread = FindWeaponValue(tool, SpreadNames)
    if spread and backup.Spread ~= nil then
        spread.Value = Settings.NoSpread and 0 or backup.Spread
    end

    local fireRate = FindWeaponValue(tool, FireRateNames)
    if fireRate and backup.FireRate ~= nil then
        fireRate.Value = Settings.RapidFire
            and (backup.FireRate * math.max(Settings.RapidFireMultiplier, 1))
            or backup.FireRate
    end

    local reload = FindWeaponValue(tool, ReloadNames)
    if reload and backup.ReloadTime ~= nil then
        reload.Value = Settings.InstantReload and 0.01 or backup.ReloadTime
    end

    for oldTool in pairs(WeaponBackups) do
        if oldTool ~= tool and not oldTool.Parent then
            WeaponBackups[oldTool] = nil
        end
    end
end

local function RestoreWeaponMods()
    for tool, backup in pairs(WeaponBackups) do
        if tool.Parent then
            pcall(function()
                local spread = FindWeaponValue(tool, SpreadNames)
                if spread and backup.Spread ~= nil then
                    spread.Value = backup.Spread
                end

                local fireRate = FindWeaponValue(tool, FireRateNames)
                if fireRate and backup.FireRate ~= nil then
                    fireRate.Value = backup.FireRate
                end

                local reload = FindWeaponValue(tool, ReloadNames)
                if reload and backup.ReloadTime ~= nil then
                    reload.Value = backup.ReloadTime
                end
            end)
        end

        WeaponBackups[tool] = nil
    end
end

task.spawn(function()
    while not Unloaded and task.wait(0.5) do
        if Settings.NoSpread or Settings.RapidFire or Settings.InstantReload then
            pcall(ApplyWeaponMods)
        end
    end
end)

-- ==============================
-- منع الارتداد (No Recoil)
-- ==============================
local RecoilHooked = false
local RecoilValue = nil
local RecoilBackup = nil

local function FindRecoilValue(tool)
    return tool
        and (tool:FindFirstChild("Recoil")
            or tool:FindFirstChild("RecoilValue")
            or tool:FindFirstChild("Kickback"))
end

local function ApplyNoRecoil()
    local tool = GetLocalTool()
    local value = FindRecoilValue(tool)

    if Settings.NoRecoil then
        if not value then
            return
        end

        if not RecoilHooked then
            RecoilHooked = true
            RecoilValue = value
            RecoilBackup = value.Value

            value.Changed:Connect(function()
                if Settings.NoRecoil and RecoilValue and RecoilValue.Parent then
                    RecoilValue.Value = 0
                end
            end)
        end

        value.Value = 0
    else
        if RecoilHooked and RecoilValue and RecoilValue.Parent then
            RecoilValue.Value = RecoilBackup
        end

        RecoilHooked = false
        RecoilValue = nil
        RecoilBackup = nil
    end
end

task.spawn(function()
    while not Unloaded and task.wait(1) do
        if Settings.NoRecoil then
            pcall(ApplyNoRecoil)
        end
    end
end)

-- ==============================
-- ذخيرة لا نهائية (Infinite Ammo)
-- ==============================
local AmmoHooked = false
local AmmoValue = nil
local AmmoBackup = nil

local function FindAmmoValue(tool)
    if not tool then
        return nil
    end

    local names = { "Ammo", "AmmoValue", "CurrentAmmo", "Bullets", "AmmoCount", "Magazine" }
    for _, name in ipairs(names) do
        local value = tool:FindFirstChild(name)
        if value and (value:IsA("NumberValue") or value:IsA("IntValue")) then
            return value
        end
    end

    return nil
end

local function ApplyInfiniteAmmo()
    local tool = GetLocalTool()
    local value = FindAmmoValue(tool)

    if Settings.InfiniteAmmo then
        if not value then
            return
        end

        if not AmmoHooked then
            AmmoHooked = true
            AmmoValue = value
            AmmoBackup = value.Value

            value.Changed:Connect(function()
                if Settings.InfiniteAmmo and AmmoValue and AmmoValue.Parent then
                    AmmoValue.Value = AmmoBackup
                end
            end)
        end

        if value.Value < AmmoBackup then
            value.Value = AmmoBackup
        end
    else
        if AmmoHooked and AmmoValue and AmmoValue.Parent then
            AmmoValue.Value = AmmoBackup
        end

        AmmoHooked = false
        AmmoValue = nil
        AmmoBackup = nil
    end
end

task.spawn(function()
    while not Unloaded and task.wait(1) do
        if Settings.InfiniteAmmo then
            pcall(ApplyInfiniteAmmo)
        end
    end
end)

-- ==============================
-- Auto Reload (تعبئة تلقائية عند نفاد الذخيرة)
-- ==============================
local LastAutoReload = 0

task.spawn(function()
    while not Unloaded and task.wait(0.5) do
        if Settings.AutoReload then
            local tool = GetLocalTool()
            local ammo = FindAmmoValue(tool)

            if ammo then
                local shouldReload = ammo.Value <= 0
                if not shouldReload and AmmoBackup then
                    shouldReload = ammo.Value <= AmmoBackup * 0.2
                end

                local now = os.clock()
                if shouldReload and now - LastAutoReload >= 1 then
                    LastAutoReload = now

                    pcall(function()
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                    end)

                    local remote = tool and (tool:FindFirstChild("Reload") or tool:FindFirstChild("ReloadRemote"))
                    if remote and remote:IsA("RemoteEvent") then
                        pcall(function()
                            remote:FireServer()
                        end)
                    end
                end
            end
        end
    end
end)

-- ==============================
-- No Animation + No Weapon Bob
-- ==============================
local function StopAnimations(includeAll)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then
        return
    end

    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        local text = string.lower((track.Animation and (track.Animation.Name .. track.Animation.AnimationId)) or "")

        if includeAll or string.find(text, "bob", 1, true) or string.find(text, "idle", 1, true) then
            pcall(function()
                track:Stop()
            end)
        end
    end
end

task.spawn(function()
    while not Unloaded and task.wait(0.5) do
        if Settings.NoAnimation then
            pcall(StopAnimations, true)
        elseif Settings.NoWeaponBob then
            pcall(StopAnimations, false)
        end
    end
end)

-- ==============================
-- Spinbot (بمحور قابل للتخصيص) + Anti-Aim Jitter + Bunny Hop
-- ==============================
table.insert(Connections, RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    -- Spinbot
    if Settings.Spinbot then
        local degrees = Settings.SpinSpeed * 360 * dt
        local spinCFrame

        if Settings.SpinAxis == "X" then
            spinCFrame = CFrame.Angles(math.rad(degrees), 0, 0)
        elseif Settings.SpinAxis == "Z" then
            spinCFrame = CFrame.Angles(0, 0, math.rad(degrees))
        else
            spinCFrame = CFrame.Angles(0, math.rad(degrees), 0)
        end

        root.CFrame = root.CFrame * spinCFrame
    end

    -- Anti-Aim Jitter: أدر ظهرك للكاميرا مع اهتزاز عشوائي (بدون تراكم)
    if Settings.AntiAimJitter then
        local lookCFrame = CFrame.lookAt(root.Position, root.Position - Camera.CFrame.LookVector)
        local jitter = CFrame.Angles(0, math.rad(math.random(-Settings.JitterAngle, Settings.JitterAngle)), 0)
        root.CFrame = lookCFrame * jitter
    end

    -- Auto Bunny Hop
    if Settings.BunnyHop
        and (UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.W))
    then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local ok, state = pcall(function()
                return hum:GetState()
            end)

            if ok and state == Enum.HumanoidStateType.Landed then
                hum.Jump = true
            end
        end
    end
end))

-- ==============================
-- Fly + Noclip
-- ==============================
local FlyGyro = nil
local FlyVelocity = nil

local function StopFly()
    if FlyGyro then
        FlyGyro:Destroy()
    end

    if FlyVelocity then
        FlyVelocity:Destroy()
    end

    FlyGyro = nil
    FlyVelocity = nil
end

local function RestoreNoclip()
    local char = LocalPlayer.Character
    if not char then
        return
    end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then
        return
    end

    if Settings.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    if Settings.Fly then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            if not FlyGyro then
                FlyGyro = Instance.new("BodyGyro")
                FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                FlyGyro.CFrame = root.CFrame
                FlyGyro.Parent = root
            end

            if not FlyVelocity then
                FlyVelocity = Instance.new("BodyVelocity")
                FlyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                FlyVelocity.Velocity = Vector3.zero
                FlyVelocity.Parent = root
            end

            local moveDir = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + Camera.CFrame.LookVector
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - Camera.CFrame.LookVector
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - Camera.CFrame.RightVector
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + Camera.CFrame.RightVector
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            FlyVelocity.Velocity = moveDir * Settings.FlySpeed
            FlyGyro.CFrame = Camera.CFrame
        end
    else
        StopFly()
    end
end))

-- ==============================
-- Speed Hack + FOV Changer + Third Person + No Fall Damage
-- ==============================
local DefaultWalkSpeed = nil
local NoFallDamageState = nil -- آخر حالة طُبقت (لتفادي الاستدعاء المتكرر)

local function GetDefaultWalkSpeed()
    if DefaultWalkSpeed then
        return DefaultWalkSpeed
    end

    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        DefaultWalkSpeed = hum.WalkSpeed
    end

    return DefaultWalkSpeed or 16
end

table.insert(Connections, RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    -- Speed Hack (مع حفظ السرعة الأصلية)
    if hum then
        if Settings.SpeedHack then
            local target = GetDefaultWalkSpeed() * math.max(Settings.SpeedMultiplier, 1)
            if hum.WalkSpeed ~= target then
                hum.WalkSpeed = target
            end
        elseif hum.WalkSpeed ~= GetDefaultWalkSpeed() then
            hum.WalkSpeed = GetDefaultWalkSpeed()
        end

        -- No Fall Damage: تعطيل حالة السقوط المؤذي (يُعاد عند إعادة الظهور)
        local wanted = not Settings.NoFallDamage
        if NoFallDamageState ~= wanted then
            NoFallDamageState = wanted
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, wanted)
            end)
        end
    end

    -- FOV Changer + Zoom Hack (كاميرا محلية — يتضاربان فيُدمجان)
    local effectiveFOV = 70
    if Settings.FOVChanger then
        effectiveFOV = Settings.FOVValue
    end

    if Settings.ZoomHack then
        effectiveFOV = 70 / math.max(Settings.ZoomLevel, 1)
    end

    if Camera.FieldOfView ~= effectiveFOV then
        Camera.FieldOfView = effectiveFOV
    end

    -- Third Person عبر إزاحة الكاميرا (يعمل Client-Side)
    if Settings.ThirdPerson then
        local offset = Vector3.new(0, 1, Settings.ThirdPersonDistance)
        if Camera.Offset ~= offset then
            Camera.Offset = offset
        end
    elseif Camera.Offset.Magnitude > 0 then
        Camera.Offset = Vector3.zero
    end
end))

-- ==============================
-- Invisibility (تخفي Client-Side)
-- ==============================
local function ApplyInvisibility()
    local char = LocalPlayer.Character
    if not char then
        return
    end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = Settings.Invisibility and 0.85 or 0
        end
    end
end

task.spawn(function()
    while not Unloaded and task.wait(0.5) do
        if Settings.Invisibility then
            pcall(ApplyInvisibility)
        end
    end
end)

-- ==============================
-- Time Scale (تأثير محلي: تسريع/إبطاء الأصوات) + Sound Amplifier
-- ==============================
task.spawn(function()
    while not Unloaded and task.wait(1) do
        if Settings.TimeScale ~= 1 then
            pcall(function()
                for _, sound in ipairs(Workspace:GetDescendants()) do
                    if sound:IsA("Sound") then
                        sound.PlaybackSpeed = Settings.TimeScale
                    end
                end
            end)
        end

        if Settings.SoundAmplifier then
            pcall(function()
                for _, sound in ipairs(Workspace:GetDescendants()) do
                    if sound:IsA("Sound") and sound.Parent and sound.Parent:FindFirstChild("Humanoid") then
                        sound.Volume = 2
                    end
                end
            end)
        end
    end
end)

-- ==============================
-- Teleport: إلى الماوس / إحداثيات / أقرب غطاء
-- ==============================
local function TeleportToMouse()
    pcall(function()
        TeleportTo(Mouse.Hit.Position + Vector3.new(0, 3, 0))
    end)
end

local function TeleportToCoords(x, y, z)
    pcall(function()
        TeleportTo(Vector3.new(x, y, z))
    end)
end

-- البحث عن أقرب غطاء: نقطة حولك يحجبها جدار بينك وبين أقرب عدو
local function TeleportToCover()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    local target = GetClosestTarget()
    local enemyHead = target and target.Character and target.Character:FindFirstChild("Head")
    if not enemyHead then
        Library:Notify({
            Title = "Smart Cover",
            Description = "لا يوجد هدف قريب للاحتماء منه.",
            Time = 3,
        })
        return
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { char, target.Character }

    local bestPoint, bestDistance = nil, math.huge
    local samples = 16
    local radius = 12

    for i = 1, samples do
        local angle = (i - 1) / samples * math.pi * 2
        local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
        local candidate = root.Position + offset

        local direction = candidate - enemyHead.Position
        local hit = Workspace:Raycast(enemyHead.Position, direction, params)

        -- يوجد جدار بين العدو والنقطة = غطاء صالح
        if hit and hit.Distance > 1 then
            local distToPlayer = (candidate - root.Position).Magnitude
            if distToPlayer < bestDistance then
                bestDistance = distToPlayer
                bestPoint = candidate
            end
        end
    end

    if bestPoint then
        TeleportTo(bestPoint + Vector3.new(0, 3, 0))
        Library:Notify({
            Title = "Smart Cover",
            Description = "تم الانتقال إلى غطاء.",
            Time = 3,
        })
    else
        Library:Notify({
            Title = "Smart Cover",
            Description = "لم يُعثر على غطاء قريب.",
            Time = 3,
        })
    end
end

-- ==============================
-- Auto Collect (تجريبي — يعتمد على أسماء الأجزاء في اللعبة)
-- ==============================
local CollectKeywords = { "coin", "cash", "gem", "orb", "crate", "supply", "loot", "resource" }
local LastCollectScan = 0

task.spawn(function()
    while not Unloaded and task.wait(0.5) do
        if Settings.AutoCollect then
            local now = os.clock()
            if now - LastCollectScan >= 0.3 then
                LastCollectScan = now

                pcall(function()
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not root then
                        return
                    end

                    local nearest, bestDist = nil, 50

                    for _, part in ipairs(Workspace:GetDescendants()) do
                        if part:IsA("BasePart") then
                            local name = string.lower(part.Name)
                            local matched = false

                            for _, keyword in ipairs(CollectKeywords) do
                                if string.find(name, keyword, 1, true) then
                                    matched = true
                                    break
                                end
                            end

                            if matched then
                                local dist = (part.Position - root.Position).Magnitude
                                if dist < bestDist then
                                    bestDist = dist
                                    nearest = part
                                end
                            end
                        end
                    end

                    if nearest then
                        TeleportTo(nearest.Position + Vector3.new(0, 3, 0))
                    end
                end)
            end
        end
    end
end)

-- ==============================
-- Auto Heal (استخدام أداة شفاء تلقائياً)
-- ==============================
local function FindHealTool()
    local keywords = { "med", "heal", "band", "aid", "kit", "first" }

    for _, container in ipairs({ LocalPlayer.Backpack, LocalPlayer.Character }) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = string.lower(tool.Name)
                    for _, keyword in ipairs(keywords) do
                        if string.find(name, keyword, 1, true) then
                            return tool
                        end
                    end
                end
            end
        end
    end

    return nil
end

task.spawn(function()
    while not Unloaded and task.wait(0.5) do
        if Settings.AutoHeal then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if hum then
                local threshold = hum.MaxHealth * (Settings.HealThreshold / 100)
                if hum.Health < threshold then
                    local tool = FindHealTool()
                    if tool then
                        pcall(function()
                            hum:EquipTool(tool)
                            task.delay(0.2, ClickMouse)
                        end)
                    end
                end
            end
        end
    end
end)

-- ==============================
-- Auto Respawn + Instant Respawn
-- ==============================
local function TryRespawn()
    -- البحث عن ريموت إعادة الظهور بالاسم (قد يختلف في لعبتك)
    pcall(function()
        for _, child in ipairs(ReplicatedStorage:GetDescendants()) do
            if (child:IsA("RemoteEvent") or child:IsA("RemoteFunction"))
                and string.find(string.lower(child.Name), "respawn", 1, true)
            then
                if child:IsA("RemoteEvent") then
                    child:FireServer()
                else
                    child:InvokeServer()
                end

                return
            end
        end
    end)
end

table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(char)
    -- إعادة ضبط الحالات المؤقتة عند إعادة الظهور
    NoFallDamageState = nil

    -- إعادة تطبيق التخفي إن كان مفعلاً
    if Settings.Invisibility then
        task.delay(0.2, function()
            pcall(ApplyInvisibility)
        end)
    end

    -- Instant Respawn مع موقع مخصص
    if Settings.InstantRespawn and Settings.SpawnLocation then
        task.delay(0.3, function()
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(Settings.SpawnLocation)
            end
        end)
    end

    -- Auto Respawn عند الموت
    local hum = char:WaitForChild("Humanoid")
    hum.Died:Connect(function()
        if Settings.AutoRespawn then
            task.delay(1, TryRespawn)
        end
    end)

    -- Health Alert: تنبيه عند انخفاض الصحة (مع إعادة التسلح بعد الشفاء)
    hum.HealthChanged:Connect(function(health)
        if not Settings.HealthAlert then
            return
        end

        if health < Settings.HealthAlertThreshold and not HealthAlertWarned then
            HealthAlertWarned = true
            Library:Notify({
                Title = "⚠ تحذير",
                Description = "صحتك منخفضة (" .. math.floor(health) .. ")!",
                Time = 3,
            })
        elseif health >= Settings.HealthAlertThreshold then
            HealthAlertWarned = false
        end
    end)
end))

-- ==============================
-- Aimbot Alert (تنبيه عند تصويب عدو عليك)
-- ==============================
local LastAimbotAlert = {} -- [plr] = وقت آخر تنبيه

task.spawn(function()
    while not Unloaded and task.wait(0.5) do
        if Settings.AimbotAlert then
            local myHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")

            if myHead then
                local now = os.clock()

                for _, plr in ipairs(Players:GetPlayers()) do
                    if IsEnemy(plr) then
                        local char = plr.Character
                        local head = char and char:FindFirstChild("Head")
                        if head and IsAlive(char) then
                            local toMe = (myHead.Position - head.Position).Unit
                            local dot = toMe:Dot(head.CFrame.LookVector)

                            if dot > 0.93 and (LastAimbotAlert[plr] or 0) + 3 < now then
                                LastAimbotAlert[plr] = now
                                Library:Notify({
                                    Title = "⚠ تحذير",
                                    Description = plr.Name .. " يصوّب عليك!",
                                    Time = 2,
                                })
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ==============================
-- Chat Spam (يدعم TextChatService والـ Legacy)
-- ==============================
local ChatSpamWarned = false

local function SendChatMessage(message)
    -- المحاولة الأولى: TextChatService
    local ok = pcall(function()
        local bar = TextChatService.ChatInputBarConfiguration
        local channel = bar and bar.TargetTextChannel
        if not channel then
            error("no channel", 0)
        end

        channel:SendAsync(message)
    end)

    -- المحاولة الثانية: نظام الدردشة القديم
    if not ok then
        pcall(function()
            local system = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            local say = system and system:FindFirstChild("SayMessageRequest")
            if say then
                say:FireServer(message, "All")
            end
        end)
    end
end

task.spawn(function()
    while not Unloaded do
        task.wait(Settings.ChatDelay)

        if Settings.ChatSpam then
            SendChatMessage(Settings.ChatMessage)
        end
    end
end)

-- ==============================
-- Anti-AFK (يمنع الطرد التلقائي)
-- ==============================
table.insert(Connections, LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
        end)

        pcall(function()
            VirtualUser:ClickButton2(Vector2.zero)
        end)
    end
end))

-- ==============================
-- نظام ESP المتقدم (Boxes / Chams / Glow / Rainbow / Radar)
-- ==============================
local ESPCache = {} -- [plr] = { Character, BoxHighlight, ChamsHighlight, GlowHighlight, Billboard, Label }

local function DestroyESPForPlayer(plr)
    local entry = ESPCache[plr]
    if not entry then
        return
    end

    if entry.BoxHighlight then
        entry.BoxHighlight:Destroy()
    end

    if entry.ChamsHighlight then
        entry.ChamsHighlight:Destroy()
    end

    if entry.GlowHighlight then
        entry.GlowHighlight:Destroy()
    end

    if entry.Billboard then
        entry.Billboard:Destroy()
    end

    ESPCache[plr] = nil
end

local function UpdateESP()
    if not Settings.ESP then
        for plr in pairs(ESPCache) do
            DestroyESPForPlayer(plr)
        end
        return
    end

    local localChar = LocalPlayer.Character
    local espColor = Settings.RainbowESP
        and Color3.fromHSV((os.clock() * 0.4) % 1, 1, 1)
        or Settings.ESPColor

    for _, plr in ipairs(Players:GetPlayers()) do
        if IsEnemy(plr) then
            local char = plr.Character
            local head = char and char:FindFirstChild("Head")

            if char and head and IsAlive(char) then
                local entry = ESPCache[plr]
                local wantBox = Settings.ESPBoxes
                local wantChams = Settings.ESPChams
                local wantGlow = Settings.ESPGlow
                local wantText = Settings.ESPNames
                    or Settings.ESPDistance
                    or Settings.ESPHealth
                    or Settings.EnemyWeaponESP

                -- إعادة البناء فقط عند تغيّر الشكل (موت/رسباون/تبديل خيارات)
                if not entry
                    or entry.Character ~= char
                    or (entry.BoxHighlight ~= nil) ~= wantBox
                    or (entry.ChamsHighlight ~= nil) ~= wantChams
                    or (entry.GlowHighlight ~= nil) ~= wantGlow
                    or (entry.Billboard ~= nil) ~= wantText
                then
                    DestroyESPForPlayer(plr)
                    entry = { Character = char }
                    ESPCache[plr] = entry

                    if wantBox then
                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = char
                        highlight.FillTransparency = 0.7
                        highlight.OutlineTransparency = 0
                        highlight.Parent = char
                        entry.BoxHighlight = highlight
                    end

                    if wantChams then
                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = char
                        highlight.FillTransparency = 0.35
                        highlight.OutlineTransparency = 1
                        highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                        highlight.Parent = char
                        entry.ChamsHighlight = highlight
                    end

                    if wantGlow then
                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = char
                        highlight.FillTransparency = 1
                        highlight.OutlineTransparency = 0
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = char
                        entry.GlowHighlight = highlight
                    end

                    if wantText then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Adornee = head
                        billboard.Size = UDim2.fromOffset(140, 40)
                        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                        billboard.AlwaysOnTop = true
                        billboard.MaxDistance = 400
                        billboard.ClipsDescendants = false

                        local label = Instance.new("TextLabel")
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.fromScale(1, 1)
                        label.TextColor3 = Color3.new(1, 1, 1)
                        label.TextStrokeTransparency = 0
                        label.TextStrokeColor3 = Color3.new(0, 0, 0)
                        label.Font = Enum.Font.SourceSansBold
                        label.TextScaled = true
                        label.Parent = billboard

                        billboard.Parent = char
                        entry.Billboard = billboard
                        entry.Label = label
                    end
                end

                -- تحديث الألوان (يدعم Rainbow) ونصوص الاسم/المسافة/الصحة
                if entry.BoxHighlight then
                    entry.BoxHighlight.FillColor = espColor
                    entry.BoxHighlight.OutlineColor = espColor
                end

                if entry.ChamsHighlight then
                    entry.ChamsHighlight.FillColor = espColor
                end

                if entry.GlowHighlight then
                    entry.GlowHighlight.OutlineColor = espColor
                end

                if entry.Label then
                    local parts = {}
                    if Settings.ESPNames then
                        table.insert(parts, plr.Name)
                    end

                    if Settings.ESPDistance then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
                        if hrp and localHrp then
                            local dist = (hrp.Position - localHrp.Position).Magnitude
                            table.insert(parts, string.format("[%.0fm]", dist))
                        end
                    end

                    if Settings.ESPHealth then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            table.insert(parts, string.format("[%.0f%%]", hum.Health / math.max(hum.MaxHealth, 1) * 100))
                        end
                    end

                    if Settings.EnemyWeaponESP then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            table.insert(parts, "[" .. tool.Name .. "]")
                        end
                    end

                    entry.Label.Text = table.concat(parts, " ")
                end
            else
                DestroyESPForPlayer(plr)
            end
        end
    end

    for plr in pairs(ESPCache) do
        if not table.find(Players:GetPlayers(), plr) then
            DestroyESPForPlayer(plr)
        end
    end
end

-- ==============================
-- Radar (رادار مبني بعناصر GUI — يعمل في كل الإكسكيوتورات)
-- ==============================
local function CreateRadar()
    if RadarFrame then
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "AimbotRadar"
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 998

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(Settings.RadarSize, Settings.RadarSize)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromOffset(Settings.RadarPos.X, Settings.RadarPos.Y)
    frame.BackgroundColor3 = Color3.new(0.05, 0.08, 0.12)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Visible = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.1, 0)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Transparency = 0.5
    stroke.Parent = frame

    -- نقطة اللاعب المحلي في المنتصف
    local localDot = Instance.new("Frame")
    localDot.Size = UDim2.fromOffset(6, 6)
    localDot.AnchorPoint = Vector2.new(0.5, 0.5)
    localDot.Position = UDim2.fromScale(0.5, 0.5)
    localDot.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    localDot.BorderSizePixel = 0

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = localDot

    localDot.Parent = frame
    frame.Parent = gui
    gui.Parent = PlayerGui

    RadarFrame = frame
    RadarDots = {}
end

local function CreateRadarDot(plr)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(6, 6)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    dot.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = dot

    dot.Parent = RadarFrame
    RadarDots[plr] = dot
    return dot
end

local function UpdateRadar()
    if not Settings.ESPRadar then
        if RadarFrame then
            RadarFrame.Visible = false
        end
        return
    end

    CreateRadar()
    RadarFrame.Visible = true

    local size = Settings.RadarSize
    RadarFrame.Size = UDim2.fromOffset(size, size)
    RadarFrame.Position = UDim2.fromOffset(Settings.RadarPos.X, Settings.RadarPos.Y)

    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        return
    end

    local scale = (size / 2) / 100 -- نطاق الرادار: 100 ستود
    local yaw = math.atan2(Camera.CFrame.LookVector.X, Camera.CFrame.LookVector.Z)
    local cosY, sinY = math.cos(yaw), math.sin(yaw)
    local center = Vector2.new(size / 2, size / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        local dot = RadarDots[plr]

        if plr ~= LocalPlayer and plr.Character and IsAlive(plr.Character) then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local rel = root.Position - myRoot.Position
                local x = rel.X * cosY + rel.Z * sinY
                local z = -rel.X * sinY + rel.Z * cosY
                local pos = center + Vector2.new(x, z) * scale

                dot = dot or CreateRadarDot(plr)
                dot.Visible = pos.X >= 0 and pos.X <= size and pos.Y >= 0 and pos.Y <= size
                dot.Position = UDim2.fromOffset(pos.X, pos.Y)
                dot.BackgroundColor3 = IsEnemy(plr) and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(60, 255, 60)
            end
        elseif dot then
            dot.Visible = false
        end
    end
end

-- ==============================
-- Player List GUI (قائمة اللاعبين للقفل السريع)
-- ==============================
local function CreatePlayerList()
    if PlayerListGui then
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "AimbotPlayerList"
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 997

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(210, 320)
    frame.Position = UDim2.new(1, -230, 0.25, 0)
    frame.BackgroundColor3 = Color3.new(0.05, 0.06, 0.1)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.06, 0)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 28)
    title.BackgroundTransparency = 1
    title.Text = "اللاعبون — اضغط للقفل"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextStrokeTransparency = 0
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 14
    title.Parent = frame

    local scrolling = Instance.new("ScrollingFrame")
    scrolling.Position = UDim2.fromOffset(0, 28)
    scrolling.Size = UDim2.new(1, 0, 1, -28)
    scrolling.BackgroundTransparency = 1
    scrolling.BorderSizePixel = 0
    scrolling.ScrollBarThickness = 4
    scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrolling.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = scrolling

    gui.Parent = PlayerGui
    PlayerListGui = gui
    PlayerListFrame = scrolling
    PlayerListButtons = {}
    LastPlayerListCount = 0
end

local function RebuildPlayerList()
    if not PlayerListFrame then
        return
    end

    for _, btn in pairs(PlayerListButtons) do
        btn:Destroy()
    end
    PlayerListButtons = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 26)
            btn.BackgroundColor3 = Color3.fromRGB(80, 25, 25)
            btn.BorderSizePixel = 0
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextStrokeTransparency = 0.5
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 13

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0.25, 0)
            btnCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                if Settings.LockTarget == plr then
                    Settings.LockTarget = nil
                else
                    Settings.LockTarget = plr
                end

                UpdatePlayerListTexts()
            end)

            btn.Parent = PlayerListFrame
            PlayerListButtons[plr] = btn
        end
    end

    LastPlayerListCount = #Players:GetPlayers()
end

local function UpdatePlayerListTexts()
    for plr, btn in pairs(PlayerListButtons) do
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        local hp = hum and math.floor(hum.Health) or 0
        local locked = Settings.LockTarget == plr

        btn.Text = plr.Name .. " [" .. hp .. "]" .. (locked and " 🔒" or "")
        btn.BackgroundColor3 = locked
            and Color3.fromRGB(200, 160, 40)
            or (IsEnemy(plr) and Color3.fromRGB(90, 25, 25) or Color3.fromRGB(25, 90, 25))
    end
end

-- ==============================
-- Custom Crosshair (علامة تصويب مخصصة بعناصر GUI)
-- ==============================
local CrosshairParts = {} -- العناصر الأربعة + النقطة

local function CreateCrosshair()
    if CrosshairGui then
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "AimbotCrosshair"
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 996

    local container = Instance.new("Frame")
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.fromScale(0.5, 0.5)
    container.Size = UDim2.fromOffset(0, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = gui

    gui.Parent = PlayerGui
    CrosshairGui = container
    CrosshairParts = {}
end

local function UpdateCrosshair()
    if not CrosshairGui then
        return
    end

    CrosshairGui.Visible = Settings.Crosshair

    if not Settings.Crosshair then
        return
    end

    local size = Settings.CrosshairSize
    local gap = 4
    local thickness = 2
    local total = size * 2 + gap
    CrosshairGui.Size = UDim2.fromOffset(total, total)

    -- نتأكد من وجود العناصر الخمسة (نقطة + 4 خطوط)
    if #CrosshairParts == 0 then
        local color = Settings.CrosshairColor

        local dot = Instance.new("Frame")
        dot.Size = UDim2.fromOffset(4, 4)
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.fromScale(0.5, 0.5)
        dot.BackgroundColor3 = color
        dot.BorderSizePixel = 0

        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot

        dot.Parent = CrosshairGui
        table.insert(CrosshairParts, dot)

        local lineSpecs = {
            { Size = UDim2.fromOffset(thickness, size), Position = UDim2.fromOffset(0, -(gap + size)) }, -- أعلى
            { Size = UDim2.fromOffset(thickness, size), Position = UDim2.fromOffset(0, gap) },             -- أسفل
            { Size = UDim2.fromOffset(size, thickness), Position = UDim2.fromOffset(-(gap + size), 0) },   -- يسار
            { Size = UDim2.fromOffset(size, thickness), Position = UDim2.fromOffset(gap, 0) },             -- يمين
        }

        for _, spec in ipairs(lineSpecs) do
            local line = Instance.new("Frame")
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.Size = spec.Size
            line.Position = spec.Position
            line.BackgroundColor3 = color
            line.BorderSizePixel = 0
            line.Parent = CrosshairGui
            table.insert(CrosshairParts, line)
        end
    end

    -- تحديث الألوان عند تغييرها
    for _, part in ipairs(CrosshairParts) do
        part.BackgroundColor3 = Settings.CrosshairColor
    end
end

-- ==============================
-- دائرة الـ FOV (عنصر مرئي)
-- ==============================
local function CreateFOVCircle()
    if FOVCircleFrame then
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "AimbotFOVCircle"
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(Settings.FOV * 2, Settings.FOV * 2)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Transparency = 0.25
    stroke.Parent = frame

    frame.Parent = gui
    gui.Parent = PlayerGui
    FOVCircleFrame = frame
end

-- ==============================
-- حلقة تحديث الرؤية (ESP + Radar + Player List)
-- ==============================
task.spawn(function()
    CreateFOVCircle()
    CreateCrosshair()
    UpdateCrosshair()

    while not Unloaded and task.wait(0.25) do
        pcall(UpdateESP)
        pcall(UpdateRadar)

        if Settings.PlayerList then
            CreatePlayerList()
            if #Players:GetPlayers() ~= LastPlayerListCount then
                pcall(RebuildPlayerList)
            end
            pcall(UpdatePlayerListTexts)
        elseif PlayerListGui then
            PlayerListGui:Destroy()
            PlayerListGui = nil
            PlayerListFrame = nil
            PlayerListButtons = {}
        end
    end
end)

-- ==============================
-- الميزات الذكية (AI)
-- ==============================
local PathfindingService = game:GetService("PathfindingService")
local AutoPilotRunning = false

-- Auto-Pilot: تحرك تلقائي نحو أقرب عدو عبر Pathfinding
local function AutoPilotLoop()
    if AutoPilotRunning then
        return
    end

    AutoPilotRunning = true

    task.spawn(function()
        while Settings.AutoPilot and not Unloaded do
            local target = GetClosestTarget()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local myRoot = char and char:FindFirstChild("HumanoidRootPart")

            if target and hum and myRoot then
                local enemyRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                if enemyRoot then
                    local ok, path = pcall(function()
                        local p = PathfindingService:CreatePath()
                        p:ComputeAsync(myRoot.Position, enemyRoot.Position)
                        return p
                    end)

                    if ok and path and path.Status == Enum.PathStatus.Success then
                        for _, waypoint in ipairs(path:GetWaypoints()) do
                            if not Settings.AutoPilot or Unloaded then
                                break
                            end

                            hum:MoveTo(waypoint.Position)
                            if not hum.MoveToFinished:Wait(2) then
                                break
                            end
                        end
                    end
                end
            end

            task.wait(0.2)
        end

        AutoPilotRunning = false
    end)
end

-- Chat AI: رد تلقائي على رسائل محددة
local function ChatReply(message)
    if not Settings.ChatAI or typeof(message) ~= "string" then
        return
    end

    local lower = string.lower(message)
    local reply = nil

    if string.find(lower, "هاكر", 1, true) or string.find(lower, "hack", 1, true) then
        reply = "ما في هاكر، أنت بس ضعيف 😎"
    elseif string.find(lower, "noob", 1, true) then
        reply = "noob? look at your kd"
    elseif string.find(lower, "ez", 1, true) then
        reply = "ez? مبروك ما شاء الله عليك"
    end

    if reply then
        SendChatMessage(reply)
    end
end

-- نظام الدردشة الحديث
pcall(function()
    TextChatService.OnIncomingMessage:Connect(function(message)
        task.spawn(function()
            local source = message.TextSource
            if source and source ~= LocalPlayer then
                ChatReply(message.Text)
            end
        end)
    end)
end)

-- نظام الدردشة القديم
pcall(function()
    Players.PlayerChatted:Connect(function(speaker, message)
        if speaker and speaker ~= LocalPlayer then
            ChatReply(message)
        end
    end)
end)

-- ==============================
-- Auto Clicker + Macro Recorder
-- ==============================
local LastClickTime = 0

local MacroData = {}
local MacroRecording = false
local MacroStartTime = 0
local MacroConnections = {}

local function StartMacroRecording()
    if MacroRecording then
        return
    end

    MacroData = {}
    MacroRecording = true
    MacroStartTime = os.clock()

    for _, conn in ipairs(MacroConnections) do
        conn:Disconnect()
    end
    MacroConnections = {}

    table.insert(MacroConnections, UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe or input.KeyCode == Enum.KeyCode.Unknown then
            return
        end

        table.insert(MacroData, { Time = os.clock() - MacroStartTime, Key = input.KeyCode, Down = true })
    end))

    table.insert(MacroConnections, UserInputService.InputEnded:Connect(function(input, gpe)
        if gpe or input.KeyCode == Enum.KeyCode.Unknown then
            return
        end

        table.insert(MacroData, { Time = os.clock() - MacroStartTime, Key = input.KeyCode, Down = false })
    end))

    Library:Notify({ Title = "Macro", Description = "بدأ التسجيل... اضغط إيقاف التسجيل للحفظ.", Time = 3 })
end

local function StopMacroRecording()
    if not MacroRecording then
        return
    end

    MacroRecording = false

    for _, conn in ipairs(MacroConnections) do
        conn:Disconnect()
    end
    MacroConnections = {}

    Library:Notify({ Title = "Macro", Description = "تم تسجيل " .. #MacroData .. " حدث.", Time = 3 })
end

local function PlayMacro()
    if #MacroData == 0 then
        return
    end

    task.spawn(function()
        local start = os.clock()

        for _, action in ipairs(MacroData) do
            local waitTime = action.Time - (os.clock() - start)
            if waitTime > 0 then
                task.wait(waitTime)
            end

            pcall(function()
                UserInputService:SendKeyEvent(action.Down, action.Key, false, game)
            end)
        end
    end)
end

-- ==============================
-- Gravity + Infinite Jump
-- ==============================
local OriginalGravity = workspace.Gravity

table.insert(Connections, UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Jump = true
        end
    end
end))

task.spawn(function()
    while not Unloaded and task.wait(0.5) do
        if Settings.GravityEnabled and math.abs(workspace.Gravity - Settings.Gravity) > 0.1 then
            pcall(function()
                workspace.Gravity = Settings.Gravity
            end)
        end
    end
end)

-- ==============================
-- Auto-Equip Best Weapon + Command Bar
-- ==============================
local function EquipBestWeapon()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer.Backpack
    if not hum or not backpack then
        return
    end

    local bestTool, bestDamage = nil, -1

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local damage = FindWeaponValue(tool, { "Damage", "DamageValue" })
            if damage and damage.Value > bestDamage then
                bestDamage = damage.Value
                bestTool = tool
            end
        end
    end

    if bestTool then
        pcall(function()
            hum:EquipTool(bestTool)
        end)
    end
end

local function ExecuteCommand(code)
    if typeof(code) ~= "string" or code == "" then
        return
    end

    local fn, err = loadstring(code)
    if fn then
        local ok, result = pcall(fn)
        if not ok then
            Library:Notify({ Title = "Command Bar", Description = "خطأ: " .. tostring(result), Time = 5 })
        end
    else
        Library:Notify({ Title = "Command Bar", Description = "خطأ صياغة: " .. tostring(err), Time = 5 })
    end
end

-- ==============================
-- Hit Sound / Kill Sound (مراقبة صحة الأعداء)
-- ==============================
local EnemyHealthCache = {}
local SoundCache = {}

local function GetCachedSound(soundId)
    if soundId == "" then
        return nil
    end

    local sound = SoundCache[soundId]
    if not sound then
        sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Parent = game:GetService("SoundService")
        SoundCache[soundId] = sound
    end

    return sound
end

task.spawn(function()
    while not Unloaded and task.wait(0.15) do
        for _, plr in ipairs(Players:GetPlayers()) do
            if IsEnemy(plr) then
                local char = plr.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local health = hum.Health
                    local last = EnemyHealthCache[plr]

                    -- تحديث الكاش دائماً (يمنع إنذارات كاذبة عند إعادة التفعيل)
                    if last and health < last then
                        if Settings.HitSound then
                            local s = GetCachedSound(Settings.HitSoundId)
                            if s then
                                pcall(function()
                                    s:Play()
                                end)
                            end
                        end

                        if Settings.KillSound and health <= 0 then
                            local s = GetCachedSound(Settings.KillSoundId)
                            if s then
                                pcall(function()
                                    s:Play()
                                end)
                            end
                        end

                        -- تبديل السلاح تلقائياً بعد القتل
                        if Settings.AutoSwitchWeapon and health <= 0 then
                            task.delay(0.5, EquipBestWeapon)
                        end
                    end

                    EnemyHealthCache[plr] = health
                end
            end
        end
    end
end)

-- ==============================
-- Character Resizer + Rainbow Character
-- ==============================
local CharacterSizeCache = {} -- [part] = الحجم الأصلي
local CharacterColorCache = {} -- [part] = اللون الأصلي
local LastResizedCharacter = nil
local LastColoredCharacter = nil

local function ApplyCharacterResize()
    local char = LocalPlayer.Character
    if not char then
        return
    end

    if LastResizedCharacter ~= char or next(CharacterSizeCache) == nil then
        CharacterSizeCache = {}
        LastResizedCharacter = char

        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                CharacterSizeCache[part] = part.Size
            end
        end
    end

    for part, original in pairs(CharacterSizeCache) do
        if part.Parent then
            part.Size = original * Settings.CharacterSize
        end
    end
end

local function RestoreCharacterSize()
    for part, original in pairs(CharacterSizeCache) do
        if part.Parent then
            part.Size = original
        end
    end

    CharacterSizeCache = {}
    LastResizedCharacter = nil
end

local function ApplyRainbowCharacter(hue)
    local char = LocalPlayer.Character
    if not char then
        return
    end

    if LastColoredCharacter ~= char or next(CharacterColorCache) == nil then
        CharacterColorCache = {}
        LastColoredCharacter = char

        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                CharacterColorCache[part] = part.Color
            end
        end
    end

    local color = Color3.fromHSV(hue, 1, 1)

    for part, original in pairs(CharacterColorCache) do
        if part.Parent then
            part.Color = color
        end
    end
end

local function RestoreCharacterColors()
    for part, original in pairs(CharacterColorCache) do
        if part.Parent then
            part.Color = original
        end
    end

    CharacterColorCache = {}
    LastColoredCharacter = nil
end

-- ==============================
-- Name Hider + Disable Screen Effects
-- ==============================
local function ApplyNameHider()
    pcall(function()
        LocalPlayer.NameOcclusion = Settings.NameHider
            and Enum.NameOcclusion.OccludeAll
            or Enum.NameOcclusion.OccludeNone
    end)

    pcall(function()
        LocalPlayer.NameDisplayDistance = Settings.NameHider and 0 or 100
    end)
end

local Lighting = game:GetService("Lighting")

local function ApplyScreenEffects()
    local blur = Lighting:FindFirstChildOfClass("BlurEffect")
    if blur then
        blur.Size = 0
    end

    local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if cc then
        cc.TintColor = Color3.new(1, 1, 1)
        cc.Saturation = 0
        cc.Contrast = 0
        cc.Brightness = 0
    end
end

-- ==============================
-- Bullet Tracers (يتطلب مكتبة Drawing)
-- ==============================
local function CreateTracer(fromWorld, toWorld)
    if not Settings.BulletTracers then
        return
    end

    pcall(function()
        local line = Drawing.new("Line")
        line.From = Camera:WorldToViewportPoint(fromWorld)
        line.To = Camera:WorldToViewportPoint(toWorld)
        line.Color = Color3.new(1, 1, 0)
        line.Thickness = 1
        line.Visible = true

        task.delay(0.1, function()
            pcall(function()
                line:Remove()
            end)
        end)
    end)
end

-- ==============================
-- الميزات الخارقة
-- ==============================
local function KillAll()
    local found = false

    pcall(function()
        for _, child in ipairs(ReplicatedStorage:GetDescendants()) do
            if child:IsA("RemoteEvent") and string.find(string.lower(child.Name), "damage", 1, true) then
                found = true

                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if hum then
                            pcall(function()
                                child:FireServer(hum, 99999)
                            end)
                        end
                    end
                end

                break
            end
        end
    end)

    if not found then
        Library:Notify({
            Title = "Kill All",
            Description = "لم يُعثر على ريموت ضرر — عدّل اسم الريموت في دالة KillAll في الكود.",
            Time = 5,
        })
    end
end

local function ApplyLagSwitch()
    pcall(function()
        game:GetService("NetworkClient"):SetOutgoingKBPSLimit(Settings.LagSwitch and 1 or 100000)
    end)
end

local function ApplyFPSUnlocker()
    if Settings.FPSUnlocker then
        pcall(function()
            setfpscap(999)
        end)
        pcall(function()
            settings():GetService("RenderSettings").FrameRateCap = 999
        end)
    else
        pcall(function()
            setfpscap(60)
        end)
        pcall(function()
            settings():GetService("RenderSettings").FrameRateCap = 60
        end)
    end
end

local function SetRageMode(state)
    Toggles.Aimbot:SetValue(state)
    Toggles.SilentAim:SetValue(state)
    Toggles.AutoShoot:SetValue(state)
    Toggles.KillAura:SetValue(state)
    Toggles.RapidFire:SetValue(state)
    Toggles.NoRecoil:SetValue(state)
    Toggles.NoSpread:SetValue(state)
    Toggles.InfiniteAmmo:SetValue(state)
    Toggles.InstantReload:SetValue(state)
    Toggles.MagicBullet:SetValue(state)
    Toggles.Prediction:SetValue(state)
end

-- إحياء الزملاء تلقائياً (يبحث عن ريموت revive بالاسم)
task.spawn(function()
    while not Unloaded and task.wait(3) do
        if Settings.AutoRevive then
            pcall(function()
                for _, child in ipairs(ReplicatedStorage:GetDescendants()) do
                    if (child:IsA("RemoteEvent") or child:IsA("RemoteFunction"))
                        and string.find(string.lower(child.Name), "revive", 1, true)
                    then
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and not IsEnemy(plr) and plr.Character then
                                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                                if hum then
                                    if child:IsA("RemoteEvent") then
                                        child:FireServer(hum)
                                    else
                                        child:InvokeServer(hum)
                                    end
                                end
                            end
                        end

                        break
                    end
                end
            end)
        end
    end
end)

-- ==============================
-- حلقة الميزات الذكية والحركية
-- ==============================
local RainbowHue = 0

table.insert(Connections, RunService.RenderStepped:Connect(function(dt)
    local now = os.clock()

    -- Auto Clicker
    if Settings.AutoClicker and now - LastClickTime >= 1 / math.max(Settings.ClickRate, 1) then
        LastClickTime = now
        task.spawn(ClickMouse)
    end

    -- Auto Dodge: تحرك عمودياً على اتجاه أقرب عدو
    if Settings.AutoDodge then
        local target = GetClosestTarget()
        if target then
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local enemyRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")

            if myRoot and enemyRoot and hum then
                local direction = (enemyRoot.Position - myRoot.Position).Unit
                local dodge = direction:Cross(Vector3.new(0, 1, 0)).Unit
                hum:Move(dodge, false)
            end
        end
    end

    -- Dynamic FOV: يتسع حسب عدد الأعداء على الشاشة
    if Settings.DynamicFOV then
        local count = 0

        for _, plr in ipairs(Players:GetPlayers()) do
            if IsEnemy(plr) then
                local char = plr.Character
                local head = char and char:FindFirstChild("Head")
                if head then
                    local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        count = count + 1
                    end
                end
            end
        end

        Settings.FOV = math.clamp(100 + count * 30, 100, 400)
    end

    -- Rainbow Character
    if Settings.RainbowChar then
        RainbowHue = (RainbowHue + dt * 120) % 1
        pcall(ApplyRainbowCharacter, RainbowHue)
    end
end))

-- NoClip 2.0: يعطل التصادم فقط أثناء الحركة (يبقيك "واقعياً" معظم الوقت)
local Noclip2State = false

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.Noclip2 then
        if Noclip2State then
            Noclip2State = false
            pcall(RestoreNoclip)
        end

        return
    end

    local moving = UserInputService:IsKeyDown(Enum.KeyCode.W)
        or UserInputService:IsKeyDown(Enum.KeyCode.A)
        or UserInputService:IsKeyDown(Enum.KeyCode.S)
        or UserInputService:IsKeyDown(Enum.KeyCode.D)

    if moving ~= Noclip2State then
        Noclip2State = moving

        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not moving
                end
            end
        end
    end
end))

-- حلقة تطبيق الميزات البطيئة (Name Hider / Screen Effects / Equip / Resizer)
task.spawn(function()
    while not Unloaded and task.wait(1) do
        if Settings.NameHider then
            pcall(ApplyNameHider)
        end

        if Settings.NoScreenEffects then
            pcall(ApplyScreenEffects)
        end

        if Settings.AutoEquipBest then
            pcall(EquipBestWeapon)
        end

        if Settings.CharacterResizer then
            pcall(ApplyCharacterResize)
        end
    end
end)

-- ==============================
-- بناء واجهة Cyan
-- ==============================
local Window = Library:CreateWindow({
    Title = "اللواء | Cyan",
    Footer = "Aimbot + Exclusive Pack — Cyan",
    NotifySide = "Right",
    ShowCustomCursor = true,
    AutoShow = true,
})

-- ---- تبويب الإيمبوت ----
local AimbotTab = Window:AddTab("الإيمبوت", "crosshair")
local AimbotGroup = AimbotTab:AddLeftGroupbox("الإيمبوت", "crosshair")
local LockGroup = AimbotTab:AddLeftGroupbox("قفل الهدف والأولوية", "lock")
local TriggerGroup = AimbotTab:AddRightGroupbox("الإطلاق التلقائي", "zap")

local AimbotToggle = AimbotGroup:AddToggle("Aimbot", {
    Text = "الإيمبوت",
    Default = false,
    Tooltip = "تصويب تلقائي على أقرب هدف. اضغط Q للتفعيل السريع،\nويمكنك التحويل لوضع Hold من قائمة الزر الأيمن.",
    Callback = function(value)
        Settings.Aimbot = value
    end,
})

AimbotToggle:AddKeyPicker("AimbotKeybind", {
    Default = "Q",
    Mode = "Toggle",
    SyncToggleState = true,
    Text = "زر الإيمبوت",
})

local AimlockToggle = AimbotGroup:AddToggle("Aimlock", {
    Text = "Aimlock (تصويب فوري)",
    Default = false,
    Tooltip = "تصويب فوري (Snap) على أقرب رأس دون نعومة.\nالوضع الافتراضي: اضغط باستمرار على E،\nويمكن التحويل لوضع Always من قائمة الزر الأيمن.",
    Callback = function(value)
        Settings.Aimlock = value
    end,
})

AimlockToggle:AddKeyPicker("AimlockKeybind", {
    Default = "E",
    Mode = "Hold",
    Modes = { "Always", "Hold" },
    SyncToggleState = false,
    Text = "زر الـ Aimlock",
})

AimbotGroup:AddToggle("SilentAim", {
    Text = "سايلنت إيم",
    Default = false,
    Tooltip = "يغيّر نقطة الإصابة دون تحريك الكاميرا (يتطلب إكسكيوتوراً يدعم خطاف metamethod).",
    Callback = function(value)
        Settings.SilentAim = value
        if value then
            InstallSilentAimHook()
        end
    end,
})

AimbotGroup:AddSlider("Smoothness", {
    Text = "النعومة",
    Default = 3,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(value)
        Settings.Smoothness = value
    end,
})

AimbotGroup:AddSlider("AimbotFOV", {
    Text = "زاوية الرؤية (FOV)",
    Default = 200,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Suffix = "px",
    Callback = function(value)
        Settings.FOV = value
    end,
})

AimbotGroup:AddToggle("FOVCircle", {
    Text = "دائرة الـ FOV",
    Default = false,
    Callback = function(value)
        Settings.FOVCircle = value
    end,
})

AimbotGroup:AddToggle("Prediction", {
    Text = "التوقع (Prediction)",
    Default = false,
    Callback = function(value)
        Settings.Prediction = value
    end,
})

AimbotGroup:AddSlider("PredictionAmount", {
    Text = "معامل التوقع",
    Default = 0.15,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(value)
        Settings.PredictionAmount = value
    end,
})

LockGroup:AddToggle("TargetLock", {
    Text = "قفل الهدف (Target Lock)",
    Default = false,
    Tooltip = "يثبّت التصويب على لاعب واحد محدد. اختر اللاعب من قائمة اللاعبين\nأو عبر ToggleLockTarget من الكود.",
    Callback = function(value)
        if not value then
            Settings.LockTarget = nil
        end
    end,
})

LockGroup:AddButton("إلغاء القفل", function()
    Settings.LockTarget = nil
    Toggles.TargetLock:SetValue(false)
end)

LockGroup:AddToggle("PlayerList", {
    Text = "قائمة اللاعبين",
    Default = false,
    Tooltip = "قائمة بجميع اللاعبين (يمين الشاشة) — اضغط على اسم للقفل عليه،\nواضغط مرة أخرى لفك القفل.",
    Callback = function(value)
        Settings.PlayerList = value
    end,
})

LockGroup:AddDropdown("HitPart", {
    Text = "مكان الإصابة",
    Values = { "الرأس", "الجذع", "الأرجل", "عشوائي" },
    Default = "الرأس",
    AllowNull = false,
    Callback = function(value)
        Settings.HitPart = value
    end,
})

LockGroup:AddDropdown("TargetPriority", {
    Text = "أولوية الهدف",
    Values = { "الأقرب للمؤشر", "الأقرب مسافة", "أقل صحة" },
    Default = "الأقرب للمؤشر",
    AllowNull = false,
    Callback = function(value)
        Settings.TargetPriority = value
    end,
})

LockGroup:AddToggle("WallCheck", {
    Text = "تجاهل خلف الجدران",
    Default = false,
    Tooltip = "فحص إشعاعي: لن يُلتقط هدف محجوب بجدار\n(تعطله Magic Bullet تلقائياً لأنها تعمل كـ Wallbang).",
    Callback = function(value)
        Settings.WallCheck = value
    end,
})

LockGroup:AddToggle("AimbotTeamCheck", {
    Text = "تجاهل الفريق",
    Default = true,
    Callback = function(value)
        Settings.TeamCheck = value
    end,
})

TriggerGroup:AddToggle("TriggerBot", {
    Text = "التريقر بوت",
    Default = false,
    Tooltip = "إطلاق تلقائي عند وقوع الكرسير على الهدف.",
    Callback = function(value)
        Settings.TriggerBot = value
    end,
})

TriggerGroup:AddToggle("AutoShoot", {
    Text = "Auto Shoot",
    Default = false,
    Tooltip = "إطلاق تلقائي عند وجود هدف داخل زاوية التصويب\n(يتطلب تفعيل الإيمبوت أو الـ Aimlock).",
    Callback = function(value)
        Settings.AutoShoot = value
    end,
})

TriggerGroup:AddSlider("TriggerDelay", {
    Text = "سرعة الإطلاق",
    Default = 0.08,
    Min = 0.03,
    Max = 0.3,
    Rounding = 2,
    Suffix = "ث",
    Callback = function(value)
        Settings.TriggerDelay = value
    end,
})

TriggerGroup:AddDivider()

TriggerGroup:AddToggle("KillAura", {
    Text = "Kill Aura (هالة القتل)",
    Default = false,
    Tooltip = "يستهدف ويطلق تلقائياً على كل عدو داخل النطاق.\n(نسخة عامة — القتل الفوري الحقيقي يتطلب ريموتات اللعبة).",
    Callback = function(value)
        Settings.KillAura = value
    end,
})

TriggerGroup:AddSlider("KillAuraRange", {
    Text = "نطاق الهالة",
    Default = 30,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Suffix = "ستود",
    Callback = function(value)
        Settings.KillAuraRange = value
    end,
})

TriggerGroup:AddSlider("KillAuraDelay", {
    Text = "سرعة الهالة",
    Default = 0.1,
    Min = 0.05,
    Max = 0.5,
    Rounding = 2,
    Suffix = "ث",
    Callback = function(value)
        Settings.KillAuraDelay = value
    end,
})

-- ---- تبويب الرؤية ----
local VisualsTab = Window:AddTab("الرؤية", "eye")
local VisualsGroup = VisualsTab:AddLeftGroupbox("ESP", "eye")
local CrosshairGroup = VisualsTab:AddRightGroupbox("علامة التصويب", "crosshair")

local EspToggle = VisualsGroup:AddToggle("ESP", {
    Text = "تفعيل الـ ESP",
    Default = false,
    Tooltip = "عرض معلومات الأعداء. اضغط C للتفعيل السريع.",
    Callback = function(value)
        Settings.ESP = value
        UpdateESP()
    end,
})

EspToggle:AddKeyPicker("ESPKeybind", {
    Default = "C",
    Mode = "Toggle",
    SyncToggleState = true,
    Text = "زر الـ ESP",
})

EspToggle:AddColorPicker("ESPColor", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "لون الـ ESP",
    Callback = function(value)
        Settings.ESPColor = value
        UpdateESP()
    end,
})

VisualsGroup:AddToggle("RainbowESP", {
    Text = "Rainbow ESP",
    Default = false,
    Tooltip = "تلون متغير مستمر لألوان الـ ESP.",
    Callback = function(value)
        Settings.RainbowESP = value
    end,
})

VisualsGroup:AddToggle("ESPBoxes", {
    Text = "إطارات (Boxes)",
    Default = false,
    Callback = function(value)
        Settings.ESPBoxes = value
        UpdateESP()
    end,
})

VisualsGroup:AddToggle("ESPChams", {
    Text = "Chams (تلوين الجسم)",
    Default = false,
    Callback = function(value)
        Settings.ESPChams = value
        UpdateESP()
    end,
})

VisualsGroup:AddToggle("ESPGlow", {
    Text = "Glow (توهج)",
    Default = false,
    Callback = function(value)
        Settings.ESPGlow = value
        UpdateESP()
    end,
})

VisualsGroup:AddToggle("ESPNames", {
    Text = "أسماء اللاعبين",
    Default = false,
    Callback = function(value)
        Settings.ESPNames = value
        UpdateESP()
    end,
})

VisualsGroup:AddToggle("ESPDistance", {
    Text = "المسافة",
    Default = false,
    Callback = function(value)
        Settings.ESPDistance = value
        UpdateESP()
    end,
})

VisualsGroup:AddToggle("ESPHealth", {
    Text = "نسبة الصحة",
    Default = false,
    Callback = function(value)
        Settings.ESPHealth = value
        UpdateESP()
    end,
})

VisualsGroup:AddToggle("ESPRadar", {
    Text = "رادار",
    Default = false,
    Tooltip = "رادار مصغّر يعرض مواقع الأعداء حولك (يتجه مع الكاميرا).",
    Callback = function(value)
        Settings.ESPRadar = value
    end,
})

VisualsGroup:AddSlider("RadarSize", {
    Text = "حجم الرادار",
    Default = 150,
    Min = 100,
    Max = 250,
    Rounding = 0,
    Callback = function(value)
        Settings.RadarSize = value
    end,
})

VisualsGroup:AddToggle("ESPTeamCheck", {
    Text = "تجاهل الفريق",
    Default = true,
    Callback = function(value)
        Settings.TeamCheck = value
        UpdateESP()
    end,
})

local CrosshairToggle = CrosshairGroup:AddToggle("Crosshair", {
    Text = "علامة تصويب مخصصة",
    Default = false,
    Tooltip = "علامة + أربعة خطوط في منتصف الشاشة (تعمل في كل الإكسكيوتورات).",
    Callback = function(value)
        Settings.Crosshair = value
        UpdateCrosshair()
    end,
})

CrosshairToggle:AddColorPicker("CrosshairColor", {
    Default = Color3.fromRGB(0, 255, 0),
    Title = "لون العلامة",
    Callback = function(value)
        Settings.CrosshairColor = value
        UpdateCrosshair()
    end,
})

CrosshairGroup:AddSlider("CrosshairSize", {
    Text = "حجم العلامة",
    Default = 10,
    Min = 4,
    Max = 30,
    Rounding = 0,
    Callback = function(value)
        Settings.CrosshairSize = value
        UpdateCrosshair()
    end,
})

-- ---- تبويب الأسلحة ----
local WeaponsTab = Window:AddTab("الأسلحة", "shield")
local WeaponsGroup = WeaponsTab:AddLeftGroupbox("تعديلات السلاح", "shield")
local BulletsGroup = WeaponsTab:AddRightGroupbox("الرصاص والإطلاق", "zap")

WeaponsGroup:AddLabel("أسماء القيم الداخلية (Spread/FireRate/ReloadTime/Ammo/Recoil...) تختلف من لعبة لأخرى — عدّلها في دوال FindWeaponValue و FindAmmoValue و FindRecoilValue في الكود.", true)

WeaponsGroup:AddToggle("NoRecoil", {
    Text = "منع الارتداد",
    Default = false,
    Callback = function(value)
        Settings.NoRecoil = value
        ApplyNoRecoil()
    end,
})

WeaponsGroup:AddToggle("NoSpread", {
    Text = "إلغاء التشتت (No Spread)",
    Default = false,
    Callback = function(value)
        Settings.NoSpread = value
    end,
})

WeaponsGroup:AddToggle("RapidFire", {
    Text = "سرعة إطلاق مضاعفة",
    Default = false,
    Callback = function(value)
        Settings.RapidFire = value
    end,
})

WeaponsGroup:AddSlider("RapidFireMultiplier", {
    Text = "مضاعف السرعة",
    Default = 5,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Suffix = "x",
    Callback = function(value)
        Settings.RapidFireMultiplier = value
    end,
})

WeaponsGroup:AddToggle("InstantReload", {
    Text = "تعبئة فورية",
    Default = false,
    Callback = function(value)
        Settings.InstantReload = value
    end,
})

WeaponsGroup:AddToggle("InfiniteAmmo", {
    Text = "ذخيرة لا نهائية",
    Default = false,
    Callback = function(value)
        Settings.InfiniteAmmo = value
        ApplyInfiniteAmmo()
    end,
})

WeaponsGroup:AddToggle("NoAnimation", {
    Text = "No Animation",
    Default = false,
    Tooltip = "إيقاف كل أنيميشن الشخصية (سلاح/حركة) — يمنح سرعة استجابة أعلى.",
    Callback = function(value)
        Settings.NoAnimation = value
    end,
})

WeaponsGroup:AddToggle("NoWeaponBob", {
    Text = "No Weapon Bob",
    Default = false,
    Tooltip = "إيقاف أنيميشن اهتزاز السلاح (idle/bob) فقط.",
    Callback = function(value)
        Settings.NoWeaponBob = value
    end,
})

BulletsGroup:AddToggle("MagicBullet", {
    Text = "الرصاصة السحرية (Magic Bullet)",
    Default = false,
    Tooltip = "الرصاصات تنحني نحو الهدف + تجاهل الجدران (Wallbang).\nيتطلب أن تكون رصاصات اللعبة أجزاء تحمل Attribute باسم Creator.",
    Callback = function(value)
        Settings.MagicBullet = value
    end,
})

BulletsGroup:AddToggle("AutoReload", {
    Text = "Auto Reload",
    Default = false,
    Tooltip = "تعبئة تلقائية عند نفاد الذخيرة (محاكاة زر R + محاولة ريموت Reload).",
    Callback = function(value)
        Settings.AutoReload = value
    end,
})

BulletsGroup:AddToggle("AutoShoot", {
    Text = "Auto Shoot",
    Default = false,
    Tooltip = "إطلاق تلقائي عند وجود هدف داخل زاوية التصويب.",
    Callback = function(value)
        Settings.AutoShoot = value
    end,
})

-- ---- تبويب الحركة ----
local MoveTab = Window:AddTab("الحركة", "move")
local MoveGroup = MoveTab:AddLeftGroupbox("حركة", "move")
local AntiAimGroup = MoveTab:AddRightGroupbox("مكافحة التصويب", "shield")

MoveGroup:AddToggle("Fly", {
    Text = "طيران (Fly)",
    Default = false,
    Tooltip = "WASD للحركة، Space للأعلى، Ctrl للأسفل.\nقد يُكتشف بسهولة — استخدمه بحذر.",
    Callback = function(value)
        Settings.Fly = value
    end,
})

MoveGroup:AddSlider("FlySpeed", {
    Text = "سرعة الطيران",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(value)
        Settings.FlySpeed = value
    end,
})

MoveGroup:AddToggle("Noclip", {
    Text = "اختراق الجدران (Noclip)",
    Default = false,
    Tooltip = "إلغاء التصادم عن جسمك — قد يُكتشف بسهولة.",
    Callback = function(value)
        Settings.Noclip = value
    end,
})

MoveGroup:AddToggle("SpeedHack", {
    Text = "سرعة مضاعفة (Speed Hack)",
    Default = false,
    Callback = function(value)
        Settings.SpeedHack = value
    end,
})

MoveGroup:AddSlider("SpeedMultiplier", {
    Text = "مضاعف السرعة",
    Default = 2,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Suffix = "x",
    Callback = function(value)
        Settings.SpeedMultiplier = value
    end,
})

MoveGroup:AddToggle("BunnyHop", {
    Text = "Auto Bunny Hop",
    Default = false,
    Tooltip = "قفز تلقائي متواصل أثناء الضغط على Space أو W.",
    Callback = function(value)
        Settings.BunnyHop = value
    end,
})

MoveGroup:AddToggle("NoFallDamage", {
    Text = "لا ضرر سقوط",
    Default = false,
    Tooltip = "تعطيل حالة السقوط المؤذية (HumanoidStateType.FallingDown).",
    Callback = function(value)
        Settings.NoFallDamage = value
        NoFallDamageState = nil
    end,
})

MoveGroup:AddToggle("ThirdPerson", {
    Text = "منظور الشخص الثالث",
    Default = false,
    Tooltip = "إزاحة الكاميرا خلف الشخصية (قد لا يعمل في الألعاب المقفلة على الشخص الأول).",
    Callback = function(value)
        Settings.ThirdPerson = value
    end,
})

MoveGroup:AddSlider("ThirdPersonDistance", {
    Text = "مسافة المنظور",
    Default = 10,
    Min = 4,
    Max = 25,
    Rounding = 1,
    Callback = function(value)
        Settings.ThirdPersonDistance = value
    end,
})

MoveGroup:AddToggle("Invisibility", {
    Text = "تخفي (Invisibility)",
    Default = false,
    Tooltip = "شفافية جسمك (Client-Side فقط — السيرفر قد يراك).",
    Callback = function(value)
        Settings.Invisibility = value
        ApplyInvisibility()
    end,
})

MoveGroup:AddDivider()

MoveGroup:AddButton("تيليبورت إلى الماوس", TeleportToMouse)
MoveGroup:AddButton("تيليبورت إلى أقرب غطاء", TeleportToCover)

AntiAimGroup:AddToggle("Spinbot", {
    Text = "Spinbot",
    Default = false,
    Tooltip = "دوران سريع للشخصية لتفادي ضربات الرأس.",
    Callback = function(value)
        Settings.Spinbot = value
    end,
})

AntiAimGroup:AddSlider("SpinSpeed", {
    Text = "سرعة الدوران",
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Suffix = "لفة/ث",
    Callback = function(value)
        Settings.SpinSpeed = value
    end,
})

AntiAimGroup:AddDropdown("SpinAxis", {
    Text = "محور الدوران",
    Values = { "X", "Y", "Z" },
    Default = "Y",
    AllowNull = false,
    Callback = function(value)
        Settings.SpinAxis = value
    end,
})

AntiAimGroup:AddToggle("AntiAimJitter", {
    Text = "Anti-Aim Jitter",
    Default = false,
    Tooltip = "يدير ظهرك للكاميرا مع اهتزاز عشوائي لإفساد التصويب عليك.",
    Callback = function(value)
        Settings.AntiAimJitter = value
    end,
})

AntiAimGroup:AddSlider("JitterAngle", {
    Text = "زاوية الاهتزاز",
    Default = 15,
    Min = 1,
    Max = 45,
    Rounding = 0,
    Suffix = "°",
    Callback = function(value)
        Settings.JitterAngle = value
    end,
})

AntiAimGroup:AddToggle("AimbotAlert", {
    Text = "تنبيه عند تصويب عدو عليك",
    Default = false,
    Tooltip = "إشعار عند وجود عدو ينظر إليك مباشرة.",
    Callback = function(value)
        Settings.AimbotAlert = value
    end,
})

-- ---- تبويب أخرى ----
local MiscTab = Window:AddTab("أخرى", "wrench")
local MiscGroup = MiscTab:AddLeftGroupbox("متنوع", "wrench")
local SurvivalGroup = MiscTab:AddRightGroupbox("بقاء وذكاء", "heart")

MiscGroup:AddToggle("FOVChanger", {
    Text = "تغيير مجال الرؤية (FOV Changer)",
    Default = false,
    Callback = function(value)
        Settings.FOVChanger = value
    end,
})

MiscGroup:AddSlider("FOVValue", {
    Text = "قيمة مجال الرؤية",
    Default = 70,
    Min = 40,
    Max = 120,
    Rounding = 0,
    Suffix = "°",
    Callback = function(value)
        Settings.FOVValue = value
    end,
})

MiscGroup:AddSlider("TimeScale", {
    Text = "Time Scale (محلي)",
    Default = 1,
    Min = 0.5,
    Max = 2,
    Rounding = 1,
    Suffix = "x",
    Tooltip = "تسريع/إبطاء محلي (يؤثر على الأصوات فقط — الوقت الحقيقي لا يتغير).",
    Callback = function(value)
        Settings.TimeScale = value
    end,
})

MiscGroup:AddToggle("SoundAmplifier", {
    Text = "تضخيم الأصوات",
    Default = false,
    Tooltip = "رفع صوت خطوات وأصوات الشخصيات (محلي فقط).",
    Callback = function(value)
        Settings.SoundAmplifier = value
    end,
})

MiscGroup:AddToggle("ChatSpam", {
    Text = "Chat Spammer",
    Default = false,
    Tooltip = "إرسال رسالة بشكل متكرر (يدعم TextChatService والـ Legacy).",
    Callback = function(value)
        Settings.ChatSpam = value
    end,
})

MiscGroup:AddInput("ChatMessage", {
    Text = "نص الرسالة",
    Default = Settings.ChatMessage,
    ClearTextOnFocus = true,
    Callback = function(value)
        Settings.ChatMessage = value
    end,
})

MiscGroup:AddSlider("ChatDelay", {
    Text = "الفاصل بين الرسائل",
    Default = 2,
    Min = 0.5,
    Max = 10,
    Rounding = 1,
    Suffix = "ث",
    Callback = function(value)
        Settings.ChatDelay = value
    end,
})

MiscGroup:AddToggle("AntiAFK", {
    Text = "Anti-AFK",
    Default = false,
    Tooltip = "يمنع الطرد التلقائي بسبب عدم النشاط.",
    Callback = function(value)
        Settings.AntiAFK = value
    end,
})

SurvivalGroup:AddToggle("AutoHeal", {
    Text = "Auto Heal",
    Default = false,
    Tooltip = "استخدام أداة الشفاء تلقائياً عند انخفاض الصحة\n(يبحث عن أدوات أسماؤها تحتوي med/heal/kit...).",
    Callback = function(value)
        Settings.AutoHeal = value
    end,
})

SurvivalGroup:AddSlider("HealThreshold", {
    Text = "حد الشفاء",
    Default = 50,
    Min = 10,
    Max = 90,
    Rounding = 0,
    Suffix = "%",
    Callback = function(value)
        Settings.HealThreshold = value
    end,
})

SurvivalGroup:AddToggle("AutoRespawn", {
    Text = "Auto Respawn",
    Default = false,
    Tooltip = "محاولة إعادة إحياء فورية بعد الموت (يبحث عن ريموت Respawn بالاسم).",
    Callback = function(value)
        Settings.AutoRespawn = value
    end,
})

SurvivalGroup:AddToggle("InstantRespawn", {
    Text = "إعادة ظهور بموقع مخصص",
    Default = false,
    Tooltip = "نقل الشخصية إلى موقع مخصص بعد كل إعادة ظهور.\nحدد الموقع عبر SetSpawnLocation من الكود.",
    Callback = function(value)
        Settings.InstantRespawn = value
    end,
})

SurvivalGroup:AddToggle("AutoCollect", {
    Text = "Auto Collect (تجريبي)",
    Default = false,
    Tooltip = "انتقال تلقائي إلى أقرب جزء تشير أسماؤه إلى موارد\n(coin/crate/supply...) — تجريبي ويعتمد على أسماء الأجزاء في اللعبة.",
    Callback = function(value)
        Settings.AutoCollect = value
    end,
})

MiscGroup:AddDivider()

MiscGroup:AddButton("إعادة تعيين كل الإعدادات", function()
    Toggles.Aimbot:SetValue(false)
    Toggles.Aimlock:SetValue(false)
    Toggles.SilentAim:SetValue(false)
    Options.Smoothness:SetValue(3)
    Options.AimbotFOV:SetValue(200)
    Toggles.FOVCircle:SetValue(false)
    Toggles.Prediction:SetValue(false)
    Options.PredictionAmount:SetValue(0.15)
    Toggles.TargetLock:SetValue(false)
    Toggles.PlayerList:SetValue(false)
    Options.HitPart:SetValue("الرأس")
    Options.TargetPriority:SetValue("الأقرب للمؤشر")
    Toggles.WallCheck:SetValue(false)
    Toggles.AimbotTeamCheck:SetValue(true)
    Toggles.TriggerBot:SetValue(false)
    Toggles.AutoShoot:SetValue(false)
    Options.TriggerDelay:SetValue(0.08)
    Toggles.KillAura:SetValue(false)
    Options.KillAuraRange:SetValue(30)
    Options.KillAuraDelay:SetValue(0.1)
    Toggles.ESP:SetValue(false)
    Toggles.RainbowESP:SetValue(false)
    Toggles.ESPBoxes:SetValue(false)
    Toggles.ESPChams:SetValue(false)
    Toggles.ESPGlow:SetValue(false)
    Toggles.ESPNames:SetValue(false)
    Toggles.ESPDistance:SetValue(false)
    Toggles.ESPHealth:SetValue(false)
    Toggles.ESPRadar:SetValue(false)
    Options.RadarSize:SetValue(150)
    Toggles.ESPTeamCheck:SetValue(true)
    Toggles.Crosshair:SetValue(false)
    Options.CrosshairSize:SetValue(10)
    Toggles.NoRecoil:SetValue(false)
    Toggles.NoSpread:SetValue(false)
    Toggles.RapidFire:SetValue(false)
    Options.RapidFireMultiplier:SetValue(5)
    Toggles.InstantReload:SetValue(false)
    Toggles.InfiniteAmmo:SetValue(false)
    Toggles.NoAnimation:SetValue(false)
    Toggles.NoWeaponBob:SetValue(false)
    Toggles.MagicBullet:SetValue(false)
    Toggles.AutoReload:SetValue(false)
    Toggles.Fly:SetValue(false)
    Options.FlySpeed:SetValue(50)
    Toggles.Noclip:SetValue(false)
    Toggles.SpeedHack:SetValue(false)
    Options.SpeedMultiplier:SetValue(2)
    Toggles.BunnyHop:SetValue(false)
    Toggles.NoFallDamage:SetValue(false)
    Toggles.ThirdPerson:SetValue(false)
    Options.ThirdPersonDistance:SetValue(10)
    Toggles.Invisibility:SetValue(false)
    Toggles.Spinbot:SetValue(false)
    Options.SpinSpeed:SetValue(5)
    Options.SpinAxis:SetValue("Y")
    Toggles.AntiAimJitter:SetValue(false)
    Options.JitterAngle:SetValue(15)
    Toggles.AimbotAlert:SetValue(false)
    Toggles.FOVChanger:SetValue(false)
    Options.FOVValue:SetValue(70)
    Options.TimeScale:SetValue(1)
    Toggles.SoundAmplifier:SetValue(false)
    Toggles.ChatSpam:SetValue(false)
    Options.ChatMessage:SetValue("أنا الأفضل في اللواء!")
    Options.ChatDelay:SetValue(2)
    Toggles.AntiAFK:SetValue(false)
    Toggles.AutoHeal:SetValue(false)
    Options.HealThreshold:SetValue(50)
    Toggles.AutoRespawn:SetValue(false)
    Toggles.InstantRespawn:SetValue(false)
    Toggles.AutoCollect:SetValue(false)
    Toggles.AIPriority:SetValue(false)
    Toggles.AdaptiveSmoothness:SetValue(false)
    Toggles.AIPrediction:SetValue(false)
    Toggles.AutoDodge:SetValue(false)
    Toggles.DynamicFOV:SetValue(false)
    Toggles.ChatAI:SetValue(false)
    Toggles.AutoPilot:SetValue(false)
    Toggles.SmartTrigger:SetValue(false)
    Toggles.AutoClicker:SetValue(false)
    Options.ClickRate:SetValue(10)
    Toggles.Gravity:SetValue(false)
    Options.GravityValue:SetValue(196.2)
    Toggles.InfiniteJump:SetValue(false)
    Toggles.ZoomHack:SetValue(false)
    Options.ZoomLevel:SetValue(2)
    Toggles.HitSound:SetValue(false)
    Toggles.KillSound:SetValue(false)
    Toggles.CharacterResizer:SetValue(false)
    Options.CharacterSize:SetValue(1)
    Toggles.RainbowChar:SetValue(false)
    Toggles.NameHider:SetValue(false)
    Toggles.NoScreenEffects:SetValue(false)
    Toggles.AutoEquipBest:SetValue(false)
    Toggles.Noclip2:SetValue(false)
    Toggles.LagSwitch:SetValue(false)
    Toggles.FPSUnlocker:SetValue(false)
    Toggles.AutoSwitchWeapon:SetValue(false)
    Toggles.BulletTracers:SetValue(false)
    Toggles.EnemyWeaponESP:SetValue(false)
    Toggles.HealthAlert:SetValue(false)
    Options.HealthAlertThreshold:SetValue(30)
    Toggles.AutoRevive:SetValue(false)
end)

-- ---- تبويب الذكاء الاصطناعي ----
local AITab = Window:AddTab("الذكاء", "brain")
local AIGroup = AITab:AddLeftGroupbox("ذكاء التصويب", "brain")
local PilotGroup = AITab:AddRightGroupbox("قيادة وردود", "bot")

AIGroup:AddToggle("AIPriority", {
    Text = "أولوية بالتهديد (AI)",
    Default = false,
    Tooltip = "يختار الهدف الأكثر خطورة أولاً: من يصوب عليك + الأقرب + الأقل صحة.",
    Callback = function(value)
        Settings.AIPriority = value
    end,
})

AIGroup:AddToggle("AdaptiveSmoothness", {
    Text = "نعومة متكيفة",
    Default = false,
    Tooltip = "ناعم جداً عن قرب (10) وسريع عن بعد (2) تلقائياً.",
    Callback = function(value)
        Settings.AdaptiveSmoothness = value
    end,
})

AIGroup:AddToggle("AIPrediction", {
    Text = "AI Prediction 2.0",
    Default = false,
    Tooltip = "توقع متقدم: السرعة + التسارع + تصحيح السقوط الحر.\n(أقوى من التوقع العادي ويعمل بدلاً عنه).",
    Callback = function(value)
        Settings.AIPrediction = value
    end,
})

AIGroup:AddToggle("AutoDodge", {
    Text = "Auto-Dodge",
    Default = false,
    Tooltip = "تحرك جانبي مستمر عمودياً على اتجاه أقرب عدو لتفادي ضرباته.",
    Callback = function(value)
        Settings.AutoDodge = value
    end,
})

AIGroup:AddToggle("DynamicFOV", {
    Text = "Dynamic FOV",
    Default = false,
    Tooltip = "زاوية الالتقاط تتسع تلقائياً (100–400) حسب عدد الأعداء على الشاشة.",
    Callback = function(value)
        Settings.DynamicFOV = value
    end,
})

AIGroup:AddToggle("SmartTrigger", {
    Text = "Smart Triggerbot",
    Default = false,
    Tooltip = "التريقر لا يطلق إلا إذا كان الهدف مرئياً (Raycast) وقريباً جداً من الكرسير.",
    Callback = function(value)
        Settings.SmartTrigger = value
    end,
})

PilotGroup:AddToggle("AutoPilot", {
    Text = "Auto-Pilot",
    Default = false,
    Tooltip = "يتحرك بك تلقائياً نحو أقرب عدو عبر PathfindingService.\nأوقف الميزة لإيقاف المسير.",
    Callback = function(value)
        Settings.AutoPilot = value
        if value then
            AutoPilotLoop()
        end
    end,
})

PilotGroup:AddToggle("ChatAI", {
    Text = "رد تلقائي في الشات",
    Default = false,
    Tooltip = "يرد تلقائياً عند كتابة كلمات مثل: هاكر / hack / noob / ez.\n(يدعم نظامي الدردشة الحديث والقديم).",
    Callback = function(value)
        Settings.ChatAI = value
    end,
})

PilotGroup:AddDivider()
PilotGroup:AddLabel("أمثلة ردود الـ Chat AI: \"هاكر\" ← \"ما في هاكر، أنت بس ضعيف 😎\"", true)

-- ---- تبويب خارق ----
local PowerTab = Window:AddTab("خارق", "zap")
local PowerGroup = PowerTab:AddLeftGroupbox("ميزات خارقة", "zap")
local PowerExtraGroup = PowerTab:AddRightGroupbox("أدوات إضافية", "settings")

PowerGroup:AddToggle("RageMode", {
    Text = "Rage Mode",
    Default = false,
    Tooltip = "تفعيل كل الميزات الهجومية دفعة واحدة:\nالإيمبوت + سايلنت + Kill Aura + Rapid Fire + No Recoil + Magic Bullet...",
    Callback = function(value)
        SetRageMode(value)
    end,
})

PowerGroup:AddButton("Kill All (إن توفر الريموت)", KillAll)

PowerGroup:AddToggle("LagSwitch", {
    Text = "Lag Switch",
    Default = false,
    Tooltip = "يخنق الاتصال الصادر مؤقتاً لإرباك الأعداء (SetOutgoingKBPSLimit).\nقد يسبب انقطاعاً كاملاً — استخدمه بحذر.",
    Callback = function(value)
        Settings.LagSwitch = value
        ApplyLagSwitch()
    end,
})

PowerGroup:AddToggle("FPSUnlocker", {
    Text = "رفع الفريمات (FPS Unlocker)",
    Default = false,
    Tooltip = "يرفع حد الفريمات إلى 999 (يتطلب دعم الإكسكيوتور).",
    Callback = function(value)
        Settings.FPSUnlocker = value
        ApplyFPSUnlocker()
    end,
})

PowerGroup:AddToggle("AutoSwitchWeapon", {
    Text = "تبديل السلاح بعد القتل",
    Default = false,
    Tooltip = "بعد كل قتل، يجهّز أفضل سلاح في حقيبتك تلقائياً (حسب قيمة Damage).",
    Callback = function(value)
        Settings.AutoSwitchWeapon = value
    end,
})

PowerGroup:AddToggle("AutoRevive", {
    Text = "إحياء الزملاء تلقائياً",
    Default = false,
    Tooltip = "يبحث عن ريموت revive في اللعبة ويستدعيه على الزملاء.\nقد لا يعمل إذا كانت اللعبة تستخدم ريموتاً باسم مختلف.",
    Callback = function(value)
        Settings.AutoRevive = value
    end,
})

PowerGroup:AddToggle("HealthAlert", {
    Text = "تنبيه انخفاض الصحة",
    Default = false,
    Callback = function(value)
        Settings.HealthAlert = value
    end,
})

PowerGroup:AddSlider("HealthAlertThreshold", {
    Text = "حد التنبيه",
    Default = 30,
    Min = 5,
    Max = 80,
    Rounding = 0,
    Suffix = "صحة",
    Callback = function(value)
        Settings.HealthAlertThreshold = value
    end,
})

PowerExtraGroup:AddToggle("AutoClicker", {
    Text = "Auto Clicker",
    Default = false,
    Tooltip = "ضغط تلقائي متواصل على زر الفأرة الأيسر بالمعدل المحدد.",
    Callback = function(value)
        Settings.AutoClicker = value
    end,
})

PowerExtraGroup:AddSlider("ClickRate", {
    Text = "معدل النقر",
    Default = 10,
    Min = 1,
    Max = 25,
    Rounding = 0,
    Suffix = "نقرة/ث",
    Callback = function(value)
        Settings.ClickRate = value
    end,
})

PowerExtraGroup:AddDivider()

PowerExtraGroup:AddButton("تسجيل ماكرو", StartMacroRecording)
PowerExtraGroup:AddButton("إيقاف التسجيل", StopMacroRecording)
PowerExtraGroup:AddButton("تشغيل الماكرو", PlayMacro)
PowerExtraGroup:AddLabel("الماكرو يسجل ضغطات لوحة المفاتيح ويعيدها بنفس التوقيتات.", true)

PowerExtraGroup:AddDivider()

PowerExtraGroup:AddToggle("BulletTracers", {
    Text = "خط مسار الرصاص",
    Default = false,
    Tooltip = "رسم خط أصفر من الكاميرا إلى الهدف عند الإطلاق\n(يتطلب مكتبة Drawing في الإكسكيوتور).",
    Callback = function(value)
        Settings.BulletTracers = value
    end,
})

PowerExtraGroup:AddToggle("EnemyWeaponESP", {
    Text = "ESP لسلاح العدو",
    Default = false,
    Tooltip = "عرض اسم سلاح كل عدو في لافتة الـ ESP.",
    Callback = function(value)
        Settings.EnemyWeaponESP = value
        UpdateESP()
    end,
})

-- ---- تبويب تخصيص ----
local CustomTab = Window:AddTab("تخصيص", "palette")
local CustomGroup = CustomTab:AddLeftGroupbox("المظهر", "palette")
local CustomToolsGroup = CustomTab:AddRightGroupbox("أدوات", "wrench")

CustomGroup:AddToggle("CharacterResizer", {
    Text = "تكبير/تصغير الشخصية",
    Default = false,
    Tooltip = "يغيّر حجم أجزاء جسمك (Client-Side — يظهر لك أنت فقط).",
    Callback = function(value)
        Settings.CharacterResizer = value
        if not value then
            RestoreCharacterSize()
        end
    end,
})

CustomGroup:AddSlider("CharacterSize", {
    Text = "حجم الشخصية",
    Default = 1,
    Min = 0.5,
    Max = 2,
    Rounding = 2,
    Suffix = "x",
    Callback = function(value)
        Settings.CharacterSize = value
    end,
})

CustomGroup:AddToggle("RainbowChar", {
    Text = "شخصية قوس قزح",
    Default = false,
    Callback = function(value)
        Settings.RainbowChar = value
        if not value then
            RestoreCharacterColors()
        end
    end,
})

CustomGroup:AddToggle("NameHider", {
    Text = "إخفاء الاسم",
    Default = false,
    Tooltip = "يخفي اسمك عن اللاعبين الآخرين (Client-Side).",
    Callback = function(value)
        Settings.NameHider = value
        ApplyNameHider()
    end,
})

CustomGroup:AddToggle("NoScreenEffects", {
    Text = "إزالة مؤثرات الشاشة",
    Default = false,
    Tooltip = "يزيل الضبابية (Blur) وتصحيحات الألوان المزعجة.",
    Callback = function(value)
        Settings.NoScreenEffects = value
        if value then
            ApplyScreenEffects()
        end
    end,
})

CustomGroup:AddToggle("Noclip2", {
    Text = "NoClip 2.0",
    Default = false,
    Tooltip = "يعطل التصادم فقط أثناء الحركة (W/A/S/D) ويستعيده عند التوقف\n— أقل قابلية للاكتشاف من Noclip الكامل.",
    Callback = function(value)
        Settings.Noclip2 = value
    end,
})

CustomToolsGroup:AddToggle("AutoEquipBest", {
    Text = "تجهيز أفضل سلاح تلقائياً",
    Default = false,
    Tooltip = "يجّهز السلاح الأعلى قيمة Damage في حقيبتك.",
    Callback = function(value)
        Settings.AutoEquipBest = value
    end,
})

CustomToolsGroup:AddToggle("InfiniteJump", {
    Text = "قفز لا نهائي",
    Default = false,
    Tooltip = "القفز المتكرر أثناء الضغط على Space.",
    Callback = function(value)
        Settings.InfiniteJump = value
    end,
})

CustomToolsGroup:AddToggle("Gravity", {
    Text = "تغيير الجاذبية",
    Default = false,
    Tooltip = "جاذبية منخفضة = قفز أعلى وبطء في السقوط (محلي).",
    Callback = function(value)
        Settings.GravityEnabled = value
        if value then
            workspace.Gravity = Settings.Gravity
        else
            workspace.Gravity = OriginalGravity
        end
    end,
})

CustomToolsGroup:AddSlider("GravityValue", {
    Text = "قيمة الجاذبية",
    Default = 196.2,
    Min = 30,
    Max = 196.2,
    Rounding = 1,
    Suffix = "ستود/ث²",
    Callback = function(value)
        Settings.Gravity = value
    end,
})

CustomToolsGroup:AddToggle("ZoomHack", {
    Text = "تكبير بصري (Zoom Hack)",
    Default = false,
    Callback = function(value)
        Settings.ZoomHack = value
    end,
})

CustomToolsGroup:AddSlider("ZoomLevel", {
    Text = "مستوى التكبير",
    Default = 2,
    Min = 1.5,
    Max = 5,
    Rounding = 1,
    Suffix = "x",
    Callback = function(value)
        Settings.ZoomLevel = value
    end,
})

CustomToolsGroup:AddToggle("HitSound", {
    Text = "صوت الإصابة",
    Default = false,
    Tooltip = "صوت عند نقصان صحة أي عدو. ضع SoundId في Settings.HitSoundId في الكود.",
    Callback = function(value)
        Settings.HitSound = value
    end,
})

CustomToolsGroup:AddToggle("KillSound", {
    Text = "صوت القتل",
    Default = false,
    Tooltip = "صوت عند موت أي عدو. ضع SoundId في Settings.KillSoundId في الكود.",
    Callback = function(value)
        Settings.KillSound = value
    end,
})

CustomToolsGroup:AddDivider()

local CommandInput = CustomToolsGroup:AddInput("CommandInput", {
    Text = "أمر Lua",
    Placeholder = "print('hello')",
    ClearTextOnFocus = true,
    Finished = true,
    Callback = function(value)
        ExecuteCommand(value)
    end,
})

CustomToolsGroup:AddButton("تنفيذ الأمر", function()
    ExecuteCommand(Options.CommandInput.Value)
end)

-- ==============================
-- التنظيف عند إلغاء المكتبة
-- ==============================
Library:OnUnload(function()
    Unloaded = true

    for _, connection in ipairs(Connections) do
        connection:Disconnect()
    end

    for plr in pairs(ESPCache) do
        DestroyESPForPlayer(plr)
    end

    -- استرجاع قيم الأسلحة
    Settings.NoRecoil = false
    Settings.InfiniteAmmo = false
    Settings.NoSpread = false
    Settings.RapidFire = false
    Settings.InstantReload = false
    ApplyNoRecoil()
    ApplyInfiniteAmmo()
    RestoreWeaponMods()

    -- استرجاع الحركة
    Settings.Fly = false
    Settings.Noclip = false
    Settings.SpeedHack = false
    Settings.Invisibility = false
    Settings.NoFallDamage = false
    Settings.ThirdPerson = false
    Settings.FOVChanger = false
    StopFly()
    RestoreNoclip()
    ApplyInvisibility()

    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and DefaultWalkSpeed then
        hum.WalkSpeed = DefaultWalkSpeed
    end

    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    end)

    Camera.FieldOfView = 70
    Camera.Offset = Vector3.zero

    -- استرجاع الميزات الجديدة
    Settings.AutoPilot = false
    Settings.AutoDodge = false
    Settings.DynamicFOV = false
    Settings.NameHider = false
    Settings.GravityEnabled = false
    Settings.ZoomHack = false
    Settings.Noclip2 = false
    Settings.CharacterResizer = false
    Settings.RainbowChar = false
    Settings.LagSwitch = false
    Settings.FPSUnlocker = false
    Settings.AutoClicker = false
    Settings.MacroRecording = false

    if MacroRecording then
        StopMacroRecording()
    end

    ApplyNameHider()
    ApplyLagSwitch()
    ApplyFPSUnlocker()

    pcall(function()
        workspace.Gravity = OriginalGravity
    end)

    RestoreCharacterSize()
    RestoreCharacterColors()

    if Noclip2State then
        Noclip2State = false
        pcall(RestoreNoclip)
    end

    for _, sound in pairs(SoundCache) do
        pcall(function()
            sound:Destroy()
        end)
    end
    SoundCache = {}

    UninstallSilentAimHook()

    -- تدمير واجهات الشاشة (كل عنصر أبوه ScreenGui خاص به — عدا PlayerListGui
    -- فهو ScreenGui مباشرة ووالده PlayerGui، لذا يُدمَّر هو نفسه)
    for _, gui in ipairs({ FOVCircleFrame, CrosshairGui, RadarFrame }) do
        if gui and gui.Parent then
            gui.Parent:Destroy()
        end
    end

    if PlayerListGui then
        PlayerListGui:Destroy()
    end

    FOVCircleFrame = nil
    CrosshairGui = nil
    RadarFrame = nil
    PlayerListGui = nil
end)

-- ==============================
-- الواجهة البرمجية العامة
-- ==============================
-- _G.ExclusiveFeatures (الجدول الجديد) و _G.AimbotFeatures (للتوافق مع الكود السابق)
-- كل الدوال تزامن عناصر Cyan تلقائياً عبر SetValue.
_G.ExclusiveFeatures = {
    -- أساسي
    ToggleAimbot = function(state)
        Toggles.Aimbot:SetValue(not not state)
    end,

    SetAimbotKey = function(key)
        local value = typeof(key) == "string" and key or tostring(key):gsub("^Enum%.KeyCode%.", "")
        pcall(function()
            Options.AimbotKeybind:SetValue({ value })
        end)
    end,

    SetSmoothness = function(value)
        Options.Smoothness:SetValue(value)
    end,

    SetFOV = function(value)
        Options.AimbotFOV:SetValue(value)
    end,

    ToggleSilentAim = function(state)
        Toggles.SilentAim:SetValue(not not state)
    end,

    ToggleTriggerBot = function(state)
        Toggles.TriggerBot:SetValue(not not state)
    end,

    ToggleAimlock = function(state)
        Toggles.Aimlock:SetValue(not not state)
    end,

    SetAimlockKey = function(key)
        local value = typeof(key) == "string" and key or tostring(key):gsub("^Enum%.KeyCode%.", "")
        pcall(function()
            Options.AimlockKeybind:SetValue({ value })
        end)
    end,

    TogglePrediction = function(state)
        Toggles.Prediction:SetValue(not not state)
    end,

    SetPredictionAmount = function(value)
        Options.PredictionAmount:SetValue(value)
    end,

    ToggleAutoShoot = function(state)
        Toggles.AutoShoot:SetValue(not not state)
    end,

    -- قفل الهدف وجزء الإصابة
    ToggleLockTarget = function(state, plr)
        if state and plr then
            Settings.LockTarget = plr
            Toggles.TargetLock:SetValue(true)
        else
            Settings.LockTarget = nil
            Toggles.TargetLock:SetValue(false)
        end
    end,

    UnlockTarget = function()
        Settings.LockTarget = nil
        Toggles.TargetLock:SetValue(false)
    end,

    GetLockedTarget = function()
        return Settings.LockTarget
    end,

    SetHitPart = function(part)
        local mapped = part
        if part == "Head" then
            mapped = "الرأس"
        elseif part == "Torso" then
            mapped = "الجذع"
        elseif part == "Leg" or part == "Legs" then
            mapped = "الأرجل"
        elseif part == "Random" then
            mapped = "عشوائي"
        end

        Options.HitPart:SetValue(mapped)
    end,

    SetTargetPriority = function(prio)
        local mapped = prio
        if prio == "Distance" then
            mapped = "الأقرب مسافة"
        elseif prio == "Health" then
            mapped = "أقل صحة"
        elseif prio == "FOV" or prio == "Screen" or prio == nil then
            mapped = "الأقرب للمؤشر"
        end

        Options.TargetPriority:SetValue(mapped)
    end,

    ToggleWallCheck = function(state)
        Toggles.WallCheck:SetValue(not not state)
    end,

    -- ESP
    ToggleESP = function(state)
        Toggles.ESP:SetValue(not not state)
    end,

    ToggleESPBoxes = function(state)
        Toggles.ESPBoxes:SetValue(not not state)
    end,

    ToggleESPNames = function(state)
        Toggles.ESPNames:SetValue(not not state)
    end,

    ToggleESPDistance = function(state)
        Toggles.ESPDistance:SetValue(not not state)
    end,

    ToggleESPHealth = function(state)
        Toggles.ESPHealth:SetValue(not not state)
    end,

    ToggleESPChams = function(state)
        Toggles.ESPChams:SetValue(not not state)
    end,

    ToggleESPGlow = function(state)
        Toggles.ESPGlow:SetValue(not not state)
    end,

    ToggleESPRadar = function(state)
        Toggles.ESPRadar:SetValue(not not state)
    end,

    SetRadarSize = function(value)
        Options.RadarSize:SetValue(value)
    end,

    SetRadarPosition = function(position)
        Settings.RadarPos = position
    end,

    ToggleRainbowESP = function(state)
        Toggles.RainbowESP:SetValue(not not state)
    end,

    -- الأسلحة
    ToggleNoRecoil = function(state)
        Toggles.NoRecoil:SetValue(not not state)
    end,

    ToggleInfiniteAmmo = function(state)
        Toggles.InfiniteAmmo:SetValue(not not state)
    end,

    ToggleNoSpread = function(state)
        Toggles.NoSpread:SetValue(not not state)
    end,

    ToggleRapidFire = function(state)
        Toggles.RapidFire:SetValue(not not state)
    end,

    SetRapidFireMultiplier = function(value)
        Options.RapidFireMultiplier:SetValue(value)
    end,

    ToggleInstantReload = function(state)
        Toggles.InstantReload:SetValue(not not state)
    end,

    ToggleMagicBullet = function(state)
        Toggles.MagicBullet:SetValue(not not state)
    end,

    ToggleAutoReload = function(state)
        Toggles.AutoReload:SetValue(not not state)
    end,

    ToggleNoAnimation = function(state)
        Toggles.NoAnimation:SetValue(not not state)
    end,

    ToggleNoWeaponBob = function(state)
        Toggles.NoWeaponBob:SetValue(not not state)
    end,

    -- Kill Aura
    ToggleKillAura = function(state)
        Toggles.KillAura:SetValue(not not state)
    end,

    SetKillAuraRange = function(value)
        Options.KillAuraRange:SetValue(value)
    end,

    SetKillAuraDelay = function(value)
        Options.KillAuraDelay:SetValue(value)
    end,

    -- الحركة
    ToggleFly = function(state)
        Toggles.Fly:SetValue(not not state)
    end,

    SetFlySpeed = function(value)
        Options.FlySpeed:SetValue(value)
    end,

    ToggleNoclip = function(state)
        Toggles.Noclip:SetValue(not not state)
    end,

    ToggleSpeedHack = function(state)
        Toggles.SpeedHack:SetValue(not not state)
    end,

    SetSpeedMultiplier = function(value)
        Options.SpeedMultiplier:SetValue(value)
    end,

    ToggleBunnyHop = function(state)
        Toggles.BunnyHop:SetValue(not not state)
    end,

    ToggleNoFallDamage = function(state)
        Toggles.NoFallDamage:SetValue(not not state)
    end,

    ToggleSpinbot = function(state)
        Toggles.Spinbot:SetValue(not not state)
    end,

    SetSpinSpeed = function(value)
        Options.SpinSpeed:SetValue(value)
    end,

    SetSpinAxis = function(axis)
        Options.SpinAxis:SetValue(axis)
    end,

    ToggleAntiAimJitter = function(state)
        Toggles.AntiAimJitter:SetValue(not not state)
    end,

    SetJitterAngle = function(value)
        Options.JitterAngle:SetValue(value)
    end,

    ToggleThirdPerson = function(state)
        Toggles.ThirdPerson:SetValue(not not state)
    end,

    SetThirdPersonDistance = function(value)
        Options.ThirdPersonDistance:SetValue(value)
    end,

    -- تخفي ونقل
    ToggleInvisibility = function(state)
        Toggles.Invisibility:SetValue(not not state)
    end,

    TeleportToMouse = TeleportToMouse,

    TeleportToCoords = TeleportToCoords,

    TeleportToCover = TeleportToCover,

    ToggleAutoCollect = function(state)
        Toggles.AutoCollect:SetValue(not not state)
    end,

    -- بقاء
    ToggleAutoHeal = function(state)
        Toggles.AutoHeal:SetValue(not not state)
    end,

    SetHealThreshold = function(value)
        Options.HealThreshold:SetValue(value)
    end,

    ToggleAutoRespawn = function(state)
        Toggles.AutoRespawn:SetValue(not not state)
    end,

    ToggleInstantRespawn = function(state)
        Toggles.InstantRespawn:SetValue(not not state)
    end,

    SetSpawnLocation = function(position)
        Settings.SpawnLocation = position
    end,

    -- أخرى
    ToggleShowFOV = function(state)
        Toggles.FOVCircle:SetValue(not not state)
    end,

    ToggleFOVChanger = function(state)
        Toggles.FOVChanger:SetValue(not not state)
    end,

    SetFOVValue = function(value)
        Options.FOVValue:SetValue(value)
    end,

    SetTimeScale = function(value)
        Options.TimeScale:SetValue(value)
    end,

    ToggleSoundAmplifier = function(state)
        Toggles.SoundAmplifier:SetValue(not not state)
    end,

    ToggleCrosshair = function(state)
        Toggles.Crosshair:SetValue(not not state)
    end,

    SetCrosshairSize = function(value)
        Options.CrosshairSize:SetValue(value)
    end,

    SetCrosshairColor = function(color)
        Settings.CrosshairColor = color
        pcall(function()
            Options.CrosshairColor:SetValueRGB(color)
        end)
        UpdateCrosshair()
    end,

    TogglePlayerList = function(state)
        Toggles.PlayerList:SetValue(not not state)
    end,

    ToggleAimbotAlert = function(state)
        Toggles.AimbotAlert:SetValue(not not state)
    end,

    ToggleAntiAFK = function(state)
        Toggles.AntiAFK:SetValue(not not state)
    end,

    ToggleChatSpam = function(state)
        Toggles.ChatSpam:SetValue(not not state)
    end,

    SetChatMessage = function(message)
        Options.ChatMessage:SetValue(message)
    end,

    SetChatDelay = function(value)
        Options.ChatDelay:SetValue(value)
    end,

    -- ============ AI ============
    ToggleAIPriority = function(state)
        Toggles.AIPriority:SetValue(not not state)
    end,

    ToggleAdaptiveSmoothness = function(state)
        Toggles.AdaptiveSmoothness:SetValue(not not state)
    end,

    ToggleAIPrediction = function(state)
        Toggles.AIPrediction:SetValue(not not state)
    end,

    ToggleAutoDodge = function(state)
        Toggles.AutoDodge:SetValue(not not state)
    end,

    ToggleDynamicFOV = function(state)
        Toggles.DynamicFOV:SetValue(not not state)
    end,

    ToggleChatAI = function(state)
        Toggles.ChatAI:SetValue(not not state)
    end,

    ToggleAutoPilot = function(state)
        Toggles.AutoPilot:SetValue(not not state)
    end,

    ToggleSmartTrigger = function(state)
        Toggles.SmartTrigger:SetValue(not not state)
    end,

    -- ============ شائعة ============
    ToggleAutoClicker = function(state)
        Toggles.AutoClicker:SetValue(not not state)
    end,

    SetClickRate = function(rate)
        Options.ClickRate:SetValue(rate)
    end,

    StartMacroRecording = StartMacroRecording,

    StopMacroRecording = StopMacroRecording,

    PlayMacro = PlayMacro,

    ToggleGravity = function(state)
        Toggles.Gravity:SetValue(not not state)
    end,

    SetGravity = function(value)
        Options.GravityValue:SetValue(value)
        workspace.Gravity = value
    end,

    ToggleInfiniteJump = function(state)
        Toggles.InfiniteJump:SetValue(not not state)
    end,

    ToggleZoomHack = function(state)
        Toggles.ZoomHack:SetValue(not not state)
    end,

    SetZoomLevel = function(level)
        Options.ZoomLevel:SetValue(level)
    end,

    ToggleHitSound = function(state)
        Toggles.HitSound:SetValue(not not state)
    end,

    ToggleKillSound = function(state)
        Toggles.KillSound:SetValue(not not state)
    end,

    SetHitSoundId = function(soundId)
        Settings.HitSoundId = soundId
    end,

    SetKillSoundId = function(soundId)
        Settings.KillSoundId = soundId
    end,

    ToggleCharacterResizer = function(state)
        Toggles.CharacterResizer:SetValue(not not state)
    end,

    SetCharacterSize = function(scale)
        Options.CharacterSize:SetValue(scale)
    end,

    ToggleRainbowChar = function(state)
        Toggles.RainbowChar:SetValue(not not state)
    end,

    ToggleNameHider = function(state)
        Toggles.NameHider:SetValue(not not state)
    end,

    ToggleNoScreenEffects = function(state)
        Toggles.NoScreenEffects:SetValue(not not state)
    end,

    ToggleAutoEquipBest = function(state)
        Toggles.AutoEquipBest:SetValue(not not state)
    end,

    EquipBestWeapon = EquipBestWeapon,

    ExecuteCommand = ExecuteCommand,

    -- ============ خارقة ============
    KillAll = KillAll,

    ToggleLagSwitch = function(state)
        Toggles.LagSwitch:SetValue(not not state)
    end,

    ToggleFPSUnlocker = function(state)
        Toggles.FPSUnlocker:SetValue(not not state)
    end,

    ToggleAutoSwitchWeapon = function(state)
        Toggles.AutoSwitchWeapon:SetValue(not not state)
    end,

    ToggleRageMode = SetRageMode,

    ToggleBulletTracers = function(state)
        Toggles.BulletTracers:SetValue(not not state)
    end,

    ToggleEnemyWeaponESP = function(state)
        Toggles.EnemyWeaponESP:SetValue(not not state)
    end,

    ToggleHealthAlert = function(state)
        Toggles.HealthAlert:SetValue(not not state)
    end,

    SetHealthAlertThreshold = function(value)
        Options.HealthAlertThreshold:SetValue(value)
    end,

    ToggleAutoRevive = function(state)
        Toggles.AutoRevive:SetValue(not not state)
    end,

    GetSettings = function()
        return Settings
    end,
}

-- توافق مع الكود السابق
_G.AimbotFeatures = _G.ExclusiveFeatures

-- إشعار نجاح التحميل
Library:Notify({
    Title = "تم تحميل السكربت",
    Description = "Q للإيمبوت، E لتصويب فوري، C للـ ESP — وأكثر من 45 ميزة.",
    Time = 5,
})
