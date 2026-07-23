-- Cyan 26.8.0 — single-file bundle (auto-generated).
-- Every add-on is inlined and the "UI Settings" tab is ungated,
-- so ESP, Aimbot and all add-on controls render by default.

--// Library.lua //--
local Library = (loadstring([=[
local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local GuiService: GuiService = cloneref(game:GetService("GuiService"))
local Lighting: Lighting = cloneref(game:GetService("Lighting"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local SoundService: SoundService = cloneref(game:GetService("SoundService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local TextService: TextService = cloneref(game:GetService("TextService"))
local Teams: Teams = cloneref(game:GetService("Teams"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))

local getgenv = getgenv or function()
    return shared
end
local setclipboard = setclipboard or nil
local protectgui = protectgui or (syn and syn.protect_gui) or function() end
local gethui = gethui or function()
    return CoreGui
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Mouse = cloneref(LocalPlayer:GetMouse())

local Labels = {}
local Buttons = {}
local Toggles = {}
local Options = {}
local Tooltips = {}

local BaseURL = "https://raw.githubusercontent.com/EhabYT/cyan/main/"
local CustomImageManager = {}
local CustomImageManagerAssets = {
    TransparencyTexture = {
        RobloxId = 139785960036434,
        Path = "Cyan/assets/TransparencyTexture.png",
        URL = BaseURL .. "assets/TransparencyTexture.png",

        Id = nil,
    },

    SaturationMap = {
        RobloxId = 4155801252,
        Path = "Cyan/assets/SaturationMap.png",
        URL = BaseURL .. "assets/SaturationMap.png",

        Id = nil,
    },

    LoadingIcon = {
        RobloxId = 97544096941083,
        Path = "Cyan/assets/LoadingIcon.png",
        URL = BaseURL .. "assets/LoadingIcon.png",

        Id = nil,
    },

    CheckIcon = {
        RobloxId = 97682394690683,
        Path = "Cyan/assets/CheckIcon.png",
        URL = BaseURL .. "assets/CheckIcon.png",

        Id = nil,
    },

    CyanLogo = {
        -- The local file is used through getcustomasset when the host supports custom assets.
        -- This ID remains a safe fallback until the CyanLogo is uploaded as a Roblox asset.
        RobloxId = 95816097006870,
        Path = "Cyan/assets/CyanLogo.png",
        URL = BaseURL .. "assets/CyanLogo.png",

        Id = nil,
    },
}
do
    local function RecursiveCreatePath(Path: string, IsFile: boolean?)
        if not isfolder or not makefolder then
            return
        end

        local Segments = Path:split("/")
        local TraversedPath = ""

        if IsFile then
            table.remove(Segments, #Segments)
        end

        for _, Segment in ipairs(Segments) do
            if not isfolder(TraversedPath .. Segment) then
                makefolder(TraversedPath .. Segment)
            end

            TraversedPath = TraversedPath .. Segment .. "/"
        end

        return TraversedPath
    end

    function CustomImageManager.AddAsset(
        AssetName: string,
        RobloxAssetId: number,
        URL: string,
        ForceRedownload: boolean?
    ): (boolean, string?)
        if
            typeof(AssetName) ~= "string"
            or AssetName:match("^%s*$")
            or AssetName:find("/", 1, true)
            or AssetName:find("\\", 1, true)
        then
            return false, "Asset name must be a non-empty file name"
        end
        if CustomImageManagerAssets[AssetName] ~= nil then
            return false, string.format("Asset %q already exists", AssetName)
        end
        if typeof(RobloxAssetId) ~= "number" then
            return false, "Roblox asset ID must be a number"
        end
        if typeof(URL) ~= "string" or URL == "" then
            return false, "Asset URL must be a non-empty string"
        end

        CustomImageManagerAssets[AssetName] = {
            RobloxId = RobloxAssetId,
            Path = string.format("Cyan/custom_assets/%s", AssetName),
            URL = URL,

            Id = nil,
        }

        local Success, ErrorMessage = CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
        if not Success then
            CustomImageManagerAssets[AssetName] = nil
        end

        return Success, ErrorMessage
    end

    function CustomImageManager.GetAsset(AssetName: string)
        if not CustomImageManagerAssets[AssetName] then
            return nil
        end

        local AssetData = CustomImageManagerAssets[AssetName]
        if AssetData.Id then
            return AssetData.Id
        end

        local AssetID = string.format("rbxassetid://%s", AssetData.RobloxId)

        if getcustomasset then
            local Success, NewID = pcall(getcustomasset, AssetData.Path)

            if Success and NewID then
                AssetID = NewID
            end
        end

        AssetData.Id = AssetID
        return AssetID
    end

    function CustomImageManager.DownloadAsset(
        AssetName: string,
        ForceRedownload: boolean?
    ): (boolean, string?)
        if typeof(AssetName) ~= "string" then
            return false, "Asset name must be a string"
        end
        if
            typeof(getcustomasset) ~= "function"
            or typeof(writefile) ~= "function"
            or typeof(isfile) ~= "function"
        then
            return false, "Required filesystem capabilities are unavailable"
        end

        local AssetData = CustomImageManagerAssets[AssetName]
        if not AssetData then
            return false, string.format("Unknown asset %q", AssetName)
        end

        local Success, ErrorMessage = pcall(function()
            RecursiveCreatePath(AssetData.Path, true)

            if ForceRedownload ~= true and isfile(AssetData.Path) then
                return
            end

            writefile(AssetData.Path, game:HttpGet(AssetData.URL))
        end)

        if not Success then
            return false, tostring(ErrorMessage)
        end

        return true
    end

    for AssetName, _ in CustomImageManagerAssets do
        CustomImageManager.DownloadAsset(AssetName)
    end
end

local Library = {
    Version = "26.8.0",
    LocalPlayer = LocalPlayer,
    IsRobloxFocused = true,

    --// Device \\--
    DevicePlatform = nil,
    IsMobile = false,

    --// Cyan Windows \\--
    ScreenGui = nil,
    Window = nil,
    WindowContainer = nil,

    --// Search \\--
    SearchText = "",
    Searching = false,
    GlobalSearch = false,
    LastSearchTab = nil,

    --// Tabs \\--
    ActiveTab = nil,
    Tabs = {},
    TabButtons = {},
    TabOrder = {},

    --// Dependency Boxes \\--
    DependencyBoxes = {},

    --// Keybinds Frame \\--
    KeybindFrame = nil,
    KeybindContainer = nil,
    KeybindToggles = {},

    --// Notifications \\--
    Notifications = {},
    NotifySide = "Right",
    NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    --// Dialogues \\--
    Dialogues = {},
    ActiveDialog = nil,

    --// Loading Window \\--
    ActiveLoading = nil,

    --// Corners \\--
    Corners = {},
    SpecificCorners = {},

    --// Animations \\--
    TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    TabTransitionInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    TabSwipeOffset = 26,
    TabSwipeFrom = "bottom",

    WindowAnimationInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    DropdownTransitionInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    KeyPickerTransitionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    GroupboxTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    RotatingChevronTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),

    Animations = {
        ToggleWindow = false,
        TabSwitch = false,
        Groupbox = false,
        Dropdown = false,
        KeyPicker = false,
    },
    PreferredAnimations = nil,
    ReducedMotion = false,

    --// States \\--
    Toggled = false,
    Unloaded = false,

    --// Elements \\--
    Labels = Labels,
    Buttons = Buttons,
    Toggles = Toggles,
    Options = Options,

    --// Options \\--
    ToggleKeybind = Enum.KeyCode.RightControl,
    ShowToggleFrameInKeybinds = true,

    NotifyOnError = false,
    ShowCustomCursor = true,
    ForceCheckbox = false,

    CantDragForced = false,
    DraggableElements = {},

    --// Signals \\--
    Signals = {},
    UnloadSignals = {},

    OriginalMinSize = Vector2.new(480, 360),
    MinSize = Vector2.new(480, 360),
    DPIScale = 1,
    CornerRadius = 6,

    --// Scheme \\--
    IsLightTheme = false,
    Scheme = {
        -- Cyan default: deep navy surfaces with a high-visibility cyan accent.
        BackgroundColor = Color3.fromRGB(6, 21, 34),
        MainColor = Color3.fromRGB(13, 33, 56),
        AccentColor = Color3.fromRGB(56, 224, 235),
        OutlineColor = Color3.fromRGB(28, 90, 115),
        FontColor = Color3.fromRGB(234, 253, 255),
        Font = Font.fromEnum(Enum.Font.Code),

        RedColor = Color3.fromRGB(255, 50, 50),
        DestructiveColor = Color3.fromRGB(220, 38, 38),
        DarkColor = Color3.new(0, 0, 0),
        WhiteColor = Color3.new(1, 1, 1),

        BackgroundImage = "",
    },

    --// Registry \\--
    Registry = {},
    Scales = {},
    ScalesOffset = {},

    --// Visual Style \\--
    GlassEnabled = true,
    GlassTransparency = 0.16,
    GlassStrokeTransparency = 0.25,
    GlassSurfaces = {},
    GlassStrokes = {},
    GlassGradients = {},
    GlassBlurEffects = {},

    --// Misc \\--
    ImageManager = CustomImageManager,
    ShowCursorBinding = string.sub(tostring({}), 10),

    Notify = nil,
    Toggle = nil, -- we love luau lsp
}

local function CopyAnimations(Animations: { [string]: boolean }): { [string]: boolean }
    local Copy = {}
    for Name, Enabled in Animations do
        Copy[Name] = Enabled == true
    end

    return Copy
end

local function ApplyAnimationPreferences(Animations: { [string]: boolean })
    Library.PreferredAnimations = CopyAnimations(Animations)
    if Library.ReducedMotion then
        local DisabledAnimations = {}
        for Name in Library.PreferredAnimations do
            DisabledAnimations[Name] = false
        end
        Library.Animations = DisabledAnimations
    else
        Library.Animations = CopyAnimations(Library.PreferredAnimations)
    end
end

function Library:SetReducedMotion(Enabled: boolean)
    assert(typeof(Enabled) == "boolean", "Reduced motion must be a boolean")

    if Library.ReducedMotion == Enabled then
        return
    end

    Library.ReducedMotion = Enabled
    ApplyAnimationPreferences(Library.PreferredAnimations or Library.Animations)
end

local function RefreshGlassSurface(Surface)
    local Instance = Surface.Instance
    if not (Instance and Instance.Parent) then
        return
    end

    Instance.BackgroundTransparency = if Library.GlassEnabled
        then math.max(Surface.OpaqueTransparency, Library.GlassTransparency)
        else Surface.OpaqueTransparency
end

local function RefreshGlassStyle()
    for _, Surface in Library.GlassSurfaces do
        RefreshGlassSurface(Surface)
    end

    for _, Stroke in Library.GlassStrokes do
        if Stroke and Stroke.Parent then
            Stroke.Transparency = if Library.GlassEnabled
                then Library.GlassStrokeTransparency
                else 1
        end
    end

    for _, Gradient in Library.GlassGradients do
        if Gradient and Gradient.Parent then
            Gradient.Enabled = Library.GlassEnabled
        end
    end
end

if RunService:IsStudio() then
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        Library.IsMobile = true
        Library.OriginalMinSize = Vector2.new(480, 240)
    else
        Library.IsMobile = false
        Library.OriginalMinSize = Vector2.new(480, 360)
    end
else
    pcall(function()
        Library.DevicePlatform = UserInputService:GetPlatform()
    end)

    Library.IsMobile = (
        Library.DevicePlatform == Enum.Platform.Android
        or Library.DevicePlatform == Enum.Platform.IOS
    )
    Library.OriginalMinSize = Library.IsMobile and Vector2.new(480, 240) or Vector2.new(480, 360)
end

local function GetSafeAreaInsets(): (Vector2, Vector2)
    local TopLeft = Vector2.zero
    local BottomRight = Vector2.zero

    pcall(function()
        TopLeft, BottomRight = GuiService:GetGuiInset()
    end)

    return TopLeft, BottomRight
end

local Templates = {
    --// UI \\--
    Frame = {
        BorderSizePixel = 0,
    },
    ImageLabel = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    },
    ImageButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
    },
    ScrollingFrame = {
        BorderSizePixel = 0,
    },
    TextLabel = {
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },
    TextButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },
    TextBox = {
        BorderSizePixel = 0,
        FontFace = "Font",
        PlaceholderColor3 = function()
            local H, S, V = Library.Scheme.FontColor:ToHSV()
            return Color3.fromHSV(H, S, V / 2)
        end,
        Text = "",
        TextColor3 = "FontColor",
    },
    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder,
    },
    UIStroke = {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    },

    --// Library \\--
    Window = {
        Title = "No Title",
        Footer = "No Footer",

        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(720, 600),
        IconSize = UDim2.fromOffset(30, 30),

        AutoShow = true,
        Center = true,
        Resizable = true,

        SearchbarSize = UDim2.fromScale(1, 1),
        GlobalSearch = false,

        CornerRadius = 6,
        NotifySide = "Right",
        ShowCustomCursor = true,

        Glass = true,
        GlassTransparency = 0.16,
        GlassStrokeTransparency = 0.25,
        GlassPreset = "Liquid",
        GlassSheen = true,
        GlassSheenSpeed = 7,
        GlassBackgroundMotion = true,
        GlassBackgroundMotionSpeed = 14,
        GlassBlur = false,
        GlassBlurSize = 8,

        Font = Enum.Font.Code,
        ToggleKeybind = Enum.KeyCode.RightControl,

        ShowMobileButtons = true,
        MobileButtonsSide = "Left",
        MobileScale = 0.9,
        MobileViewportPadding = 12,
        MobileStartCompacted = true,
        MobileLayout = "Balanced",
        EnableTabSwipeNavigation = true,
        TabSwipeNavigationThreshold = 60,

        UnlockMouseWhileOpen = true,

        EnableSidebarResize = false,
        EnableCompacting = true,
        DisableCompactingSnap = false,
        SidebarCompacted = false,
        MinContainerWidth = 256,

        --// Snapping \\--
        MinSidebarWidth = 128,
        SidebarCompactWidth = 48,
        SidebarCollapseThreshold = 0.5,

        --// Dragging \\--
        CompactWidthActivation = 128,

        --// Background \\--
        BackgroundImage = "",

        --// Animations \\--
        Animations = {
            ToggleWindow = false,
            TabSwitch = false,
            Groupbox = false,
            Dropdown = false,
            KeyPicker = false,
        },

        TabTransitionTime = 0.22,
        TabSwipeOffset = 26,
        TabSwipeFrom = "bottom",
    },
    Dialog = {
        Title = "Dialog",
        Description = "Description",
        AutoDismiss = true,
        OutsideClickDismiss = true,
        FooterButtons = {},
    },
    Loading = {
        Title = "Cyan",
        Icon = CustomImageManager.GetAsset("CyanLogo"),
        IconSize = UDim2.fromOffset(30, 30),

        LoadingIcon = CustomImageManager.GetAsset("LoadingIcon"),
        LoadingIconColor = nil,
        LoadingIconTweenTime = 1,

        CurrentStep = 0,
        TotalSteps = 10,

        ShowSidebar = false,
        AutoResizeHeight = false,

        WindowWidth = 450,
        WindowHeight = 275,

        ContentWidth = 450,
        SidebarWidth = 250,
    },
    Toggle = {
        Text = "Toggle",
        Default = false,

        Callback = function() end,
        Changed = function() end,

        Risky = false,
        Disabled = false,
        Visible = true,
    },
    Input = {
        Text = "Input",
        Default = "",
        Finished = false,
        Numeric = false,
        ClearTextOnFocus = true,
        ClearTextOnBlur = false,
        Placeholder = "",
        AllowEmpty = true,
        EmptyReset = "---",

        Callback = function() end,
        Changed = function() end,
        VerifyValue = nil,

        Disabled = false,
        Visible = true,
    },
    Slider = {
        Text = "Slider",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,

        Prefix = "",
        Suffix = "",

        Callback = function() end,
        Changed = function() end,

        Disabled = false,
        Visible = true,

        AllowRightClickInput = true,
    },
    Dropdown = {
        Values = {},
        DisabledValues = {},
        ValueImages = {},

        Multi = false,
        DragSelect = false,
        MaxVisibleDropdownItems = 8,

        Callback = function() end,
        Changed = function() end,

        Disabled = false,
        Visible = true,
    },
    Viewport = {
        Object = nil,
        Camera = nil,
        Clone = true,
        AutoFocus = true,
        Interactive = false,
        Height = 200,
        Visible = true,
    },
    Image = {
        Image = "",
        Transparency = 0,
        BackgroundTransparency = 0,
        Color = Color3.new(1, 1, 1),
        RectOffset = Vector2.zero,
        RectSize = Vector2.zero,
        ScaleType = Enum.ScaleType.Fit,
        Height = 200,
        Visible = true,
    },
    Video = {
        Video = "",
        Looped = false,
        Playing = false,
        Volume = 1,
        Height = 200,
        Visible = true,
    },
    UIPassthrough = {
        Instance = nil,
        Height = 24,
        Visible = true,
    },

    --// Addons \\-
    KeyPicker = {
        Text = "KeyPicker",

        Default = "None",
        DefaultModifiers = {},

        Blacklisted = {},
        BlacklistedModifiers = {},
        Whitelisted = {},
        WhitelistedModifiers = {},

        Mode = "Toggle",
        Modes = { "Always", "Toggle", "Hold" },
        SyncToggleState = false,

        Callback = function() end,
        ChangedCallback = function() end,
        Changed = function() end,
        Clicked = function() end,
    },
    ColorPicker = {
        Default = Color3.new(1, 1, 1),

        Callback = function() end,
        Changed = function() end,
    },
}

local Places = {
    Bottom = { 0, 1 },
    Right = { 1, 0 },
}
local Sizes = {
    Left = { 0.5, 1 },
    Right = { 0.5, 1 },
}

--// Scheme Functions \\--
local SchemeReplaceAlias = {
    RedColor = "Red",
    WhiteColor = "White",
    DarkColor = "Dark",
}

local SchemeAlias = {
    Red = "RedColor",
    White = "WhiteColor",
    Dark = "DarkColor",
}

local function GetSchemeValue(Index)
    if not Index then
        return nil
    end

    local ReplaceAliasIndex = SchemeReplaceAlias[Index]
    if ReplaceAliasIndex and Library.Scheme[ReplaceAliasIndex] ~= nil then
        Library.Scheme[Index] = Library.Scheme[ReplaceAliasIndex]
        Library.Scheme[ReplaceAliasIndex] = nil

        return Library.Scheme[Index]
    end

    local AliasIndex = SchemeAlias[Index]
    if AliasIndex and Library.Scheme[AliasIndex] ~= nil then
        warn(
            string.format(
                "Scheme Value %q is deprecated, please use %q instead.",
                Index,
                AliasIndex
            )
        )
        return Library.Scheme[AliasIndex]
    end

    return Library.Scheme[Index]
end

--// Basic Functions \\--
local function WaitForEvent(Event, Timeout, Condition)
    local Bindable = Instance.new("BindableEvent")
    local Connection = Event:Once(function(...)
        if not Condition or typeof(Condition) == "function" and Condition(...) then
            Bindable:Fire(true)
        else
            Bindable:Fire(false)
        end
    end)
    task.delay(Timeout, function()
        Connection:Disconnect()
        Bindable:Fire(false)
    end)

    local Result = Bindable.Event:Wait()
    Bindable:Destroy()

    return Result
end

local function IsMouseInput(Input: InputObject, IncludeM2: boolean?)
    return Input.UserInputType == Enum.UserInputType.MouseButton1
        or (IncludeM2 == true and Input.UserInputType == Enum.UserInputType.MouseButton2)
        or Input.UserInputType == Enum.UserInputType.Touch
end
local function IsClickInput(Input: InputObject, IncludeM2: boolean?)
    return IsMouseInput(Input, IncludeM2)
        and Input.UserInputState == Enum.UserInputState.Begin
        and Library.IsRobloxFocused
end
local function IsHoverInput(Input: InputObject)
    return (
        Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch
    ) and Input.UserInputState == Enum.UserInputState.Change
end
local function IsDragInput(Input: InputObject, IncludeM2: boolean?)
    return IsMouseInput(Input, IncludeM2)
        and (Input.UserInputState == Enum.UserInputState.Begin or Input.UserInputState == Enum.UserInputState.Change)
        and Library.IsRobloxFocused
end
local function IsMouseClickInput(Input: InputObject)
    return Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.MouseButton2
        or Input.UserInputType == Enum.UserInputType.MouseButton3
end
local function IsMovementInput(Input: InputObject)
    return (
        Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch
    ) and Library.IsRobloxFocused
end

local function GetTableSize(Table: { [any]: any })
    local Size = 0

    for _, _ in Table do
        Size += 1
    end

    return Size
end
local function StopTween(Tween: TweenBase, Destroy: boolean?)
    if not Tween then
        return
    end

    if Tween.PlaybackState == Enum.PlaybackState.Playing then
        Tween:Cancel()
    end

    if Destroy == true then
        pcall(Tween.Destroy, Tween)
    end
end
local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end
local function Round(Value, Rounding)
    assert(Rounding >= 0, "Invalid rounding number.")

    if Rounding == 0 then
        return math.floor(Value)
    end

    return tonumber(string.format("%." .. Rounding .. "f", Value))
end

local function GetPlayers(ExcludeLocalPlayer: boolean?)
    local PlayerList = Players:GetPlayers()

    if ExcludeLocalPlayer then
        local Idx = table.find(PlayerList, LocalPlayer)
        if Idx then
            table.remove(PlayerList, Idx)
        end
    end

    table.sort(PlayerList, function(Player1, Player2)
        return Player1.Name:lower() < Player2.Name:lower()
    end)

    return PlayerList
end
local function GetTeams()
    local TeamList = Teams:GetTeams()

    table.sort(TeamList, function(Team1, Team2)
        return Team1.Name:lower() < Team2.Name:lower()
    end)

    return TeamList
end

function Library:UpdateDependencyBoxes()
    for _, Depbox in Library.DependencyBoxes do
        Depbox:Update(true)
    end

    if Library.Searching then
        Library:UpdateSearch(Library.SearchText)
    end
end

local function CheckDepbox(Box, Search)
    local VisibleElements = 0

    for _, ElementInfo in Box.Elements do
        if ElementInfo.Type == "Divider" then
            ElementInfo.Holder.Visible = false
            continue
        elseif ElementInfo.SubButton then
            --// Check if any of the Buttons Name matches with Search
            local Visible = false

            --// Check if Search matches Element's Name and if Element is Visible
            if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                Visible = true
            else
                ElementInfo.Base.Visible = false
            end
            if
                ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible
            then
                Visible = true
            else
                ElementInfo.SubButton.Base.Visible = false
            end
            ElementInfo.Holder.Visible = Visible
            if Visible then
                VisibleElements += 1
            end

            continue
        end

        --// Check if Search matches Element's Name and if Element is Visible
        if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
            ElementInfo.Holder.Visible = true
            VisibleElements += 1
        else
            ElementInfo.Holder.Visible = false
        end
    end

    for _, Depbox in Box.DependencyBoxes do
        if not Depbox.Visible then
            continue
        end

        VisibleElements += CheckDepbox(Depbox, Search)
    end

    Box.Holder.Visible = VisibleElements > 0
    return VisibleElements
end
local function RestoreDepbox(Box)
    for _, ElementInfo in Box.Elements do
        ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

        if ElementInfo.SubButton then
            ElementInfo.Base.Visible = ElementInfo.Visible
            ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
        end
    end

    Box:Resize()
    Box.Holder.Visible = true

    for _, Depbox in Box.DependencyBoxes do
        if not Depbox.Visible then
            continue
        end

        RestoreDepbox(Depbox)
    end
end

local function ApplySearchToTab(Tab, Search)
    if not Tab then
        return
    end

    local HasVisible = false

    --// Loop through Groupboxes to get Elements Info
    for _, Groupbox in Tab.Groupboxes do
        if Groupbox.Visible == false then
            continue
        end

        local VisibleElements = 0
        for _, ElementInfo in Groupbox.Elements do
            if ElementInfo.Type == "Divider" then
                ElementInfo.Holder.Visible = false
                continue
            elseif ElementInfo.SubButton then
                --// Check if any of the Buttons Name matches with Search
                local Visible = false

                --// Check if Search matches Element's Name and if Element is Visible
                if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                    Visible = true
                else
                    ElementInfo.Base.Visible = false
                end
                if
                    ElementInfo.SubButton.Text:lower():match(Search)
                    and ElementInfo.SubButton.Visible
                then
                    Visible = true
                else
                    ElementInfo.SubButton.Base.Visible = false
                end
                ElementInfo.Holder.Visible = Visible

                if Visible then
                    VisibleElements += 1
                end

                continue
            end

            --// Check if Search matches Element's Name and if Element is Visible
            if
                ElementInfo.Text
                and ElementInfo.Text:lower():match(Search)
                and ElementInfo.Visible
            then
                ElementInfo.Holder.Visible = true
                VisibleElements += 1
            else
                ElementInfo.Holder.Visible = false
            end
        end

        for _, Depbox in Groupbox.DependencyBoxes do
            if not Depbox.Visible then
                continue
            end

            VisibleElements += CheckDepbox(Depbox, Search)
        end

        --// Update Groupbox Size and Visibility if found any element
        if VisibleElements > 0 then
            Groupbox:Resize()
            HasVisible = true
        end
        Groupbox.BoxHolder.Visible = VisibleElements > 0
    end

    for _, Tabbox in Tab.Tabboxes do
        local VisibleTabs = 0
        local VisibleElements = {}

        for _, SubTab in Tabbox.Tabs do
            VisibleElements[SubTab] = 0

            for _, ElementInfo in SubTab.Elements do
                if ElementInfo.Type == "Divider" then
                    ElementInfo.Holder.Visible = false
                    continue
                elseif ElementInfo.SubButton then
                    --// Check if any of the Buttons Name matches with Search
                    local Visible = false

                    --// Check if Search matches Element's Name and if Element is Visible
                    if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                        Visible = true
                    else
                        ElementInfo.Base.Visible = false
                    end
                    if
                        ElementInfo.SubButton.Text:lower():match(Search)
                        and ElementInfo.SubButton.Visible
                    then
                        Visible = true
                    else
                        ElementInfo.SubButton.Base.Visible = false
                    end
                    ElementInfo.Holder.Visible = Visible
                    if Visible then
                        VisibleElements[SubTab] += 1
                    end

                    continue
                end

                --// Check if Search matches Element's Name and if Element is Visible
                if
                    ElementInfo.Text
                    and ElementInfo.Text:lower():match(Search)
                    and ElementInfo.Visible
                then
                    ElementInfo.Holder.Visible = true
                    VisibleElements[SubTab] += 1
                else
                    ElementInfo.Holder.Visible = false
                end
            end

            for _, Depbox in SubTab.DependencyBoxes do
                if not Depbox.Visible then
                    continue
                end

                VisibleElements[SubTab] += CheckDepbox(Depbox, Search)
            end
        end

        for SubTab, Visible in VisibleElements do
            SubTab.ButtonHolder.Visible = Visible > 0
            if Visible > 0 then
                VisibleTabs += 1
                HasVisible = true

                if Tabbox.ActiveTab == SubTab then
                    SubTab:Resize()
                elseif Tabbox.ActiveTab and VisibleElements[Tabbox.ActiveTab] == 0 then
                    SubTab:Show()
                end
            end
        end

        --// Update Tabbox Visibility if any visible
        Tabbox.BoxHolder.Visible = VisibleTabs > 0
    end

    return HasVisible
end
local function ResetTab(Tab)
    if not Tab then
        return
    end

    for _, Groupbox in Tab.Groupboxes do
        for _, ElementInfo in Groupbox.Elements do
            ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

            if ElementInfo.SubButton then
                ElementInfo.Base.Visible = ElementInfo.Visible
                ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
            end
        end

        for _, Depbox in Groupbox.DependencyBoxes do
            if not Depbox.Visible then
                continue
            end

            RestoreDepbox(Depbox)
        end

        Groupbox:Resize()
        Groupbox.BoxHolder.Visible = Groupbox.Visible ~= false
    end

    for _, Tabbox in Tab.Tabboxes do
        for _, SubTab in Tabbox.Tabs do
            for _, ElementInfo in SubTab.Elements do
                ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

                if ElementInfo.SubButton then
                    ElementInfo.Base.Visible = ElementInfo.Visible
                    ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
                end
            end

            for _, Depbox in SubTab.DependencyBoxes do
                if not Depbox.Visible then
                    continue
                end

                RestoreDepbox(Depbox)
            end

            SubTab.ButtonHolder.Visible = true
        end

        if Tabbox.ActiveTab then
            Tabbox.ActiveTab:Resize()
        end
        Tabbox.BoxHolder.Visible = true
    end
end

function Library:UpdateSearch(SearchText: string)
    assert(typeof(SearchText) == "string", "Search text must be a string")
    Library.SearchText = SearchText

    local TabsToReset = {}

    if Library.GlobalSearch then
        for _, Tab in Library.Tabs do
            if typeof(Tab) == "table" and not Tab.IsKeyTab then
                table.insert(TabsToReset, Tab)
            end
        end
    elseif Library.LastSearchTab and typeof(Library.LastSearchTab) == "table" then
        table.insert(TabsToReset, Library.LastSearchTab)
    end

    for _, Tab in ipairs(TabsToReset) do
        ResetTab(Tab)
    end

    local Search = SearchText:lower()
    if Trim(Search) == "" then
        Library.Searching = false
        Library.LastSearchTab = nil
        return
    end
    if not Library.GlobalSearch and Library.ActiveTab and Library.ActiveTab.IsKeyTab then
        Library.Searching = false
        Library.LastSearchTab = nil
        return
    end

    Library.Searching = true

    local TabsToSearch = {}

    if Library.GlobalSearch then
        TabsToSearch = TabsToReset
        if #TabsToSearch == 0 then
            for _, Tab in Library.Tabs do
                if typeof(Tab) == "table" and not Tab.IsKeyTab then
                    table.insert(TabsToSearch, Tab)
                end
            end
        end
    elseif Library.ActiveTab then
        table.insert(TabsToSearch, Library.ActiveTab)
    end

    local FirstVisibleTab = nil
    local ActiveHasVisible = false

    for _, Tab in ipairs(TabsToSearch) do
        local HasVisible = ApplySearchToTab(Tab, Search)
        if HasVisible then
            if not FirstVisibleTab then
                FirstVisibleTab = Tab
            end
            if Tab == Library.ActiveTab then
                ActiveHasVisible = true
            end
        end
    end

    if Library.GlobalSearch then
        if ActiveHasVisible and Library.ActiveTab then
            Library.ActiveTab:RefreshSides()
        elseif FirstVisibleTab then
            local SearchMarker = SearchText
            task.defer(function()
                if Library.SearchText ~= SearchMarker then
                    return
                end

                if Library.ActiveTab ~= FirstVisibleTab then
                    FirstVisibleTab:Show()
                end
            end)
        end
        Library.LastSearchTab = nil
    else
        Library.LastSearchTab = Library.ActiveTab
    end
end

function Library:AddToRegistry(Instance, Properties)
    Library.Registry[Instance] = Properties
end

function Library:RemoveFromRegistry(Instance)
    Library.Registry[Instance] = nil
end

function Library:UpdateColorsUsingRegistry()
    for Instance, Properties in Library.Registry do
        for Property, Index in Properties do
            local SchemeValue = GetSchemeValue(Index)

            if SchemeValue or typeof(Index) == "function" then
                Instance[Property] = SchemeValue or Index()
            end
        end
    end
end

function Library:SetDPIScale(DPIScale: number)
    assert(typeof(DPIScale) == "number" and DPIScale == DPIScale, "DPI scale must be a number")

    -- Keep layouts usable while allowing applications to choose any sensible scale.
    DPIScale = math.clamp(DPIScale, 25, 300)
    Library.DPIScale = DPIScale / 100
    Library.MinSize = Library.OriginalMinSize * Library.DPIScale

    for _, UIScale in Library.Scales do
        UIScale.Scale = Library.DPIScale - (tonumber(Library.ScalesOffset[UIScale]) or 0)
    end

    for _, Option in Options do
        if Option.Type == "Dropdown" then
            Option:RecalculateListSize()
        end
    end

    for _, Notification in Library.Notifications do
        Notification:Resize()
    end

    Library:UpdateNotificationPositions(true)

    if Library.Window and typeof(Library.Window.RefreshMobileLayout) == "function" then
        Library.Window:RefreshMobileLayout()
    end
end

function Library:GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
    local ConnectionType = typeof(Connection)
    if
        Connection
        and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal")
    then
        table.insert(Library.Signals, Connection)
    end

    return Connection
end

local function IsValidCustomIcon(Icon: string)
    return typeof(Icon) == "string"
        and (
            Icon:match("^rbxasset://textures/")
            or Icon:match("roblox%.com/asset/%?id=")
            or Icon:match("rbxthumb://type=")
        )
end

local function IsCustomAssetIcon(Icon: string, IncludeAssetId: boolean)
    return typeof(Icon) == "string"
        and (
            Icon:match("^content://")
            or Icon:match("^rbxasset://%x+/")
            or (IncludeAssetId == true and Icon:match("^rbxassetid://"))
        )
end

type Icon = {
    Url: string,
    Id: number,
    IconName: string,
    ImageRectOffset: Vector2,
    ImageRectSize: Vector2,
}

type IconModule = {
    Icons: { string },
    GetAsset: (Name: string) -> Icon?,
}

local FetchIcons, Icons = pcall(function()
    return (loadstring(
        game:HttpGet(
            "https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua"
        )
    ) :: () -> IconModule)()
end)

function Library:GetIcon(IconName: string)
    if typeof(IconName) ~= "string" or not FetchIcons or typeof(Icons) ~= "table" then
        return nil
    end

    local GetAsset = Icons.GetAsset
    if typeof(GetAsset) ~= "function" then
        return nil
    end

    local Success, Icon = pcall(GetAsset, IconName)
    if not Success then
        return nil
    end

    return Icon
end

function Library:GetCustomIcon(IconName: string): any
    if not IconName then
        return nil
    end

    if tonumber(IconName) then
        IconName = string.format("rbxassetid://%s", tostring(IconName))
    end

    if IsCustomAssetIcon(IconName, true) then
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
        }
    elseif IsValidCustomIcon(IconName) then
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
            Custom = true,
        }
    end

    local LucideIcon = Library:GetIcon(IconName)
    if LucideIcon then
        return LucideIcon
    end

    return nil
end

function Library:Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
    if typeof(Table) ~= "table" then
        return Template
    end

    for k, v in Template do
        if typeof(k) == "number" then
            continue
        end

        if typeof(v) == "table" then
            Table[k] = Library:Validate(Table[k], v)
        elseif Table[k] == nil then
            Table[k] = v
        end
    end

    return Table
end

--// Creator Functions \\--
local function FillInstance(Table: { [string]: any }, Instance: GuiObject)
    local ThemeProperties = Library.Registry[Instance] or {}

    for key, value in Table do
        if key ~= "Text" then
            local SchemeValue = GetSchemeValue(value)

            if SchemeValue or typeof(value) == "function" then
                ThemeProperties[key] = value
                value = SchemeValue or value()
            else
                ThemeProperties[key] = nil
            end
        end

        Instance[key] = value
    end

    if GetTableSize(ThemeProperties) > 0 then
        Library.Registry[Instance] = ThemeProperties
    end
end

local function New(ClassName: string, Properties: { [string]: any }): any
    local Instance = Instance.new(ClassName)

    if Templates[ClassName] then
        FillInstance(Templates[ClassName], Instance)
    end
    FillInstance(Properties, Instance)

    -- Glass-aware controls: keep interactive buttons and inputs visually consistent
    -- without affecting explicitly transparent layout containers.
    if
        (ClassName == "TextButton" or ClassName == "TextBox" or ClassName == "ImageButton")
        and Properties["BackgroundColor3"] ~= nil
        and Properties["BackgroundTransparency"] == nil
    then
        local Surface = {
            Instance = Instance,
            OpaqueTransparency = Instance.BackgroundTransparency,
        }
        table.insert(Library.GlassSurfaces, Surface)
        RefreshGlassSurface(Surface)
    end

    if Properties["Parent"] and not Properties["ZIndex"] then
        pcall(function()
            Instance.ZIndex = Properties.Parent.ZIndex
        end)
    end

    return Instance
end

--// Main Instances \\-
local function SafeParentUI(Instance: Instance, Parent: Instance | () -> Instance)
    local success, _error = pcall(function()
        if not Parent then
            Parent = CoreGui
        end

        local DestinationParent
        if typeof(Parent) == "function" then
            DestinationParent = Parent()
        else
            DestinationParent = Parent
        end

        Instance.Parent = DestinationParent
    end)

    if not (success and Instance.Parent) then
        Instance.Parent = Library.LocalPlayer:WaitForChild("PlayerGui", math.huge)
    end
end

local function ParentUI(UI: Instance, SkipHiddenUI: boolean?)
    if SkipHiddenUI then
        SafeParentUI(UI, CoreGui)
        return
    end

    pcall(protectgui, UI)
    SafeParentUI(UI, gethui)
end

local ScreenGui = New("ScreenGui", {
    Name = "Cyan",
    DisplayOrder = 998,
    ResetOnSpawn = false,
})
ParentUI(ScreenGui)
Library.ScreenGui = ScreenGui

ScreenGui.DescendantRemoving:Connect(function(Instance)
    Library:RemoveFromRegistry(Instance)
end)

local ModalElement = New("TextButton", {
    BackgroundTransparency = 1,
    Modal = false,
    Size = UDim2.fromScale(0, 0),
    AnchorPoint = Vector2.zero,
    Text = "",
    ZIndex = -999,
    Parent = ScreenGui,
})

--// Cursor
local Cursor, CursorCustomImage
do
    Cursor = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "WhiteColor",
        Size = UDim2.fromOffset(9, 1),
        Visible = false,
        ZIndex = 11000,
        Parent = ScreenGui,
    })
    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 2, 1, 2),
        ZIndex = 10999,
        Parent = Cursor,
    })

    local CursorV = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "WhiteColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(1, 9),
        ZIndex = 11000,
        Parent = Cursor,
    })
    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 2, 1, 2),
        ZIndex = 10999,
        Parent = CursorV,
    })

    CursorCustomImage = New("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(20, 20),
        ZIndex = 11000,
        Visible = false,
        Parent = Cursor,
    })
end

--// Notification \\--
local NotificationArea
local NotifyOrder = {}
do
    NotificationArea = New("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -6, 0, 6),
        Size = UDim2.new(0, 300, 1, -6),
        Parent = ScreenGui,
    })
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = NotificationArea,
        })
    )
end

--// Lib Functions \\--
function Library:ResetCursorIcon()
    CursorCustomImage.Visible = false
    CursorCustomImage.Size = UDim2.fromOffset(20, 20)
end

function Library:ChangeCursorIcon(ImageId: string)
    if not ImageId or ImageId == "" then
        Library:ResetCursorIcon()
        return
    end

    local Icon = Library:GetCustomIcon(ImageId)
    assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

    CursorCustomImage.Visible = true
    CursorCustomImage.Image = Icon.Url
    CursorCustomImage.ImageRectOffset = Icon.ImageRectOffset
    CursorCustomImage.ImageRectSize = Icon.ImageRectSize
end

function Library:ChangeCursorIconSize(Size: UDim2)
    assert(typeof(Size) == "UDim2", "UDim2 expected.")
    CursorCustomImage.Size = Size
end

function Library:GetBetterColor(Color: Color3, Add: number): Color3
    Add = Add * (Library.IsLightTheme and -4 or 2)
    return Color3.fromRGB(
        math.clamp(Color.R * 255 + Add, 0, 255),
        math.clamp(Color.G * 255 + Add, 0, 255),
        math.clamp(Color.B * 255 + Add, 0, 255)
    )
end

function Library:GetLighterColor(Color: Color3): Color3
    local H, S, V = Color:ToHSV()
    return Color3.fromHSV(H, math.max(0, S - 0.1), math.min(1, V + 0.1))
end

function Library:GetDarkerColor(Color: Color3): Color3
    local H, S, V = Color:ToHSV()
    return Color3.fromHSV(H, S, V / 2)
end

function Library:GetKeyString(KeyCode: Enum.KeyCode)
    if KeyCode.EnumType == Enum.KeyCode and KeyCode.Value > 33 and KeyCode.Value < 127 then
        return string.char(KeyCode.Value)
    end

    return KeyCode.Name
end

function Library:GetTextBounds(
    Text: string,
    Font: Font,
    Size: number,
    Width: number?
): (number, number)
    local Params = Instance.new("GetTextBoundsParams")
    Params.Text = Text
    Params.RichText = true
    Params.Font = Font
    Params.Size = Size

    local Camera = workspace.CurrentCamera
    local DefaultWidth = Camera and math.max(1, Camera.ViewportSize.X - 32) or 1920
    Params.Width = Width or DefaultWidth

    local Bounds = TextService:GetTextBoundsAsync(Params)
    return Bounds.X, Bounds.Y
end

function Library:MouseIsOverFrame(Frame: GuiObject, Mouse: Vector2): boolean
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
    return Mouse.X >= AbsPos.X
        and Mouse.X <= AbsPos.X + AbsSize.X
        and Mouse.Y >= AbsPos.Y
        and Mouse.Y <= AbsPos.Y + AbsSize.Y
end

function Library:IsInsideFrame(ParentFrame: GuiObject, Frame: GuiObject)
    local GuiPos = Frame.AbsolutePosition
    local GuiSize = Frame.AbsoluteSize

    local FramePos = ParentFrame.AbsolutePosition
    local FrameSize = ParentFrame.AbsoluteSize

    return GuiPos.X >= FramePos.X
        and GuiPos.X + GuiSize.X <= FramePos.X + FrameSize.X
        and GuiPos.Y >= FramePos.Y
        and GuiPos.Y + GuiSize.Y <= FramePos.Y + FrameSize.Y
end

function Library:SafeCallback(Func: (...any) -> ...any, ...: any)
    if not (Func and typeof(Func) == "function") then
        return
    end

    local Result = table.pack(xpcall(Func, function(Error)
        task.defer(error, debug.traceback(Error, 2))
        if Library.NotifyOnError and Library.Notify then
            Library:Notify(Error)
        end

        return Error
    end, ...))

    if not Result[1] then
        return nil
    end

    return table.unpack(Result, 2, Result.n)
end

function GetOverlappingDraggable(UI: GuiObject, TargetPos: Vector2?)
    local Pos1 = TargetPos or UI.AbsolutePosition
    local Size1 = UI.AbsoluteSize

    for _, Other in ipairs(Library.DraggableElements) do
        if Other == UI or not Other.Visible or not Other.Parent then
            continue
        end

        local Pos2 = Other.AbsolutePosition
        local Size2 = Other.AbsoluteSize

        if
            Pos1.X < Pos2.X + Size2.X
            and Pos1.X + Size1.X > Pos2.X
            and Pos1.Y < Pos2.Y + Size2.Y
            and Pos1.Y + Size1.Y > Pos2.Y
        then
            return Other
        end
    end

    return nil
end

function GetNonOverlappingPosition(UI: GuiObject, StartPos: UDim2?)
    local ScreenSize = (
        workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    ) - Vector2.new(100, 100)
    local Start = StartPos and Vector2.new(StartPos.X.Offset, StartPos.Y.Offset)
        or Vector2.new(6, 6)
    local Padding = 6

    local CurrentX = Start.X
    local CurrentY = Start.Y

    local Size = UI.AbsoluteSize
    if Size.X == 0 and Size.Y == 0 then
        RunService.RenderStepped:Wait()
        Size = UI.AbsoluteSize
    end

    if Size.X == 0 then
        Size = Vector2.new(150, 40)
    end

    local MaxXInColumn = Size.X

    while true do
        local Obstacle = GetOverlappingDraggable(UI, Vector2.new(CurrentX, CurrentY))
        if not Obstacle then
            break
        end

        if Obstacle.AbsoluteSize.X > MaxXInColumn then
            MaxXInColumn = Obstacle.AbsoluteSize.X
        end

        local NextY = Obstacle.AbsolutePosition.Y + Obstacle.AbsoluteSize.Y + Padding
        if NextY + Size.Y > ScreenSize.Y - Padding then
            local NextX = CurrentX + MaxXInColumn + Padding

            if NextX + Size.X > ScreenSize.X - Padding then
                break
            end

            CurrentY = Start.Y
            CurrentX = NextX
            MaxXInColumn = Size.X
        else
            CurrentY = NextY
        end
    end

    return UDim2.fromOffset(CurrentX, CurrentY)
end

function PositionDraggable(UI: GuiObject, StartPos: UDim2?)
    UI.Position = GetNonOverlappingPosition(UI, StartPos)
end

function Library:MakeDraggable(
    UI: GuiObject,
    DragFrame: GuiObject,
    IgnoreToggled: boolean?,
    IsMainWindow: boolean?
)
    local StartPos
    local FramePos
    local Dragging = false
    local Changed
    local InputBegan
    local InputChanged

    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then
            return
        end

        StartPos = Input.Position
        FramePos = UI.Position
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
        if
            (not IgnoreToggled and not Library.Toggled)
            or (IsMainWindow and Library.CantDragForced)
            or not (ScreenGui and ScreenGui.Parent)
        then
            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            UI.Position = UDim2.new(
                FramePos.X.Scale,
                FramePos.X.Offset + Delta.X,
                FramePos.Y.Scale,
                FramePos.Y.Offset + Delta.Y
            )
        end
    end)

    Library:GiveSignal(InputChanged)
    Library:GiveSignal(InputBegan)

    UI.Destroying:Once(function()
        if InputChanged and InputChanged.Connected then
            InputChanged:Disconnect()
        end

        if InputBegan and InputBegan.Connected then
            InputBegan:Disconnect()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end

        local IdxChanged = table.find(Library.Signals, InputChanged)
        if IdxChanged then
            table.remove(Library.Signals, IdxChanged)
        end

        local IdxBegan = table.find(Library.Signals, InputBegan)
        if IdxBegan then
            table.remove(Library.Signals, IdxBegan)
        end
    end)
end

function Library:MakeResizable(UI: GuiObject, DragFrame: GuiObject, Callback: () -> ()?)
    local StartPos
    local FrameSize
    local Dragging = false
    local Changed
    local InputBegan
    local InputChanged

    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end

        StartPos = Input.Position
        FrameSize = UI.Size
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
        if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then
            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            UI.Size = UDim2.new(
                FrameSize.X.Scale,
                math.clamp(FrameSize.X.Offset + Delta.X, Library.MinSize.X, math.huge),
                FrameSize.Y.Scale,
                math.clamp(FrameSize.Y.Offset + Delta.Y, Library.MinSize.Y, math.huge)
            )
            if Callback then
                Library:SafeCallback(Callback)
            end
        end
    end)

    Library:GiveSignal(InputChanged)
    Library:GiveSignal(InputBegan)

    UI.Destroying:Once(function()
        if InputChanged and InputChanged.Connected then
            InputChanged:Disconnect()
        end

        if InputBegan and InputBegan.Connected then
            InputBegan:Disconnect()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end

        local IdxChanged = table.find(Library.Signals, InputChanged)
        if IdxChanged then
            table.remove(Library.Signals, IdxChanged)
        end

        local IdxBegan = table.find(Library.Signals, InputBegan)
        if IdxBegan then
            table.remove(Library.Signals, IdxBegan)
        end
    end)
end

function Library:MakeCover(Holder: GuiObject, Place: string)
    local Pos = Places[Place] or { 0, 0 }
    local Size = Sizes[Place] or { 1, 0.5 }

    local Cover = New("Frame", {
        AnchorPoint = Vector2.new(Pos[1], Pos[2]),
        BackgroundColor3 = Holder.BackgroundColor3,
        Position = UDim2.fromScale(Pos[1], Pos[2]),
        Size = UDim2.fromScale(Size[1], Size[2]),
        Parent = Holder,
    })

    return Cover
end

function Library:MakeLine(Frame: GuiObject, Info)
    local Line = New("Frame", {
        AnchorPoint = Info.AnchorPoint or Vector2.zero,
        BackgroundColor3 = "OutlineColor",
        Position = Info.Position,
        Size = Info.Size,
        ZIndex = Info.ZIndex or Frame.ZIndex,
        Parent = Frame,
    })

    return Line
end

function Library:AddOutline(Frame: GuiObject)
    local OutlineStroke = New("UIStroke", {
        Color = "OutlineColor",
        Thickness = 1,
        ZIndex = 2,
        Parent = Frame,
    })
    local ShadowStroke = New("UIStroke", {
        Color = "DarkColor",
        Thickness = 1.5,
        ZIndex = 1,
        Parent = Frame,
    })
    return OutlineStroke, ShadowStroke
end

function Library:AddBlank(Frame: GuiObject, Size: UDim2)
    return New("Frame", {
        BackgroundTransparency = 1,
        Size = Size or UDim2.fromScale(0, 0),
        Parent = Frame,
    })
end

--// Animations \\--
local TransparencyCache = {}
local ActiveTabTweens = setmetatable({}, { __mode = "k" })

function Library:PlayTabAnimation(TabCanvas: CanvasGroup, Showing: boolean, OnComplete: (() -> ())?)
    if not TabCanvas then
        if OnComplete then
            OnComplete()
        end

        return
    end

    local Existing = ActiveTabTweens[TabCanvas]
    if Existing then
        StopTween(Existing, true)
        ActiveTabTweens[TabCanvas] = nil
    end

    local BaseZIndex = TabCanvas.ZIndex
    if not (Library.Animations and Library.Animations.TabSwitch) then
        TabCanvas.Visible = Showing
        TabCanvas.GroupTransparency = Showing and 0 or 1
        TabCanvas.Position = UDim2.fromScale(0, 0)
        TabCanvas.ZIndex = BaseZIndex

        if OnComplete then
            OnComplete()
        end

        return
    end

    if Showing then
        local TweenInfo = Library.TabTransitionInfo
            or TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Offset = Library.TabSwipeOffset or 26
        local SwipeFrom = string.lower(Library.TabSwipeFrom or "bottom")
        local StartPosition

        if SwipeFrom == "left" then
            StartPosition = UDim2.fromOffset(-Offset, 0)
        elseif SwipeFrom == "top" then
            StartPosition = UDim2.fromOffset(0, -Offset)
        elseif SwipeFrom == "right" then
            StartPosition = UDim2.fromOffset(Offset, 0)
        else -- bottom (Default)
            StartPosition = UDim2.fromOffset(0, Offset)
        end

        TabCanvas.ZIndex = BaseZIndex + 1
        TabCanvas.GroupTransparency = 1
        TabCanvas.Position = StartPosition
        TabCanvas.Visible = true

        local Tween = TweenService:Create(TabCanvas, TweenInfo, {
            GroupTransparency = 0,
            Position = UDim2.fromScale(0, 0),
        })

        ActiveTabTweens[TabCanvas] = Tween
        Tween:Play()

        local Connection
        Connection = Tween.Completed:Connect(function(PlaybackState)
            if Connection then
                Connection:Disconnect()
            end

            if ActiveTabTweens[TabCanvas] == Tween then
                ActiveTabTweens[TabCanvas] = nil
            end

            if PlaybackState == Enum.PlaybackState.Cancelled then
                return
            end

            TabCanvas.ZIndex = BaseZIndex
            if OnComplete then
                OnComplete()
            end
        end)
    else
        TabCanvas.GroupTransparency = 1
        TabCanvas.Visible = false
        TabCanvas.Position = UDim2.fromScale(0, 0)
        TabCanvas.ZIndex = BaseZIndex

        if OnComplete then
            OnComplete()
        end
    end
end

--// Deprecated \\--
function Library:MakeOutline(Frame: GuiObject, Corner: number?, ZIndex: number?)
    warn("Cyan:MakeOutline is deprecated, please use Cyan:AddOutline instead.")
    local Holder = New("Frame", {
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromOffset(-2, -2),
        Size = UDim2.new(1, 4, 1, 4),
        ZIndex = ZIndex,
        Parent = Frame,
    })

    local Outline = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = ZIndex,
        Parent = Holder,
    })

    if Corner and Corner > 0 then
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner + 1),
            Parent = Holder,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner),
            Parent = Outline,
        })
    end

    return Holder, Outline
end

function Library:AddDraggableLabel(...)
    local Params = select(1, ...)
    local Text
    local Icon
    local IconPosition = "left"

    if typeof(Params) == "table" then
        Text = Params.Text
        Icon = Params.Icon
        IconPosition = Params.IconPosition or "left"
    elseif typeof(Params) == "string" then
        Text = Params
        Icon = select(2, ...)
        IconPosition = select(3, ...) or "left"
    end

    if typeof(IconPosition) ~= "string" then
        IconPosition = "left"
    end

    IconPosition = string.lower(IconPosition)
    assert(
        IconPosition == "left" or IconPosition == "right",
        "Icon Position needs to be either 'left' or 'right'."
    )

    local DraggableLabel = {
        Connections = {},
        Destroyed = false,
    }

    local IconImage
    local Label = New("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = "BackgroundColor",
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.fromOffset(6, 6),
        Text = Text,
        TextSize = 15,
        ZIndex = 10,
        Parent = ScreenGui,
    })

    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Label,
        })
    )

    local Padding = New("UIPadding", {
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 6),
        Parent = Label,
    })
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Label,
        })
    )

    Library:AddOutline(Label)
    Library:MakeDraggable(Label, Label, true)

    function DraggableLabel:SetText(Text: string)
        Label.Text = Text
    end

    function DraggableLabel:SetIcon(NewIcon: string)
        Icon = NewIcon

        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
        if IsNotEmpty then
            local CustomIcon = Library:GetCustomIcon(Icon)
            assert(
                CustomIcon,
                "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon."
            )

            IconImage = IconImage
                or New("ImageLabel", {
                    BackgroundTransparency = 1,
                    ImageColor3 = "FontColor",
                    Size = UDim2.fromOffset(16, 16),
                    ZIndex = 11,
                    Parent = Label,
                })

            IconImage.Image = CustomIcon.Url
            IconImage.ImageRectOffset = CustomIcon.ImageRectOffset
            IconImage.ImageRectSize = CustomIcon.ImageRectSize
        end

        if IconImage then
            IconImage.Visible = IsNotEmpty
        end
        DraggableLabel:SetIconPosition(IconPosition)
    end

    function DraggableLabel:SetIconPosition(NewPosition: string)
        IconPosition = string.lower(NewPosition)
        assert(
            IconPosition == "left" or IconPosition == "right",
            "Icon Position needs to be either 'left' or 'right'."
        )

        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
        Padding.PaddingLeft = UDim.new(0, (IsNotEmpty and IconPosition == "left") and 34 or 12)
        Padding.PaddingRight = UDim.new(0, (IsNotEmpty and IconPosition == "right") and 34 or 12)

        if IconImage then
            if IconPosition == "left" then
                IconImage.AnchorPoint = Vector2.new(0, 0.5)
                IconImage.Position = UDim2.new(0, -22, 0.5, 0)
            else
                IconImage.AnchorPoint = Vector2.new(1, 0.5)
                IconImage.Position = UDim2.new(1, 22, 0.5, 0)
            end
        end
    end

    function DraggableLabel:SetVisible(Visible: boolean)
        Label.Visible = Visible
    end

    DraggableLabel:SetIcon(Icon)
    DraggableLabel.Label = Label

    if not table.find(Library.DraggableElements, Label) then
        table.insert(Library.DraggableElements, Label)
    end

    PositionDraggable(Label, Label.Position)

    function DraggableLabel:Destroy()
        DraggableLabel.Destroyed = true

        if DraggableLabel.Connections then
            for _, connection in DraggableLabel.Connections do
                connection:Disconnect()
            end
        end

        local ElemIdx = table.find(Library.DraggableElements, Label)
        if ElemIdx then
            table.remove(Library.DraggableElements, ElemIdx)
        end

        if Label then
            Label:Destroy()
        end
    end

    return DraggableLabel
end

function Library:AddDraggableButton(...)
    local Params = select(1, ...)

    local Text
    local Func
    local ExcludeScaling
    local ExcludeDragging

    if typeof(Params) == "table" then
        Text = Params.Text
        Func = Params.Callback or Params.Func
        ExcludeScaling = Params.ExcludeScaling
        ExcludeDragging = Params.ExcludeDragging
    elseif typeof(Params) == "string" then
        Text = Params
        Func = select(2, ...)
        ExcludeScaling = select(3, ...)
        ExcludeDragging = select(4, ...)
    end

    local DraggableButton = {
        Connections = {},
        Destroyed = false,
    }

    local Button = New("TextButton", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        TextSize = 16,
        ZIndex = 10,
        Parent = ScreenGui,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Button,
        })
    )
    if not ExcludeScaling then
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Button,
            })
        )
    end
    Library:AddOutline(Button)

    local DragThreshold = if ExcludeDragging then 0.25 else math.huge
    Button.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end

        local Start = tick()

        local Changed
        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            local IsLikelyDragging = tick() - Start > DragThreshold
            if IsLikelyDragging then
                return
            end

            Library:SafeCallback(Func, DraggableButton)

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    function DraggableButton:SetText(Text: string)
        local X, Y = Library:GetTextBounds(Text, Library.Scheme.Font, 16)

        Button.Text = Text
        Button.Size = UDim2.fromOffset(X * 2, Y * 2)
    end

    Library:MakeDraggable(Button, Button, true)
    DraggableButton:SetText(Text)
    DraggableButton.Button = Button

    if not table.find(Library.DraggableElements, Button) then
        table.insert(Library.DraggableElements, Button)
    end

    PositionDraggable(Button, Button.Position)

    function DraggableButton:Destroy()
        DraggableButton.Destroyed = true

        if DraggableButton.Connections then
            for _, connection in DraggableButton.Connections do
                connection:Disconnect()
            end
        end

        local ElemIdx = table.find(Library.DraggableElements, Button)
        if ElemIdx then
            table.remove(Library.DraggableElements, ElemIdx)
        end

        if Button then
            Button:Destroy()
        end
    end

    return DraggableButton
end

function Library:AddDraggableMenu(Name: string)
    local Holder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(0, 0),
        ZIndex = 10,
        Parent = ScreenGui,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Holder,
        })
    )
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Holder,
        })
    )
    Library:AddOutline(Holder)

    Library:MakeLine(Holder, {
        Position = UDim2.fromOffset(0, 34),
        Size = UDim2.new(1, 0, 0, 1),
    })

    local Label = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        Text = Name,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder,
    })
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = Label,
    })

    local Container = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 35),
        Size = UDim2.new(1, 0, 1, -35),
        Parent = Holder,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 7),
        Parent = Container,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 7),
        PaddingLeft = UDim.new(0, 7),
        PaddingRight = UDim.new(0, 7),
        PaddingTop = UDim.new(0, 7),
        Parent = Container,
    })

    Library:MakeDraggable(Holder, Label, true)

    if not table.find(Library.DraggableElements, Holder) then
        table.insert(Library.DraggableElements, Holder)
    end

    PositionDraggable(Holder, Holder.Position)

    return Holder, Container
end

function Library:AddDraggableImageButton(...)
    local Params = select(1, ...)

    local Icon
    local IconSize
    local Func
    local ExcludeScaling
    local ExcludeDragging

    if typeof(Params) == "table" then
        Icon = Params.Icon
        IconSize = Params.IconSize or 24
        Func = Params.Callback or Params.Func
        ExcludeScaling = Params.ExcludeScaling
        ExcludeDragging = Params.ExcludeDragging
    elseif typeof(Params) == "string" or typeof(Params) == "number" then
        Icon = Params
        IconSize = select(2, ...)
        Func = select(3, ...)
        ExcludeScaling = select(4, ...)
        ExcludeDragging = select(5, ...)
    end

    local DraggableImageButton = {}

    local Button = New("TextButton", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(IconSize + 12, IconSize + 12),
        Text = "",
        ZIndex = 10,
        Parent = ScreenGui,
    })

    local IconImage = New("ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(IconSize, IconSize),
        ImageColor3 = "FontColor",
        ZIndex = 11,
        Parent = Button,
    })

    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Button,
        })
    )
    if not ExcludeScaling then
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Button,
            })
        )
    end
    Library:AddOutline(Button)

    local DragThreshold = if ExcludeDragging then 0.25 else math.huge
    Button.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end

        local Start = tick()

        local Changed
        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            local IsLikelyDragging = tick() - Start > DragThreshold
            if IsLikelyDragging then
                return
            end

            Library:SafeCallback(Func, DraggableImageButton)

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    function DraggableImageButton:SetIcon(NewIcon: string)
        Icon = NewIcon or Icon

        local CustomIcon = Library:GetCustomIcon(Icon)
        assert(
            CustomIcon,
            "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon."
        )

        IconImage.Image = CustomIcon.Url
        IconImage.ImageRectOffset = CustomIcon.ImageRectOffset
        IconImage.ImageRectSize = CustomIcon.ImageRectSize
    end

    function DraggableImageButton:SetIconSize(NewSize: number)
        IconSize = NewSize
        IconImage.Size = UDim2.fromOffset(IconSize, IconSize)
        Button.Size = UDim2.fromOffset(IconSize + 12, IconSize + 12)
    end

    Library:MakeDraggable(Button, Button, true)
    DraggableImageButton:SetIcon(Icon)
    DraggableImageButton.Button = Button

    if not table.find(Library.DraggableElements, Button) then
        table.insert(Library.DraggableElements, Button)
    end

    PositionDraggable(Button, Button.Position)

    return DraggableImageButton
end

--// Watermark - Deprecated \\--
do
    local WatermarkLabel = Library:AddDraggableLabel("")
    WatermarkLabel:SetVisible(false)

    function Library:SetWatermark(Text: string)
        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
        WatermarkLabel:SetText(Text)
    end

    function Library:SetWatermarkVisibility(Visible: boolean)
        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
        WatermarkLabel:SetVisible(Visible)
    end
end

--// Context Menu \\--
local CurrentMenu
function Library:AddContextMenu(
    Holder: GuiObject,
    Size: UDim2 | () -> (),
    Offset: { [number]: number } | () -> {},
    List: number?,
    ActiveCallback: (Active: boolean) -> ()?,
    IgnoreCornerRadius: boolean?,
    SpecificCornersOnly: ("top" | "bottom" | "no_left" | "no_top_left")?, -- stupid way of doing this
    AnimationType: ("Dropdown" | "KeyPicker" | "none")?
)
    local Menu
    local ParentGui = Holder:FindFirstAncestorOfClass("ScreenGui")
    local MenuZIndex = math.max(10, Holder.ZIndex + 1)
    if
        ParentGui ~= ScreenGui
        and (Library.ActiveLoading and ParentGui ~= Library.ActiveLoading.ScreenGui)
    then
        ParentGui = ScreenGui
    end

    if List then
        Menu = New("ScrollingFrame", {
            AutomaticCanvasSize = List == 2 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            AutomaticSize = List == 1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            BackgroundColor3 = "BackgroundColor",
            BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarImageColor3 = "OutlineColor",
            ScrollBarThickness = List == 2 and 2 or 0,
            Size = typeof(Size) == "function" and Size() or Size,
            TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            Visible = false,
            ZIndex = MenuZIndex,
            Parent = ParentGui,
        })
    else
        Menu = New("Frame", {
            BackgroundColor3 = "BackgroundColor",
            Size = typeof(Size) == "function" and Size() or Size,
            Visible = false,
            ZIndex = MenuZIndex,
            Parent = ParentGui,
        })
    end
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Menu,
        })
    )

    New("UIStroke", {
        Color = "OutlineColor",
        Parent = Menu,
    })

    local Corner
    if IgnoreCornerRadius ~= true then
        if SpecificCornersOnly == "top" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, 0),
                BottomLeftRadius = UDim.new(0, 0),
                Parent = Menu,
            })
            table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "bottom" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, 0),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            })
            table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "no_left" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, 0),
                Parent = Menu,
            })
            table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "no_top_left" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            })
            table.insert(Library.SpecificCorners, Corner)
        else
            Corner = New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            })
            table.insert(Library.Corners, Corner)
        end
    end

    local Table = {
        Connections = {},
        Destroyed = false,

        Active = false,
        Holder = Holder,
        Menu = Menu,
        List = nil,
        Signal = nil,

        Size = Size,

        AutoSizeY = List == 1,
        OpenCloseTween = nil,
        Animated = function()
            if not AnimationType or AnimationType == "none" then
                return false
            end

            if not (Library.Animations and Library.Animations[AnimationType] == true) then
                return false
            end

            return true,
                Library[string.format("%sTransitionInfo", AnimationType)] or TweenInfo.new(
                    0.18,
                    Enum.EasingStyle.Quad,
                    Enum.EasingDirection.Out
                )
        end,
    }

    if List then
        Table.List = New("UIListLayout", {
            Parent = Menu,
        })
    end

    function Table:Open()
        if CurrentMenu == Table then
            return
        elseif CurrentMenu then
            CurrentMenu:Close()
        end

        CurrentMenu = Table
        Table.Active = true

        if typeof(Offset) == "function" then
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset()[2])
            )
        else
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset[2])
            )
        end

        local TargetSize = typeof(Table.Size) == "function" and Table.Size() or Table.Size

        if typeof(ActiveCallback) == "function" then
            Library:SafeCallback(ActiveCallback, true)
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local IsAnimated, TweenInfo = Table.Animated()
        if IsAnimated == true then
            local OpenSize = TargetSize
            if Table.AutoSizeY then
                local FullHeight = Menu.AbsoluteSize.Y

                Menu.AutomaticSize = Enum.AutomaticSize.None
                OpenSize = UDim2.new(TargetSize.X.Scale, TargetSize.X.Offset, 0, FullHeight)
            end

            Menu.Size = UDim2.new(OpenSize.X.Scale, OpenSize.X.Offset, 0, 0)
            Menu.Visible = true

            local Tween = TweenService:Create(Menu, TweenInfo, { Size = OpenSize })
            Table.OpenCloseTween = Tween

            local Connection
            Connection = Library:GiveSignal(Tween.Completed:Once(function()
                if Connection then
                    Connection:Disconnect()
                end

                if Table.OpenCloseTween == Tween then
                    StopTween(Table.OpenCloseTween, true)
                    Table.OpenCloseTween = nil

                    if Table.AutoSizeY then
                        Menu.AutomaticSize = Enum.AutomaticSize.Y
                    end
                end
            end))

            Tween:Play()
        else
            Menu.Size = TargetSize
            Menu.Visible = true
        end

        Table.Signal = Holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if typeof(Offset) == "function" then
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset()[2])
                )
            else
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset[2])
                )
            end

            if not Library:IsInsideFrame(Library.WindowContainer, Holder) and Table.Active then
                Table:Close()
            end
        end)
    end

    function Table:Close()
        if CurrentMenu ~= Table then
            return
        end

        if Table.Signal then
            Table.Signal:Disconnect()
            Table.Signal = nil
        end

        Table.Active = false
        CurrentMenu = nil

        if typeof(ActiveCallback) == "function" then
            Library:SafeCallback(ActiveCallback, false)
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local IsAnimated, TweenInfo = Table.Animated()
        if IsAnimated == true then
            if Table.AutoSizeY then
                Menu.AutomaticSize = Enum.AutomaticSize.None
            end

            local CurrentSize = Menu.Size
            local CollapsedSize = UDim2.new(CurrentSize.X.Scale, CurrentSize.X.Offset, 0, 0)

            local Tween = TweenService:Create(Menu, TweenInfo, { Size = CollapsedSize })
            Table.OpenCloseTween = Tween

            local Connection
            Connection = Library:GiveSignal(Tween.Completed:Once(function(PlaybackState)
                if Connection then
                    Connection:Disconnect()
                end

                if Table.OpenCloseTween == Tween then
                    StopTween(Table.OpenCloseTween, true)
                    Table.OpenCloseTween = nil

                    Menu.Visible = false
                    if Table.AutoSizeY then
                        Menu.AutomaticSize = Enum.AutomaticSize.Y
                    end
                end
            end))

            Tween:Play()
        else
            Menu.Visible = false
        end
    end

    function Table:Toggle()
        if Table.Active then
            Table:Close()
        else
            Table:Open()
        end
    end

    function Table:SetSize(Size)
        Table.Size = Size
        Menu.Size = typeof(Size) == "function" and Size() or Size
    end

    function Table:Destroy()
        Table.Destroyed = true

        if Table.Connections then
            for _, Connection in Table.Connections do
                Connection:Disconnect()
            end
        end

        if CurrentMenu == Table then
            Table:Close()
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        if Menu then
            Menu:Destroy()
        end
    end

    return Table
end

function Library:CloseTransientUI(): boolean
    if CurrentMenu then
        CurrentMenu:Close()
        return true
    end

    local Dialog = Library.ActiveDialog
    if Dialog and Dialog.OutsideClickDismiss then
        Dialog:Dismiss()
        return true
    end

    return false
end

Library:GiveSignal(
    UserInputService.InputBegan:Connect(function(Input: InputObject, GameProcessedEvent: boolean)
        if Library.Unloaded then
            return
        end

        if Input.KeyCode == Enum.KeyCode.Escape then
            -- Do not dismiss a menu or dialog while the user is editing text.
            if not UserInputService:GetFocusedTextBox() then
                Library:CloseTransientUI()
            end
            return
        end

        if GameProcessedEvent then
            return
        end

        if IsClickInput(Input, true) then
            local Location = Input.Position

            if
                CurrentMenu
                and not (
                    Library:MouseIsOverFrame(CurrentMenu.Menu, Location)
                    or Library:MouseIsOverFrame(CurrentMenu.Holder, Location)
                )
            then
                CurrentMenu:Close()
            end
        end
    end)
)

--// Tooltip \\--
local TooltipLabel = New("TextLabel", {
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = "BackgroundColor",
    TextSize = 14,
    TextWrapped = true,
    Visible = false,
    ZIndex = 20,
    Parent = ScreenGui,
})
New("UIPadding", {
    PaddingBottom = UDim.new(0, 2),
    PaddingLeft = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4),
    PaddingTop = UDim.new(0, 2),
    Parent = TooltipLabel,
})
table.insert(
    Library.Scales,
    New("UIScale", {
        Parent = TooltipLabel,
    })
)
New("UIStroke", {
    Color = "OutlineColor",
    Parent = TooltipLabel,
})
table.insert(
    Library.Corners,
    New("UICorner", {
        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
        Parent = TooltipLabel,
    })
)
TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    if Library.Unloaded then
        return
    end

    local X, _ = Library:GetTextBounds(
        TooltipLabel.Text,
        TooltipLabel.FontFace,
        TooltipLabel.TextSize,
        (workspace.CurrentCamera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 8)
            / Library.DPIScale
    )

    TooltipLabel.Size = UDim2.fromOffset(X + 8, 0)
end)

local CurrentHoverInstance
function Library:AddTooltip(InfoStr: string, DisabledInfoStr: string, HoverInstance: GuiObject)
    local TooltipTable = {
        Disabled = false,
        Hovering = false,
        Signals = {},
    }

    local function DoHover()
        if
            CurrentHoverInstance == HoverInstance
            or Library.ActiveDialog
            or (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
            or (TooltipTable.Disabled and typeof(DisabledInfoStr) ~= "string")
            or (not TooltipTable.Disabled and typeof(InfoStr) ~= "string")
        then
            return
        end
        CurrentHoverInstance = HoverInstance

        local ParentGui = HoverInstance:FindFirstAncestorOfClass("ScreenGui")
        if
            ParentGui ~= ScreenGui
            and (Library.ActiveLoading and ParentGui ~= Library.ActiveLoading.ScreenGui)
        then
            ParentGui = ScreenGui
        end
        TooltipLabel.Parent = ParentGui

        TooltipLabel.Text = TooltipTable.Disabled and DisabledInfoStr or InfoStr
        TooltipLabel.Visible = true

        while
            (Library.Toggled or Library.ActiveLoading)
            and not Library.ActiveDialog
            and Library:MouseIsOverFrame(HoverInstance, Mouse)
            and not (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
        do
            TooltipLabel.Position = UDim2.fromOffset(
                Mouse.X + (Library.ShowCustomCursor and 8 or 14),
                Mouse.Y + (Library.ShowCustomCursor and 8 or 12)
            )

            RunService.RenderStepped:Wait()
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
    end

    local function GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
        local ConnectionType = typeof(Connection)
        if
            Connection
            and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal")
        then
            table.insert(TooltipTable.Signals, Connection)
        end

        return Connection
    end

    GiveSignal(HoverInstance.MouseEnter:Connect(DoHover))
    GiveSignal(HoverInstance.MouseMoved:Connect(DoHover))
    GiveSignal(HoverInstance.MouseLeave:Connect(function()
        if CurrentHoverInstance ~= HoverInstance then
            return
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
    end))

    function TooltipTable:Destroy()
        for Index = #TooltipTable.Signals, 1, -1 do
            local Connection = table.remove(TooltipTable.Signals, Index)
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end

        if CurrentHoverInstance == HoverInstance then
            if TooltipLabel then
                TooltipLabel.Visible = false
            end

            CurrentHoverInstance = nil
        end
    end

    table.insert(Tooltips, TooltipLabel)
    return TooltipTable
end

function Library:OnUnload(Callback)
    table.insert(Library.UnloadSignals, Callback)
end

local CheckIcon = Library:GetIcon("check")
local ArrowIcon = Library:GetIcon("chevron-up")
local ResizeIcon = Library:GetIcon("move-diagonal-2")
local KeyIcon = Library:GetIcon("key")
local MoveIcon = Library:GetIcon("move")

function Library:SetIconModule(module: IconModule)
    assert(
        typeof(module) == "table" and typeof(module.GetAsset) == "function",
        "Invalid icon module"
    )

    FetchIcons = true
    Icons = module

    CheckIcon = Library:GetIcon("check")
    ArrowIcon = Library:GetIcon("chevron-up")
    ResizeIcon = Library:GetIcon("move-diagonal-2")
    KeyIcon = Library:GetIcon("key")
    MoveIcon = Library:GetIcon("move")
end

local BaseAddons = {}
do
    local Funcs = {}

    function Funcs:AddKeyPicker(Idx, Info)
        if self.Destroyed then
            return nil
        end

        Info = Library:Validate(Info, Templates.KeyPicker)

        local ParentObj = self
        local ToggleLabel = ParentObj.TextLabel

        if ParentObj.Type == "Button" or ParentObj.Type == "SubButton" then
            assert(
                Info.Mode == "Press",
                "KeyPicker on Buttons can only be applied with the 'Press' mode."
            )

            ToggleLabel = ParentObj.Base
        end

        local KeyPicker = {
            Connections = {},

            Text = Info.Text,
            Value = Info.Default, -- Key
            Modifiers = Info.DefaultModifiers, -- Modifiers
            DisplayValue = Info.Default, -- Picker Text

            Blacklisted = Info.Blacklisted,
            BlacklistedModifiers = Info.BlacklistedModifiers,
            Whitelisted = Info.Whitelisted,
            WhitelistedModifiers = Info.WhitelistedModifiers,

            Toggled = false,
            Mode = Info.Mode,
            SyncToggleState = Info.SyncToggleState,

            Callback = Info.Callback,
            ChangedCallback = Info.ChangedCallback,
            Changed = Info.Changed,
            Clicked = Info.Clicked,

            Type = "KeyPicker",
        }

        if KeyPicker.Mode == "Press" then
            assert(
                ParentObj.Type == "Label"
                    or ParentObj.Type == "Button"
                    or ParentObj.Type == "SubButton",
                "KeyPicker with the mode 'Press' can be only applied on Labels and Buttons."
            )

            KeyPicker.SyncToggleState = false
            Info.Modes = { "Press" }
            Info.Mode = "Press"
        end

        if KeyPicker.SyncToggleState then
            Info.Modes = { "Toggle", "Hold" }

            if not table.find(Info.Modes, Info.Mode) then
                Info.Mode = "Toggle"
            end
        end

        local Picking = false
        local IsForButton = ParentObj.Type == "Button" or ParentObj.Type == "SubButton"

        -- Special Keys
        local SpecialKeys = {
            ["MB1"] = Enum.UserInputType.MouseButton1,
            ["MB2"] = Enum.UserInputType.MouseButton2,
            ["MB3"] = Enum.UserInputType.MouseButton3,
        }

        local SpecialKeysInput = {
            [Enum.UserInputType.MouseButton1] = "MB1",
            [Enum.UserInputType.MouseButton2] = "MB2",
            [Enum.UserInputType.MouseButton3] = "MB3",
        }

        -- Modifiers
        local Modifiers = {
            ["LAlt"] = Enum.KeyCode.LeftAlt,
            ["RAlt"] = Enum.KeyCode.RightAlt,

            ["LCtrl"] = Enum.KeyCode.LeftControl,
            ["RCtrl"] = Enum.KeyCode.RightControl,

            ["LShift"] = Enum.KeyCode.LeftShift,
            ["RShift"] = Enum.KeyCode.RightShift,

            ["Tab"] = Enum.KeyCode.Tab,
            ["CapsLock"] = Enum.KeyCode.CapsLock,
        }

        local ModifiersInput = {
            [Enum.KeyCode.LeftAlt] = "LAlt",
            [Enum.KeyCode.RightAlt] = "RAlt",

            [Enum.KeyCode.LeftControl] = "LCtrl",
            [Enum.KeyCode.RightControl] = "RCtrl",

            [Enum.KeyCode.LeftShift] = "LShift",
            [Enum.KeyCode.RightShift] = "RShift",

            [Enum.KeyCode.Tab] = "Tab",
            [Enum.KeyCode.CapsLock] = "CapsLock",
        }

        local IsModifierInput = function(Input)
            return Input.UserInputType == Enum.UserInputType.Keyboard
                and ModifiersInput[Input.KeyCode] ~= nil
        end

        local GetActiveModifiers = function()
            local ActiveModifiers = {}

            for Name, Input in Modifiers do
                if table.find(ActiveModifiers, Name) then
                    continue
                end
                if not UserInputService:IsKeyDown(Input) then
                    continue
                end

                table.insert(ActiveModifiers, Name)
            end

            return ActiveModifiers
        end

        local AreModifiersHeld = function(Required)
            if not (typeof(Required) == "table" and GetTableSize(Required) > 0) then
                return true
            end

            local ActiveModifiers = GetActiveModifiers()
            local Holding = true

            for _, Name in Required do
                if table.find(ActiveModifiers, Name) then
                    continue
                end

                Holding = false
                break
            end

            return Holding
        end

        local IsInputDown = function(Input)
            if not Input then
                return false
            end

            if SpecialKeysInput[Input.UserInputType] ~= nil then
                return UserInputService:IsMouseButtonPressed(Input.UserInputType)
                    and not UserInputService:GetFocusedTextBox()
            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                return UserInputService:IsKeyDown(Input.KeyCode)
                    and not UserInputService:GetFocusedTextBox()
            else
                return false
            end
        end

        local ConvertToInputModifiers = function(CurrentModifiers)
            local InputModifiers = {}

            for _, name in CurrentModifiers do
                table.insert(InputModifiers, Modifiers[name])
            end

            return InputModifiers
        end

        local VerifyModifiers = function(CurrentModifiers)
            if typeof(CurrentModifiers) ~= "table" then
                return {}
            end

            local ValidModifiers = {}

            for _, name in CurrentModifiers do
                if not Modifiers[name] then
                    continue
                end

                table.insert(ValidModifiers, name)
            end

            return ValidModifiers
        end

        KeyPicker.Modifiers = VerifyModifiers(KeyPicker.Modifiers)

        local SlideOverflow = true
        local MaxPickerWidth = 75
        local SlidingLabel

        local LastPickerWidth = 0
        local SlideForwardTween
        local SlideBackTween
        local HandleForwardTween = function(State)
            if State ~= Enum.PlaybackState.Completed then
                return
            end

            task.wait(1.5)
            if SlideBackTween then
                SlideBackTween:Play()
            end
        end

        local HandleBackTween = function(State)
            if State ~= Enum.PlaybackState.Completed then
                return
            end

            task.wait(1.5)
            if SlideForwardTween then
                SlideForwardTween:Play()
            end
        end

        local CancelSlidingTweens = function()
            if SlideForwardTween then
                StopTween(SlideForwardTween, true)
                SlideForwardTween = nil
            end

            if SlideBackTween then
                SlideForwardTween(SlideBackTween, true)
                SlideBackTween = nil
            end
        end

        local Picker = New("TextButton", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromOffset(18, 18),
            Text = (IsForButton and SlideOverflow) and "" or KeyPicker.Value,
            TextSize = 14,
            Parent = ToggleLabel,
        })

        if IsForButton and SlideOverflow then
            Picker.ClipsDescendants = true

            SlidingLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Text = KeyPicker.Value,
                TextSize = 14,
                FontFace = Picker.FontFace,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = Picker,
            })

            Library:AddToRegistry(SlidingLabel, {
                TextColor3 = "FontColor",
            })
        end

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Picker,
        })

        local PickerCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = Picker,
        })
        table.insert(Library.SpecificCorners, PickerCorner)

        if IsForButton then
            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 21),
                Parent = ToggleLabel.Parent,
            })

            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDim.new(0, 9),
                Parent = Holder,
            })

            ToggleLabel.Parent = Holder
            Picker.Parent = Holder

            Picker.Size = UDim2.new(0, 18, 1, 0)
        end

        local KeybindsToggle = { Normal = KeyPicker.Mode ~= "Toggle" }
        do
            local Holder = New("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                Text = "",
                Visible = not Info.NoUI,
                Parent = Library.KeybindContainer,
            })

            local Label = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0, 1),
                Text = "",
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = Holder,
            })

            local Checkbox = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromOffset(14, 14),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = Holder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Checkbox,
                })
            )
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Checkbox,
            })

            local CheckImage = New("ImageLabel", {
                Image = CheckIcon and CheckIcon.Url or "",
                ImageColor3 = "FontColor",
                ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
                ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
                ImageTransparency = 1,
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Parent = Checkbox,
            })

            function KeybindsToggle:Display(State)
                Label.TextTransparency = State and 0 or 0.5
                CheckImage.ImageTransparency = State and 0 or 1
            end

            function KeybindsToggle:SetText(Text)
                Label.Text = Text
            end

            function KeybindsToggle:SetVisibility(Visibility)
                Holder.Visible = Visibility
            end

            function KeybindsToggle:SetNormal(Normal)
                KeybindsToggle.Normal = Normal

                Holder.Active = not Normal
                Label.Position = Normal and UDim2.fromOffset(0, 0) or UDim2.fromOffset(22, 0)
                Checkbox.Visible = not Normal
            end

            KeyPicker.DoClick = function(...) end --// make luau lsp shut up
            Holder.MouseButton1Click:Connect(function()
                if KeybindsToggle.Normal then
                    return
                end

                KeyPicker.Toggled = not KeyPicker.Toggled
                KeyPicker:DoClick()
            end)

            KeybindsToggle.Holder = Holder
            KeybindsToggle.Label = Label
            KeybindsToggle.Checkbox = Checkbox
            KeybindsToggle.Loaded = true
            table.insert(Library.KeybindToggles, KeybindsToggle)
        end

        local ModeButtons = {}
        local TotalModeButtons = GetTableSize(Info.Modes)
        local MenuTable = Library:AddContextMenu(
            Picker,
            UDim2.fromOffset(62, 0),
            function()
                return { Picker.AbsoluteSize.X + 1.5, 0.5 }
            end,
            1,
            function(Active: boolean)
                PickerCorner.TopRightRadius = Active and UDim.new(0, 0)
                    or UDim.new(0, Library.CornerRadius / 2)
                PickerCorner.BottomRightRadius = Active and UDim.new(0, 0)
                    or UDim.new(0, Library.CornerRadius / 2)
            end,
            false,
            if TotalModeButtons == 1 then "no_left" else "no_top_left",
            "KeyPicker"
        )
        KeyPicker.Menu = MenuTable

        for Index, Mode in Info.Modes do
            local ModeButton = {}

            local Button = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(
                    1,
                    0,
                    0,
                    IsForButton and 21 or (TotalModeButtons == 1 and 18 or 19)
                ),
                Text = Mode,
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = MenuTable.Menu,
            })

            if Index == 1 and TotalModeButtons == 1 then
                table.insert(
                    Library.SpecificCorners,
                    New("UICorner", {
                        TopLeftRadius = UDim.new(0, 0),
                        TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                        BottomLeftRadius = UDim.new(0, 0),
                        BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = Button,
                    })
                )
            elseif Index == 1 then
                table.insert(
                    Library.SpecificCorners,
                    New("UICorner", {
                        TopLeftRadius = UDim.new(0, 0),
                        TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                        BottomLeftRadius = UDim.new(0, 0),
                        BottomRightRadius = UDim.new(0, 0),
                        Parent = Button,
                    })
                )
            elseif Index == TotalModeButtons then
                table.insert(
                    Library.SpecificCorners,
                    New("UICorner", {
                        TopLeftRadius = UDim.new(0, 0),
                        TopRightRadius = UDim.new(0, 0),
                        BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                        BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = Button,
                    })
                )
            end

            function ModeButton:Select()
                for _, Button in ModeButtons do
                    Button:Deselect()
                end

                KeyPicker.Mode = Mode

                Button.BackgroundTransparency = 0
                Button.TextTransparency = 0

                MenuTable:Close()
            end

            function ModeButton:Deselect()
                KeyPicker.Mode = nil

                Button.BackgroundTransparency = 1
                Button.TextTransparency = 0.5
            end

            Button.MouseButton1Click:Connect(function()
                ModeButton:Select()
            end)

            if KeyPicker.Mode == Mode then
                ModeButton:Select()
            end

            ModeButtons[Mode] = ModeButton
        end

        function KeyPicker:Display(PickerText)
            if Library.Unloaded then
                return
            end

            local DisplayText = PickerText or KeyPicker.DisplayValue
            if IsForButton and SlideOverflow then
                if LastPickerWidth == Picker.AbsoluteSize.X then
                    return
                end

                local X, _Y =
                    Library:GetTextBounds(DisplayText, Picker.FontFace, Picker.TextSize, 10000)

                SlidingLabel.Text = DisplayText

                local OffsetScale = X + 9
                local PickerWidth = math.min(OffsetScale, MaxPickerWidth)
                Picker.Size = UDim2.new(0, PickerWidth, 1, 0)

                if OffsetScale > PickerWidth then
                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Left
                    SlidingLabel.Size = UDim2.new(0, OffsetScale, 1, 0)
                    SlidingLabel.Position = UDim2.fromOffset(4.5, 0)

                    RunService.RenderStepped:Wait()

                    local RealPickerWidth = Picker.AbsoluteSize.X
                    if RealPickerWidth <= 0 then
                        RealPickerWidth = PickerWidth
                    end

                    LastPickerWidth = RealPickerWidth

                    local OverflowDistance = OffsetScale - RealPickerWidth - 4.5
                    if OverflowDistance > 0 then
                        CancelSlidingTweens()

                        local Duration = OverflowDistance / 25
                        local TweenInfo = TweenInfo.new(
                            Duration,
                            Enum.EasingStyle.Linear,
                            Enum.EasingDirection.InOut
                        )

                        SlideForwardTween = TweenService:Create(SlidingLabel, TweenInfo, {
                            Position = UDim2.fromOffset(-OverflowDistance, 0),
                        })

                        SlideBackTween = TweenService:Create(SlidingLabel, TweenInfo, {
                            Position = UDim2.fromOffset(4.5, 0),
                        })

                        SlideForwardTween:Play()

                        SlideForwardTween.Completed:Connect(HandleForwardTween)
                        SlideBackTween.Completed:Connect(HandleBackTween)
                    else
                        CancelSlidingTweens()

                        SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
                        SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
                        SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
                    end
                else
                    CancelSlidingTweens()

                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
                    SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
                    SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
                end
            else
                local X, Y = Library:GetTextBounds(
                    DisplayText,
                    Picker.FontFace,
                    Picker.TextSize,
                    ToggleLabel.AbsoluteSize.X
                )
                Picker.Text = DisplayText
                Picker.Size = IsForButton and UDim2.new(0, X + 9, 1, 0)
                    or UDim2.fromOffset((X + 9), (Y + 4))
            end
        end

        function KeyPicker:Update()
            KeyPicker:Display()

            if Info.NoUI then
                return
            end

            if KeyPicker.Mode == "Toggle" and ParentObj.Type == "Toggle" and ParentObj.Disabled then
                KeybindsToggle:SetVisibility(false)
                return
            end

            local State = KeyPicker:GetState()
            local ShowToggle = Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == "Toggle"

            if KeyPicker.SyncToggleState and ParentObj.Value ~= State then
                ParentObj:SetValue(State)
            end

            if KeybindsToggle.Loaded then
                if ShowToggle then
                    KeybindsToggle:SetNormal(false)
                else
                    KeybindsToggle:SetNormal(true)
                end

                KeybindsToggle:SetText(
                    ("[%s] %s (%s)"):format(KeyPicker.DisplayValue, KeyPicker.Text, KeyPicker.Mode)
                )
                KeybindsToggle:SetVisibility(true)
                KeybindsToggle:Display(State)
            end
        end

        function KeyPicker:GetState()
            if KeyPicker.Mode == "Always" then
                return true
            elseif KeyPicker.Mode == "Hold" then
                local Key = KeyPicker.Value
                if Key == "None" then
                    return false
                end

                if not AreModifiersHeld(KeyPicker.Modifiers) then
                    return false
                end

                if Picking then
                    return false
                end

                if SpecialKeys[Key] ~= nil then
                    if Library.Toggled then
                        return false
                    end

                    return UserInputService:IsMouseButtonPressed(SpecialKeys[Key])
                        and not UserInputService:GetFocusedTextBox()
                else
                    return UserInputService:IsKeyDown(Enum.KeyCode[Key] :: any)
                        and not UserInputService:GetFocusedTextBox()
                end
            else
                return KeyPicker.Toggled
            end
        end

        function KeyPicker:OnChanged(Func)
            KeyPicker.Changed = Func
        end

        function KeyPicker:OnClick(Func)
            KeyPicker.Clicked = Func
        end

        function KeyPicker:DoClick()
            if Picking then
                return
            end

            if KeyPicker.Mode == "Press" then
                if KeyPicker.Toggled and Info.WaitForCallback == true then
                    return
                end

                KeyPicker.Toggled = true
            end

            Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
            Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)

            if IsForButton then
                Library:SafeCallback(ParentObj.Func, KeyPicker.Toggled)
            end

            if Library.ToggleKeybind == KeyPicker and Library.Toggle then
                Library:Toggle()
            end

            if KeyPicker.Mode == "Press" then
                KeyPicker.Toggled = false
            end
        end

        function KeyPicker:RunChanged(IsKeyValid, KeyCode)
            if IsKeyValid == nil or KeyCode == nil then
                IsKeyValid, KeyCode = pcall(function()
                    if KeyPicker.Value == "None" then
                        return nil
                    end

                    if SpecialKeys[KeyPicker.Value] == nil then
                        return Enum.KeyCode[KeyPicker.Value]
                    end

                    return SpecialKeys[KeyPicker.Value]
                end)
            end

            local NewModifiers = ConvertToInputModifiers(KeyPicker.Modifiers)
            Library:SafeCallback(KeyPicker.ChangedCallback, KeyCode, NewModifiers)
            Library:SafeCallback(KeyPicker.Changed, KeyCode, NewModifiers)
        end

        function KeyPicker:SetValue(Data)
            local Key, Mode, Modifiers = Data[1], Data[2], Data[3]

            local IsKeyValid, KeyCode = pcall(function()
                if Key == "None" then
                    Key = nil
                    return nil
                end

                if SpecialKeys[Key] == nil then
                    return Enum.KeyCode[Key]
                end

                return SpecialKeys[Key]
            end)

            if Key == nil then
                KeyPicker.Value = "None"
            elseif IsKeyValid then
                KeyPicker.Value = Key
            else
                KeyPicker.Value = "Unknown"
            end

            KeyPicker.Modifiers = VerifyModifiers(
                if typeof(Modifiers) == "table" then Modifiers else KeyPicker.Modifiers
            )
            KeyPicker.DisplayValue = if GetTableSize(KeyPicker.Modifiers) > 0
                then (table.concat(KeyPicker.Modifiers, " + ") .. " + " .. KeyPicker.Value)
                else KeyPicker.Value

            if ModeButtons[Mode] then
                ModeButtons[Mode]:Select()
            end

            KeyPicker:Update()
            KeyPicker:RunChanged(IsKeyValid, KeyCode)
        end

        function KeyPicker:SetText(Text)
            KeybindsToggle:SetText(Text)
            KeyPicker:Update()
        end

        local SetPickingState = function(State)
            Picking = State
            Library.IsPicking = State

            if ParentObj then
                ParentObj.AnyKeyPickerPicking = Picking
            end

            if IsForButton then
                ToggleLabel.Visible = not Picking
                RunService.RenderStepped:Wait()
            end

            KeyPicker:Update()
        end

        Picker.MouseButton1Click:Connect(function()
            if Picking or Library.IsPicking then
                return
            end

            SetPickingState(true)

            if IsForButton and SlideOverflow then
                KeyPicker:Display("...")
            else
                Picker.Text = "..."
                Picker.Size = IsForButton and UDim2.new(0, 29, 1, 0) or UDim2.fromOffset(29, 18)
            end

            -- Wait for any input --
            local ActiveModifiers = {}
            local CurrentInput = nil

            local IsValidInput = function(InputObj)
                if InputObj.KeyCode == Enum.KeyCode.Escape then
                    return true
                end

                local IsMod = IsModifierInput(InputObj)
                local KeyName
                if SpecialKeysInput[InputObj.UserInputType] ~= nil then
                    KeyName = SpecialKeysInput[InputObj.UserInputType]
                elseif InputObj.UserInputType == Enum.UserInputType.Keyboard then
                    if IsMod then
                        KeyName = ModifiersInput[InputObj.KeyCode]
                    else
                        KeyName = InputObj.KeyCode.Name
                    end
                end

                if KeyName then
                    if IsMod then
                        if
                            KeyPicker.WhitelistedModifiers
                            and #KeyPicker.WhitelistedModifiers > 0
                            and not table.find(KeyPicker.WhitelistedModifiers, KeyName)
                        then
                            return false
                        end

                        if
                            KeyPicker.BlacklistedModifiers
                            and table.find(KeyPicker.BlacklistedModifiers, KeyName)
                        then
                            return false
                        end
                    else
                        if
                            KeyPicker.Whitelisted
                            and #KeyPicker.Whitelisted > 0
                            and not table.find(KeyPicker.Whitelisted, KeyName)
                        then
                            return false
                        end

                        if KeyPicker.Blacklisted and table.find(KeyPicker.Blacklisted, KeyName) then
                            return false
                        end
                    end
                end

                return true
            end

            -- Wait for the first valid InputBegan --
            while true do
                local InputObj = UserInputService.InputBegan:Wait()
                if UserInputService:GetFocusedTextBox() ~= nil then
                    SetPickingState(false)
                    return
                end

                if IsValidInput(InputObj) then
                    CurrentInput = InputObj
                    break
                end
            end

            -- If it's a modifier key, we wait for either its release or another input --
            while IsModifierInput(CurrentInput) do
                if CurrentInput.KeyCode == Enum.KeyCode.Escape then
                    break
                end

                -- Display the current state including the current modifier key --
                local ModName = ModifiersInput[CurrentInput.KeyCode]
                if ModName then
                    local text = if #ActiveModifiers > 0
                        then table.concat(ActiveModifiers, " + ") .. " + " .. ModName .. " + ..."
                        else ModName .. " + ..."
                    KeyPicker:Display(text)
                end

                local NextInput = nil
                local Released = false

                local BeganConn
                local EndedConn

                BeganConn = UserInputService.InputBegan:Connect(function(InputObj)
                    if UserInputService:GetFocusedTextBox() ~= nil then
                        return
                    end
                    if IsValidInput(InputObj) then
                        NextInput = InputObj
                    end
                end)

                EndedConn = UserInputService.InputEnded:Connect(function(InputObj)
                    if InputObj.KeyCode == CurrentInput.KeyCode then
                        Released = true
                    end
                end)

                repeat
                    task.wait()
                until Released
                    or NextInput
                    or UserInputService:GetFocusedTextBox() ~= nil
                    or Library.Unloaded

                if BeganConn then
                    BeganConn:Disconnect()
                end
                if EndedConn then
                    EndedConn:Disconnect()
                end

                if UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded then
                    SetPickingState(false)
                    return
                end

                if Released then
                    break -- Use modifier key as bind
                elseif NextInput then
                    -- Add another modifier or continue to normal key
                    local OldModName = ModifiersInput[CurrentInput.KeyCode]
                    if OldModName and not table.find(ActiveModifiers, OldModName) then
                        ActiveModifiers[#ActiveModifiers + 1] = OldModName
                    end

                    CurrentInput = NextInput
                    if CurrentInput.KeyCode == Enum.KeyCode.Escape then
                        break
                    end
                end
            end

            local Key = "Unknown"
            if SpecialKeysInput[CurrentInput.UserInputType] ~= nil then
                Key = SpecialKeysInput[CurrentInput.UserInputType]
            elseif CurrentInput.UserInputType == Enum.UserInputType.Keyboard then
                Key = CurrentInput.KeyCode == Enum.KeyCode.Escape and "None"
                    or CurrentInput.KeyCode.Name
            end

            ActiveModifiers = if CurrentInput.KeyCode == Enum.KeyCode.Escape
                    or Key == "Unknown"
                then {}
                else ActiveModifiers

            KeyPicker.Toggled = if ParentObj.Type == "Toggle" then ParentObj.Value else false
            KeyPicker:SetValue({ Key, KeyPicker.Mode, ActiveModifiers })

            repeat
                task.wait()
            until not IsInputDown(CurrentInput) or UserInputService:GetFocusedTextBox()

            SetPickingState(false)
        end)
        Picker.MouseButton2Click:Connect(MenuTable.Toggle)

        table.insert(
            KeyPicker.Connections,
            UserInputService.InputBegan:Connect(function(Input: InputObject)
                if Library.Unloaded then
                    return
                end

                local IsMouse = IsMouseClickInput(Input)
                if
                    KeyPicker.Mode == "Always"
                    or KeyPicker.Value == "Unknown"
                    or KeyPicker.Value == "None"
                    or Picking
                    or Library.IsPicking
                    or UserInputService:GetFocusedTextBox()
                    or (IsMouse and Library.Toggled)
                then
                    return
                end

                local Key = KeyPicker.Value
                local HoldingModifiers = AreModifiersHeld(KeyPicker.Modifiers)
                local HoldingKey = false

                if
                    Key
                    and HoldingModifiers == true
                    and (
                        SpecialKeysInput[Input.UserInputType] == Key
                        or (
                            Input.UserInputType == Enum.UserInputType.Keyboard
                            and Input.KeyCode.Name == Key
                        )
                    )
                then
                    HoldingKey = true
                end

                if KeyPicker.Mode == "Toggle" then
                    if HoldingKey then
                        KeyPicker.Toggled = not KeyPicker.Toggled
                        KeyPicker:DoClick()
                    end
                elseif KeyPicker.Mode == "Press" then
                    if HoldingKey then
                        KeyPicker:DoClick()
                    end
                end

                KeyPicker:Update()
            end)
        )

        table.insert(
            KeyPicker.Connections,
            UserInputService.InputEnded:Connect(function(Input: InputObject)
                if Library.Unloaded then
                    return
                end

                local IsMouse = IsMouseClickInput(Input)
                if
                    KeyPicker.Value == "Unknown"
                    or KeyPicker.Value == "None"
                    or Picking
                    or Library.IsPicking
                    or UserInputService:GetFocusedTextBox()
                    or (IsMouse and Library.Toggled)
                then
                    return
                end

                KeyPicker:Update()
            end)
        )

        KeyPicker:Update()

        if ParentObj.Addons then
            table.insert(ParentObj.Addons, KeyPicker)
        end

        KeyPicker.Default = KeyPicker.Value
        KeyPicker.DefaultModifiers = table.clone(KeyPicker.Modifiers or {})

        function KeyPicker:Destroy()
            KeyPicker.Destroyed = true

            if KeyPicker.Connections then
                for _, Connection in KeyPicker.Connections do
                    Connection:Disconnect()
                end
            end

            if KeybindsToggle and KeybindsToggle.Loaded then
                if KeybindsToggle.Holder then
                    KeybindsToggle.Holder:Destroy()
                end
                local KTIdx = table.find(Library.KeybindToggles, KeybindsToggle)
                if KTIdx then
                    table.remove(Library.KeybindToggles, KTIdx)
                end
            end

            if MenuTable then
                MenuTable:Destroy()
            end

            if IsForButton and SlideOverflow then
                if SlideForwardTween then
                    SlideForwardTween:Destroy()
                end

                if SlideBackTween then
                    SlideBackTween:Destroy()
                end
            end

            if Picker then
                Picker:Destroy()
            end

            if ParentObj and ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, KeyPicker)

                if AddonIdx then
                    table.remove(ParentObj.Addons, AddonIdx)
                end
            end

            Options[Idx] = nil
        end

        Options[Idx] = KeyPicker

        return self
    end

    local HueSequenceTable = {}
    for Hue = 0, 1, 0.1 do
        table.insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
    end
    function Funcs:AddColorPicker(Idx, Info)
        if self.Destroyed then
            return nil
        end

        Info = Library:Validate(Info, Templates.ColorPicker)

        local ParentObj = self
        local ToggleLabel = ParentObj.TextLabel

        local ColorPicker = {
            Connections = {},
            Destroyed = false,

            Value = Info.Default,

            Transparency = Info.Transparency or 0,
            Title = Info.Title,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Type = "ColorPicker",
        }
        ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ColorPicker.Value:ToHSV()

        local Holder = New("TextButton", {
            BackgroundColor3 = ColorPicker.Value,
            Size = UDim2.fromOffset(18, 18),
            Text = "",
            Parent = ToggleLabel,
        })

        local HolderStroke = New("UIStroke", {
            Color = Library:GetDarkerColor(ColorPicker.Value),
            Parent = Holder,
        })

        local ColorPickerCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = Holder,
        })
        table.insert(Library.SpecificCorners, ColorPickerCorner)

        local HolderTransparency = New("ImageLabel", {
            Image = CustomImageManager.GetAsset("TransparencyTexture"),
            ImageTransparency = (1 - ColorPicker.Transparency),
            ScaleType = Enum.ScaleType.Tile,
            Position = UDim2.new(0, -1, 0, -1),
            Size = UDim2.new(1, 2, 1, 2),
            TileSize = UDim2.fromOffset(9, 9),
            Parent = Holder,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = HolderTransparency,
            })
        )

        --// Color Menu \\--
        local ColorMenu = Library:AddContextMenu(
            Holder,
            UDim2.fromOffset(Info.Transparency and 256 or 234, 0),
            function()
                return { 0.5, Holder.AbsoluteSize.Y + 1.5 }
            end,
            1,
            function(Active: boolean)
                ColorPickerCorner.BottomRightRadius = Active and UDim.new(0, 0)
                    or UDim.new(0, Library.CornerRadius / 2)
                ColorPickerCorner.BottomLeftRadius = Active and UDim.new(0, 0)
                    or UDim.new(0, Library.CornerRadius / 2)
            end,
            false,
            "no_top_left"
        )
        ColorMenu.List.Padding = UDim.new(0, 8)
        ColorPicker.ColorMenu = ColorMenu

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6),
            Parent = ColorMenu.Menu,
        })

        if typeof(ColorPicker.Title) == "string" then
            New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 8),
                Text = ColorPicker.Title,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ColorMenu.Menu,
            })
        end

        local ColorHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 200),
            Parent = ColorMenu.Menu,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            Parent = ColorHolder,
        })

        --// Sat Map
        local SatVipMap = New("ImageButton", {
            BackgroundColor3 = ColorPicker.Value,
            Image = CustomImageManager.GetAsset("SaturationMap"),
            Size = UDim2.fromOffset(200, 200),
            Parent = ColorHolder,
        })

        local SatVibCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            Size = UDim2.fromOffset(6, 6),
            Parent = SatVipMap,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = SatVibCursor,
        })
        New("UIStroke", {
            Color = "DarkColor",
            Parent = SatVibCursor,
        })

        --// Hue
        local HueSelector = New("TextButton", {
            Size = UDim2.fromOffset(16, 200),
            Text = "",
            Parent = ColorHolder,
        })
        New("UIGradient", {
            Color = ColorSequence.new(HueSequenceTable),
            Rotation = 90,
            Parent = HueSelector,
        })

        local HueCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            BorderColor3 = "DarkColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0.5, ColorPicker.Hue),
            Size = UDim2.new(1, 2, 0, 1),
            Parent = HueSelector,
        })

        --// Alpha
        local TransparencySelector, TransparencyColor, TransparencyCursor
        if Info.Transparency then
            TransparencySelector = New("ImageButton", {
                Image = CustomImageManager.GetAsset("TransparencyTexture"),
                ScaleType = Enum.ScaleType.Tile,
                Size = UDim2.fromOffset(16, 200),
                TileSize = UDim2.fromOffset(8, 8),
                Parent = ColorHolder,
            })

            TransparencyColor = New("Frame", {
                BackgroundColor3 = ColorPicker.Value,
                Size = UDim2.fromScale(1, 1),
                Parent = TransparencySelector,
            })
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }),
                Parent = TransparencyColor,
            })

            TransparencyCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = "WhiteColor",
                BorderColor3 = "DarkColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0.5, ColorPicker.Transparency),
                Size = UDim2.new(1, 2, 0, 1),
                Parent = TransparencySelector,
            })
        end

        local InfoHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Parent = ColorMenu.Menu,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 8),
            Parent = InfoHolder,
        })

        local HueBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "#??????",
            TextSize = 14,
            Parent = InfoHolder,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = HueBox,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = HueBox,
            })
        )

        local RgbBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "?, ?, ?",
            TextSize = 14,
            Parent = InfoHolder,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = RgbBox,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = RgbBox,
            })
        )

        --// Context Menu \\--
        local ContextMenu = Library:AddContextMenu(
            Holder,
            UDim2.fromOffset(93, 0),
            function()
                return { Holder.AbsoluteSize.X + 1.5, 0.5 }
            end,
            1,
            function(Active: boolean)
                ColorPickerCorner.TopRightRadius = Active and UDim.new(0, 0)
                    or UDim.new(0, Library.CornerRadius / 2)
                ColorPickerCorner.BottomRightRadius = Active and UDim.new(0, 0)
                    or UDim.new(0, Library.CornerRadius / 2)
            end,
            false,
            "no_top_left"
        )
        ColorPicker.ContextMenu = ContextMenu
        ContextMenu.List.Padding = UDim.new(0, 6)
        do
            local function CreateButton(Text, Func)
                local Button = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 21),
                    Text = Text,
                    TextSize = 14,
                    Parent = ContextMenu.Menu,
                })

                Button.MouseButton1Click:Connect(function()
                    Library:SafeCallback(Func)
                    ContextMenu:Close()
                end)
            end

            CreateButton("Copy color", function()
                Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }
            end)

            ColorPicker.SetValueRGB = function(...) end --// make luau lsp shut up
            CreateButton("Paste color", function()
                ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
            end)

            if setclipboard then
                CreateButton("Copy Hex", function()
                    setclipboard(tostring(ColorPicker.Value:ToHex()))
                end)

                CreateButton("Copy RGB", function()
                    setclipboard(table.concat({
                        math.floor(ColorPicker.Value.R * 255),
                        math.floor(ColorPicker.Value.G * 255),
                        math.floor(ColorPicker.Value.B * 255),
                    }, ", "))
                end)
            end
        end

        --// End \\--
        function ColorPicker:SetHSVFromRGB(Color)
            ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
        end

        function ColorPicker:Display()
            if Library.Unloaded then
                return
            end

            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)

            Holder.BackgroundColor3 = ColorPicker.Value
            HolderStroke.Color = Library:GetDarkerColor(ColorPicker.Value)
            HolderTransparency.ImageTransparency = (1 - ColorPicker.Transparency)

            SatVipMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)
            if TransparencyColor then
                TransparencyColor.BackgroundColor3 = ColorPicker.Value
            end

            SatVibCursor.Position = UDim2.fromScale(ColorPicker.Sat, 1 - ColorPicker.Vib)
            HueCursor.Position = UDim2.fromScale(0.5, ColorPicker.Hue)
            if TransparencyCursor then
                TransparencyCursor.Position = UDim2.fromScale(0.5, ColorPicker.Transparency)
            end

            HueBox.Text = "#" .. ColorPicker.Value:ToHex()
            RgbBox.Text = table.concat({
                math.floor(ColorPicker.Value.R * 255),
                math.floor(ColorPicker.Value.G * 255),
                math.floor(ColorPicker.Value.B * 255),
            }, ", ")
        end

        function ColorPicker:RunChanged()
            Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
            Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
        end

        function ColorPicker:Update()
            ColorPicker:Display()
            ColorPicker:RunChanged()
        end

        function ColorPicker:OnChanged(Func)
            ColorPicker.Changed = Func
        end

        function ColorPicker:SetValue(HSV, Transparency)
            if typeof(HSV) == "Color3" then
                ColorPicker:SetValueRGB(HSV, Transparency)
                return
            end

            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])
            ColorPicker.Transparency = Info.Transparency and Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Update()
        end

        function ColorPicker:SetValueRGB(Color, Transparency)
            ColorPicker.Transparency = Info.Transparency and Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Update()
        end

        table.insert(ColorPicker.Connections, Holder.MouseButton1Click:Connect(ColorMenu.Toggle))
        table.insert(ColorPicker.Connections, Holder.MouseButton2Click:Connect(ContextMenu.Toggle))

        table.insert(
            ColorPicker.Connections,
            SatVipMap.InputBegan:Connect(function(Input: InputObject)
                while IsDragInput(Input) and not ColorPicker.Destroyed do
                    local MinX = SatVipMap.AbsolutePosition.X
                    local MaxX = MinX + SatVipMap.AbsoluteSize.X
                    local LocationX = math.clamp(Mouse.X, MinX, MaxX)

                    local MinY = SatVipMap.AbsolutePosition.Y
                    local MaxY = MinY + SatVipMap.AbsoluteSize.Y
                    local LocationY = math.clamp(Mouse.Y, MinY, MaxY)

                    local OldSat = ColorPicker.Sat
                    local OldVib = ColorPicker.Vib
                    ColorPicker.Sat = (LocationX - MinX) / (MaxX - MinX)
                    ColorPicker.Vib = 1 - ((LocationY - MinY) / (MaxY - MinY))

                    if ColorPicker.Sat ~= OldSat or ColorPicker.Vib ~= OldVib then
                        ColorPicker:Update()
                    end

                    RunService.RenderStepped:Wait()
                end
            end)
        )

        table.insert(
            ColorPicker.Connections,
            HueSelector.InputBegan:Connect(function(Input: InputObject)
                while IsDragInput(Input) and not ColorPicker.Destroyed do
                    local Min = HueSelector.AbsolutePosition.Y
                    local Max = Min + HueSelector.AbsoluteSize.Y
                    local Location = math.clamp(Mouse.Y, Min, Max)

                    local OldHue = ColorPicker.Hue
                    ColorPicker.Hue = (Location - Min) / (Max - Min)

                    if ColorPicker.Hue ~= OldHue then
                        ColorPicker:Update()
                    end

                    RunService.RenderStepped:Wait()
                end
            end)
        )

        if TransparencySelector then
            table.insert(
                ColorPicker.Connections,
                TransparencySelector.InputBegan:Connect(function(Input: InputObject)
                    while IsDragInput(Input) and not ColorPicker.Destroyed do
                        local Min = TransparencySelector.AbsolutePosition.Y
                        local Max = TransparencySelector.AbsolutePosition.Y
                            + TransparencySelector.AbsoluteSize.Y
                        local Location = math.clamp(Mouse.Y, Min, Max)

                        local OldTransparency = ColorPicker.Transparency
                        ColorPicker.Transparency = (Location - Min) / (Max - Min)

                        if ColorPicker.Transparency ~= OldTransparency then
                            ColorPicker:Update()
                        end

                        RunService.RenderStepped:Wait()
                    end
                end)
            )
        end

        table.insert(
            ColorPicker.Connections,
            HueBox.FocusLost:Connect(function(Enter)
                if not Enter then
                    return
                end

                local Success, Color = pcall(Color3.fromHex, HueBox.Text)
                if Success and typeof(Color) == "Color3" then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
                end

                ColorPicker:Update()
            end)
        )

        table.insert(
            ColorPicker.Connections,
            RgbBox.FocusLost:Connect(function(Enter)
                if not Enter then
                    return
                end

                local R, G, B = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
                if R and G and B then
                    ColorPicker:SetHSVFromRGB(Color3.fromRGB(R, G, B))
                end

                ColorPicker:Update()
            end)
        )

        ColorPicker:Display()

        if ParentObj.Addons then
            table.insert(ParentObj.Addons, ColorPicker)
        end

        ColorPicker.Default = ColorPicker.Value

        function ColorPicker:Destroy()
            ColorPicker.Destroyed = true

            if ColorPicker.Connections then
                for _, Connection in ColorPicker.Connections do
                    Connection:Disconnect()
                end
            end

            if ColorMenu then
                ColorMenu:Destroy()
            end

            if ContextMenu then
                ContextMenu:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            if ParentObj and ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, ColorPicker)

                if AddonIdx then
                    table.remove(ParentObj.Addons, AddonIdx)
                end
            end

            Options[Idx] = nil
        end

        Options[Idx] = ColorPicker

        return self
    end

    BaseAddons.__index = Funcs
    BaseAddons.__namecall = function(_, Key, ...)
        return Funcs[Key](...)
    end
end

local BaseGroupbox = {}
do
    local Funcs = {}

    function Funcs:AddDivider(...)
        if self.Destroyed then
            return nil
        end

        local Params = select(1, ...)
        local Text
        local MarginTop = 0
        local MarginBottom = 0

        if typeof(Params) == "table" then
            Text = Params.Text
            MarginTop = Params.MarginTop or Params.Margin or 0
            MarginBottom = Params.MarginBottom or Params.Margin or 0
        elseif typeof(Params) == "string" then
            Text = Params
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 6 + MarginTop + MarginBottom),
            Parent = Container,
        })

        local InnerHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingTop = UDim.new(0, MarginTop),
            PaddingBottom = UDim.new(0, MarginBottom),
            Parent = Holder,
        })

        if Text then
            local TextLabel = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Text = Text,
                TextSize = 14,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = InnerHolder,
            })

            local X, _ = Library:GetTextBounds(
                Text,
                TextLabel.FontFace,
                TextLabel.TextSize,
                TextLabel.AbsoluteSize.X
            )
            local SizeX = X // 2 + 10

            New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.new(0.5, -SizeX, 0, 2),
                Parent = InnerHolder,
            })
            New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(1, 0.5),
                Size = UDim2.new(0.5, -SizeX, 0, 2),
                Parent = InnerHolder,
            })
        else
            New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.new(1, 0, 0, 2),
                Parent = InnerHolder,
            })
        end

        Groupbox:Resize()

        local Divider = {
            Connections = {},
            Destroyed = false,

            Holder = Holder,
            Text = Text,
            MarginTop = MarginTop,
            MarginBottom = MarginBottom,
            Type = "Divider",
        }

        function Divider:SetVisible(Value)
            Holder.Visible = Value == true
            Groupbox:Resize()
        end

        function Divider:Destroy()
            Divider.Destroyed = true

            if Divider.Connections then
                for _, Connection in Divider.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Divider)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
        end

        table.insert(Groupbox.Elements, Divider)
        return Divider
    end

    function Funcs:AddLabel(...)
        if self.Destroyed then
            return nil
        end

        local Data = {}
        local Addons = {}

        local First = select(1, ...)
        local Second = select(2, ...)

        if typeof(First) == "table" or typeof(Second) == "table" then
            local Params = typeof(First) == "table" and First or Second

            Data.Text = Params.Text or ""
            Data.DoesWrap = Params.DoesWrap or false
            Data.Size = Params.Size or 14
            Data.Visible = Params.Visible or true
            Data.Idx = typeof(Second) == "table" and First or nil
        else
            Data.Text = First or ""
            Data.DoesWrap = Second or false
            Data.Size = 14
            Data.Visible = true
            Data.Idx = select(3, ...) or nil
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local Label = {
            Connections = {},
            Destroyed = false,

            Text = Data.Text,
            DoesWrap = Data.DoesWrap,

            Addons = Addons,

            Visible = Data.Visible,
            Type = "Label",
        }

        local TextLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = Label.Text,
            TextSize = Data.Size,
            TextWrapped = Label.DoesWrap,
            TextXAlignment = Groupbox.IsKeyTab and Enum.TextXAlignment.Center
                or Enum.TextXAlignment.Left,
            Parent = Container,
        })

        function Label:Display()
            if not Label.DoesWrap then
                return
            end

            local Width = TextLabel.AbsoluteSize.X
            if Width <= 0 then
                return
            end

            local _, Y =
                Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, Width)
            TextLabel.Size = UDim2.new(1, 0, 0, Y + 4)
        end

        function Label:SetVisible(Visible: boolean)
            Label.Visible = Visible

            TextLabel.Visible = Label.Visible
            Groupbox:Resize()
        end

        function Label:SetText(Text: string)
            Label.Text = Text
            TextLabel.Text = Text

            Label:Display()
            Groupbox:Resize()
        end

        if Label.DoesWrap then
            Label:Display()

            local Last = TextLabel.AbsoluteSize
            TextLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if TextLabel.AbsoluteSize == Last then
                    return
                end

                Label:Display()
                Last = TextLabel.AbsoluteSize

                Groupbox:Resize()
            end)
        else
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 6),
                Parent = TextLabel,
            })
        end

        Groupbox:Resize()

        Label.TextLabel = TextLabel
        Label.Container = Container
        if not Data.DoesWrap then
            setmetatable(Label, BaseAddons)
        end

        Label.Holder = TextLabel
        table.insert(Groupbox.Elements, Label)

        if Data.Idx then
            Labels[Data.Idx] = Label
        else
            table.insert(Labels, Label)
        end

        function Label:Destroy()
            Label.Destroyed = true

            if Label.Connections then
                for _, Connection in Label.Connections do
                    Connection:Disconnect()
                end
            end

            if Label.Addons then
                for Index = #Label.Addons, 1, -1 do
                    local Addon = table.remove(Label.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            if TextLabel then
                TextLabel:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Label)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()

            if Data.Idx then
                Labels[Data.Idx] = nil
            else
                local LblIdx = table.find(Labels, Label)

                if LblIdx then
                    table.remove(Labels, LblIdx)
                end
            end
        end

        return Label
    end

    function Funcs:AddButton(...)
        if self.Destroyed then
            return nil
        end

        local function GetInfo(...)
            local Info = {}

            local First = select(1, ...)
            local Second = select(2, ...)

            if typeof(First) == "table" or typeof(Second) == "table" then
                local Params = typeof(First) == "table" and First or Second

                Info.Text = Params.Text or ""
                Info.Func = Params.Func or Params.Callback or function() end
                Info.DoubleClick = Params.DoubleClick

                Info.Tooltip = Params.Tooltip
                Info.DisabledTooltip = Params.DisabledTooltip

                Info.Risky = Params.Risky or false
                Info.Disabled = Params.Disabled or false
                Info.Visible = Params.Visible or true
                Info.Idx = typeof(Second) == "table" and First or nil
            else
                Info.Text = First or ""
                Info.Func = Second or function() end
                Info.DoubleClick = false

                Info.Tooltip = nil
                Info.DisabledTooltip = nil

                Info.Risky = false
                Info.Disabled = false
                Info.Visible = true
                Info.Idx = select(3, ...) or nil
            end

            return Info
        end
        local Info = GetInfo(...)

        local Groupbox = self
        local Container = Groupbox.Container

        local Button = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Func = Info.Func,
            DoubleClick = Info.DoubleClick,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Tween = nil,
            Type = "Button",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 21),
            Parent = Container,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 9),
            Parent = Holder,
        })

        local function CreateButton(Button)
            local Base = New("TextButton", {
                Active = not Button.Disabled,
                BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
                Size = UDim2.fromScale(1, 1),
                Text = Button.Text,
                TextSize = 14,
                TextTransparency = 0.4,
                Visible = Button.Visible,
                Parent = Holder,
            })

            local Stroke = New("UIStroke", {
                Color = "OutlineColor",
                Transparency = Button.Disabled and 0.5 or 0,
                Parent = Base,
            })

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Base,
                })
            )

            return Base, Stroke
        end

        local function InitEvents(Button)
            Button.Base.MouseEnter:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
                    TextTransparency = 0,
                })
                Button.Tween:Play()
            end)
            Button.Base.MouseLeave:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = TweenService:Create(Button.Base, Library.TweenInfo, {
                    TextTransparency = 0.4,
                })
                Button.Tween:Play()
            end)

            Button.Base.MouseButton1Click:Connect(function()
                if Button.Disabled or Button.Locked then
                    return
                end

                if Button.DoubleClick then
                    Button.Locked = true

                    Button.Base.Text = "Are you sure?"
                    Button.Base.TextColor3 = Library.Scheme.AccentColor
                    Library.Registry[Button.Base].TextColor3 = "AccentColor"

                    local Clicked = WaitForEvent(Button.Base.MouseButton1Click, 0.5)

                    Button.Base.Text = Button.Text
                    Button.Base.TextColor3 = Button.Risky and Library.Scheme.RedColor
                        or Library.Scheme.FontColor
                    Library.Registry[Button.Base].TextColor3 = Button.Risky and "RedColor"
                        or "FontColor"

                    if Clicked then
                        Library:SafeCallback(Button.Func)
                    end

                    RunService.RenderStepped:Wait() --// Mouse Button fires without waiting (i hate roblox)
                    Button.Locked = false
                    return
                end

                Library:SafeCallback(Button.Func)
            end)
        end

        Button.Base, Button.Stroke = CreateButton(Button)
        InitEvents(Button)

        function Button:AddButton(...)
            local Info = GetInfo(...)

            local SubButton = {
                Connections = {},
                Destroyed = false,

                Text = Info.Text,
                Func = Info.Func,
                DoubleClick = Info.DoubleClick,

                Tooltip = Info.Tooltip,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Risky = Info.Risky,
                Disabled = Info.Disabled,
                Visible = Info.Visible,

                Tween = nil,
                Type = "SubButton",
            }

            Button.SubButton = SubButton
            SubButton.Base, SubButton.Stroke = CreateButton(SubButton)
            InitEvents(SubButton)

            function SubButton:UpdateColors()
                if Library.Unloaded then
                    return
                end

                StopTween(SubButton.Tween)

                SubButton.Base.BackgroundColor3 = SubButton.Disabled
                        and Library.Scheme.BackgroundColor
                    or Library.Scheme.MainColor
                SubButton.Base.TextTransparency = SubButton.Disabled and 0.8 or 0.4
                SubButton.Stroke.Transparency = SubButton.Disabled and 0.5 or 0

                Library.Registry[SubButton.Base].BackgroundColor3 = SubButton.Disabled
                        and "BackgroundColor"
                    or "MainColor"
            end

            function SubButton:SetDisabled(Disabled: boolean)
                SubButton.Disabled = Disabled

                if SubButton.TooltipTable then
                    SubButton.TooltipTable.Disabled = SubButton.Disabled
                end

                SubButton.Base.Active = not SubButton.Disabled
                SubButton:UpdateColors()
            end

            function SubButton:SetVisible(Visible: boolean)
                SubButton.Visible = Visible

                SubButton.Base.Visible = SubButton.Visible
                Groupbox:Resize()
            end

            function SubButton:SetText(Text: string)
                SubButton.Text = Text
                SubButton.Base.Text = Text
            end

            if
                typeof(SubButton.Tooltip) == "string"
                or typeof(SubButton.DisabledTooltip) == "string"
            then
                SubButton.TooltipTable =
                    Library:AddTooltip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Base)
                SubButton.TooltipTable.Disabled = SubButton.Disabled
            end

            if SubButton.Risky then
                SubButton.Base.TextColor3 = Library.Scheme.RedColor
                Library.Registry[SubButton.Base].TextColor3 = "RedColor"
            end

            SubButton:UpdateColors()

            if Info.Idx then
                Buttons[Info.Idx] = SubButton
            else
                table.insert(Buttons, SubButton)
            end

            SubButton.AddKeyPicker = BaseAddons.__index.AddKeyPicker

            function SubButton:Destroy()
                SubButton.Destroyed = true

                if SubButton.TooltipTable then
                    SubButton.TooltipTable:Destroy()
                end

                if SubButton.Tween then
                    SubButton.Tween:Destroy()
                end

                if SubButton.Base then
                    SubButton.Base:Destroy()
                end

                if Info.Idx then
                    Buttons[Info.Idx] = nil
                else
                    local BIdx = table.find(Buttons, SubButton)

                    if BIdx then
                        table.remove(Buttons, BIdx)
                    end
                end
            end

            return SubButton
        end

        function Button:UpdateColors()
            if Library.Unloaded then
                return
            end

            StopTween(Button.Tween)

            Button.Base.BackgroundColor3 = Button.Disabled and Library.Scheme.BackgroundColor
                or Library.Scheme.MainColor
            Button.Base.TextTransparency = Button.Disabled and 0.8 or 0.4
            Button.Stroke.Transparency = Button.Disabled and 0.5 or 0

            Library.Registry[Button.Base].BackgroundColor3 = Button.Disabled and "BackgroundColor"
                or "MainColor"
        end

        function Button:SetDisabled(Disabled: boolean)
            Button.Disabled = Disabled

            if Button.TooltipTable then
                Button.TooltipTable.Disabled = Button.Disabled
            end

            Button.Base.Active = not Button.Disabled
            Button:UpdateColors()
        end

        function Button:SetVisible(Visible: boolean)
            Button.Visible = Visible

            Holder.Visible = Button.Visible
            Groupbox:Resize()
        end

        function Button:SetText(Text: string)
            Button.Text = Text
            Button.Base.Text = Text
        end

        if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
            Button.TooltipTable =
                Library:AddTooltip(Button.Tooltip, Button.DisabledTooltip, Button.Base)
            Button.TooltipTable.Disabled = Button.Disabled
        end

        if Button.Risky then
            Button.Base.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Button.Base].TextColor3 = "RedColor"
        end

        Button:UpdateColors()
        Groupbox:Resize()

        Button.Holder = Holder
        table.insert(Groupbox.Elements, Button)

        if Info.Idx then
            Buttons[Info.Idx] = Button
        else
            table.insert(Buttons, Button)
        end

        Button.AddKeyPicker = BaseAddons.__index.AddKeyPicker

        function Button:Destroy()
            Button.Destroyed = true

            if Button.TooltipTable then
                Button.TooltipTable:Destroy()
            end

            if Button.Tween then
                Button.Tween:Destroy()
            end

            if Button.SubButton then
                Button.SubButton:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Button)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()

            if Info.Idx then
                Buttons[Info.Idx] = nil
            else
                local BIdx = table.find(Buttons, Button)

                if BIdx then
                    table.remove(Buttons, BIdx)
                end
            end
        end

        return Button
    end

    function Funcs:AddCheckbox(Idx, Info)
        if self.Destroyed then
            return nil
        end

        Info = Library:Validate(Info, Templates.Toggle)

        local Groupbox = self
        local Container = Groupbox.Container

        local Toggle = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},
            AnyKeyPickerPicking = false,

            Variant = "Checkbox",
            Type = "Toggle",
        }

        local Button = New("TextButton", {
            Active = not Toggle.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(26, 0),
            Size = UDim2.new(1, -26, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Checkbox = New("Frame", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Button,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Checkbox,
            })
        )

        local CheckboxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Checkbox,
        })

        local CheckImage = New("ImageLabel", {
            Image = CheckIcon and CheckIcon.Url or "",
            ImageColor3 = "FontColor",
            ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 1,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.new(1, -4, 1, -4),
            Parent = Checkbox,
        })

        function Toggle:UpdateColors()
            Toggle:Display()
        end

        function Toggle:Display()
            if Library.Unloaded then
                return
            end

            CheckboxStroke.Transparency = Toggle.Disabled and 0.5 or 0

            if Toggle.Disabled then
                Label.TextTransparency = 0.8
                CheckImage.ImageTransparency = Toggle.Value and 0.8 or 1

                Checkbox.BackgroundColor3 = Library.Scheme.BackgroundColor
                Library.Registry[Checkbox].BackgroundColor3 = "BackgroundColor"

                return
            end

            TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            TweenService:Create(CheckImage, Library.TweenInfo, {
                ImageTransparency = Toggle.Value and 0 or 1,
            }):Play()

            Checkbox.BackgroundColor3 = Library.Scheme.MainColor
            Library.Registry[Checkbox].BackgroundColor3 = "MainColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:RunChanged()
            Library:SafeCallback(Toggle.Callback, Toggle.Value)
            Library:SafeCallback(Toggle.Changed, Toggle.Value)
        end

        function Toggle:SetValue(Value)
            if Toggle.Disabled then
                return
            end

            Toggle.Value = Value
            Toggle:Display()

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon.Toggled = Toggle.Value
                    Addon:Update()
                end
            end

            Library:UpdateDependencyBoxes()

            if not Toggle.AnyKeyPickerPicking then
                Toggle:RunChanged()
            end
        end

        function Toggle:SetDisabled(Disabled: boolean)
            Toggle.Disabled = Disabled

            if Toggle.TooltipTable then
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon:Update()
                end
            end

            Button.Active = not Toggle.Disabled
            Toggle:Display()
        end

        function Toggle:SetVisible(Visible: boolean)
            Toggle.Visible = Visible

            Button.Visible = Toggle.Visible
            Groupbox:Resize()
        end

        function Toggle:SetText(Text: string)
            Toggle.Text = Text
            Label.Text = Text
        end

        table.insert(
            Toggle.Connections,
            Button.MouseButton1Click:Connect(function()
                if Toggle.Disabled then
                    return
                end

                Toggle:SetValue(not Toggle.Value)
            end)
        )

        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
            Toggle.TooltipTable.Disabled = Toggle.Disabled
        end

        if Toggle.Risky then
            Label.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Label].TextColor3 = "RedColor"
        end

        Toggle:Display()
        Groupbox:Resize()

        Toggle.TextLabel = Label
        Toggle.Container = Container
        setmetatable(Toggle, BaseAddons)

        Toggle.Holder = Button
        table.insert(Groupbox.Elements, Toggle)

        Toggle.Default = Toggle.Value

        Toggles[Idx] = Toggle

        function Toggle:Destroy()
            Toggle.Destroyed = true

            if Toggle.Connections then
                for _, Connection in Toggle.Connections do
                    Connection:Disconnect()
                end
            end

            if Toggle.TooltipTable then
                Toggle.TooltipTable:Destroy()
            end

            if Button then
                Button:Destroy()
            end

            if Toggle.Addons then
                for Index = #Toggle.Addons, 1, -1 do
                    local Addon = table.remove(Toggle.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            local ElemIdx = table.find(Groupbox.Elements, Toggle)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Toggles[Idx] = nil
        end

        return Toggle
    end

    function Funcs:AddToggle(Idx, Info)
        if self.Destroyed then
            return nil
        end

        if Library.ForceCheckbox then
            return Funcs.AddCheckbox(self, Idx, Info)
        end

        Info = Library:Validate(Info, Templates.Toggle)

        local Groupbox = self
        local Container = Groupbox.Container

        local Toggle = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},
            AnyKeyPickerPicking = false,

            Variant = "Switch",
            Type = "Toggle",
        }

        local Button = New("TextButton", {
            Active = not Toggle.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Switch = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.fromOffset(32, 18),
            Parent = Button,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Switch,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 2),
            Parent = Switch,
        })
        local SwitchStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Switch,
        })

        local Ball = New("Frame", {
            BackgroundColor3 = "FontColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Switch,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Ball,
        })

        function Toggle:UpdateColors()
            Toggle:Display()
        end

        function Toggle:Display()
            if Library.Unloaded then
                return
            end

            local Offset = Toggle.Value and 1 or 0

            Switch.BackgroundTransparency = Toggle.Disabled and 0.75 or 0
            SwitchStroke.Transparency = Toggle.Disabled and 0.75 or 0

            Switch.BackgroundColor3 = Toggle.Value and Library.Scheme.AccentColor
                or Library.Scheme.MainColor
            SwitchStroke.Color = Toggle.Value and Library.Scheme.AccentColor
                or Library.Scheme.OutlineColor

            Library.Registry[Switch].BackgroundColor3 = Toggle.Value and "AccentColor"
                or "MainColor"
            Library.Registry[SwitchStroke].Color = Toggle.Value and "AccentColor" or "OutlineColor"

            if Toggle.Disabled then
                Label.TextTransparency = 0.8
                Ball.AnchorPoint = Vector2.new(Offset, 0)
                Ball.Position = UDim2.fromScale(Offset, 0)

                Ball.BackgroundColor3 = Library:GetDarkerColor(Library.Scheme.FontColor)
                Library.Registry[Ball].BackgroundColor3 = function()
                    return Library:GetDarkerColor(Library.Scheme.FontColor)
                end

                return
            end

            TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            TweenService:Create(Ball, Library.TweenInfo, {
                AnchorPoint = Vector2.new(Offset, 0),
                Position = UDim2.fromScale(Offset, 0),
            }):Play()

            Ball.BackgroundColor3 = Library.Scheme.FontColor
            Library.Registry[Ball].BackgroundColor3 = "FontColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:RunChanged()
            Library:SafeCallback(Toggle.Callback, Toggle.Value)
            Library:SafeCallback(Toggle.Changed, Toggle.Value)
        end

        function Toggle:SetValue(Value)
            if Toggle.Disabled then
                return
            end

            Toggle.Value = Value
            Toggle:Display()

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon.Toggled = Toggle.Value
                    Addon:Update()
                end
            end

            Library:UpdateDependencyBoxes()

            if not Toggle.AnyKeyPickerPicking then
                Toggle:RunChanged()
            end
        end

        function Toggle:SetDisabled(Disabled: boolean)
            Toggle.Disabled = Disabled

            if Toggle.TooltipTable then
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon:Update()
                end
            end

            Button.Active = not Toggle.Disabled
            Toggle:Display()
        end

        function Toggle:SetVisible(Visible: boolean)
            Toggle.Visible = Visible

            Button.Visible = Toggle.Visible
            Groupbox:Resize()
        end

        function Toggle:SetText(Text: string)
            Toggle.Text = Text
            Label.Text = Text
        end

        table.insert(
            Toggle.Connections,
            Button.MouseButton1Click:Connect(function()
                if Toggle.Disabled then
                    return
                end

                Toggle:SetValue(not Toggle.Value)
            end)
        )

        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
            Toggle.TooltipTable.Disabled = Toggle.Disabled
        end

        if Toggle.Risky then
            Label.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Label].TextColor3 = "RedColor"
        end

        Toggle:Display()
        Groupbox:Resize()

        Toggle.TextLabel = Label
        Toggle.Container = Container
        setmetatable(Toggle, BaseAddons)

        Toggle.Holder = Button
        table.insert(Groupbox.Elements, Toggle)

        Toggle.Default = Toggle.Value

        Toggles[Idx] = Toggle

        function Toggle:Destroy()
            Toggle.Destroyed = true

            if Toggle.Connections then
                for _, Connection in Toggle.Connections do
                    Connection:Disconnect()
                end
            end

            if Toggle.TooltipTable then
                Toggle.TooltipTable:Destroy()
            end

            if Button then
                Button:Destroy()
            end

            if Toggle.Addons then
                for Index = #Toggle.Addons, 1, -1 do
                    local Addon = table.remove(Toggle.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            local ElemIdx = table.find(Groupbox.Elements, Toggle)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Toggles[Idx] = nil
        end

        return Toggle
    end

    function Funcs:AddInput(Idx, Info)
        if self.Destroyed then
            return nil
        end

        if
            typeof(Info) == "table"
            and (typeof(Info.VerifyValue) == "function" and Info.Finished ~= true)
        then
            Info.Finished = true
        end

        Info = Library:Validate(Info, Templates.Input)

        local Groupbox = self
        local Container = Groupbox.Container

        local Input = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Finished = Info.Finished,
            Numeric = Info.Numeric,
            ClearTextOnFocus = Info.ClearTextOnFocus,
            ClearTextOnBlur = Info.ClearTextOnBlur,
            Placeholder = Info.Placeholder,
            AllowEmpty = Info.AllowEmpty,
            EmptyReset = Info.EmptyReset,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,
            VerifyValue = Info.VerifyValue,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Type = "Input",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 39),
            Visible = Input.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Input.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        local Box = New("TextBox", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus,
            PlaceholderText = Input.Placeholder,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = Input.Value,
            TextEditable = not Input.Disabled,
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Box,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Box,
            })
        )

        function Input:UpdateColors()
            if Library.Unloaded then
                return
            end

            Label.TextTransparency = Input.Disabled and 0.8 or 0
            Box.TextTransparency = Input.Disabled and 0.8 or 0
        end

        function Input:OnChanged(Func)
            Input.Changed = Func
        end

        function Input:RunChanged()
            Library:SafeCallback(Input.Callback, Input.Value)
            Library:SafeCallback(Input.Changed, Input.Value)
        end

        function Input:SetValue(Text)
            if not Input.AllowEmpty and Trim(Text) == "" then
                Text = Input.EmptyReset
            end

            if Info.MaxLength and #Text > Info.MaxLength then
                Text = Text:sub(1, Info.MaxLength)
            end

            if Input.Numeric then
                if #tostring(Text) > 0 and not tonumber(Text) then
                    Text = Input.Value
                end
            end

            if
                typeof(Info.VerifyValue) == "function"
                and (Text ~= Input.EmptyReset and Info.VerifyValue(Text) ~= true)
            then
                Text = Input.EmptyReset
            end

            Input.Value = Text
            Box.Text = Text

            if not Input.Disabled then
                Input:RunChanged()
            end
        end

        function Input:SetDisabled(Disabled: boolean)
            Input.Disabled = Disabled

            if Input.TooltipTable then
                Input.TooltipTable.Disabled = Input.Disabled
            end

            Box.ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus
            Box.TextEditable = not Input.Disabled
            Input:UpdateColors()
        end

        function Input:SetVisible(Visible: boolean)
            Input.Visible = Visible

            Holder.Visible = Input.Visible
            Groupbox:Resize()
        end

        function Input:SetText(Text: string)
            Input.Text = Text
            Label.Text = Text
        end

        if Input.Finished then
            table.insert(
                Input.Connections,
                Box.FocusLost:Connect(function(Enter)
                    if not Enter then
                        if Input.ClearTextOnBlur then
                            Box.Text = Input.Value
                        end

                        return
                    end

                    Input:SetValue(Box.Text)
                end)
            )
        else
            table.insert(
                Input.Connections,
                Box:GetPropertyChangedSignal("Text"):Connect(function()
                    if Box.Text == Input.Value then
                        return
                    end

                    Input:SetValue(Box.Text)
                end)
            )
        end

        if typeof(Input.Tooltip) == "string" or typeof(Input.DisabledTooltip) == "string" then
            Input.TooltipTable = Library:AddTooltip(Input.Tooltip, Input.DisabledTooltip, Box)
            Input.TooltipTable.Disabled = Input.Disabled
        end

        Groupbox:Resize()

        Input.Holder = Holder
        table.insert(Groupbox.Elements, Input)

        Input.Default = Input.Value
        if
            typeof(Info.VerifyValue) == "function"
            and (Input.Default ~= Input.EmptyReset and Info.VerifyValue(Input.Default) ~= true)
        then
            Input:SetValue(Input.EmptyReset)
            Input.Default = Input.EmptyReset
        end

        Options[Idx] = Input

        function Input:Destroy()
            Input.Destroyed = true

            if Input.Connections then
                for _, Connection in Input.Connections do
                    Connection:Disconnect()
                end
            end

            if Input.TooltipTable then
                Input.TooltipTable:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Input)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Input
    end

    function Funcs:AddSlider(Idx, Info)
        if self.Destroyed then
            return nil
        end

        Info = Library:Validate(Info, Templates.Slider)

        local Groupbox = self
        local Container = Groupbox.Container

        local Slider = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Min = Info.Min,
            Max = Info.Max,

            Prefix = Info.Prefix,
            Suffix = Info.Suffix,
            Compact = Info.Compact,
            Rounding = Info.Rounding,
            HideMax = Info.HideMax,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            AllowRightClickInput = Info.AllowRightClickInput,

            Type = "Slider",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Compact and 15 or 33),
            Visible = Slider.Visible,
            Parent = Container,
        })

        local SliderLabel
        if not Info.Compact then
            SliderLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                Text = Slider.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
        end

        local Bar = New("TextButton", {
            Active = not Slider.Disabled,
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 15),
            Text = "",
            Parent = Holder,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Bar,
        })

        local DisplayLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            TextSize = 14,
            ZIndex = Bar.ZIndex + 2,
            Parent = Bar,
        })
        New("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
            Color = "DarkColor",
            LineJoinMode = Enum.LineJoinMode.Miter,
            Parent = DisplayLabel,
        })

        local InputTextBox
        if Info.AllowRightClickInput then
            InputTextBox = New("TextBox", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                TextSize = 14,
                ZIndex = Bar.ZIndex + 3,
                Visible = false,
                ClearTextOnFocus = false,
                Parent = Bar,
            })
            New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = "DarkColor",
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = InputTextBox,
            })
        end

        local Fill = New("Frame", {
            BackgroundColor3 = "AccentColor",
            Size = UDim2.fromScale(0.5, 1),
            ZIndex = Bar.ZIndex + 1,
            Parent = Bar,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Bar,
            })
        )

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Fill,
            })
        )

        function Slider:UpdateColors()
            if Library.Unloaded then
                return
            end

            if SliderLabel then
                SliderLabel.TextTransparency = Slider.Disabled and 0.8 or 0
            end
            DisplayLabel.TextTransparency = Slider.Disabled and 0.8 or 0

            if Info.AllowRightClickInput then
                InputTextBox.TextTransparency = Slider.Disabled and 0.8 or 0
            end

            Fill.BackgroundColor3 = Slider.Disabled and Library.Scheme.OutlineColor
                or Library.Scheme.AccentColor
            Library.Registry[Fill].BackgroundColor3 = Slider.Disabled and "OutlineColor"
                or "AccentColor"
        end

        function Slider:Display()
            if Library.Unloaded then
                return
            end

            local CustomDisplayText = nil
            if Info.FormatDisplayValue then
                CustomDisplayText = Info.FormatDisplayValue(Slider, Slider.Value)
            end

            if CustomDisplayText then
                DisplayLabel.Text = tostring(CustomDisplayText)
            else
                if Info.Compact then
                    DisplayLabel.Text = string.format(
                        "%s: %s%s%s",
                        Slider.Text,
                        Slider.Prefix,
                        Slider.Value,
                        Slider.Suffix
                    )
                elseif Info.HideMax then
                    DisplayLabel.Text =
                        string.format("%s%s%s", Slider.Prefix, Slider.Value, Slider.Suffix)
                else
                    DisplayLabel.Text = string.format(
                        "%s%s%s/%s%s%s",
                        Slider.Prefix,
                        Slider.Value,
                        Slider.Suffix,
                        Slider.Prefix,
                        Slider.Max,
                        Slider.Suffix
                    )
                end
            end

            local X = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
            Fill.Size = UDim2.fromScale(X, 1)
        end

        function Slider:OnChanged(Func)
            Slider.Changed = Func
        end

        function Slider:SetMax(Value)
            assert(Value > Slider.Min, "Max value cannot be less than the current min value.")

            Slider:SetValue(math.clamp(Slider.Value, Slider.Min, Value))
            Slider.Max = Value
            Slider:Display()
        end

        function Slider:SetMin(Value)
            assert(Value < Slider.Max, "Min value cannot be greater than the current max value.")

            Slider:SetValue(math.clamp(Slider.Value, Value, Slider.Max))
            Slider.Min = Value
            Slider:Display()
        end

        function Slider:RunChanged()
            Library:SafeCallback(Slider.Callback, Slider.Value)
            Library:SafeCallback(Slider.Changed, Slider.Value)
        end

        function Slider:SetValue(Str)
            if Slider.Disabled then
                return
            end

            local Num = tonumber(Str)
            if not Num or Num == Slider.Value then
                return
            end

            Num = math.clamp(Num, Slider.Min, Slider.Max)

            Slider.Value = Num
            Slider:Display()

            Slider:RunChanged()
        end

        function Slider:SetDisabled(Disabled: boolean)
            Slider.Disabled = Disabled

            if Slider.TooltipTable then
                Slider.TooltipTable.Disabled = Slider.Disabled
            end

            Bar.Active = not Slider.Disabled
            Slider:UpdateColors()
        end

        function Slider:SetVisible(Visible: boolean)
            Slider.Visible = Visible

            Holder.Visible = Slider.Visible
            Groupbox:Resize()
        end

        function Slider:SetText(Text: string)
            Slider.Text = Text
            if SliderLabel then
                SliderLabel.Text = Text
                return
            end
            Slider:Display()
        end

        function Slider:SetPrefix(Prefix: string)
            Slider.Prefix = Prefix
            Slider:Display()
        end

        function Slider:SetSuffix(Suffix: string)
            Slider.Suffix = Suffix
            Slider:Display()
        end

        if Info.AllowRightClickInput then
            local LastValidText = ""
            table.insert(
                Slider.Connections,
                InputTextBox:GetPropertyChangedSignal("Text"):Connect(function()
                    local Text = InputTextBox.Text
                    local AsNum = tonumber(Text)

                    if #tostring(Text) > 0 and not AsNum and Text ~= "-" then
                        InputTextBox.Text = LastValidText
                    else
                        if Slider.Rounding == 0 and Text:find("%.") then
                            InputTextBox.Text = LastValidText
                            return
                        end

                        local DecimalPos = Text:find("%.")
                        if DecimalPos and Slider.Rounding > 0 then
                            local Decimals = #Text - DecimalPos
                            if Decimals > Slider.Rounding then
                                InputTextBox.Text = LastValidText
                                return
                            end
                        end

                        LastValidText = Text

                        if AsNum then
                            if AsNum > Slider.Max then
                                InputTextBox.Text = tostring(Slider.Max)
                            elseif AsNum < Slider.Min then
                                InputTextBox.Text = tostring(Slider.Min)
                            end
                        end
                    end
                end)
            )

            table.insert(
                Slider.Connections,
                InputTextBox.FocusLost:Connect(function()
                    InputTextBox.Visible = false
                    DisplayLabel.Visible = true

                    local Num = tonumber(InputTextBox.Text)
                    if not Num then
                        return
                    end

                    Num = Round(Num, Slider.Rounding)
                    Slider:SetValue(Num)
                end)
            )
        end

        local LastTap = 0
        table.insert(
            Slider.Connections,
            Bar.InputBegan:Connect(function(Input: InputObject)
                local ValidInput = IsClickInput(Input)
                    or Input.UserInputType == Enum.UserInputType.MouseButton2
                if not ValidInput or Slider.Disabled then
                    return
                end

                if Info.AllowRightClickInput then
                    local IsRightClick = Input.UserInputType == Enum.UserInputType.MouseButton2
                    local IsDoubleTap = false

                    if Library.IsMobile and Input.UserInputType == Enum.UserInputType.Touch then
                        if tick() - LastTap < 0.3 then
                            IsDoubleTap = true
                        end

                        LastTap = tick()
                    end

                    if IsRightClick or IsDoubleTap then
                        InputTextBox.Text = tostring(Slider.Value)
                        InputTextBox.Visible = true
                        DisplayLabel.Visible = false

                        task.spawn(InputTextBox.CaptureFocus, InputTextBox)
                        return
                    end
                end

                if not IsClickInput(Input) then
                    return
                end

                if Library.ActiveTab then
                    for _, Side in Library.ActiveTab.Sides do
                        Side.ScrollingEnabled = false
                    end
                end

                if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
                    Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = false
                end

                while IsDragInput(Input) and not Slider.Destroyed do
                    local Location = Mouse.X
                    local Scale =
                        math.clamp((Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)

                    local OldValue = Slider.Value
                    Slider.Value =
                        Round(Slider.Min + ((Slider.Max - Slider.Min) * Scale), Slider.Rounding)

                    Slider:Display()
                    if Slider.Value ~= OldValue then
                        Slider:RunChanged()
                    end

                    RunService.RenderStepped:Wait()
                end

                if Library.ActiveTab then
                    for _, Side in Library.ActiveTab.Sides do
                        Side.ScrollingEnabled = true
                    end
                end

                if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
                    Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = true
                end
            end)
        )

        if typeof(Slider.Tooltip) == "string" or typeof(Slider.DisabledTooltip) == "string" then
            Slider.TooltipTable = Library:AddTooltip(Slider.Tooltip, Slider.DisabledTooltip, Bar)
            Slider.TooltipTable.Disabled = Slider.Disabled
        end

        Slider:UpdateColors()
        Slider:Display()
        Groupbox:Resize()

        Slider.Holder = Holder
        table.insert(Groupbox.Elements, Slider)

        Slider.Default = Slider.Value

        Options[Idx] = Slider

        function Slider:Destroy()
            Slider.Destroyed = true

            if Slider.Connections then
                for _, Connection in Slider.Connections do
                    Connection:Disconnect()
                end
            end

            if Slider.TooltipTable then
                Slider.TooltipTable:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Slider)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Slider
    end

    function Funcs:AddDropdown(Idx, Info)
        if self.Destroyed then
            return nil
        end

        Info = Library:Validate(Info, Templates.Dropdown)

        local Groupbox = self
        local Container = Groupbox.Container

        if Info.SpecialType == "Player" then
            Info.Values = GetPlayers(Info.ExcludeLocalPlayer)
            Info.AllowNull = true
        elseif Info.SpecialType == "Team" then
            Info.Values = GetTeams()
            Info.AllowNull = true
        end

        local Dropdown = {
            Connections = {},
            Destroyed = false,

            Text = typeof(Info.Text) == "string" and Info.Text or nil,

            Value = Info.Multi and {} or nil,
            Values = Info.Values,
            DisabledValues = Info.DisabledValues,
            ValueImages = Info.ValueImages,

            Multi = Info.Multi,
            DragSelect = Info.Multi and not Library.IsMobile and Info.DragSelect == true,

            SpecialType = Info.SpecialType,
            ExcludeLocalPlayer = Info.ExcludeLocalPlayer,
            EnablePlayerImages = Info.EnablePlayerImages,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Type = "Dropdown",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21),
            Visible = Dropdown.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Dropdown.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = not not Info.Text,
            ZIndex = 3,
            Parent = Holder,
        })

        local DisplayContainer = New("TextButton", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = "",
            TextTransparency = 1,
            ZIndex = 2,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 4),
            Parent = DisplayContainer,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = DisplayContainer,
        })

        local DropdownCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = DisplayContainer,
        })
        table.insert(Library.SpecificCorners, DropdownCorner)

        local DisplayImage = New("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(-4, 3),
            Size = UDim2.fromOffset(16, 16),
            Image = "",
            ImageTransparency = 1,
            ZIndex = 2,
            Parent = DisplayContainer,
        })

        local DisplayButton = New("TextButton", {
            Active = not Dropdown.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 21),
            Text = "---",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2,
            Parent = DisplayContainer,
        })

        local ArrowImage = New("ImageLabel", {
            AnchorPoint = Vector2.new(1, 0.5),
            Image = ArrowIcon and ArrowIcon.Url or "",
            ImageColor3 = "FontColor",
            ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 0.5,
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromOffset(16, 16),
            Parent = DisplayContainer,
        })

        local SearchBox
        if Info.Searchable then
            SearchBox = New("TextBox", {
                BackgroundTransparency = 1,
                PlaceholderText = "Search...",
                Position = UDim2.fromOffset(-8, 0),
                Size = UDim2.new(1, -12, 1, 0),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = false,
                Parent = DisplayButton,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                Parent = SearchBox,
            })
        end

        local GetValueImage = function(Value)
            if not Value then
                return nil
            end

            local ValueImage = nil
            if Dropdown.SpecialType == "Player" and Dropdown.EnablePlayerImages == true then
                if typeof(Value) == "Instance" and Value:IsA("Player") then
                    ValueImage = {
                        Url = string.format(
                            "rbxthumb://type=AvatarHeadShot&id=%s&w=48&h=48",
                            tostring(Value.UserId)
                        ),
                    }
                end
            else
                if Info.ValueImages and Info.ValueImages[Value] then
                    ValueImage = Library:GetCustomIcon(Info.ValueImages[Value])
                end
            end

            return ValueImage
        end

        local MenuTable = Library:AddContextMenu(
            DisplayContainer,
            function()
                return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), 0)
            end,
            function()
                return { 0.5, DisplayContainer.AbsoluteSize.Y + 1.5 }
            end,
            2,
            function(Active: boolean)
                DisplayButton.TextTransparency = (Active and SearchBox) and 1 or 0

                ArrowImage.ImageTransparency = Active and 0 or 0.5
                ArrowImage.Rotation = Active and 180 or 0

                if SearchBox then
                    SearchBox.Text = ""
                    SearchBox.Visible = Active
                end

                DropdownCorner.BottomRightRadius = Active and UDim.new(0, 0)
                    or UDim.new(0, Library.CornerRadius / 2)
                DropdownCorner.BottomLeftRadius = Active and UDim.new(0, 0)
                    or UDim.new(0, Library.CornerRadius / 2)
            end,
            false,
            "bottom",
            "Dropdown"
        )
        Dropdown.Menu = MenuTable

        function Dropdown:RecalculateListSize(Count)
            local Y = math.clamp(
                (Count or GetTableSize(Dropdown.Values)) * 21,
                0,
                Info.MaxVisibleDropdownItems * 21
            )

            MenuTable:SetSize(function()
                return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), Y)
            end)
        end

        function Dropdown:UpdateColors()
            if Library.Unloaded then
                return
            end

            Label.TextTransparency = Dropdown.Disabled and 0.8 or 0
            DisplayButton.TextTransparency = Dropdown.Disabled and 0.8 or 0
            DisplayImage.ImageTransparency = Dropdown.Disabled and 0.8 or 0
            ArrowImage.ImageTransparency = Dropdown.Disabled and 0.8
                or MenuTable.Active and 0
                or 0.5
        end

        function Dropdown:Display()
            if Library.Unloaded then
                return
            end

            local Str = ""
            local ValueImage = nil

            if Info.Multi then
                for _, Value in Dropdown.Values do
                    if Dropdown.Value[Value] then
                        if not ValueImage then
                            ValueImage = GetValueImage(Value)
                        end

                        Str = Str
                            .. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(Value)) or tostring(
                                Value
                            ))
                            .. ", "
                    end
                end

                Str = Str:sub(1, #Str - 2)
            else
                ValueImage = GetValueImage(Dropdown.Value)
                Str = Dropdown.Value and tostring(Dropdown.Value) or ""

                if Str ~= "" and Info.FormatDisplayValue then
                    Str = tostring(Info.FormatDisplayValue(Str))
                end
            end

            if #Str > 25 then
                Str = Str:sub(1, 22) .. "..."
            end

            DisplayButton.Text = (Str == "" and "---" or Str)

            if ValueImage then
                DisplayImage.Image = ValueImage.Url
                DisplayImage.ImageRectOffset = ValueImage.ImageRectOffset or Vector2.zero
                DisplayImage.ImageRectSize = ValueImage.ImageRectSize or Vector2.zero
                DisplayImage.ImageTransparency = 0
            else
                DisplayImage.Image = ""
                DisplayImage.ImageTransparency = 1
            end

            DisplayButton.Size = ValueImage and UDim2.new(1, -8, 0, 21) or UDim2.new(1, 0, 0, 21)
            DisplayButton.Position = ValueImage and UDim2.fromOffset(14, 0)
                or UDim2.fromOffset(0, 0)
        end

        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func
        end

        function Dropdown:GetActiveValues(ReturnCount)
            local Table = {}

            if Info.Multi then
                for Value, _ in Dropdown.Value do
                    table.insert(Table, Value)
                end
            else
                if Dropdown.Value then
                    table.insert(Table, Dropdown.Value)
                end
            end

            return ReturnCount == true and GetTableSize(Table) or Table
        end

        local Buttons = {}
        local DragSelecting = false
        local DragStartIndex = nil
        local DragInitialValues = {}
        local DragInputEndedConn = nil
        local DragInputChangedConn = nil

        local function StopDragSelect()
            DragSelecting = false
            DragStartIndex = nil
            table.clear(DragInitialValues)

            if DragInputEndedConn then
                DragInputEndedConn:Disconnect()
                DragInputEndedConn = nil
            end

            if DragInputChangedConn then
                DragInputChangedConn:Disconnect()
                DragInputChangedConn = nil
            end
        end

        local function UpdateDrag(CurrentIndex)
            local Min = math.min(DragStartIndex, CurrentIndex)
            local Max = math.max(DragStartIndex, CurrentIndex)

            for OtherButton, OtherTable in Buttons do
                local InRange = OtherTable.Index >= Min and OtherTable.Index <= Max
                local Try = DragInitialValues[OtherTable.Value]
                if InRange then
                    Try = not Try
                end

                if not (Dropdown:GetActiveValues(true) == 1 and not Try and not Info.AllowNull) then
                    Dropdown.Value[OtherTable.Value] = Try and true or nil
                end

                OtherTable:UpdateButton()
            end

            Dropdown:Display()
        end

        function Dropdown:BuildDropdownList()
            local Values = Dropdown.Values
            local DisabledValues = Dropdown.DisabledValues

            StopDragSelect()

            for Button, _ in Buttons do
                if not (Button and Button.Parent) then
                    continue
                end

                Button.Parent:Destroy()
            end
            table.clear(Buttons)

            local Count = 0
            local ProcessedCount = 0
            local TotalLen = GetTableSize(Values) + GetTableSize(DisabledValues)

            for _, Value in Values do
                ProcessedCount += 1

                local FormattedValue =
                    tostring(Info.FormatListValue and Info.FormatListValue(Value) or Value)
                if SearchBox and not FormattedValue:lower():match(SearchBox.Text:lower()) then
                    continue
                end

                Count += 1

                local IsDisabled = table.find(DisabledValues, Value)
                local Table = {}
                local ValueImage = GetValueImage(Value)

                local Container = New("Frame", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 1,
                    LayoutOrder = IsDisabled and 1 or 0,
                    Size = UDim2.new(1, 0, 0, 21),
                    Parent = MenuTable.Menu,
                })

                if ProcessedCount == TotalLen then
                    local Corner = New("UICorner", {
                        TopLeftRadius = UDim.new(0, 0),
                        TopRightRadius = UDim.new(0, 0),
                        BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                        BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = Container,
                    })
                    table.insert(Library.SpecificCorners, Corner)
                end

                local Image = ValueImage
                    and New("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = ValueImage.Url,
                        ImageRectOffset = ValueImage.ImageRectOffset,
                        ImageRectSize = ValueImage.ImageRectSize,
                        ImageTransparency = 0.5,
                        Size = UDim2.fromOffset(16, 16),
                        Position = UDim2.fromOffset(4, 3),
                        Parent = Container,
                    })

                local Button = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = ValueImage and UDim2.new(1, -18, 0, 21) or UDim2.new(1, 0, 0, 21),
                    Position = ValueImage and UDim2.fromOffset(18, 0) or UDim2.fromOffset(0, 0),
                    Text = FormattedValue,
                    TextSize = 14,
                    TextTransparency = 0.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Container,
                })
                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    Parent = Button,
                })

                local Selected
                if Info.Multi then
                    Selected = Dropdown.Value[Value]
                else
                    Selected = Dropdown.Value == Value
                end

                function Table:UpdateButton()
                    if Info.Multi then
                        Selected = Dropdown.Value[Value]
                    else
                        Selected = Dropdown.Value == Value
                    end

                    Container.BackgroundTransparency = Selected and 0 or 1
                    Button.TextTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5

                    if Image then
                        Image.ImageTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5
                    end
                end

                Table.Index = Count
                Table.Value = Value

                if not IsDisabled then
                    Button.MouseButton1Click:Connect(function()
                        if DragSelecting then
                            return
                        end

                        local Try = not Selected
                        if
                            not (
                                Dropdown:GetActiveValues(true) == 1
                                and not Try
                                and not Info.AllowNull
                            )
                        then
                            Selected = Try
                            if Info.Multi then
                                Dropdown.Value[Value] = Selected and true or nil
                            else
                                Dropdown.Value = Selected and Value or nil
                            end

                            for _, OtherButton in Buttons do
                                OtherButton:UpdateButton()
                            end
                        end

                        Table:UpdateButton()
                        Dropdown:Display()

                        Library:UpdateDependencyBoxes()
                        Dropdown:RunChanged()
                    end)

                    if Info.Multi and Dropdown.DragSelect and not Library.IsMobile then
                        Button.InputBegan:Connect(function(StartInput)
                            if not IsMouseInput(StartInput) then
                                return
                            end

                            DragSelecting = true
                            DragStartIndex = Table.Index
                            table.clear(DragInitialValues)

                            for OtherButton, OtherTable in Buttons do
                                DragInitialValues[OtherTable.Value] =
                                    Dropdown.Value[OtherTable.Value]
                            end

                            UpdateDrag(Table.Index)

                            if DragInputEndedConn then
                                DragInputEndedConn:Disconnect()
                            end
                            if DragInputChangedConn then
                                DragInputChangedConn:Disconnect()
                            end

                            DragInputChangedConn = Library:GiveSignal(
                                UserInputService.InputChanged:Connect(function(ChangeInput)
                                    if
                                        not IsMovementInput(ChangeInput)
                                        and ChangeInput ~= StartInput
                                    then
                                        return
                                    end

                                    local Pos = ChangeInput.Position
                                    for OtherButton, OtherTable in Buttons do
                                        if Library:MouseIsOverFrame(OtherButton, Pos) then
                                            UpdateDrag(OtherTable.Index)
                                            break
                                        end
                                    end
                                end)
                            )

                            DragInputEndedConn = Library:GiveSignal(
                                UserInputService.InputEnded:Connect(function(EndInput)
                                    if
                                        EndInput ~= StartInput
                                        and not (
                                            IsMouseInput(EndInput)
                                            and EndInput.UserInputType
                                                == StartInput.UserInputType
                                        )
                                    then
                                        return
                                    end

                                    Library:UpdateDependencyBoxes()
                                    Dropdown:RunChanged()

                                    StopDragSelect()
                                end)
                            )

                            table.insert(Dropdown.Connections, DragInputEndedConn)
                            table.insert(Dropdown.Connections, DragInputChangedConn)
                        end)
                    end
                end

                Table:UpdateButton()
                Dropdown:Display()

                Buttons[Button] = Table
            end

            Dropdown:RecalculateListSize(Count)
        end

        function Dropdown:RunChanged()
            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
        end

        function Dropdown:SetValue(Value)
            if Info.Multi then
                local Table = {}

                for Val, Active in Value or {} do
                    if typeof(Active) ~= "boolean" then
                        Table[Active] = true
                    elseif Active and table.find(Dropdown.Values, Val) then
                        Table[Val] = true
                    end
                end

                Dropdown.Value = Table
            else
                if table.find(Dropdown.Values, Value) then
                    Dropdown.Value = Value
                elseif not Value then
                    Dropdown.Value = nil
                end
            end

            Dropdown:Display()
            for _, Button in Buttons do
                Button:UpdateButton()
            end

            if not Dropdown.Disabled then
                Library:UpdateDependencyBoxes()
                Dropdown:RunChanged()
            end
        end

        function Dropdown:SetValues(Values)
            Dropdown.Values = Values
            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddValues(Values)
            if typeof(Values) == "table" then
                for _, val in Values do
                    table.insert(Dropdown.Values, val)
                end
            elseif typeof(Values) == "string" then
                table.insert(Dropdown.Values, Values)
            else
                return
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetDisabledValues(DisabledValues)
            Dropdown.DisabledValues = DisabledValues
            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddDisabledValues(DisabledValues)
            if typeof(DisabledValues) == "table" then
                for _, val in DisabledValues do
                    table.insert(Dropdown.DisabledValues, val)
                end
            elseif typeof(DisabledValues) == "string" then
                table.insert(Dropdown.DisabledValues, DisabledValues)
            else
                return
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetValueImages(ValueImages)
            if typeof(ValueImages) ~= "table" then
                return
            end

            Dropdown.ValueImages = ValueImages
            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddValueImages(ValueImages)
            if typeof(ValueImages) ~= "table" then
                return
            end

            for key, val in ValueImages do
                Dropdown.ValueImages[key] = val
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetDisabled(Disabled: boolean)
            Dropdown.Disabled = Disabled

            if Dropdown.TooltipTable then
                Dropdown.TooltipTable.Disabled = Dropdown.Disabled
            end

            MenuTable:Close()
            DisplayButton.Active = not Dropdown.Disabled
            Dropdown:UpdateColors()
        end

        function Dropdown:SetVisible(Visible: boolean)
            Dropdown.Visible = Visible

            Holder.Visible = Dropdown.Visible
            Groupbox:Resize()
        end

        function Dropdown:SetText(Text: string)
            Dropdown.Text = Text
            Holder.Size = UDim2.new(1, 0, 0, Text and 39 or 21)

            Label.Text = Text and Text or ""
            Label.Visible = not not Text
        end

        function Dropdown:SetDragSelect(Value: boolean)
            if not Info.Multi or Library.IsMobile then
                Value = false
            end

            Dropdown.DragSelect = Value == true
            Dropdown:BuildDropdownList()
        end

        local ToggleDropdown = function()
            if Dropdown.Disabled then
                return
            end

            MenuTable:Toggle()
        end

        table.insert(
            Dropdown.Connections,
            DisplayContainer.MouseButton1Click:Connect(ToggleDropdown)
        )
        table.insert(Dropdown.Connections, DisplayButton.MouseButton1Click:Connect(ToggleDropdown))

        if SearchBox then
            table.insert(
                Dropdown.Connections,
                SearchBox:GetPropertyChangedSignal("Text"):Connect(Dropdown.BuildDropdownList)
            )
        end

        local Defaults = {}
        if typeof(Info.Default) == "string" then
            local Index = table.find(Dropdown.Values, Info.Default)
            if Index then
                table.insert(Defaults, Index)
            end
        elseif typeof(Info.Default) == "table" then
            for _, Value in next, Info.Default do
                local Index = table.find(Dropdown.Values, Value)
                if Index then
                    table.insert(Defaults, Index)
                end
            end
        elseif Dropdown.Values[Info.Default] ~= nil then
            table.insert(Defaults, Info.Default)
        end

        if next(Defaults) then
            for i = 1, #Defaults do
                local Index = Defaults[i]
                if Info.Multi then
                    Dropdown.Value[Dropdown.Values[Index]] = true
                else
                    Dropdown.Value = Dropdown.Values[Index]
                end

                if not Info.Multi then
                    break
                end
            end
        end

        if typeof(Dropdown.Tooltip) == "string" or typeof(Dropdown.DisabledTooltip) == "string" then
            Dropdown.TooltipTable =
                Library:AddTooltip(Dropdown.Tooltip, Dropdown.DisabledTooltip, DisplayContainer)
            Dropdown.TooltipTable.Disabled = Dropdown.Disabled
        end

        Dropdown:UpdateColors()
        Dropdown:Display()
        Dropdown:BuildDropdownList()
        Groupbox:Resize()

        Dropdown.Holder = Holder
        table.insert(Groupbox.Elements, Dropdown)

        Dropdown.Default = Defaults
        Dropdown.DefaultValues = Dropdown.Values

        Options[Idx] = Dropdown

        function Dropdown:Destroy()
            Dropdown.Destroyed = true

            StopDragSelect()

            if Dropdown.Connections then
                for _, Connection in Dropdown.Connections do
                    Connection:Disconnect()
                end
            end

            if Dropdown.TooltipTable then
                Dropdown.TooltipTable:Destroy()
            end

            if MenuTable then
                MenuTable:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Dropdown)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Dropdown
    end

    function Funcs:AddViewport(Idx, Info)
        if self.Destroyed then
            return nil
        end

        Info = Library:Validate(Info, Templates.Viewport)

        local Groupbox = self
        local Container = Groupbox.Container

        local Dragging, Pinching = false, false
        local LastMousePos, LastPinchDist = nil, 0

        local ViewportObject = Info.Object
        if Info.Clone and typeof(Info.Object) == "Instance" then
            if Info.Object.Archivable then
                ViewportObject = ViewportObject:Clone()
            else
                Info.Object.Archivable = true
                ViewportObject = ViewportObject:Clone()
                Info.Object.Archivable = false
            end
        end

        local Viewport = {
            Connections = {},
            Destroyed = false,

            Object = ViewportObject :: PVInstance,
            Camera = if not Info.Camera then Instance.new("Camera") else Info.Camera,
            Interactive = Info.Interactive,
            AutoFocus = Info.AutoFocus,
            Visible = Info.Visible,
            Type = "Viewport",
        }

        assert(
            typeof(Viewport.Object) == "Instance"
                and (Viewport.Object:IsA("BasePart") or Viewport.Object:IsA("Model")),
            "Instance must be a BasePart or Model."
        )

        assert(
            typeof(Viewport.Camera) == "Instance" and Viewport.Camera:IsA("Camera"),
            "Camera must be a valid Camera instance."
        )

        local function GetModelSize(model)
            if model:IsA("BasePart") then
                return model.Size
            end

            return select(2, model:GetBoundingBox())
        end

        local function FocusCamera()
            local ModelSize = GetModelSize(Viewport.Object)
            local MaxExtent = math.max(ModelSize.X, ModelSize.Y, ModelSize.Z)
            local CameraDistance = MaxExtent * 2
            local ModelPosition = (Viewport.Object :: PVInstance):GetPivot().Position

            Viewport.Camera.CFrame = CFrame.new(
                ModelPosition + Vector3.new(0, MaxExtent / 2, CameraDistance),
                ModelPosition
            )
        end

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Viewport.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local ViewportFrame = New("ViewportFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = Box,
            CurrentCamera = Viewport.Camera,
            Active = Viewport.Interactive,
        })

        table.insert(
            Viewport.Connections,
            ViewportFrame.MouseEnter:Connect(function()
                if not Viewport.Interactive then
                    return
                end

                for _, Side in Groupbox.Tab.Sides do
                    Side.ScrollingEnabled = false
                end
            end)
        )

        table.insert(
            Viewport.Connections,
            ViewportFrame.MouseLeave:Connect(function()
                if not Viewport.Interactive then
                    return
                end

                for _, Side in Groupbox.Tab.Sides do
                    Side.ScrollingEnabled = true
                end
            end)
        )

        table.insert(
            Viewport.Connections,
            ViewportFrame.InputBegan:Connect(function(input)
                if not Viewport.Interactive then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Dragging = true
                    LastMousePos = input.Position
                elseif input.UserInputType == Enum.UserInputType.Touch and not Pinching then
                    Dragging = true
                    LastMousePos = input.Position
                end
            end)
        )

        table.insert(
            Viewport.Connections,
            UserInputService.InputEnded:Connect(function(input)
                if Library.Unloaded then
                    return
                end

                if not Viewport.Interactive then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Dragging = false
                elseif input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
        )

        table.insert(
            Viewport.Connections,
            UserInputService.InputChanged:Connect(function(input)
                if Library.Unloaded then
                    return
                end

                if not Viewport.Interactive or not Dragging or Pinching then
                    return
                end

                if
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    local MouseDelta = input.Position - LastMousePos
                    LastMousePos = input.Position

                    local Position = (Viewport.Object :: PVInstance):GetPivot().Position
                    local Camera = Viewport.Camera

                    local RotationY =
                        CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -MouseDelta.X * 0.01)
                    Camera.CFrame = CFrame.new(Position)
                        * RotationY
                        * CFrame.new(-Position)
                        * Camera.CFrame

                    local RotationX =
                        CFrame.fromAxisAngle(Camera.CFrame.RightVector, -MouseDelta.Y * 0.01)
                    local PitchedCFrame = CFrame.new(Position)
                        * RotationX
                        * CFrame.new(-Position)
                        * Camera.CFrame

                    if PitchedCFrame.UpVector.Y > 0.1 then
                        Camera.CFrame = PitchedCFrame
                    end
                end
            end)
        )

        table.insert(
            Viewport.Connections,
            ViewportFrame.InputChanged:Connect(function(input)
                if not Viewport.Interactive then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseWheel then
                    local ZoomAmount = input.Position.Z * 2
                    Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * ZoomAmount
                end
            end)
        )

        table.insert(
            Viewport.Connections,
            UserInputService.TouchPinch:Connect(function(touchPositions, scale, velocity, state)
                if Library.Unloaded then
                    return
                end

                if
                    not Viewport.Interactive
                    or not Library:MouseIsOverFrame(ViewportFrame, touchPositions[1])
                then
                    return
                end

                if state == Enum.UserInputState.Begin then
                    Pinching = true
                    Dragging = false
                    LastPinchDist = (touchPositions[1] - touchPositions[2]).Magnitude
                elseif state == Enum.UserInputState.Change then
                    local currentDist = (touchPositions[1] - touchPositions[2]).Magnitude
                    local delta = (currentDist - LastPinchDist) * 0.1
                    LastPinchDist = currentDist
                    Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * delta
                elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
                    Pinching = false
                end
            end)
        );
        (Viewport.Object :: PVInstance).Parent = ViewportFrame
        if Viewport.AutoFocus then
            FocusCamera()
        end

        function Viewport:SetObject(Object: Instance, Clone: boolean?)
            assert(Object, "Object cannot be nil.")

            if Clone then
                Object = Object:Clone()
            end

            if Viewport.Object then
                Viewport.Object:Destroy()
            end

            Viewport.Object = Object;
            (Viewport.Object :: PVInstance).Parent = ViewportFrame

            Groupbox:Resize()
        end

        function Viewport:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Viewport:Focus()
            if not Viewport.Object then
                return
            end

            FocusCamera()
        end

        function Viewport:SetCamera(Camera: Instance)
            assert(
                Camera and typeof(Camera) == "Instance" and Camera:IsA("Camera"),
                "Camera must be a valid Camera instance."
            )

            Viewport.Camera = Camera
            ViewportFrame.CurrentCamera = Camera
        end

        function Viewport:SetInteractive(Interactive: boolean)
            Viewport.Interactive = Interactive
            ViewportFrame.Active = Interactive
        end

        function Viewport:SetVisible(Visible: boolean)
            Viewport.Visible = Visible

            Holder.Visible = Viewport.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Viewport.Holder = Holder
        table.insert(Groupbox.Elements, Viewport)

        Options[Idx] = Viewport

        function Viewport:Destroy()
            Viewport.Destroyed = true

            if Viewport.Connections then
                for _, Connection in Viewport.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Viewport)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Viewport
    end

    function Funcs:AddImage(Idx, Info)
        if self.Destroyed then
            return nil
        end

        Info = Library:Validate(Info, Templates.Image)

        local Groupbox = self
        local Container = Groupbox.Container

        local Image = {
            Connections = {},
            Destroyed = false,

            Image = Info.Image,
            Color = Info.Color,
            RectOffset = Info.RectOffset,
            RectSize = Info.RectSize,
            Height = Info.Height,
            ScaleType = Info.ScaleType,
            Transparency = Info.Transparency,
            BackgroundTransparency = Info.BackgroundTransparency,

            Visible = Info.Visible,
            Type = "Image",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Image.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            BackgroundTransparency = Image.BackgroundTransparency,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local ImageProperties = {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Image = Image.Image,
            ImageTransparency = Image.Transparency,
            ImageColor3 = Image.Color,
            ImageRectOffset = Image.RectOffset,
            ImageRectSize = Image.RectSize,
            ScaleType = Image.ScaleType,
            Parent = Box,
        }

        local Icon = Library:GetCustomIcon(ImageProperties.Image)
        assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        ImageProperties.Image = Icon.Url
        ImageProperties.ImageRectOffset = Icon.ImageRectOffset
        ImageProperties.ImageRectSize = Icon.ImageRectSize

        local ImageLabel = New("ImageLabel", ImageProperties)

        function Image:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Image.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Image:SetImage(NewImage: string)
            assert(typeof(NewImage) == "string", "Image must be a string.")

            local Icon = Library:GetCustomIcon(NewImage)
            assert(
                Icon,
                "Image must be a valid Roblox asset or a valid URL or a valid lucide icon."
            )

            NewImage = Icon.Url
            Image.RectOffset = Icon.ImageRectOffset
            Image.RectSize = Icon.ImageRectSize

            ImageLabel.Image = NewImage
            Image.Image = NewImage
        end

        function Image:SetColor(Color: Color3)
            assert(typeof(Color) == "Color3", "Color must be a Color3 value.")

            ImageLabel.ImageColor3 = Color
            Image.Color = Color
        end

        function Image:SetRectOffset(RectOffset: Vector2)
            assert(typeof(RectOffset) == "Vector2", "RectOffset must be a Vector2 value.")

            ImageLabel.ImageRectOffset = RectOffset
            Image.RectOffset = RectOffset
        end

        function Image:SetRectSize(RectSize: Vector2)
            assert(typeof(RectSize) == "Vector2", "RectSize must be a Vector2 value.")

            ImageLabel.ImageRectSize = RectSize
            Image.RectSize = RectSize
        end

        function Image:SetScaleType(ScaleType: Enum.ScaleType)
            assert(
                typeof(ScaleType) == "EnumItem" and ScaleType:IsA("ScaleType"),
                "ScaleType must be a valid Enum.ScaleType."
            )

            ImageLabel.ScaleType = ScaleType
            Image.ScaleType = ScaleType
        end

        function Image:SetTransparency(Transparency: number)
            assert(
                typeof(Transparency) == "number",
                "Transparency must be a number between 0 and 1."
            )
            assert(Transparency >= 0 and Transparency <= 1, "Transparency must be between 0 and 1.")

            ImageLabel.ImageTransparency = Transparency
            Image.Transparency = Transparency
        end

        function Image:SetVisible(Visible: boolean)
            Image.Visible = Visible

            Holder.Visible = Image.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Image.Holder = Holder
        table.insert(Groupbox.Elements, Image)

        Options[Idx] = Image

        function Image:Destroy()
            Image.Destroyed = true

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Image)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Image
    end

    function Funcs:AddVideo(Idx, Info)
        if self.Destroyed then
            return nil
        end

        Info = Library:Validate(Info, Templates.Video)

        local Groupbox = self
        local Container = Groupbox.Container

        local Video = {
            Connections = {},
            Destroyed = false,

            Video = Info.Video,
            Looped = Info.Looped,
            Playing = Info.Playing,
            Volume = Info.Volume,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "Video",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Video.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local VideoFrameInstance = New("VideoFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Video = Video.Video,
            Looped = Video.Looped,
            Volume = Video.Volume,
            Parent = Box,
        })

        VideoFrameInstance.Playing = Video.Playing

        function Video:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Video.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Video:SetVideo(NewVideo: string)
            assert(typeof(NewVideo) == "string", "Video must be a string.")

            VideoFrameInstance.Video = NewVideo
            Video.Video = NewVideo
        end

        function Video:SetLooped(Looped: boolean)
            assert(typeof(Looped) == "boolean", "Looped must be a boolean.")

            VideoFrameInstance.Looped = Looped
            Video.Looped = Looped
        end

        function Video:SetVolume(Volume: number)
            assert(typeof(Volume) == "number", "Volume must be a number between 0 and 10.")

            VideoFrameInstance.Volume = Volume
            Video.Volume = Volume
        end

        function Video:SetPlaying(Playing: boolean)
            assert(typeof(Playing) == "boolean", "Playing must be a boolean.")

            VideoFrameInstance.Playing = Playing
            Video.Playing = Playing
        end

        function Video:Play()
            VideoFrameInstance.Playing = true
            Video.Playing = true
        end

        function Video:Pause()
            VideoFrameInstance.Playing = false
            Video.Playing = false
        end

        function Video:SetVisible(Visible: boolean)
            Video.Visible = Visible

            Holder.Visible = Video.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Video.Holder = Holder
        Video.VideoFrame = VideoFrameInstance
        table.insert(Groupbox.Elements, Video)

        Options[Idx] = Video

        function Video:Destroy()
            Video.Destroyed = true

            if Video.Connections then
                for _, Connection in Video.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Video)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Video
    end

    function Funcs:AddUIPassthrough(Idx, Info)
        if self.Destroyed then
            return nil
        end

        Info = Library:Validate(Info, Templates.UIPassthrough)

        local Groupbox = self
        local Container = Groupbox.Container

        assert(Info.Instance, "Instance must be provided.")
        assert(
            typeof(Info.Instance) == "Instance" and Info.Instance:IsA("GuiBase2d"),
            "Instance must inherit from GuiBase2d."
        )
        assert(
            typeof(Info.Height) == "number" and Info.Height > 0,
            "Height must be a number greater than 0."
        )

        local Passthrough = {
            Connections = {},
            Destroyed = false,

            Instance = Info.Instance,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "UIPassthrough",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Passthrough.Visible,
            Parent = Container,
        })

        Passthrough.Instance.Parent = Holder

        Groupbox:Resize()

        function Passthrough:SetHeight(Height: number)
            assert(
                typeof(Height) == "number" and Height > 0,
                "Height must be a number greater than 0."
            )

            Passthrough.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Passthrough:SetInstance(Instance: Instance)
            assert(Instance, "Instance must be provided.")
            assert(
                typeof(Instance) == "Instance" and Instance:IsA("GuiBase2d"),
                "Instance must inherit from GuiBase2d."
            )

            if Passthrough.Instance then
                Passthrough.Instance.Parent = nil
            end

            Passthrough.Instance = Instance
            Passthrough.Instance.Parent = Holder
        end

        function Passthrough:SetVisible(Visible: boolean)
            Passthrough.Visible = Visible

            Holder.Visible = Passthrough.Visible
            Groupbox:Resize()
        end

        Passthrough.Holder = Holder
        table.insert(Groupbox.Elements, Passthrough)

        Options[Idx] = Passthrough

        function Passthrough:Destroy()
            Passthrough.Destroyed = true

            if Passthrough.Connections then
                for _, Connection in Passthrough.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Passthrough)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Passthrough
    end

    function Funcs:AddDependencyBox()
        if self.Destroyed then
            return nil
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local DepboxContainer
        local DepboxList

        do
            DepboxContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            DepboxList = New("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = DepboxContainer,
            })
        end

        local Depbox = {
            Connections = {},
            Destroyed = false,

            Visible = false,
            Dependencies = {},

            Holder = DepboxContainer,
            Container = DepboxContainer,

            Elements = {},
            DependencyBoxes = {},
        }

        function Depbox:Resize()
            DepboxContainer.Size =
                UDim2.new(1, 0, 0, DepboxList.AbsoluteContentSize.Y / Library.DPIScale)
            Groupbox:Resize()
        end

        function Depbox:Update(CancelSearch)
            for _, Dependency in Depbox.Dependencies do
                local Element = Dependency[1]
                local Value = Dependency[2]

                if Element.Type == "Toggle" and Element.Value ~= Value then
                    DepboxContainer.Visible = false
                    Depbox.Visible = false
                    return
                elseif Element.Type == "Dropdown" then
                    if typeof(Element.Value) == "table" then
                        if not Element.Value[Value] then
                            DepboxContainer.Visible = false
                            Depbox.Visible = false
                            return
                        end
                    else
                        if Element.Value ~= Value then
                            DepboxContainer.Visible = false
                            Depbox.Visible = false
                            return
                        end
                    end
                end
            end

            Depbox.Visible = true
            DepboxContainer.Visible = true
            if not Library.Searching then
                task.defer(function()
                    Depbox:Resize()
                end)
            elseif not CancelSearch then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        DepboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if not Depbox.Visible then
                return
            end

            Depbox:Resize()
        end)

        function Depbox:SetupDependencies(Dependencies)
            for _, Dependency in Dependencies do
                assert(typeof(Dependency) == "table", "Dependency should be a table.")
                assert(Dependency[1] ~= nil, "Dependency is missing element.")
                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
            end

            Depbox.Dependencies = Dependencies
            Depbox:Update()
        end

        DepboxContainer:GetPropertyChangedSignal("Visible"):Connect(function()
            Depbox:Resize()
        end)

        setmetatable(Depbox, BaseGroupbox)

        table.insert(Groupbox.DependencyBoxes, Depbox)
        table.insert(Library.DependencyBoxes, Depbox)

        function Depbox:Destroy()
            Depbox.Destroyed = true

            if Depbox.Connections then
                for _, Connection in Depbox.Connections do
                    Connection:Disconnect()
                end
            end

            for _, Element in Depbox.Elements do
                if Element.Destroy then
                    Element:Destroy()
                end
            end

            for _, SubDepbox in Depbox.DependencyBoxes do
                if SubDepbox.Destroy then
                    SubDepbox:Destroy()
                end
            end

            if DepboxContainer then
                DepboxContainer:Destroy()
            end

            local ElemIdx = table.find(Groupbox.DependencyBoxes, Depbox)
            if ElemIdx then
                table.remove(Groupbox.DependencyBoxes, ElemIdx)
            end

            local LibIdx = table.find(Library.DependencyBoxes, Depbox)
            if LibIdx then
                table.remove(Library.DependencyBoxes, LibIdx)
            end
        end

        return Depbox
    end

    function Funcs:AddDependencyGroupbox()
        if self.Destroyed then
            return nil
        end

        local Groupbox = self
        local Tab = Groupbox.Tab
        local BoxHolder = Groupbox.BoxHolder

        local DepGroupboxContainer
        local DepGroupboxList

        do
            DepGroupboxContainer = New("Frame", {
                BackgroundColor3 = "BackgroundColor",
                Size = UDim2.fromScale(1, 0),
                Visible = false,
                Parent = BoxHolder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius),
                    Parent = DepGroupboxContainer,
                })
            )
            Library:AddOutline(DepGroupboxContainer)

            DepGroupboxList = New("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = DepGroupboxContainer,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 7),
                PaddingLeft = UDim.new(0, 7),
                PaddingRight = UDim.new(0, 7),
                PaddingTop = UDim.new(0, 7),
                Parent = DepGroupboxContainer,
            })
        end

        local DepGroupbox = {
            Connections = {},
            Destroyed = false,

            Visible = false,
            Dependencies = {},

            BoxHolder = BoxHolder,
            Holder = DepGroupboxContainer,
            Container = DepGroupboxContainer,

            Tab = Tab,
            Elements = {},
            DependencyBoxes = {},
        }

        function DepGroupbox:Resize()
            DepGroupboxContainer.Size =
                UDim2.new(1, 0, 0, (DepGroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 18)
        end

        function DepGroupbox:Update(CancelSearch)
            for _, Dependency in DepGroupbox.Dependencies do
                local Element = Dependency[1]
                local Value = Dependency[2]

                if Element.Type == "Toggle" and Element.Value ~= Value then
                    DepGroupboxContainer.Visible = false
                    DepGroupbox.Visible = false
                    return
                elseif Element.Type == "Dropdown" then
                    if typeof(Element.Value) == "table" then
                        if not Element.Value[Value] then
                            DepGroupboxContainer.Visible = false
                            DepGroupbox.Visible = false
                            return
                        end
                    else
                        if Element.Value ~= Value then
                            DepGroupboxContainer.Visible = false
                            DepGroupbox.Visible = false
                            return
                        end
                    end
                end
            end

            DepGroupbox.Visible = true
            if not Library.Searching then
                DepGroupboxContainer.Visible = true
                DepGroupbox:Resize()
            elseif not CancelSearch then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function DepGroupbox:SetupDependencies(Dependencies)
            for _, Dependency in Dependencies do
                assert(typeof(Dependency) == "table", "Dependency should be a table.")
                assert(Dependency[1] ~= nil, "Dependency is missing element.")
                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
            end

            DepGroupbox.Dependencies = Dependencies
            DepGroupbox:Update()
        end

        setmetatable(DepGroupbox, BaseGroupbox)

        table.insert(Tab.DependencyGroupboxes, DepGroupbox)
        table.insert(Library.DependencyBoxes, DepGroupbox :: any)

        function DepGroupbox:Destroy()
            DepGroupbox.Destroyed = true

            if DepGroupbox.Connections then
                for _, Connection in DepGroupbox.Connections do
                    Connection:Disconnect()
                end
            end

            for _, Element in DepGroupbox.Elements do
                if Element.Destroy then
                    Element:Destroy()
                end
            end

            for _, SubDepbox in DepGroupbox.DependencyBoxes do
                if SubDepbox.Destroy then
                    SubDepbox:Destroy()
                end
            end

            if DepGroupboxContainer then
                DepGroupboxContainer:Destroy()
            end

            local ElemIdx = table.find(Tab.DependencyGroupboxes, DepGroupbox)
            if ElemIdx then
                table.remove(Tab.DependencyGroupboxes, ElemIdx)
            end

            local LibIdx = table.find(Library.DependencyBoxes, DepGroupbox)
            if LibIdx then
                table.remove(Library.DependencyBoxes, LibIdx)
            end
        end

        return DepGroupbox
    end

    BaseGroupbox.__index = Funcs
    BaseGroupbox.__namecall = function(_, Key, ...)
        return Funcs[Key](...)
    end
end

function Library:SetFont(FontFace: Font | Enum.Font)
    if typeof(FontFace) == "EnumItem" then
        assert(FontFace.EnumType == Enum.Font, "Expected an Enum.Font value")
        FontFace = Font.fromEnum(FontFace :: any)
    end

    assert(typeof(FontFace) == "Font", "Expected a Font or Enum.Font value")
    Library.Scheme.Font = FontFace
    Library:UpdateColorsUsingRegistry()
end

function Library:SetBackgroundImage(Image: string | number)
    assert(
        typeof(Image) == "string" or typeof(Image) == "number",
        "Expected string/number got " .. typeof(Image)
    )

    Library.Scheme.BackgroundImage = Image
    if Library.Window then
        Library.Window:SetBackgroundImage(Image)
    end

    Library:UpdateColorsUsingRegistry()
end

function Library:UpdateNotificationPositions(Snap: boolean?)
    local IsLeft = Library.NotifySide:lower() == "left"
    local XScale = IsLeft and 0 or 1
    local RunningY = 0

    for _, FakeBackground in NotifyOrder do
        local Data = Library.Notifications[FakeBackground]
        if not (Data and FakeBackground.Parent) then
            continue
        end

        local Target = UDim2.new(XScale, 0, 0, RunningY)
        if Snap or not Data.PositionInitialized then
            FakeBackground.Position = Target
            Data.PositionInitialized = true
        elseif FakeBackground.Position ~= Target then
            TweenService:Create(FakeBackground, Library.NotifyTweenInfo, {
                Position = Target,
            }):Play()
        end

        RunningY = RunningY + FakeBackground.AbsoluteSize.Y + 8
    end
end

function Library:SetNotifySide(Side: string)
    assert(typeof(Side) == "string", "Notification side must be a string")

    Side = string.lower(Side)
    assert(Side == "left" or Side == "right", "Notification side must be either 'Left' or 'Right'")
    Library.NotifySide = if Side == "left" then "Left" else "Right"

    local IsLeft = Side == "left"
    if IsLeft then
        NotificationArea.AnchorPoint = Vector2.new(0, 0)
        NotificationArea.Position = UDim2.fromOffset(6, 6)
    else
        NotificationArea.AnchorPoint = Vector2.new(1, 0)
        NotificationArea.Position = UDim2.new(1, -6, 0, 6)
    end

    for FakeBackground in Library.Notifications do
        if not (FakeBackground and FakeBackground.Parent) then
            continue
        end
        FakeBackground.AnchorPoint = if IsLeft then Vector2.new(0, 0) else Vector2.new(1, 0)
    end

    Library:UpdateNotificationPositions(true)
end

function Library:Notify(...)
    local Data = {}
    local Info = select(1, ...)

    if typeof(Info) == "table" then
        Data.Title = tostring(Info.Title)
        Data.TitleColor = Info.TitleColor

        Data.Description = tostring(Info.Description)
        Data.DescriptionColor = Info.DescriptionColor

        Data.Time = Info.Time or 5
        Data.SoundId = Info.SoundId
        Data.Steps = Info.Steps
        Data.Persist = Info.Persist

        Data.Icon = Info.Icon
        Data.BigIcon = Info.BigIcon
        Data.IconColor = Info.IconColor

        Data.Volume = tonumber(Info.Volume) or 3
    else
        Data.Description = tostring(Info)
        Data.Time = select(2, ...) or 5
        Data.SoundId = select(3, ...)
        Data.Volume = select(4, ...) or 3
    end
    Data.Destroyed = false

    local DeletedInstance = false
    local DeleteConnection = nil
    if typeof(Data.Time) == "Instance" then
        DeleteConnection = Data.Time.Destroying:Connect(function()
            DeletedInstance = true

            DeleteConnection:Disconnect()
            DeleteConnection = nil
        end)
    end

    local FakeBackground = New("Frame", {
        AnchorPoint = Library.NotifySide:lower() == "left" and Vector2.new(0, 0)
            or Vector2.new(1, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        Visible = false,
        Parent = NotificationArea,
    })

    local Holder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = "MainColor",
        BackgroundTransparency = Library.GlassEnabled and math.max(0.22, Library.GlassTransparency)
            or 0,
        Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2)
            or UDim2.new(1, 8, 0, -2),
        Size = UDim2.fromScale(1, 1),
        ZIndex = 5,
        Parent = FakeBackground,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Holder,
        })
    )
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = Holder,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8),
        Parent = Holder,
    })
    Library:AddOutline(Holder)
    local NotificationGlassSurface = {
        Instance = Holder,
        OpaqueTransparency = 0,
    }
    table.insert(Library.GlassSurfaces, NotificationGlassSurface)
    RefreshGlassSurface(NotificationGlassSurface)
    local NotificationGlassStroke = New("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = "AccentColor",
        Thickness = 1,
        Transparency = Library.GlassEnabled and math.max(0.2, Library.GlassStrokeTransparency) or 1,
        Parent = Holder,
    })
    table.insert(Library.GlassStrokes, NotificationGlassStroke)

    local ContentContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.fromScale(1, 0),
        Parent = Holder,
    })

    if Data.BigIcon then
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = ContentContainer,
        })
    end

    local BigIconLabel
    if Data.BigIcon then
        local ParsedIcon = Library:GetCustomIcon(Data.BigIcon)
        if ParsedIcon then
            BigIconLabel = New("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(24, 24),
                Image = ParsedIcon.Url,
                ImageColor3 = Data.IconColor or "AccentColor",
                ImageRectOffset = ParsedIcon.ImageRectOffset,
                ImageRectSize = ParsedIcon.ImageRectSize,
                Parent = ContentContainer,
            })
        end
    end

    local TextContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.fromScale(0, 0),
        Parent = ContentContainer,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = TextContainer,
    })

    local TitleContainer
    if Data.Title then
        TitleContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0, 0),
            Parent = TextContainer,
        })
    end

    local IconLabel
    if Data.Icon and TitleContainer then
        local ParsedIcon = Library:GetCustomIcon(Data.Icon)
        if ParsedIcon then
            IconLabel = New("ImageLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 0, 0.5, 1),
                Size = UDim2.fromOffset(15, 15),
                Image = ParsedIcon.Url,
                ImageColor3 = Data.IconColor or "FontColor",
                ImageRectOffset = ParsedIcon.ImageRectOffset,
                ImageRectSize = ParsedIcon.ImageRectSize,
                Parent = TitleContainer,
            })
        end
    end

    local Title
    local Desc
    local TitleX = 0
    local DescX = 0

    local TimerFill

    if Data.Title then
        Title = New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.None,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, (Data.Icon and 21 or 0), 0.5, 0),
            Size = UDim2.fromScale(0, 0),
            Text = Data.Title,
            TextColor3 = Data.TitleColor or "FontColor",
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextWrapped = true,
            Parent = TitleContainer,
        })
    end

    if Data.Description then
        Desc = New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.None,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0, 0),
            Text = Data.Description,
            TextColor3 = Data.DescriptionColor or "FontColor",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = TextContainer,
        })
    end

    function Data:Resize()
        local ExtraWidth = BigIconLabel and 32 or 0
        local IconWidth = IconLabel and 21 or 0

        if Title then
            local X, Y = Library:GetTextBounds(
                Title.Text,
                Title.FontFace,
                Title.TextSize,
                (NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth - IconWidth
            )
            Title.Size = UDim2.fromOffset(X, Y)
            TitleX = X + IconWidth
            TitleContainer.Size = UDim2.fromOffset(TitleX, math.max(Y, IconLabel and 16 or 0))
        end

        if Desc then
            local X, Y = Library:GetTextBounds(
                Desc.Text,
                Desc.FontFace,
                Desc.TextSize,
                (NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth
            )
            Desc.Size = UDim2.fromOffset(X, Y)
            DescX = X
        end

        FakeBackground.Size = UDim2.fromOffset(math.max(TitleX, DescX) + 24 + ExtraWidth, 0)

        if Library.Notifications[FakeBackground] then
            Library:UpdateNotificationPositions()
        end
    end

    function Data:ChangeTitle(Text)
        if Title then
            Data.Title = tostring(Text)
            Title.Text = Data.Title
            Data:Resize()
        end
    end

    function Data:ChangeDescription(Text)
        if Desc then
            Data.Description = tostring(Text)
            Desc.Text = Data.Description
            Data:Resize()
        end
    end

    function Data:ChangeStep(NewStep)
        if TimerFill and Data.Steps then
            NewStep = math.clamp(NewStep or 0, 0, Data.Steps)
            TimerFill.Size = UDim2.fromScale(NewStep / Data.Steps, 1)
        end
    end

    function Data:Destroy()
        Data.Destroyed = true

        if typeof(Data.Time) == "Instance" then
            pcall(Data.Time.Destroy, Data.Time)
        end

        if DeleteConnection then
            DeleteConnection:Disconnect()
        end

        if FakeBackground then
            local Idx = table.find(NotifyOrder, FakeBackground)
            if Idx then
                table.remove(NotifyOrder, Idx)
            end
        end

        Library:UpdateNotificationPositions()

        TweenService
            :Create(Holder, Library.NotifyTweenInfo, {
                Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2)
                    or UDim2.new(1, 8, 0, -2),
            })
            :Play()

        task.delay(Library.NotifyTweenInfo.Time, function()
            Library.Notifications[FakeBackground] = nil
            FakeBackground:Destroy()
        end)
    end

    Data:Resize()

    local TimerHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 7),
        Visible = (Data.Persist ~= true and typeof(Data.Time) ~= "Instance")
            or typeof(Data.Steps) == "number",
        Parent = Holder,
    })
    local TimerBar = New("Frame", {
        BackgroundColor3 = "BackgroundColor",
        BorderColor3 = "OutlineColor",
        BorderSizePixel = 1,
        Position = UDim2.fromOffset(0, 3),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = TimerHolder,
    })
    TimerFill = New("Frame", {
        BackgroundColor3 = "AccentColor",
        Size = UDim2.fromScale(1, 1),
        Parent = TimerBar,
    })

    if typeof(Data.Time) == "Instance" then
        TimerFill.Size = UDim2.fromScale(0, 1)
    end
    if Data.SoundId then
        local SoundId = Data.SoundId
        if typeof(SoundId) == "number" then
            SoundId = string.format("rbxassetid://%d", SoundId)
        end

        New("Sound", {
            SoundId = SoundId,
            Volume = tonumber(Data.Volume) or 3,
            PlayOnRemove = true,
            Parent = SoundService,
        }):Destroy()
    end

    Data.Holder = Holder

    table.insert(NotifyOrder, FakeBackground)
    Library.Notifications[FakeBackground] = Data

    Library:UpdateNotificationPositions()

    FakeBackground.Visible = true
    TweenService:Create(Holder, Library.NotifyTweenInfo, {
        Position = UDim2.fromOffset(0, 0),
    }):Play()

    task.delay(Library.NotifyTweenInfo.Time, function()
        if Data.Persist then
            return
        elseif typeof(Data.Time) == "Instance" then
            repeat
                task.wait()
            until DeletedInstance or Data.Destroyed
        else
            TweenService
                :Create(
                    TimerFill,
                    TweenInfo.new(Data.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
                    {
                        Size = UDim2.fromScale(0, 1),
                    }
                )
                :Play()
            task.wait(Data.Time)
        end

        if not Data.Destroyed then
            Data:Destroy()
        end
    end)

    return Data
end

local function AddGlassPressFeedback(Button: GuiButton)
    if not Library.IsMobile then
        return
    end

    local PressScale = New("UIScale", {
        Parent = Button,
    })
    local PressTween

    local function SetPressed(Pressed: boolean)
        if PressTween then
            StopTween(PressTween, true)
        end
        PressTween = TweenService:Create(
            PressScale,
            TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Scale = Pressed and 0.94 or 1,
            }
        )
        PressTween:Play()
    end

    Button.InputBegan:Connect(function(Input)
        if IsClickInput(Input, true) then
            SetPressed(true)
        end
    end)
    Button.InputEnded:Connect(function(Input)
        if IsClickInput(Input, true) then
            SetPressed(false)
        end
    end)
    Button.MouseLeave:Connect(function()
        SetPressed(false)
    end)
end

function Library:CreateWindow(WindowInfo)
    WindowInfo = Library:Validate(WindowInfo, Templates.Window)
    local ViewportSize: Vector2 = workspace.CurrentCamera.ViewportSize
    if RunService:IsStudio() and ViewportSize.X <= 5 and ViewportSize.Y <= 5 then
        repeat
            ViewportSize = workspace.CurrentCamera.ViewportSize
            task.wait()
        until ViewportSize.X > 5 and ViewportSize.Y > 5
    end

    local MaxX = ViewportSize.X - 64
    local MaxY = ViewportSize.Y - 64

    Library.OriginalMinSize = Vector2.new(
        math.min(Library.OriginalMinSize.X, MaxX),
        math.min(Library.OriginalMinSize.Y, MaxY)
    )
    Library.MinSize = Library.OriginalMinSize

    WindowInfo.Size = UDim2.fromOffset(
        math.clamp(WindowInfo.Size.X.Offset, Library.MinSize.X, MaxX),
        math.clamp(WindowInfo.Size.Y.Offset, Library.MinSize.Y, MaxY)
    )
    if typeof(WindowInfo.Font) == "EnumItem" then
        WindowInfo.Font = Font.fromEnum(WindowInfo.Font :: any)
    end
    WindowInfo.CornerRadius = math.min(WindowInfo.CornerRadius, 20)
    WindowInfo.Glass = WindowInfo.Glass ~= false
    WindowInfo.GlassTransparency =
        math.clamp(tonumber(WindowInfo.GlassTransparency) or 0.16, 0, 0.85)
    WindowInfo.GlassStrokeTransparency =
        math.clamp(tonumber(WindowInfo.GlassStrokeTransparency) or 0.25, 0, 1)
    WindowInfo.GlassPreset = tostring(WindowInfo.GlassPreset or "Custom")
    WindowInfo.GlassSheen = WindowInfo.GlassSheen ~= false
    WindowInfo.GlassSheenSpeed = math.clamp(tonumber(WindowInfo.GlassSheenSpeed) or 7, 2, 20)
    WindowInfo.GlassBackgroundMotion = WindowInfo.GlassBackgroundMotion ~= false
    WindowInfo.GlassBackgroundMotionSpeed =
        math.clamp(tonumber(WindowInfo.GlassBackgroundMotionSpeed) or 14, 4, 30)
    WindowInfo.GlassBlur = WindowInfo.GlassBlur == true
    WindowInfo.GlassBlurSize = math.clamp(tonumber(WindowInfo.GlassBlurSize) or 8, 0, 24)
    WindowInfo.MobileScale = math.clamp(WindowInfo.MobileScale, 0.35, 1)
    WindowInfo.MobileViewportPadding = math.max(0, WindowInfo.MobileViewportPadding)
    WindowInfo.EnableTabSwipeNavigation = WindowInfo.EnableTabSwipeNavigation ~= false
    WindowInfo.TabSwipeNavigationThreshold =
        math.max(24, tonumber(WindowInfo.TabSwipeNavigationThreshold) or 60)
    local RequestedMobileLayout = string.lower(tostring(WindowInfo.MobileLayout or "Balanced"))
    WindowInfo.MobileLayout = if RequestedMobileLayout == "compact"
        then "Compact"
        elseif RequestedMobileLayout == "expanded" then "Expanded"
        else "Balanced"

    --// Old Naming \\--
    if WindowInfo.Compact ~= nil then
        WindowInfo.SidebarCompacted = WindowInfo.Compact
    end
    if WindowInfo.SidebarMinWidth ~= nil then
        WindowInfo.MinSidebarWidth = WindowInfo.SidebarMinWidth
    end
    WindowInfo.MinSidebarWidth = math.max(64, WindowInfo.MinSidebarWidth)
    WindowInfo.SidebarCompactWidth = math.max(48, WindowInfo.SidebarCompactWidth)
    WindowInfo.SidebarCollapseThreshold = math.clamp(WindowInfo.SidebarCollapseThreshold, 0.1, 0.9)
    WindowInfo.CompactWidthActivation = math.max(48, WindowInfo.CompactWidthActivation)

    Library.CornerRadius = WindowInfo.CornerRadius
    Library.GlassEnabled = WindowInfo.Glass
    Library.GlassTransparency = WindowInfo.GlassTransparency
    Library.GlassStrokeTransparency = WindowInfo.GlassStrokeTransparency
    Library:SetNotifySide(WindowInfo.NotifySide)
    Library.ShowCustomCursor = WindowInfo.ShowCustomCursor
    Library:SetFont(WindowInfo.Font)
    Library.ToggleKeybind = WindowInfo.ToggleKeybind
    Library.GlobalSearch = WindowInfo.GlobalSearch

    ApplyAnimationPreferences(WindowInfo.Animations)
    Library.TabTransitionInfo = TweenInfo.new(
        math.max(0, WindowInfo.TabTransitionTime or 0.22),
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    Library.TabSwipeOffset = math.max(1, WindowInfo.TabSwipeOffset or 26)
    Library.TabSwipeFrom = WindowInfo.TabSwipeFrom or "right"

    local IsDefaultSearchbarSize = WindowInfo.SearchbarSize == UDim2.fromScale(1, 1)
    local MainFrame
    local DividerLine
    local TitleHolder
    local WindowTitle
    local WindowIcon
    local RightWrapper
    local SearchBox
    local CurrentTabInfo
    local CurrentTabLabel
    local CurrentTabDescription
    local ResizeButton
    local Tabs
    local Container
    local BackgroundImage
    local BottomBackground
    local FooterLabel
    local TopBar
    local HeaderButtonCount = 0
    local MobileControlHolder
    local UpdateMobileLockButton
    local SetMobileActionMenuVisible
    local MainWindowScale
    local GlassBlurEffect
    local GlassGradient
    local GlassGradientTween
    local GlassBackdrop
    local GlassReflectionA
    local GlassReflectionB
    local GlassBackdropTweens = {}
    local RightWrapperHeightOffset = Library.IsMobile and -4 or -16

    local MobileCompacted = Library.IsMobile
        and (
            WindowInfo.MobileLayout == "Compact"
            or (WindowInfo.MobileLayout == "Balanced" and WindowInfo.MobileStartCompacted == true)
        )
    local InitialLeftWidth = if MobileCompacted
        then WindowInfo.SidebarCompactWidth
        else math.ceil(WindowInfo.Size.X.Offset * 0.3)
    local IsCompact = WindowInfo.SidebarCompacted or MobileCompacted
    local LastExpandedWidth = if MobileCompacted
        then math.ceil(WindowInfo.Size.X.Offset * 0.3)
        else InitialLeftWidth

    local function AddGlassSurface(Instance: GuiObject, OpaqueTransparency: number)
        local Surface = {
            Instance = Instance,
            OpaqueTransparency = OpaqueTransparency,
        }
        table.insert(Library.GlassSurfaces, Surface)
        RefreshGlassSurface(Surface)
    end

    do
        Library.KeybindFrame, Library.KeybindContainer = Library:AddDraggableMenu("Keybinds")
        Library.KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)
        Library.KeybindFrame.Position = UDim2.new(0, 6, 0.5, 0)
        Library.KeybindFrame.Visible = false

        if WindowInfo.GlassBlur then
            GlassBlurEffect = Instance.new("BlurEffect")
            GlassBlurEffect.Name = "CyanLiquidGlassBlur"
            GlassBlurEffect.Size = WindowInfo.GlassBlurSize
            GlassBlurEffect.Enabled = false
            GlassBlurEffect.Parent = Lighting
            table.insert(Library.GlassBlurEffects, GlassBlurEffect)
        end

        MainFrame = New("TextButton", {
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
            end,
            Name = "Main",
            Text = "",
            BackgroundTransparency = WindowInfo.Glass and WindowInfo.GlassTransparency or 0,
            Position = WindowInfo.Position,
            Size = WindowInfo.Size,
            Visible = false,
            Parent = ScreenGui,
        })
        AddGlassSurface(MainFrame, 0)
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = MainFrame,
            })
        )
        MainWindowScale = New("UIScale", {
            Parent = MainFrame,
        })
        if not Library.IsMobile then
            table.insert(Library.Scales, MainWindowScale)
        end
        Library:AddOutline(MainFrame)

        GlassGradient = New("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 46, 66)),
                ColorSequenceKeypoint.new(0.52, Color3.fromRGB(12, 76, 94)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 26, 43)),
            }),
            Rotation = 35,
            Enabled = Library.GlassEnabled,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.12),
                NumberSequenceKeypoint.new(0.5, 0.36),
                NumberSequenceKeypoint.new(1, 0.16),
            }),
            Parent = MainFrame,
        })
        table.insert(Library.GlassGradients, GlassGradient)

        local GlassStroke = New("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = "AccentColor",
            Thickness = 1.25,
            Transparency = Library.GlassEnabled and Library.GlassStrokeTransparency or 1,
            Parent = MainFrame,
        })
        table.insert(Library.GlassStrokes, GlassStroke)

        GlassBackdrop = New("Frame", {
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Size = UDim2.fromScale(1, 1),
            Visible = Library.GlassEnabled,
            ZIndex = 1,
            Parent = MainFrame,
        })

        local function CreateGlassReflection(
            Position: UDim2,
            Size: UDim2,
            Color: Color3,
            Transparency: number
        )
            local Reflection = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color,
                BackgroundTransparency = Transparency,
                Position = Position,
                Size = Size,
                ZIndex = 1,
                Parent = GlassBackdrop,
            })
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = Reflection,
            })
            local ReflectionGradient = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color),
                }),
                Rotation = 35,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.72),
                    NumberSequenceKeypoint.new(1, 1),
                }),
                Enabled = Library.GlassEnabled,
                Parent = Reflection,
            })
            table.insert(Library.GlassGradients, ReflectionGradient)
            return Reflection
        end

        GlassReflectionA = CreateGlassReflection(
            UDim2.fromScale(-0.12, -0.08),
            UDim2.fromScale(0.72, 0.58),
            Color3.fromRGB(34, 211, 238),
            0.82
        )
        GlassReflectionB = CreateGlassReflection(
            UDim2.fromScale(1.08, 0.88),
            UDim2.fromScale(0.62, 0.48),
            Color3.fromRGB(114, 244, 255),
            0.88
        )

        Library:MakeLine(MainFrame, {
            Position = UDim2.fromOffset(0, 48),
            Size = UDim2.new(1, 0, 0, 1),
        })

        DividerLine = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            Position = UDim2.fromOffset(InitialLeftWidth, 0),
            Size = UDim2.new(0, 1, 1, -21),
            Parent = MainFrame,
            ZIndex = 2,
        })

        local BackgroundIcon = Library:GetCustomIcon(WindowInfo.BackgroundImage)
        BackgroundImage = New("ImageLabel", {
            Image = BackgroundIcon and BackgroundIcon.Url or "",
            ImageRectOffset = BackgroundIcon and BackgroundIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = BackgroundIcon and BackgroundIcon.ImageRectSize or Vector2.zero,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            ScaleType = Enum.ScaleType.Stretch,
            ZIndex = 999,
            BackgroundTransparency = 1,
            ImageTransparency = 0.75,
            Visible = BackgroundIcon ~= nil,
            Parent = MainFrame,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = BackgroundImage,
            })
        )

        if WindowInfo.Center then
            MainFrame.Position =
                UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)
        end

        --// Top Bar \\-
        TopBar = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 48),
            Parent = MainFrame,
        })
        Library:MakeDraggable(MainFrame, TopBar, false, true)

        --// Title \\--
        TitleHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, InitialLeftWidth, 1, 0),
            Parent = TopBar,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            Parent = TitleHolder,
        })

        if WindowInfo.Icon then
            local Icon = Library:GetCustomIcon(WindowInfo.Icon)
            WindowIcon = New("ImageLabel", {
                Image = Icon.Url,
                ImageRectOffset = Icon.ImageRectOffset,
                ImageRectSize = Icon.ImageRectSize,
                Size = WindowInfo.IconSize,
                Parent = TitleHolder,
            })
        else
            WindowIcon = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = WindowInfo.IconSize,
                Text = WindowInfo.Title:sub(1, 1),
                TextScaled = true,
                Visible = false,
                Parent = TitleHolder,
            })
        end

        local X = Library:GetTextBounds(
            WindowInfo.Title,
            Library.Scheme.Font,
            20,
            TitleHolder.AbsoluteSize.X
                - (WindowInfo.Icon and WindowInfo.IconSize.X.Offset + 6 or 0)
                - 12
        )
        WindowTitle = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, X, 1, 0),
            Text = WindowInfo.Title,
            TextSize = 20,
            Parent = TitleHolder,
        })

        --// Top Right Bar \\--
        RightWrapper = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -49, 0.5, 0),
            Size = UDim2.new(1, -InitialLeftWidth - 57 - 1, 1, RightWrapperHeightOffset),
            Parent = TopBar,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8),
            Parent = RightWrapper,
        })

        CurrentTabInfo = New("Frame", {
            LayoutOrder = 1,
            Size = UDim2.fromScale(WindowInfo.DisableSearch and 1 or 0.5, 1),
            Visible = false,
            BackgroundTransparency = 1,
            Parent = RightWrapper,
        })

        New("UIFlexItem", {
            FlexMode = Enum.UIFlexMode.Grow,
            Parent = CurrentTabInfo,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = CurrentTabInfo,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            Parent = CurrentTabInfo,
        })

        CurrentTabLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = CurrentTabInfo,
        })

        CurrentTabDescription = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            TextWrapped = true,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.5,
            Parent = CurrentTabInfo,
        })

        SearchBox = New("TextBox", {
            LayoutOrder = 100,
            BackgroundColor3 = "MainColor",
            BackgroundTransparency = Library.GlassEnabled
                    and math.max(0.28, Library.GlassTransparency)
                or 0,
            PlaceholderText = "Search",
            Size = WindowInfo.SearchbarSize,
            TextScaled = true,
            Visible = not (WindowInfo.DisableSearch or false),
            Parent = RightWrapper,
        })
        AddGlassSurface(SearchBox, 0)
        New("UIFlexItem", {
            FlexMode = Enum.UIFlexMode.Shrink,
            Parent = SearchBox,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = SearchBox,
            })
        )
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            Parent = SearchBox,
        })
        New("UIStroke", {
            Color = "OutlineColor",
            Parent = SearchBox,
        })

        local SearchIcon = Library:GetIcon("search")
        if SearchIcon then
            New("ImageLabel", {
                Image = SearchIcon.Url,
                ImageColor3 = "FontColor",
                ImageRectOffset = SearchIcon.ImageRectOffset,
                ImageRectSize = SearchIcon.ImageRectSize,
                ImageTransparency = 0.5,
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = SearchBox,
            })
        end

        if MoveIcon then
            New("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Image = MoveIcon.Url,
                ImageColor3 = "OutlineColor",
                ImageRectOffset = MoveIcon.ImageRectOffset,
                ImageRectSize = MoveIcon.ImageRectSize,
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(28, 28),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = TopBar,
            })
        end

        --// Bottom Bar \\--
        BottomBackground = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
            end,
            BackgroundTransparency = Library.GlassEnabled
                    and math.max(0.22, Library.GlassTransparency)
                or 0,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 20 + WindowInfo.CornerRadius),
            Parent = MainFrame,
        })
        AddGlassSurface(BottomBackground, 0)
        Library:MakeLine(MainFrame, {
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 0, 1, -20),
            Size = UDim2.new(1, 0, 0, 1),
        })

        local BottomBar = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 20),
            Parent = MainFrame,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = BottomBackground,
            })
        )

        --// Footer \\-
        FooterLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = WindowInfo.Footer,
            TextSize = 14,
            TextTransparency = 0.5,
            Parent = BottomBar,
        })

        --// Resize Button \\--
        if WindowInfo.Resizable then
            ResizeButton = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -WindowInfo.CornerRadius / 4, 0, 0),
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Text = "",
                Parent = BottomBar,
            })

            Library:MakeResizable(MainFrame, ResizeButton, function()
                for _, Tab in Library.Tabs do
                    Tab:Resize(true)
                end
            end)
        end

        New("ImageLabel", {
            Image = ResizeIcon and ResizeIcon.Url or "",
            ImageColor3 = "FontColor",
            ImageRectOffset = ResizeIcon and ResizeIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = ResizeIcon and ResizeIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 0.5,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.new(1, -4, 1, -4),
            Parent = ResizeButton,
        })

        --// Tabs \\--
        Tabs = New("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = "BackgroundColor",
            BackgroundTransparency = Library.GlassEnabled
                    and math.max(0.08, Library.GlassTransparency)
                or 0,
            CanvasSize = UDim2.fromScale(0, 0),
            Position = UDim2.fromOffset(0, 49),
            ScrollBarThickness = 0,
            Size = UDim2.new(0, InitialLeftWidth, 1, -70),
            Parent = MainFrame,
        })
        AddGlassSurface(Tabs, 0)
        New("UIListLayout", {
            Parent = Tabs,
        })

        --// Container \\--
        Container = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 1)
            end,
            BackgroundTransparency = Library.GlassEnabled and Library.GlassTransparency or 0,
            ClipsDescendants = true,
            Name = "Container",
            Position = UDim2.new(1, 0, 0, 49),
            Size = UDim2.new(1, -InitialLeftWidth - 1, 1, -70),
            Parent = MainFrame,
        })
        AddGlassSurface(Container, 0)
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 0),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 0),
            Parent = Container,
        })

        Library.WindowContainer = Container
    end

    --// Window Table \\--
    local Window = {}
    local Fading = false

    local function SetUICorner(UICorner, Corner, HalfCurrent, HalfValue, Value)
        local Current = UICorner[Corner]
        if Current.Offset == 0 and Current.Scale == 0 then
            return
        end

        UICorner[Corner] = Current.Offset == HalfCurrent and HalfValue or Value
    end

    function Window:ChangeTitle(title)
        assert(typeof(title) == "string", "Expected string for title got: " .. typeof(title))

        WindowTitle.Text = title
        WindowInfo.Title = title
    end

    function Window:SetBackgroundImage(Image: string)
        local ValidIcon = false

        if typeof(Image) == "string" then
            local BackgroundIcon = Library:GetCustomIcon(Image)

            if BackgroundIcon then
                ValidIcon = true

                BackgroundImage.Image = BackgroundIcon.Url
                BackgroundImage.ImageRectOffset = BackgroundIcon.ImageRectOffset
                BackgroundImage.ImageRectSize = BackgroundIcon.ImageRectSize
                BackgroundImage.Visible = true
            elseif Image:match("http://") or Image:match("https://") then
                local RawFileName = Image:match("(.+)%..+$")
                local _, Domain = Image:match("^(https?://)([^/]+)")

                if RawFileName and Domain then
                    local Extention = string.sub(Image, #RawFileName + 1, #Image)
                    local FileNamePos = RawFileName:gsub("\\", "/"):find("/[^/]*$")
                    local FileName = FileNamePos and Image:sub(FileNamePos + 1) or nil

                    if FileName then
                        ValidIcon = true

                        local AssetName = Domain .. FileName
                        if #AssetName > 255 then
                            local NewLength = 255 - #Domain - #Extention
                            if NewLength < 0 then
                                AssetName = Domain .. Extention
                            else
                                AssetName = Domain
                                    .. string.sub(
                                        FileName:sub(1, #FileName - #Extention),
                                        1,
                                        NewLength
                                    )
                                    .. Extention
                            end
                        end

                        if CustomImageManagerAssets[FileName] == nil then
                            CustomImageManager.AddAsset(FileName, 0, Image)
                        else
                            CustomImageManager.DownloadAsset(FileName, true)
                        end

                        BackgroundImage.Image = CustomImageManager.GetAsset(FileName)
                        BackgroundImage.ImageRectOffset = Vector2.zero
                        BackgroundImage.ImageRectSize = Vector2.zero
                        BackgroundImage.Visible = true
                    end
                end
            end
        end

        if not ValidIcon then
            BackgroundImage.Image = ""
            BackgroundImage.ImageRectOffset = Vector2.zero
            BackgroundImage.ImageRectSize = Vector2.zero
            BackgroundImage.Visible = false
        end

        WindowInfo.BackgroundImage = Image
    end

    function Window:SetFooter(Footer: string)
        assert(typeof(Footer) == "string", "Expected string for footer got: " .. typeof(Footer))

        FooterLabel.Text = Footer
        WindowInfo.Footer = Footer
    end

    function Window:ClearSearch()
        if SearchBox.Text ~= "" then
            SearchBox.Text = ""
        else
            Library:UpdateSearch("")
        end
        SearchBox:ReleaseFocus()
    end

    function Window:FocusSearch(): boolean
        if not (Library.Toggled and SearchBox.Visible) then
            return false
        end

        SearchBox:CaptureFocus()
        return true
    end

    function Window:AddHeaderButton(
        Info: {
            Text: string,
            Tooltip: string?,
            Callback: (() -> ())?,
            Disabled: boolean?,
            Visible: boolean?,
        } | string,
        Callback: (() -> ())?
    )
        if typeof(Info) == "string" then
            Info = {
                Text = Info,
                Callback = Callback,
            }
        end
        assert(
            typeof(Info) == "table" and typeof(Info.Text) == "string",
            "Header button requires text"
        )

        HeaderButtonCount += 1
        local HeaderButton = {
            Text = Info.Text,
            Disabled = Info.Disabled == true,
            Visible = Info.Visible ~= false,
            Destroyed = false,
        }
        local Button = New("TextButton", {
            Active = not HeaderButton.Disabled,
            BackgroundColor3 = HeaderButton.Disabled and "BackgroundColor" or "MainColor",
            LayoutOrder = 10 + HeaderButtonCount,
            Size = UDim2.fromOffset(Library.IsMobile and 36 or 28, Library.IsMobile and 40 or 32),
            Text = HeaderButton.Text,
            TextSize = Library.IsMobile and 16 or 14,
            TextTransparency = HeaderButton.Disabled and 0.55 or 0.15,
            Visible = HeaderButton.Visible,
            Parent = RightWrapper,
        })
        Library:AddOutline(Button)
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Button,
            })
        )
        AddGlassPressFeedback(Button)

        local Tooltip
        if typeof(Info.Tooltip) == "string" then
            Tooltip = Library:AddTooltip(Info.Tooltip, "", Button)
            Tooltip.Disabled = HeaderButton.Disabled
        end

        function HeaderButton:SetText(Text: string)
            assert(typeof(Text) == "string", "Header button text must be a string")
            HeaderButton.Text = Text
            Button.Text = Text
        end

        function HeaderButton:SetDisabled(Disabled: boolean)
            HeaderButton.Disabled = Disabled == true
            Button.Active = not HeaderButton.Disabled
            Button.BackgroundColor3 = HeaderButton.Disabled and Library.Scheme.BackgroundColor
                or Library.Scheme.MainColor
            Button.TextTransparency = HeaderButton.Disabled and 0.55 or 0.15
            if Tooltip then
                Tooltip.Disabled = HeaderButton.Disabled
            end
        end

        function HeaderButton:SetVisible(Visible: boolean)
            HeaderButton.Visible = Visible == true
            Button.Visible = HeaderButton.Visible
        end

        -- Activated supports mouse, touch, and gamepad input, unlike mouse-only click handlers.
        local Connection = Library:GiveSignal(Button.Activated:Connect(function()
            if not HeaderButton.Disabled and not HeaderButton.Destroyed then
                Library:SafeCallback(Info.Callback)
            end
        end))

        function HeaderButton:Destroy()
            if HeaderButton.Destroyed then
                return
            end
            HeaderButton.Destroyed = true
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
            if Tooltip then
                Tooltip:Destroy()
            end
            Button:Destroy()
        end

        HeaderButton.Button = Button
        return HeaderButton
    end

    function Window:SelectTab(Name: string): boolean
        assert(typeof(Name) == "string", "Tab name must be a string")
        local Tab = Library.Tabs[Name]
        if not Tab or typeof(Tab.Show) ~= "function" then
            return false
        end

        Tab:Show()
        return true
    end

    function Window:GetActiveTab()
        return Library.ActiveTab
    end

    function Window:GetTabs(VisibleOnly: boolean?)
        local Result = {}
        for _, Tab in Library.TabOrder do
            if Tab and (VisibleOnly ~= true or not Tab.Button or Tab.Button.Visible) then
                table.insert(Result, Tab)
            end
        end
        return Result
    end

    local function CycleTab(Direction: number): boolean
        local TabsInOrder = Window:GetTabs(true)
        if #TabsInOrder == 0 then
            return false
        end

        local CurrentIndex = table.find(TabsInOrder, Library.ActiveTab)
        local NextIndex = if CurrentIndex
            then ((CurrentIndex - 1 + Direction) % #TabsInOrder) + 1
            else 1
        local NextTab = TabsInOrder[NextIndex]
        if NextTab and typeof(NextTab.Show) == "function" then
            NextTab:Show()
            return true
        end

        return false
    end

    function Window:NextTab(): boolean
        return CycleTab(1)
    end

    function Window:PreviousTab(): boolean
        return CycleTab(-1)
    end

    function Window:ToggleSidebar()
        Window:SetCompact(not Window:IsSidebarCompacted())
    end

    function Window:GetPosition(): UDim2
        return MainFrame.Position
    end

    function Window:SetPosition(Position: UDim2)
        assert(typeof(Position) == "UDim2", "Menu position must be a UDim2")
        MainFrame.Position = Position
        WindowInfo.Position = Position
    end

    function Window:RefreshMobileLayout(): number
        if not Library.IsMobile or not MainWindowScale then
            return MainWindowScale and MainWindowScale.Scale or 1
        end

        local Camera = workspace.CurrentCamera
        if not Camera then
            return MainWindowScale.Scale
        end

        local Viewport = Camera.ViewportSize
        local SafeTopLeft, SafeBottomRight = GetSafeAreaInsets()
        local Padding = WindowInfo.MobileViewportPadding
        local AvailableWidth =
            math.max(1, Viewport.X - SafeTopLeft.X - SafeBottomRight.X - Padding * 2)
        local AvailableHeight =
            math.max(1, Viewport.Y - SafeTopLeft.Y - SafeBottomRight.Y - Padding * 2)
        local FitScale = math.min(
            AvailableWidth / MainFrame.Size.X.Offset,
            AvailableHeight / MainFrame.Size.Y.Offset,
            WindowInfo.MobileScale
        )

        MainWindowScale.Scale = math.clamp(FitScale * Library.DPIScale, 0.35, 1)
        if WindowInfo.Center then
            local ScaledWidth = MainFrame.Size.X.Offset * MainWindowScale.Scale
            local ScaledHeight = MainFrame.Size.Y.Offset * MainWindowScale.Scale
            MainFrame.Position = UDim2.fromOffset(
                SafeTopLeft.X + Padding + (AvailableWidth - ScaledWidth) / 2,
                SafeTopLeft.Y + Padding + (AvailableHeight - ScaledHeight) / 2
            )
        end

        return MainWindowScale.Scale
    end

    function Window:GetMobileLayout(): string
        return WindowInfo.MobileLayout
    end

    function Window:SetMobileLayout(Layout: string): boolean
        assert(typeof(Layout) == "string", "Mobile layout must be a string")
        Layout = string.lower(Layout)
        assert(
            Layout == "compact" or Layout == "balanced" or Layout == "expanded",
            "Invalid mobile layout"
        )

        if not Library.IsMobile then
            return false
        end

        if Layout == "compact" then
            WindowInfo.MobileLayout = "Compact"
            WindowInfo.MobileScale = 0.8
            WindowInfo.MobileViewportPadding = 16
            WindowInfo.MobileStartCompacted = true
            Window:SetCompact(true)
        elseif Layout == "expanded" then
            WindowInfo.MobileLayout = "Expanded"
            WindowInfo.MobileScale = 1
            WindowInfo.MobileViewportPadding = 8
            WindowInfo.MobileStartCompacted = false
            Window:SetCompact(false)
        else
            WindowInfo.MobileLayout = "Balanced"
            WindowInfo.MobileScale = 0.9
            WindowInfo.MobileViewportPadding = 12
            WindowInfo.MobileStartCompacted = true
            Window:SetCompact(true)
        end

        Window:RefreshMobileLayout()
        return true
    end

    function Window:SetTabSwipeNavigation(Enabled: boolean, Threshold: number?)
        assert(typeof(Enabled) == "boolean", "Tab swipe navigation must be a boolean")
        WindowInfo.EnableTabSwipeNavigation = Enabled
        if Threshold ~= nil then
            assert(
                typeof(Threshold) == "number" and Threshold == Threshold,
                "Tab swipe threshold must be a number"
            )
            WindowInfo.TabSwipeNavigationThreshold = math.max(24, Threshold)
        end
    end

    function Window:GetTabSwipeNavigation(): (boolean, number)
        return WindowInfo.EnableTabSwipeNavigation, WindowInfo.TabSwipeNavigationThreshold
    end

    function Window:Center()
        if Library.IsMobile then
            Window:RefreshMobileLayout()
            return
        end

        local Scale = MainWindowScale and MainWindowScale.Scale or 1
        Window:SetPosition(
            UDim2.new(
                0.5,
                -(MainFrame.Size.X.Offset * Scale) / 2,
                0.5,
                -(MainFrame.Size.Y.Offset * Scale) / 2
            )
        )
    end

    function Window:ResetPosition()
        if WindowInfo.Center then
            Window:Center()
        else
            Window:SetPosition(WindowInfo.Position)
        end
    end

    function Window:GetSearchText(): string
        return SearchBox.Text
    end

    function Window:IsSearchVisible(): boolean
        return SearchBox.Visible
    end

    function Window:SetSearchPlaceholder(Text: string)
        assert(typeof(Text) == "string", "Search placeholder must be a string")
        SearchBox.PlaceholderText = Text
    end

    function Window:SetSearchVisible(Visible: boolean)
        assert(typeof(Visible) == "boolean", "Search visibility must be a boolean")
        SearchBox.Visible = Visible
        CurrentTabInfo.Size = UDim2.fromScale(Visible and 0.5 or 1, 1)
        WindowInfo.DisableSearch = not Visible

        if not Visible then
            Window:ClearSearch()
        end
    end

    local GlassGradientProfiles = {
        Liquid = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 46, 66)),
            ColorSequenceKeypoint.new(0.52, Color3.fromRGB(12, 76, 94)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 26, 43)),
        }),
        Crystal = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(104, 232, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(29, 148, 176)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 62, 84)),
        }),
        Frosted = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(53, 90, 110)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(89, 127, 145)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 68, 86)),
        }),
        Ocean = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 73, 132)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 153, 190)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 42, 92)),
        }),
        Aurora = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(13, 125, 145)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(47, 183, 152)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(84, 75, 161)),
        }),
        Midnight = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 22, 48)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 47, 82)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 12, 30)),
        }),
    }

    local function ApplyGlassGradientProfile(Preset: string)
        if GlassGradient and GlassGradientProfiles[Preset] then
            GlassGradient.Color = GlassGradientProfiles[Preset]
        end
    end

    local function UpdateGlassSheen()
        if GlassGradientTween then
            StopTween(GlassGradientTween, true)
            GlassGradientTween = nil
        end
        if not (GlassGradient and Library.GlassEnabled and WindowInfo.GlassSheen) then
            if GlassGradient then
                GlassGradient.Offset = Vector2.zero
            end
            return
        end

        GlassGradient.Offset = Vector2.new(-0.08, 0)
        GlassGradientTween = TweenService:Create(
            GlassGradient,
            TweenInfo.new(
                WindowInfo.GlassSheenSpeed,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut,
                -1,
                true
            ),
            { Offset = Vector2.new(0.08, 0) }
        )
        GlassGradientTween:Play()
    end

    local function UpdateGlassBackdropMotion()
        for Index = #GlassBackdropTweens, 1, -1 do
            StopTween(GlassBackdropTweens[Index], true)
            table.remove(GlassBackdropTweens, Index)
        end

        if GlassBackdrop then
            GlassBackdrop.Visible = Library.GlassEnabled
        end
        if not (GlassBackdrop and Library.GlassEnabled and WindowInfo.GlassBackgroundMotion) then
            return
        end

        local TweenInfo = TweenInfo.new(
            WindowInfo.GlassBackgroundMotionSpeed,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        )
        local ReflectionATween = TweenService:Create(GlassReflectionA, TweenInfo, {
            Position = UDim2.fromScale(0.18, 0.12),
        })
        local ReflectionBTween = TweenService:Create(GlassReflectionB, TweenInfo, {
            Position = UDim2.fromScale(0.76, 0.68),
        })
        table.insert(GlassBackdropTweens, ReflectionATween)
        table.insert(GlassBackdropTweens, ReflectionBTween)
        ReflectionATween:Play()
        ReflectionBTween:Play()
    end

    function Window:SetGlass(Enabled: boolean, Transparency: number?, StrokeTransparency: number?)
        assert(typeof(Enabled) == "boolean", "Glass enabled state must be a boolean")
        if Transparency ~= nil then
            assert(
                typeof(Transparency) == "number" and Transparency == Transparency,
                "Glass transparency must be a number"
            )
            Library.GlassTransparency = math.clamp(Transparency, 0, 0.85)
            WindowInfo.GlassTransparency = Library.GlassTransparency
        end
        if StrokeTransparency ~= nil then
            assert(
                typeof(StrokeTransparency) == "number" and StrokeTransparency == StrokeTransparency,
                "Glass stroke transparency must be a number"
            )
            Library.GlassStrokeTransparency = math.clamp(StrokeTransparency, 0, 1)
            WindowInfo.GlassStrokeTransparency = Library.GlassStrokeTransparency
        end

        Library.GlassEnabled = Enabled
        WindowInfo.Glass = Enabled
        WindowInfo.GlassPreset = "Custom"
        RefreshGlassStyle()
        UpdateGlassSheen()
        UpdateGlassBackdropMotion()
        if GlassBlurEffect and not Enabled then
            GlassBlurEffect.Enabled = false
        end
    end

    function Window:SetGlassSheen(Enabled: boolean, Speed: number?)
        assert(typeof(Enabled) == "boolean", "Glass sheen enabled state must be a boolean")
        if Speed ~= nil then
            assert(
                typeof(Speed) == "number" and Speed == Speed,
                "Glass sheen speed must be a number"
            )
            WindowInfo.GlassSheenSpeed = math.clamp(Speed, 2, 20)
        end
        WindowInfo.GlassSheen = Enabled
        UpdateGlassSheen()
    end

    function Window:SetGlassBackgroundMotion(Enabled: boolean, Speed: number?)
        assert(
            typeof(Enabled) == "boolean",
            "Glass background motion enabled state must be a boolean"
        )
        if Speed ~= nil then
            assert(
                typeof(Speed) == "number" and Speed == Speed,
                "Glass background motion speed must be a number"
            )
            WindowInfo.GlassBackgroundMotionSpeed = math.clamp(Speed, 4, 30)
        end
        WindowInfo.GlassBackgroundMotion = Enabled
        UpdateGlassBackdropMotion()
    end

    function Window:SetGlassBlur(Enabled: boolean, Size: number?)
        assert(typeof(Enabled) == "boolean", "Glass blur enabled state must be a boolean")
        if Size ~= nil then
            assert(typeof(Size) == "number" and Size == Size, "Glass blur size must be a number")
            WindowInfo.GlassBlurSize = math.clamp(Size, 0, 24)
        end

        WindowInfo.GlassBlur = Enabled
        if Enabled and not GlassBlurEffect then
            GlassBlurEffect = Instance.new("BlurEffect")
            GlassBlurEffect.Name = "CyanLiquidGlassBlur"
            GlassBlurEffect.Parent = Lighting
            table.insert(Library.GlassBlurEffects, GlassBlurEffect)
        end
        if GlassBlurEffect then
            GlassBlurEffect.Size = WindowInfo.GlassBlurSize
            GlassBlurEffect.Enabled = Enabled and Library.Toggled and Library.GlassEnabled
        end
    end

    function Window:GetGlassPreset(): string
        return WindowInfo.GlassPreset
    end

    function Window:SetGlassPreset(Preset: string): boolean
        assert(typeof(Preset) == "string", "Glass preset must be a string")
        Preset = string.lower(Preset)

        if Preset == "crystal" then
            Window:SetGlass(true, 0.08, 0.1)
            WindowInfo.GlassPreset = "Crystal"
        elseif Preset == "frosted" then
            Window:SetGlass(true, 0.34, 0.42)
            WindowInfo.GlassPreset = "Frosted"
        elseif Preset == "solid" then
            Window:SetGlass(false)
            WindowInfo.GlassPreset = "Solid"
        elseif Preset == "liquid" then
            Window:SetGlass(true, 0.16, 0.25)
            WindowInfo.GlassPreset = "Liquid"
        elseif Preset == "ocean" then
            Window:SetGlass(true, 0.18, 0.2)
            WindowInfo.GlassPreset = "Ocean"
        elseif Preset == "aurora" then
            Window:SetGlass(true, 0.2, 0.18)
            WindowInfo.GlassPreset = "Aurora"
        elseif Preset == "midnight" then
            Window:SetGlass(true, 0.12, 0.3)
            WindowInfo.GlassPreset = "Midnight"
        else
            return false
        end

        ApplyGlassGradientProfile(WindowInfo.GlassPreset)
        return true
    end

    function Window:SetCornerRadius(Radius: number)
        assert(typeof(Radius) == "number", "Expected number for Radius got: " .. typeof(Radius))
        Radius = math.min(Radius, 20)

        local RadiusHalf = UDim.new(0, Radius / 2)
        local RadiusUDim = UDim.new(0, Radius)
        local HalfCurrent = Library.CornerRadius / 2

        for _, UICorner in Library.Corners do
            if UICorner.CornerRadius.Offset == HalfCurrent then
                UICorner.CornerRadius = RadiusHalf
            else
                UICorner.CornerRadius = RadiusUDim
            end
        end

        for _, UICorner in Library.SpecificCorners do
            SetUICorner(UICorner, "TopRightRadius", HalfCurrent, RadiusHalf, RadiusUDim)
            SetUICorner(UICorner, "TopLeftRadius", HalfCurrent, RadiusHalf, RadiusUDim)
            SetUICorner(UICorner, "BottomRightRadius", HalfCurrent, RadiusHalf, RadiusUDim)
            SetUICorner(UICorner, "BottomLeftRadius", HalfCurrent, RadiusHalf, RadiusUDim)
        end

        Library.CornerRadius = Radius
        WindowInfo.CornerRadius = Radius

        ResizeButton.Position = UDim2.new(1, -Radius / 4, 0, 0)
        BottomBackground.Size = UDim2.new(1, 0, 0, 20 + Radius)

        for _, Tab in Library.Tabs do
            if Tab.IsKeyTab then
                continue
            end

            for _, Tabbox in Tab.Tabboxes do
                Tabbox:UpdateCorners()
            end
        end
    end

    function Window:SetAnimations(
        Animations: { [string]: boolean }?,
        TabTransitionTime: number?,
        TabSwipeOffset: number?,
        TabSwipeFrom: ("left" | "right" | "top" | "bottom" | string)?
    )
        if typeof(Animations) == "table" then
            WindowInfo.Animations = CopyAnimations(Animations)
            ApplyAnimationPreferences(WindowInfo.Animations)
        end

        if typeof(TabTransitionTime) == "number" then
            local TweenInfo = TweenInfo.new(
                math.max(0, TabTransitionTime or 0.22),
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )

            WindowInfo.TabTransitionInfo = TweenInfo
            Library.TabTransitionInfo = TweenInfo
        end

        if typeof(TabSwipeOffset) == "number" then
            TabSwipeOffset = math.max(1, TabSwipeOffset)

            WindowInfo.TabSwipeOffset = TabSwipeOffset
            Library.TabSwipeOffset = TabSwipeOffset
        end

        if typeof(TabSwipeFrom) == "string" then
            TabSwipeFrom = string.lower(TabSwipeFrom)

            WindowInfo.TabSwipeFrom = TabSwipeFrom
            Library.TabSwipeFrom = TabSwipeFrom
        end
    end

    local function ApplyCompact()
        IsCompact = Window:GetSidebarWidth() == WindowInfo.SidebarCompactWidth
        if WindowInfo.DisableCompactingSnap then
            IsCompact = Window:GetSidebarWidth() <= WindowInfo.CompactWidthActivation
        end

        WindowTitle.Visible = not IsCompact
        if not WindowInfo.Icon then
            WindowIcon.Visible = IsCompact
        end

        for _, Button in Library.TabButtons do
            if not Button.Icon then
                continue
            end

            Button.Label.Visible = not IsCompact
            Button.Padding.PaddingBottom = UDim.new(0, IsCompact and 6 or 11)
            Button.Padding.PaddingLeft = UDim.new(0, IsCompact and 6 or 12)
            Button.Padding.PaddingRight = UDim.new(0, IsCompact and 6 or 12)
            Button.Padding.PaddingTop = UDim.new(0, IsCompact and 6 or 11)
            Button.Icon.SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY
                or Enum.SizeConstraint.RelativeYY
        end
    end

    function Window:IsSidebarCompacted()
        return IsCompact
    end

    function Window:SetCompact(State)
        Window:SetSidebarWidth(State and WindowInfo.SidebarCompactWidth or LastExpandedWidth)
    end

    function Window:GetSidebarWidth()
        return Tabs.Size.X.Offset
    end

    function Window:SetSidebarWidth(Width)
        Width = math.clamp(Width, 48, MainFrame.Size.X.Offset - WindowInfo.MinContainerWidth - 1)

        DividerLine.Position = UDim2.fromOffset(Width, 0)

        TitleHolder.Size = UDim2.new(0, Width, 1, 0)
        RightWrapper.Size = UDim2.new(1, -Width - 57 - 1, 1, RightWrapperHeightOffset)
        Tabs.Size = UDim2.new(0, Width, 1, -70)
        Container.Size = UDim2.new(1, -Width - 1, 1, -70)

        if WindowInfo.EnableCompacting then
            ApplyCompact()
        end
        if not IsCompact then
            LastExpandedWidth = Width
        end
    end

    function Window:ShowTabInfo(Name, Description)
        CurrentTabLabel.Text = Name
        CurrentTabDescription.Text = Description

        if IsDefaultSearchbarSize then
            SearchBox.Size = UDim2.fromScale(0.5, 1)
        end
        CurrentTabInfo.Visible = true
    end

    function Window:HideTabInfo()
        CurrentTabInfo.Visible = false
        if IsDefaultSearchbarSize then
            SearchBox.Size = UDim2.fromScale(1, 1)
        end
    end

    function Window:AddTab(...)
        local Name = nil
        local Icon = nil
        local Description = nil

        if select("#", ...) == 1 and typeof(...) == "table" then
            local Info = select(1, ...)
            Name = Info.Name or "Tab"
            Icon = Info.Icon
            Description = Info.Description
        else
            Name = select(1, ...)
            Icon = select(2, ...)
            Description = select(3, ...)
        end

        local TabButton: TextButton
        local TabLabel
        local TabIcon

        local TabContainer
        local TabCanvas
        local TabLeft
        local TabRight

        Icon = Library:GetCustomIcon(Icon)
        do
            TabButton = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                Parent = Tabs,
            })
            local ButtonPadding = New("UIPadding", {
                PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
                PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
                PaddingRight = UDim.new(0, IsCompact and 6 or 12),
                PaddingTop = UDim.new(0, IsCompact and 6 or 11),
                Parent = TabButton,
            })

            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = Name,
                TextSize = 16,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = not IsCompact,
                Parent = TabButton,
            })

            if Icon then
                TabIcon = New("ImageLabel", {
                    Image = Icon.Url,
                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                    ImageRectOffset = Icon.ImageRectOffset,
                    ImageRectSize = Icon.ImageRectSize,
                    ImageTransparency = 0.5,
                    ScaleType = Enum.ScaleType.Fit,
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY
                        or Enum.SizeConstraint.RelativeYY,
                    Parent = TabButton,
                })
            end

            table.insert(Library.TabButtons, {
                Label = TabLabel,
                Padding = ButtonPadding,
                Icon = TabIcon,
            })

            --// Tab Canvas \\--
            TabCanvas = New("CanvasGroup", {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                GroupTransparency = 0,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            --// Tab Container \\--
            TabContainer = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1),
                Visible = true,
                Parent = TabCanvas,
            })

            TabLeft = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                Size = UDim2.new(0.5, -3, 1, 0),
                Parent = TabContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = TabLeft,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
                Parent = TabLeft,
            })
            do
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = -1,
                    Parent = TabLeft,
                })
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Parent = TabLeft,
                })
            end

            TabRight = New("ScrollingFrame", {
                AnchorPoint = Vector2.new(1, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                Position = UDim2.fromScale(1, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                Size = UDim2.new(0.5, -3, 1, 0),
                Parent = TabContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = TabRight,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
                Parent = TabRight,
            })
            do
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = -1,
                    Parent = TabRight,
                })
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Parent = TabRight,
                })
            end
        end

        --// Warning Box \\--
        local WarningBoxHolder = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 7),
            Size = UDim2.fromScale(1, 0),
            Visible = false,
            Parent = TabContainer,
        })

        local WarningBox
        local WarningBoxOutline
        local WarningBoxShadowOutline
        local WarningBoxScrollingFrame
        local WarningTitle
        local WarningStroke
        local WarningText
        do
            WarningBox = New("Frame", {
                BackgroundColor3 = "BackgroundColor",
                Position = UDim2.fromOffset(2, 0),
                Size = UDim2.new(1, -5, 0, 0),
                Parent = WarningBoxHolder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                    Parent = WarningBox,
                })
            )
            WarningBoxOutline, WarningBoxShadowOutline = Library:AddOutline(WarningBox)

            WarningBoxScrollingFrame = New("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 3,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                Parent = WarningBox,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                PaddingTop = UDim.new(0, 4),
                Parent = WarningBoxScrollingFrame,
            })

            WarningTitle = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -4, 0, 14),
                Text = "",
                TextColor3 = Color3.fromRGB(255, 50, 50),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = WarningBoxScrollingFrame,
            })

            WarningStroke = New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = Color3.fromRGB(169, 0, 0),
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = WarningTitle,
            })

            WarningText = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 16),
                Size = UDim2.new(1, -4, 0, 0),
                Text = "",
                TextSize = 14,
                TextWrapped = true,
                Parent = WarningBoxScrollingFrame,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
            })

            New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = "DarkColor",
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = WarningText,
            })
        end

        --// Tab Table \\--
        local Tab = {
            Description = Description,

            Connections = {},
            Destroyed = false,

            Window = Window,
            Canvas = TabCanvas,
            Sides = {
                TabLeft,
                TabRight,
            },
            WarningBox = {
                IsNormal = false,
                LockSize = false,
                Visible = false,
                Title = "WARNING",
                Text = "",
            },

            Groupboxes = {},
            Tabboxes = {},
            DependencyGroupboxes = {},
        }

        function Tab:UpdateWarningBox(Info)
            if typeof(Info.IsNormal) == "boolean" then
                Tab.WarningBox.IsNormal = Info.IsNormal
            end
            if typeof(Info.LockSize) == "boolean" then
                Tab.WarningBox.LockSize = Info.LockSize
            end
            if typeof(Info.Visible) == "boolean" then
                Tab.WarningBox.Visible = Info.Visible
            end
            if typeof(Info.Title) == "string" then
                Tab.WarningBox.Title = Info.Title
            end
            if typeof(Info.Text) == "string" then
                Tab.WarningBox.Text = Info.Text
            end

            WarningBoxHolder.Visible = Tab.WarningBox.Visible
            WarningTitle.Text = Tab.WarningBox.Title
            WarningText.Text = Tab.WarningBox.Text
            Tab:Resize(true)

            WarningBox.BackgroundColor3 = Tab.WarningBox.IsNormal == true
                    and Library.Scheme.BackgroundColor
                or Color3.fromRGB(127, 0, 0)

            WarningBoxShadowOutline.Color = Tab.WarningBox.IsNormal == true
                    and Library.Scheme.DarkColor
                or Color3.fromRGB(85, 0, 0)
            WarningBoxOutline.Color = Tab.WarningBox.IsNormal == true
                    and Library.Scheme.OutlineColor
                or Color3.fromRGB(255, 50, 50)

            WarningTitle.TextColor3 = Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor
                or Color3.fromRGB(255, 50, 50)
            WarningStroke.Color = Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor
                or Color3.fromRGB(169, 0, 0)

            if not Library.Registry[WarningBox] then
                Library:AddToRegistry(WarningBox, {})
            end
            if not Library.Registry[WarningBoxShadowOutline] then
                Library:AddToRegistry(WarningBoxShadowOutline, {})
            end
            if not Library.Registry[WarningBoxOutline] then
                Library:AddToRegistry(WarningBoxOutline, {})
            end
            if not Library.Registry[WarningTitle] then
                Library:AddToRegistry(WarningTitle, {})
            end
            if not Library.Registry[WarningStroke] then
                Library:AddToRegistry(WarningStroke, {})
            end

            Library.Registry[WarningBox].BackgroundColor3 = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor
                    or Color3.fromRGB(127, 0, 0)
            end

            Library.Registry[WarningBoxShadowOutline].Color = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor
                    or Color3.fromRGB(85, 0, 0)
            end

            Library.Registry[WarningBoxOutline].Color = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor
                    or Color3.fromRGB(255, 50, 50)
            end

            Library.Registry[WarningTitle].TextColor3 = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor
                    or Color3.fromRGB(255, 50, 50)
            end

            Library.Registry[WarningStroke].Color = function()
                return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor
                    or Color3.fromRGB(169, 0, 0)
            end
        end

        function Tab:RefreshSides()
            local Offset = WarningBoxHolder.Visible and WarningBox.Size.Y.Offset + 8 or 0
            for _, Side in Tab.Sides do
                Side.Position = UDim2.new(Side.Position.X.Scale, 0, 0, Offset)
                Side.Size = UDim2.new(0.5, -3, 1, -Offset)
            end
        end

        function Tab:Resize(ResizeWarningBox: boolean?)
            if ResizeWarningBox then
                local MaximumSize = math.floor(TabContainer.AbsoluteSize.Y / 3.25)
                local _, YText = Library:GetTextBounds(
                    WarningText.Text,
                    Library.Scheme.Font,
                    WarningText.TextSize,
                    WarningText.AbsoluteSize.X
                )

                local YBox = 24 + YText
                if Tab.WarningBox.LockSize == true and YBox >= MaximumSize then
                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, YBox)
                    YBox = MaximumSize
                else
                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
                end

                WarningText.Size = UDim2.new(1, -4, 0, YText)
                WarningBox.Size = UDim2.new(1, -5, 0, YBox + 4)
            end

            Tab:RefreshSides()
        end

        local function AddTabbox(self, Info)
            local ParentObj = self

            local BoxHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Parent = if ParentObj.Type == "Groupbox"
                    then ParentObj.Container
                    else (Info.Side == 1 and TabLeft or TabRight),
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = BoxHolder,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingTop = UDim.new(0, 4),
                Parent = BoxHolder,
            })

            local TabboxHolder
            local TabboxButtons

            do
                TabboxHolder = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Size = UDim2.fromScale(1, 0),
                    Parent = BoxHolder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                        Parent = TabboxHolder,
                    })
                )
                Library:AddOutline(TabboxHolder)

                TabboxButtons = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 34),
                    Parent = TabboxHolder,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Parent = TabboxButtons,
                })
            end

            local TotalTabs = 0
            local FirstTab
            local LastTab

            local Tabbox = {
                Connections = {},
                Destroyed = false,

                ActiveTab = nil,

                BoxHolder = BoxHolder,
                Holder = TabboxHolder,
                Tabs = {},
            }

            function Tabbox:UpdateCorners()
                for _, Tab in Tabbox.Tabs do
                    Tab:UpdateCorners()
                end
            end

            function Tabbox:AddTab(Name, IconName)
                TotalTabs = TotalTabs + 1
                local TabIndex = TotalTabs

                LastTab = TabIndex
                if not FirstTab then
                    FirstTab = TabIndex
                end

                local IsNameEmpty = Name == nil or Trim(tostring(Name)) == ""
                local TabStoringIndex = IsNameEmpty and tostring(TabIndex) or Name

                local Button = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 0,
                    Size = UDim2.fromOffset(0, 34),
                    Text = "",
                    Parent = TabboxButtons,
                })

                local ButtonCorner = New("UICorner", {
                    TopLeftRadius = UDim.new(0, WindowInfo.CornerRadius),
                    TopRightRadius = UDim.new(0, WindowInfo.CornerRadius),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0),
                    Parent = Button,
                })
                table.insert(Library.SpecificCorners, ButtonCorner)

                local ButtonContent = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(0, 16),
                    Parent = Button,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 8),
                    Parent = ButtonContent,
                })

                local ButtonIcon
                local BoxIcon = Library:GetCustomIcon(IconName)
                if BoxIcon then
                    ButtonIcon = New("ImageLabel", {
                        Image = BoxIcon.Url,
                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                        ImageRectOffset = BoxIcon.ImageRectOffset,
                        ImageRectSize = BoxIcon.ImageRectSize,
                        ImageTransparency = 0.5,
                        Size = IsNameEmpty and UDim2.fromOffset(16, 16) or UDim2.fromOffset(18, 18),
                        Parent = ButtonContent,
                    })
                end

                local ButtonLabel
                if not IsNameEmpty then
                    ButtonLabel = New("TextLabel", {
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(0, 16),
                        Text = Name,
                        TextSize = 15,
                        TextTransparency = 0.5,
                        Parent = ButtonContent,
                    })
                end

                local Line = Library:MakeLine(Button, {
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                })

                local Container = New("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(0, 35),
                    Size = UDim2.new(1, 0, 1, -35),
                    Visible = false,
                    Parent = TabboxHolder,
                })
                local List = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = Container,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = Container,
                })

                local Tab = {
                    Connections = {},
                    Destroyed = false,

                    ButtonHolder = Button,
                    Container = Container,
                    ButtonCorner = ButtonCorner,

                    Tab = Tab,
                    Elements = {},
                    DependencyBoxes = {},
                }

                function Tab:Show()
                    if Tabbox.ActiveTab then
                        Tabbox.ActiveTab:Hide()
                    end

                    Button.BackgroundTransparency = 1

                    if ButtonLabel then
                        ButtonLabel.TextTransparency = 0
                    end
                    if ButtonIcon then
                        ButtonIcon.ImageTransparency = 0
                    end

                    Line.Visible = false

                    Container.Visible = true

                    Tabbox.ActiveTab = Tab
                    Tab:Resize()
                end

                function Tab:Hide()
                    Button.BackgroundTransparency = 0

                    if ButtonLabel then
                        ButtonLabel.TextTransparency = 0.5
                    end
                    if ButtonIcon then
                        ButtonIcon.ImageTransparency = 0.5
                    end
                    Line.Visible = true
                    Container.Visible = false

                    Tabbox.ActiveTab = nil
                end

                function Tab:Resize()
                    if Tabbox.ActiveTab ~= Tab then
                        return
                    end

                    TabboxHolder.Size =
                        UDim2.new(1, 0, 0, (List.AbsoluteContentSize.Y / Library.DPIScale) + 49)
                    if ParentObj.Type == "Groupbox" then
                        ParentObj:Resize()
                    end
                end

                function Tab:UpdateCorners()
                    local Radius = WindowInfo.CornerRadius

                    ButtonCorner.TopLeftRadius = UDim.new(0, TabIndex == FirstTab and Radius or 0)
                    ButtonCorner.TopRightRadius = UDim.new(0, TabIndex == LastTab and Radius or 0)
                end

                function Tab:Destroy()
                    Tab.Destroyed = true

                    if Tab.Connections then
                        for _, Connection in Tab.Connections do
                            Connection:Disconnect()
                        end
                    end

                    for _, Element in Tab.Elements do
                        if Element.Destroy then
                            Element:Destroy()
                        end
                    end

                    for _, SubDepbox in Tab.DependencyBoxes do
                        if SubDepbox.Destroy then
                            SubDepbox:Destroy()
                        end
                    end

                    if Container then
                        Container:Destroy()
                    end

                    if Button then
                        Button:Destroy()
                    end
                end

                --// Execution \\--
                if not Tabbox.ActiveTab then
                    Tab:Show()
                end

                Button.MouseButton1Click:Connect(Tab.Show)

                setmetatable(Tab, BaseGroupbox)

                Tabbox.Tabs[TabStoringIndex] = Tab
                Tabbox:UpdateCorners()

                return Tab, TabStoringIndex
            end

            function Tabbox:Destroy()
                Tabbox.Destroyed = true

                if Tabbox.Connections then
                    for _, Connection in Tabbox.Connections do
                        Connection:Disconnect()
                    end
                end

                for _, Tab in Tabbox.Tabs do
                    if Tab.Destroy then
                        Tab:Destroy()
                    end
                end

                if TabboxHolder then
                    TabboxHolder:Destroy()
                end

                if BoxHolder then
                    BoxHolder:Destroy()
                end
            end

            if Info.Name then
                Tab.Tabboxes[Info.Name] = Tabbox
            else
                table.insert(Tab.Tabboxes, Tabbox)
            end

            return Tabbox
        end

        Tab.AddTabbox = AddTabbox

        function Tab:AddLeftTabbox(Name)
            return Tab:AddTabbox({ Side = 1, Name = Name })
        end

        function Tab:AddRightTabbox(Name)
            return Tab:AddTabbox({ Side = 2, Name = Name })
        end

        function Tab:AddGroupbox(Info)
            local BoxHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Parent = Info.Side == 1 and TabLeft or TabRight,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = BoxHolder,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingTop = UDim.new(0, 4),
                Parent = BoxHolder,
            })

            local GroupboxHolder
            local GroupboxLabel

            local GroupboxContainer
            local GroupboxList

            local GroupboxCollapseArrow
            local GroupboxLine

            do
                GroupboxHolder = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    BackgroundTransparency = Library.GlassEnabled and Library.GlassTransparency
                        or 0,
                    Size = UDim2.fromScale(1, 0),
                    Parent = BoxHolder,
                })
                AddGlassSurface(GroupboxHolder, 0)
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                        Parent = GroupboxHolder,
                    })
                )
                Library:AddOutline(GroupboxHolder)

                GroupboxLine = Library:MakeLine(GroupboxHolder, {
                    Position = UDim2.fromOffset(0, 34),
                    Size = UDim2.new(1, 0, 0, 1),
                })

                local BoxIcon = Library:GetCustomIcon(Info.IconName)
                if BoxIcon then
                    New("ImageLabel", {
                        Image = BoxIcon.Url,
                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                        ImageRectOffset = BoxIcon.ImageRectOffset,
                        ImageRectSize = BoxIcon.ImageRectSize,
                        Position = UDim2.fromOffset(6, 6),
                        Size = UDim2.fromOffset(22, 22),
                        Parent = GroupboxHolder,
                    })
                end

                GroupboxLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(BoxIcon and 24 or 0, 0),
                    Size = UDim2.new(1, 0, 0, 34),
                    Text = Info.Name,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = GroupboxHolder,
                })
                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    Parent = GroupboxLabel,
                })

                if Info.DisableCollapsing ~= true then
                    GroupboxCollapseArrow = New("ImageButton", {
                        Image = ArrowIcon and ArrowIcon.Url or "",
                        ImageColor3 = "WhiteColor",
                        ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2.zero,
                        ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2.zero,
                        BackgroundTransparency = 1,
                        Rotation = 180,
                        Position = UDim2.new(1, -(22 + 6), 0, 6),
                        Size = UDim2.fromOffset(22, 22),
                        Parent = GroupboxHolder,
                    })
                end

                GroupboxContainer = New("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(0, 35),
                    Size = UDim2.new(1, 0, 1, -35),
                    Parent = GroupboxHolder,
                })

                GroupboxList = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = GroupboxContainer,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = GroupboxContainer,
                })
            end

            local Groupbox = {
                Type = "Groupbox",

                Connections = {},
                Destroyed = false,

                Visible = true,
                Collapsed = false,

                BoxHolder = BoxHolder,
                Holder = GroupboxHolder,
                Container = GroupboxContainer,

                Tab = Tab,
                DependencyBoxes = {},
                Elements = {},
            }

            local ResizeTween
            local CollapseArrowTween

            function Groupbox:Resize()
                if ResizeTween then
                    StopTween(ResizeTween, true)
                    ResizeTween = nil
                end

                local TargetSize = UDim2.new(
                    1,
                    0,
                    0,
                    if Groupbox.Collapsed
                        then 34
                        else (GroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 49
                )

                GroupboxLine.Visible = not Groupbox.Collapsed
                if Library.Animations and Library.Animations.Groupbox then
                    local TweenInfo = Library.GroupboxTweenInfo
                        or TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local Tween =
                        TweenService:Create(GroupboxHolder, TweenInfo, { Size = TargetSize })
                    ResizeTween = Tween

                    local Connection
                    Connection = Library:GiveSignal(Tween.Completed:Once(function()
                        if Connection then
                            Connection:Disconnect()
                        end

                        if ResizeTween == Tween then
                            StopTween(ResizeTween, true)
                            ResizeTween = nil
                        end
                    end))

                    Tween:Play()
                else
                    GroupboxHolder.Size = TargetSize
                end
            end

            function Groupbox:SetCollapsed(Collapsed: boolean)
                if Info.DisableCollapsing == true then
                    return
                end
                Groupbox.Collapsed = Collapsed

                if CollapseArrowTween then
                    StopTween(CollapseArrowTween, true)
                    CollapseArrowTween = nil
                end

                local TargetRotation = if Collapsed then 0 else 180

                GroupboxContainer.Visible = not Collapsed
                if Library.Animations and Library.Animations.Groupbox then
                    local TweenInfo = Library.GroupboxTweenInfo
                        or TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    local Tween = TweenService:Create(
                        GroupboxCollapseArrow,
                        TweenInfo,
                        { Rotation = TargetRotation }
                    )
                    CollapseArrowTween = Tween

                    local Connection
                    Connection = Library:GiveSignal(Tween.Completed:Connect(function()
                        if Connection then
                            Connection:Disconnect()
                        end

                        if CollapseArrowTween == Tween then
                            StopTween(CollapseArrowTween, true)
                            CollapseArrowTween = nil
                        end
                    end))

                    Tween:Play()
                else
                    GroupboxCollapseArrow.Rotation = TargetRotation
                end

                Groupbox:Resize()
            end

            function Groupbox:ToggleCollapsed()
                if Info.DisableCollapsing == true then
                    return
                end
                Groupbox:SetCollapsed(not Groupbox.Collapsed)
            end

            function Groupbox:Destroy()
                Groupbox.Destroyed = true

                if ResizeTween then
                    StopTween(ResizeTween, true)
                    ResizeTween = nil
                end

                if CollapseArrowTween then
                    StopTween(CollapseArrowTween, true)
                    CollapseArrowTween = nil
                end

                if Groupbox.Connections then
                    for _, Connection in Groupbox.Connections do
                        Connection:Disconnect()
                    end
                end

                for _, Element in Groupbox.Elements do
                    if Element.Destroy then
                        Element:Destroy()
                    end
                end
                table.clear(Groupbox.Elements)

                for _, SubDepbox in Groupbox.DependencyBoxes do
                    if SubDepbox.Destroy then
                        SubDepbox:Destroy()
                    end
                end
                table.clear(Groupbox.DependencyBoxes)

                if GroupboxHolder then
                    GroupboxHolder:Destroy()
                end

                if BoxHolder then
                    BoxHolder:Destroy()
                end
            end

            function Groupbox:SetVisible(Visible: boolean)
                Groupbox.Visible = Visible
                BoxHolder.Visible = Visible

                if Visible == true and Library.Searching then
                    Library:UpdateSearch(Library.SearchText)
                end
            end

            function Groupbox:Show()
                Groupbox:SetVisible(true)
            end

            function Groupbox:Hide()
                Groupbox:SetVisible(false)
            end

            if Info.DisableCollapsing ~= true then
                GroupboxCollapseArrow.MouseButton1Click:Connect(function()
                    Groupbox:ToggleCollapsed()
                end)
            end

            Groupbox.AddTabbox = AddTabbox
            setmetatable(Groupbox, BaseGroupbox)

            Groupbox:Resize()
            Tab.Groupboxes[Info.Name] = Groupbox

            if Info.Visible == false then
                Groupbox:Hide()
            end

            if Info.DisableCollapsing ~= true and Info.Collapsed == true then
                Groupbox:SetCollapsed(true)
            end

            return Groupbox
        end

        function Tab:AddLeftGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
            return Tab:AddGroupbox({
                Side = 1,
                Name = Name,
                IconName = IconName,
                Visible = Visible,
                Collapsed = Collapsed,
                DisableCollapsing = DisableCollapsing,
            })
        end

        function Tab:AddRightGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
            return Tab:AddGroupbox({
                Side = 2,
                Name = Name,
                IconName = IconName,
                Visible = Visible,
                Collapsed = Collapsed,
                DisableCollapsing = DisableCollapsing,
            })
        end

        function Tab:Hover(Hovering)
            if Library.ActiveTab == Tab then
                return
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = Hovering and 0.25 or 0.5,
                }):Play()
            end
        end

        function Tab:Show()
            if Library.ActiveTab == Tab then
                return
            end

            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            TweenService
                :Create(TabButton, Library.TweenInfo, {
                    BackgroundTransparency = Library.GlassEnabled and 0.28 or 0,
                })
                :Play()
            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0,
                }):Play()
            end

            if Description then
                Window:ShowTabInfo(Name, Description)
            end

            Library:PlayTabAnimation(TabCanvas, true)
            Tab:RefreshSides()

            Library.ActiveTab = Tab

            if Library.Searching then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function Tab:Hide()
            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0.5,
            }):Play()

            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0.5,
                }):Play()
            end

            Library:PlayTabAnimation(TabCanvas, false)
            Window:HideTabInfo()

            Library.ActiveTab = nil
        end

        function Tab:SetVisible(Visible: boolean)
            TabButton.Visible = Visible

            if not Visible and Library.ActiveTab == Tab then
                Tab:Hide()
            end
        end

        function Tab:Destroy()
            Tab.Destroyed = true

            if Tab.Connections then
                for _, Connection in Tab.Connections do
                    Connection:Disconnect()
                end
            end

            for _, Groupbox in Tab.Groupboxes do
                if Groupbox.Destroy then
                    Groupbox:Destroy()
                end
            end
            table.clear(Tab.Groupboxes)

            for _, Tabbox in Tab.Tabboxes do
                if Tabbox.Destroy then
                    Tabbox:Destroy()
                end
            end
            table.clear(Tab.Tabboxes)

            for _, DepGroupbox in Tab.DependencyGroupboxes do
                if DepGroupbox.Destroy then
                    DepGroupbox:Destroy()
                end
            end

            if TabCanvas then
                TabCanvas:Destroy()
            elseif TabContainer then
                TabContainer:Destroy()
            end

            if TabButton then
                for Index, Entry in Library.TabButtons do
                    if typeof(Entry) == "table" and Entry.Button == TabButton then
                        table.remove(Library.TabButtons, Index)
                        break
                    end
                end

                TabButton:Destroy()
            end

            Library.Tabs[Name] = nil
            local TabOrderIndex = table.find(Library.TabOrder, Tab)
            if TabOrderIndex then
                table.remove(Library.TabOrder, TabOrderIndex)
            end
        end

        --// Execution \\--
        if not Library.ActiveTab then
            Tab:Show()
        end

        TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end)
        TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end)
        TabButton.MouseButton1Click:Connect(Tab.Show)

        Tab.Button = TabButton
        Library.Tabs[Name] = Tab
        table.insert(Library.TabOrder, Tab)

        return Tab
    end

    function Window:AddKeyTab(...)
        local Name = nil
        local Icon = nil
        local Description = nil

        if select("#", ...) == 1 and typeof(...) == "table" then
            local Info = select(1, ...)
            Name = Info.Name or "Tab"
            Icon = Info.Icon
            Description = Info.Description
        else
            Name = select(1, ...) or "Tab"
            Icon = select(2, ...)
            Description = select(3, ...)
        end

        Icon = Icon or "key"

        local TabButton: TextButton
        local TabLabel
        local TabIcon

        local TabCanvas
        local TabContainer

        Icon = if Icon == "key" then KeyIcon else Library:GetCustomIcon(Icon)
        do
            TabButton = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                Parent = Tabs,
            })
            local ButtonPadding = New("UIPadding", {
                PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
                PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
                PaddingRight = UDim.new(0, IsCompact and 6 or 12),
                PaddingTop = UDim.new(0, IsCompact and 6 or 11),
                Parent = TabButton,
            })

            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = Name,
                TextSize = 16,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = not IsCompact,
                Parent = TabButton,
            })

            if Icon then
                TabIcon = New("ImageLabel", {
                    Image = Icon.Url,
                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                    ImageRectOffset = Icon.ImageRectOffset,
                    ImageRectSize = Icon.ImageRectSize,
                    ImageTransparency = 0.5,
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY
                        or Enum.SizeConstraint.RelativeYY,
                    Parent = TabButton,
                })
            end

            table.insert(Library.TabButtons, {
                Label = TabLabel,
                Padding = ButtonPadding,
                Icon = TabIcon,
            })

            --// Tab Canvas \\--
            TabCanvas = New("CanvasGroup", {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                GroupTransparency = 0,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            --// Tab Container \\--
            TabContainer = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarThickness = 0,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1),
                Visible = true,
                Parent = TabCanvas,
            })
            New("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 8),
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = TabContainer,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 1),
                PaddingRight = UDim.new(0, 1),
                Parent = TabContainer,
            })
        end

        --// Tab Table \\--
        local Tab = {
            Description = Description,
            IsKeyTab = true,

            Elements = {},

            Window = Window,
            Canvas = TabCanvas,
        }

        function Tab:AddKeyBox(Callback)
            assert(typeof(Callback) == "function", "Callback must be a function")

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0.75, 0, 0, 21),
                Parent = TabContainer,
            })

            local Box = New("TextBox", {
                BackgroundColor3 = "MainColor",
                PlaceholderText = "Key",
                Size = UDim2.new(1, -71, 1, 0),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = Box,
            })
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Box,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Box,
                })
            )

            local Button = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(1, 0),
                Size = UDim2.new(0, 63, 1, 0),
                Text = "Execute",
                TextSize = 14,
                Parent = Holder,
            })
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Button,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Button,
                })
            )

            local KeyBox = {
                TextBox = Box,
                Button = Button,
                Disabled = false,
            }

            function KeyBox:SetDisabled(Disabled: boolean)
                KeyBox.Disabled = Disabled == true
                Box.TextEditable = not KeyBox.Disabled
                Button.Active = not KeyBox.Disabled
                Button.Text = if KeyBox.Disabled then "Verified" else "Execute"
                Button.TextTransparency = if KeyBox.Disabled then 0.35 else 0
                Box.TextTransparency = if KeyBox.Disabled then 0.35 else 0
            end

            function KeyBox:SetText(Text: string)
                assert(typeof(Text) == "string", "Key box text must be a string")
                Box.Text = Text
            end

            function KeyBox:Clear()
                Box.Text = ""
            end

            function KeyBox:Focus()
                if not KeyBox.Disabled then
                    Box:CaptureFocus()
                end
            end

            function KeyBox:Submit()
                if KeyBox.Disabled then
                    return
                end

                Library:SafeCallback(Callback, Box.Text)
            end

            Library:GiveSignal(Button.InputBegan:Connect(function(Input)
                if not IsClickInput(Input) then
                    return
                end

                if not Library:MouseIsOverFrame(Button, Input.Position) then
                    return
                end

                KeyBox:Submit()
            end))
            Library:GiveSignal(Box.FocusLost:Connect(function(EnterPressed)
                if EnterPressed then
                    KeyBox:Submit()
                end
            end))

            return KeyBox
        end

        function Tab:Destroy()
            if TabCanvas then
                TabCanvas:Destroy()
            elseif TabContainer then
                TabContainer:Destroy()
            end

            if TabButton then
                for Index, Entry in Library.TabButtons do
                    if typeof(Entry) == "table" and Entry.Button == TabButton then
                        table.remove(Library.TabButtons, Index)
                        break
                    end
                end

                TabButton:Destroy()
            end

            Library.Tabs[Name] = nil
            local TabOrderIndex = table.find(Library.TabOrder, Tab)
            if TabOrderIndex then
                table.remove(Library.TabOrder, TabOrderIndex)
            end
        end

        function Tab:RefreshSides() end
        function Tab:Resize() end
        function Tab:UpdateCorners() end

        function Tab:Hover(Hovering)
            if Library.ActiveTab == Tab then
                return
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = Hovering and 0.25 or 0.5,
                }):Play()
            end
        end

        function Tab:Show()
            if Library.ActiveTab == Tab then
                return
            end

            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            TweenService
                :Create(TabButton, Library.TweenInfo, {
                    BackgroundTransparency = Library.GlassEnabled and 0.28 or 0,
                })
                :Play()

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0,
            }):Play()

            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0,
                }):Play()
            end

            Library:PlayTabAnimation(TabCanvas, true)

            if Description then
                Window:ShowTabInfo(Name, Description)
            end

            Tab:RefreshSides()

            Library.ActiveTab = Tab

            if Library.Searching then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function Tab:Hide()
            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0.5,
            }):Play()

            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0.5,
                }):Play()
            end

            Library:PlayTabAnimation(TabCanvas, false)
            Window:HideTabInfo()

            Library.ActiveTab = nil
        end

        function Tab:SetVisible(Visible: boolean)
            TabButton.Visible = Visible

            if not Visible and Library.ActiveTab == Tab then
                Tab:Hide()
            end
        end

        --// Execution \\--
        if not Library.ActiveTab then
            Tab:Show()
        end

        TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end)
        TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end)
        TabButton.MouseButton1Click:Connect(Tab.Show)

        Tab.Container = TabContainer
        setmetatable(Tab, BaseGroupbox)

        Tab.Button = TabButton
        Library.Tabs[Name] = Tab
        table.insert(Library.TabOrder, Tab)

        return Tab
    end

    function Window:AddDialog(Idx, Info)
        Info = Library:Validate(Info, Templates.Dialog)

        local DialogFrame
        local DialogOverlay
        local DialogContainer
        local ButtonsHolder
        local FooterButtonsList = {}

        DialogOverlay = New("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = "DarkColor",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            Active = false,
            ZIndex = 9000,
            Visible = true,
            Parent = MainFrame,
        })
        TweenService:Create(DialogOverlay, Library.TweenInfo, {
            BackgroundTransparency = 0.5,
        }):Play()

        DialogFrame = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "BackgroundColor",
            BackgroundTransparency = Library.GlassEnabled
                    and math.max(0.14, Library.GlassTransparency)
                or 0,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(300, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 9001,
            Parent = DialogOverlay,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = DialogFrame,
            })
        )
        Library:AddOutline(DialogFrame)
        AddGlassSurface(DialogFrame, 0)
        local DialogGlassStroke = New("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = "AccentColor",
            Thickness = 1.1,
            Transparency = Library.GlassEnabled and math.max(0.18, Library.GlassStrokeTransparency)
                or 1,
            Parent = DialogFrame,
        })
        table.insert(Library.GlassStrokes, DialogGlassStroke)

        local InnerContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 9002,
            Parent = DialogFrame,
        })
        local DialogScale = New("UIScale", {
            Scale = 0.95,
            Parent = DialogFrame,
        })
        TweenService:Create(DialogScale, Library.TweenInfo, {
            Scale = 1,
        }):Play()
        local _InnerPadding = New("UIPadding", {
            PaddingBottom = UDim.new(0, 15),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingTop = UDim.new(0, 15),
            Parent = InnerContainer,
        })
        local _InnerLayout = New("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = InnerContainer,
        })

        local HeaderContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 9002,
            Parent = InnerContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = HeaderContainer,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            Parent = HeaderContainer,
        })

        local TitleRow = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 9002,
            Parent = HeaderContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 6),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TitleRow,
        })

        if Info.Icon then
            local ParsedIcon = Library:GetCustomIcon(Info.Icon)
            if ParsedIcon then
                local IconImg = New("ImageLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(16, 16),
                    Image = ParsedIcon.Url,
                    ImageColor3 = "FontColor",
                    ImageRectOffset = ParsedIcon.ImageRectOffset,
                    ImageRectSize = ParsedIcon.ImageRectSize,
                    LayoutOrder = 1,
                    ZIndex = 9002,
                    Parent = TitleRow,
                })
                if Info.TitleColor then
                    IconImg.ImageColor3 = Info.TitleColor
                end
            end
        end

        local TitleLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Title,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 2,
            ZIndex = 9002,
            Parent = TitleRow,
        })
        if Info.TitleColor then
            TitleLabel.TextColor3 = Info.TitleColor
        end

        local DescriptionLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Description,
            TextSize = 14,
            TextTransparency = Info.DescriptionColor and 0 or 0.2,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 2,
            ZIndex = 9002,
            Parent = HeaderContainer,
        })
        if Info.DescriptionColor then
            DescriptionLabel.TextColor3 = Info.DescriptionColor
        end

        DialogContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 4,
            ZIndex = 9002,
            Parent = InnerContainer,
        })
        local _DialogContainerLayout = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = DialogContainer,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            Parent = DialogContainer,
        })

        local _Sep2 = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 1),
            LayoutOrder = 5,
            ZIndex = 9002,
            Parent = InnerContainer,
        })

        ButtonsHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 6,
            ZIndex = 9002,
            Parent = InnerContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Wraps = true,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ButtonsHolder,
        })
        New("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            Parent = ButtonsHolder,
        })

        local Dialog = {
            Destroyed = false,
            Elements = {},
            Container = DialogContainer,
            OutsideClickDismiss = Info.OutsideClickDismiss == true,
        }

        function Dialog:Resize()
            local MaxWidth = MainFrame.AbsoluteSize.X * 0.75
            local MinWidth = 400

            local TotalButtonWidth = 0
            local ButtonCount = 0
            local HasButtons = false

            for _, BtnWrap in FooterButtonsList do
                HasButtons = true
                ButtonCount = ButtonCount + 1
                TotalButtonWidth = TotalButtonWidth + BtnWrap.Container.Size.X.Offset
            end

            local TargetWidth = MinWidth
            if HasButtons then
                local RequiredWidth = TotalButtonWidth + ((ButtonCount - 1) * 8) + 30
                TargetWidth = math.max(MinWidth, math.min(RequiredWidth, MaxWidth))
            end

            DialogFrame.Size = UDim2.fromOffset(TargetWidth, 0)

            local _DescX, DescY = Library:GetTextBounds(
                DescriptionLabel.Text,
                Library.Scheme.Font,
                14,
                TargetWidth - 30
            )
            DescriptionLabel.Size = UDim2.new(1, 0, 0, DescY)

            local HasElements = false
            for _, v in DialogContainer:GetChildren() do
                if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                    HasElements = true
                    break
                end
            end
            DialogContainer.Visible = HasElements

            ButtonsHolder.Visible = HasButtons
            _Sep2.Visible = HasButtons
        end

        function Dialog:SetTitle(Title)
            TitleLabel.Text = Title
            Dialog:Resize()
        end

        function Dialog:SetDescription(Description)
            DescriptionLabel.Text = Description
            Dialog:Resize()
        end

        function Dialog:Dismiss()
            if Dialog.Destroyed then
                return
            end

            Dialog.Destroyed = true

            if Library.ActiveDialog == Dialog then
                Library.ActiveDialog = nil
            end

            for Index = #Dialog.Elements, 1, -1 do
                local Element = Dialog.Elements[Index]
                if Element and Element.Destroy then
                    Element:Destroy()
                end
            end
            table.clear(Dialog.Elements)

            local CloseTween = TweenService:Create(DialogScale, Library.TweenInfo, { Scale = 0.95 })
            TweenService:Create(DialogOverlay, Library.TweenInfo, { BackgroundTransparency = 1 })
                :Play()
            CloseTween:Play()

            task.delay(Library.TweenInfo.Time, function()
                DialogOverlay:Destroy()
            end)
            Library.Dialogues[Idx] = nil
        end

        DialogOverlay.MouseButton1Click:Connect(function()
            if Info.OutsideClickDismiss then
                Dialog:Dismiss()
            end
        end)

        function Dialog:RemoveFooterButton(ButtonIdx)
            if FooterButtonsList[ButtonIdx] then
                FooterButtonsList[ButtonIdx].Container:Destroy()
                FooterButtonsList[ButtonIdx] = nil
            end
        end

        function Dialog:SetButtonDisabled(ButtonIdx, Disabled)
            if
                FooterButtonsList[ButtonIdx]
                and type(FooterButtonsList[ButtonIdx].SetDisabled) == "function"
            then
                FooterButtonsList[ButtonIdx]:SetDisabled(Disabled)
            end
        end

        function Dialog:SetButtonOrder(ButtonIdx, Order)
            if FooterButtonsList[ButtonIdx] and FooterButtonsList[ButtonIdx].Container then
                FooterButtonsList[ButtonIdx].Container.LayoutOrder = Order
            end
        end

        function Dialog:AddFooterButton(ButtonIdx, ButtonInfo)
            Dialog:RemoveFooterButton(ButtonIdx)

            local WaitTime = ButtonInfo.WaitTime or 0

            local ButtonContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 26),
                LayoutOrder = ButtonInfo.Order or 0,
                ZIndex = 9002,
                Parent = ButtonsHolder,
            })

            local BtnColor = "MainColor"
            local BtnOutline = "OutlineColor"
            local Variant = ButtonInfo.Variant or "Primary"

            if Variant == "Primary" then
                BtnColor = "FontColor"
                BtnOutline = "FontColor"
            elseif Variant == "Secondary" then
                BtnColor = "MainColor"
                BtnOutline = "OutlineColor"
            elseif Variant == "Destructive" then
                BtnColor = "DestructiveColor"
                BtnOutline = "DestructiveColor"
            elseif Variant == "Ghost" then
                BtnColor = "BackgroundColor"
                BtnOutline = "BackgroundColor"
            end

            local TextBtn = New("TextButton", {
                BackgroundColor3 = BtnColor,
                BorderColor3 = BtnOutline,
                BackgroundTransparency = WaitTime > 0 and 0.5 or 0,
                Size = UDim2.fromOffset(0, 26),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 9002,
                Parent = ButtonContainer,
            })
            Library:AddOutline(TextBtn)
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius),
                    Parent = TextBtn,
                })
            )

            local _BtnPadding = New("UIPadding", {
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                Parent = TextBtn,
            })

            local TextColor = Library.Scheme.FontColor
            if Variant == "Primary" then
                TextColor = Library.Scheme.BackgroundColor
            elseif Variant == "Destructive" then
                TextColor = Color3.new(1, 1, 1)
            end

            local BtnLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ButtonInfo.Title or ButtonIdx,
                TextColor3 = TextColor,
                TextTransparency = WaitTime > 0 and 0.5 or 0,
                TextSize = 14,
                ZIndex = 9002,
                Parent = TextBtn,
            })

            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

            local ProgressBar
            if WaitTime > 0 then
                ProgressBar = New("Frame", {
                    BackgroundColor3 = "AccentColor",
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, -2),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 2,
                    Parent = TextBtn,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius),
                        Parent = ProgressBar,
                    })
                )
            end

            local IsActive = WaitTime <= 0

            local ButtonWrap = {
                Container = ButtonContainer,
                SetDisabled = function(self, Disabled)
                    IsActive = not Disabled
                    if Disabled then
                        TweenService
                            :Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0.5 })
                            :Play()
                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0.5 })
                            :Play()
                    else
                        TweenService
                            :Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0 })
                            :Play()
                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0 })
                            :Play()
                    end
                end,
            }

            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor
                or Library.Scheme[BtnColor]
            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor
                or Library:GetBetterColor(ActiveColor, 10)

            TextBtn.MouseEnter:Connect(function()
                if not IsActive then
                    return
                end
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = HoverColor,
                }):Play()
            end)
            TextBtn.MouseLeave:Connect(function()
                if not IsActive then
                    return
                end
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = ActiveColor,
                }):Play()
            end)

            TextBtn.MouseButton1Click:Connect(function()
                if not IsActive then
                    return
                end
                if ButtonInfo.Callback then
                    ButtonInfo.Callback(Dialog)
                end
                if Info.AutoDismiss then
                    Dialog:Dismiss()
                end
            end)

            if WaitTime > 0 then
                TweenService
                    :Create(ProgressBar, TweenInfo.new(WaitTime, Enum.EasingStyle.Linear), {
                        Size = UDim2.new(1, 0, 0, 2),
                    })
                    :Play()

                task.delay(WaitTime, function()
                    ButtonWrap:SetDisabled(false)
                    if ProgressBar then
                        TweenService
                            :Create(ProgressBar, Library.TweenInfo, {
                                BackgroundTransparency = 1,
                            })
                            :Play()
                    end
                end)
            end

            FooterButtonsList[ButtonIdx] = ButtonWrap
        end

        for BIdx, BInfo in Info.FooterButtons do
            if type(BIdx) == "number" and BInfo.Id then
                BIdx = BInfo.Id
            end
            Dialog:AddFooterButton(BIdx, BInfo)
        end

        setmetatable(Dialog, BaseGroupbox)
        Library.Dialogues[Idx] = Dialog

        Dialog:Resize()

        Library.ActiveDialog = Dialog
        return Dialog
    end

    local GuiProperties = { "BackgroundTransparency" }
    local ImageProperties = { "BackgroundTransparency", "ImageTransparency" }
    local TextProperties = { "BackgroundTransparency", "TextTransparency" }
    local StrokeProperties = { "Transparency" }

    local function FadeInstance(Desc, Properties)
        local Cache = TransparencyCache[Desc]
        if not Cache then
            Cache = {}
            TransparencyCache[Desc] = Cache
        end

        for _, Prop in Properties do
            if not Library.Toggled then
                Cache[Prop] = Desc[Prop]
            end

            if Cache[Prop] ~= nil and Cache[Prop] ~= 1 then
                TweenService:Create(Desc, Library.WindowAnimationInfo, {
                    [Prop] = Library.Toggled and Cache[Prop] or 1,
                }):Play()
            end
        end
    end

    function Window:Toggle(Value: boolean?)
        if Fading then
            return
        end

        if Library.ActiveLoading then
            if Value == true then
                return
            end

            if not Library.Toggled then
                return
            end
        end

        if typeof(Value) == "boolean" then
            Library.Toggled = Value
        else
            Library.Toggled = not Library.Toggled
        end

        if UpdateMobileLockButton then
            UpdateMobileLockButton()
        end
        if not Library.Toggled and SetMobileActionMenuVisible then
            SetMobileActionMenuVisible(false)
        end
        if GlassBlurEffect then
            GlassBlurEffect.Enabled = Library.Toggled
                and WindowInfo.GlassBlur
                and Library.GlassEnabled
        end

        if Library.Animations and Library.Animations.ToggleWindow == true then
            local FadeTime = Library.WindowAnimationInfo.Time
            Fading = true

            if Library.Toggled then
                MainFrame.Visible = true
            end

            if Library.Toggled then
                FadeInstance(MainFrame, { "BackgroundTransparency" })
                task.wait(FadeTime / 2)
            else
                task.delay(FadeTime / 2, FadeInstance, MainFrame, { "BackgroundTransparency" })
            end

            for _, Instance in MainFrame:GetDescendants() do
                if Instance == TopBar then
                    continue
                end

                if Instance:IsA("GuiObject") then
                    local ClassName = Instance.ClassName
                    if ClassName == "ImageLabel" or ClassName == "ImageButton" then
                        FadeInstance(Instance, ImageProperties)
                    elseif
                        ClassName == "TextLabel"
                        or ClassName == "TextBox"
                        or ClassName == "TextButton"
                    then
                        FadeInstance(Instance, TextProperties)
                    else
                        FadeInstance(Instance, GuiProperties)
                    end
                elseif Instance.ClassName == "UIStroke" then
                    FadeInstance(Instance, StrokeProperties)
                end
            end

            task.delay(FadeTime, function()
                MainFrame.Visible = Library.Toggled
                Fading = false
            end)
        else
            MainFrame.Visible = Library.Toggled
        end

        if WindowInfo.UnlockMouseWhileOpen then
            ModalElement.Modal = Library.Toggled
        end

        if Library.Toggled and not Library.IsMobile then
            local OldMouseIconEnabled = UserInputService.MouseIconEnabled
            local ShowCursorBinding = Library.ShowCursorBinding
            pcall(function()
                RunService:UnbindFromRenderStep(ShowCursorBinding)
            end)
            RunService:BindToRenderStep(
                ShowCursorBinding,
                Enum.RenderPriority.Last.Value,
                function()
                    UserInputService.MouseIconEnabled = not Library.ShowCustomCursor

                    Cursor.Position = UDim2.fromOffset(Mouse.X, Mouse.Y)
                    Cursor.Visible = Library.ShowCustomCursor

                    if not (Library.Toggled and ScreenGui and ScreenGui.Parent) then
                        UserInputService.MouseIconEnabled = OldMouseIconEnabled
                        Cursor.Visible = false
                        RunService:UnbindFromRenderStep(ShowCursorBinding)
                    end
                end
            )
        elseif not Library.Toggled then
            TooltipLabel.Visible = false

            for _, Option in Library.Options do
                if Option.Type == "ColorPicker" then
                    Option.ColorMenu:Close()
                    Option.ContextMenu:Close()
                elseif Option.Type == "Dropdown" or Option.Type == "KeyPicker" then
                    Option.Menu:Close()
                end
            end
        end
    end

    function Window:Open()
        Window:Toggle(true)
    end

    function Window:Close()
        Window:Toggle(false)
    end

    function Library:Toggle(Value: boolean?)
        return Window:Toggle(Value)
    end

    if WindowInfo.EnableSidebarResize then
        local Threshold = (WindowInfo.MinSidebarWidth + WindowInfo.SidebarCompactWidth)
            * WindowInfo.SidebarCollapseThreshold
        local StartPos, StartWidth
        local Dragging = false
        local Changed

        local SidebarGrabber = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.new(0, 8, 1, 0),
            Text = "",
            Parent = DividerLine,
        })
        SidebarGrabber.MouseEnter:Connect(function()
            TweenService
                :Create(DividerLine, Library.TweenInfo, {
                    BackgroundColor3 = Library:GetLighterColor(Library.Scheme.OutlineColor),
                })
                :Play()
        end)
        SidebarGrabber.MouseLeave:Connect(function()
            if Dragging then
                return
            end
            TweenService:Create(DividerLine, Library.TweenInfo, {
                BackgroundColor3 = Library.Scheme.OutlineColor,
            }):Play()
        end)

        SidebarGrabber.InputBegan:Connect(function(Input: InputObject)
            if not IsClickInput(Input) then
                return
            end

            Library.CantDragForced = true

            StartPos = Input.Position
            StartWidth = Window:GetSidebarWidth()
            Dragging = true

            Changed = Input.Changed:Connect(function()
                if Input.UserInputState ~= Enum.UserInputState.End then
                    return
                end

                Library.CantDragForced = false
                TweenService:Create(DividerLine, Library.TweenInfo, {
                    BackgroundColor3 = Library.Scheme.OutlineColor,
                }):Play()

                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end
            end)
        end)

        Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
            if not Library.Toggled or not (ScreenGui and ScreenGui.Parent) then
                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end

                return
            end

            if Dragging and IsHoverInput(Input) then
                local Delta = Input.Position - StartPos
                local Width = StartWidth + Delta.X

                if WindowInfo.DisableCompactingSnap then
                    Window:SetSidebarWidth(Width)
                    return
                end

                if Width > Threshold then
                    Window:SetSidebarWidth(math.max(Width, WindowInfo.MinSidebarWidth))
                else
                    Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
                end
            end
        end))
    end
    if WindowInfo.EnableCompacting and (WindowInfo.SidebarCompacted or MobileCompacted) then
        Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
    end
    if WindowInfo.AutoShow and not Library.ActiveLoading then
        task.spawn(Library.Toggle)
    end

    if Library.IsMobile then
        -- One circular menu control opens a compact action panel for Open, Close, and Lock/Unlock.
        local MobileButtonSize = 52
        local MobileActionSize = 48
        local MobileActionGap = 6
        local MobilePanelHeight = MobileActionSize * 3 + MobileActionGap * 2

        MobileControlHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(MobileButtonSize, MobileButtonSize),
            ZIndex = 10,
            Parent = ScreenGui,
        })

        local ActionPanel = New("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, MobileButtonSize + 8),
            Size = UDim2.fromOffset(MobileActionSize, MobilePanelHeight),
            Visible = false,
            ZIndex = 10,
            Parent = MobileControlHolder,
        })

        SetMobileActionMenuVisible = function(Visible: boolean)
            ActionPanel.Visible = Visible == true
        end

        local function ApplyIcon(
            Button: TextButton,
            IconImage: ImageLabel,
            IconName: string,
            FallbackText: string
        )
            local Icon = Library:GetIcon(IconName)
            if Icon then
                IconImage.Image = Icon.Url
                IconImage.ImageRectOffset = Icon.ImageRectOffset
                IconImage.ImageRectSize = Icon.ImageRectSize
                IconImage.Visible = true
                Button.Text = ""
            else
                IconImage.Visible = false
                Button.Text = FallbackText
            end
        end

        local function CreateCircularButton(
            Parent: Instance,
            Size: number,
            IconName: string,
            FallbackText: string,
            TooltipText: string,
            Callback: () -> ()
        )
            local Button = New("TextButton", {
                Active = true,
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = Library.GlassEnabled
                        and math.max(0.22, Library.GlassTransparency)
                    or 0,
                Size = UDim2.fromOffset(Size, Size),
                Text = FallbackText,
                TextColor3 = "FontColor",
                TextSize = 14,
                ZIndex = 10,
                Parent = Parent,
            })
            Library:AddToRegistry(Button, {
                BackgroundColor3 = "MainColor",
                TextColor3 = "FontColor",
            })
            local ButtonSurface = {
                Instance = Button,
                OpaqueTransparency = 0,
            }
            table.insert(Library.GlassSurfaces, ButtonSurface)
            RefreshGlassSurface(ButtonSurface)
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = Button,
            })
            AddGlassPressFeedback(Button)
            local GlassControlStroke = New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = "AccentColor",
                Thickness = 1,
                Transparency = Library.GlassEnabled
                        and math.max(0.18, Library.GlassStrokeTransparency)
                    or 1,
                Parent = Button,
            })
            table.insert(Library.GlassStrokes, GlassControlStroke)
            local GlassControlGradient = New("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 250, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 113, 137)),
                }),
                Rotation = 45,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.72),
                    NumberSequenceKeypoint.new(1, 0.9),
                }),
                Enabled = Library.GlassEnabled,
                Parent = Button,
            })
            table.insert(Library.GlassGradients, GlassControlGradient)

            local IconImage = New("ImageLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                ImageColor3 = "FontColor",
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(math.floor(Size * 0.5), math.floor(Size * 0.5)),
                Visible = false,
                ZIndex = 11,
                Parent = Button,
            })

            ApplyIcon(Button, IconImage, IconName, FallbackText)
            Library:AddTooltip(TooltipText, "", Button)

            -- Some mobile/executor UI hosts expose MouseButton1Click more reliably than Activated.
            -- Use both while debouncing to guarantee each tap triggers one action only.
            local LastActivation = -math.huge
            local function Activate()
                local Now = os.clock()
                if Now - LastActivation < 0.1 then
                    return
                end
                LastActivation = Now
                Library:SafeCallback(Callback)
            end
            Library:GiveSignal(Button.Activated:Connect(Activate))
            Library:GiveSignal(Button.MouseButton1Click:Connect(Activate))

            return Button, IconImage
        end

        local MenuButton, MenuIcon = CreateCircularButton(
            MobileControlHolder,
            MobileButtonSize,
            "menu",
            "Menu",
            "Open mobile actions",
            function()
                -- Tap-to-open is handled by the launcher drag logic below so that
                -- dragging the launcher does not also toggle the action panel.
            end
        )

        -- Make the circular launcher draggable. A short tap toggles the action
        -- panel; a drag (more than a few pixels) repositions the launcher and is
        -- remembered so viewport/orientation changes no longer reset it.
        local LauncherDragging = false
        local LauncherStartInput = nil
        local LauncherStartPos = nil
        local LauncherMoved = false
        local LauncherDragThreshold = 6

        MenuButton.InputBegan:Connect(function(Input: InputObject)
            if not IsClickInput(Input) then
                return
            end

            LauncherDragging = true
            LauncherMoved = false
            LauncherStartInput = Input
            LauncherStartPos = MobileControlHolder.Position
        end)

        Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
            if not LauncherDragging or not LauncherStartInput or not IsHoverInput(Input) then
                return
            end

            local Delta = Input.Position - LauncherStartInput.Position
            if Delta.Magnitude > LauncherDragThreshold then
                LauncherMoved = true
                MobileControlsUserMoved = true
            end

            MobileControlHolder.Position = UDim2.new(
                LauncherStartPos.X.Scale,
                LauncherStartPos.X.Offset + Delta.X,
                LauncherStartPos.Y.Scale,
                LauncherStartPos.Y.Offset + Delta.Y
            )
        end))

        Library:GiveSignal(UserInputService.InputEnded:Connect(function(Input: InputObject)
            if not LauncherDragging or not LauncherStartInput then
                return
            end

            if Input.UserInputType ~= LauncherStartInput.UserInputType then
                return
            end

            LauncherDragging = false
            if not LauncherMoved then
                SetMobileActionMenuVisible(not ActionPanel.Visible)
            end
            LauncherStartInput = nil
        end))
        local OpenButton, OpenIcon = CreateCircularButton(
            ActionPanel,
            MobileActionSize,
            "menu",
            "Open",
            "Open menu",
            function()
                Window:Open()
                if Library.Toggled then
                    SetMobileActionMenuVisible(false)
                end
            end
        )
        local CloseButton = CreateCircularButton(
            ActionPanel,
            MobileActionSize,
            "x",
            "Close",
            "Close menu",
            function()
                Window:Close()
                if not Library.Toggled then
                    SetMobileActionMenuVisible(false)
                end
            end
        )
        local LockButton, LockIcon = CreateCircularButton(
            ActionPanel,
            MobileActionSize,
            "lock",
            "Lock",
            "Lock menu position",
            function()
                Library.CantDragForced = not Library.CantDragForced
                UpdateMobileLockButton()
            end
        )

        -- Give the close action a subtle red liquid-glass tint without losing the glass treatment.
        Library:AddToRegistry(CloseButton, {
            BackgroundColor3 = "DestructiveColor",
            TextColor3 = "WhiteColor",
        })
        CloseButton.BackgroundColor3 = Library.Scheme.DestructiveColor
        CloseButton.TextColor3 = Library.Scheme.WhiteColor
        local CloseStroke = CloseButton:FindFirstChildOfClass("UIStroke")
        if CloseStroke then
            CloseStroke.Color = Library.Scheme.DestructiveColor
        end
        local CloseGradient = CloseButton:FindFirstChildOfClass("UIGradient")
        if CloseGradient then
            CloseGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 178, 178)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 28, 45)),
            })
        end

        -- Brand the primary mobile open actions with the bundled Cyan logo.
        local CyanLogo = Library.ImageManager.GetAsset("CyanLogo")
        if CyanLogo then
            for _, IconImage in { MenuIcon, OpenIcon } do
                IconImage.Image = CyanLogo
                IconImage.ImageRectOffset = Vector2.zero
                IconImage.ImageRectSize = Vector2.zero
                IconImage.ImageColor3 = Color3.new(1, 1, 1)
                IconImage.Visible = true
            end
            MenuButton.Text = ""
            OpenButton.Text = ""
        end

        OpenButton.Position = UDim2.fromOffset(0, 0)
        CloseButton.Position = UDim2.fromOffset(0, MobileActionSize + MobileActionGap)
        LockButton.Position = UDim2.fromOffset(0, (MobileActionSize + MobileActionGap) * 2)

        UpdateMobileLockButton = function()
            if Library.CantDragForced then
                ApplyIcon(LockButton, LockIcon, "lock-open", "Unlock")
                Library:AddToRegistry(LockButton, {
                    BackgroundColor3 = "DestructiveColor",
                    TextColor3 = "BackgroundColor",
                })
                LockButton.BackgroundColor3 = Library.Scheme.DestructiveColor
                local LockStroke = LockButton:FindFirstChildOfClass("UIStroke")
                if LockStroke then
                    LockStroke.Color = Library.Scheme.DestructiveColor
                end
            else
                ApplyIcon(LockButton, LockIcon, "lock", "Lock")
                Library:AddToRegistry(LockButton, {
                    BackgroundColor3 = "AccentColor",
                    TextColor3 = "BackgroundColor",
                })
                LockButton.BackgroundColor3 = Library.Scheme.AccentColor
                local LockStroke = LockButton:FindFirstChildOfClass("UIStroke")
                if LockStroke then
                    LockStroke.Color = Library.Scheme.AccentColor
                end
            end
        end
        UpdateMobileLockButton()

        SetMobileActionMenuVisible = function(Visible: boolean)
            local ShowActions = Visible == true
            ActionPanel.Visible = ShowActions
            if ShowActions then
                OpenButton.Visible = not Library.Toggled
                CloseButton.Visible = Library.Toggled
                LockButton.Visible = Library.Toggled
            end
        end

        Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
            if not ActionPanel.Visible or not IsClickInput(Input, true) then
                return
            end

            local Position = Input.Position
            if
                not (
                    Library:MouseIsOverFrame(MobileControlHolder, Position)
                    or Library:MouseIsOverFrame(ActionPanel, Position)
                )
            then
                SetMobileActionMenuVisible(false)
            end
        end))

        local MobileControlsUserMoved = false
        local function PositionMobileControls()
            -- Once the user has repositioned the launcher, stop auto-pinning it to
            -- the safe area so orientation/viewport changes no longer reset it.
            if MobileControlsUserMoved then
                return
            end

            local SafeTopLeft, SafeBottomRight = GetSafeAreaInsets()
            local EdgePadding = 6
            if WindowInfo.MobileButtonsSide == "Right" then
                MobileControlHolder.AnchorPoint = Vector2.new(1, 0)
                MobileControlHolder.Position =
                    UDim2.new(1, -(SafeBottomRight.X + EdgePadding), 0, SafeTopLeft.Y + EdgePadding)
            else
                MobileControlHolder.AnchorPoint = Vector2.new(0, 0)
                MobileControlHolder.Position =
                    UDim2.fromOffset(SafeTopLeft.X + EdgePadding, SafeTopLeft.Y + EdgePadding)
            end
        end
        PositionMobileControls()

        if WindowInfo.ShowMobileButtons == false then
            MobileControlHolder.Visible = false
        end

        Window:RefreshMobileLayout()
        local function RefreshForViewport()
            Window:RefreshMobileLayout()
            PositionMobileControls()
        end
        if workspace.CurrentCamera then
            Library:GiveSignal(
                workspace.CurrentCamera
                    :GetPropertyChangedSignal("ViewportSize")
                    :Connect(RefreshForViewport)
            )
        end
        Library:GiveSignal(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            if workspace.CurrentCamera then
                Library:GiveSignal(
                    workspace.CurrentCamera
                        :GetPropertyChangedSignal("ViewportSize")
                        :Connect(RefreshForViewport)
                )
            end
            RefreshForViewport()
        end))
    end

    if Library.IsMobile and WindowInfo.EnableTabSwipeNavigation then
        local SwipeStart: Vector2? = nil
        local SwipeInput: InputObject? = nil
        Library:GiveSignal(
            UserInputService.InputBegan:Connect(
                function(Input: InputObject, GameProcessedEvent: boolean)
                    if GameProcessedEvent or Input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end
                    if
                        not Library.Toggled
                        or UserInputService:GetFocusedTextBox()
                        or CurrentMenu
                        or Library.ActiveDialog
                    then
                        return
                    end
                    if not Library:MouseIsOverFrame(Container, Input.Position) then
                        return
                    end

                    SwipeInput = Input
                    SwipeStart = Input.Position
                end
            )
        )
        Library:GiveSignal(UserInputService.InputEnded:Connect(function(Input: InputObject)
            if Input ~= SwipeInput or not SwipeStart then
                return
            end

            local Delta = Input.Position - SwipeStart
            SwipeInput = nil
            SwipeStart = nil
            if
                math.abs(Delta.X) < WindowInfo.TabSwipeNavigationThreshold
                or math.abs(Delta.X) <= math.abs(Delta.Y)
            then
                return
            end

            if Delta.X < 0 then
                Window:NextTab()
            else
                Window:PreviousTab()
            end
        end))
    end

    --// Execution \\--
    Library:GiveSignal(SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        Library:UpdateSearch(SearchBox.Text)
    end))

    Library:GiveSignal(
        UserInputService.InputBegan:Connect(
            function(Input: InputObject, GameProcessedEvent: boolean)
                if Library.Unloaded then
                    return
                end

                local FocusedTextBox = UserInputService:GetFocusedTextBox()
                if FocusedTextBox then
                    local IsLibraryTextBox = FocusedTextBox:IsDescendantOf(ScreenGui)
                    if Library.ActiveLoading and Library.ActiveLoading.ScreenGui then
                        IsLibraryTextBox = IsLibraryTextBox
                            or FocusedTextBox:IsDescendantOf(Library.ActiveLoading.ScreenGui)
                    end

                    -- Escape should never steal focus from chat or another experience-owned text box.
                    if Input.KeyCode == Enum.KeyCode.Escape and IsLibraryTextBox then
                        FocusedTextBox:ReleaseFocus()
                    end
                    return
                end

                if GameProcessedEvent then
                    return
                end

                local IsControlDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
                    or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
                if IsControlDown and Input.KeyCode == Enum.KeyCode.K and Window:FocusSearch() then
                    return
                end
                if
                    IsControlDown
                    and Input.KeyCode == Enum.KeyCode.PageDown
                    and Window:NextTab()
                then
                    return
                end
                if
                    IsControlDown
                    and Input.KeyCode == Enum.KeyCode.PageUp
                    and Window:PreviousTab()
                then
                    return
                end

                if Input.KeyCode == Library.ToggleKeybind then
                    Library:Toggle()
                end
            end
        )
    )

    Library:GiveSignal(UserInputService.WindowFocused:Connect(function()
        Library.IsRobloxFocused = true
    end))
    Library:GiveSignal(UserInputService.WindowFocusReleased:Connect(function()
        Library.IsRobloxFocused = false
    end))

    ApplyGlassGradientProfile(WindowInfo.GlassPreset)
    UpdateGlassSheen()
    UpdateGlassBackdropMotion()
    Library:OnUnload(function()
        if GlassGradientTween then
            StopTween(GlassGradientTween, true)
            GlassGradientTween = nil
        end
        for Index = #GlassBackdropTweens, 1, -1 do
            StopTween(GlassBackdropTweens[Index], true)
            table.remove(GlassBackdropTweens, Index)
        end
    end)
    Library.Window = Window
    return Window
end

function Library:CreateLoading(LoadingInfo)
    if Library.ActiveLoading then
        warn("Loading GUI already exists, you cannot create multiple Loading GUIs.")
        return Library.ActiveLoading
    end

    LoadingInfo = Library:Validate(LoadingInfo, Templates.Loading)

    local Loading = {
        CurrentStep = LoadingInfo.CurrentStep,
        TotalSteps = LoadingInfo.TotalSteps,

        ShowSidebar = LoadingInfo.ShowSidebar,
        AutoResizeHeight = LoadingInfo.AutoResizeHeight,
        IsError = false,
        Destroyed = false,

        WindowWidth = LoadingInfo.WindowWidth,
        WindowHeight = LoadingInfo.WindowHeight,
        BaseWindowHeight = LoadingInfo.WindowHeight,
        WindowErrorHeight = LoadingInfo.WindowHeight,

        ContentWidth = LoadingInfo.ContentWidth,
        SidebarWidth = LoadingInfo.SidebarWidth,
    }

    --// ScreenGui \\--
    local ScreenGui = New("ScreenGui", {
        Name = "CyanLoading",
        DisplayOrder = 999,
        ResetOnSpawn = false,
    })
    ParentUI(ScreenGui)
    Loading.ScreenGui = ScreenGui

    ScreenGui.DescendantRemoving:Connect(function(Instance)
        Library:RemoveFromRegistry(Instance)
    end)

    --// Main Frame \\--
    local MainFrame = New("TextButton", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = function()
            return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
        end,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(
            Loading.ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth)
                or Loading.WindowWidth,
            Loading.WindowHeight
        ),
        ClipsDescendants = true,
        Text = "",
        AutoButtonColor = false,
        Parent = ScreenGui,
    })
    Library:AddOutline(MainFrame)
    table.insert(
        Library.Corners,
        New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = MainFrame })
    )

    local MainScale = New("UIScale", {
        Scale = Library.IsMobile and 0.8 or 1,
        Parent = MainFrame,
    })
    table.insert(Library.Scales, MainScale)
    Library.ScalesOffset[MainScale] = Library.IsMobile and 0.2 or 0

    --// Layout Containers \\--
    local Container = New("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, Loading.ContentWidth, 1, 0),
        Parent = MainFrame,
    })

    local SideBar = New("Frame", {
        Name = "SideBar",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(Loading.ContentWidth, 0),
        Size = UDim2.new(0, Loading.ShowSidebar and Loading.SidebarWidth or 0, 1, 0),
        ClipsDescendants = true,
        Visible = Loading.ShowSidebar,
        Parent = MainFrame,
    })
    local SidebarCorner =
        New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = SideBar })
    table.insert(Library.Corners, SidebarCorner)

    Library:AddOutline(SideBar)

    local SidebarDivider = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        Visible = Loading.ShowSidebar,
        Parent = SideBar,
    })

    --// Top Bar \\--
    local TopBar = New("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 48),
        ZIndex = 2,
        Parent = Container,
    })
    Library:MakeDraggable(MainFrame, TopBar, true, true)

    local TitleHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = TopBar,
    })
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        Parent = TitleHolder,
    })
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        Parent = TitleHolder,
    })

    if LoadingInfo.Icon then
        local Icon = Library:GetCustomIcon(LoadingInfo.Icon)
        local _WindowIcon = New("ImageLabel", {
            Image = Icon.Url,
            ImageRectOffset = Icon.ImageRectOffset,
            ImageRectSize = Icon.ImageRectSize,
            Size = LoadingInfo.IconSize,
            Parent = TitleHolder,
        })
    else
        local _WindowIcon = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = LoadingInfo.IconSize,
            Text = LoadingInfo.Title:sub(1, 1),
            TextScaled = true,
            Visible = false,
            Parent = TitleHolder,
        })
    end

    local TitleX = Library:GetTextBounds(
        LoadingInfo.Title,
        Library.Scheme.Font,
        20,
        TitleHolder.AbsoluteSize.X
            - (LoadingInfo.Icon and (LoadingInfo.IconSize.X.Offset + 6) or 0)
            - 12
    )
    local _WindowTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, TitleX, 1, 0),
        Text = LoadingInfo.Title,
        TextSize = 20,
        Parent = TitleHolder,
    })

    Library:MakeLine(Container, {
        Position = UDim2.fromOffset(0, 48),
        Size = UDim2.new(1, 0, 0, 1),
    })

    --// Loading Content Elements \\--
    local InnerContent = New("Frame", {
        Name = "InnerContent",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 49),
        Size = UDim2.new(1, 0, 1, -49),
        Parent = Container,
    })

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 12),
        Parent = InnerContent,
    })

    local IconHolder = New("Frame", {
        Name = "IconHolder",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(64, 64),
        Parent = InnerContent,
    })

    local LoaderIcon = Library:GetCustomIcon(LoadingInfo.LoadingIcon)
    local LoadingIcon = New("ImageLabel", {
        Name = "LoaderIcon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        Image = LoaderIcon.Url,
        ImageRectOffset = LoaderIcon.ImageRectOffset,
        ImageRectSize = LoaderIcon.ImageRectSize,
        ImageColor3 = LoadingInfo.LoadingIconColor
            or (
                (LoadingInfo.LoadingIcon == Templates.Loading.LoadingIcon) and "AccentColor"
                or "WhiteColor"
            ),
        Parent = IconHolder,
    })

    local RotationTween
    if LoadingInfo.LoadingIconTweenTime > 0 then
        RotationTween = TweenService:Create(
            LoadingIcon,
            TweenInfo.new(
                LoadingInfo.LoadingIconTweenTime,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out,
                -1
            ),
            { Rotation = 360 }
        )
        RotationTween:Play()
    end

    local MessageLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
        Text = "",
        TextSize = 18,
        TextWrapped = Loading.AutoResizeHeight,
        Parent = InnerContent,
    })

    local DescriptionLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
        Text = "",
        TextSize = 14,
        TextTransparency = 0.5,
        TextWrapped = Loading.AutoResizeHeight,
        Parent = InnerContent,
    })

    --// Progress Bar \\--
    local SliderBar = New("Frame", {
        BackgroundColor3 = "MainColor",
        Size = UDim2.new(0.7, 0, 0, 15),
        Parent = InnerContent,
    })
    Library:AddOutline(SliderBar)
    table.insert(
        Library.Corners,
        New(
            "UICorner",
            { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderBar }
        )
    )

    local SliderFill = New("Frame", {
        BackgroundColor3 = "AccentColor",
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0, 1),
        Parent = SliderBar,
    })
    table.insert(
        Library.Corners,
        New(
            "UICorner",
            { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderFill }
        )
    )

    local ProgressLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        TextSize = 14,
        ZIndex = 2,
        Parent = SliderBar,
    })
    New("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
        Color = "DarkColor",
        LineJoinMode = Enum.LineJoinMode.Miter,
        Parent = ProgressLabel,
    })

    --// Sidebar Object \\--
    local SidebarScrolling = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Size = UDim2.fromScale(1, 1),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = "OutlineColor",
        Parent = SideBar,
    })
    local SidebarList = New("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = SidebarScrolling,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 12),
        Parent = SidebarScrolling,
    })

    local SidebarObject = {
        Elements = {},
        DependencyBoxes = {},
        Tabboxes = {},

        BoxHolder = SidebarScrolling,
        Container = SidebarScrolling,

        Resize = function(self)
            SidebarScrolling.CanvasSize =
                UDim2.fromOffset(0, SidebarList.AbsoluteContentSize.Y + 24)
        end,
        Tab = {
            Elements = {},
            DependencyBoxes = {},
            DependencyGroupboxes = {},
            Tabboxes = {},
        },
    }

    SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SidebarObject:Resize()
    end)

    setmetatable(SidebarObject, BaseGroupbox)
    Loading.Sidebar = SidebarObject

    --// Error Frame \\--
    local ErrorFrame = New("Frame", {
        Name = "Error",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 49),
        Size = UDim2.new(1, 0, 1, -49),
        ClipsDescendants = true,
        Visible = false,
        Parent = Container,
    })

    local _ErrorTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15, 15),
        Size = UDim2.new(1, -30, 0, 18),
        Text = "Error",
        TextColor3 = "RedColor",
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ErrorFrame,
    })

    local ErrorLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15, 39),
        Size = UDim2.new(1, -30, 1, -90),
        Text = "Error Message",
        TextSize = 14,
        TextTransparency = 0.2,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = ErrorFrame,
    })

    local ErrorButtonsDivider = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 1, -48),
        Size = UDim2.new(1, -30, 0, 1),
        Visible = false,
        Parent = ErrorFrame,
    })

    local ErrorButtonsHolder = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 42),
        Visible = false,
        Parent = ErrorFrame,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = ErrorButtonsHolder,
    })
    New("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        Parent = ErrorButtonsHolder,
    })

    function Loading:UpdateLayout()
        if Loading.IsError then
            Loading:RecalculateErrorHeight()
        end

        local ShowSidebar = Loading.ShowSidebar
        local FinalWidth = ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth)
            or Loading.WindowWidth
        local FinalHeight = Loading.IsError and Loading.WindowErrorHeight or Loading.WindowHeight

        if ShowSidebar then
            SideBar.Visible = true
            SidebarDivider.Visible = true
        end

        TweenService
            :Create(
                MainFrame,
                Library.TweenInfo,
                { Size = UDim2.fromOffset(FinalWidth, FinalHeight) }
            )
            :Play()
        TweenService:Create(SideBar, Library.TweenInfo, {
            Position = UDim2.fromOffset(Loading.ContentWidth, 0),
            Size = UDim2.new(0, ShowSidebar and Loading.SidebarWidth or 0, 1, 0),
        }):Play()
        TweenService
            :Create(Container, Library.TweenInfo, {
                Size = UDim2.new(
                    0,
                    ShowSidebar and Loading.ContentWidth or Loading.WindowWidth,
                    1,
                    0
                ),
            })
            :Play()

        if not ShowSidebar then
            task.delay(Library.TweenInfo.Time, function()
                if not Loading.ShowSidebar then
                    SideBar.Visible = false
                    SidebarDivider.Visible = false
                end
            end)
        end
    end

    --// Content Page \\--
    function Loading:RecalculateLoadingHeight()
        if not Loading.AutoResizeHeight then
            return
        end

        local RequiredHeight = 49 -- TopBar
            + 48 -- Padding
            + InnerContent.UIListLayout.AbsoluteContentSize.Y

        Loading.WindowHeight = math.max(Loading.BaseWindowHeight, RequiredHeight)
    end

    function Loading:SetMessage(Text)
        MessageLabel.Text = Text

        if Loading.AutoResizeHeight then
            Loading:RecalculateLoadingHeight()
            Loading:UpdateLayout()
        end
    end

    function Loading:SetDescription(Text)
        DescriptionLabel.Text = Text

        if Loading.AutoResizeHeight then
            Loading:RecalculateLoadingHeight()
            Loading:UpdateLayout()
        end
    end

    function Loading:SetLoadingIcon(Icon)
        local IconData = Library:GetCustomIcon(Icon)
        LoadingIcon.Image = IconData.Url
        LoadingIcon.ImageRectOffset = IconData.ImageRectOffset
        LoadingIcon.ImageRectSize = IconData.ImageRectSize
    end

    function Loading:SetLoadingIconTweenTime(TweenTime)
        if RotationTween then
            StopTween(RotationTween, true)
            RotationTween = nil
        end

        if TweenTime > 0 then
            RotationTween = TweenService:Create(
                LoadingIcon,
                TweenInfo.new(TweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
                { Rotation = 360 }
            )
            RotationTween:Play()
        else
            LoadingIcon.Rotation = 0
        end
    end

    function Loading:SetLoadingIconColor(Color)
        LoadingIcon.ImageColor3 = Color
    end

    function Loading:SetCurrentStep(Step)
        Loading.CurrentStep = math.clamp(Step, 0, Loading.TotalSteps)

        local Progress = Loading.CurrentStep / Loading.TotalSteps
        TweenService:Create(SliderFill, Library.TweenInfo, { Size = UDim2.fromScale(Progress, 1) })
            :Play()

        ProgressLabel.Text = string.format("%d/%d", Loading.CurrentStep, Loading.TotalSteps)
    end

    function Loading:SetTotalSteps(Steps)
        Loading.TotalSteps = Steps
        Loading:SetCurrentStep(Loading.CurrentStep)
    end

    --// Size \\--
    function Loading:SetWindowHeight(Height)
        Loading.WindowHeight = Height
        Loading:UpdateLayout()
    end

    function Loading:SetWindowWidth(Width)
        Loading.WindowWidth = Width
        Loading:UpdateLayout()
    end

    function Loading:SetContentWidth(Width)
        Loading.ContentWidth = Width
        Loading:UpdateLayout()
    end

    function Loading:SetSidebarWidth(Width)
        Loading.SidebarWidth = Width
        Loading:UpdateLayout()
    end

    --// Sidebar \\--
    function Loading:ShowSidebarPage(Bool)
        Loading.ShowSidebar = Bool
        Loading:UpdateLayout()
    end

    --// Error Page \\--
    function Loading:ShowErrorPage(Enabled)
        Loading.IsError = Enabled
        InnerContent.Visible = not Enabled
        ErrorFrame.Visible = Enabled

        if Loading.ShowSidebar then
            Loading:ShowSidebarPage(not Enabled)
        else
            Loading:UpdateLayout()
        end
    end

    function Loading:RecalculateErrorHeight()
        local TargetWidth = (Loading.ShowSidebar and Loading.ContentWidth or Loading.WindowWidth)
            - 30
        local _, ErrorY =
            Library:GetTextBounds(ErrorLabel.Text, Library.Scheme.Font, 14, TargetWidth)

        ErrorLabel.Size = UDim2.new(1, -30, 0, ErrorY)

        local HasButtons = ErrorButtonsHolder.Visible
        local RequiredHeight = 49 -- TopBar
            + 15 -- Padding Top
            + 18 -- Title Height
            + 6 -- Padding between Title and Label
            + ErrorY -- Label Height
            + 15 -- Padding between Label and Buttons
            + (HasButtons and 48 or 0) -- Buttons Area

        Loading.WindowErrorHeight = RequiredHeight -- math.max(Loading.WindowHeight, RequiredHeight)
    end

    function Loading:SetErrorMessage(Text)
        ErrorLabel.Text = Text
        Loading:UpdateLayout()
    end

    function Loading:SetErrorButtons(Buttons)
        assert(typeof(Buttons) == "table", "Buttons must be a table")

        for _, button in ErrorButtonsHolder:GetChildren() do
            if button:IsA("Frame") then
                button:Destroy()
            end
        end

        local HasButtons = GetTableSize(Buttons) > 0
        ErrorButtonsHolder.Visible = HasButtons
        ErrorButtonsDivider.Visible = HasButtons

        for Idx, ButtonInfo in Buttons do
            local ButtonContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 26),
                Parent = ErrorButtonsHolder,
            })

            local BtnColor = "MainColor"
            local BtnOutline = "OutlineColor"
            local Variant = ButtonInfo.Variant or "Primary"

            if Variant == "Primary" then
                BtnColor = "FontColor"
                BtnOutline = "FontColor"
            elseif Variant == "Secondary" then
                BtnColor = "MainColor"
                BtnOutline = "OutlineColor"
            elseif Variant == "Destructive" then
                BtnColor = "DestructiveColor"
                BtnOutline = "DestructiveColor"
            elseif Variant == "Ghost" then
                BtnColor = "BackgroundColor"
                BtnOutline = "BackgroundColor"
            end

            local TextBtn = New("TextButton", {
                BackgroundColor3 = BtnColor,
                BorderColor3 = BtnOutline,
                Size = UDim2.fromOffset(0, 26),
                Text = "",
                AutoButtonColor = false,
                Parent = ButtonContainer,
            })
            Library:AddOutline(TextBtn)
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius),
                    Parent = TextBtn,
                })
            )

            New("UIPadding", {
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                Parent = TextBtn,
            })

            local TextColor = Library.Scheme.FontColor
            if Variant == "Primary" then
                TextColor = Library.Scheme.BackgroundColor
            elseif Variant == "Destructive" then
                TextColor = Color3.new(1, 1, 1)
            end

            local BtnLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ButtonInfo.Title or Idx,
                TextColor3 = TextColor,
                TextSize = 14,
                Parent = TextBtn,
            })

            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor
                or Library.Scheme[BtnColor]
            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor
                or Library:GetBetterColor(ActiveColor, 10)

            TextBtn.MouseEnter:Connect(function()
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = HoverColor,
                }):Play()
            end)
            TextBtn.MouseLeave:Connect(function()
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = ActiveColor,
                }):Play()
            end)

            TextBtn.MouseButton1Click:Connect(function()
                if ButtonInfo.Callback then
                    ButtonInfo.Callback(Loading)
                end
            end)
        end

        Loading:UpdateLayout()
    end

    --// Destroy/Continue \\--
    function Loading:Destroy()
        if RotationTween then
            StopTween(RotationTween, true)
            RotationTween = nil
        end

        ScreenGui:Destroy()
        Loading.Destroyed = true
        Library.ActiveLoading = nil

        if Library.Toggle and Library.Toggled == false and Library.Unloaded ~= true then
            Library:Toggle(true)
        end
    end

    Loading.Continue = Loading.Destroy

    if Library.Toggle and Library.Toggled and Library.Unloaded ~= true then
        Library:Toggle(false)
    end

    Loading:SetCurrentStep(Loading.CurrentStep)

    Library.ActiveLoading = Loading
    return Loading
end

local function OnPlayerChange()
    if Library.Unloaded then
        return
    end

    local PlayerList, ExcludedPlayerList = GetPlayers(), GetPlayers(true)
    for _, Dropdown in Options do
        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Player" then
            Dropdown:SetValues(Dropdown.ExcludeLocalPlayer and ExcludedPlayerList or PlayerList)
        end
    end
end

local function OnTeamChange()
    if Library.Unloaded then
        return
    end

    local TeamList = GetTeams()
    for _, Dropdown in Options do
        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Team" then
            Dropdown:SetValues(TeamList)
        end
    end
end

Library:GiveSignal(Players.PlayerAdded:Connect(OnPlayerChange))
Library:GiveSignal(Players.PlayerRemoving:Connect(OnPlayerChange))

Library:GiveSignal(Teams.ChildAdded:Connect(OnTeamChange))
Library:GiveSignal(Teams.ChildRemoved:Connect(OnTeamChange))

function Library:Unload()
    Library.Unloaded = true

    --// Disconnect connections
    for Index = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Index)

        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end

    --// Run Unload Callbacks
    for _ = 1, #Library.UnloadSignals do
        local Callback = table.remove(Library.UnloadSignals, 1)

        if Callback then
            Library:SafeCallback(Callback)
        end
    end

    --// Destroy elements
    for Index = #Library.Tabs, 1, -1 do
        local Tab = table.remove(Library.Tabs, Index)

        if Tab and Tab.Destroy then
            Library:SafeCallback(Tab.Destroy, Tab)
        end
    end

    for Index = #Tooltips, 1, -1 do
        local Tooltip = table.remove(Tooltips, Index)

        if Tooltip and Tooltip.Destroy then
            Library:SafeCallback(Tooltip.Destroy, Tooltip)
        end
    end

    if Library.ActiveLoading then
        Library.ActiveLoading:Destroy()
    end

    if ScreenGui then
        ScreenGui:Destroy()
    end

    for Index = #Library.GlassBlurEffects, 1, -1 do
        local Effect = table.remove(Library.GlassBlurEffects, Index)
        if Effect then
            Effect:Destroy()
        end
    end

    --// Clear tables
    table.clear(Library.Registry)

    table.clear(Options)
    table.clear(Toggles)
    table.clear(Buttons)
    table.clear(Labels)
    table.clear(Tooltips)

    table.clear(Library.Tabs)
    table.clear(Library.TabButtons)
    table.clear(Library.TabOrder)

    table.clear(Library.Scales)
    table.clear(Library.ScalesOffset)

    table.clear(Library.Corners)
    table.clear(Library.SpecificCorners)
    table.clear(Library.GlassSurfaces)
    table.clear(Library.GlassStrokes)
    table.clear(Library.GlassGradients)
    table.clear(Library.GlassBlurEffects)

    table.clear(Library.Notifications)
    table.clear(Library.Dialogues)
    table.clear(Library.DraggableElements)
    table.clear(Library.KeybindToggles)
    table.clear(Library.DependencyBoxes)

    table.clear(TransparencyCache)
    table.clear(ActiveTabTweens)

    Library.Toggle = function(...) end
    Library.ScreenGui = nil
    Library.WindowContainer = nil
    Library.KeybindFrame = nil
    Library.KeybindContainer = nil

    getgenv().Library = nil
end

getgenv().Library = Library
return Library
]=]))()

--// addons/ThemeManager.lua //--
local ThemeManager = (loadstring([[
local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func)
    return func
end)

local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local isfolder, isfile, listfiles = isfolder, isfile, listfiles
local makefolder, readfile, writefile, delfile = makefolder, readfile, writefile, delfile

if typeof(clonefunction) == "function" then
    -- Some third-party environments expose predicate APIs that throw. Normalize them to safe results.

    local isfolder_copy, isfile_copy, listfiles_copy =
        clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)

    local isfolder_success, isfolder_error = pcall(function()
        return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
    end)

    if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
        isfolder = function(folder)
            local success, data = pcall(isfolder_copy, folder)
            return (if success then data else false)
        end

        isfile = function(file)
            local success, data = pcall(isfile_copy, file)
            return (if success then data else false)
        end

        listfiles = function(folder)
            local success, data = pcall(listfiles_copy, folder)
            return (if success then data else {})
        end
    end
end

local SchemeIndexes = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
local ThemeManager = {
    Library = nil,

    Folder = "CyanLibSettings",

    AppliedToTab = false,
    DefaultThemeName = nil,

    BuiltInThemes = {
        -- Stable Cyan palette. Unlike "Default", this is never changed by SetDefaultTheme.
        ["Cyan"] = {
            0,
            {
                FontColor = "eafdff",
                MainColor = "0d2138",
                AccentColor = "38e0eb",
                BackgroundColor = "061522",
                OutlineColor = "1c5a73",
                BackgroundImage = "",
            },
        },
        ["Default"] = {
            1,
            {
                FontColor = "eafdff",
                MainColor = "0d2138",
                AccentColor = "38e0eb",
                BackgroundColor = "061522",
                OutlineColor = "1c5a73",
                BackgroundImage = "",
            },
        },
        ["BBot"] = {
            2,
            {
                FontColor = "ffffff",
                MainColor = "1e1e1e",
                AccentColor = "7e48a3",
                BackgroundColor = "232323",
                OutlineColor = "141414",
                BackgroundImage = "",
            },
        },
        ["Fatality"] = {
            3,
            {
                FontColor = "ffffff",
                MainColor = "1e1842",
                AccentColor = "c50754",
                BackgroundColor = "191335",
                OutlineColor = "3c355d",
                BackgroundImage = "",
            },
        },
        ["Jester"] = {
            4,
            {
                FontColor = "ffffff",
                MainColor = "242424",
                AccentColor = "db4467",
                BackgroundColor = "1c1c1c",
                OutlineColor = "373737",
                BackgroundImage = "",
            },
        },
        ["Mint"] = {
            5,
            {
                FontColor = "ffffff",
                MainColor = "242424",
                AccentColor = "3db488",
                BackgroundColor = "1c1c1c",
                OutlineColor = "373737",
                BackgroundImage = "",
            },
        },
        ["Tokyo Night"] = {
            6,
            {
                FontColor = "ffffff",
                MainColor = "191925",
                AccentColor = "6759b3",
                BackgroundColor = "16161f",
                OutlineColor = "323232",
                BackgroundImage = "",
            },
        },
        ["Ubuntu"] = {
            7,
            {
                FontColor = "ffffff",
                MainColor = "3e3e3e",
                AccentColor = "e2581e",
                BackgroundColor = "323232",
                OutlineColor = "191919",
                BackgroundImage = "",
            },
        },
        ["Quartz"] = {
            8,
            {
                FontColor = "ffffff",
                MainColor = "232330",
                AccentColor = "426e87",
                BackgroundColor = "1d1b26",
                OutlineColor = "27232f",
                BackgroundImage = "",
            },
        },
        ["Nord"] = {
            9,
            {
                FontColor = "eceff4",
                MainColor = "3b4252",
                AccentColor = "88c0d0",
                BackgroundColor = "2e3440",
                OutlineColor = "4c566a",
                BackgroundImage = "",
            },
        },
        ["Dracula"] = {
            10,
            {
                FontColor = "f8f8f2",
                MainColor = "44475a",
                AccentColor = "ff79c6",
                BackgroundColor = "282a36",
                OutlineColor = "6272a4",
                BackgroundImage = "",
            },
        },
        ["Monokai"] = {
            11,
            {
                FontColor = "f8f8f2",
                MainColor = "272822",
                AccentColor = "f92672",
                BackgroundColor = "1e1f1c",
                OutlineColor = "49483e",
                BackgroundImage = "",
            },
        },
        ["Gruvbox"] = {
            12,
            {
                FontColor = "ebdbb2",
                MainColor = "3c3836",
                AccentColor = "fb4934",
                BackgroundColor = "282828",
                OutlineColor = "504945",
                BackgroundImage = "",
            },
        },
        ["Solarized"] = {
            13,
            {
                FontColor = "839496",
                MainColor = "073642",
                AccentColor = "cb4b16",
                BackgroundColor = "002b36",
                OutlineColor = "586e75",
                BackgroundImage = "",
            },
        },
        ["Catppuccin"] = {
            14,
            {
                FontColor = "d9e0ee",
                MainColor = "302d41",
                AccentColor = "f5c2e7",
                BackgroundColor = "1e1e2e",
                OutlineColor = "575268",
                BackgroundImage = "",
            },
        },
        ["One Dark"] = {
            15,
            {
                FontColor = "abb2bf",
                MainColor = "282c34",
                AccentColor = "c678dd",
                BackgroundColor = "21252b",
                OutlineColor = "5c6370",
                BackgroundImage = "",
            },
        },
        ["Cyberpunk"] = {
            16,
            {
                FontColor = "f9f9f9",
                MainColor = "262335",
                AccentColor = "00ff9f",
                BackgroundColor = "1a1a2e",
                OutlineColor = "413c5e",
                BackgroundImage = "",
            },
        },
        ["Oceanic Next"] = {
            17,
            {
                FontColor = "d8dee9",
                MainColor = "1b2b34",
                AccentColor = "6699cc",
                BackgroundColor = "16232a",
                OutlineColor = "343d46",
                BackgroundImage = "",
            },
        },
        ["Material"] = {
            18,
            {
                FontColor = "eeffff",
                MainColor = "212121",
                AccentColor = "82aaff",
                BackgroundColor = "151515",
                OutlineColor = "424242",
                BackgroundImage = "",
            },
        },
        -- Professional showcase palettes (added in 26.8.0). Each is a complete,
        -- high-contrast scheme tuned for long sessions on desktop and mobile.
        ["Cyan Pro"] = {
            15,
            {
                FontColor = "eafdff",
                MainColor = "0d2138",
                AccentColor = "38e0eb",
                BackgroundColor = "061522",
                OutlineColor = "1c5a73",
                BackgroundImage = "",
            },
        },
        ["Midnight"] = {
            16,
            {
                FontColor = "dde3ff",
                MainColor = "141a33",
                AccentColor = "6c7bff",
                BackgroundColor = "0b0f1f",
                OutlineColor = "2a3358",
                BackgroundImage = "",
            },
        },
        ["Aurora"] = {
            17,
            {
                FontColor = "e8fff6",
                MainColor = "122a23",
                AccentColor = "34d399",
                BackgroundColor = "0a1a16",
                OutlineColor = "1f5042",
                BackgroundImage = "",
            },
        },
        ["Graphite"] = {
            18,
            {
                FontColor = "f2f2f2",
                MainColor = "1c1c1f",
                AccentColor = "38bdf8",
                BackgroundColor = "141417",
                OutlineColor = "2e2e34",
                BackgroundImage = "",
            },
        },
        ["Bloom"] = {
            19,
            {
                FontColor = "fde8f3",
                MainColor = "2a1530",
                AccentColor = "ec4899",
                BackgroundColor = "1a0f1f",
                OutlineColor = "43214d",
                BackgroundImage = "",
            },
        },
    },
}

function ThemeManager:SetLibrary(Library)
    ThemeManager.Library = Library
end

function ThemeManager:IsSupported(): (boolean, string?)
    local RequiredFunctions = {
        isfolder = isfolder,
        isfile = isfile,
        listfiles = listfiles,
        makefolder = makefolder,
        readfile = readfile,
        writefile = writefile,
        delfile = delfile,
    }

    for Name, Func in RequiredFunctions do
        if typeof(Func) ~= "function" then
            return false, string.format("Missing filesystem capability: %s", Name)
        end
    end

    return true
end

--// Filesystem helpers \\--
local function TryFileSystemCall(Func: any, ...: any): (boolean, any)
    if typeof(Func) ~= "function" then
        return false, "Filesystem capability is unavailable"
    end

    return pcall(Func, ...)
end

local function SafeIsFolder(Path: string): boolean
    local Success, Result = TryFileSystemCall(isfolder, Path)
    return Success and Result == true
end

local function SafeIsFile(Path: string): boolean
    local Success, Result = TryFileSystemCall(isfile, Path)
    return Success and Result == true
end

local function EnsureFolder(Path: string): (boolean, string?)
    if SafeIsFolder(Path) then
        return true
    end

    local Success, ErrorMessage = TryFileSystemCall(makefolder, Path)
    if Success or SafeIsFolder(Path) then
        return true
    end

    return false, string.format("Failed to create folder %q: %s", Path, tostring(ErrorMessage))
end

local function Notify(Message: string)
    local Library = ThemeManager.Library
    if Library and typeof(Library.Notify) == "function" then
        Library:Notify(Message)
    end
end

--// Helpers \\--
local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end

local function IsStringEmpty(String: string): boolean
    return if typeof(String) == "string" then Trim(String) == "" else true
end

local function IsValidFolderPath(Name: string): boolean
    if typeof(Name) ~= "string" then
        return false
    end

    Name = Trim(Name)
    if Name == "" or Name:find('[<>:"|%?%*%z]') or Name:find("\\", 1, true) then
        return false
    end
    if Name:sub(1, 1) == "/" or Name:find("//", 1, true) then
        return false
    end

    for Segment in string.gmatch(Name, "[^/]+") do
        if Segment == "." or Segment == ".." then
            return false
        end
    end

    return true
end

local function IsValidThemeName(Name: string): boolean
    if typeof(Name) ~= "string" then
        return false
    end

    Name = Trim(Name)
    return Name ~= ""
        and Name ~= "."
        and Name ~= ".."
        and not Name:find("/", 1, true)
        and not Name:find("\\", 1, true)
        and not Name:find('[<>:"|%?%*%z]')
end

--// Folder helper \\--
local function SplitPath(Path: string): { string }
    local Result = {}
    local Current = ""

    for Part in string.gmatch(Path, "[^/]+") do
        Current = if Current == "" then Part else (Current .. "/" .. Part)
        table.insert(Result, Current)
    end

    return Result
end

local function GetFolderPath(): false | string
    if IsStringEmpty(ThemeManager.Folder) then
        return false
    end

    return string.format("%s/themes", ThemeManager.Folder)
end

local GetCurrentThemesPath = GetFolderPath

--// Files helper \\--
local function GetThemePath(ThemeName: string): false | string
    if not IsValidThemeName(ThemeName) then
        return false
    end

    local CurrentThemesPath = GetCurrentThemesPath()
    return if CurrentThemesPath == false
        then false
        else string.format("%s/%s.json", CurrentThemesPath, ThemeName)
end

local function DoesThemeExist(ThemeName: string, IncludeBuiltIn: boolean): boolean
    if IncludeBuiltIn and ThemeManager.BuiltInThemes[ThemeName] then
        return true
    end

    local ThemePath = GetThemePath(ThemeName)
    return if ThemePath == false then false else SafeIsFile(ThemePath)
end

local function GetDefaultThemePath(): false | string
    local CurrentThemesPath = GetCurrentThemesPath()
    return if CurrentThemesPath == false
        then false
        else string.format("%s/default.txt", CurrentThemesPath)
end

--// Folders \\--
function ThemeManager:GetPaths(): { string }
    local FolderPath = GetFolderPath()
    return if FolderPath == false then {} else SplitPath(FolderPath)
end

function ThemeManager:BuildFolderTree(SkipWhenCreated: boolean?): (boolean, string?)
    local Supported, SupportError = ThemeManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    local Paths = ThemeManager:GetPaths()
    if #Paths == 0 then
        return false, "Invalid folder path"
    end

    if SkipWhenCreated == true and SafeIsFolder(Paths[#Paths]) then
        return true
    end

    for _, Path in Paths do
        local Success, ErrorMessage = EnsureFolder(Path)
        if not Success then
            return false, ErrorMessage
        end
    end

    return true
end

function ThemeManager:CheckFolderTree(): (boolean, string?)
    return ThemeManager:BuildFolderTree(true)
end

function ThemeManager:SetFolder(Folder: string)
    assert(IsValidFolderPath(Folder), "Invalid path provided")

    ThemeManager.Folder = Folder
    ThemeManager:BuildFolderTree()
end

--// Theme Management \\--
function ThemeManager:ReloadCustomThemes()
    local Supported = ThemeManager:IsSupported()
    if not Supported then
        return {}
    end

    local SettingsPath = GetCurrentThemesPath()
    if SettingsPath == false then
        return {}
    end

    local SuccessList, Files = TryFileSystemCall(listfiles, SettingsPath)
    if not (SuccessList and typeof(Files) == "table") then
        Notify(string.format("Failed to load theme list: %s", tostring(Files)))
        return {}
    end

    local FileNames = {}
    for _, FilePath in Files do
        local FileName = FilePath:gsub("\\", "/"):match("([^/]+)%.json$")
        if FileName and IsValidThemeName(FileName) and string.lower(FileName) ~= "default" then
            table.insert(FileNames, FileName)
        end
    end

    table.sort(FileNames, function(Left, Right)
        return string.lower(Left) < string.lower(Right)
    end)
    return FileNames
end

function ThemeManager:GetCustomTheme(ThemeName: string): any
    if not ThemeManager:IsSupported() then
        return nil
    end

    if not IsValidThemeName(ThemeName) then
        return nil
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false or not SafeIsFile(ThemePath) then
        return nil
    end

    local SuccessRead, Content = TryFileSystemCall(readfile, ThemePath)
    if not SuccessRead then
        return nil
    end

    local SuccessDecode, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)
    if not SuccessDecode or typeof(Decoded) ~= "table" then
        return nil
    end

    return Decoded
end

function ThemeManager:SaveCustomTheme(ThemeName: string): (boolean, string?)
    local Supported, SupportError = ThemeManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    if not IsValidThemeName(ThemeName) or string.lower(ThemeName) == "default" then
        return false, "Invalid theme name provided"
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false then
        return false, "Invalid theme name provided"
    end

    local FolderCreated, FolderError = ThemeManager:CheckFolderTree()
    if not FolderCreated then
        return false, FolderError
    end

    local Library = ThemeManager.Library
    if not Library then
        return false, "Library is not set, call ThemeManager:SetLibrary(Library) first"
    end

    local FontOption = Library.Options and Library.Options.FontFace
    local BackgroundOption = Library.Options and Library.Options.BackgroundImage
    local ThemeData = {
        FontFace = if FontOption and typeof(FontOption.Value) == "string"
            then FontOption.Value
            else "Code",
        BackgroundImage = if BackgroundOption
                and typeof(BackgroundOption.Value) == "string"
            then BackgroundOption.Value
            else (
                typeof(Library.Scheme.BackgroundImage) == "string"
                    and Library.Scheme.BackgroundImage
                or ""
            ),
    }

    for _, SchemeIndex in SchemeIndexes do
        local Option = Library.Options and Library.Options[SchemeIndex]
        local Color = if Option and typeof(Option.Value) == "Color3"
            then Option.Value
            else Library.Scheme[SchemeIndex]
        if typeof(Color) ~= "Color3" then
            return false, string.format("Library scheme is missing a valid %s color", SchemeIndex)
        end

        ThemeData[SchemeIndex] = Color:ToHex()
    end

    local SuccessEncode, EncodedData = pcall(HttpService.JSONEncode, HttpService, ThemeData)
    if not SuccessEncode then
        return false, "Failed to encode data"
    end

    local SuccessWrite, ErrorMessage = TryFileSystemCall(writefile, ThemePath, EncodedData)
    if not SuccessWrite then
        return false, "Failed to write theme file: " .. tostring(ErrorMessage)
    end

    return true
end

function ThemeManager:Delete(ThemeName: string): (boolean, string?)
    local Supported, SupportError = ThemeManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    if not IsValidThemeName(ThemeName) then
        return false, "Invalid theme name provided"
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false or not SafeIsFile(ThemePath) then
        return false, "Theme file does not exist"
    end

    local SuccessDelete, ErrorMessage = TryFileSystemCall(delfile, ThemePath)
    if not SuccessDelete then
        return false, "Failed to delete theme file: " .. tostring(ErrorMessage)
    end

    if ThemeName == ThemeManager.DefaultThemeName then
        ThemeManager:DeleteDefaultTheme()
    end

    return true
end

--// Default Theme \\--
function ThemeManager:GetDefaultTheme(): (string, boolean, string?)
    local Supported, SupportError = ThemeManager:IsSupported()
    if not Supported then
        return "none", false, SupportError
    end

    local FolderCreated, FolderError = ThemeManager:CheckFolderTree()
    if not FolderCreated then
        return "none", false, FolderError
    end

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return "none", false, "Invalid path provided"
    end

    if not SafeIsFile(DefaultThemePath) then
        return "none", false, "Default theme is not set"
    end

    local SuccessRead, DefaultThemeName = TryFileSystemCall(readfile, DefaultThemePath)
    if not (SuccessRead and typeof(DefaultThemeName) == "string") then
        return "none", false, tostring(DefaultThemeName)
    end

    DefaultThemeName = Trim(DefaultThemeName)
    if not IsValidThemeName(DefaultThemeName) then
        return "none", false, "Default theme name is invalid"
    end

    local ConfigExists = DoesThemeExist(DefaultThemeName, true)
    if not ConfigExists then
        return "none", false, "Theme file not found"
    end

    ThemeManager.DefaultThemeName = DefaultThemeName
    return DefaultThemeName, true
end

function ThemeManager:SetDefaultTheme(Theme: any)
    assert(ThemeManager.Library, "Library is not set, call ThemeManager:SetLibrary(Library) first.")
    assert(
        not ThemeManager.AppliedToTab,
        "Cannot set default theme after applying ThemeManager to a tab!"
    )
    assert(typeof(Theme) == "table", "Expected theme table, got " .. typeof(Theme))

    local Library = ThemeManager.Library
    local DefaultThemeData = ThemeManager.BuiltInThemes["Default"][2]

    local LibraryScheme = {}
    local FinalTheme = {}

    for _, SchemeIndex in SchemeIndexes do
        local IndexData = Theme[SchemeIndex]
        local IndexType = typeof(IndexData)

        if IndexType == "Color3" then
            LibraryScheme[SchemeIndex] = IndexData
            FinalTheme[SchemeIndex] = string.format("#%s", IndexData:ToHex())
        elseif IndexType == "string" then
            local Success, Color = pcall(Color3.fromHex, IndexData)
            if Success and typeof(Color) == "Color3" then
                LibraryScheme[SchemeIndex] = Color
                FinalTheme[SchemeIndex] = if IndexData:sub(1, 1) == "#"
                    then IndexData
                    else string.format("#%s", IndexData)
            else
                local Value = DefaultThemeData[SchemeIndex]
                LibraryScheme[SchemeIndex] = Color3.fromHex(Value)
                FinalTheme[SchemeIndex] = Value
            end
        else
            local Value = DefaultThemeData[SchemeIndex]
            LibraryScheme[SchemeIndex] = Color3.fromHex(Value)
            FinalTheme[SchemeIndex] = Value
        end
    end

    --// Font
    local FontFace = Theme["FontFace"]
    local FontFaceType = typeof(FontFace)

    if FontFaceType == "EnumItem" and FontFace.EnumType == Enum.Font then
        LibraryScheme.Font = Font.fromEnum(FontFace)
        FinalTheme.FontFace = FontFace.Name
    elseif FontFaceType == "string" and Enum.Font[FontFace] then
        LibraryScheme.Font = Font.fromEnum(Enum.Font[FontFace])
        FinalTheme.FontFace = FontFace
    else
        LibraryScheme.Font = Font.fromEnum(Enum.Font.Code)
        FinalTheme.FontFace = "Code"
    end

    --// Default Scheme Colors
    for _, DefaultSchemeColor in { "RedColor", "DestructiveColor", "DarkColor", "WhiteColor" } do
        LibraryScheme[DefaultSchemeColor] = Library.Scheme[DefaultSchemeColor]
    end

    --// Apply
    Library.Scheme = LibraryScheme
    ThemeManager.BuiltInThemes["Default"] = { 1, FinalTheme }

    Library:UpdateColorsUsingRegistry()
end

function ThemeManager:SaveDefault(ThemeName: string): (boolean, string?)
    local Supported, SupportError = ThemeManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    if not IsValidThemeName(ThemeName) then
        return false, "Invalid theme name provided"
    end

    local FolderCreated, FolderError = ThemeManager:CheckFolderTree()
    if not FolderCreated then
        return false, FolderError
    end

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return false, "Invalid path provided"
    end

    if not DoesThemeExist(ThemeName, true) then
        return false, "Theme does not exist"
    end

    local SuccessWrite, ErrorMessage = TryFileSystemCall(writefile, DefaultThemePath, ThemeName)
    if not SuccessWrite then
        return false, ErrorMessage
    end

    ThemeManager.DefaultThemeName = ThemeName
    return true
end

function ThemeManager:LoadDefault(): (boolean, string?)
    local Library = ThemeManager.Library
    if not Library then
        return false, "Library is not set, call ThemeManager:SetLibrary(Library) first"
    end

    local ThemeName, Success, FetchErrorMessage = ThemeManager:GetDefaultTheme()
    if not Success or FetchErrorMessage then
        if FetchErrorMessage ~= "Default theme is not set" then
            Library:Notify(
                string.format("Failed to apply default theme: %s", tostring(FetchErrorMessage))
            )
        end

        return false, FetchErrorMessage
    end

    if ThemeManager.BuiltInThemes[ThemeName] then
        local ThemeList = Library.Options.ThemeManager_ThemeList
        if ThemeList then
            ThemeList:SetValue(ThemeName)
        end
        return true
    end

    local SuccessLoad, LoadErrorMessage = ThemeManager:ApplyTheme(ThemeName)
    if not SuccessLoad then
        Library:Notify(
            string.format("Failed to apply default theme: %s", tostring(LoadErrorMessage))
        )
        return false, LoadErrorMessage
    end

    Library:Notify(string.format("Successfully applied default theme %q", ThemeName))
    return true
end

function ThemeManager:DeleteDefaultTheme(): (boolean, string?)
    local Supported, SupportError = ThemeManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    local FolderCreated, FolderError = ThemeManager:CheckFolderTree()
    if not FolderCreated then
        return false, FolderError
    end

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return false, "Invalid path provided"
    end

    if not SafeIsFile(DefaultThemePath) then
        return false, "Default theme is not set"
    end

    local SuccessDelete, ErrorMessage = TryFileSystemCall(delfile, DefaultThemePath)
    if not SuccessDelete then
        return false, ErrorMessage
    end

    ThemeManager.DefaultThemeName = nil
    return true
end

--// Apply Theme \\--
function ThemeManager:ThemeUpdate(): (boolean, string?)
    local Library = ThemeManager.Library
    if not Library then
        return false, "Library is not set, call ThemeManager:SetLibrary(Library) first"
    end

    for _, SchemeIndex in SchemeIndexes do
        local Element = Library.Options[SchemeIndex]
        if not Element then
            continue
        end

        Library.Scheme[SchemeIndex] = Element.Value
    end

    Library:UpdateColorsUsingRegistry()
    return true
end

function ThemeManager:ApplyTheme(ThemeName: string): (boolean, string?)
    if typeof(ThemeName) ~= "string" or IsStringEmpty(ThemeName) then
        return false, "No theme is selected"
    end

    local Library = ThemeManager.Library
    if not Library then
        return false, "Library is not set, call ThemeManager:SetLibrary(Library) first"
    end

    local CustomThemeData = ThemeManager:GetCustomTheme(ThemeName)
    local BuiltInTheme = ThemeManager.BuiltInThemes[ThemeName]
    local ThemeData = CustomThemeData or (BuiltInTheme and BuiltInTheme[2])
    if typeof(ThemeData) ~= "table" then
        return false, "Theme not found"
    end

    for _, SchemeIndex in SchemeIndexes do
        local HexValue = ThemeData[SchemeIndex]
        if typeof(HexValue) ~= "string" then
            return false, string.format("Theme is missing a valid %s value", SchemeIndex)
        end

        local Success, Color = pcall(Color3.fromHex, HexValue)
        if not Success or typeof(Color) ~= "Color3" then
            return false, string.format("Theme has an invalid %s color", SchemeIndex)
        end

        Library.Scheme[SchemeIndex] = Color
        local Element = Library.Options[SchemeIndex]
        if Element then
            Element:SetValue(Color)
        end
    end

    local FontFace = ThemeData.FontFace
    if FontFace ~= nil then
        if typeof(FontFace) ~= "string" or not Enum.Font[FontFace] then
            return false, "Theme has an invalid FontFace"
        end
        Library:SetFont(Enum.Font[FontFace])
        local FontOption = Library.Options.FontFace
        if FontOption then
            FontOption:SetValue(FontFace)
        end
    end

    local BackgroundImage = ThemeData.BackgroundImage
    if BackgroundImage ~= nil then
        if typeof(BackgroundImage) ~= "string" then
            return false, "Theme has an invalid BackgroundImage"
        end
        Library:SetBackgroundImage(BackgroundImage)
        local BackgroundOption = Library.Options.BackgroundImage
        if BackgroundOption then
            BackgroundOption:SetValue(BackgroundImage)
        end
    end

    ThemeManager:ThemeUpdate()
    return true
end

--// GUI \\--
local function ShowDialog(
    Condition: () -> boolean,

    Index: string,
    Title: string,
    Description: string,

    DestructiveText: string,
    DestructiveAction: () -> nil
)
    if Condition() == false then
        return DestructiveAction()
    end

    return ThemeManager.Library.Window:AddDialog(Index, {
        Title = Title,
        Description = Description,
        AutoDismiss = false,

        FooterButtons = {
            Cancel = {
                Title = "Cancel",
                Variant = "Ghost",
                Order = 1,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                end,
            },

            DestructiveAction = {
                Title = DestructiveText,
                Variant = "Destructive",
                Order = 2,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                    DestructiveAction()
                end,
            },
        },
    })
end

function ThemeManager:CreateThemeManager(Themesbox: any)
    assert(ThemeManager.Library, "Library is not set, call ThemeManager:SetLibrary(Library) first.")

    local Supported, SupportError = ThemeManager:IsSupported()
    if not Supported then
        Themesbox:AddLabel("Theme persistence is unavailable: " .. tostring(SupportError), true)
        return Themesbox
    end

    local BuiltInThemesNames = {}
    for Name, _ThemeData in ThemeManager.BuiltInThemes do
        table.insert(BuiltInThemesNames, Name)
    end

    local CustomThemeList, CustomThemeName, ThemeList, FontFace, BackgroundImage, DefaultThemeLabel
    local function RefreshList()
        CustomThemeList:SetValues(ThemeManager:ReloadCustomThemes())
        CustomThemeList:SetValue(nil)

        ThemeList:SetValues(BuiltInThemesNames)
    end

    local function RefreshDefaultThemeLabel()
        local DefaultThemeName, _Success, _ErrorMessage = ThemeManager:GetDefaultTheme()

        DefaultThemeLabel:SetText(string.format("Current default theme: %s", DefaultThemeName))
        if CustomThemeList then
            RefreshList()
        end
    end

    table.sort(BuiltInThemesNames, function(IndexA, IndexB)
        return ThemeManager.BuiltInThemes[IndexA][1] < ThemeManager.BuiltInThemes[IndexB][1]
    end)

    local function CreateColorOption(Text, SchemeIndex)
        Themesbox:AddLabel(Text):AddColorPicker(SchemeIndex, {
            Default = ThemeManager.Library.Scheme[SchemeIndex],
        })

        return ThemeManager.Library.Options[SchemeIndex]
    end

    local BackgroundColor = CreateColorOption("Background color", "BackgroundColor")
    local MainColor = CreateColorOption("Main color", "MainColor")
    local AccentColor = CreateColorOption("Accent color", "AccentColor")
    local OutlineColor = CreateColorOption("Outline color", "OutlineColor")
    local FontColor = CreateColorOption("Font color", "FontColor")

    Themesbox:AddDropdown("FontFace", {
        Text = "Font Face",
        Default = "Code",

        Values = {
            "BuilderSans",
            "Code",
            "Fantasy",
            "Gotham",
            "Jura",
            "Roboto",
            "RobotoMono",
            "SourceSans",
        },
        AllowNull = false,
        Multi = false,
    })

    Themesbox:AddInput("BackgroundImage", {
        Text = "Background Image",

        Default = "",
        Finished = true,
        ClearTextOnFocus = false,
        ClearTextOnBlur = false,
    })

    Themesbox:AddDivider()

    Themesbox:AddDropdown("ThemeManager_ThemeList", {
        Text = "Theme list",

        Values = BuiltInThemesNames,
        AllowNull = true,
        Multi = false,

        FormatDisplayValue = function(Value: any)
            if Value ~= "Default" and Value == ThemeManager.DefaultThemeName then
                return string.format("%s (default)", Value)
            end

            return Value
        end,
        FormatListValue = function(Value: any)
            if Value ~= "Default" and Value == ThemeManager.DefaultThemeName then
                return string.format("%s (default)", Value)
            end

            return Value
        end,
    })

    Themesbox:AddButton("Set as default", function()
        local ThemeName = ThemeList.Value
        local Success, ErrorMessage = ThemeManager:SaveDefault(ThemeName)
        if not Success then
            ThemeManager.Library:Notify(
                string.format("Failed to set default theme: %s", tostring(ErrorMessage))
            )
            return
        end

        ThemeManager.Library:Notify(
            string.format("Successfully set default theme to %q", ThemeName)
        )
        RefreshDefaultThemeLabel()
    end)

    Themesbox:AddDivider()

    CustomThemeName = Themesbox:AddInput("ThemeManager_CustomThemeName", {
        Text = "Custom theme name",
    })

    Themesbox:AddButton("Create theme", function()
        local Name = CustomThemeName.Value
        if not IsValidThemeName(Name) or string.lower(Name) == "default" then
            ThemeManager.Library:Notify(
                "Theme names cannot be empty, reserved, or contain path characters."
            )
            return
        end

        ShowDialog(
            function(): boolean
                return ThemeManager:GetCustomTheme(Name) ~= nil
            end,

            "ThemeManager_CreateTheme",
            "Theme already exists",
            string.format(
                "A custom theme named %q already exists. Overwriting it will replace it with your current colors.",
                Name
            ),

            "Overwrite",
            function()
                local Success, ErrorMessage = ThemeManager:SaveCustomTheme(Name)
                if not Success then
                    ThemeManager.Library:Notify(
                        string.format("Failed to create theme %q: %s", Name, ErrorMessage)
                    )
                    return
                end

                ThemeManager.Library:Notify(string.format("Successfully created theme %q", Name))
                RefreshList()
            end
        )
    end)

    Themesbox:AddDivider()

    CustomThemeList = Themesbox:AddDropdown("ThemeManager_CustomThemeList", {
        Text = "Custom themes",

        Values = ThemeManager:ReloadCustomThemes(),
        AllowNull = true,
        Multi = false,

        FormatDisplayValue = function(Value: any)
            if Value == ThemeManager.DefaultThemeName then
                return string.format("%s (default)", Value)
            end

            return Value
        end,
        FormatListValue = function(Value: any)
            if Value == ThemeManager.DefaultThemeName then
                return string.format("%s (default)", Value)
            end

            return Value
        end,
    })

    Themesbox:AddButton("Load theme", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("Please select a theme first.")
            return
        end

        local Success, ErrorMessage = ThemeManager:ApplyTheme(Name)
        if not Success then
            ThemeManager.Library:Notify(
                string.format("Failed to load theme %q: %s", Name, tostring(ErrorMessage))
            )
            return
        end

        ThemeManager.Library:Notify(string.format("Successfully loaded theme %q", Name))
    end)

    Themesbox:AddButton("Overwrite theme", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("Please select a theme first.")
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_OverwriteTheme",
            "Overwrite theme",
            string.format(
                "Are you sure you want to overwrite %q with your current colors? This cannot be undone.",
                Name
            ),

            "Overwrite",
            function()
                local Success, ErrorMessage = ThemeManager:SaveCustomTheme(Name)
                if not Success then
                    ThemeManager.Library:Notify(
                        string.format(
                            "Failed to overwrite theme %q: %s",
                            Name,
                            tostring(ErrorMessage)
                        )
                    )
                    return
                end

                ThemeManager.Library:Notify(string.format("Successfully overwrote theme %q", Name))
            end
        )
    end)

    Themesbox:AddButton("Delete theme", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("Please select a theme first.")
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_DeleteTheme",
            "Delete theme",
            string.format("Are you sure you want to delete %q? This cannot be undone.", Name),

            "Delete",
            function()
                local Success, ErrorMessage = ThemeManager:Delete(Name)
                if not Success then
                    ThemeManager.Library:Notify(
                        string.format("Failed to delete theme: %s", ErrorMessage)
                    )
                    return
                end

                ThemeManager.Library:Notify(string.format("Successfully deleted theme %q", Name))
                RefreshDefaultThemeLabel()
            end
        )
    end)

    Themesbox:AddButton("Refresh list", RefreshList)

    Themesbox:AddButton("Set as default", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("Please select a theme first.")
            return
        end

        local Success, ErrorMessage = ThemeManager:SaveDefault(Name)
        if not Success then
            ThemeManager.Library:Notify(
                string.format("Failed to set default theme: %s", tostring(ErrorMessage))
            )
            return
        end

        ThemeManager.Library:Notify(string.format("Successfully set default theme to %q", Name))
        RefreshDefaultThemeLabel()
    end)

    Themesbox:AddButton("Reset default", function()
        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_ResetDefault",
            "Reset default theme",
            "Are you sure you want to clear the default theme? The library will revert to its built-in default on next load.",

            "Reset",
            function()
                local Success, ErrorMessage = ThemeManager:DeleteDefaultTheme()
                if not Success then
                    ThemeManager.Library:Notify(
                        string.format("Failed to reset default theme: %s", ErrorMessage)
                    )
                    return
                end

                ThemeManager.Library:Notify("Successfully reset default theme.")
                RefreshDefaultThemeLabel()
            end
        )
    end)

    DefaultThemeLabel = Themesbox:AddLabel("Current default theme: ...", true)

    --// Set Variables
    CustomThemeList, CustomThemeName, ThemeList, FontFace, BackgroundImage =
        ThemeManager.Library.Options.ThemeManager_CustomThemeList,
        ThemeManager.Library.Options.ThemeManager_CustomThemeName,
        ThemeManager.Library.Options.ThemeManager_ThemeList,
        ThemeManager.Library.Options.FontFace,
        ThemeManager.Library.Options.BackgroundImage

    --// Handlers
    ThemeList:OnChanged(function()
        local Success, ErrorMessage = ThemeManager:ApplyTheme(ThemeList.Value)
        if not Success then
            ThemeManager.Library:Notify(
                string.format("Failed to apply theme: %s", tostring(ErrorMessage))
            )
        end
    end)

    local function UpdateTheme()
        ThemeManager:ThemeUpdate()
    end

    BackgroundColor:OnChanged(UpdateTheme)
    MainColor:OnChanged(UpdateTheme)
    AccentColor:OnChanged(UpdateTheme)
    OutlineColor:OnChanged(UpdateTheme)
    FontColor:OnChanged(UpdateTheme)
    FontFace:OnChanged(function(Value)
        ThemeManager.Library:SetFont(Enum.Font[Value])
    end)
    BackgroundImage:OnChanged(function(Value)
        ThemeManager.Library:SetBackgroundImage(Value)
    end)

    --// Load default
    ThemeManager:LoadDefault()
    ThemeManager.AppliedToTab = true
    RefreshDefaultThemeLabel()

    return Themesbox
end

function ThemeManager:CreateGroupBox(Tab: any, IconName: string)
    return Tab:AddLeftGroupbox("Themes", IconName or "paintbrush")
end

function ThemeManager:ApplyToTab(Tab: any, IconName: string)
    local Groupbox = ThemeManager:CreateGroupBox(Tab, IconName)
    return ThemeManager:CreateThemeManager(Groupbox)
end

function ThemeManager:ApplyToGroupbox(Groupbox: any)
    return ThemeManager:CreateThemeManager(Groupbox)
end

getgenv().CyanThemeManager = ThemeManager
return ThemeManager
]]))()

--// addons/SaveManager.lua //--
local SaveManager = (loadstring([[
local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func)
    return func
end)

local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local isfolder, isfile, listfiles = isfolder, isfile, listfiles
local makefolder, readfile, writefile, delfile = makefolder, readfile, writefile, delfile

if typeof(clonefunction) == "function" then
    -- Some third-party environments expose predicate APIs that throw. Normalize them to safe results.

    local isfolder_copy, isfile_copy, listfiles_copy =
        clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)

    local isfolder_success, isfolder_error = pcall(function()
        return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
    end)

    if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
        isfolder = function(folder)
            local success, data = pcall(isfolder_copy, folder)
            return (if success then data else false)
        end

        isfile = function(file)
            local success, data = pcall(isfile_copy, file)
            return (if success then data else false)
        end

        listfiles = function(folder)
            local success, data = pcall(listfiles_copy, folder)
            return (if success then data else {})
        end
    end
end

local SaveManager = {
    Library = nil,

    Folder = "CyanLibSettings",
    SubFolder = "",

    Ignore = {},
    LoadingOrder = {},
    UseLoadingOrder = false,

    AutoloadConfig = nil,
}

function SaveManager:SetLibrary(Library)
    SaveManager.Library = Library
end

function SaveManager:IsSupported(): (boolean, string?)
    local RequiredFunctions = {
        isfolder = isfolder,
        isfile = isfile,
        listfiles = listfiles,
        makefolder = makefolder,
        readfile = readfile,
        writefile = writefile,
        delfile = delfile,
    }

    for Name, Func in RequiredFunctions do
        if typeof(Func) ~= "function" then
            return false, string.format("Missing filesystem capability: %s", Name)
        end
    end

    return true
end

--// Filesystem helpers \\--
local function TryFileSystemCall(Func: any, ...: any): (boolean, any)
    if typeof(Func) ~= "function" then
        return false, "Filesystem capability is unavailable"
    end

    return pcall(Func, ...)
end

local function SafeIsFolder(Path: string): boolean
    local Success, Result = TryFileSystemCall(isfolder, Path)
    return Success and Result == true
end

local function SafeIsFile(Path: string): boolean
    local Success, Result = TryFileSystemCall(isfile, Path)
    return Success and Result == true
end

local function EnsureFolder(Path: string): (boolean, string?)
    if SafeIsFolder(Path) then
        return true
    end

    local Success, ErrorMessage = TryFileSystemCall(makefolder, Path)
    if Success or SafeIsFolder(Path) then
        return true
    end

    return false, string.format("Failed to create folder %q: %s", Path, tostring(ErrorMessage))
end

local function Notify(Message: string)
    local Library = SaveManager.Library
    if Library and typeof(Library.Notify) == "function" then
        Library:Notify(Message)
    end
end

--// Element Parser \\--
local SpecialValueParser = {
    UDim2 = {
        Encode = function(Value: UDim2)
            return {
                X = { Scale = Value.X.Scale, Offset = Value.X.Offset },
                Y = { Scale = Value.Y.Scale, Offset = Value.Y.Offset },
            }
        end,

        Decode = function(Data: any)
            local DataType = typeof(Data)
            if DataType == "table" then
                return UDim2.new(Data.X.Scale, Data.X.Offset, Data.Y.Scale, Data.Y.Offset)
            elseif DataType == "UDim2" then
                return Data
            end

            return nil
        end,
    },
}

local ElementParser = {}
do
    local function CreateParser(
        ElementType: string,
        LibaryIndex: string,

        Save: (string, any, ...any) -> any,
        Load: (any?, any) -> any,
        CustomElementFetcher: boolean?
    )
        ElementParser[ElementType] = {
            Save = function(Index: string, Element: any, ...)
                local Data = Save(Index, Element, ...)
                Data.type = ElementType
                Data.idx = Index

                return Data
            end,

            Load = function(Index: string?, Data: any)
                if CustomElementFetcher == true then
                    return Load(nil, Data)
                end

                local Elements = SaveManager.Library and SaveManager.Library[LibaryIndex]
                local Element = Elements and Elements[Index]
                return Load(Element, Data)
            end,
        }
    end

    CreateParser("Toggle", "Toggles", function(Index: string, Toggle: any)
        return { value = Toggle.Value }
    end, function(Element: any?, Data: any)
        if not Element then
            return
        end
        if Element.Value == Data.value then
            Element:RunChanged()
            return
        end

        Element:SetValue(Data.value)
    end)

    CreateParser("Slider", "Options", function(Index: string, Slider: any)
        return { value = tostring(Slider.Value) }
    end, function(Element: any?, Data: any)
        if not Element then
            return
        end
        if Element.Value == Data.value then
            Element:RunChanged()
            return
        end

        Element:SetValue(Data.value)
    end)

    CreateParser("Dropdown", "Options", function(Index: string, Dropdown: any)
        return { value = Dropdown.Value, multi = Dropdown.Multi }
    end, function(Element: any?, Data: any)
        if not Element then
            return
        end
        if Element.Value == Data.value then
            Element:RunChanged()
            return
        end

        Element:SetValue(Data.value)
    end)

    CreateParser("ColorPicker", "Options", function(Index: string, ColorPicker: any)
        return { value = ColorPicker.Value:ToHex(), transparency = ColorPicker.Transparency }
    end, function(Element: any?, Data: any)
        if not Element then
            return
        end

        Element:SetValueRGB(Color3.fromHex(Data.value), Data.transparency)
    end)

    CreateParser("KeyPicker", "Options", function(Index: string, KeyPicker: any)
        return {
            mode = KeyPicker.Mode,
            key = KeyPicker.Value,
            modifiers = KeyPicker.Modifiers,
            toggled = KeyPicker.Toggled,
        }
    end, function(Element: any?, Data: any)
        if not Element then
            return
        end

        Element:SetValue({ Data.key, Data.mode, Data.modifiers })
        if Data.mode == "Toggle" and Data.toggled ~= nil then
            Element.Toggled = Data.toggled
            Element:Update()
        end
    end)

    CreateParser("Input", "Options", function(Index: string, Input: any)
        return { text = Input.Value }
    end, function(Element: any?, Data: any)
        if not Element then
            return
        end
        if typeof(Data.text) ~= "string" then
            return
        end

        if Element.Value == Data.text then
            Element:RunChanged()
            return
        end

        Element:SetValue(Data.text)
    end)

    CreateParser("Groupbox", "Tabs", function(Index: string, Groupbox: any, TabIndex: string)
        return { collapsed = Groupbox.Collapsed, tabIdx = TabIndex }
    end, function(_, Data: any)
        local TabIndex, Index = Data.tabIdx, Data.idx
        if typeof(TabIndex) ~= "string" or typeof(Index) ~= "string" then
            return
        end

        local Tabs = SaveManager.Library and SaveManager.Library.Tabs
        local Tab = Tabs and Tabs[TabIndex]
        if not Tab then
            return
        end

        local Groupbox = Tab.Groupboxes[Index]
        if not Groupbox or Groupbox.Collapsed == Data.collapsed then
            return
        end

        Groupbox:SetCollapsed(Data.collapsed == true)
    end, true)
end

--// Helpers \\--
local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end

local function IsStringEmpty(String: string): boolean
    return if typeof(String) == "string" then Trim(String) == "" else true
end

local function IsValidFolderPath(Name: string): boolean
    if typeof(Name) ~= "string" then
        return false
    end

    Name = Trim(Name)
    if Name == "" or Name:find('[<>:"|%?%*%z]') or Name:find("\\", 1, true) then
        return false
    end
    if Name:sub(1, 1) == "/" or Name:find("//", 1, true) then
        return false
    end

    for Segment in string.gmatch(Name, "[^/]+") do
        if Segment == "." or Segment == ".." then
            return false
        end
    end

    return true
end

local function IsValidConfigName(Name: string): boolean
    if typeof(Name) ~= "string" then
        return false
    end

    Name = Trim(Name)
    return Name ~= ""
        and Name ~= "."
        and Name ~= ".."
        and not Name:find("/", 1, true)
        and not Name:find("\\", 1, true)
        and not Name:find('[<>:"|%?%*%z]')
end

--// Folder helper \\--
local function SplitPath(Path: string): { string }
    local Result = {}
    local Current = ""

    for Part in string.gmatch(Path, "[^/]+") do
        Current = if Current == "" then Part else (Current .. "/" .. Part)
        table.insert(Result, Current)
    end

    return Result
end

local function GetFolderPath(): false | string
    if IsStringEmpty(SaveManager.Folder) then
        return false
    end

    return string.format("%s/settings", SaveManager.Folder)
end

local function GetSubFolderPath(): false | string
    if IsStringEmpty(SaveManager.Folder) or IsStringEmpty(SaveManager.SubFolder) then
        return false
    end

    return string.format("%s/settings/%s", SaveManager.Folder, SaveManager.SubFolder)
end

local function GetCurrentSettingsPath(): false | string
    local SubFolderPath = GetSubFolderPath()
    return if SubFolderPath == false then GetFolderPath() else SubFolderPath
end

--// Files helper \\--
local function GetConfigPath(ConfigName: string): false | string
    if not IsValidConfigName(ConfigName) then
        return false
    end

    local CurrentSettingsPath = GetCurrentSettingsPath()
    return if CurrentSettingsPath == false
        then false
        else string.format("%s/%s.json", CurrentSettingsPath, ConfigName)
end

local function DoesConfigExist(ConfigName: string): boolean
    local ConfigPath = GetConfigPath(ConfigName)
    return if ConfigPath == false then false else SafeIsFile(ConfigPath)
end

local function GetAutoloadPath(): false | string
    local CurrentSettingsPath = GetCurrentSettingsPath()
    return if CurrentSettingsPath == false
        then false
        else string.format("%s/autoload.txt", CurrentSettingsPath)
end

--// Indexes \\--
function SaveManager:SetLoadingOrder(Enabled: boolean, Order: { string }?)
    SaveManager.UseLoadingOrder = Enabled == true
    SaveManager.LoadingOrder = typeof(Order) == "table" and Order or SaveManager.LoadingOrder
end

function SaveManager:SetIgnoreIndexes(Indexes: { string }?)
    assert(typeof(Indexes) == "table", "Expected table, got " .. typeof(Indexes))

    for _, Index in Indexes do
        SaveManager.Ignore[Index] = true
    end
end

function SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({
        "BackgroundColor",
        "MainColor",
        "AccentColor",
        "OutlineColor",
        "FontColor",
        "FontFace",
        "BackgroundImage",
        "ThemeManager_ThemeList",
        "ThemeManager_CustomThemeList",
        "ThemeManager_CustomThemeName",
    })
end

--// Folders \\--
function SaveManager:GetPaths(): { string }
    local SubFolderPath = GetSubFolderPath()
    if SubFolderPath == false then
        local FolderPath = GetFolderPath()
        return if FolderPath == false then {} else SplitPath(FolderPath)
    end

    return SplitPath(SubFolderPath)
end

function SaveManager:BuildFolderTree(SkipWhenCreated: boolean?): (boolean, string?)
    local Supported, SupportError = SaveManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    local Paths = SaveManager:GetPaths()
    if #Paths == 0 then
        return false, "Invalid folder path"
    end

    if SkipWhenCreated == true and SafeIsFolder(Paths[#Paths]) then
        return true
    end

    for _, Path in Paths do
        local Success, ErrorMessage = EnsureFolder(Path)
        if not Success then
            return false, ErrorMessage
        end
    end

    return true
end

function SaveManager:CheckFolderTree(): (boolean, string?)
    return SaveManager:BuildFolderTree(true)
end

function SaveManager:CheckSubFolder(CreateFolder: boolean): (boolean, string?)
    local Supported, SupportError = SaveManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    local SubFolderPath = GetSubFolderPath()
    if SubFolderPath == false then
        return false, "No subfolder is configured"
    end

    if not CreateFolder then
        return SafeIsFolder(SubFolderPath)
    end

    return EnsureFolder(SubFolderPath)
end

function SaveManager:SetFolder(Folder: string)
    assert(IsValidFolderPath(Folder), "Invalid path provided")

    SaveManager.Folder = Folder
    SaveManager:BuildFolderTree()
end

function SaveManager:SetSubFolder(SubFolder: string)
    assert(IsValidFolderPath(SubFolder), "Invalid path provided")

    SaveManager.SubFolder = SubFolder
    SaveManager:BuildFolderTree()
end

--// Config Management \\--
function SaveManager:RefreshConfigList()
    local Supported, ErrorMessage = SaveManager:IsSupported()
    if not Supported then
        return {}, ErrorMessage
    end

    local SettingsPath = GetCurrentSettingsPath()
    if SettingsPath == false then
        return {}
    end

    local SuccessList, Files = TryFileSystemCall(listfiles, SettingsPath)
    if not (SuccessList and typeof(Files) == "table") then
        Notify(string.format("Failed to load config list: %s", tostring(Files)))
        return {}, tostring(Files)
    end

    local FileNames = {}
    for _, FilePath in Files do
        local FileName = FilePath:gsub("\\", "/"):match("([^/]+)%.json$")
        if FileName and IsValidConfigName(FileName) and string.lower(FileName) ~= "autoload" then
            table.insert(FileNames, FileName)
        end
    end

    table.sort(FileNames, function(Left, Right)
        return string.lower(Left) < string.lower(Right)
    end)
    return FileNames
end

function SaveManager:Save(ConfigName: string): (boolean, string?)
    local Supported, SupportError = SaveManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    if not IsValidConfigName(ConfigName) or string.lower(ConfigName) == "autoload" then
        return false, "Invalid config name provided"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false then
        return false, "Invalid config name provided"
    end

    local FolderCreated, FolderError = SaveManager:CheckFolderTree()
    if not FolderCreated then
        return false, FolderError
    end

    local Library = SaveManager.Library
    if not Library then
        return false, "Library is not set, call SaveManager:SetLibrary(Library) first"
    end

    local IgnoreIndexes = SaveManager.Ignore
    local CurrentData = {
        timestamp = os.date("%d.%m.%Y %H:%M:%S"),
        name = ConfigName,

        objects = {},
        keybindMenu = if Library.KeybindFrame
            then {
                visible = Library.KeybindFrame.Visible,
                position = SpecialValueParser.UDim2.Encode(Library.KeybindFrame.Position),
            }
            else nil,
    }

    --// Toggles
    for Index, Toggle in Library.Toggles do
        if not Toggle.Type then
            continue
        end
        if IgnoreIndexes[Index] then
            continue
        end

        local Parser = ElementParser[Toggle.Type]
        if not Parser then
            continue
        end

        table.insert(CurrentData.objects, Parser.Save(Index, Toggle))
    end

    --// Options
    for Index, Option in Library.Options do
        if not Option.Type then
            continue
        end
        if IgnoreIndexes[Index] then
            continue
        end

        local Parser = ElementParser[Option.Type]
        if not Parser then
            continue
        end

        table.insert(CurrentData.objects, Parser.Save(Index, Option))
    end

    --// Groupboxes
    for TabIndex, Tab in Library.Tabs do
        if not Tab.Groupboxes then
            continue
        end

        for Index, Groupbox in Tab.Groupboxes do
            if IgnoreIndexes[Index] then
                continue
            end

            local Parser = ElementParser.Groupbox
            if not Parser then
                continue
            end

            table.insert(CurrentData.objects, Parser.Save(Index, Groupbox, TabIndex))
        end
    end

    local SuccessEncode, EncodedData = pcall(HttpService.JSONEncode, HttpService, CurrentData)
    if not SuccessEncode then
        return false, "Failed to encode data"
    end

    local SuccessWrite, ErrorMessage = TryFileSystemCall(writefile, ConfigPath, EncodedData)
    if not SuccessWrite then
        return false, "Failed to write config file: " .. tostring(ErrorMessage)
    end

    return true
end

function SaveManager:Load(ConfigName: string): (boolean, string?)
    local Supported, SupportError = SaveManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    if not IsValidConfigName(ConfigName) then
        return false, "Invalid config name provided"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false or not SafeIsFile(ConfigPath) then
        return false, "Config file does not exist"
    end

    local SuccessRead, Content = TryFileSystemCall(readfile, ConfigPath)
    if not SuccessRead then
        return false, "Failed to read config file"
    end

    local SuccessDecode, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)
    if not SuccessDecode or typeof(Decoded) ~= "table" or typeof(Decoded.objects) ~= "table" then
        return false, "Failed to decode config data"
    end

    local Library = SaveManager.Library
    if not Library then
        return false, "Library is not set, call SaveManager:SetLibrary(Library) first"
    end

    local LoadingOrder = SaveManager.LoadingOrder
    local IgnoreIndexes = SaveManager.Ignore

    if SaveManager.UseLoadingOrder == true and typeof(LoadingOrder) == "table" then
        table.sort(Decoded.objects, function(a, b)
            local aIndex = table.find(LoadingOrder, a.type) or math.huge
            local bIndex = table.find(LoadingOrder, b.type) or math.huge
            return aIndex < bIndex
        end)
    end

    --// Keybind Menu
    if Library.KeybindFrame and typeof(Decoded.keybindMenu) == "table" then
        local KeybindFrameData = Decoded.keybindMenu
        local IsVisible = KeybindFrameData.visible == true
        local Position = SpecialValueParser.UDim2.Decode(KeybindFrameData.position)

        Library.KeybindFrame.Visible = IsVisible
        Library.KeybindFrame.Position = Position or Library.KeybindFrame.Position

        local KeybindMenuToggle = Library.Options and Library.Options.KeybindMenuOpen
        if KeybindMenuToggle then
            KeybindMenuToggle:SetValue(IsVisible)
        end
    end

    --// Elements
    for _, Option in Decoded.objects do
        if
            typeof(Option) ~= "table"
            or typeof(Option.type) ~= "string"
            or typeof(Option.idx) ~= "string"
        then
            continue
        end
        if IgnoreIndexes[Option.idx] then
            continue
        end

        local Parser = ElementParser[Option.type]
        if not Parser then
            continue
        end

        task.defer(function()
            local Success, ErrorMessage = pcall(Parser.Load, Option.idx, Option)
            if not Success then
                Notify(
                    string.format(
                        "Skipped invalid saved setting %q: %s",
                        Option.idx,
                        tostring(ErrorMessage)
                    )
                )
            end
        end)
    end

    return true
end

function SaveManager:Delete(ConfigName: string): (boolean, string?)
    local Supported, SupportError = SaveManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    if not IsValidConfigName(ConfigName) then
        return false, "Invalid config name provided"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false or not SafeIsFile(ConfigPath) then
        return false, "Config file does not exist"
    end

    local SuccessDelete, ErrorMessage = TryFileSystemCall(delfile, ConfigPath)
    if not SuccessDelete then
        return false, "Failed to delete config file: " .. tostring(ErrorMessage)
    end

    if ConfigName == SaveManager.AutoloadConfig then
        SaveManager:DeleteAutoLoadConfig()
    end

    return true
end

function SaveManager:Rename(CurrentName: string, NewName: string): (boolean, string?)
    local Supported, SupportError = SaveManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    if not IsValidConfigName(CurrentName) or string.lower(CurrentName) == "autoload" then
        return false, "Invalid current config name provided"
    end
    if not IsValidConfigName(NewName) or string.lower(NewName) == "autoload" then
        return false, "Invalid new config name provided"
    end
    if CurrentName == NewName then
        return true
    end

    local CurrentPath = GetConfigPath(CurrentName)
    local NewPath = GetConfigPath(NewName)
    if CurrentPath == false or NewPath == false or not SafeIsFile(CurrentPath) then
        return false, "Config file does not exist"
    end
    if SafeIsFile(NewPath) then
        return false, "A config with the new name already exists"
    end

    local SuccessRead, Content = TryFileSystemCall(readfile, CurrentPath)
    if not SuccessRead or typeof(Content) ~= "string" then
        return false, "Failed to read config file"
    end

    local SuccessWrite, WriteError = TryFileSystemCall(writefile, NewPath, Content)
    if not SuccessWrite then
        return false, "Failed to write renamed config: " .. tostring(WriteError)
    end

    -- Read the persisted autoload target instead of relying only on the in-memory cache.
    -- This also handles callers that rename a config before opening the configuration UI.
    local AutoloadName, HasAutoload = SaveManager:GetAutoloadConfig()
    if HasAutoload and AutoloadName == CurrentName then
        local AutoloadSuccess, AutoloadError = SaveManager:SaveAutoloadConfig(NewName)
        if not AutoloadSuccess then
            TryFileSystemCall(delfile, NewPath)
            return false,
                "Config rename was cancelled because autoload could not be updated: " .. tostring(
                    AutoloadError
                )
        end
    end

    local SuccessDelete, DeleteError = TryFileSystemCall(delfile, CurrentPath)
    if not SuccessDelete then
        return false,
            "Renamed config was created, but the original could not be removed: " .. tostring(
                DeleteError
            )
    end

    return true
end

--// Auto Load Config \\--
function SaveManager:GetAutoloadConfig(): (string, boolean, string?)
    local Supported, SupportError = SaveManager:IsSupported()
    if not Supported then
        return "none", false, SupportError
    end

    local FolderCreated, FolderError = SaveManager:CheckFolderTree()
    if not FolderCreated then
        return "none", false, FolderError
    end

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return "none", false, "Invalid path provided"
    end

    if not SafeIsFile(AutoloadPath) then
        return "none", false, "Autoload config is not set"
    end

    local SuccessRead, AutoloadConfigName = TryFileSystemCall(readfile, AutoloadPath)
    if not (SuccessRead and typeof(AutoloadConfigName) == "string") then
        return "none", false, tostring(AutoloadConfigName)
    end

    AutoloadConfigName = Trim(AutoloadConfigName)
    if
        not IsValidConfigName(AutoloadConfigName)
        or string.lower(AutoloadConfigName) == "autoload"
    then
        return "none", false, "Autoload config name is invalid"
    end

    local ConfigExists = DoesConfigExist(AutoloadConfigName)
    if not ConfigExists then
        return "none", false, "Config file not found"
    end

    SaveManager.AutoloadConfig = AutoloadConfigName
    return AutoloadConfigName, true
end

function SaveManager:SaveAutoloadConfig(ConfigName: string): (boolean, string?)
    local Supported, SupportError = SaveManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    if not IsValidConfigName(ConfigName) or string.lower(ConfigName) == "autoload" then
        return false, "Invalid config name provided"
    end

    local FolderCreated, FolderError = SaveManager:CheckFolderTree()
    if not FolderCreated then
        return false, FolderError
    end

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return false, "Invalid path provided"
    end

    if not DoesConfigExist(ConfigName) then
        return false, "Config does not exist"
    end

    local SuccessWrite, ErrorMessage = TryFileSystemCall(writefile, AutoloadPath, ConfigName)
    if not SuccessWrite then
        return false, ErrorMessage
    end

    SaveManager.AutoloadConfig = ConfigName
    return true
end

function SaveManager:LoadAutoloadConfig(): (boolean, string?)
    local Library = SaveManager.Library
    if not Library then
        return false, "Library is not set, call SaveManager:SetLibrary(Library) first"
    end

    local ConfigName, Success, FetchErrorMessage = SaveManager:GetAutoloadConfig()
    if not Success or FetchErrorMessage then
        if FetchErrorMessage ~= "Autoload config is not set" then
            Library:Notify(string.format("Failed to load autoload config: %s", FetchErrorMessage))
        end

        return false, FetchErrorMessage
    end

    local SuccessLoad, LoadErrorMessage = SaveManager:Load(ConfigName)
    if not SuccessLoad then
        Library:Notify(string.format("Failed to load autoload config: %s", LoadErrorMessage))
        return false, LoadErrorMessage
    end

    Library:Notify(string.format("Successfully loaded autoload config %q", ConfigName))
    return true
end

function SaveManager:DeleteAutoLoadConfig(): (boolean, string?)
    local Supported, SupportError = SaveManager:IsSupported()
    if not Supported then
        return false, SupportError
    end

    local FolderCreated, FolderError = SaveManager:CheckFolderTree()
    if not FolderCreated then
        return false, FolderError
    end

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return false, "Invalid path provided"
    end

    if not SafeIsFile(AutoloadPath) then
        return false, "Autoload config is not set"
    end

    local SuccessDelete, ErrorMessage = TryFileSystemCall(delfile, AutoloadPath)
    if not SuccessDelete then
        return false, ErrorMessage
    end

    SaveManager.AutoloadConfig = nil
    return true
end

--// GUI \\--
local function ShowDialog(
    Condition: () -> boolean,

    Index: string,
    Title: string,
    Description: string,

    DestructiveText: string,
    DestructiveAction: () -> nil
)
    if Condition() == false then
        return DestructiveAction()
    end

    return SaveManager.Library.Window:AddDialog(Index, {
        Title = Title,
        Description = Description,
        AutoDismiss = false,

        FooterButtons = {
            Cancel = {
                Title = "Cancel",
                Variant = "Ghost",
                Order = 1,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                end,
            },

            DestructiveAction = {
                Title = DestructiveText,
                Variant = "Destructive",
                Order = 2,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                    DestructiveAction()
                end,
            },
        },
    })
end

function SaveManager:BuildConfigSection(Tab: any, IconName: string)
    assert(SaveManager.Library, "Library is not set, call SaveManager:SetLibrary(Library) first.")
    local ConfigurationBox = Tab:AddRightGroupbox("Configuration", IconName or "folder-cog")

    local Supported, SupportError = SaveManager:IsSupported()
    if not Supported then
        ConfigurationBox:AddLabel(
            "Configuration persistence is unavailable: " .. tostring(SupportError),
            true
        )
        return ConfigurationBox
    end

    local ConfigNameInput, ConfigList, AutoloadConfigLabel
    local function RefreshList()
        ConfigList:SetValues(SaveManager:RefreshConfigList())
        ConfigList:SetValue(nil)
    end

    local function RefreshAutoloadConfigLabel()
        local AutoloadConfigName, _Success, _ErrorMessage = SaveManager:GetAutoloadConfig()

        AutoloadConfigLabel:SetText(
            string.format("Current autoload config: %s", AutoloadConfigName)
        )
        if ConfigList then
            RefreshList()
        end
    end

    --// Create
    ConfigurationBox:AddInput("SaveManager_ConfigName", {
        Text = "Config name",
    })

    ConfigurationBox:AddButton("Create config", function()
        local ConfigName = ConfigNameInput.Value
        if not IsValidConfigName(ConfigName) or string.lower(ConfigName) == "autoload" then
            SaveManager.Library:Notify(
                "Config names cannot be empty, reserved, or contain path characters."
            )
            return
        end

        ShowDialog(
            function(): boolean
                return DoesConfigExist(ConfigName)
            end,

            "SaveManager_CreateConfig",
            "Config already exists",
            string.format(
                "A config named %q already exists. Overwriting will replace it with your current settings.",
                ConfigName
            ),

            "Overwrite",
            function()
                local Success, ErrorMessage = SaveManager:Save(ConfigName)
                if not Success then
                    SaveManager.Library:Notify(
                        string.format("Failed to create config %q: %s", ConfigName, ErrorMessage)
                    )
                    return
                end

                SaveManager.Library:Notify(
                    string.format("Successfully created config %q", ConfigName)
                )
                RefreshList()
            end
        )
    end)

    ConfigurationBox:AddDivider()

    --// Manage
    ConfigurationBox:AddDropdown("SaveManager_ConfigList", {
        Text = "Config list",

        Values = SaveManager:RefreshConfigList(),
        AllowNull = true,
        Multi = false,

        FormatDisplayValue = function(Value: any)
            if Value == SaveManager.AutoloadConfig then
                return string.format("%s (autoload)", Value)
            end

            return Value
        end,
        FormatListValue = function(Value: any)
            if Value == SaveManager.AutoloadConfig then
                return string.format("%s (autoload)", Value)
            end

            return Value
        end,
    })

    ConfigurationBox:AddButton({
        Text = "Load config",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("Please select a config first.")
                return
            end

            local Success, ErrorMessage = SaveManager:Load(ConfigName)
            if not Success then
                SaveManager.Library:Notify(
                    string.format("Failed to load config %q: %s", ConfigName, ErrorMessage)
                )
                return
            end

            SaveManager.Library:Notify(string.format("Successfully loaded config %q", ConfigName))
        end,
    })

    ConfigurationBox:AddButton({
        Text = "Overwrite config",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("Please select a config first.")
                return
            end

            ShowDialog(
                function(): boolean
                    return true --// Always show
                end,

                "SaveManager_OverwriteConfig",
                "Overwrite config",
                string.format(
                    "Are you sure you want to overwrite %q with your current settings? This cannot be undone.",
                    ConfigName
                ),

                "Overwrite",
                function()
                    local Success, ErrorMessage = SaveManager:Save(ConfigName)
                    if not Success then
                        SaveManager.Library:Notify(
                            string.format(
                                "Failed to overwrite config %q: %s",
                                ConfigName,
                                ErrorMessage
                            )
                        )
                        return
                    end

                    SaveManager.Library:Notify(
                        string.format("Successfully overwrote config %q", ConfigName)
                    )
                end
            )
        end,
    })

    ConfigurationBox:AddButton({
        Text = "Rename config",
        DoubleClick = false,

        Func = function()
            local CurrentName = ConfigList.Value
            local NewName = ConfigNameInput.Value
            if IsStringEmpty(CurrentName) then
                SaveManager.Library:Notify("Please select a config first.")
                return
            end

            local Success, ErrorMessage = SaveManager:Rename(CurrentName, NewName)
            if not Success then
                SaveManager.Library:Notify(
                    string.format("Failed to rename config: %s", tostring(ErrorMessage))
                )
                return
            end

            SaveManager.Library:Notify(
                string.format("Renamed config %q to %q", CurrentName, NewName)
            )
            ConfigNameInput:SetValue("")
            RefreshAutoloadConfigLabel()
        end,
    })

    ConfigurationBox:AddButton({
        Text = "Delete config",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("Please select a config first.")
                return
            end

            ShowDialog(
                function(): boolean
                    return true --// Always show
                end,

                "SaveManager_DeleteConfig",
                "Delete config",
                string.format(
                    "Are you sure you want to delete %q? This cannot be undone.",
                    ConfigName
                ),

                "Delete",
                function()
                    local Success, ErrorMessage = SaveManager:Delete(ConfigName)
                    if not Success then
                        SaveManager.Library:Notify(
                            string.format(
                                "Failed to delete config %q: %s",
                                ConfigName,
                                ErrorMessage
                            )
                        )
                        return
                    end

                    SaveManager.Library:Notify(
                        string.format("Successfully deleted config %q", ConfigName)
                    )
                    RefreshAutoloadConfigLabel()
                end
            )
        end,
    })

    ConfigurationBox:AddButton("Refresh list", RefreshList)

    --// Autoload Config
    ConfigurationBox:AddButton({
        Text = "Set as autoload",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("Please select a config first.")
                return
            end

            local Success, ErrorMessage = SaveManager:SaveAutoloadConfig(ConfigName)
            if not Success then
                SaveManager.Library:Notify(
                    string.format("Failed to set autoload config %q: %s", ConfigName, ErrorMessage)
                )
                return
            end

            SaveManager.Library:Notify(
                string.format("Successfully set autoload config to %q", ConfigName)
            )
            RefreshAutoloadConfigLabel()
        end,
    })

    ConfigurationBox:AddButton({
        Text = "Reset autoload",
        DoubleClick = false,

        Func = function()
            ShowDialog(
                function(): boolean
                    return true --// Always show
                end,

                "SaveManager_ResetAutoload",
                "Reset autoload config",
                "Are you sure you want to clear the autoload config? No config will be loaded automatically on next launch.",

                "Reset",
                function()
                    local Success, ErrorMessage = SaveManager:DeleteAutoLoadConfig()
                    if not Success then
                        SaveManager.Library:Notify(
                            string.format("Failed to reset autoload config: %s", ErrorMessage)
                        )
                        return
                    end

                    SaveManager.Library:Notify("Successfully reset autoload config.")
                    RefreshAutoloadConfigLabel()
                end
            )
        end,
    })

    AutoloadConfigLabel = ConfigurationBox:AddLabel("Current autoload config: ...", true)

    --// Set variables
    ConfigNameInput, ConfigList =
        SaveManager.Library.Options.SaveManager_ConfigName,
        SaveManager.Library.Options.SaveManager_ConfigList

    --// Refresh
    RefreshAutoloadConfigLabel()
    SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })

    return ConfigurationBox
end

SaveManager:BuildFolderTree()
return SaveManager
]]))()

--// addons/KeySystem.lua //--
local KeySystem = (loadstring([[
--!strict
-- Cyan callback-driven access-key UI.
-- This module intentionally does not ship keys or contact a key service itself.
-- The host owns verification through the Validate callback.

local KeySystem = {}
KeySystem.__index = KeySystem

export type State = "Idle" | "Checking" | "Verified" | "Rejected" | "Locked"
export type Validator = (Key: string) -> (boolean, string?)
export type Options = {
    Validate: Validator,
    MaxAttempts: number?,
    CooldownSeconds: number?,
    OnVerified: ((KeySystem) -> ())?,
    OnRejected: ((KeySystem, string) -> ())?,
    OnLoggedOut: ((KeySystem) -> ())?,
    OnStateChanged: ((KeySystem, State, string?) -> ())?,
}
export type RemoteOptions = {
    MaxAttempts: number?,
    CooldownSeconds: number?,
    OnVerified: ((KeySystem) -> ())?,
    OnRejected: ((KeySystem, string) -> ())?,
    OnLoggedOut: ((KeySystem) -> ())?,
    OnStateChanged: ((KeySystem, State, string?) -> ())?,
}

export type UIOptions = {
    Prompt: string?,
    Placeholder: string?,
    CheckingText: string?,
    VerifiedText: string?,
    RejectedPrefix: string?,
    LockedText: string?,
    ResetText: string?,
    ShowResetButton: boolean?,
}

export type GateOptions = {
    DefaultTab: any?,
    HideLoginTabAfterVerification: boolean?,
    HideSearchBeforeVerification: boolean?,
}

export type GateController = {
    Lock: (self: GateController) -> (),
    Unlock: (self: GateController) -> (),
}

export type KeySystem = {
    State: State,
    Attempts: number,
    MaxAttempts: number?,
    CooldownSeconds: number,
    NextAttemptAt: number,
    LastError: string?,

    Verify: (self: KeySystem, Key: string) -> (boolean, string?),
    Reset: (self: KeySystem) -> (),
    GetRemainingAttempts: (self: KeySystem) -> number?,
    GetStatus: (self: KeySystem) -> (State, string?),
    IsVerified: (self: KeySystem) -> boolean,
    IsLocked: (self: KeySystem) -> boolean,
    Logout: (self: KeySystem) -> boolean,
    GateTabs: (
        self: KeySystem,
        LoginTab: any,
        ProtectedTabs: { any },
        Options: GateOptions?
    ) -> GateController,
    Attach: (self: KeySystem, KeyTab: any, Options: UIOptions?) -> any,
}

local function Trim(Value: string): string
    return Value:match("^%s*(.-)%s*$")
end

local function CallSafely(Callback: (...any) -> ...any, ...: any): (boolean, ...any)
    return pcall(Callback, ...)
end

local function RunHook(Callback: ((...any) -> ())?, ...: any)
    if typeof(Callback) == "function" then
        -- Access state must not be changed by a consumer callback error.
        pcall(Callback, ...)
    end
end

function KeySystem:_SetState(State: State, Message: string?)
    self.State = State
    RunHook(self._OnStateChanged, self, State, Message)
end

function KeySystem.new(Options: Options): KeySystem
    assert(typeof(Options) == "table", "KeySystem options must be a table")
    assert(
        typeof(Options.Validate) == "function",
        "KeySystem requires an Options.Validate callback"
    )

    local MaxAttempts = Options.MaxAttempts
    if MaxAttempts ~= nil then
        assert(
            typeof(MaxAttempts) == "number" and MaxAttempts >= 1,
            "MaxAttempts must be a positive number"
        )
        MaxAttempts = math.floor(MaxAttempts)
    end

    local CooldownSeconds = Options.CooldownSeconds or 0
    assert(
        typeof(CooldownSeconds) == "number" and CooldownSeconds >= 0,
        "CooldownSeconds must be non-negative"
    )

    local Self = setmetatable({
        State = "Idle" :: State,
        Attempts = 0,
        MaxAttempts = MaxAttempts,
        CooldownSeconds = CooldownSeconds,
        NextAttemptAt = 0,
        LastError = nil,

        _Validate = Options.Validate,
        _OnVerified = Options.OnVerified,
        _OnRejected = Options.OnRejected,
        _OnLoggedOut = Options.OnLoggedOut,
        _OnStateChanged = Options.OnStateChanged,
    }, KeySystem)

    return Self :: any
end

-- Creates a key system backed by a server-owned RemoteFunction.
-- The server must validate access and enforce every protected action itself.
function KeySystem.fromRemote(Remote: RemoteFunction, Options: RemoteOptions?): KeySystem
    assert(
        typeof(Remote) == "Instance" and Remote:IsA("RemoteFunction"),
        "KeySystem.fromRemote requires a RemoteFunction"
    )

    local RemoteOptions = Options or {}
    assert(typeof(RemoteOptions) == "table", "Remote key system options must be a table")

    return KeySystem.new({
        Validate = function(Key: string): (boolean, string?)
            local Success, Allowed, Message = pcall(function()
                return Remote:InvokeServer(Key)
            end)
            if not Success then
                return false, "Unable to contact the access service"
            end

            if Allowed == true then
                return true, if typeof(Message) == "string" then Message else nil
            end
            return false, if typeof(Message) == "string" then Message else "Access was not approved"
        end,
        MaxAttempts = RemoteOptions.MaxAttempts,
        CooldownSeconds = RemoteOptions.CooldownSeconds,
        OnVerified = RemoteOptions.OnVerified,
        OnRejected = RemoteOptions.OnRejected,
        OnLoggedOut = RemoteOptions.OnLoggedOut,
        OnStateChanged = RemoteOptions.OnStateChanged,
    })
end

function KeySystem:IsVerified(): boolean
    return self.State == "Verified"
end

function KeySystem:IsLocked(): boolean
    return self.State == "Locked"
end

function KeySystem:Reset()
    self.Attempts = 0
    self.NextAttemptAt = 0
    self.LastError = nil
    self:_SetState("Idle")
end

function KeySystem:Logout(): boolean
    if not self:IsVerified() then
        return false
    end

    self:Reset()

    local UI = self._AttachedUI
    if UI then
        if UI.KeyBox and typeof(UI.KeyBox.SetDisabled) == "function" then
            UI.KeyBox:SetDisabled(false)
        end
        if UI.KeyBox and typeof(UI.KeyBox.Clear) == "function" then
            UI.KeyBox:Clear()
        end
        if UI.StatusLabel and typeof(UI.StatusLabel.SetText) == "function" then
            UI.StatusLabel:SetText("Status: logged out")
        end
    end

    if self._GateController and typeof(self._GateController.Lock) == "function" then
        self._GateController:Lock()
    end

    if UI and UI.KeyBox and typeof(UI.KeyBox.Focus) == "function" then
        local Focused = pcall(function()
            task.defer(function()
                UI.KeyBox:Focus()
            end)
        end)
        if not Focused then
            UI.KeyBox:Focus()
        end
    end

    RunHook(self._OnLoggedOut, self)
    return true
end

function KeySystem:GetRemainingAttempts(): number?
    if self.MaxAttempts == nil then
        return nil
    end

    return math.max(0, self.MaxAttempts - self.Attempts)
end

function KeySystem:GetStatus(): (State, string?)
    return self.State, self.LastError
end

function KeySystem:Verify(Key: string): (boolean, string?)
    if self:IsVerified() then
        return true, "Access has already been verified"
    end
    if self:IsLocked() then
        return false, "Too many invalid attempts. Reset the key system before trying again"
    end
    if typeof(Key) ~= "string" then
        return false, "Key must be a string"
    end

    Key = Trim(Key)
    if Key == "" then
        return false, "Enter an access key"
    end

    local Now = os.clock()
    if Now < self.NextAttemptAt then
        local Remaining = math.ceil(self.NextAttemptAt - Now)
        return false,
            string.format(
                "Please wait %d second%s before trying again",
                Remaining,
                if Remaining == 1 then "" else "s"
            )
    end

    self:_SetState("Checking")
    local Invoked, Allowed, Message = CallSafely(self._Validate, Key)
    if not Invoked then
        self.LastError = "Key verification is temporarily unavailable"
        self:_SetState("Rejected", self.LastError)
        RunHook(self._OnRejected, self, self.LastError)
        return false, self.LastError
    end

    if Allowed == true then
        self.LastError = nil
        self:_SetState("Verified", if typeof(Message) == "string" then Message else nil)
        -- Deliberately do not retain the entered key after verification.
        RunHook(self._OnVerified, self)
        return true,
            if typeof(Message) == "string" and Message ~= "" then Message else "Access granted"
    end

    self.Attempts += 1
    self.LastError = if typeof(Message) == "string" and Message ~= ""
        then Message
        else "Invalid access key"
    self.NextAttemptAt = Now + self.CooldownSeconds

    if self.MaxAttempts and self.Attempts >= self.MaxAttempts then
        self.LastError = "Too many invalid attempts"
        self:_SetState("Locked", self.LastError)
    else
        self:_SetState("Rejected", self.LastError)
    end

    RunHook(self._OnRejected, self, self.LastError)
    return false, self.LastError
end

-- Shows a login tab first and keeps supplied tabs unavailable until verification succeeds.
-- This is UI gating only; protected gameplay/actions must still be enforced by the server.
function KeySystem:GateTabs(LoginTab: any, ProtectedTabs: { any }, Options: GateOptions?)
    assert(
        typeof(LoginTab) == "table" and typeof(LoginTab.Show) == "function",
        "A valid login tab is required"
    )
    assert(typeof(ProtectedTabs) == "table", "ProtectedTabs must be a table")
    assert(Options == nil or typeof(Options) == "table", "Gate options must be a table")

    Options = Options or {}

    local Window = LoginTab.Window
    local SearchWasVisible = nil

    local function SetProtectedVisible(Visible: boolean)
        for _, Tab in ProtectedTabs do
            if
                Tab ~= LoginTab
                and typeof(Tab) == "table"
                and typeof(Tab.SetVisible) == "function"
            then
                Tab:SetVisible(Visible)
            end
        end
    end

    local function Lock()
        SetProtectedVisible(false)
        if
            Options.HideSearchBeforeVerification ~= false
            and typeof(Window) == "table"
            and typeof(Window.IsSearchVisible) == "function"
            and typeof(Window.SetSearchVisible) == "function"
        then
            SearchWasVisible = Window:IsSearchVisible()
            Window:SetSearchVisible(false)
        end
        if typeof(LoginTab.SetVisible) == "function" then
            LoginTab:SetVisible(true)
        end
        LoginTab:Show()
    end

    local function Unlock()
        SetProtectedVisible(true)
        if
            SearchWasVisible == true
            and typeof(Window) == "table"
            and typeof(Window.SetSearchVisible) == "function"
        then
            Window:SetSearchVisible(true)
        end
        if
            Options.HideLoginTabAfterVerification ~= false
            and typeof(LoginTab.SetVisible) == "function"
        then
            LoginTab:SetVisible(false)
        end

        local DefaultTab = Options.DefaultTab or ProtectedTabs[1]
        if typeof(DefaultTab) == "table" and typeof(DefaultTab.Show) == "function" then
            DefaultTab:Show()
        end
    end

    local PreviousOnVerified = self._OnVerified
    self._OnVerified = function(System)
        Unlock()
        RunHook(PreviousOnVerified, System)
    end

    if self:IsVerified() then
        Unlock()
    else
        Lock()
    end

    local Controller = {
        Lock = Lock,
        Unlock = Unlock,
    }
    self._GateController = Controller
    return Controller
end

function KeySystem:Attach(KeyTab: any, Options: UIOptions?)
    assert(
        typeof(KeyTab) == "table" and typeof(KeyTab.AddKeyBox) == "function",
        "KeyTab with AddKeyBox is required"
    )
    assert(Options == nil or typeof(Options) == "table", "KeySystem UI options must be a table")

    Options = Options or {}
    local Prompt = Options.Prompt or "Enter your access key to continue."
    local CheckingText = Options.CheckingText or "Checking key..."
    local VerifiedText = Options.VerifiedText or "Access granted."
    local RejectedPrefix = Options.RejectedPrefix or "Access denied: "
    local LockedText = Options.LockedText or "Access is locked. Reset before trying again."
    local ResetText = Options.ResetText or "Reset key entry"

    local PromptLabel = nil
    local StatusLabel = nil
    if typeof(KeyTab.AddLabel) == "function" then
        PromptLabel = KeyTab:AddLabel(Prompt, true)
        StatusLabel = KeyTab:AddLabel("Status: waiting for a key", true)
    end

    local KeyBox
    local function SetStatus(Text: string)
        if StatusLabel then
            StatusLabel:SetText(Text)
        end
    end

    KeyBox = KeyTab:AddKeyBox(function(Key: string)
        if self:IsLocked() then
            SetStatus(LockedText)
            return
        end

        SetStatus(CheckingText)
        local Allowed, Message = self:Verify(Key)
        if Allowed then
            SetStatus(VerifiedText)
            if KeyBox and typeof(KeyBox.Clear) == "function" then
                KeyBox:Clear()
            end
            if KeyBox and typeof(KeyBox.SetDisabled) == "function" then
                KeyBox:SetDisabled(true)
            end
            return
        end

        if self:IsLocked() then
            SetStatus(LockedText)
            if KeyBox and typeof(KeyBox.SetDisabled) == "function" then
                KeyBox:SetDisabled(true)
            end
            return
        end

        SetStatus(RejectedPrefix .. tostring(Message))
    end)

    if KeyBox and KeyBox.TextBox and typeof(Options.Placeholder) == "string" then
        KeyBox.TextBox.PlaceholderText = Options.Placeholder
    end

    local ResetButton = nil
    if Options.ShowResetButton ~= false and typeof(KeyTab.AddButton) == "function" then
        ResetButton = KeyTab:AddButton(ResetText, function()
            self:Reset()
            if KeyBox and typeof(KeyBox.SetDisabled) == "function" then
                KeyBox:SetDisabled(false)
            end
            if KeyBox and typeof(KeyBox.Clear) == "function" then
                KeyBox:Clear()
            end
            SetStatus("Status: waiting for a key")
            if KeyBox and typeof(KeyBox.Focus) == "function" then
                KeyBox:Focus()
            end
        end)
    end

    local UI = {
        PromptLabel = PromptLabel,
        StatusLabel = StatusLabel,
        KeyBox = KeyBox,
        ResetButton = ResetButton,
    }
    self._AttachedUI = UI
    return UI
end

return KeySystem
]]))()

--// addons/HUD.lua //--
local HUD = (loadstring([[
--!strict
-- Cyan HUD addon: a lightweight, draggable status panel for experience-owned data.

local HUD = {}
HUD.__index = HUD

local RunService: RunService = game:GetService("RunService")
local Stats: Stats? = nil
pcall(function()
    Stats = game:GetService("Stats")
end)

export type TextInfo = {
    Text: string,
    Value: string | number?,
    Order: number?,
    Visible: boolean?,
}

export type ProgressInfo = {
    Text: string,
    Value: number?,
    Order: number?,
    Visible: boolean?,
    Format: ((number) -> string)?,
}

export type TimerInfo = {
    Text: string,
    Duration: number,
    Remaining: number?,
    Running: boolean?,
    Order: number?,
    Visible: boolean?,
    OnCompleted: (() -> ())?,
}

export type CounterInfo = {
    Text: string,
    Value: number?,
    Order: number?,
    Visible: boolean?,
}

export type WaypointInfo = {
    Text: string,
    Target: Vector3 | BasePart | Attachment | Model | (() -> Vector3?),
    Order: number?,
    Visible: boolean?,
    MaxDistance: number?,
}

export type MarkerInfo = {
    Text: string,
    Target: BasePart | Attachment,
    Color: Color3?,
    MaxDistance: number?,
    AlwaysOnTop: boolean?,
    Visible: boolean?,
}

export type InteractionInfo = MarkerInfo & {
    ActionText: string?,
    HoldDuration: number?,
    OnTriggered: ((Player) -> ())?,
}

export type PartyMember = {
    Id: string,
    Name: string,
    Status: string | number?,
    Visible: boolean?,
}

export type PerformanceInfo = {
    Text: string?,
    Order: number?,
    Visible: boolean?,
    PingProvider: (() -> string | number?)?,
}

export type Options = {
    Title: string?,
    Position: UDim2?,
    Visible: boolean?,
    UpdateInterval: number?,
}

local function ToDisplayText(Value: any): string
    if Value == nil then
        return ""
    end

    return tostring(Value)
end

local function EnsureLibrary(Library: any)
    assert(typeof(Library) == "table", "HUD requires a Cyan Library instance")
    assert(typeof(Library.AddDraggableMenu) == "function", "HUD requires Library:AddDraggableMenu")
    assert(typeof(Library.AddToRegistry) == "function", "HUD requires Library:AddToRegistry")
    assert(typeof(Library.OnUnload) == "function", "HUD requires Library:OnUnload")
end

local function CreateTextLabel(
    Library: any,
    Parent: Instance,
    Properties: { [string]: any }
): TextLabel
    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.BorderSizePixel = 0
    Label.FontFace = Library.Scheme.Font
    Label.RichText = true
    Label.TextColor3 = Library.Scheme.FontColor
    Label.TextSize = 14
    Label.Size = UDim2.fromScale(1, 1)
    Label.Parent = Parent

    for Property, Value in Properties do
        Label[Property] = Value
    end

    Library:AddToRegistry(Label, {
        FontFace = "Font",
        TextColor3 = "FontColor",
    })

    return Label
end

local CompassDirections = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }

local function ResolveWorldPosition(Target: any): Vector3?
    local TargetType = typeof(Target)
    if TargetType == "Vector3" then
        return Target
    elseif TargetType == "function" then
        local Success, Position = pcall(Target)
        return if Success and typeof(Position) == "Vector3" then Position else nil
    elseif TargetType ~= "Instance" then
        return nil
    end

    if Target:IsA("Attachment") then
        return Target.WorldPosition
    elseif Target:IsA("BasePart") then
        return Target.Position
    elseif Target:IsA("Model") then
        return Target:GetPivot().Position
    end

    return nil
end

local function GetCompassDirection(Camera: Camera, Position: Vector3): (number, string)
    local Offset = Position - Camera.CFrame.Position
    local FlatDistance = Vector2.new(Offset.X, Offset.Z).Magnitude
    if FlatDistance <= 0.001 then
        return 0, "HERE"
    end

    local Angle = math.atan2(Offset.X, -Offset.Z)
    local Sector = math.floor((math.deg(Angle) + 22.5) / 45) % 8 + 1
    return FlatDistance, CompassDirections[Sector]
end

function HUD.new(Library: any, Options: Options?)
    EnsureLibrary(Library)

    local Config: Options = Options or {}
    assert(typeof(Config) == "table", "HUD options must be a table")

    local Holder, Container = Library:AddDraggableMenu(Config.Title or "HUD")
    if typeof(Config.Position) == "UDim2" then
        Holder.Position = Config.Position
    end
    Holder.Visible = Config.Visible ~= false

    local Self: any = setmetatable({
        Library = Library,
        Holder = Holder,
        Container = Container,
        Title = Config.Title or "HUD",
        Visible = Config.Visible ~= false,
        Entries = {},
        Timers = {},
        Waypoints = {},
        Markers = {},
        PartyEntries = {},
        PerformanceEntries = {},
        Connections = {},
        UpdateInterval = math.clamp(
            Config.UpdateInterval or (Library.IsMobile and 0.15 or 0.1),
            0.05,
            1
        ),
        DisplayElapsed = 0,
        Destroyed = false,
    }, HUD)

    local function CreateEntry(Index: string, Height: number, Order: number?, Visible: boolean?)
        assert(
            typeof(Index) == "string" and Index ~= "",
            "HUD entry index must be a non-empty string"
        )
        assert(
            Self.Entries[Index] == nil and Self.Markers[Index] == nil,
            string.format("HUD index %q already exists", Index)
        )

        local Frame = Instance.new("Frame")
        Frame.BackgroundColor3 = Library.Scheme.MainColor
        Frame.BorderSizePixel = 0
        Frame.Size = UDim2.new(1, 0, 0, Height)
        Frame.LayoutOrder = Order or 0
        Frame.Visible = Visible ~= false
        Frame.Parent = Container
        Library:AddToRegistry(Frame, {
            BackgroundColor3 = "MainColor",
        })
        Library:AddOutline(Frame)

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, Library.CornerRadius / 2)
        Corner.Parent = Frame
        table.insert(Library.Corners, Corner)

        local Entry: any = {
            Frame = Frame,
            Destroyed = false,
            Index = Index,
        }
        Self.Entries[Index] = Entry

        return Entry
    end

    function Self:AddText(Index: string, Info: TextInfo | string)
        assert(not Self.Destroyed, "HUD has been destroyed")

        local TextData: any = Info
        if typeof(TextData) == "string" then
            TextData = { Text = TextData }
        end
        assert(
            typeof(TextData) == "table" and typeof(TextData.Text) == "string",
            "HUD text entry requires Text"
        )

        local Entry = CreateEntry(Index, 24, TextData.Order, TextData.Visible)
        local NameLabel = CreateTextLabel(Library, Entry.Frame, {
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(0.58, -8, 1, 0),
            Text = TextData.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local ValueLabel = CreateTextLabel(Library, Entry.Frame, {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -8, 0, 0),
            Size = UDim2.new(0.42, -8, 1, 0),
            Text = ToDisplayText(TextData.Value),
            TextTransparency = 0.2,
            TextXAlignment = Enum.TextXAlignment.Right,
        })

        Entry.Text = TextData.Text
        Entry.Value = TextData.Value
        Entry.NameLabel = NameLabel
        Entry.ValueLabel = ValueLabel

        function Entry:SetText(Text: string)
            assert(typeof(Text) == "string", "HUD text must be a string")
            Entry.Text = Text
            NameLabel.Text = Text
        end

        function Entry:SetValue(Value: string | number?)
            Entry.Value = Value
            ValueLabel.Text = ToDisplayText(Value)
        end

        function Entry:SetVisible(Visible: boolean)
            Entry.Frame.Visible = Visible == true
        end

        function Entry:Destroy()
            if Entry.Destroyed then
                return
            end
            Entry.Destroyed = true
            Self.Entries[Index] = nil
            Entry.Frame:Destroy()
        end

        Entry:SetValue(TextData.Value)
        return Entry
    end

    function Self:AddProgress(Index: string, Info: ProgressInfo)
        assert(not Self.Destroyed, "HUD has been destroyed")
        assert(
            typeof(Info) == "table" and typeof(Info.Text) == "string",
            "HUD progress entry requires Text"
        )

        local Entry = CreateEntry(Index, 42, Info.Order, Info.Visible)
        local Label = CreateTextLabel(Library, Entry.Frame, {
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(1, -16, 0, 18),
            Text = Info.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local Bar = Instance.new("Frame")
        Bar.BackgroundColor3 = Library.Scheme.BackgroundColor
        Bar.BorderSizePixel = 0
        Bar.Position = UDim2.fromOffset(8, 25)
        Bar.Size = UDim2.new(1, -16, 0, 9)
        Bar.Parent = Entry.Frame
        Library:AddToRegistry(Bar, {
            BackgroundColor3 = "BackgroundColor",
        })

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = Bar

        local Fill = Instance.new("Frame")
        Fill.BackgroundColor3 = Library.Scheme.AccentColor
        Fill.BorderSizePixel = 0
        Fill.Size = UDim2.fromScale(0, 1)
        Fill.Parent = Bar
        Library:AddToRegistry(Fill, {
            BackgroundColor3 = "AccentColor",
        })

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill

        Entry.Text = Info.Text
        Entry.Value = 0
        Entry.Label = Label
        Entry.Bar = Bar
        Entry.Fill = Fill

        function Entry:SetText(Text: string)
            assert(typeof(Text) == "string", "HUD text must be a string")
            Entry.Text = Text
            Label.Text = Text
        end

        function Entry:SetValue(Value: number)
            assert(
                typeof(Value) == "number" and Value == Value,
                "HUD progress value must be a number"
            )
            Entry.Value = math.clamp(Value, 0, 1)
            Fill.Size = UDim2.fromScale(Entry.Value, 1)
            if typeof(Info.Format) == "function" then
                Label.Text = Info.Format(Entry.Value)
            else
                Label.Text =
                    string.format("%s  %d%%", Entry.Text, math.floor(Entry.Value * 100 + 0.5))
            end
        end

        function Entry:SetVisible(Visible: boolean)
            Entry.Frame.Visible = Visible == true
        end

        function Entry:Destroy()
            if Entry.Destroyed then
                return
            end
            Entry.Destroyed = true
            Self.Entries[Index] = nil
            Entry.Frame:Destroy()
        end

        Entry:SetValue(Info.Value or 0)
        return Entry
    end

    function Self:_GiveConnection(Connection: RBXScriptConnection)
        table.insert(Self.Connections, Connection)
        return Connection
    end

    function Self:_StopUpdateLoopIfIdle()
        if
            next(Self.Timers)
            or next(Self.Waypoints)
            or next(Self.PerformanceEntries)
            or not Self.UpdateConnection
        then
            return
        end

        if Self.UpdateConnection.Connected then
            Self.UpdateConnection:Disconnect()
        end
        local ConnectionIndex = table.find(Self.Connections, Self.UpdateConnection)
        if ConnectionIndex then
            table.remove(Self.Connections, ConnectionIndex)
        end
        Self.UpdateConnection = nil
    end

    function Self:_StartUpdateLoop()
        if Self.UpdateConnection then
            return
        end

        Self.UpdateConnection =
            Self:_GiveConnection(RunService.RenderStepped:Connect(function(DeltaTime)
                if Self.Destroyed then
                    return
                end

                -- Count every rendered frame for accurate FPS, but update visible text less often.
                for Index, Performance in Self.PerformanceEntries do
                    if Performance.Destroyed or Performance.Entry.Destroyed then
                        Self.PerformanceEntries[Index] = nil
                    else
                        Performance.Elapsed += DeltaTime
                        Performance.Frames += 1
                    end
                end

                Self.DisplayElapsed += DeltaTime
                if Self.DisplayElapsed < Self.UpdateInterval then
                    return
                end

                local DisplayDelta = Self.DisplayElapsed
                Self.DisplayElapsed = 0

                for Index, Timer in Self.Timers do
                    if Timer.Destroyed or Timer.Entry.Destroyed then
                        Self.Timers[Index] = nil
                    elseif Timer.Running then
                        Timer:SetRemaining(Timer.Remaining - DisplayDelta)
                    end
                end

                local Camera = workspace.CurrentCamera
                if Camera then
                    for Index, Waypoint in Self.Waypoints do
                        if Waypoint.Destroyed or Waypoint.Entry.Destroyed then
                            Self.Waypoints[Index] = nil
                        else
                            local Position = ResolveWorldPosition(Waypoint.Target)
                            if Position then
                                local Distance, Direction = GetCompassDirection(Camera, Position)
                                local Value = if Waypoint.MaxDistance
                                        and Distance > Waypoint.MaxDistance
                                    then "Out of range"
                                    else string.format(
                                        "%.0f studs • %s",
                                        Distance,
                                        Direction
                                    )
                                Waypoint.Entry:SetValue(Value)
                            else
                                Waypoint.Entry:SetValue("Unavailable")
                            end
                        end
                    end
                end

                for _, Performance in Self.PerformanceEntries do
                    if Performance.Elapsed >= 0.5 then
                        local FPS = math.floor(Performance.Frames / Performance.Elapsed + 0.5)
                        local Ping = nil
                        if typeof(Performance.PingProvider) == "function" then
                            local Success, Value = pcall(Performance.PingProvider)
                            Ping = if Success then Value else nil
                        elseif Stats then
                            pcall(function()
                                Ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                            end)
                        end

                        local Value = string.format("%d FPS", FPS)
                        if Ping ~= nil then
                            Value ..= " • " .. tostring(Ping)
                        end
                        Performance.Entry:SetValue(Value)
                        Performance.Elapsed = 0
                        Performance.Frames = 0
                    end
                end

                Self:_StopUpdateLoopIfIdle()
            end))
    end

    function Self:AddCounter(Index: string, Info: CounterInfo)
        assert(
            typeof(Info) == "table" and typeof(Info.Text) == "string",
            "HUD counter requires Text"
        )

        local Entry = Self:AddText(Index, {
            Text = Info.Text,
            Value = Info.Value or 0,
            Order = Info.Order,
            Visible = Info.Visible,
        })
        Entry.Count = tonumber(Info.Value) or 0

        function Entry:SetCount(Value: number)
            assert(
                typeof(Value) == "number" and Value == Value,
                "HUD counter value must be a number"
            )
            Entry.Count = Value
            Entry:SetValue(Value)
        end

        function Entry:Add(Delta: number?)
            Entry:SetCount(Entry.Count + (Delta or 1))
        end

        return Entry
    end

    function Self:AddTimer(Index: string, Info: TimerInfo)
        assert(typeof(Info) == "table" and typeof(Info.Text) == "string", "HUD timer requires Text")
        assert(
            typeof(Info.Duration) == "number" and Info.Duration > 0,
            "HUD timer duration must be positive"
        )

        local Entry = Self:AddProgress(Index, {
            Text = Info.Text,
            Value = 0,
            Order = Info.Order,
            Visible = Info.Visible,
        })
        local Timer: any = {
            Entry = Entry,
            Duration = Info.Duration,
            Remaining = math.clamp(Info.Remaining or Info.Duration, 0, Info.Duration),
            Running = Info.Running ~= false,
            Destroyed = false,
            OnCompleted = Info.OnCompleted,
        }
        Self.Timers[Index] = Timer

        local function RefreshDisplay()
            local Minutes = math.floor(Timer.Remaining / 60)
            local Seconds = math.floor(Timer.Remaining % 60)
            Entry.Label.Text = string.format("%s  %02d:%02d", Info.Text, Minutes, Seconds)
        end

        function Timer:SetRemaining(Remaining: number)
            assert(
                typeof(Remaining) == "number" and Remaining == Remaining,
                "HUD timer remaining value must be a number"
            )
            Timer.Remaining = math.clamp(Remaining, 0, Timer.Duration)
            Entry:SetValue(Timer.Remaining / Timer.Duration)
            RefreshDisplay()

            if Timer.Remaining <= 0 and Timer.Running then
                Timer.Running = false
                if typeof(Timer.OnCompleted) == "function" then
                    pcall(Timer.OnCompleted)
                end
            end
        end

        function Timer:Start()
            if not Timer.Destroyed and Timer.Remaining > 0 then
                Timer.Running = true
            end
        end

        function Timer:Pause()
            Timer.Running = false
        end

        function Timer:Reset(Remaining: number?)
            Timer:SetRemaining(Remaining or Timer.Duration)
            Timer.Running = true
        end

        function Timer:Destroy()
            if Timer.Destroyed then
                return
            end
            Timer.Destroyed = true
            Self.Timers[Index] = nil
            Self:Remove(Index)
        end

        Timer:SetRemaining(Timer.Remaining)
        Self:_StartUpdateLoop()
        return Timer
    end

    function Self:AddCooldown(Index: string, Info: TimerInfo)
        return Self:AddTimer(Index, Info)
    end

    function Self:AddProgressRing(Index: string, Info: ProgressInfo)
        assert(
            typeof(Info) == "table" and typeof(Info.Text) == "string",
            "HUD progress ring requires Text"
        )

        local Entry = Self:AddText(Index, {
            Text = Info.Text,
            Value = "○ 0%",
            Order = Info.Order,
            Visible = Info.Visible,
        })
        local Glyphs = { "○", "◔", "◑", "◕", "●" }

        function Entry:SetValue(Value: number)
            assert(
                typeof(Value) == "number" and Value == Value,
                "HUD progress ring value must be a number"
            )
            Entry.Progress = math.clamp(Value, 0, 1)
            local GlyphIndex =
                math.clamp(math.floor(Entry.Progress * (#Glyphs - 1) + 1.5), 1, #Glyphs)
            Entry.Value = Entry.Progress
            Entry.ValueLabel.Text =
                string.format("%s %d%%", Glyphs[GlyphIndex], math.floor(Entry.Progress * 100 + 0.5))
            if typeof(Info.Format) == "function" then
                Entry.ValueLabel.Text = Info.Format(Entry.Progress)
            end
        end

        Entry:SetValue(Info.Value or 0)
        return Entry
    end

    function Self:AddWaypoint(Index: string, Info: WaypointInfo)
        assert(
            typeof(Info) == "table" and typeof(Info.Text) == "string",
            "HUD waypoint requires Text"
        )
        assert(
            ResolveWorldPosition(Info.Target) ~= nil or typeof(Info.Target) == "function",
            "HUD waypoint target is invalid"
        )

        local Entry = Self:AddText(Index, {
            Text = Info.Text,
            Value = "Locating...",
            Order = Info.Order,
            Visible = Info.Visible,
        })
        local Waypoint: any = {
            Entry = Entry,
            Target = Info.Target,
            MaxDistance = Info.MaxDistance,
            Destroyed = false,
        }
        Self.Waypoints[Index] = Waypoint

        function Waypoint:SetTarget(Target: any)
            assert(
                ResolveWorldPosition(Target) ~= nil or typeof(Target) == "function",
                "HUD waypoint target is invalid"
            )
            Waypoint.Target = Target
        end

        function Waypoint:Destroy()
            if Waypoint.Destroyed then
                return
            end
            Waypoint.Destroyed = true
            Self.Waypoints[Index] = nil
            Self:Remove(Index)
        end

        Self:_StartUpdateLoop()
        return Waypoint
    end

    function Self:AddObjectiveTracker(Index: string, Info: WaypointInfo)
        return Self:AddWaypoint(Index, Info)
    end

    function Self:AddObjectiveMarker(Index: string, Info: MarkerInfo)
        assert(
            typeof(Index) == "string" and Index ~= "",
            "HUD marker index must be a non-empty string"
        )
        assert(
            typeof(Info) == "table" and typeof(Info.Text) == "string",
            "HUD marker requires Text"
        )
        assert(
            typeof(Info.Target) == "Instance"
                and (Info.Target:IsA("BasePart") or Info.Target:IsA("Attachment")),
            "HUD marker target must be a BasePart or Attachment"
        )
        assert(
            Self.Markers[Index] == nil and Self.Entries[Index] == nil,
            string.format("HUD index %q already exists", Index)
        )

        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "CyanObjective_" .. Index
        Billboard.Adornee = Info.Target
        Billboard.AlwaysOnTop = Info.AlwaysOnTop == true
        Billboard.LightInfluence = 0
        Billboard.MaxDistance = Info.MaxDistance or 250
        Billboard.Size = UDim2.fromOffset(180, 32)
        Billboard.StudsOffsetWorldSpace = Vector3.new(0, 2.5, 0)
        Billboard.Enabled = Self.Visible and Info.Visible ~= false
        Billboard.Parent = Library.ScreenGui

        local Label = CreateTextLabel(Library, Billboard, {
            BackgroundColor3 = Library.Scheme.BackgroundColor,
            BackgroundTransparency = 0.15,
            Text = Info.Text,
            TextColor3 = Info.Color or Library.Scheme.FontColor,
            TextScaled = true,
        })
        local LabelRegistry = {
            FontFace = "Font",
            BackgroundColor3 = "BackgroundColor",
        }
        if Info.Color == nil then
            LabelRegistry.TextColor3 = "FontColor"
        end
        Library:AddToRegistry(Label, LabelRegistry)

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, Library.CornerRadius)
        Corner.Parent = Label

        local Marker: any = {
            Billboard = Billboard,
            Label = Label,
            Index = Index,
            Destroyed = false,
            UserVisible = Info.Visible ~= false,
        }
        Self.Markers[Index] = Marker

        function Marker:_ApplyVisibility()
            Billboard.Enabled = Self.Visible and Marker.UserVisible
        end

        function Marker:SetText(Text: string)
            assert(typeof(Text) == "string", "HUD marker text must be a string")
            Label.Text = Text
        end

        function Marker:SetVisible(Visible: boolean)
            Marker.UserVisible = Visible == true
            Marker:_ApplyVisibility()
        end

        function Marker:Destroy()
            if Marker.Destroyed then
                return
            end
            Marker.Destroyed = true
            Self.Markers[Index] = nil
            Billboard:Destroy()
        end

        return Marker
    end

    function Self:AddInteractionPrompt(Index: string, Info: InteractionInfo)
        assert(
            typeof(Info) == "table" and typeof(Info.Target) == "Instance",
            "HUD interaction prompt requires a target"
        )

        local ActionText = Info.ActionText or "Interact"
        local Marker = Self:AddObjectiveMarker(Index, {
            Text = string.format("[%s] %s", ActionText, Info.Text),
            Target = Info.Target,
            Color = Info.Color,
            MaxDistance = Info.MaxDistance,
            AlwaysOnTop = false,
            Visible = Info.Visible,
        })

        local Prompt = Instance.new("ProximityPrompt")
        Prompt.ActionText = ActionText
        Prompt.ObjectText = Info.Text
        Prompt.MaxActivationDistance = math.min(Info.MaxDistance or 12, 50)
        Prompt.HoldDuration = math.max(0, Info.HoldDuration or 0)
        Prompt.RequiresLineOfSight = true
        Prompt.Enabled = Self.Visible and Info.Visible ~= false
        Prompt.Parent = Info.Target

        local Connection = Prompt.Triggered:Connect(function(Player)
            if typeof(Info.OnTriggered) == "function" then
                pcall(Info.OnTriggered, Player)
            end
        end)

        local BaseDestroy = Marker.Destroy
        Marker.Prompt = Prompt
        function Marker:_ApplyVisibility()
            local Visible = Self.Visible and Marker.UserVisible
            Marker.Billboard.Enabled = Visible
            Prompt.Enabled = Visible
        end
        function Marker:SetVisible(Visible: boolean)
            Marker.UserVisible = Visible == true
            Marker:_ApplyVisibility()
        end
        function Marker:Destroy()
            if Marker.Destroyed then
                return
            end
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
            Prompt:Destroy()
            BaseDestroy(Marker)
        end

        return Marker
    end

    function Self:SetParty(Members: { PartyMember })
        assert(typeof(Members) == "table", "HUD party members must be a table")
        local Active = {}

        for Order, Member in Members do
            assert(
                typeof(Member) == "table"
                    and typeof(Member.Id) == "string"
                    and typeof(Member.Name) == "string",
                "HUD party member is invalid"
            )
            local EntryIndex = "party:" .. Member.Id
            Active[EntryIndex] = true
            local Entry = Self.PartyEntries[EntryIndex]
            if not Entry then
                Entry = Self:AddText(EntryIndex, {
                    Text = Member.Name,
                    Value = Member.Status,
                    Order = Order,
                    Visible = Member.Visible,
                })
                Self.PartyEntries[EntryIndex] = Entry
            else
                Entry:SetText(Member.Name)
                Entry:SetValue(Member.Status)
                Entry:SetVisible(Member.Visible ~= false)
            end
        end

        for EntryIndex, Entry in Self.PartyEntries do
            if not Active[EntryIndex] then
                Entry:Destroy()
                Self.PartyEntries[EntryIndex] = nil
            end
        end
    end

    function Self:AddPerformance(Index: string, Info: PerformanceInfo?)
        Info = Info or {}
        assert(typeof(Info) == "table", "HUD performance options must be a table")

        local Entry = Self:AddText(Index, {
            Text = Info.Text or "Performance",
            Value = "Measuring...",
            Order = Info.Order,
            Visible = Info.Visible,
        })
        local Performance: any = {
            Entry = Entry,
            PingProvider = Info.PingProvider,
            Elapsed = 0,
            Frames = 0,
            Destroyed = false,
        }
        Self.PerformanceEntries[Index] = Performance

        function Performance:Destroy()
            if Performance.Destroyed then
                return
            end
            Performance.Destroyed = true
            Self.PerformanceEntries[Index] = nil
            Self:Remove(Index)
        end

        Self:_StartUpdateLoop()
        return Performance
    end

    function Self:SetUpdateInterval(Seconds: number)
        assert(
            typeof(Seconds) == "number" and Seconds == Seconds,
            "HUD update interval must be a number"
        )
        Self.UpdateInterval = math.clamp(Seconds, 0.05, 1)
    end

    function Self:Alert(Info: { [string]: any } | string, Time: number?)
        return Library:Notify(Info, Time)
    end

    function Self:GetEntry(Index: string)
        return Self.Entries[Index]
    end

    function Self:Remove(Index: string): boolean
        local Entry = Self.Entries[Index]
        if not Entry then
            local Marker = Self.Markers[Index]
            if Marker then
                Marker:Destroy()
                return true
            end
            return false
        end

        local Timer = Self.Timers[Index]
        if Timer then
            Timer.Destroyed = true
            Self.Timers[Index] = nil
        end
        local Waypoint = Self.Waypoints[Index]
        if Waypoint then
            Waypoint.Destroyed = true
            Self.Waypoints[Index] = nil
        end
        local Performance = Self.PerformanceEntries[Index]
        if Performance then
            Performance.Destroyed = true
            Self.PerformanceEntries[Index] = nil
        end
        Self.PartyEntries[Index] = nil

        Entry:Destroy()
        Self:_StopUpdateLoopIfIdle()
        return true
    end

    function Self:Clear()
        local EntryIndexes = {}
        for Index in Self.Entries do
            table.insert(EntryIndexes, Index)
        end
        for _, Index in EntryIndexes do
            Self:Remove(Index)
        end
    end

    function Self:ClearMarkers()
        local Markers = {}
        for _, Marker in Self.Markers do
            table.insert(Markers, Marker)
        end
        for _, Marker in Markers do
            Marker:Destroy()
        end
    end

    function Self:SetVisible(Visible: boolean)
        Self.Visible = Visible == true
        Holder.Visible = Self.Visible
        for _, Marker in Self.Markers do
            Marker:_ApplyVisibility()
        end
    end

    function Self:Toggle()
        Self:SetVisible(not Self.Visible)
    end

    function Self:SetTitle(Title: string)
        assert(typeof(Title) == "string", "HUD title must be a string")
        Self.Title = Title
        for _, Child in Holder:GetChildren() do
            if Child:IsA("TextLabel") and Child.Size.Y.Offset == 34 then
                Child.Text = Title
                break
            end
        end
    end

    function Self:Destroy()
        if Self.Destroyed then
            return
        end
        Self.Destroyed = true
        Self:Clear()
        Self:ClearMarkers()

        for Index = #Self.Connections, 1, -1 do
            local Connection = table.remove(Self.Connections, Index)
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end
        Self.UpdateConnection = nil

        local DraggableIndex = table.find(Library.DraggableElements, Holder)
        if DraggableIndex then
            table.remove(Library.DraggableElements, DraggableIndex)
        end

        Holder:Destroy()
    end

    Library:OnUnload(function()
        Self:Destroy()
    end)

    return Self
end

return HUD
]]))()

--// addons/ESP.lua //--
local ESP = (loadstring([[
--!strict
-- Cyan ESP + Aimbot addon: player/object ESP boxes, health bars, names, tracers, chams,
-- FOV circle, and target-selection utilities for aim assistance.

local ESP = {}
ESP.__index = ESP

local RunService: RunService = game:GetService("RunService")
local UserInputService: UserInputService = game:GetService("UserInputService")
local Players: Players = game:GetService("Players")
local TweenService: TweenService = game:GetService("TweenService")
local CoreGui: CoreGui = game:GetService("CoreGui")

local Vector3World = Vector3
local CFrameWorld = CFrame

export type BoxStyle = "Corner" | "Standard" | "Outline"
export type TracerOrigin = "Bottom" | "Middle" | "Mouse"

export type PlayerESPOptions = {
    Enabled: boolean?,
    Box: boolean?,
    BoxStyle: BoxStyle?,
    BoxColor: Color3?,
    BoxTransparency: number?,
    BoxThickness: number?,
    HealthBar: boolean?,
    HealthBarColor: boolean?,
    HealthBarTransparency: number?,
    Name: boolean?,
    NameSize: number?,
    NameColor: Color3?,
    Distance: boolean?,
    DistanceColor: Color3?,
    Tracer: boolean?,
    TracerOrigin: TracerOrigin?,
    TracerColor: Color3?,
    TracerTransparency: number?,
    Chams: boolean?,
    ChamsColor: Color3?,
    ChamsTransparency: number?,
    TeamCheck: boolean?,
    MaxDistance: number?,
    VisibleCheck: boolean?,
    CustomFilter: ((Player) -> boolean)?,
}

export type ObjectESPOptions = {
    Enabled: boolean?,
    Box: boolean?,
    BoxColor: Color3?,
    BoxTransparency: number?,
    Name: boolean?,
    NameColor: Color3?,
    Distance: boolean?,
    DistanceColor: Color3?,
    Tracer: boolean?,
    TracerColor: Color3?,
    TracerTransparency: number?,
    Highlight: boolean?,
    HighlightColor: Color3?,
    HighlightTransparency: number?,
    MaxDistance: number?,
    CustomName: string?,
}

export type FOVCircleOptions = {
    Enabled: boolean?,
    Radius: number?,
    Color: Color3?,
    Transparency: number?,
    Thickness: number?,
    Filled: boolean?,
    Visible: boolean?,
}

export type ESPOptions = {
    UpdateInterval: number?,
    TeamColor: Color3?,
    EnemyColor: Color3?,
    DefaultBoxColor: Color3?,
}

local function IsPlayerVisible(Target: Model): boolean
    local Camera = workspace.CurrentCamera
    if not Camera then
        return true
    end

    local Character = Target
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
    if not RootPart then
        return true
    end

    local Origin = Camera.CFrame.Position
    local Direction = (RootPart.Position - Origin).Unit
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    RaycastParams.FilterDescendantsInstances = { Camera, Character, Players.LocalPlayer.Character }

    local Result =
        workspace:Raycast(Origin, Direction * (RootPart.Position - Origin).Magnitude, RaycastParams)
    return Result == nil
end

local function GetPlayerColor(Target: Player): Color3?
    local Team = Target.Team
    if Team then
        return Team.TeamColor.Color
    end

    return nil
end

local function IsOnSameTeam(Target: Player): boolean
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then
        return false
    end

    local MyTeam = LocalPlayer.Team
    local TargetTeam = Target.Team
    if MyTeam and TargetTeam then
        return MyTeam == TargetTeam
    end

    return false
end

local function GetCharacterPosition(Character: Model): Vector3?
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")

    if RootPart then
        return RootPart.Position
    end

    return Character:GetPivot().Position
end

local function GetCharacterBoundingBox(Character: Model, IgnoreHead: boolean?): (Vector3, Vector3)
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("LowerTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")

    if not RootPart then
        return nil
    end

    local Size = RootPart.Size
    local Position = RootPart.Position
    local Head = Character:FindFirstChild("Head")
    local HeadOffset = 0

    if Head and not IgnoreHead then
        HeadOffset = (Head.Position.Y - Position.Y) + Head.Size.Y / 2
    end

    local Bottom =
        RootPart.CFrame:PointToWorldSpace(Vector3.new(-Size.X / 2, -Size.Y / 2, -Size.Z / 2))
    local Top = RootPart.CFrame:PointToWorldSpace(
        Vector3.new(Size.X / 2, Size.Y / 2 + HeadOffset, Size.Z / 2)
    )

    return Bottom, Top
end

local function WorldToScreen(WorldPoint: Vector3): Vector2?
    local Camera = workspace.CurrentCamera
    if not Camera then
        return nil
    end

    local Point, OnScreen = Camera:WorldToViewportPoint(WorldPoint)
    if not OnScreen or Point.Z < 0 then
        return nil
    end

    return Vector2.new(Point.X, Point.Y)
end

local function IsOnScreen(Position: Vector3): boolean
    local Camera = workspace.CurrentCamera
    if not Camera then
        return false
    end

    local Point, OnScreen = Camera:WorldToViewportPoint(Position)
    return OnScreen and Point.Z > 0
end

function ESP.new(Library: any, Options: ESPOptions?)
    assert(typeof(Library) == "table", "ESP requires a Cyan Library instance")
    assert(typeof(Library.ScreenGui) == "Instance", "ESP requires Library.ScreenGui")

    local Config: ESPOptions = Options or {}
    local Self: any = setmetatable({
        Library = Library,
        Players = {},
        Objects = {},
        FOVCircle = nil,
        FOVCircleVisible = false,
        Enabled = true,
        TracersVisible = true,
        BoxesVisible = true,
        NamesVisible = true,
        HealthBarsVisible = true,
        ChamsVisible = true,
        TeamCheck = false,
        TeamColor = Config.TeamColor or Color3.fromRGB(0, 255, 0),
        EnemyColor = Config.EnemyColor or Color3.fromRGB(255, 50, 50),
        DefaultBoxColor = Config.DefaultBoxColor or Color3.fromRGB(255, 255, 255),
        UpdateInterval = math.clamp(Config.UpdateInterval or 0.1, 0.03, 1),
        DisplayElapsed = 0,
        UpdateConnection = nil,
        ItemConnections = {},
        Connections = {},
        ChamsHighlights = {},
        FOVDrawing = nil,
        TargetLock = nil,
        _AimbotOptions = {
            Enabled = false,
            SilentAim = false,
            Prediction = true,
            PredictionAmount = 0.5,
            Smoothness = 0.8,
            Hitbox = "Torso",
            AutoFire = false,
            AutoFireDelay = 0.15,
            FOV = 60,
            MaxDistance = 1000,
            TeamCheck = true,
            VisibleCheck = false,
            MagicBullet = false,
            MagicBulletChance = 100,
        },
        Destroyed = false,
    }, ESP)

    Self:_InitFOVCircle()
    Self:_StartUpdateLoop()
    SetupSilentAim(Self)
    SetupMagicBullet(Self)
    SetupAutoFire(Self)

    Library:OnUnload(function()
        Self:Destroy()
    end)

    return Self
end

function ESP:_EnsureLibrary()
    assert(not self.Destroyed, "ESP has been destroyed")
end

function ESP:_GiveConnection(Connection: RBXScriptConnection)
    table.insert(self.Connections, Connection)
    return Connection
end

function ESP:_StartUpdateLoop()
    if self.UpdateConnection then
        return
    end

    self.UpdateConnection =
        self:_GiveConnection(RunService.RenderStepped:Connect(function(DeltaTime)
            if self.Destroyed then
                return
            end

            self.DisplayElapsed += DeltaTime
            if self.DisplayElapsed < self.UpdateInterval then
                return
            end
            self.DisplayElapsed = 0

            if not self.Enabled then
                return
            end

            for _, Handler in self.Players do
                if not Handler.Destroyed then
                    Handler:Update()
                end
            end

            for _, Handler in self.Objects do
                if not Handler.Destroyed then
                    Handler:Update()
                end
            end
        end))
end

function ESP:_InitFOVCircle()
    local FOVFrame = Instance.new("ImageLabel")
    FOVFrame.Name = "CyanFOVCircle"
    FOVFrame.BackgroundTransparency = 1
    FOVFrame.BorderSizePixel = 0
    FOVFrame.Image = "rbxasset://textures/ui/WhiteCircle.png"
    FOVFrame.ImageColor3 = Color3.fromRGB(255, 255, 255)
    FOVFrame.ImageTransparency = 0.85
    FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVFrame.Size = UDim2.fromOffset(0, 0)
    FOVFrame.Visible = false
    FOVFrame.ZIndex = 10000
    FOVFrame.Parent = self.Library.ScreenGui

    self.FOVDrawing = FOVFrame
end

function ESP:SetFOVCircle(Options: FOVCircleOptions)
    self:_EnsureLibrary()

    local FOV = self.FOVDrawing
    if not FOV then
        return
    end

    local Radius = Options.Radius or 60
    local Color = Options.Color or Color3.fromRGB(255, 255, 255)
    local Transparency = Options.Transparency or 0.85
    local Thickness = Options.Thickness or 1

    FOV.Size = UDim2.fromOffset(Radius * 2, Radius * 2)
    FOV.ImageColor3 = Color
    FOV.ImageTransparency = Transparency

    local Visible = Options.Enabled ~= false and Options.Visible ~= false
    FOV.Visible = Visible
    self.FOVCircleVisible = Visible

    if Options.Filled then
        FOV.BackgroundColor3 = Color
        FOV.BackgroundTransparency = math.min(1, Transparency + 0.3)
    else
        FOV.BackgroundTransparency = 1
    end
end

function ESP:ShowFOVCircle(Visible: boolean)
    self:_EnsureLibrary()
    if self.FOVDrawing then
        self.FOVDrawing.Visible = Visible and self.FOVCircleVisible
    end
end

function ESP:AddPlayerESP(Options: PlayerESPOptions)
    self:_EnsureLibrary()
    assert(typeof(Options) == "table", "PlayerESP options must be a table")

    local ESPRoot = self
    local Opts: PlayerESPOptions = Options
    local Handler = {
        Options = Opts,
        Connections = {},
        BoxLines = {},
        HealthBarFrame = nil,
        HealthBarFill = nil,
        NameLabel = nil,
        DistanceLabel = nil,
        TracerLine = nil,
        TargetPlayer = nil,
        Destroyed = false,
    }

    local function CreateESPInstance(ClassName: string, Properties: { [string]: any }): Instance
        local Inst = Instance.new(ClassName)
        for Key, Value in Properties do
            Inst[Key] = Value
        end
        return Inst
    end

    local function UpdateESPForPlayer(Player: Player)
        if Handler.Destroyed then
            return
        end

        if not Player or not Player.Parent then
            Handler:ClearESP()
            return
        end

        local Character = Player.Character
        if not Character or not Character.Parent then
            Handler:ClearESP()
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then
            Handler:ClearESP()
            return
        end

        if Opts.TeamCheck and IsOnSameTeam(Player) then
            Handler:ClearESP()
            return
        end

        local Position3D = GetCharacterPosition(Character)
        if not Position3D then
            Handler:ClearESP()
            return
        end

        if Opts.MaxDistance then
            local LocalPlayer = Players.LocalPlayer
            local MyChar = LocalPlayer and LocalPlayer.Character
            local MyPos = MyChar and GetCharacterPosition(MyChar)
            if MyPos and (Position3D - MyPos).Magnitude > Opts.MaxDistance then
                Handler:ClearESP()
                return
            end
        end

        if Opts.VisibleCheck and not IsPlayerVisible(Character) then
            if Opts.Chams then
                Handler:UpdateChams(Player, false)
            end
            if not Handler.BoxLines[1] then
                return
            end
        end

        local ScreenPos = WorldToScreen(Position3D)
        if not ScreenPos then
            Handler:ClearESP()
            return
        end

        Handler.TargetPlayer = Player

        local BoxColor = Opts.BoxColor
        if not BoxColor then
            if Opts.TeamCheck then
                BoxColor = IsOnSameTeam(Player) and self.TeamColor or self.EnemyColor
            else
                BoxColor = self.DefaultBoxColor
            end
        end

        local Bottom, Top = GetCharacterBoundingBox(Character)
        if Bottom and Top then
            local BottomScreen = WorldToScreen(Bottom)
            local TopScreen = WorldToScreen(Top)

            if BottomScreen and TopScreen then
                local Height = math.abs(BottomScreen.Y - TopScreen.Y)
                local Width = Height * 0.55

                if Width < 4 or Height < 8 then
                    Handler:ClearESP()
                    return
                end

                local CenterX = (TopScreen.X + BottomScreen.X) / 2
                local TopY = TopScreen.Y
                local LeftX = CenterX - Width / 2

                if Opts.Box ~= false then
                    Handler:DrawBox(
                        LeftX,
                        TopY,
                        Width,
                        Height,
                        BoxColor,
                        Opts.BoxStyle or "Corner",
                        Opts.BoxTransparency or 0,
                        Opts.BoxThickness or 1
                    )
                end

                if Opts.HealthBar ~= false then
                    local HealthPercent = math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)
                    local HealthColor = Color3.fromRGB(
                        math.floor(255 * (1 - HealthPercent)),
                        math.floor(255 * HealthPercent),
                        0
                    )
                    Handler:DrawHealthBar(
                        LeftX - 6,
                        TopY,
                        4,
                        Height,
                        HealthPercent,
                        HealthColor,
                        Opts.HealthBarTransparency or 0
                    )
                end

                if Opts.Name ~= false then
                    Handler:DrawName(
                        Player.Name,
                        CenterX,
                        TopY - 14,
                        Opts.NameSize or 13,
                        Opts.NameColor or Color3.fromRGB(255, 255, 255)
                    )
                end

                if Opts.Distance ~= false then
                    local LocalPlayer = Players.LocalPlayer
                    local MyChar = LocalPlayer and LocalPlayer.Character
                    local MyPos = MyChar and GetCharacterPosition(MyChar)
                    local DistanceText = ""
                    if MyPos then
                        local Dist = math.floor((Position3D - MyPos).Magnitude + 0.5)
                        DistanceText = tostring(Dist) .. " studs"
                    end
                    Handler:DrawDistance(
                        DistanceText,
                        CenterX,
                        BottomScreen.Y + 4,
                        Opts.DistanceColor or Color3.fromRGB(200, 200, 200)
                    )
                end

                if Opts.Tracer then
                    local Origin = Opts.TracerOrigin or "Bottom"
                    local StartX, StartY

                    if Origin == "Mouse" then
                        local MousePos = UserInputService:GetMouseLocation()
                        StartX = MousePos.X
                        StartY = MousePos.Y
                    elseif Origin == "Middle" then
                        local Viewport = workspace.CurrentCamera
                                and workspace.CurrentCamera.ViewportSize
                            or Vector2.new(1920, 1080)
                        StartX = Viewport.X / 2
                        StartY = Viewport.Y
                    else
                        local Viewport = workspace.CurrentCamera
                                and workspace.CurrentCamera.ViewportSize
                            or Vector2.new(1920, 1080)
                        StartX = Viewport.X / 2
                        StartY = Viewport.Y
                    end

                    Handler:DrawTracer(
                        StartX,
                        StartY,
                        CenterX,
                        BottomScreen.Y,
                        Opts.TracerColor or BoxColor,
                        Opts.TracerTransparency or 0
                    )
                end
            end
        end

        if Opts.Chams then
            Handler:UpdateChams(Player, true, Opts.ChamsColor, Opts.ChamsTransparency or 0.5)
        end
    end

    function Handler:DrawBox(
        Left: number,
        Top: number,
        Width: number,
        Height: number,
        Color: Color3,
        Style: BoxStyle,
        Transparency: number,
        Thickness: number
    )
        local ScreenGui = self.Library.ScreenGui
        local StyleStr = Style or "Corner"

        local function MakeLine(Index: number, Props: { [string]: any })
            if self.BoxLines[Index] and self.BoxLines[Index].Parent then
                for K, V in Props do
                    self.BoxLines[Index][K] = V
                end
                return
            end

            local Line = Instance.new("Frame")
            Line.BorderSizePixel = 0
            Line.BackgroundColor3 = Color
            Line.BackgroundTransparency = Transparency
            Line.ZIndex = 9999
            Line.Parent = ScreenGui

            for K, V in Props do
                Line[K] = V
            end

            if self.BoxLines[Index] then
                self.BoxLines[Index]:Destroy()
            end
            self.BoxLines[Index] = Line
        end

        if StyleStr == "Standard" then
            MakeLine(1, {
                Position = UDim2.fromOffset(Left, Top),
                Size = UDim2.fromOffset(Width, Thickness),
            })
            MakeLine(2, {
                Position = UDim2.fromOffset(Left, Top + Height),
                Size = UDim2.fromOffset(Width, Thickness),
            })
            MakeLine(3, {
                Position = UDim2.fromOffset(Left, Top),
                Size = UDim2.fromOffset(Thickness, Height),
            })
            MakeLine(4, {
                Position = UDim2.fromOffset(Left + Width, Top),
                Size = UDim2.fromOffset(Thickness, Height),
            })
        elseif StyleStr == "Outline" then
            local OutlineFrame = self.BoxLines[1]
            if not OutlineFrame or not OutlineFrame.Parent then
                if OutlineFrame then
                    OutlineFrame:Destroy()
                end
                OutlineFrame = Instance.new("Frame")
                OutlineFrame.BorderSizePixel = 0
                OutlineFrame.BackgroundTransparency = 1
                OutlineFrame.ZIndex = 9998
                OutlineFrame.Parent = ScreenGui
                self.BoxLines[1] = OutlineFrame
            end

            OutlineFrame.Position = UDim2.fromOffset(Left - 1, Top - 1)
            OutlineFrame.Size = UDim2.fromOffset(Width + 2, Height + 2)

            local Inner = self.BoxLines[2]
            if not Inner or not Inner.Parent then
                if Inner then
                    Inner:Destroy()
                end
                Inner = Instance.new("Frame")
                Inner.BorderSizePixel = 0
                Inner.BackgroundColor3 = Color
                Inner.BackgroundTransparency = Transparency
                Inner.ZIndex = 9999
                Inner.Parent = OutlineFrame
                self.BoxLines[2] = Inner
            end

            Inner.Position = UDim2.fromOffset(1, 1)
            Inner.Size = UDim2.fromOffset(Width, Height)
            Inner.BackgroundColor3 = Color

            for i = 3, #self.BoxLines do
                if self.BoxLines[i] then
                    self.BoxLines[i]:Destroy()
                    self.BoxLines[i] = nil
                end
            end
        else
            local CornerLength = math.min(Width * 0.2, Height * 0.2, 16)

            MakeLine(1, {
                Position = UDim2.fromOffset(Left, Top),
                Size = UDim2.fromOffset(CornerLength, Thickness),
            })
            MakeLine(2, {
                Position = UDim2.fromOffset(Left + Width - CornerLength, Top),
                Size = UDim2.fromOffset(CornerLength, Thickness),
            })
            MakeLine(3, {
                Position = UDim2.fromOffset(Left, Top + Height),
                Size = UDim2.fromOffset(CornerLength, Thickness),
            })
            MakeLine(4, {
                Position = UDim2.fromOffset(Left + Width - CornerLength, Top + Height),
                Size = UDim2.fromOffset(CornerLength, Thickness),
            })
            MakeLine(5, {
                Position = UDim2.fromOffset(Left, Top),
                Size = UDim2.fromOffset(Thickness, CornerLength),
            })
            MakeLine(6, {
                Position = UDim2.fromOffset(Left + Width, Top),
                Size = UDim2.fromOffset(Thickness, CornerLength),
            })
            MakeLine(7, {
                Position = UDim2.fromOffset(Left, Top + Height - CornerLength),
                Size = UDim2.fromOffset(Thickness, CornerLength),
            })
            MakeLine(8, {
                Position = UDim2.fromOffset(Left + Width, Top + Height - CornerLength),
                Size = UDim2.fromOffset(Thickness, CornerLength),
            })
        end
    end

    function Handler:DrawHealthBar(
        Left: number,
        Top: number,
        Width: number,
        Height: number,
        Percent: number,
        Color: Color3,
        Transparency: number
    )
        local ScreenGui = self.Library.ScreenGui

        if not self.HealthBarFrame or not self.HealthBarFrame.Parent then
            if self.HealthBarFrame then
                self.HealthBarFrame:Destroy()
            end
            self.HealthBarFrame = Instance.new("Frame")
            self.HealthBarFrame.BorderSizePixel = 0
            self.HealthBarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            self.HealthBarFrame.BackgroundTransparency = Transparency
            self.HealthBarFrame.ZIndex = 9999
            self.HealthBarFrame.Parent = ScreenGui

            self.HealthBarFill = Instance.new("Frame")
            self.HealthBarFill.BorderSizePixel = 0
            self.HealthBarFill.ZIndex = 10000
            self.HealthBarFill.Parent = self.HealthBarFrame
        end

        self.HealthBarFrame.Position = UDim2.fromOffset(Left, Top)
        self.HealthBarFrame.Size = UDim2.fromOffset(Width, Height)

        self.HealthBarFill.BackgroundColor3 = Color
        self.HealthBarFill.BackgroundTransparency = Transparency
        self.HealthBarFill.Size = UDim2.fromScale(1, Percent)
        self.HealthBarFill.Position = UDim2.fromScale(0, 1 - Percent)
    end

    function Handler:DrawName(
        Text: string,
        CenterX: number,
        TopY: number,
        Size: number,
        Color: Color3
    )
        if not self.NameLabel or not self.NameLabel.Parent then
            if self.NameLabel then
                self.NameLabel:Destroy()
            end
            self.NameLabel = Instance.new("TextLabel")
            self.NameLabel.BackgroundTransparency = 1
            self.NameLabel.BorderSizePixel = 0
            self.NameLabel.FontFace = Font.fromEnum(Enum.Font.Code)
            self.NameLabel.RichText = true
            self.NameLabel.TextStrokeTransparency = 0.5
            self.NameLabel.ZIndex = 9999
            self.NameLabel.Parent = self.Library.ScreenGui
        end

        self.NameLabel.Text = Text
        self.NameLabel.TextColor3 = Color
        self.NameLabel.TextSize = Size
        self.NameLabel.Size = UDim2.fromOffset(200, Size + 4)
        self.NameLabel.Position = UDim2.fromOffset(CenterX - 100, TopY)
        self.NameLabel.TextXAlignment = Enum.TextXAlignment.Center
    end

    function Handler:DrawDistance(Text: string, CenterX: number, BottomY: number, Color: Color3)
        if not self.DistanceLabel or not self.DistanceLabel.Parent then
            if self.DistanceLabel then
                self.DistanceLabel:Destroy()
            end
            self.DistanceLabel = Instance.new("TextLabel")
            self.DistanceLabel.BackgroundTransparency = 1
            self.DistanceLabel.BorderSizePixel = 0
            self.DistanceLabel.FontFace = Font.fromEnum(Enum.Font.Code)
            self.DistanceLabel.RichText = true
            self.DistanceLabel.TextStrokeTransparency = 0.5
            self.DistanceLabel.TextSize = 11
            self.DistanceLabel.ZIndex = 9999
            self.DistanceLabel.Parent = self.Library.ScreenGui
        end

        self.DistanceLabel.Text = Text
        self.DistanceLabel.TextColor3 = Color
        self.DistanceLabel.Size = UDim2.fromOffset(200, 16)
        self.DistanceLabel.Position = UDim2.fromOffset(CenterX - 100, BottomY)
        self.DistanceLabel.TextXAlignment = Enum.TextXAlignment.Center
    end

    function Handler:DrawTracer(
        StartX: number,
        StartY: number,
        EndX: number,
        EndY: number,
        Color: Color3,
        Transparency: number
    )
        local ScreenGui = self.Library.ScreenGui

        if not self.TracerLine or not self.TracerLine.Parent then
            if self.TracerLine then
                self.TracerLine:Destroy()
            end
            self.TracerLine = Instance.new("Frame")
            self.TracerLine.BorderSizePixel = 0
            self.TracerLine.ZIndex = 9998
            self.TracerLine.Parent = ScreenGui
        end

        local DX = EndX - StartX
        local DY = EndY - StartY
        local Length = math.sqrt(DX * DX + DY * DY)
        local Angle = math.atan2(DY, DX)

        self.TracerLine.BackgroundColor3 = Color
        self.TracerLine.BackgroundTransparency = Transparency
        self.TracerLine.Size = UDim2.fromOffset(Length, 1)
        self.TracerLine.Position = UDim2.fromOffset(StartX, StartY)
        self.TracerLine.Rotation = math.deg(Angle)
    end

    function Handler:UpdateChams(
        Player: Player,
        Enabled: boolean,
        Color: Color3?,
        Transparency: number?
    )
        if not Enabled then
            if self.ChamsHighlight and self.ChamsHighlight.Parent then
                self.ChamsHighlight:Destroy()
            end
            self.ChamsHighlight = nil
            return
        end

        local Character = Player.Character
        if not Character then
            return
        end

        local Highlight = self.ChamsHighlight
        if not Highlight or not Highlight.Parent then
            if Highlight then
                Highlight:Destroy()
            end
            Highlight = Instance.new("Highlight")
            Highlight.FillTransparency = Transparency or 0.5
            Highlight.OutlineTransparency = 1
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.Parent = Character
            self.ChamsHighlight = Highlight
        end

        Highlight.FillColor = Color or Color3.fromRGB(255, 255, 255)
        Highlight.Adornee = Character
    end

    function Handler:ClearESP()
        for i = 1, #self.BoxLines do
            if self.BoxLines[i] then
                self.BoxLines[i]:Destroy()
                self.BoxLines[i] = nil
            end
        end

        if self.HealthBarFrame then
            self.HealthBarFrame:Destroy()
            self.HealthBarFrame = nil
        end
        if self.HealthBarFill then
            self.HealthBarFill = nil
        end
        if self.NameLabel then
            self.NameLabel:Destroy()
            self.NameLabel = nil
        end
        if self.DistanceLabel then
            self.DistanceLabel:Destroy()
            self.DistanceLabel = nil
        end
        if self.TracerLine then
            self.TracerLine:Destroy()
            self.TracerLine = nil
        end
        if self.ChamsHighlight then
            self.ChamsHighlight:Destroy()
            self.ChamsHighlight = nil
        end

        self.TargetPlayer = nil
    end

    function Handler:Destroy()
        if self.Destroyed then
            return
        end
        self.Destroyed = true

        if self.Connections then
            for _, Connection in self.Connections do
                if Connection and Connection.Connected then
                    Connection:Disconnect()
                end
            end
        end

        self:ClearESP()
        ESPRoot.Players[self.TargetPlayer] = nil
    end

    function Handler:Update()
        if not self.TargetPlayer or not self.TargetPlayer.Parent then
            UpdateESPForPlayer(self.TargetPlayer)
            return
        end

        UpdateESPForPlayer(self.TargetPlayer)
    end

    local PlayerAddedConnection = Players.PlayerAdded:Connect(function(Player)
        if Player == Players.LocalPlayer then
            return
        end

        if Opts.CustomFilter and not Opts.CustomFilter(Player) then
            return
        end

        local PlayerHandler = setmetatable({}, {
            __index = Handler,
            __tostring = function()
                return "PlayerESP:" .. Player.Name
            end,
        })

        PlayerHandler.TargetPlayer = Player
        PlayerHandler.BoxLines = {}
        PlayerHandler.Connections = {}
        self.Players[Player] = PlayerHandler
    end)

    table.insert(Handler.Connections, PlayerAddedConnection)

    local PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(Player)
        local PlayerHandler = self.Players[Player]
        if PlayerHandler then
            PlayerHandler:Destroy()
        end
    end)

    table.insert(Handler.Connections, PlayerRemovingConnection)

    for _, Player in Players:GetPlayers() do
        if Player ~= Players.LocalPlayer then
            if Opts.CustomFilter and not Opts.CustomFilter(Player) then
                continue
            end

            local PlayerHandler = setmetatable({}, {
                __index = Handler,
            })

            PlayerHandler.TargetPlayer = Player
            PlayerHandler.BoxLines = {}
            PlayerHandler.Connections = {}
            self.Players[Player] = PlayerHandler
        end
    end

    self:_StartUpdateLoop()

    return Handler
end

function ESP:AddObjectESP(Target: Instance, Options: ObjectESPOptions)
    self:_EnsureLibrary()
    assert(typeof(Target) == "Instance", "ObjectESP target must be an Instance")
    assert(typeof(Options) == "table", "ObjectESP options must be a table")

    local Opts: ObjectESPOptions = Options
    local ObjectHandler = {
        Target = Target,
        Options = Opts,
        BoxLines = {},
        NameLabel = nil,
        DistanceLabel = nil,
        TracerLine = nil,
        HighlightInst = nil,
        Destroyed = false,
    }

    local function UpdateObjectESP()
        if ObjectHandler.Destroyed then
            return
        end

        if not Target or not Target.Parent then
            return
        end

        local Position3D
        if Target:IsA("BasePart") then
            Position3D = Target.Position
        elseif Target:IsA("Model") then
            Position3D = Target:GetPivot().Position
        elseif Target:IsA("Attachment") then
            Position3D = Target.WorldPosition
        else
            return
        end

        if Opts.MaxDistance then
            local LocalPlayer = Players.LocalPlayer
            local MyChar = LocalPlayer and LocalPlayer.Character
            local MyPos = MyChar and GetCharacterPosition(MyChar)
            if MyPos and (Position3D - MyPos).Magnitude > Opts.MaxDistance then
                ObjectHandler:ClearESP()
                return
            end
        end

        local ScreenPos = WorldToScreen(Position3D)
        if not ScreenPos then
            ObjectHandler:ClearESP()
            return
        end

        local BoxColor = Opts.BoxColor or Color3.fromRGB(255, 255, 0)

        if Opts.Box ~= false then
            local ObjectSize
            if Target:IsA("BasePart") then
                ObjectSize = Target.Size
            else
                ObjectSize = Vector3.new(4, 4, 4)
            end

            if ObjectSize then
                local TopPos = WorldToScreen(Position3D + Vector3World.new(0, ObjectSize.Y / 2, 0))
                local BottomPos =
                    WorldToScreen(Position3D - Vector3World.new(0, ObjectSize.Y / 2, 0))

                if TopPos and BottomPos then
                    local Height = math.abs(BottomPos.Y - TopPos.Y)
                    local Width = Height * 0.6

                    if Width > 4 and Height > 8 then
                        ObjectHandler:DrawBox(
                            (TopPos.X + BottomPos.X) / 2 - Width / 2,
                            TopPos.Y,
                            Width,
                            Height,
                            BoxColor,
                            "Standard",
                            Opts.BoxTransparency or 0,
                            1
                        )
                    end
                end
            end
        end

        local DisplayName = Opts.CustomName or Target.Name
        if Opts.Name ~= false then
            ObjectHandler:DrawName(
                DisplayName,
                ScreenPos.X,
                ScreenPos.Y - 14,
                13,
                Opts.NameColor or Color3.fromRGB(255, 255, 0)
            )
        end

        if Opts.Distance ~= false then
            local LocalPlayer = Players.LocalPlayer
            local MyChar = LocalPlayer and LocalPlayer.Character
            local MyPos = MyChar and GetCharacterPosition(MyChar)
            local DistanceText = ""
            if MyPos then
                local Dist = math.floor((Position3D - MyPos).Magnitude + 0.5)
                DistanceText = tostring(Dist) .. " studs"
            end
            ObjectHandler:DrawDistance(
                DistanceText,
                ScreenPos.X,
                ScreenPos.Y + 4,
                Opts.DistanceColor or Color3.fromRGB(200, 200, 200)
            )
        end

        if Opts.Tracer then
            local Viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
                or Vector2.new(1920, 1080)
            local StartX = Viewport.X / 2
            local StartY = Viewport.Y
            ObjectHandler:DrawTracer(
                StartX,
                StartY,
                ScreenPos.X,
                ScreenPos.Y,
                Opts.TracerColor or BoxColor,
                Opts.TracerTransparency or 0
            )
        end

        if Opts.Highlight and Target:IsA("BasePart") then
            if not ObjectHandler.HighlightInst or not ObjectHandler.HighlightInst.Parent then
                if ObjectHandler.HighlightInst then
                    ObjectHandler.HighlightInst:Destroy()
                end
                ObjectHandler.HighlightInst = Instance.new("Highlight")
                ObjectHandler.HighlightInst.FillTransparency = Opts.HighlightTransparency or 0.5
                ObjectHandler.HighlightInst.OutlineTransparency = 1
                ObjectHandler.HighlightInst.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                ObjectHandler.HighlightInst.Adornee = Target
                ObjectHandler.HighlightInst.Parent = Target
            end

            ObjectHandler.HighlightInst.FillColor = Opts.HighlightColor
                or Color3.fromRGB(255, 255, 0)
        elseif ObjectHandler.HighlightInst then
            ObjectHandler.HighlightInst:Destroy()
            ObjectHandler.HighlightInst = nil
        end
    end

    function ObjectHandler:DrawBox(
        Left: number,
        Top: number,
        Width: number,
        Height: number,
        Color: Color3,
        Style: BoxStyle,
        Transparency: number,
        Thickness: number
    )
        local function MakeLine(Index: number, Props: { [string]: any })
            if self.BoxLines[Index] and self.BoxLines[Index].Parent then
                for K, V in Props do
                    self.BoxLines[Index][K] = V
                end
                return
            end
            if self.BoxLines[Index] then
                self.BoxLines[Index]:Destroy()
            end
            local Line = Instance.new("Frame")
            Line.BorderSizePixel = 0
            Line.BackgroundColor3 = Color
            Line.BackgroundTransparency = Transparency or 0
            Line.ZIndex = 9999
            for K, V in Props do
                Line[K] = V
            end
            Line.Parent = self.Library.ScreenGui
            self.BoxLines[Index] = Line
        end

        MakeLine(
            1,
            { Position = UDim2.fromOffset(Left, Top), Size = UDim2.fromOffset(Width, Thickness) }
        )
        MakeLine(2, {
            Position = UDim2.fromOffset(Left, Top + Height),
            Size = UDim2.fromOffset(Width, Thickness),
        })
        MakeLine(
            3,
            { Position = UDim2.fromOffset(Left, Top), Size = UDim2.fromOffset(Thickness, Height) }
        )
        MakeLine(4, {
            Position = UDim2.fromOffset(Left + Width, Top),
            Size = UDim2.fromOffset(Thickness, Height),
        })
    end

    function ObjectHandler:DrawName(
        Text: string,
        CenterX: number,
        TopY: number,
        Size: number,
        Color: Color3
    )
        if not self.NameLabel or not self.NameLabel.Parent then
            if self.NameLabel then
                self.NameLabel:Destroy()
            end
            self.NameLabel = Instance.new("TextLabel")
            self.NameLabel.BackgroundTransparency = 1
            self.NameLabel.BorderSizePixel = 0
            self.NameLabel.FontFace = Font.fromEnum(Enum.Font.Code)
            self.NameLabel.RichText = true
            self.NameLabel.TextStrokeTransparency = 0.5
            self.NameLabel.ZIndex = 9999
            self.NameLabel.Parent = self.Library.ScreenGui
        end
        self.NameLabel.Text = Text
        self.NameLabel.TextColor3 = Color
        self.NameLabel.TextSize = Size
        self.NameLabel.Size = UDim2.fromOffset(200, Size + 4)
        self.NameLabel.Position = UDim2.fromOffset(CenterX - 100, TopY)
        self.NameLabel.TextXAlignment = Enum.TextXAlignment.Center
    end

    function ObjectHandler:DrawDistance(
        Text: string,
        CenterX: number,
        BottomY: number,
        Color: Color3
    )
        if not self.DistanceLabel or not self.DistanceLabel.Parent then
            if self.DistanceLabel then
                self.DistanceLabel:Destroy()
            end
            self.DistanceLabel = Instance.new("TextLabel")
            self.DistanceLabel.BackgroundTransparency = 1
            self.DistanceLabel.BorderSizePixel = 0
            self.DistanceLabel.FontFace = Font.fromEnum(Enum.Font.Code)
            self.DistanceLabel.RichText = true
            self.DistanceLabel.TextStrokeTransparency = 0.5
            self.DistanceLabel.TextSize = 11
            self.DistanceLabel.ZIndex = 9999
            self.DistanceLabel.Parent = self.Library.ScreenGui
        end
        self.DistanceLabel.Text = Text
        self.DistanceLabel.TextColor3 = Color
        self.DistanceLabel.Size = UDim2.fromOffset(200, 16)
        self.DistanceLabel.Position = UDim2.fromOffset(CenterX - 100, BottomY)
        self.DistanceLabel.TextXAlignment = Enum.TextXAlignment.Center
    end

    function ObjectHandler:DrawTracer(
        StartX: number,
        StartY: number,
        EndX: number,
        EndY: number,
        Color: Color3,
        Transparency: number
    )
        if not self.TracerLine or not self.TracerLine.Parent then
            if self.TracerLine then
                self.TracerLine:Destroy()
            end
            self.TracerLine = Instance.new("Frame")
            self.TracerLine.BorderSizePixel = 0
            self.TracerLine.ZIndex = 9998
            self.TracerLine.Parent = self.Library.ScreenGui
        end
        local DX = EndX - StartX
        local DY = EndY - StartY
        local Length = math.sqrt(DX * DX + DY * DY)
        local Angle = math.atan2(DY, DX)
        self.TracerLine.BackgroundColor3 = Color
        self.TracerLine.BackgroundTransparency = Transparency or 0
        self.TracerLine.Size = UDim2.fromOffset(Length, 1)
        self.TracerLine.Position = UDim2.fromOffset(StartX, StartY)
        self.TracerLine.Rotation = math.deg(Angle)
    end

    function ObjectHandler:ClearESP()
        for i = 1, #self.BoxLines do
            if self.BoxLines[i] then
                self.BoxLines[i]:Destroy()
                self.BoxLines[i] = nil
            end
        end
        if self.NameLabel then
            self.NameLabel:Destroy()
            self.NameLabel = nil
        end
        if self.DistanceLabel then
            self.DistanceLabel:Destroy()
            self.DistanceLabel = nil
        end
        if self.TracerLine then
            self.TracerLine:Destroy()
            self.TracerLine = nil
        end
        if self.HighlightInst then
            self.HighlightInst:Destroy()
            self.HighlightInst = nil
        end
    end

    function ObjectHandler:Destroy()
        if ObjectHandler.Destroyed then
            return
        end
        ObjectHandler.Destroyed = true
        ObjectHandler:ClearESP()
        self.Objects[Target] = nil
    end

    function ObjectHandler:Update()
        UpdateObjectESP()
    end

    self.Objects[Target] = ObjectHandler
    self:_StartUpdateLoop()

    return ObjectHandler
end

function ESP:RemovePlayerESP(Player: Player)
    local Handler = self.Players[Player]
    if Handler then
        Handler:Destroy()
    end
end

function ESP:RemoveObjectESP(Target: Instance)
    local Handler = self.Objects[Target]
    if Handler then
        Handler:Destroy()
    end
end

function ESP:SetEnabled(Enabled: boolean)
    self.Enabled = Enabled
    for _, Handler in self.Players do
        if not Handler.Destroyed then
            Handler:ClearESP()
        end
    end
    for _, Handler in self.Objects do
        if not Handler.Destroyed then
            Handler:ClearESP()
        end
    end
end

function ESP:SetBoxesVisible(Visible: boolean)
    self.BoxesVisible = Visible
    for _, Handler in self.Players do
        if not Handler.Destroyed and Handler.Options then
            Handler.Options.Box = Visible
        end
    end
end

function ESP:SetNamesVisible(Visible: boolean)
    self.NamesVisible = Visible
    for _, Handler in self.Players do
        if not Handler.Destroyed and Handler.Options then
            Handler.Options.Name = Visible
        end
    end
end

function ESP:SetTracersVisible(Visible: boolean)
    self.TracersVisible = Visible
    for _, Handler in self.Players do
        if not Handler.Destroyed and Handler.Options then
            Handler.Options.Tracer = Visible
        end
    end
end

function ESP:SetTeamCheck(Enabled: boolean)
    self.TeamCheck = Enabled
    for _, Handler in self.Players do
        if not Handler.Destroyed and Handler.Options then
            Handler.Options.TeamCheck = Enabled
        end
    end
end

-- Aimbot + Magic Bullet system

export type AimbotHitbox = "Head" | "Torso" | "Limb" | "Random"
export type AimbotOptions = {
    Enabled: boolean?,
    SilentAim: boolean?,
    Prediction: boolean?,
    PredictionAmount: number?,
    Smoothness: number?,
    Hitbox: AimbotHitbox?,
    AutoFire: boolean?,
    AutoFireDelay: number?,
    FOV: number?,
    MaxDistance: number?,
    TeamCheck: boolean?,
    VisibleCheck: boolean?,
    MagicBullet: boolean?,
    MagicBulletChance: number?,
}

local AimbotDefaults: AimbotOptions = {
    Enabled = false,
    SilentAim = false,
    Prediction = true,
    PredictionAmount = 0.5,
    Smoothness = 0.8,
    Hitbox = "Torso",
    AutoFire = false,
    AutoFireDelay = 0.15,
    FOV = 60,
    MaxDistance = 1000,
    TeamCheck = true,
    VisibleCheck = false,
    MagicBullet = false,
    MagicBulletChance = 100,
}

local function GetHitboxPosition(Character: Model, Hitbox: AimbotHitbox): Vector3?
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then
        return nil
    end

    if Hitbox == "Head" then
        local Head = Character:FindFirstChild("Head")
        return Head and Head.Position
    end

    if Hitbox == "Torso" then
        local Torso = Character:FindFirstChild("HumanoidRootPart")
            or Character:FindFirstChild("UpperTorso")
            or Character:FindFirstChild("LowerTorso")
            or Character:FindFirstChild("Torso")
        return Torso and Torso.Position
    end

    if Hitbox == "Limb" then
        local Limbs = {
            Character:FindFirstChild("Left Arm"),
            Character:FindFirstChild("Right Arm"),
            Character:FindFirstChild("Left Leg"),
            Character:FindFirstChild("Right Leg"),
            Character:FindFirstChild("LeftHand"),
            Character:FindFirstChild("RightHand"),
            Character:FindFirstChild("LeftFoot"),
            Character:FindFirstChild("RightFoot"),
        }
        local Valid = {}
        for _, Limb in Limbs do
            if Limb then
                table.insert(Valid, Limb)
            end
        end
        if #Valid > 0 then
            return Valid[math.random(1, #Valid)].Position
        end
        return GetHitboxPosition(Character, "Torso")
    end

    if Hitbox == "Random" then
        local Choices = { "Head", "Torso", "Limb" }
        return GetHitboxPosition(Character, Choices[math.random(1, #Choices)])
    end

    return GetHitboxPosition(Character, "Torso")
end

local function PredictPosition(Target: Model, HitPos: Vector3, PredictionAmount: number): Vector3
    local RootPart = Target:FindFirstChild("HumanoidRootPart")
        or Target:FindFirstChild("UpperTorso")
        or Target:FindFirstChild("Torso")
    if not RootPart then
        return HitPos
    end

    local Velocity = RootPart.AssemblyLinearVelocity
    if Velocity.Magnitude < 1 then
        return HitPos
    end

    return HitPos + Velocity * PredictionAmount
end

function ESP:SetAimbotEnabled(Enabled: boolean)
    self._AimbotOptions.Enabled = Enabled
end

function ESP:SetAimbotOptions(Options: AimbotOptions)
    for K, V in Options do
        if self._AimbotOptions[K] ~= nil then
            self._AimbotOptions[K] = V
        end
    end
end

function ESP:GetAimbotTarget(): (Player?, Vector3?)
    local Opts = self._AimbotOptions
    if not Opts.Enabled then
        return nil, nil
    end

    local LocalPlayer = Players.LocalPlayer
    local MyChar = LocalPlayer and LocalPlayer.Character
    local MyRoot = MyChar
        and (
            MyChar:FindFirstChild("HumanoidRootPart")
            or MyChar:FindFirstChild("UpperTorso")
            or MyChar:FindFirstChild("Torso")
        )
    if not MyRoot then
        return nil, nil
    end

    local MousePos = UserInputService:GetMouseLocation()
    local ClosestPlayer: Player? = nil
    local ClosestHitPos: Vector3? = nil
    local ClosestScreenDist = math.huge

    for Player, Handler in self.Players do
        if Handler.Destroyed or not Handler.TargetPlayer then
            continue
        end
        if Player == LocalPlayer then
            continue
        end

        local Character = Player.Character
        if not Character then
            continue
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then
            continue
        end

        if Opts.TeamCheck and IsOnSameTeam(Player) then
            continue
        end

        local HitPos = GetHitboxPosition(Character, Opts.Hitbox)
        if not HitPos then
            continue
        end

        local Dist = (MyRoot.Position - HitPos).Magnitude
        if Dist > Opts.MaxDistance then
            continue
        end

        if Opts.VisibleCheck then
            local Camera = workspace.CurrentCamera
            local RaycastParams = RaycastParams.new()
            RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            RaycastParams.FilterDescendantsInstances = { Camera, MyChar, Character }
            local Direction = (HitPos - MyRoot.Position).Unit
            local Result = workspace:Raycast(MyRoot.Position, Direction * Dist, RaycastParams)
            if Result then
                continue
            end
        end

        local TargetPos = Opts.Prediction
                and PredictPosition(Character, HitPos, Opts.PredictionAmount)
            or HitPos
        local ScreenPos = WorldToScreen(TargetPos)
        if not ScreenPos then
            continue
        end

        local DX = ScreenPos.X - MousePos.X
        local DY = ScreenPos.Y - MousePos.Y
        local ScreenDist = math.sqrt(DX * DX + DY * DY)

        if ScreenDist <= Opts.FOV and ScreenDist < ClosestScreenDist then
            ClosestScreenDist = ScreenDist
            ClosestPlayer = Player
            ClosestHitPos = TargetPos
        end
    end

    return ClosestPlayer, ClosestHitPos
end

function ESP:GetAimbotTargetPosition(Player: Player): Vector3?
    local Character = Player.Character
    if not Character then
        return nil
    end
    return GetHitboxPosition(Character, self._AimbotOptions.Hitbox)
end

-- Silent Aim: rotate character toward target without visible snapping
local function SetupSilentAim(self: any)
    local LastTargetPos = nil

    local SilentAimConnection = RunService.RenderStepped:Connect(function()
        if self.Destroyed then
            return
        end
        local Opts = self._AimbotOptions
        if not Opts.Enabled or not Opts.SilentAim then
            LastTargetPos = nil
            return
        end

        local LocalPlayer = Players.LocalPlayer
        local MyChar = LocalPlayer and LocalPlayer.Character
        local MyRoot = MyChar
            and (
                MyChar:FindFirstChild("HumanoidRootPart")
                or MyChar:FindFirstChild("UpperTorso")
                or MyChar:FindFirstChild("Torso")
            )
        if not MyRoot then
            return
        end

        local Target, HitPos = self:GetAimbotTarget()
        if not Target or not HitPos then
            return
        end

        if Opts.Smoothness and Opts.Smoothness < 1 then
            if LastTargetPos then
                HitPos = LastTargetPos:Lerp(HitPos, 1 - Opts.Smoothness)
            end
            LastTargetPos = HitPos
        end

        local LookCF =
            CFrame.lookAt(MyRoot.Position, Vector3.new(HitPos.X, MyRoot.Position.Y, HitPos.Z))
        MyRoot.CFrame = LookCF
    end)
    table.insert(self.Connections, SilentAimConnection)
end

-- Magic Bullet: redirect projectiles / tool fire to target
local function SetupMagicBullet(self: any)
    local ProjectileConnection = nil

    local function CreateMagicTracker(Child: Instance)
        if self.Destroyed then
            return
        end
        local Opts = self._AimbotOptions
        if not Opts.Enabled or not Opts.MagicBullet then
            return
        end
        if not Child:IsA("BasePart") then
            return
        end

        local LocalPlayer = Players.LocalPlayer
        local MyChar = LocalPlayer and LocalPlayer.Character
        if not MyChar then
            return
        end

        local Handle = nil
        local Tool = MyChar:FindFirstChildOfClass("Tool")
        if Tool then
            Handle = Tool:FindFirstChild("Handle")
        end
        if not Handle then
            return
        end

        local DistFromHandle = Handle and (Child.Position - Handle.Position).Magnitude or 999
        if DistFromHandle > 20 then
            return
        end

        local Target, HitPos = self:GetAimbotTarget()
        if not Target or not HitPos then
            return
        end
        local TargetChar = Target.Character
        if not TargetChar then
            return
        end

        if math.random(1, 100) > Opts.MagicBulletChance then
            return
        end

        if Opts.Prediction then
            HitPos = PredictPosition(TargetChar, HitPos, Opts.PredictionAmount)
        end

        local AlignPos = Instance.new("AlignPosition")
        AlignPos.MaxForce = 1e9
        AlignPos.MaxVelocity = 1e9
        AlignPos.Responsiveness = 200
        AlignPos.Parent = Child

        local Attach0 = Instance.new("Attachment", Child)
        AlignPos.Attachment0 = Attach0

        local TargetRoot = TargetChar:FindFirstChild("HumanoidRootPart")
            or TargetChar:FindFirstChild("UpperTorso")
            or TargetChar:FindFirstChild("Torso")
            or TargetChar
        local Attach1 = Instance.new("Attachment", TargetRoot)
        Attach1.WorldPosition = HitPos
        AlignPos.Attachment1 = Attach1

        game:GetService("Debris"):AddItem(Attach1, 0.5)
        game:GetService("Debris"):AddItem(AlignPos, 1)
    end

    if ProjectileConnection then
        ProjectileConnection:Disconnect()
    end
    ProjectileConnection = workspace.ChildAdded:Connect(CreateMagicTracker)
    table.insert(self.Connections, ProjectileConnection)

    -- Also check existing projectiles once per second
    local ScanConnection = RunService.Stepped:Connect(function()
        if self.Destroyed then
            return
        end
        local Opts = self._AimbotOptions
        if not Opts.Enabled or not Opts.MagicBullet then
            return
        end
        for _, Child in workspace:GetChildren() do
            if Child:IsA("BasePart") and Child.Name:find("[Pp]rojectile") then
                CreateMagicTracker(Child)
            end
        end
    end)
    table.insert(self.Connections, ScanConnection)
end

-- Auto-fire: fire tool when a target is in FOV
local function SetupAutoFire(self: any)
    local LastFire = 0
    local AutoFireConnection = RunService.RenderStepped:Connect(function()
        if self.Destroyed then
            return
        end
        local Opts = self._AimbotOptions
        if not Opts.Enabled or not Opts.AutoFire then
            LastFire = 0
            return
        end

        local Target, _ = self:GetAimbotTarget()
        if not Target then
            return
        end

        local LocalPlayer = Players.LocalPlayer
        local MyChar = LocalPlayer and LocalPlayer.Character
        if not MyChar then
            return
        end

        local Tool = MyChar:FindFirstChildOfClass("Tool")
        if not Tool then
            return
        end

        local Now = tick()
        if Now - LastFire < Opts.AutoFireDelay then
            return
        end
        LastFire = Now

        local ClickFunction = Tool:FindFirstChild("Click")
        if ClickFunction and ClickFunction:IsA("BindableFunction") then
            ClickFunction:Invoke()
        end

        local Activate = Tool:FindFirstChild("Activate")
        if Activate and Activate:IsA("BindableFunction") then
            Activate:Invoke()
        end

        local ToolRemote = Tool:FindFirstChildWhichIsA("RemoteEvent")
            or Tool:FindFirstChildWhichIsA("RemoteFunction")
        if ToolRemote then
            ToolRemote:FireServer()
        end
    end)
    table.insert(self.Connections, AutoFireConnection)
end

function ESP:GetNearestPlayerToMouse(MaxDistance: number?): (Player?, number?)
    self:_EnsureLibrary()

    local MousePos = UserInputService:GetMouseLocation()
    local ClosestPlayer: Player? = nil
    local ClosestDistance = MaxDistance or math.huge

    for Player, Handler in self.Players do
        if Handler.Destroyed or not Handler.TargetPlayer then
            continue
        end

        local Character = Player.Character
        if not Character then
            continue
        end

        local Position3D = GetCharacterPosition(Character)
        if not Position3D then
            continue
        end

        local ScreenPos = WorldToScreen(Position3D)
        if not ScreenPos then
            continue
        end

        local DX = ScreenPos.X - MousePos.X
        local DY = ScreenPos.Y - MousePos.Y
        local Distance = math.sqrt(DX * DX + DY * DY)

        if Distance < ClosestDistance then
            ClosestDistance = Distance
            ClosestPlayer = Player
        end
    end

    return ClosestPlayer, ClosestDistance
end

function ESP:GetNearestPlayerToCharacter(MaxDistance: number?): (Player?, number?)
    self:_EnsureLibrary()

    local LocalPlayer = Players.LocalPlayer
    local MyChar = LocalPlayer and LocalPlayer.Character
    local MyPos = MyChar and GetCharacterPosition(MyChar)

    if not MyPos then
        return nil, nil
    end

    local ClosestPlayer: Player? = nil
    local ClosestDistance = MaxDistance or math.huge

    for Player, Handler in self.Players do
        if Handler.Destroyed then
            continue
        end

        local Character = Player.Character
        if not Character then
            continue
        end

        local Position3D = GetCharacterPosition(Character)
        if not Position3D then
            continue
        end

        local Distance = (Position3D - MyPos).Magnitude
        if Distance < ClosestDistance then
            ClosestDistance = Distance
            ClosestPlayer = Player
        end
    end

    return ClosestPlayer, ClosestDistance
end

function ESP:IsTargetInFOV(Target: Player | Model, FOVRadius: number): boolean
    self:_EnsureLibrary()

    local Character
    if typeof(Target) == "Instance" and Target:IsA("Player") then
        Character = Target.Character
    elseif typeof(Target) == "Instance" and Target:IsA("Model") then
        Character = Target
    else
        return false
    end

    if not Character then
        return false
    end

    local Position3D = GetCharacterPosition(Character)
    if not Position3D then
        return false
    end

    local ScreenPos = WorldToScreen(Position3D)
    if not ScreenPos then
        return false
    end

    local MousePos = UserInputService:GetMouseLocation()
    local DX = ScreenPos.X - MousePos.X
    local DY = ScreenPos.Y - MousePos.Y
    local Distance = math.sqrt(DX * DX + DY * DY)

    return Distance <= (FOVRadius or 60)
end

function ESP:LockOntoTarget(Player: Player)
    self:_EnsureLibrary()
    self.TargetLock = Player
end

function ESP:UnlockTarget()
    self.TargetLock = nil
end

function ESP:GetLockedTarget(): Player?
    return self.TargetLock
end

function ESP:GetAllPlayers(): { Player }
    local Result = {}
    for Player, Handler in self.Players do
        if not Handler.Destroyed then
            table.insert(Result, Player)
        end
    end
    return Result
end

function ESP:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    for _, PlayerHandler in self.Players do
        PlayerHandler:Destroy()
    end
    for _, ObjectHandler in self.Objects do
        ObjectHandler:Destroy()
    end

    if self.FOVDrawing then
        self.FOVDrawing:Destroy()
        self.FOVDrawing = nil
    end

    for Index = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, Index)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end
    self.UpdateConnection = nil

    self.TargetLock = nil
end

return ESP
]]))()

--// addons/Radar.lua //--
local Radar = (loadstring([[
--!strict
-- Cyan Radar addon: a 2D top-down minimap showing player positions, facing direction,
-- and configurable zoom/range with team colors and FOV overlay.

local Radar = {}
Radar.__index = Radar

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")

export type BlipStyle = "Dot" | "Arrow" | "Ring"
export type RadarPosition = "TopLeft" | "TopRight" | "BottomLeft" | "BottomRight" | "Custom"

export type RadarOptions = {
    Range: number?,
    Zoom: number?,
    Size: number?,
    Position: RadarPosition?,
    CustomPosition: UDim2?,
    BackgroundTransparency: number?,
    BackgroundColor: Color3?,
    BorderColor: Color3?,
    ShowLocalFOV: boolean?,
    FOVColor: Color3?,
    FOVTransparency: number?,
    FOVAngle: number?,
    BlipStyle: BlipStyle?,
    BlipSize: number?,
    ShowNames: boolean?,
    ShowGrid: boolean?,
    TeamColor: Color3?,
    EnemyColor: Color3?,
    LocalColor: Color3?,
    DotColor: Color3?,
    Visible: boolean?,
    UpdateInterval: number?,
}

local function GetCharacterPosition(Character: Model): Vector3?
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")
    if RootPart then
        return RootPart.Position
    end
    return Character:GetPivot().Position
end

local function GetCharacterCFrame(Character: Model): CFrame?
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
    if RootPart then
        return RootPart.CFrame
    end
    return nil
end

local function IsOnSameTeam(Target: Player): boolean
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then
        return false
    end
    return LocalPlayer.Team and Target.Team and LocalPlayer.Team == Target.Team
end

local function CreateRadarInstance(ClassName: string, Properties: { [string]: any }): Instance
    local Inst = Instance.new(ClassName)
    for Key, Value in Properties do
        Inst[Key] = Value
    end
    return Inst
end

function Radar.new(Library: any, Options: RadarOptions?)
    assert(typeof(Library) == "table", "Radar requires a Cyan Library instance")
    assert(typeof(Library.ScreenGui) == "Instance", "Radar requires Library.ScreenGui")

    local Config: RadarOptions = Options or {}
    local Size = Config.Size or 180
    local HalfSize = Size / 2

    local ScreenGui = Library.ScreenGui

    local Holder = CreateRadarInstance("Frame", {
        Name = "CyanRadar",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(Size + 8, Size + 8),
        Position = UDim2.fromOffset(6, 6),
        ZIndex = 9000,
        Visible = Config.Visible ~= false,
        Parent = ScreenGui,
    })

    local function ApplyPosition(Position: RadarPosition)
        if Position == "TopRight" then
            Holder.AnchorPoint = Vector2.new(1, 0)
            Holder.Position = UDim2.new(1, -6, 0, 6)
        elseif Position == "BottomLeft" then
            Holder.AnchorPoint = Vector2.new(0, 1)
            Holder.Position = UDim2.new(0, 6, 1, -6)
        elseif Position == "BottomRight" then
            Holder.AnchorPoint = Vector2.new(1, 1)
            Holder.Position = UDim2.new(1, -6, 1, -6)
        elseif Position == "Custom" and Config.CustomPosition then
            Holder.AnchorPoint = Vector2.new(0, 0)
            Holder.Position = Config.CustomPosition
        else
            Holder.AnchorPoint = Vector2.new(0, 0)
            Holder.Position = UDim2.fromOffset(6, 6)
        end
    end

    ApplyPosition(Config.Position or "TopLeft")

    local BorderFrame = CreateRadarInstance("Frame", {
        BackgroundColor3 = Config.BackgroundColor or Library.Scheme.BackgroundColor,
        BackgroundTransparency = Config.BackgroundTransparency or 0.2,
        Size = UDim2.fromOffset(Size, Size),
        Position = UDim2.fromOffset(4, 4),
        ZIndex = 9001,
        Parent = Holder,
    })

    local BorderCorner = CreateRadarInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = BorderFrame,
    })

    local BorderStroke = CreateRadarInstance("UIStroke", {
        Color = Config.BorderColor or Library.Scheme.OutlineColor,
        Thickness = 1.5,
        Parent = BorderFrame,
    })

    local ClipFrame = CreateRadarInstance("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ClipsDescendants = true,
        ZIndex = 9002,
        Parent = BorderFrame,
    })

    local MaskCorner = CreateRadarInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ClipFrame,
    })

    local RadarCanvas = CreateRadarInstance("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0, 0),
        ZIndex = 9003,
        Parent = ClipFrame,
    })

    local FOVCone = CreateRadarInstance("ImageLabel", {
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/WhiteCircle.png",
        ImageColor3 = Config.FOVColor or Library.Scheme.AccentColor,
        ImageTransparency = Config.FOVTransparency or 0.7,
        Size = UDim2.fromScale(2, 2),
        Position = UDim2.fromScale(-0.5, -0.5),
        Visible = Config.ShowLocalFOV ~= false,
        ZIndex = 9004,
        Parent = RadarCanvas,
    })

    local CrosshairV = CreateRadarInstance("Frame", {
        BackgroundColor3 = Config.BorderColor or Library.Scheme.OutlineColor,
        BackgroundTransparency = 0.5,
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.fromOffset(1, Size),
        ZIndex = 9005,
        Parent = RadarCanvas,
    })

    local CrosshairH = CreateRadarInstance("Frame", {
        BackgroundColor3 = Config.BorderColor or Library.Scheme.OutlineColor,
        BackgroundTransparency = 0.5,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(Size, 1),
        ZIndex = 9005,
        Parent = RadarCanvas,
    })

    -- Grid rings
    local GridRings = {}
    if Config.ShowGrid ~= false then
        local RingDistances = { 0.25, 0.5, 0.75 }
        for _, Fraction in RingDistances do
            local Ring = CreateRadarInstance("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5 - Fraction / 2, 0.5 - Fraction / 2),
                Size = UDim2.fromScale(Fraction, Fraction),
                ZIndex = 9004,
                Parent = RadarCanvas,
            })
            local RingCorner = CreateRadarInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = Ring,
            })
            local RingStroke = CreateRadarInstance("UIStroke", {
                Color = Config.BorderColor or Library.Scheme.OutlineColor,
                Thickness = 1,
                Transparency = 0.7,
                Parent = Ring,
            })
            GridRings[#GridRings + 1] = Ring
        end
    end

    local Self: any = setmetatable({
        Library = Library,
        Holder = Holder,
        BorderFrame = BorderFrame,
        ClipFrame = ClipFrame,
        RadarCanvas = RadarCanvas,
        FOVCone = FOVCone,
        CrosshairV = CrosshairV,
        CrosshairH = CrosshairH,
        GridRings = GridRings,
        Blips = {},
        BlipPool = {},
        NameLabels = {},
        Range = Config.Range or 150,
        Zoom = Config.Zoom or 1,
        Size = Size,
        HalfSize = HalfSize,
        BackgroundTransparency = Config.BackgroundTransparency or 0.2,
        BackgroundColor = Config.BackgroundColor or Library.Scheme.BackgroundColor,
        BorderColor = Config.BorderColor or Library.Scheme.OutlineColor,
        ShowLocalFOV = Config.ShowLocalFOV ~= false,
        FOVColor = Config.FOVColor or Library.Scheme.AccentColor,
        FOVTransparency = Config.FOVTransparency or 0.7,
        FOVAngle = Config.FOVAngle or 90,
        BlipStyle = Config.BlipStyle or "Arrow",
        BlipSize = Config.BlipSize or 4,
        ShowNames = Config.ShowNames or false,
        ShowGrid = Config.ShowGrid ~= false,
        TeamColor = Config.TeamColor or Color3.fromRGB(0, 255, 0),
        EnemyColor = Config.EnemyColor or Color3.fromRGB(255, 50, 50),
        LocalColor = Config.LocalColor or Color3.fromRGB(0, 150, 255),
        DotColor = Config.DotColor or Color3.fromRGB(255, 255, 255),
        Visible = Config.Visible ~= false,
        UpdateInterval = math.clamp(Config.UpdateInterval or 0.1, 0.03, 0.5),
        DisplayElapsed = 0,
        Connections = {},
        UpdateConnection = nil,
        Destroyed = false,
        PositionMode = Config.Position or "TopLeft",
        CustomPosition = Config.CustomPosition,
    }, Radar)

    local function CreateBlip(Player: Player): Frame
        local Blip = CreateRadarInstance("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0,
            Size = UDim2.fromOffset(Self.BlipSize * 2, Self.BlipSize * 2),
            Position = UDim2.fromScale(0.5, 0.5),
            ZIndex = 9010,
            Visible = false,
            Parent = RadarCanvas,
        })

        local BlipCorner = CreateRadarInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Blip,
        })

        local NameLabel = CreateRadarInstance("TextLabel", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            FontFace = Font.fromEnum(Enum.Font.Code),
            RichText = true,
            Text = Player.Name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 10,
            TextStrokeTransparency = 0.6,
            Size = UDim2.fromOffset(60, 14),
            Position = UDim2.fromOffset(Self.BlipSize * 2 + 2, -Self.BlipSize),
            ZIndex = 9011,
            Visible = Self.ShowNames,
            Parent = Blip,
        })

        local DirectionArrow = CreateRadarInstance("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.fromOffset(6, 2),
            Position = UDim2.fromOffset(-3, Self.BlipSize - 1),
            ZIndex = 9012,
            Visible = Self.BlipStyle == "Arrow",
            Parent = Blip,
        })

        local Entry: any = {
            Blip = Blip,
            DirectionArrow = DirectionArrow,
            NameLabel = NameLabel,
            Player = Player,
        }
        Self.Blips[Player] = Entry
        return Blip
    end

    local function GetBlip(Player: Player): Frame?
        local Entry = Self.Blips[Player]
        if Entry then
            return Entry.Blip
        end
        return nil
    end

    local function UpdateRadar()
        if Self.Destroyed or not Self.Visible then
            return
        end

        local LocalPlayer = Players.LocalPlayer
        if not LocalPlayer then
            return
        end

        local MyCharacter = LocalPlayer.Character
        if not MyCharacter then
            return
        end

        local MyPosition = GetCharacterPosition(MyCharacter)
        local MyCFrame = GetCharacterCFrame(MyCharacter)
        if not MyPosition or not MyCFrame then
            return
        end

        local EffectiveRange = Self.Range / Self.Zoom
        local Scale = Self.HalfSize / EffectiveRange
        local MyForward = -MyCFrame.LookVector
        local MyAngle = math.atan2(MyForward.X, MyForward.Z)

        if Self.ShowLocalFOV then
            Self.FOVCone.Visible = true
            Self.FOVCone.Rotation = math.deg(MyAngle) - 90 - Self.FOVAngle / 2
        else
            Self.FOVCone.Visible = false
        end

        local BlipSize = Self.BlipSize
        local BlipStyle = Self.BlipStyle

        local function UpdateBlip(Player: Player)
            local Character = Player.Character
            if not Character then
                return
            end

            if Player == LocalPlayer then
                return
            end

            local TargetPos = GetCharacterPosition(Character)
            if not TargetPos then
                return
            end

            local RelativePos = TargetPos - MyPosition
            local Distance = RelativePos.Magnitude

            if Distance > EffectiveRange then
                local BlipFrame = GetBlip(Player)
                if BlipFrame then
                    BlipFrame.Visible = false
                end
                return
            end

            local RotatedX = RelativePos.X * math.cos(-MyAngle) - RelativePos.Z * math.sin(-MyAngle)
            local RotatedZ = RelativePos.X * math.sin(-MyAngle) + RelativePos.Z * math.cos(-MyAngle)

            local ScreenX = Self.HalfSize + RotatedX * Scale
            local ScreenY = Self.HalfSize - RotatedZ * Scale

            ScreenX = math.clamp(ScreenX, 2, Self.Size - 2)
            ScreenY = math.clamp(ScreenY, 2, Self.Size - 2)

            local BlipFrame = GetBlip(Player)
            if not BlipFrame then
                BlipFrame = CreateBlip(Player)
            end

            BlipFrame.Position = UDim2.fromOffset(ScreenX - BlipSize, ScreenY - BlipSize)
            BlipFrame.Size = UDim2.fromOffset(BlipSize * 2, BlipSize * 2)
            BlipFrame.Visible = true

            local IsTeam = IsOnSameTeam(Player)
            local BlipColor = if IsTeam then Self.TeamColor else Self.EnemyColor
            BlipFrame.BackgroundColor3 = BlipColor

            if BlipStyle == "Arrow" then
                local TargetCFrame = GetCharacterCFrame(Character)
                if TargetCFrame then
                    local TargetForward = -TargetCFrame.LookVector
                    local TargetAngle =
                        math.deg(math.atan2(TargetForward.X, TargetForward.Z) - MyAngle)
                    if BlipFrame.DirectionArrow and BlipFrame.DirectionArrow.Parent then
                        BlipFrame.DirectionArrow.Visible = true
                        BlipFrame.DirectionArrow.BackgroundColor3 = BlipColor
                        BlipFrame.DirectionArrow.Rotation = -TargetAngle
                    end
                end
            end

            if Self.ShowNames and BlipFrame.NameLabel then
                BlipFrame.NameLabel.Visible = true
            elseif BlipFrame.NameLabel then
                BlipFrame.NameLabel.Visible = false
            end
        end

        for _, Player in Players:GetPlayers() do
            if Player ~= LocalPlayer then
                UpdateBlip(Player)
            end
        end

        -- Local player indicator
        local LocalBlip = GetBlip(LocalPlayer)
        if not LocalBlip then
            local Blip = CreateBlip(LocalPlayer)
            LocalBlip = Blip
        end
        if LocalBlip then
            LocalBlip.Position =
                UDim2.fromOffset(Self.HalfSize - BlipSize + 1, Self.HalfSize - BlipSize + 1)
            LocalBlip.Size = UDim2.fromOffset(BlipSize * 2, BlipSize * 2)
            LocalBlip.BackgroundColor3 = Self.LocalColor
            LocalBlip.Visible = true
            if LocalBlip.DirectionArrow then
                LocalBlip.DirectionArrow.Visible = BlipStyle == "Arrow"
                LocalBlip.DirectionArrow.BackgroundColor3 = Self.LocalColor
                LocalBlip.DirectionArrow.Rotation = 0
            end
            if LocalBlip.NameLabel then
                LocalBlip.NameLabel.Visible = false
            end
        end

        -- Hide blips for disconnected players
        local ActivePlayers = {}
        for _, Player in Players:GetPlayers() do
            ActivePlayers[Player] = true
        end
        for Player, Entry in Self.Blips do
            if not ActivePlayers[Player] and Entry.Blip then
                Entry.Blip.Visible = false
            end
        end
    end

    -- Drag support
    local Dragging = false
    local DragStart: Vector2?
    local DragPos: UDim2?

    local function StartDrag(Input: InputObject)
        if
            Input.UserInputType ~= Enum.UserInputType.MouseButton1
            and Input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end
        Dragging = true
        DragStart = Input.Position
        DragPos = Holder.Position
    end

    local function EndDrag(Input: InputObject)
        if
            Input.UserInputType ~= Enum.UserInputType.MouseButton1
            and Input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end
        Dragging = false
    end

    local function DoDrag(Input: InputObject)
        if not Dragging or not DragStart or not DragPos then
            return
        end
        if Input.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end
        local Delta = Input.Position - DragStart
        Holder.AnchorPoint = Vector2.new(0, 0)
        Holder.Position = UDim2.fromOffset(DragPos.X.Offset + Delta.X, DragPos.Y.Offset + Delta.Y)
    end

    BorderFrame.InputBegan:Connect(StartDrag)
    BorderFrame.InputEnded:Connect(EndDrag)
    Self:_GiveConnection(UserInputService.InputChanged:Connect(DoDrag))

    function Self:_GiveConnection(Connection: RBXScriptConnection)
        table.insert(Self.Connections, Connection)
        return Connection
    end

    function Self:_StartUpdateLoop()
        if Self.UpdateConnection then
            return
        end
        Self.UpdateConnection =
            Self:_GiveConnection(RunService.RenderStepped:Connect(function(DeltaTime)
                if Self.Destroyed then
                    return
                end
                Self.DisplayElapsed += DeltaTime
                if Self.DisplayElapsed < Self.UpdateInterval then
                    return
                end
                Self.DisplayElapsed = 0
                UpdateRadar()
            end))
    end

    function Self:SetRange(Range: number)
        assert(typeof(Range) == "number" and Range > 0, "Radar range must be a positive number")
        Self.Range = Range
    end

    function Self:SetZoom(Zoom: number)
        assert(typeof(Zoom) == "number" and Zoom > 0, "Radar zoom must be a positive number")
        Self.Zoom = Zoom
    end

    function Self:SetVisible(Visible: boolean)
        Self.Visible = Visible
        Holder.Visible = Visible
        if not Visible then
            for _, Entry in Self.Blips do
                if Entry.Blip then
                    Entry.Blip.Visible = false
                end
            end
        end
    end

    function Self:Toggle()
        Self:SetVisible(not Self.Visible)
    end

    function Self:SetPosition(Position: RadarPosition, CustomPosition: UDim2?)
        Self.PositionMode = Position
        Self.CustomPosition = CustomPosition
        ApplyPosition(Position)
    end

    function Self:SetBackgroundTransparency(Transparency: number)
        assert(typeof(Transparency) == "number", "Transparency must be a number")
        Self.BackgroundTransparency = math.clamp(Transparency, 0, 1)
        BorderFrame.BackgroundTransparency = Self.BackgroundTransparency
    end

    function Self:SetShowFOV(Enabled: boolean)
        Self.ShowLocalFOV = Enabled
        FOVCone.Visible = Enabled and Self.Visible
    end

    function Self:SetFOVAngle(Angle: number)
        Self.FOVAngle = math.clamp(Angle, 10, 360)
    end

    function Self:SetBlipStyle(Style: BlipStyle)
        Self.BlipStyle = Style
        for _, Entry in Self.Blips do
            if Entry.DirectionArrow then
                Entry.DirectionArrow.Visible = Style == "Arrow"
            end
        end
    end

    function Self:SetShowNames(Show: boolean)
        Self.ShowNames = Show
        for _, Entry in Self.Blips do
            if Entry.NameLabel then
                Entry.NameLabel.Visible = Show
            end
        end
    end

    function Self:SetBlipSize(Size: number)
        assert(typeof(Size) == "number" and Size > 0, "Blip size must be a positive number")
        Self.BlipSize = Size
    end

    function Self:SetTeamColor(Color: Color3)
        Self.TeamColor = Color
    end

    function Self:SetEnemyColor(Color: Color3)
        Self.EnemyColor = Color
    end

    function Self:Destroy()
        if Self.Destroyed then
            return
        end
        Self.Destroyed = true

        for _, Entry in Self.Blips do
            if Entry.Blip then
                Entry.Blip:Destroy()
            end
        end
        Self.Blips = {}

        for Index = #Self.Connections, 1, -1 do
            local Connection = table.remove(Self.Connections, Index)
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end
        Self.UpdateConnection = nil

        if Holder then
            Holder:Destroy()
        end
    end

    Self:_StartUpdateLoop()

    Library:OnUnload(function()
        Self:Destroy()
    end)

    return Self
end

return Radar
]]))()

--// addons/Movement.lua //--
local Movement = (loadstring([[
--!strict
-- Cyan Movement addon: WalkSpeed, JumpPower, Gravity, Fly, Noclip, and Anti-tool protection.

local Movement = {}
Movement.__index = Movement

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")

export type FlyControl = "Classic" | "Directional"
export type AntiVoidAction = "Teleport" | "Float"

export type MovementOptions = {
    WalkSpeed: number?,
    JumpPower: number?,
    JumpHeight: number?,
    Gravity: number?,
    FlySpeed: number?,
    FlyControl: FlyControl?,
    AutoNoclipWhenFlying: boolean?,
    AntiVoid: boolean?,
    AntiVoidAction: AntiVoidAction?,
    VoidThreshold: number?,
    AntiKick: boolean?,
    AntiTeleport: boolean?,
    AutoUpdateSpeed: boolean?,
}

local function GetHumanoid(Player: Player): Humanoid?
    local Character = Player and Player.Character
    if not Character then
        return nil
    end
    return Character:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart(Player: Player): BasePart?
    local Character = Player and Player.Character
    if not Character then
        return nil
    end
    return Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
end

function Movement.new(Library: any, Options: MovementOptions?)
    assert(typeof(Library) == "table", "Movement requires a Cyan Library instance")

    local Config: MovementOptions = Options or {}
    local LocalPlayer = Players.LocalPlayer

    local self: any = setmetatable({
        Library = Library,
        WalkSpeed = Config.WalkSpeed or 16,
        JumpPower = Config.JumpPower or 50,
        JumpHeight = Config.JumpHeight,
        FlySpeed = Config.FlySpeed or 50,
        FlyControl = Config.FlyControl or "Directional",
        Gravity = Config.Gravity,
        AutoNoclipWhenFlying = Config.AutoNoclipWhenFlying or true,
        WalkSpeedEnabled = false,
        JumpPowerEnabled = false,
        GravityEnabled = false,
        Flying = false,
        Noclipping = false,
        AntiVoid = Config.AntiVoid or false,
        AntiVoidAction = Config.AntiVoidAction or "Float",
        VoidThreshold = Config.VoidThreshold or -50,
        AntiKick = Config.AntiKick or false,
        AntiTeleport = Config.AntiTeleport or false,
        AutoUpdateSpeed = Config.AutoUpdateSpeed or true,
        Connections = {},
        FlyBodyVelocity = nil,
        FlyBodyGyro = nil,
        OnGroundLast = false,
        LastPosition = nil,
        Destroyed = false,
    }, Movement)

    if self.Gravity ~= nil then
        self.GravityEnabled = true
        workspace.Gravity = self.Gravity
    end

    self:_StartLoop()
    Library:OnUnload(function()
        self:Destroy()
    end)

    return self
end

function Movement:_GiveConnection(Connection: RBXScriptConnection)
    table.insert(self.Connections, Connection)
    return Connection
end

function Movement:_StartLoop()
    if self._UpdateConnection then
        return
    end

    self._UpdateConnection = self:_GiveConnection(RunService.Heartbeat:Connect(function(DeltaTime)
        if self.Destroyed then
            return
        end

        local Player = Players.LocalPlayer
        if not Player then
            return
        end

        local Humanoid = GetHumanoid(Player)
        local RootPart = GetRootPart(Player)

        if self.WalkSpeedEnabled and Humanoid and Humanoid.Parent then
            Humanoid.WalkSpeed = self.WalkSpeed
        end

        if self.JumpPowerEnabled and Humanoid and Humanoid.Parent then
            if self.JumpHeight then
                Humanoid.JumpHeight = self.JumpHeight
            else
                Humanoid.JumpPower = self.JumpPower
            end
        end

        if self.Noclipping and RootPart and RootPart.Parent then
            RootPart.CanCollide = false
        end

        if self.Flying and RootPart and RootPart.Parent then
            self:_UpdateFly(RootPart, Humanoid, DeltaTime)
        end

        if self.AntiVoid and RootPart and RootPart.Parent then
            self:_CheckVoid(RootPart)
        end

        if self.AntiTeleport and RootPart and RootPart.Parent then
            self:_CheckTeleport(RootPart)
        end
    end))
end

function Movement:SetWalkSpeed(Speed: number, Enable: boolean?)
    self.WalkSpeed = math.clamp(Speed, 0, 500)
    if Enable ~= nil then
        self.WalkSpeedEnabled = Enable
    else
        self.WalkSpeedEnabled = Speed ~= 16
    end

    local Humanoid = GetHumanoid(Players.LocalPlayer)
    if self.WalkSpeedEnabled and Humanoid then
        Humanoid.WalkSpeed = self.WalkSpeed
    end
end

function Movement:SetJumpPower(Power: number, Enable: boolean?)
    self.JumpPower = math.clamp(Power, 0, 500)
    if Enable ~= nil then
        self.JumpPowerEnabled = Enable
    else
        self.JumpPowerEnabled = Power ~= 50
    end

    local Humanoid = GetHumanoid(Players.LocalPlayer)
    if self.JumpPowerEnabled and Humanoid then
        Humanoid.JumpPower = self.JumpPower
    end
end

function Movement:SetJumpHeight(Height: number, Enable: boolean?)
    self.JumpHeight = math.clamp(Height, 0, 100)
    if Enable ~= nil then
        self.JumpPowerEnabled = Enable
    else
        self.JumpPowerEnabled = Height ~= 0
    end
end

function Movement:SetGravity(G: number)
    workspace.Gravity = G
    self.GravityEnabled = true
    self.Gravity = G
end

function Movement:ResetGravity()
    workspace.Gravity = 196.2
    self.GravityEnabled = false
    self.Gravity = nil
end

function Movement:ToggleFly()
    self:SetFlying(not self.Flying)
end

function Movement:SetFlying(Fly: boolean)
    if Fly == self.Flying then
        return
    end

    self.Flying = Fly
    local Player = Players.LocalPlayer

    if Fly then
        self:_SetupFly()
        Player.CharacterAdded:Connect(function(Character)
            if self.Flying then
                task.wait(0.5)
                self:_SetupFly()
            end
        end)
        if self.AutoNoclipWhenFlying then
            self:SetNoclipping(true)
        end
    else
        self:_CleanupFly()
        if self.AutoNoclipWhenFlying and not self.Noclipping then
            self:SetNoclipping(false)
        end
    end
end

function Movement:_SetupFly()
    local Player = Players.LocalPlayer
    if not Player then
        return
    end

    local Character = Player.Character
    local Humanoid = GetHumanoid(Player)
    local RootPart = GetRootPart(Player)
    if not RootPart or not Humanoid then
        return
    end

    Humanoid.PlatformStand = true

    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Name = "CyanFlyVelocity"
    BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.Parent = RootPart

    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.Name = "CyanFlyGyro"
    BodyGyro.MaxTorque = Vector3.new(0, 0, 0)
    BodyGyro.Parent = RootPart

    self.FlyBodyVelocity = BodyVelocity
    self.FlyBodyGyro = BodyGyro
end

function Movement:_CleanupFly()
    local Player = Players.LocalPlayer
    if not Player then
        return
    end

    local Humanoid = GetHumanoid(Player)
    if Humanoid then
        Humanoid.PlatformStand = false
    end

    task.delay(0.1, function()
        if self.FlyBodyVelocity then
            self.FlyBodyVelocity:Destroy()
            self.FlyBodyVelocity = nil
        end
        if self.FlyBodyGyro then
            self.FlyBodyGyro:Destroy()
            self.FlyBodyGyro = nil
        end
    end)
end

function Movement:_UpdateFly(RootPart: BasePart, Humanoid: Humanoid?, DeltaTime: number)
    if not self.FlyBodyVelocity then
        return
    end

    local Camera = workspace.CurrentCamera
    if not Camera then
        return
    end

    local Forward = Camera.CFrame.LookVector
    local Right = Camera.CFrame.RightVector
    local Up = Vector3.new(0, 1, 0)
    local InputDirection = Vector3.zero

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        InputDirection += Forward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        InputDirection -= Forward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        InputDirection -= Right
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        InputDirection += Right
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        InputDirection += Up
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        InputDirection -= Up
    end

    if InputDirection.Magnitude > 0 then
        InputDirection = InputDirection.Unit
        local Speed = self.FlySpeed
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            Speed = Speed * 2.5
        end
        self.FlyBodyVelocity.Velocity = InputDirection * Speed
    elseif self.AutoUpdateSpeed and Humanoid then
        local MoveDir = Humanoid.MoveDirection
        if MoveDir.Magnitude > 0 then
            self.FlyBodyVelocity.Velocity = MoveDir * self.WalkSpeed * 2
            return
        end
        self.FlyBodyVelocity.Velocity = Vector3.zero
    else
        self.FlyBodyVelocity.Velocity = Vector3.zero
    end
end

function Movement:ToggleNoclip()
    self:SetNoclipping(not self.Noclipping)
end

function Movement:SetNoclipping(Noclip: boolean)
    self.Noclipping = Noclip

    local RootPart = GetRootPart(Players.LocalPlayer)
    if RootPart and Noclip then
        RootPart.CanCollide = false
    end
end

function Movement:SetFlySpeed(Speed: number)
    self.FlySpeed = math.max(1, Speed)
end

function Movement:SetFlyControl(Control: FlyControl)
    self.FlyControl = Control
end

function Movement:_CheckVoid(RootPart: BasePart)
    if RootPart.Position.Y < self.VoidThreshold then
        if self.AntiVoidAction == "Teleport" then
            local Spawns = workspace:FindFirstChild("SpawnLocation")
            if Spawns then
                RootPart.CFrame = CFrame.new(Spawns.Position + Vector3.new(0, 5, 0))
            else
                local Camera = workspace.CurrentCamera
                if Camera then
                    RootPart.CFrame = CFrame.new(Camera.CFrame.Position + Vector3.new(0, 5, 0))
                end
            end
        elseif self.AntiVoidAction == "Float" then
            RootPart.Velocity = Vector3.zero
            RootPart.CFrame += Vector3.new(0, 3, 0)
        end
    end
end

function Movement:_CheckTeleport(RootPart: BasePart)
    local CurrentPos = RootPart.Position
    if self.LastPosition then
        local Distance = (CurrentPos - self.LastPosition).Magnitude
        local Character = RootPart.Parent
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if Distance > 500 and Humanoid and Humanoid.Health > 0 then
            RootPart.CFrame = CFrame.new(self.LastPosition)
            return
        end
    end
    self.LastPosition = CurrentPos
end

function Movement:SetAntiVoid(Enabled: boolean, Action: AntiVoidAction?)
    self.AntiVoid = Enabled
    if Action then
        self.AntiVoidAction = Action
    end
end

function Movement:SetAntiKick(Enabled: boolean)
    self.AntiKick = Enabled
end

function Movement:SetAntiTeleport(Enabled: boolean)
    self.AntiTeleport = Enabled
    self.LastPosition = nil

    local RootPart = GetRootPart(Players.LocalPlayer)
    if RootPart then
        self.LastPosition = RootPart.Position
    end
end

function Movement:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    if self._UpdateConnection then
        self._UpdateConnection:Disconnect()
        self._UpdateConnection = nil
    end

    self:SetFlying(false)
    self:SetNoclipping(false)

    if self.GravityEnabled then
        workspace.Gravity = 196.2
    end

    for Index = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, Index)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end
end

return Movement
]]))()

--// addons/Visuals.lua //--
local Visuals = (loadstring([[
--!strict
-- Cyan Visuals addon: Fullbright, Night Vision, X-Ray, Fog control, and FPS counter.

local Visuals = {}
Visuals.__index = Visuals

local RunService: RunService = game:GetService("RunService")
local Lighting: Lighting = game:GetService("Lighting")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")

export type VisualsOptions = {
    Fullbright: boolean?,
    NightVision: boolean?,
    NightVisionIntensity: number?,
    XRay: boolean?,
    FogOverride: boolean?,
    FogStart: number?,
    FogEnd: number?,
    FogColor: Color3?,
    FPSCounter: boolean?,
}

local function GetHumanoid(Player: Player): Humanoid?
    local Character = Player and Player.Character
    return Character and Character:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart(Player: Player): BasePart?
    local Character = Player and Player.Character
    if not Character then
        return nil
    end
    return Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
end

local function CloneLightingProperties(LightingInstance: Lighting): { [string]: any }
    local Props = {}
    for _, Property in
        {
            "Ambient",
            "Brightness",
            "ColorShift_Top",
            "ColorShift_Bottom",
            "OutdoorAmbient",
            "FogStart",
            "FogEnd",
            "FogColor",
            "GlobalShadows",
            "ClockTime",
            "GeographicLatitude",
            "ExposureCompensation",
            "EnvironmentDiffuseScale",
            "EnvironmentSpecularScale",
        }
    do
        local Success, Value = pcall(function()
            return LightingInstance[Property]
        end)
        if Success then
            Props[Property] = Value
        end
    end
    return Props
end

function Visuals.new(Library: any, Options: VisualsOptions?)
    assert(typeof(Library) == "table", "Visuals requires a Cyan Library instance")

    local Config: VisualsOptions = Options or {}
    local ScreenGui = Library.ScreenGui
    assert(typeof(ScreenGui) == "Instance", "Visuals requires Library.ScreenGui")

    local SavedLighting = CloneLightingProperties(Lighting)
    local SavedAmbient = Lighting.Ambient
    local SavedOutdoorAmbient = Lighting.OutdoorAmbient
    local SavedBrightness = Lighting.Brightness
    local SavedShadows = Lighting.GlobalShadows
    local SavedFogStart = Lighting.FogStart
    local SavedFogEnd = Lighting.FogEnd
    local SavedFogColor = Lighting.FogColor
    local SavedClockTime = Lighting.ClockTime

    local NightVisionOverlay = Instance.new("Frame")
    NightVisionOverlay.Name = "CyanNightVision"
    NightVisionOverlay.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    NightVisionOverlay.BackgroundTransparency = 0.85
    NightVisionOverlay.BorderSizePixel = 0
    NightVisionOverlay.Size = UDim2.fromScale(1, 1)
    NightVisionOverlay.ZIndex = 100000
    NightVisionOverlay.Visible = false
    NightVisionOverlay.Active = false
    NightVisionOverlay.Parent = ScreenGui

    local FPSCounterLabel = Instance.new("TextLabel")
    FPSCounterLabel.Name = "CyanFPSCounter"
    FPSCounterLabel.BackgroundTransparency = 1
    FPSCounterLabel.BorderSizePixel = 0
    FPSCounterLabel.FontFace = Font.fromEnum(Enum.Font.Code)
    FPSCounterLabel.RichText = true
    FPSCounterLabel.Text = "FPS: --"
    FPSCounterLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    FPSCounterLabel.TextSize = 14
    FPSCounterLabel.TextStrokeTransparency = 0.5
    FPSCounterLabel.Position = UDim2.new(1, -80, 0, 6)
    FPSCounterLabel.Size = UDim2.fromOffset(74, 20)
    FPSCounterLabel.ZIndex = 10000
    FPSCounterLabel.Visible = false
    FPSCounterLabel.Parent = ScreenGui

    local XRayHighlights: { [Player]: Highlight } = {}

    local self: any = setmetatable({
        Library = Library,
        Fullbright = false,
        NightVision = false,
        NightVisionIntensity = Config.NightVisionIntensity or 0.85,
        XRay = false,
        FogOverride = false,
        FogStart = Config.FogStart or 0,
        FogEnd = Config.FogEnd or math.huge,
        FogColor = Config.FogColor or Color3.fromRGB(128, 128, 128),
        FPSCounter = false,
        FPSCounterDisplay = "",
        FPSTable = {},
        FPSIndex = 0,
        Connections = {},
        Destroyed = false,
        SavedLighting = SavedLighting,
    }, Visuals)

    if Config.Fullbright then
        self:SetFullbright(true)
    end
    if Config.NightVision then
        self:SetNightVision(true, Config.NightVisionIntensity)
    end
    if Config.XRay then
        self:SetXRay(true)
    end
    if Config.FogOverride then
        self:SetFogOverride(true, Config.FogStart, Config.FogEnd, Config.FogColor)
    end
    if Config.FPSCounter then
        self:SetFPSCounter(true)
    end

    if self.FPSCounter then
        self:_StartFPSLoop()
    end

    Library:OnUnload(function()
        self:Destroy()
    end)

    return self
end

function Visuals:_GiveConnection(Connection: RBXScriptConnection)
    table.insert(self.Connections, Connection)
    return Connection
end

function Visuals:_GetFPSEstimate(): number
    self.FPSIndex += 1
    self.FPSTable[self.FPSIndex] = tick()
    local Cutoff = self.FPSTable[self.FPSIndex - 60]
    if Cutoff then
        local FPS = 60 / (self.FPSTable[self.FPSIndex] - Cutoff)
        self.FPSCounterDisplay = string.format("%.0f", FPS)
        if FPS >= 55 then
            FPSCounterLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        elseif FPS >= 30 then
            FPSCounterLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            FPSCounterLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end

    while self.FPSTable[self.FPSIndex - 120] do
        self.FPSTable[self.FPSIndex - 120] = nil
    end

    return tonumber(self.FPSCounterDisplay) or 0
end

function Visuals:_StartFPSLoop()
    if self._FPSConnection then
        return
    end

    self._FPSConnection = self:_GiveConnection(RunService.RenderStepped:Connect(function()
        if self.Destroyed then
            return
        end
        if self.FPSCounter and FPSCounterLabel then
            self:_GetFPSEstimate()
            FPSCounterLabel.Text = "FPS: " .. self.FPSCounterDisplay
        end
    end))
end

function Visuals:SetFullbright(Enabled: boolean)
    self.Fullbright = Enabled

    if Enabled then
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.FogEnd = math.huge
        Lighting.ClockTime = 14
    else
        Lighting.Brightness = self.SavedLighting.Brightness or 1
        Lighting.GlobalShadows = self.SavedLighting.GlobalShadows
        Lighting.OutdoorAmbient = self.SavedLighting.OutdoorAmbient or Color3.new(0.3, 0.3, 0.3)
        Lighting.Ambient = self.SavedLighting.Ambient or Color3.new(0.5, 0.5, 0.5)
        Lighting.ClockTime = self.SavedLighting.ClockTime or 12

        if not self.FogOverride then
            Lighting.FogEnd = self.SavedLighting.FogEnd or 500
        end
    end
end

function Visuals:SetNightVision(Enabled: boolean, Intensity: number?)
    self.NightVision = Enabled
    if Intensity then
        self.NightVisionIntensity = math.clamp(Intensity, 0, 1)
    end

    if Enabled then
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(0.8, 0.8, 0.8)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        NightVisionOverlay.BackgroundTransparency = self.NightVisionIntensity
        NightVisionOverlay.Visible = true
    else
        if not self.Fullbright then
            Lighting.Brightness = self.SavedLighting.Brightness or 1
            Lighting.GlobalShadows = self.SavedLighting.GlobalShadows
            Lighting.Ambient = self.SavedLighting.Ambient or Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = self.SavedLighting.OutdoorAmbient or Color3.new(0.3, 0.3, 0.3)
        end
        NightVisionOverlay.Visible = false
    end
end

function Visuals:_UpdateXRayPlayer(Player: Player)
    if self.Destroyed then
        return
    end

    local Character = Player.Character
    if not Character then
        local Existing = XRayHighlights[Player]
        if Existing then
            Existing:Destroy()
            XRayHighlights[Player] = nil
        end
        return
    end

    local RootPart = GetRootPart(Player)
    if not RootPart then
        return
    end

    if self.XRay then
        local Highlight = XRayHighlights[Player]
        if not Highlight or not Highlight.Parent then
            if Highlight then
                Highlight:Destroy()
            end
            Highlight = Instance.new("Highlight")
            Highlight.FillTransparency = 0.5
            Highlight.OutlineTransparency = 1
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.FillColor = Player.Team and Player.Team.TeamColor.Color
                or Color3.fromRGB(255, 255, 255)
            Highlight.Parent = Character
            XRayHighlights[Player] = Highlight
        end
        Highlight.Adornee = Character
    else
        local Existing = XRayHighlights[Player]
        if Existing then
            Existing:Destroy()
            XRayHighlights[Player] = nil
        end
    end
end

function Visuals:SetXRay(Enabled: boolean)
    self.XRay = Enabled

    for _, Player in Players:GetPlayers() do
        if Player ~= Players.LocalPlayer then
            self:_UpdateXRayPlayer(Player)
        end
    end

    if Enabled then
        if not self._XRayConnection then
            self._XRayConnection = self:_GiveConnection(Players.PlayerAdded:Connect(function(Player)
                Player.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    self:_UpdateXRayPlayer(Player)
                end)
                self:_UpdateXRayPlayer(Player)
            end))
            self:_GiveConnection(Players.PlayerRemoving:Connect(function(Player)
                local Existing = XRayHighlights[Player]
                if Existing then
                    Existing:Destroy()
                    XRayHighlights[Player] = nil
                end
            end))
        end

        self:_GiveConnection(RunService.Heartbeat:Connect(function()
            if not self.XRay then
                return
            end
            for _, Player in Players:GetPlayers() do
                if Player ~= Players.LocalPlayer then
                    self:_UpdateXRayPlayer(Player)
                end
            end
        end))
    end
end

function Visuals:SetFogOverride(Enabled: boolean, Start: number?, End: number?, Color: Color3?)
    self.FogOverride = Enabled

    if Enabled then
        if Start then
            self.FogStart = Start
            Lighting.FogStart = Start
        end
        if End then
            self.FogEnd = End
        end
        Lighting.FogEnd = self.FogEnd
        if Color then
            self.FogColor = Color
            Lighting.FogColor = Color
        end
    else
        Lighting.FogStart = self.SavedLighting.FogStart or 0
        Lighting.FogEnd = self.SavedLighting.FogEnd or 500
        Lighting.FogColor = self.SavedLighting.FogColor or Color3.fromRGB(128, 128, 128)
    end
end

function Visuals:ResetFog()
    self.FogOverride = false
    Lighting.FogStart = self.SavedLighting.FogStart or 0
    Lighting.FogEnd = self.SavedLighting.FogEnd or 500
    Lighting.FogColor = self.SavedLighting.FogColor or Color3.fromRGB(128, 128, 128)
end

function Visuals:SetFPSCounter(Enabled: boolean)
    self.FPSCounter = Enabled
    FPSCounterLabel.Visible = Enabled

    if Enabled then
        self:_StartFPSLoop()
    end
end

function Visuals:ResetAll()
    self:SetFullbright(false)
    self:SetNightVision(false)
    self:SetXRay(false)
    self:ResetFog()
    self:SetFPSCounter(false)
end

function Visuals:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    self:ResetAll()

    for _, Highlight in XRayHighlights do
        Highlight:Destroy()
    end

    if NightVisionOverlay then
        NightVisionOverlay:Destroy()
    end
    if FPSCounterLabel then
        FPSCounterLabel:Destroy()
    end

    for Index = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, Index)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end
    self._FPSConnection = nil
    self._XRayConnection = nil
end

return Visuals
]]))()

--// addons/Camera.lua //--
local Camera = (loadstring([[
--!strict
-- Cyan Camera addon: Third-person, FOV changer, view locking, camera spin, and freecam.

local CameraMan = {}
CameraMan.__index = CameraMan

local RunService: RunService = game:GetService("RunService")
local UserInputService: UserInputService = game:GetService("UserInputService")
local Players: Players = game:GetService("Players")
local TweenService: TweenService = game:GetService("TweenService")

export type CameraOptions = {
    ThirdPerson: boolean?,
    ThirdPersonDistance: number?,
    ThirdPersonSmoothness: number?,
    FOV: number?,
    FOVEnabled: boolean?,
    ViewLock: boolean?,
    ViewLockCFrame: CFrame?,
    Spin: boolean?,
    SpinSpeed: number?,
    Freecam: boolean?,
    FreecamSpeed: number?,
}

local function GetCharacter(Player: Player): Model?
    return Player and Player.Character
end

local function GetRootPart(Player: Player): BasePart?
    local Character = GetCharacter(Player)
    if not Character then
        return nil
    end
    return Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
end

local function IsLocalPlayer(Player: Player): boolean
    return Player == Players.LocalPlayer
end

function CameraMan.new(Library: any, Options: CameraOptions?)
    assert(typeof(Library) == "table", "Camera requires a Cyan Library instance")

    local self: any = setmetatable({
        Library = Library,
        ThirdPerson = false,
        ThirdPersonDistance = Options and Options.ThirdPersonDistance or 8,
        ThirdPersonSmoothness = Options and Options.ThirdPersonSmoothness or 0.15,
        FOV = Options and Options.FOV or 80,
        FOVEnabled = false,
        ViewLock = false,
        ViewLockCFrame = Options and Options.ViewLockCFrame or CFrame.identity,
        Spin = false,
        SpinSpeed = Options and Options.SpinSpeed or 30,
        Freecam = false,
        FreecamSpeed = Options and Options.FreecamSpeed or 50,
        SavedFOV = nil,
        SavedCameraType = nil,
        SavedCameraSubject = nil,
        SavedCFrame = nil,
        SavedFocus = nil,
        FreecamCFrame = CFrame.new(0, 10, 0),
        FreecamYaw = 0,
        FreecamPitch = 0,
        SpinAngle = 0,
        MouseSensitivity = 0.3,
        Connections = {},
        RenderConnection = nil,
        Destroyed = false,
    }, CameraMan)

    if Options then
        if Options.ThirdPerson then
            self:SetThirdPerson(true, Options.ThirdPersonDistance)
        end
        if Options.FOVEnabled and Options.FOV then
            self:SetFOV(Options.FOV, true)
        end
        if Options.Freecam then
            self:SetFreecam(true)
        end
        if Options.Spin then
            self:SetSpin(true, Options.SpinSpeed)
        end
        if Options.ViewLock then
            self:SetViewLock(true, Options.ViewLockCFrame)
        end
    end

    Library:OnUnload(function()
        self:Destroy()
    end)

    return self
end

function CameraMan:_GiveConnection(Connection: RBXScriptConnection)
    table.insert(self.Connections, Connection)
    return Connection
end

function CameraMan:_StartRender()
    if self.RenderConnection then
        return
    end

    self.RenderConnection =
        self:_GiveConnection(RunService.RenderStepped:Connect(function(DeltaTime)
            if self.Destroyed then
                return
            end

            local Camera = workspace.CurrentCamera
            if not Camera then
                return
            end

            local Player = Players.LocalPlayer
            local Character = GetCharacter(Player)
            local RootPart = GetRootPart(Player)

            if self.Freecam then
                self:_UpdateFreecam(Camera, DeltaTime)
                return
            end

            if self.ThirdPerson and RootPart then
                self:_UpdateThirdPerson(Camera, RootPart, DeltaTime)
            end

            if self.Spin and RootPart then
                self:_UpdateSpin(Camera, RootPart, DeltaTime)
            end

            if self.ViewLock then
                self:_UpdateViewLock(Camera, RootPart)
            end

            if self.FOVEnabled and self.FOV then
                Camera.FieldOfView = self.FOV
            elseif self.SavedFOV and not self.FOVEnabled then
                Camera.FieldOfView = self.SavedFOV
                self.SavedFOV = nil
            end

            if
                not self.ThirdPerson
                and not self.Freecam
                and not self.Spin
                and not self.ViewLock
            then
                if self.SavedCameraType then
                    Camera.CameraType = self.SavedCameraType
                    self.SavedCameraType = nil
                end
                if self.SavedCameraSubject then
                    Camera.CameraSubject = self.SavedCameraSubject
                    self.SavedCameraSubject = nil
                end
            end
        end))
end

function CameraMan:_SaveCameraState(Camera: Camera)
    if not self.SavedCameraType then
        self.SavedCameraType = Camera.CameraType
    end
    if not self.SavedCameraSubject then
        self.SavedCameraSubject = Camera.CameraSubject
    end
end

function CameraMan:_UpdateThirdPerson(Camera: Camera, RootPart: BasePart, DeltaTime: number)
    self:_SaveCameraState(Camera)
    Camera.CameraType = Enum.CameraType.Scriptable

    local CameraCFrame = Camera.CFrame
    local RootCFrame = RootPart.CFrame
    local Offset = RootCFrame.Position - CameraCFrame.Position
    local Distance = Offset.Magnitude
    local Direction = Offset.Unit

    local TargetDistance = self.ThirdPersonDistance
    local CurrentDistance = Distance

    local SmoothDistance = CurrentDistance
        + (TargetDistance - CurrentDistance)
            * math.min(1, DeltaTime / (self.ThirdPersonSmoothness or 0.15))
    local NewPosition = RootCFrame.Position - Direction * SmoothDistance

    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    RaycastParams.FilterDescendantsInstances = { RootPart.Parent, Camera }

    local Result =
        workspace:Raycast(RootCFrame.Position, -Direction * SmoothDistance, RaycastParams)
    local FinalDistance = SmoothDistance
    if Result then
        FinalDistance =
            math.min(SmoothDistance, (Result.Position - RootCFrame.Position).Magnitude - 0.5)
        NewPosition = RootCFrame.Position - Direction * FinalDistance
    end

    Camera.CFrame = CFrame.new(NewPosition, RootCFrame.Position)
    Camera.Focus = CFrame.new(RootCFrame.Position)
end

function CameraMan:_UpdateFreecam(Camera: Camera, DeltaTime: number)
    self:_SaveCameraState(Camera)
    Camera.CameraType = Enum.CameraType.Scriptable

    local Speed = self.FreecamSpeed
        * (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 3 or 1)
    local Forward = self.FreecamCFrame.LookVector
    local Right = self.FreecamCFrame.RightVector
    local Up = Vector3.new(0, 1, 0)
    local MoveVector = Vector3.zero

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        MoveVector += Forward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        MoveVector -= Forward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        MoveVector -= Right
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        MoveVector += Right
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.E) then
        MoveVector += Up
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
        MoveVector -= Up
    end

    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        MoveVector += Up
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        MoveVector -= Up
    end

    if MoveVector.Magnitude > 0 then
        MoveVector = MoveVector.Unit * Speed * DeltaTime
        self.FreecamCFrame += MoveVector
    end

    if not UserInputService:GetFocusedTextBox() then
        local MouseDelta = UserInputService:GetMouseDelta()
        self.FreecamYaw -= MouseDelta.X * self.MouseSensitivity * DeltaTime * 60
        self.FreecamPitch = math.clamp(
            self.FreecamPitch - MouseDelta.Y * self.MouseSensitivity * DeltaTime * 60,
            -85,
            85
        )
    end

    self.FreecamCFrame = CFrame.new(self.FreecamCFrame.Position)
        * CFrame.Angles(0, math.rad(self.FreecamYaw), 0)
        * CFrame.Angles(math.rad(self.FreecamPitch), 0, 0)

    Camera.CFrame = self.FreecamCFrame
    Camera.Focus = CFrame.new(self.FreecamCFrame.Position + self.FreecamCFrame.LookVector * 100)
end

function CameraMan:_UpdateSpin(Camera: Camera, RootPart: BasePart, DeltaTime: number)
    if not self.ThirdPerson then
        self:_SaveCameraState(Camera)
        Camera.CameraType = Enum.CameraType.Scriptable
    end

    self.SpinAngle = (self.SpinAngle + self.SpinSpeed * DeltaTime) % 360
    local RadAngle = math.rad(self.SpinAngle)
    local Offset = Vector3.new(
        math.sin(RadAngle) * self.ThirdPersonDistance,
        2,
        math.cos(RadAngle) * self.ThirdPersonDistance
    )
    local Position = RootPart.Position + Offset

    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    RaycastParams.FilterDescendantsInstances = { RootPart.Parent, workspace.CurrentCamera }
    local Result = workspace:Raycast(RootPart.Position, Offset, RaycastParams)
    if Result then
        Position = Result.Position - (Result.Position - RootPart.Position).Unit * 0.5
    end

    Camera.CFrame = CFrame.new(Position, RootPart.Position)
    Camera.Focus = CFrame.new(RootPart.Position)
end

function CameraMan:_UpdateViewLock(Camera: Camera, RootPart: BasePart?)
    self:_SaveCameraState(Camera)

    if self.ViewLockCFrame then
        local LookAt = self.ViewLockCFrame.Position

        if self.ThirdPerson and RootPart then
            local Direction = (LookAt - Camera.CFrame.Position).Unit
            local NewPosition = RootPart.Position - Direction * self.ThirdPersonDistance
            Camera.CFrame = CFrame.new(NewPosition, LookAt)
        else
            if RootPart then
                local CurrentPos = RootPart.Position
                Camera.CFrame = CFrame.new(CurrentPos, LookAt)
                Camera.CFrame += Vector3.new(0, 2, 0)
            else
                local CameraPos = Camera.CFrame.Position
                Camera.CFrame = CFrame.new(CameraPos, LookAt)
            end
        end
        Camera.Focus = CFrame.new(LookAt)
    end
end

function CameraMan:SetThirdPerson(Enabled: boolean, Distance: number?)
    self.ThirdPerson = Enabled
    if Distance then
        self.ThirdPersonDistance = math.clamp(Distance, 1, 100)
    end

    if Enabled then
        if self.Freecam then
            self:SetFreecam(false)
        end
        self:_StartRender()
    elseif not self.Freecam and not self.Spin and not self.ViewLock then
        local Camera = workspace.CurrentCamera
        if Camera then
            if self.SavedCameraType then
                Camera.CameraType = self.SavedCameraType
                self.SavedCameraType = nil
            end
            if self.SavedCameraSubject then
                Camera.CameraSubject = self.SavedCameraSubject
                self.SavedCameraSubject = nil
            end
        end
    end
end

function CameraMan:SetFOV(FOV: number, Enabled: boolean?)
    self.FOV = math.clamp(FOV, 1, 180)
    if Enabled ~= nil then
        self.FOVEnabled = Enabled
    else
        self.FOVEnabled = true
    end

    if self.FOVEnabled then
        self:_StartRender()
    end
end

function CameraMan:ResetFOV()
    self.FOVEnabled = false
    local Camera = workspace.CurrentCamera
    if Camera then
        Camera.FieldOfView = self.SavedFOV or 80
    end
end

function CameraMan:SetViewLock(Enabled: boolean, Target: CFrame?)
    self.ViewLock = Enabled
    if Target then
        self.ViewLockCFrame = Target
    end

    if Enabled then
        if self.Freecam then
            self:SetFreecam(false)
        end
        self:_StartRender()
    elseif not self.ThirdPerson and not self.Freecam and not self.Spin then
        local Camera = workspace.CurrentCamera
        if Camera and self.SavedCameraType then
            Camera.CameraType = self.SavedCameraType
            self.SavedCameraType = nil
        end
    end
end

function CameraMan:SetSpin(Enabled: boolean, Speed: number?)
    self.Spin = Enabled
    if Speed then
        self.SpinSpeed = Speed
    end

    if Enabled then
        self._StartRender()
    elseif not self.ThirdPerson and not self.Freecam and not self.ViewLock then
        local Camera = workspace.CurrentCamera
        if Camera and self.SavedCameraType then
            Camera.CameraType = self.SavedCameraType
            self.SavedCameraType = nil
        end
    end
end

function CameraMan:SetFreecam(Enabled: boolean)
    if Enabled == self.Freecam then
        return
    end

    self.Freecam = Enabled

    if Enabled then
        if self.ThirdPerson then
            self:SetThirdPerson(false)
        end
        if self.Spin then
            self:SetSpin(false)
        end

        local Camera = workspace.CurrentCamera
        if Camera then
            self.FreecamCFrame = Camera.CFrame
            local _, Yaw, Pitch = Camera.CFrame:ToOrientation()
            self.FreecamYaw = math.deg(Yaw)
            self.FreecamPitch = math.deg(Pitch)
        end
        self:_StartRender()
    else
        local Camera = workspace.CurrentCamera
        if Camera then
            Camera.CameraType = self.SavedCameraType or Enum.CameraType.Custom
            self.SavedCameraType = nil
            if self.SavedCameraSubject then
                Camera.CameraSubject = self.SavedCameraSubject
                self.SavedCameraSubject = nil
            end
        end
    end
end

function CameraMan:SetFreecamSpeed(Speed: number)
    self.FreecamSpeed = math.max(1, Speed)
end

function CameraMan:ResetAll()
    self:SetThirdPerson(false)
    self:SetViewLock(false)
    self:SetSpin(false)
    self:SetFreecam(false)
    self:ResetFOV()
end

function CameraMan:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    self:ResetAll()

    if self.RenderConnection then
        self.RenderConnection:Disconnect()
        self.RenderConnection = nil
    end

    for Index = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, Index)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end
end

return CameraMan
]]))()

--// addons/Protections.lua //--
local Protections = (loadstring([[
--!strict
-- Cyan Protections addon: Anti-kick, anti-crash, anti-idle, anti-lag, and anti-detection tools.

local Protections = {}
Protections.__index = Protections

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")
local TeleportService: TeleportService = game:GetService("TeleportService")
local CoreGui: CoreGui = game:GetService("CoreGui")
local Stats: Stats = game:GetService("Stats")

export type ProtectionOptions = {
    AntiKick: boolean?,
    AntiKickRejoin: boolean?,
    AntiCrash: boolean?,
    AntiCrashFilterParts: boolean?,
    AntiCrashFilterSounds: boolean?,
    AntiCrashFilterMeshes: boolean?,
    AntiCrashFilterParticles: boolean?,
    AntiIdle: boolean?,
    AntiIdleInterval: number?,
    AntiLag: boolean?,
    AntiLagGraphicsLevel: number?,
    AntiLagDisableShadows: boolean?,
    AntiLagDisableEffects: boolean?,
}

local function IsAlive(Player: Player): boolean
    local Character = Player and Player.Character
    if not Character then
        return false
    end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    return Humanoid ~= nil and Humanoid.Health > 0
end

function Protections.new(Library: any, Options: ProtectionOptions?)
    assert(typeof(Library) == "table", "Protections requires a Cyan Library instance")

    local self: any = setmetatable({
        Library = Library,
        AntiKick = false,
        AntiKickRejoin = false,
        KickedByServer = false,
        KickMessage = "",
        AntiCrash = false,
        AntiCrashFilterParts = true,
        AntiCrashFilterSounds = true,
        AntiCrashFilterMeshes = true,
        AntiCrashFilterParticles = true,
        AntiIdle = false,
        AntiIdleInterval = 30,
        AntiLag = false,
        AntiLagGraphicsLevel = 1,
        AntiLagDisableShadows = true,
        AntiLagDisableEffects = true,
        SavedGraphicsLevel = nil,
        SavedShadows = nil,
        Connections = {},
        AntiIdleConnection = nil,
        AntiCrashConnection = nil,
        Destroyed = false,
    }, Protections)

    if Options then
        if Options.AntiKick then
            self:SetAntiKick(true, Options.AntiKickRejoin)
        end
        if Options.AntiCrash then
            self:SetAntiCrash(true)
        end
        if Options.AntiIdle then
            self:SetAntiIdle(true, Options.AntiIdleInterval)
        end
        if Options.AntiLag then
            self:SetAntiLag(true)
        end
    end

    Library:OnUnload(function()
        self:Destroy()
    end)

    return self
end

function Protections:_GiveConnection(Connection: RBXScriptConnection)
    table.insert(self.Connections, Connection)
    return Connection
end

-- Anti-Kick

function Protections:SetAntiKick(Enabled: boolean, Rejoin: boolean?)
    self.AntiKick = Enabled
    if Rejoin ~= nil then
        self.AntiKickRejoin = Rejoin
    end

    if Enabled then
        local LocalPlayer = Players.LocalPlayer
        if LocalPlayer then
            local Success, Connection = pcall(function()
                return LocalPlayer.OnTeleport:Connect(function(State, Message)
                    if State == Enum.TeleportState.Failed and self.AntiKick then
                        self.KickedByServer = true
                        self.KickMessage = tostring(Message)
                        if self.AntiKickRejoin then
                            self:_RejoinGame()
                        end
                    end
                end)
            end)
            if Success then
                self._AntiKickConnection = Connection
                self:_GiveConnection(Connection)
            end
        end

        -- Block the Kick function by wrapping it
        local Success, Hooked = pcall(function()
            local OldKick = Players.LocalPlayer.Kick
            if OldKick then
                local Player = Players.LocalPlayer
                Player.Kick = function(...)
                    if self.AntiKick then
                        self.KickedByServer = true
                        self.KickMessage = "Kick blocked by Cyan protections."
                        if self.AntiKickRejoin then
                            self:_RejoinGame()
                        end
                        return
                    end
                    return OldKick(...)
                end
            end
        end)
    else
        if self._AntiKickConnection then
            self._AntiKickConnection:Disconnect()
            self._AntiKickConnection = nil
        end
    end
end

function Protections:_RejoinGame()
    local PlaceId = game.PlaceId
    local JobId = game.JobId

    task.spawn(function()
        task.wait(1)
        local Success, Error = pcall(function()
            TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
        end)
        if not Success then
            warn("Cyan: Rejoin failed:", tostring(Error))
        end
    end)
end

-- Anti-Crash

function Protections:SetAntiCrash(
    Enabled: boolean,
    FilterParts: boolean?,
    FilterSounds: boolean?,
    FilterMeshes: boolean?,
    FilterParticles: boolean?
)
    self.AntiCrash = Enabled
    if FilterParts ~= nil then
        self.AntiCrashFilterParts = FilterParts
    end
    if FilterSounds ~= nil then
        self.AntiCrashFilterSounds = FilterSounds
    end
    if FilterMeshes ~= nil then
        self.AntiCrashFilterMeshes = FilterMeshes
    end
    if FilterParticles ~= nil then
        self.AntiCrashFilterParticles = FilterParticles
    end

    if Enabled then
        if self.AntiCrashConnection then
            return
        end

        self.AntiCrashConnection =
            self:_GiveConnection(workspace.DescendantAdded:Connect(function(Descendant)
                if not self.AntiCrash then
                    return
                end

                task.spawn(function()
                    task.wait(0.1)
                    if not Descendant or not Descendant.Parent then
                        return
                    end

                    local ShouldRemove = false

                    if
                        self.AntiCrashFilterParts and Descendant:IsA("Part")
                        or Descendant:IsA("UnionOperation")
                    then
                        local Size = Descendant.Size
                        local Volume = Size.X * Size.Y * Size.Z
                        if Volume > 100000 then
                            ShouldRemove = true
                        end
                        if
                            Descendant:IsA("Part")
                            and Descendant.Shape == Enum.PartType.Ball
                            and Descendant.Size.X > 500
                        then
                            ShouldRemove = true
                        end
                    end

                    if self.AntiCrashFilterSounds and Descendant:IsA("Sound") then
                        if Descendant.Playing then
                            Descendant:Stop()
                        end
                        Descendant.Volume = 0
                        Descendant.PlayOnRemove = false
                        task.delay(5, function()
                            if Descendant and Descendant.Parent then
                                Descendant:Destroy()
                            end
                        end)
                    end

                    if
                        self.AntiCrashFilterMeshes
                        and (Descendant:IsA("MeshPart") or Descendant:IsA("SpecialMesh"))
                    then
                        local Size = Descendant:IsA("MeshPart") and Descendant.Size
                            or (
                                Descendant:IsA("SpecialMesh") and Descendant.Scale
                                or Vector3.new(1, 1, 1)
                            )
                        local Volume = Size.X * Size.Y * Size.Z
                        if Volume > 50000 then
                            ShouldRemove = true
                        end
                    end

                    if
                        self.AntiCrashFilterParticles
                        and (
                            Descendant:IsA("ParticleEmitter")
                            or Descendant:IsA("Beam")
                            or Descendant:IsA("Smoke")
                            or Descendant:IsA("Fire")
                        )
                    then
                        ShouldRemove = true
                    end

                    if ShouldRemove and Descendant.Parent then
                        Descendant:Destroy()
                    end
                end)
            end))

        self:_GiveConnection(workspace.DescendantRemoving:Connect(function(Descendant)
            if not self.AntiCrash then
                return
            end
            if Descendant:IsA("BasePart") and Descendant:IsA("Part") then
                local PartCount = 0
                for _, Part in ipairs(workspace:GetDescendants()) do
                    if Part:IsA("Part") or Part:IsA("UnionOperation") or Part:IsA("MeshPart") then
                        PartCount += 1
                        if PartCount > 5000 then
                            break
                        end
                    end
                end
                if PartCount > 5000 then
                    local Parts = workspace:GetDescendants()
                    local RemovedCount = 0
                    for _, Part in ipairs(Parts) do
                        if
                            (Part:IsA("Part") or Part:IsA("UnionOperation") or Part:IsA("MeshPart"))
                            and (not Part.Anchored or Part.Size.Magnitude < 2)
                        then
                            Part:Destroy()
                            RemovedCount += 1
                            if RemovedCount >= 2000 then
                                break
                            end
                        end
                    end
                end
            end
        end))
    else
        if self.AntiCrashConnection then
            self.AntiCrashConnection:Disconnect()
            self.AntiCrashConnection = nil
        end
    end
end

-- Anti-Idle

function Protections:SetAntiIdle(Enabled: boolean, Interval: number?)
    self.AntiIdle = Enabled
    if Interval then
        self.AntiIdleInterval = math.max(10, Interval)
    end

    if Enabled then
        if self.AntiIdleConnection then
            return
        end

        self.AntiIdleConnection = self:_GiveConnection(RunService.Heartbeat:Connect(function()
            if not self.AntiIdle then
                return
            end

            local LocalPlayer = Players.LocalPlayer
            if not LocalPlayer then
                return
            end

            local Character = LocalPlayer.Character
            if not Character then
                return
            end

            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            local RootPart = Character:FindFirstChild("HumanoidRootPart")
                or Character:FindFirstChild("UpperTorso")

            if Humanoid and RootPart and Humanoid.Health > 0 then
                local CurrentTime = tick()
                if not self._LastAntiIdleTime then
                    self._LastAntiIdleTime = CurrentTime
                end

                if CurrentTime - self._LastAntiIdleTime >= self.AntiIdleInterval then
                    self._LastAntiIdleTime = CurrentTime
                    RootPart.Velocity = RootPart.Velocity + Vector3.new(0, 0.1, 0)
                end
            end
        end))
    else
        if self.AntiIdleConnection then
            self.AntiIdleConnection:Disconnect()
            self.AntiIdleConnection = nil
        end
        self._LastAntiIdleTime = nil
    end
end

-- Anti-Lag

function Protections:SetAntiLag(Enabled: boolean, GraphicsLevel: number?)
    self.AntiLag = Enabled
    if GraphicsLevel then
        self.AntiLagGraphicsLevel = math.clamp(GraphicsLevel, 1, 10)
    end

    if Enabled then
        local Success, Settings = pcall(function()
            return UserInputService:GetUserGameSettings()
        end)
        if Success and Settings then
            if self.SavedGraphicsLevel == nil then
                self.SavedGraphicsLevel = Settings.SavedQualityLevel
            end
            if self.SavedShadows == nil then
                self.SavedShadows = Settings.GlobalShadows
            end

            Settings.SavedQualityLevel = self.AntiLagGraphicsLevel
            if self.AntiLagDisableShadows then
                Settings.GlobalShadows = false
            end
        end

        if self.AntiLagDisableEffects then
            local function DisableEffects(Instance: Instance)
                for _, Child in Instance:GetDescendants() do
                    if
                        Child:IsA("ParticleEmitter")
                        or Child:IsA("Smoke")
                        or Child:IsA("Fire")
                        or Child:IsA("Sparkles")
                    then
                        Child.Enabled = false
                    end
                    if
                        Child:IsA("BloomEffect")
                        or Child:IsA("BlurEffect")
                        or Child:IsA("SunRaysEffect")
                        or Child:IsA("ColorCorrectionEffect")
                        or Child:IsA("DepthOfFieldEffect")
                    then
                        Child.Enabled = false
                    end
                end
            end
            DisableEffects(game:GetService("Lighting"))
            DisableEffects(workspace)
        end
    else
        local Success, Settings = pcall(function()
            return UserInputService:GetUserGameSettings()
        end)
        if Success and Settings then
            if self.SavedGraphicsLevel then
                Settings.SavedQualityLevel = self.SavedGraphicsLevel
                self.SavedGraphicsLevel = nil
            end
            if self.SavedShadows ~= nil then
                Settings.GlobalShadows = self.SavedShadows
                self.SavedShadows = nil
            end
        end

        if self.AntiLagDisableEffects then
            local function EnableEffects(Instance: Instance)
                for _, Child in Instance:GetDescendants() do
                    if
                        Child:IsA("BloomEffect")
                        or Child:IsA("BlurEffect")
                        or Child:IsA("SunRaysEffect")
                        or Child:IsA("ColorCorrectionEffect")
                        or Child:IsA("DepthOfFieldEffect")
                    then
                        Child.Enabled = true
                    end
                end
            end
            EnableEffects(game:GetService("Lighting"))
        end
    end
end

function Protections:SetAntiLagGraphicsLevel(Level: number)
    self.AntiLagGraphicsLevel = math.clamp(Level, 1, 10)
    if self.AntiLag then
        self:SetAntiLag(true)
    end
end

-- Chat monitor
function Protections:GetChatLog(): { { Player: string, Message: string, Time: number } }
    return self.ChatLog or {}
end

-- Status

function Protections:GetStatus(): { [string]: boolean }
    return {
        AntiKick = self.AntiKick,
        AntiCrash = self.AntiCrash,
        AntiIdle = self.AntiIdle,
        AntiLag = self.AntiLag,
    }
end

function Protections:DisableAll()
    self:SetAntiKick(false)
    self:SetAntiCrash(false)
    self:SetAntiIdle(false)
    self:SetAntiLag(false)
end

function Protections:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    self:DisableAll()

    for Index = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, Index)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end
    self.AntiCrashConnection = nil
    self.AntiIdleConnection = nil
    self._AntiKickConnection = nil
end

return Protections
]]))()

--// addons/ServerInfo.lua //--
local ServerInfo = (loadstring([[
--!strict
-- Cyan ServerInfo addon: server stats panel, player info overlay, and session data display.

local ServerInfo = {}
ServerInfo.__index = ServerInfo

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local Stats: Stats = game:GetService("Stats")
local UserInputService: UserInputService = game:GetService("UserInputService")
local MarketplaceService: MarketplaceService = game:GetService("MarketplaceService")

export type ServerInfoOptions = {
    Visible: boolean?,
    Position: UDim2?,
    UpdateInterval: number?,
    ShowServerInfo: boolean?,
    ShowPlayerInfo: boolean?,
}

local function GetCharacterPosition(Character: Model): Vector3?
    local Root = Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")
    return Root and Root.Position or Character:GetPivot().Position
end

function ServerInfo.new(Library: any, Options: ServerInfoOptions?)
    assert(typeof(Library) == "table", "ServerInfo requires a Cyan Library instance")
    assert(
        typeof(Library.AddDraggableMenu) == "function",
        "ServerInfo requires Library:AddDraggableMenu"
    )

    local Config: ServerInfoOptions = Options or {}
    local Holder, Container = Library:AddDraggableMenu("Server Info")
    if typeof(Config.Position) == "UDim2" then
        Holder.Position = Config.Position
    end
    Holder.Visible = Config.Visible ~= false

    local self: any = setmetatable({
        Library = Library,
        Holder = Holder,
        Container = Container,
        ShowServerInfo = Config.ShowServerInfo ~= false,
        ShowPlayerInfo = Config.ShowPlayerInfo ~= false,
        Visible = Config.Visible ~= false,
        UpdateInterval = math.clamp(Config.UpdateInterval or 0.3, 0.1, 2),
        DisplayElapsed = 0,
        Labels = {},
        PlayerDropdown = nil,
        SelectedPlayer = nil,
        SessionStart = os.time(),
        Connections = {},
        UpdateConnection = nil,
        Destroyed = false,
    }, ServerInfo)

    local TextStyle = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        FontFace = Library.Scheme.Font,
        RichText = true,
        TextColor3 = Library.Scheme.FontColor,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }

    local function CreateLabel(
        Parent: Instance,
        Text: string,
        SizeY: number,
        Order: number
    ): TextLabel
        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.BorderSizePixel = 0
        Label.FontFace = Library.Scheme.Font
        Label.RichText = true
        Label.TextColor3 = Library.Scheme.FontColor
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = Text
        Label.Size = UDim2.new(1, -10, 0, SizeY or 18)
        Label.LayoutOrder = Order or 0
        Label.Parent = Parent

        Library:AddToRegistry(Label, {
            FontFace = "Font",
            TextColor3 = "FontColor",
        })
        return Label
    end

    local function RefreshDisplay()
        for _, Label in self.Labels do
            if Label and Label.Parent then
                Label:Destroy()
            end
        end
        self.Labels = {}

        if not self.Visible then
            return
        end

        local Order = 0

        local function AddText(Text: string, Color: Color3?)
            Order += 1
            local L = CreateLabel(Container, Text, 18, Order)
            if Color then
                L.TextColor3 = Color
            end
            table.insert(self.Labels, L)
        end

        if self.ShowServerInfo then
            AddText("<b>Server</b>", Library.Scheme.AccentColor)
            AddText(
                string.format(
                    "  Game: %s",
                    game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
                        or "Unknown"
                )
            )
            local PingStats = Stats.Network.ServerStatsItem
            local Ping = ""
            pcall(function()
                Ping = PingStats["Data Ping"]:GetValueString()
            end)
            AddText(string.format("  Ping: %s", Ping ~= "" and Ping or "N/A"))

            local PlayerCount = #Players:GetPlayers()
            local MaxPlayers = Players.MaxPlayers
            AddText(string.format("  Players: %d / %d", PlayerCount, MaxPlayers))

            local PlaceIdStr = tostring(game.PlaceId)
            AddText(string.format("  Place ID: %s", PlaceIdStr))

            local JobId = game.JobId
            if #JobId > 16 then
                JobId = JobId:sub(1, 16) .. "..."
            end
            AddText(string.format("  Job ID: %s", JobId))

            local Elapsed = os.difftime(os.time(), self.SessionStart)
            local Hours = math.floor(Elapsed / 3600)
            local Minutes = math.floor((Elapsed % 3600) / 60)
            local Seconds = math.floor(Elapsed % 60)
            AddText(string.format("  Session: %02d:%02d:%02d", Hours, Minutes, Seconds))
            AddText("") -- spacer
        end

        if self.ShowPlayerInfo and self.SelectedPlayer then
            local Player = self.SelectedPlayer
            if Player and Player.Parent then
                AddText("<b>Player Info</b>", Library.Scheme.AccentColor)
                AddText(string.format("  Name: %s", Player.Name))
                AddText(string.format("  Display: %s", Player.DisplayName))
                AddText(string.format("  User ID: %d", Player.UserId))

                local Team = Player.Team
                AddText(string.format("  Team: %s", Team and Team.Name or "None"))

                local Character = Player.Character
                if Character then
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        AddText(
                            string.format(
                                "  Health: %.0f / %.0f",
                                Humanoid.Health,
                                Humanoid.MaxHealth
                            )
                        )
                    end

                    local Position = GetCharacterPosition(Character)
                    if Position then
                        AddText(
                            string.format(
                                "  Position: %.0f, %.0f, %.0f",
                                Position.X,
                                Position.Y,
                                Position.Z
                            )
                        )
                        local LocalPlayer = Players.LocalPlayer
                        local MyChar = LocalPlayer and LocalPlayer.Character
                        if MyChar then
                            local MyPos = GetCharacterPosition(MyChar)
                            if MyPos then
                                local Dist = (Position - MyPos).Magnitude
                                AddText(string.format("  Distance: %.0f studs", Dist))
                            end
                        end
                    end
                else
                    AddText("  [Character not loaded]")
                end
            else
                AddText("<b>Player Info</b>", Library.Scheme.AccentColor)
                AddText("  [Player left]")
                self.SelectedPlayer = nil
            end
        end
    end

    function Self:SetVisible(Visible: boolean)
        self.Visible = Visible
        Holder.Visible = Visible
        if not Visible then
            for _, Label in self.Labels do
                if Label and Label.Parent then
                    Label:Destroy()
                end
            end
            self.Labels = {}
        end
    end

    function Self:Toggle()
        self:SetVisible(not self.Visible)
    end

    function Self:SelectPlayer(Player: Player?)
        self.SelectedPlayer = Player
    end

    function Self:GetPlayerList(): { Player }
        return Players:GetPlayers()
    end

    if self.ShowPlayerInfo then
        local DropdownLabel = CreateLabel(Container, "Click a player below:", 18, 0)
        table.insert(self.Labels, DropdownLabel)

        for _, Player in Players:GetPlayers() do
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.BackgroundColor3 = Library.Scheme.MainColor
            PlayerButton.BorderSizePixel = 0
            PlayerButton.FontFace = Library.Scheme.Font
            PlayerButton.RichText = true
            PlayerButton.TextColor3 = Library.Scheme.FontColor
            PlayerButton.TextSize = 13
            PlayerButton.TextXAlignment = Enum.TextXAlignment.Left
            PlayerButton.Text = string.format("  %s", Player.Name)
            PlayerButton.Size = UDim2.new(1, -10, 0, 20)
            PlayerButton.LayoutOrder = 100 + (Player.UserId % 1000)
            PlayerButton.Parent = Container

            Library:AddToRegistry(PlayerButton, {
                BackgroundColor3 = "MainColor",
                FontFace = "Font",
                TextColor3 = "FontColor",
            })

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, Library.CornerRadius / 2)
            Corner.Parent = PlayerButton

            table.insert(self.Labels, PlayerButton)

            local TeamColor = Player.Team and Player.Team.TeamColor.Color
            local PingLabel = Instance.new("TextLabel")
            PingLabel.BackgroundTransparency = 1
            PingLabel.FontFace = Library.Scheme.Font
            PingLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            PingLabel.TextSize = 11
            PingLabel.TextXAlignment = Enum.TextXAlignment.Right
            PingLabel.Text = ""
            PingLabel.Size = UDim2.new(0.4, -4, 1, 0)
            PingLabel.Position = UDim2.new(0.6, 0, 0, 0)
            PingLabel.Parent = PlayerButton

            PlayerButton.MouseButton1Click:Connect(function()
                self:SelectPlayer(Player)
            end)

            RunService.Heartbeat:Connect(function()
                if PlayerButton and PlayerButton.Parent then
                    local PingStats = Stats.Network.ServerStatsItem
                    local Ping = ""
                    pcall(function()
                        Ping = PingStats["Data Ping"]:GetValueString()
                    end)
                    PingLabel.Text = Ping ~= "" and Ping or ""
                end
            end)
        end
    end

    self._RefreshConnection = RunService.Heartbeat:Connect(function()
        if self.Destroyed then
            return
        end
        self.DisplayElapsed += RunService.Heartbeat:Wait()
        if self.DisplayElapsed < self.UpdateInterval then
            return
        end
        self.DisplayElapsed = 0
        RefreshDisplay()
    end)
    table.insert(self.Connections, self._RefreshConnection)

    Library:OnUnload(function()
        self:Destroy()
    end)

    return self
end

function ServerInfo:SetShowServerInfo(Show: boolean)
    self.ShowServerInfo = Show
end

function ServerInfo:SetShowPlayerInfo(Show: boolean)
    self.ShowPlayerInfo = Show
end

function ServerInfo:SetUpdateInterval(Seconds: number)
    self.UpdateInterval = math.clamp(Seconds, 0.1, 2)
end

function ServerInfo:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    for _, Label in self.Labels do
        if Label and Label.Parent then
            Label:Destroy()
        end
    end
    self.Labels = {}

    local Index = table.find(Library.DraggableElements, self.Holder)
    if Index then
        table.remove(Library.DraggableElements, Index)
    end

    if self.Holder then
        self.Holder:Destroy()
    end

    for i = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, i)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end
    self._RefreshConnection = nil
end

return ServerInfo
]]))()

--// addons/QoL.lua //--
local QoL = (loadstring([[
-- !strict
-- Cyan QoL addon: Teleport panel, Server rejoin, Item ESP, Auto-collect, Anti-void, Infinite-yield-style tools.

local QoL = {}
QoL.__index = QoL

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")
local TweenService: TweenService = game:GetService("TweenService")
local TeleportService: TeleportService = game:GetService("TeleportService")
local VirtualUser: VirtualUser = game:GetService("VirtualUser")

export type QoLOptions = {
    Visible: boolean?,
    Position: UDim2?,
}

local function GetCharacter(Player: Player): Model?
    return Player and Player.Character
end

local function GetRootPart(Character: Model): BasePart?
    return Character
        and (
            Character:FindFirstChild("HumanoidRootPart")
            or Character:FindFirstChild("UpperTorso")
            or Character:FindFirstChild("Torso")
            or Character:FindFirstChild("Head")
        )
end

local function GetCharacterPosition(Character: Model): Vector3?
    local Root = GetRootPart(Character)
    return Root and Root.Position
end

local function GetLocalCharacter(): Model?
    local Player = Players.LocalPlayer
    return Player and Player.Character
end

local function GetLocalRoot(): BasePart?
    return GetRootPart(GetLocalCharacter())
end

function QoL.new(Library: any, Options: QoLOptions?)
    assert(typeof(Library) == "table", "QoL requires a Cyan Library instance")

    local Config: QoLOptions = Options or {}
    local self: any = setmetatable({
        Library = Library,
        Config = Config,
        Options = {
            ItemEsp = false,
            ItemEspColor = Color3.fromRGB(0, 255, 255),
            ItemEspTransparency = 0.3,
            ItemEspRange = 100,
            AutoCollect = false,
            AutoCollectRange = 20,
            AutoCollectWhitelist = {},
            AntiVoidEnabled = false,
            AntiVoidMode = "Teleport",
            AntiVoidY = -50,
            AntiVoidSafePosition = nil,
            InfiniteYield = false,
            AutoClick = false,
            AutoClickInterval = 0.1,
            JumpModifier = false,
            JumpPower = 50,
            WalkSpeedModifier = false,
            WalkSpeed = 16,
        },
        ItemEspHighlights = {},
        AutoCollectConnections = {},
        AntiVoidConnection = nil,
        AutoClickThread = nil,
        Connections = {},
        Destroyed = false,
    }, QoL)

    local function SetupConnections()
        -- Item ESP logic
        local function RefreshItemEsp()
            for _, Highlight in self.ItemEspHighlights do
                if Highlight and Highlight.Parent then
                    Highlight:Destroy()
                end
            end
            self.ItemEspHighlights = {}

            if not self.Options.ItemEsp then
                return
            end

            local Character = GetLocalCharacter()
            local Root = Character and GetRootPart(Character)
            local Origin = Root and Root.Position or Vector3.zero

            for _, Part in workspace:GetDescendants() do
                if
                    Part:IsA("BasePart")
                    and Part.CanCollide == false
                    and not Part:FindFirstAncestorOfClass("Player")
                    and not Part:FindFirstAncestorOfClass("Tool")
                then
                    local IsDroppedItem = Part:IsA("Part") or Part:IsA("MeshPart")
                    if
                        IsDroppedItem
                        and (Part.Position - Origin).Magnitude <= self.Options.ItemEspRange
                    then
                        local Highlight = Instance.new("Highlight")
                        Highlight.Adornee = Part
                        Highlight.FillColor = self.Options.ItemEspColor
                        Highlight.FillTransparency = self.Options.ItemEspTransparency
                        Highlight.OutlineColor = Color3.new(1, 1, 1)
                        Highlight.OutlineTransparency = 0.5
                        Highlight.Parent = Part
                        table.insert(self.ItemEspHighlights, Highlight)
                    end
                end
            end
        end

        local EspConnection = RunService.Heartbeat:Connect(function()
            if self.Options.ItemEsp and not self.Destroyed then
                RefreshItemEsp()
            end
        end)
        table.insert(self.Connections, EspConnection)

        -- Auto-collect logic: walk to collectibles
        local AutoCollectTick = 0
        local ACConnection = RunService.Heartbeat:Connect(function(Delta)
            if not self.Options.AutoCollect or self.Destroyed then
                AutoCollectTick = 0
                return
            end
            AutoCollectTick += Delta
            if AutoCollectTick < 0.5 then
                return
            end
            AutoCollectTick = 0

            local Character = GetLocalCharacter()
            local Root = Character and GetRootPart(Character)
            if not Root then
                return
            end
            local Origin = Root.Position

            for _, Part in workspace:GetDescendants() do
                if not Part:IsA("BasePart") then
                    continue
                end
                if Part:FindFirstAncestorOfClass("Player") then
                    continue
                end
                if Part:FindFirstAncestorOfClass("Tool") then
                    continue
                end
                if
                    Part:FindFirstAncestorOfClass("Model")
                    and Part.Parent:IsA("Model")
                    and Part.Parent:FindFirstChildOfClass("Humanoid")
                then
                    continue
                end
                local TouchInterest = Part:FindFirstChildOfClass("TouchTransmitter")
                if not TouchInterest then
                    continue
                end

                local Dist = (Part.Position - Origin).Magnitude
                if Dist > self.Options.AutoCollectRange then
                    continue
                end

                local BodyPos = Instance.new("BodyPosition")
                BodyPos.MaxForce = Vector3.new(100000, 100000, 100000)
                BodyPos.Position = Part.Position
                BodyPos.P = 3000
                BodyPos.D = 100
                BodyPos.Parent = Root

                local StartPos = Root.Position
                local Target = Part.Position
                local StartTime = tick()

                repeat
                    RunService.Heartbeat:Wait()
                    local Elapsed = tick() - StartTime
                    if Elapsed > 3 then
                        break
                    end
                    local Alpha = math.min(Elapsed / 0.5, 1)
                    BodyPos.Position = StartPos:Lerp(Target, Alpha)
                until (Root.Position - Part.Position).Magnitude < 4
                    or not Part.Parent
                    or not BodyPos.Parent

                BodyPos:Destroy()
                break
            end
        end)
        table.insert(self.Connections, ACConnection)
    end

    local function SetupAntiVoid()
        if self.AntiVoidConnection then
            self.AntiVoidConnection:Disconnect()
            self.AntiVoidConnection = nil
        end

        if not self.Options.AntiVoidEnabled then
            return
        end

        local StartPos = Vector3.zero
        local Character = GetLocalCharacter()
        if Character then
            local Root = GetRootPart(Character)
            if Root then
                StartPos = Root.Position
            end
        end
        self.Options.AntiVoidSafePosition = self.Options.AntiVoidSafePosition or StartPos

        self.AntiVoidConnection = RunService.Heartbeat:Connect(function()
            if self.Destroyed then
                return
            end
            local Character = GetLocalCharacter()
            local Root = Character and GetRootPart(Character)
            if not Root then
                return
            end

            if Root.Position.Y < self.Options.AntiVoidY then
                local SafePos = self.Options.AntiVoidSafePosition
                if self.Options.AntiVoidMode == "Teleport" then
                    Root.CFrame = CFrame.new(SafePos + Vector3.new(0, 3, 0))
                    local Force = Instance.new("BodyVelocity")
                    Force.MaxForce = Vector3.new(0, 1e9, 0)
                    Force.Velocity = Vector3.new(0, 0, 0)
                    Force.Parent = Root
                    game:GetService("Debris"):AddItem(Force, 0.5)
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                elseif self.Options.AntiVoidMode == "Float" then
                    local BodyPos = Root:FindFirstChildOfClass("BodyPosition")
                    if not BodyPos then
                        BodyPos = Instance.new("BodyPosition")
                        BodyPos.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                        BodyPos.P = 5000
                        BodyPos.D = 200
                        BodyPos.Parent = Root
                    end
                    BodyPos.Position = SafePos + Vector3.new(0, 3, 0)
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                    end
                end
            end
        end)
        table.insert(self.Connections, self.AntiVoidConnection)
    end

    local function SetupAutoClick()
        if self.AutoClickThread then
            coroutine.close(self.AutoClickThread)
            self.AutoClickThread = nil
        end

        if not self.Options.AutoClick then
            return
        end

        self.AutoClickThread = coroutine.create(function()
            while self.Options.AutoClick and not self.Destroyed do
                task.wait(self.Options.AutoClickInterval)
                if not self.Options.AutoClick then
                    break
                end
                local Character = GetLocalCharacter()
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                if Humanoid then
                    local Tool = Character:FindFirstChildOfClass("Tool")
                    if Tool then
                        local ClickFunction = Tool:FindFirstChild("Click")
                        if ClickFunction and ClickFunction:IsA("BindableFunction") then
                            ClickFunction:Invoke()
                        end
                        local Handle = Tool:FindFirstChild("Handle")
                        if Handle then
                            local TouchInterest = Handle:FindFirstChildOfClass("TouchTransmitter")
                            if TouchInterest then
                                firetouchinterest(
                                    Handle,
                                    (
                                        Players.LocalPlayer
                                        and Players.LocalPlayer.Character
                                        and Players.LocalPlayer.Character:FindFirstChild(
                                            "HumanoidRootPart"
                                        )
                                    ) or Handle,
                                    0
                                )
                            end
                        end
                    end
                end
            end
        end)
        table.insert(self.Connections, {
            Connected = true,
            Disconnect = function()
                if self.AutoClickThread then
                    coroutine.close(self.AutoClickThread)
                    self.AutoClickThread = nil
                end
            end,
        })
        coroutine.resume(self.AutoClickThread)
    end

    self._SetupAntiVoid = SetupAntiVoid
    self._SetupAutoClick = SetupAutoClick

    SetupConnections()
    SetupAntiVoid()
    SetupAutoClick()

    Library:OnUnload(function()
        self:Destroy()
    end)

    return self
end

-- Teleport methods
function QoL:TeleportToPlayer(TargetPlayer: Player)
    local TargetChar = TargetPlayer and TargetPlayer.Character
    local TargetRoot = TargetChar and GetRootPart(TargetChar)
    if not TargetRoot then
        return false, "Target has no character"
    end
    local LocalRoot = GetLocalRoot()
    if not LocalRoot then
        return false, "You have no character"
    end
    LocalRoot.CFrame = TargetRoot.CFrame * CFrame.new(0, 3, 3)
    return true
end

function QoL:TeleportToPosition(Position: Vector3)
    local Root = GetLocalRoot()
    if not Root then
        return false
    end
    Root.CFrame = CFrame.new(Position + Vector3.new(0, 3, 0))
    return true
end

function QoL:TeleportToCoordinates(X: number, Y: number, Z: number)
    return self:TeleportToPosition(Vector3.new(X, Y, Z))
end

function QoL:TeleportToWaypoint(Waypoint: CFrame)
    local Root = GetLocalRoot()
    if not Root then
        return false, "You have no character"
    end
    Root.CFrame = Waypoint
    return true
end

-- Server rejoin tools
function QoL:GetServerId(): string
    return game.JobId
end

function QoL:GetPlaceId(): number
    return game.PlaceId
end

function QoL:RejoinServer()
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
end

function QoL:CopyServerLink()
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    local Link =
        string.format("https://www.roblox.com/games/%d/Custom?gameInstanceId=%s", PlaceId, JobId)
    setclipboard(Link)
    return Link
end

function QoL:ServerHop()
    local PlaceId = game.PlaceId
    TeleportService:Teleport(PlaceId)
end

-- Item ESP
function QoL:SetItemEsp(Enabled: boolean)
    self.Options.ItemEsp = Enabled
end

function QoL:SetItemEspColor(Color: Color3)
    self.Options.ItemEspColor = Color
end

function QoL:SetItemEspTransparency(Transparency: number)
    self.Options.ItemEspTransparency = math.clamp(Transparency, 0, 1)
end

function QoL:SetItemEspRange(Range: number)
    self.Options.ItemEspRange = math.max(Range, 10)
end

-- Auto-collect
function QoL:SetAutoCollect(Enabled: boolean)
    self.Options.AutoCollect = Enabled
end

function QoL:SetAutoCollectRange(Range: number)
    self.Options.AutoCollectRange = math.clamp(Range, 5, 200)
end

-- Anti-void
function QoL:SetAntiVoid(Enabled: boolean, Mode: string?)
    self.Options.AntiVoidEnabled = Enabled
    if Mode then
        self.Options.AntiVoidMode = Mode
    end
    if Enabled then
        local Root = GetLocalRoot()
        if Root then
            self.Options.AntiVoidSafePosition = Root.Position
        end
    end
    self._SetupAntiVoid()
end

function QoL:SetAntiVoidY(Y: number)
    self.Options.AntiVoidY = Y
end

function QoL:SetAntiVoidMode(Mode: string)
    self.Options.AntiVoidMode = Mode
end

-- Infinite-yield-style tools
function QoL:SetInfiniteYield(Enabled: boolean)
    self.Options.InfiniteYield = Enabled
end

-- Auto-click
function QoL:SetAutoClick(Enabled: boolean)
    self.Options.AutoClick = Enabled
    self._SetupAutoClick()
end

function QoL:SetAutoClickInterval(Interval: number)
    self.Options.AutoClickInterval = math.max(Interval, 0.02)
    if self.Options.AutoClick then
        self._SetupAutoClick()
    end
end

-- Character modifiers
function QoL:SetCharacterWalkSpeed(Speed: number)
    self.Options.WalkSpeedModifier = true
    self.Options.WalkSpeed = Speed
    local Character = GetLocalCharacter()
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = Speed
    end
end

function QoL:SetCharacterJumpPower(Power: number)
    self.Options.JumpModifier = true
    self.Options.JumpPower = Power
    local Character = GetLocalCharacter()
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.JumpPower = Power
    end
end

function QoL:ResetCharacterModifiers()
    self.Options.WalkSpeedModifier = false
    self.Options.JumpModifier = false
    local Character = GetLocalCharacter()
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
    end
end

function QoL:GetPlayerList(): { Player }
    return Players:GetPlayers()
end

function QoL:GetPlayerByName(Name: string): Player?
    Name = Name:lower()
    for _, Player in Players:GetPlayers() do
        if Player.Name:lower():find(Name) or Player.DisplayName:lower():find(Name) then
            return Player
        end
    end
    return nil
end

function QoL:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    for _, Highlight in self.ItemEspHighlights do
        if Highlight and Highlight.Parent then
            Highlight:Destroy()
        end
    end
    self.ItemEspHighlights = {}

    if self.AutoClickThread then
        coroutine.close(self.AutoClickThread)
        self.AutoClickThread = nil
    end

    for i = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, i)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end

    self._SetupAntiVoid = nil
    self._SetupAutoClick = nil
end

return QoL
]]))()

--// addons/UIUtilities.lua //--
local UIUtilities = (loadstring([[
--!strict
-- Cyan UI Utilities addon: Watermark, Notification Presets, Color Palette.

local UIUtilities = {}
UIUtilities.__index = UIUtilities

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")
local Stats: Stats = game:GetService("Stats")
local MarketplaceService: MarketplaceService = game:GetService("MarketplaceService")

export type WatermarkOptions = {
    Visible: boolean?,
    Position: UDim2?,
    Title: string?,
    ShowFPS: boolean?,
    ShowPing: boolean?,
    ShowPlayers: boolean?,
    ShowTime: boolean?,
    TextSize: number?,
}

export type PaletteColor = {
    Name: string,
    Color: Color3,
}

export type ColorPaletteOptions = {
    Visible: boolean?,
    Position: UDim2?,
    Colors: { PaletteColor }?,
    OnColorSelected: ((Color3, string) -> ())?,
}

export type UIUtilitiesOptions = {
    Watermark: WatermarkOptions?,
    ColorPalette: ColorPaletteOptions?,
}

local function GetFPS(): number
    return math.floor(1 / RunService.RenderStepped:Wait())
end

local function GetPing(): string
    local PingStats = Stats.Network.ServerStatsItem
    local Ping = ""
    pcall(function()
        Ping = PingStats["Data Ping"]:GetValueString()
    end)
    return Ping
end

local DefaultPalette: { PaletteColor } = {
    { Name = "Red", Color = Color3.fromRGB(255, 50, 50) },
    { Name = "Orange", Color = Color3.fromRGB(255, 150, 50) },
    { Name = "Yellow", Color = Color3.fromRGB(255, 255, 50) },
    { Name = "Lime", Color = Color3.fromRGB(50, 255, 50) },
    { Name = "Green", Color = Color3.fromRGB(50, 200, 50) },
    { Name = "Cyan", Color = Color3.fromRGB(50, 255, 255) },
    { Name = "Teal", Color = Color3.fromRGB(50, 150, 200) },
    { Name = "Blue", Color = Color3.fromRGB(50, 100, 255) },
    { Name = "Purple", Color = Color3.fromRGB(200, 50, 255) },
    { Name = "Pink", Color = Color3.fromRGB(255, 50, 200) },
    { Name = "White", Color = Color3.fromRGB(255, 255, 255) },
    { Name = "Gray", Color = Color3.fromRGB(150, 150, 150) },
    { Name = "Black", Color = Color3.fromRGB(30, 30, 30) },
}

function UIUtilities.new(Library: any, Options: UIUtilitiesOptions?)
    assert(typeof(Library) == "table", "UIUtilities requires a Cyan Library instance")

    local Config: UIUtilitiesOptions = Options or {}
    local self: any = setmetatable({
        Library = Library,
        Config = Config,
        Watermark = nil,
        WatermarkOptions = Config.Watermark or {},
        ColorPaletteMenu = nil,
        ColorPaletteOptions = Config.ColorPalette or {},
        PaletteCallback = (Config.ColorPalette or {}).OnColorSelected or nil,
        Connections = {},
        Destroyed = false,
    }, UIUtilities)

    -- Watermark
    local WmOpts = self.WatermarkOptions
    local WmHolder, WmContainer =
        Library:AddDraggableMenu(WmOpts.Title and WmOpts.Title .. " — Info" or "Watermark")
    if WmOpts.Position then
        WmHolder.Position = WmOpts.Position
    end
    WmHolder.Visible = WmOpts.Visible ~= false
    self.Watermark = WmHolder
    self.WatermarkContainer = WmContainer

    local function BuildWatermark()
        for _, Child in WmContainer:GetChildren() do
            if Child:IsA("TextLabel") or Child:IsA("Frame") then
                Child:Destroy()
            end
        end

        if not WmHolder.Visible then
            return
        end

        local FPS = GetFPS()
        local FPSColor: Color3
        if FPS >= 55 then
            FPSColor = Color3.fromRGB(0, 255, 0)
        elseif FPS >= 30 then
            FPSColor = Color3.fromRGB(255, 255, 0)
        else
            FPSColor = Color3.fromRGB(255, 0, 0)
        end

        local Lines: { string } = {}
        if WmOpts.ShowFPS ~= false then
            table.insert(
                Lines,
                string.format(
                    "<b>FPS:</b> <font color='rgb(%d,%d,%d)'>%d</font>",
                    FPSColor.R * 255,
                    FPSColor.G * 255,
                    FPSColor.B * 255,
                    FPS
                )
            )
        end
        if WmOpts.ShowPing ~= false then
            local Ping = GetPing()
            table.insert(Lines, "<b>Ping:</b> " .. (Ping ~= "" and Ping or "N/A"))
        end
        if WmOpts.ShowPlayers ~= false then
            table.insert(
                Lines,
                string.format("<b>Players:</b> %d / %d", #Players:GetPlayers(), Players.MaxPlayers)
            )
        end
        if WmOpts.ShowTime ~= false then
            table.insert(Lines, "<b>Time:</b> " .. os.date("%H:%M:%S"))
        end

        local Text = table.concat(Lines, "  |  ")
        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.BorderSizePixel = 0
        Label.FontFace = Library.Scheme.Font
        Label.RichText = true
        Label.TextColor3 = Library.Scheme.FontColor
        Label.TextSize = WmOpts.TextSize or 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = Text
        Label.Size = UDim2.new(1, -10, 0, 20)
        Label.Parent = WmContainer

        Library:AddToRegistry(Label, {
            FontFace = "Font",
            TextColor3 = "FontColor",
        })
    end

    local WmConnection = RunService.Heartbeat:Connect(function()
        if self.Destroyed then
            return
        end
        BuildWatermark()
    end)
    table.insert(self.Connections, WmConnection)

    -- Color Palette
    local PalOpts = self.ColorPaletteOptions
    local Colors = PalOpts.Colors or DefaultPalette
    local PalHolder, PalContainer = Library:AddDraggableMenu("Color Palette")
    if PalOpts.Position then
        PalHolder.Position = PalOpts.Position
    else
        PalHolder.Position = UDim2.fromOffset(300, 6)
    end
    PalHolder.Visible = PalOpts.Visible ~= false
    self.ColorPaletteMenu = PalHolder
    self.ColorPaletteContainer = PalContainer

    local PaletteGrid = Instance.new("UIGridLayout")
    PaletteGrid.CellSize = UDim2.fromOffset(30, 30)
    PaletteGrid.CellPadding = UDim2.fromOffset(4, 4)
    PaletteGrid.FillDirection = Enum.FillDirection.Horizontal
    PaletteGrid.StartCorner = Enum.StartCorner.TopLeft
    PaletteGrid.Parent = PalContainer

    for _, ColorEntry in Colors do
        local ColorBtn = Instance.new("ImageButton")
        ColorBtn.BackgroundColor3 = ColorEntry.Color
        ColorBtn.BorderSizePixel = 0
        ColorBtn.Size = UDim2.fromOffset(30, 30)
        ColorBtn.AutoButtonColor = false
        ColorBtn.Parent = PalContainer

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 4)
        Corner.Parent = ColorBtn

        local Hover = Instance.new("Frame")
        Hover.BackgroundColor3 = Color3.new(1, 1, 1)
        Hover.BackgroundTransparency = 1
        Hover.BorderSizePixel = 0
        Hover.Size = UDim2.fromScale(1, 1)
        Hover.ZIndex = 2
        Hover.Parent = ColorBtn

        local HoverCorner = Instance.new("UICorner")
        HoverCorner.CornerRadius = UDim.new(0, 4)
        HoverCorner.Parent = Hover

        ColorBtn.MouseEnter:Connect(function()
            Hover.BackgroundTransparency = 0.8
        end)
        ColorBtn.MouseLeave:Connect(function()
            Hover.BackgroundTransparency = 1
        end)

        ColorBtn.MouseButton1Click:Connect(function()
            setclipboard(
                ColorEntry.Color.R .. "," .. ColorEntry.Color.G .. "," .. ColorEntry.Color.B
            )
            Library:Notify({
                Title = "Color Copied",
                Description = string.format(
                    "%s: %.3f, %.3f, %.3f",
                    ColorEntry.Name,
                    ColorEntry.Color.R,
                    ColorEntry.Color.G,
                    ColorEntry.Color.B
                ),
                Time = 2,
            })
            if self.PaletteCallback then
                self.PaletteCallback(ColorEntry.Color, ColorEntry.Name)
            end
        end)
    end

    Library:OnUnload(function()
        self:Destroy()
    end)

    return self
end

-- Watermark methods
function UIUtilities:SetWatermarkVisible(Visible: boolean)
    if self.Watermark then
        self.Watermark.Visible = Visible
    end
end

function UIUtilities:SetWatermarkTitle(Title: string)
    if self.Watermark and self.Watermark:FindFirstChildOfClass("TextLabel") then
        local Label = self.Watermark:FindFirstChildOfClass("TextLabel")
        Label.Text = Title
    end
end

function UIUtilities:SetWatermarkOption(Option: string, Value: boolean)
    if Option == "FPS" then
        self.WatermarkOptions.ShowFPS = Value
    elseif Option == "Ping" then
        self.WatermarkOptions.ShowPing = Value
    elseif Option == "Players" then
        self.WatermarkOptions.ShowPlayers = Value
    elseif Option == "Time" then
        self.WatermarkOptions.ShowTime = Value
    end
end

-- Notification Presets
function UIUtilities:Notify(Title: string, Description: string, Time: number?)
    self.Library:Notify({
        Title = Title,
        Description = Description,
        Time = Time or 5,
    })
end

function UIUtilities:NotifySuccess(Description: string, Title: string?, Time: number?)
    self.Library:Notify({
        Title = Title or "Success",
        Description = Description,
        Time = Time or 4,
    })
end

function UIUtilities:NotifyError(Description: string, Title: string?, Time: number?)
    self.Library:Notify({
        Title = Title or "Error",
        Description = Description,
        Time = Time or 6,
    })
end

function UIUtilities:NotifyInfo(Description: string, Title: string?, Time: number?)
    self.Library:Notify({
        Title = Title or "Info",
        Description = Description,
        Time = Time or 4,
    })
end

function UIUtilities:NotifyWarning(Description: string, Title: string?, Time: number?)
    self.Library:Notify({
        Title = Title or "Warning",
        Description = Description,
        Time = Time or 5,
    })
end

-- Color Palette methods
function UIUtilities:SetPaletteVisible(Visible: boolean)
    if self.ColorPaletteMenu then
        self.ColorPaletteMenu.Visible = Visible
    end
end

function UIUtilities:SetPaletteCallback(Callback: (Color3, string) -> ())
    self.PaletteCallback = Callback
end

function UIUtilities:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    local Index = table.find(self.Library.DraggableElements, self.Watermark)
    if Index then
        table.remove(self.Library.DraggableElements, Index)
    end
    local Index2 = table.find(self.Library.DraggableElements, self.ColorPaletteMenu)
    if Index2 then
        table.remove(self.Library.DraggableElements, Index2)
    end

    if self.Watermark then
        self.Watermark:Destroy()
    end
    if self.ColorPaletteMenu then
        self.ColorPaletteMenu:Destroy()
    end

    for i = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, i)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end
end

return UIUtilities
]]))()

--// addons/Player.lua //--
local Player = (loadstring([[
--!strict
-- Cyan Player add-on: teleport utilities and a best-effort God Mode.
-- God Mode is a generic health lock and may not cover games that use a custom
-- health/damage system; it is provided as a convenience toggle.

local Player = {}
Player.__index = Player

local Players: Players = game:GetService("Players")
local RunService: RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

export type PlayerOptions = {
    GodMode: boolean?,
}

function Player.new(Library, Options: PlayerOptions?)
    Options = Options or {}
    local Self = setmetatable({}, Player)

    Self._GodMode = false
    Self._Connection = nil

    local function CharacterRoot()
        local Character = LocalPlayer.Character
        if not Character then
            return nil
        end
        return Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
    end

    function Self:SetGodMode(Enabled: boolean)
        Self._GodMode = Enabled
        if Enabled then
            Self._Connection = RunService.Heartbeat:Connect(function()
                local Character = LocalPlayer.Character
                if not Character then
                    return
                end
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                if Humanoid and Humanoid.Health < Humanoid.MaxHealth then
                    pcall(function()
                        Humanoid.Health = Humanoid.MaxHealth
                    end)
                end
            end)
        elseif Self._Connection then
            Self._Connection:Disconnect()
            Self._Connection = nil
        end
    end

    function Self:TeleportToPlayer(Name: string?)
        if not Name then
            return
        end
        local Target = Players:FindFirstChild(Name)
        if not Target or not Target.Character then
            return
        end
        local TargetRoot = Target.Character:FindFirstChild("HumanoidRootPart")
            or Target.Character:FindFirstChild("Torso")
        local MyRoot = CharacterRoot()
        if TargetRoot and MyRoot then
            pcall(function()
                MyRoot.CFrame = TargetRoot.CFrame
            end)
        end
    end

    function Self:TeleportToMouse()
        local Mouse = LocalPlayer:GetMouse()
        if not Mouse then
            return
        end
        local MyRoot = CharacterRoot()
        if Mouse.Hit and MyRoot then
            pcall(function()
                MyRoot.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end)
        end
    end

    function Self:Destroy()
        if Self._Connection then
            Self._Connection:Disconnect()
            Self._Connection = nil
        end
    end

    if Options.GodMode then
        Self:SetGodMode(true)
    end

    return Self
end

return Player
]]))()

--// addons/WeaponMods.lua //--
local WeaponMods = (loadstring([[
--!strict
-- Cyan Weapon Mods add-on (best-effort, game-dependent).
-- These attempt to neutralize common weapon properties. Effectiveness depends
-- entirely on the game's weapon implementation; treat them as conveniences.

local WeaponMods = {}
WeaponMods.__index = WeaponMods

local Players: Players = game:GetService("Players")
local RunService: RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

export type WeaponModOptions = {
    NoRecoil: boolean?,
    NoSpread: boolean?,
    InfiniteAmmo: boolean?,
    RapidFire: boolean?,
}

function WeaponMods.new(Library, Options: WeaponModOptions?)
    Options = Options or {}
    local Self = setmetatable({}, WeaponMods)

    Self.Flags = {
        NoRecoil = Options.NoRecoil or false,
        NoSpread = Options.NoSpread or false,
        InfiniteAmmo = Options.InfiniteAmmo or false,
        RapidFire = Options.RapidFire or false,
    }
    Self._Connection = nil

    local function GetTool()
        local Character = LocalPlayer.Character
        if not Character then
            return nil
        end
        return Character:FindFirstChildOfClass("Tool")
            or Character:FindFirstChildOfClass("HopperBin")
    end

    local function SetIfPresent(Tool, Name, Value)
        pcall(function()
            if Tool[Name] ~= nil then
                Tool[Name] = Value
            end
        end)
    end

    local function Apply()
        local Tool = GetTool()
        if not Tool then
            return
        end
        if Self.Flags.NoRecoil then
            SetIfPresent(Tool, "Recoil", 0)
        end
        if Self.Flags.NoSpread then
            SetIfPresent(Tool, "Spread", 0)
        end
        if Self.Flags.InfiniteAmmo then
            SetIfPresent(Tool, "Ammo", 999999)
            SetIfPresent(Tool, "Clip", 999999)
            SetIfPresent(Tool, "ClipSize", 999999)
        end
        if Self.Flags.RapidFire then
            SetIfPresent(Tool, "FireRate", 0.05)
            SetIfPresent(Tool, "Cooldown", 0)
            SetIfPresent(Tool, "FireCooldown", 0)
        end
    end

    function Self:Set(Name: string, Enabled: boolean)
        if Self.Flags[Name] == nil then
            return
        end
        Self.Flags[Name] = Enabled
        local Any = Self.Flags.NoRecoil
            or Self.Flags.NoSpread
            or Self.Flags.InfiniteAmmo
            or Self.Flags.RapidFire
        if Any and not Self._Connection then
            Self._Connection = RunService.Heartbeat:Connect(Apply)
        elseif not Any and Self._Connection then
            Self._Connection:Disconnect()
            Self._Connection = nil
        end
    end

    function Self:Destroy()
        if Self._Connection then
            Self._Connection:Disconnect()
            Self._Connection = nil
        end
    end

    return Self
end

return WeaponMods
]]))()

--// Example.lua (body) //--
local Player = LoadModule("addons/Player.lua")
local WeaponMods = LoadModule("addons/WeaponMods.lua")

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false -- Forces AddToggle to AddCheckbox
Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)

-- CyanLogo is bundled in assets/ and loaded through Cyan's custom asset manager.
local CyanLogo = Library.ImageManager.GetAsset("CyanLogo")

local Window = Library:CreateWindow({
    -- Set Center to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Set Resizable to true if you want to have in-game resizable Window
    -- Set MobileButtonsSide to "Left" or "Right" if you want the ui toggle & lock buttons to be on the left or right side of the window
    -- Set ShowCustomCursor to false if you don't want to use the Linoria cursor
    -- NotifySide = Changes the side of the notifications (Left, Right) (Default value = Left)
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = "Cyan",
    Icon = CyanLogo,
    IconSize = UDim2.fromOffset(32, 32),
    Footer = "version: example",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

-- CALLBACK NOTE:
-- Passing in callback functions via the initial element parameters (i.e. Callback = function(Value)...) works
-- HOWEVER, using Toggles/Options.INDEX:OnChanged(function(Value) ... ) is the RECOMMENDED way to do this.
-- I strongly recommend decoupling UI code from logic code. i.e. Create your UI elements FIRST, and THEN setup :OnChanged functions later.

-- You do not have to set your tabs & groups up this way, just a prefrence.
-- You can find more icons in https://lucide.dev/
Window:AddHeaderButton({
    Text = "R",
    Tooltip = "Reset menu position",
    Visible = not Library.IsMobile,
}, function()
    Window:ResetPosition()
end)

Window:AddHeaderButton({
    Text = "S",
    Tooltip = "Toggle compact sidebar",
    Visible = not Library.IsMobile,
}, function()
    Window:ToggleSidebar()
end)

Window:AddHeaderButton({
    Text = "F",
    Tooltip = "Focus search",
    Visible = not Library.IsMobile,
}, function()
    Window:FocusSearch()
end)

local Tabs = {
    -- Creates a new tab titled Main
    Main = Window:AddTab("Main", "user"),
    Key = Window:AddKeyTab("Key System"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

--[[
Example of how to add a warning box to a tab; the title AND text support rich text formatting.

local UISettingsTab = Tabs["UI Settings"]

UISettingsTab:UpdateWarningBox({
	Visible = true,
	Title = "Warning",
	Text = "This is a warning box!",
})

--]]

-- Groupbox and Tabbox inherit the same functions
-- except Tabboxes you have to call the functions on a tab (Tabbox:AddTab(Name))
local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Groupbox", "boxes")

-- We can also get our Main tab via the following code:
-- local LeftGroupBox = Window.Tabs.Main:AddLeftGroupbox("Groupbox", "boxes")

-- Tabboxes are a tiny bit different, but here's a basic example:
--[[

local TabBox = Tabs.Main:AddLeftTabbox() -- Add Tabbox on left side

local Tab1 = TabBox:AddTab("Tab 1")
local Tab2 = TabBox:AddTab("Tab 2")

-- You can now call AddToggle, etc on the tabs you added to the Tabbox
]]

-- Groupbox:AddToggle
-- Arguments: Index, Options
LeftGroupBox:AddToggle("MyToggle", {
    Text = "This is a toggle",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the toggle
    DisabledTooltip = "I am disabled!", -- Information shown when you hover over the toggle while it's disabled

    Default = true, -- Default value (true / false)
    Disabled = false, -- Will disable the toggle (true / false)
    Visible = true, -- Will make the toggle invisible (true / false)
    Risky = false, -- Makes the text red (the color can be changed using Library.Scheme.Red) (Default value = false)

    Callback = function(Value)
        print("[cb] MyToggle changed to:", Value)
    end,
})
    :AddColorPicker("ColorPicker1", {
        Default = Color3.new(1, 0, 0),
        Title = "Some color1", -- Optional. Allows you to have a custom color picker title (when you open it)
        Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

        Callback = function(Value)
            print("[cb] Color changed!", Value)
        end,
    })
    :AddColorPicker("ColorPicker2", {
        Default = Color3.new(0, 1, 0),
        Title = "Some color2",

        Callback = function(Value)
            print("[cb] Color changed!", Value)
        end,
    })

-- Fetching a toggle object for later use:
-- Toggles.MyToggle.Value

-- Toggles is a table added to getgenv() by the library
-- You index Toggles with the specified index, in this case it is 'MyToggle'
-- To get the state of the toggle you do toggle.Value

-- Calls the passed function when the toggle is updated
Toggles.MyToggle:OnChanged(function()
    -- here we get our toggle object & then get its value
    print("MyToggle changed to:", Toggles.MyToggle.Value)
end)

-- This should print to the console: "My toggle state changed! New value: false"
Toggles.MyToggle:SetValue(false)

LeftGroupBox:AddCheckbox("MyCheckbox", {
    Text = "This is a checkbox",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the toggle
    DisabledTooltip = "I am disabled!", -- Information shown when you hover over the toggle while it's disabled

    Default = true, -- Default value (true / false)
    Disabled = false, -- Will disable the toggle (true / false)
    Visible = true, -- Will make the toggle invisible (true / false)
    Risky = false, -- Makes the text red (the color can be changed using Library.Scheme.Red) (Default value = false)

    Callback = function(Value)
        print("[cb] MyCheckbox changed to:", Value)
    end,
})

Toggles.MyCheckbox:OnChanged(function()
    print("MyCheckbox changed to:", Toggles.MyCheckbox.Value)
end)

-- 1/15/23
-- Deprecated old way of creating buttons in favor of using a table
-- Added DoubleClick button functionality

--[[
	Groupbox:AddButton
	Arguments: {
		Text = string,
		Func = function,
		DoubleClick = boolean
		Tooltip = string,
	}

	You can call :AddButton on a button to add a SubButton!
]]

local MyButton = LeftGroupBox:AddButton({
    Text = "Button",
    Func = function()
        print("You clicked a button!")
    end,
    DoubleClick = false,

    Tooltip = "This is the main button",
    DisabledTooltip = "I am disabled!",

    Disabled = false, -- Will disable the button (true / false)
    Visible = true, -- Will make the button invisible (true / false)
    Risky = false, -- Makes the text red (the color can be changed using Library.Scheme.Red) (Default value = false)
})

local MyButton2 = MyButton:AddButton({
    Text = "Sub button",
    Func = function()
        print("You clicked a sub button!")
    end,
    DoubleClick = true, -- You will have to click this button twice to trigger the callback
    Tooltip = "This is the sub button",
    DisabledTooltip = "I am disabled!",
})

local MyDisabledButton = LeftGroupBox:AddButton({
    Text = "Disabled Button",
    Func = function()
        print("You somehow clicked a disabled button!")
    end,
    DoubleClick = false,
    Tooltip = "This is a disabled button",
    DisabledTooltip = "I am disabled!", -- Information shown when you hover over the button while it's disabled
    Disabled = true,
})

--[[
	NOTE: You can chain the button methods!
	EXAMPLE:

	LeftGroupBox:AddButton({ Text = 'Kill all', Func = Functions.KillAll, Tooltip = 'This will kill everyone in the game!' })
		:AddButton({ Text = 'Kick all', Func = Functions.KickAll, Tooltip = 'This will kick everyone in the game!' })
]]

-- Groupbox:AddLabel
-- Arguments: Text, DoesWrap, Idx
-- Arguments: Idx, Options
LeftGroupBox:AddLabel("This is a label")
LeftGroupBox:AddLabel("This is a label\n\nwhich wraps its text!", true)
LeftGroupBox:AddLabel("This is a label exposed to Labels", true, "TestLabel")
LeftGroupBox:AddLabel("SecondTestLabel", {
    Text = "This is a label made with table options and an index",
    DoesWrap = true, -- Defaults to false
})

LeftGroupBox:AddLabel("SecondTestLabel", {
    Text = "This is a label that doesn't wrap it's own text",
    DoesWrap = false, -- Defaults to false
})

-- Options is a table added to getgenv() by the library
-- You index Options with the specified index, in this case it is 'SecondTestLabel' & 'TestLabel'
-- To set the text of the label you do label:SetText

-- Options.TestLabel:SetText("first changed!")
-- Options.SecondTestLabel:SetText("second changed!")

-- Groupbox:AddDivider
-- Arguments: None
LeftGroupBox:AddDivider()

--[[
	Groupbox:AddSlider
	Arguments: Idx, SliderOptions

	SliderOptions: {
		Text = string,
		Default = number,
		Min = number,
		Max = number,
		Suffix = string,
		Rounding = number,
		Compact = boolean,
		HideMax = boolean,
	}

	Text, Default, Min, Max, Rounding must be specified.
	Suffix is optional.
	Rounding is the number of decimal places for precision.

	Compact will hide the title label of the Slider

	HideMax will only display the value instead of the value & max value of the slider
	Compact will do the same thing
]]
LeftGroupBox:AddSlider("MySlider", {
    Text = "This is my slider!",
    Default = 0,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        print("[cb] MySlider was changed! New value:", Value)
    end,

    Tooltip = "I am a slider!", -- Information shown when you hover over the slider
    DisabledTooltip = "I am disabled!", -- Information shown when you hover over the slider while it's disabled

    Disabled = false, -- Will disable the slider (true / false)
    Visible = true, -- Will make the slider invisible (true / false)
})

-- Options is a table added to getgenv() by the library
-- You index Options with the specified index, in this case it is 'MySlider'
-- To get the value of the slider you do slider.Value

local Number = Options.MySlider.Value
Options.MySlider:OnChanged(function()
    print("MySlider was changed! New value:", Options.MySlider.Value)
end)

-- This should print to the console: "MySlider was changed! New value: 3"
Options.MySlider:SetValue(3)

LeftGroupBox:AddSlider("MySlider2", {
    Text = "This is my custom display slider!",
    Default = 0,
    Min = 0,
    Max = 5,
    Rounding = 0,
    Compact = false,

    FormatDisplayValue = function(slider, value)
        if value == slider.Max then
            return "Everything"
        end
        if value == slider.Min then
            return "Nothing"
        end
        -- If you return nil, the default formatting will be applied
    end,

    Tooltip = "I am a slider!", -- Information shown when you hover over the slider
    DisabledTooltip = "I am disabled!", -- Information shown when you hover over the slider while it's disabled

    Disabled = false, -- Will disable the slider (true / false)
    Visible = true, -- Will make the slider invisible (true / false)
})

-- Groupbox:AddInput
-- Arguments: Idx, Info
LeftGroupBox:AddInput("MyTextbox", {
    Default = "My textbox!",
    Numeric = false, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter
    ClearTextOnFocus = true, -- true / false, if false the text will not clear when textbox focused

    Text = "This is a textbox",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the textbox

    Placeholder = "Placeholder text", -- placeholder text when the box is empty
    -- MaxLength is also an option which is the max length of the text

    Callback = function(Value)
        print("[cb] Text updated. New text:", Value)
    end,
})

Options.MyTextbox:OnChanged(function()
    print("Text updated. New text:", Options.MyTextbox.Value)
end)

-- Groupbox:AddDropdown
-- Arguments: Idx, Info

local DropdownGroupBox = Tabs.Main:AddRightGroupbox("Dropdowns")

DropdownGroupBox:AddDropdown("MyDropdown", {
    Values = { "This", "is", "a", "dropdown" },
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = "A dropdown",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the dropdown
    DisabledTooltip = "I am disabled!", -- Information shown when you hover over the dropdown while it's disabled

    Searchable = false, -- true / false, makes the dropdown searchable (great for a long list of values)

    Callback = function(Value)
        print("[cb] Dropdown got changed. New value:", Value)
    end,

    Disabled = false, -- Will disable the dropdown (true / false)
    Visible = true, -- Will make the dropdown invisible (true / false)
})

Options.MyDropdown:OnChanged(function()
    print("Dropdown got changed. New value:", Options.MyDropdown.Value)
end)

Options.MyDropdown:SetValue("This")

DropdownGroupBox:AddDropdown("MySearchableDropdown", {
    Values = { "This", "is", "a", "searchable", "dropdown" },
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = "A searchable dropdown",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the dropdown
    DisabledTooltip = "I am disabled!", -- Information shown when you hover over the dropdown while it's disabled

    Searchable = true, -- true / false, makes the dropdown searchable (great for a long list of values)

    Callback = function(Value)
        print("[cb] Dropdown got changed. New value:", Value)
    end,

    Disabled = false, -- Will disable the dropdown (true / false)
    Visible = true, -- Will make the dropdown invisible (true / false)
})

DropdownGroupBox:AddDropdown("MyDisplayFormattedDropdown", {
    Values = { "This", "is", "a", "formatted", "dropdown" },
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = "A display formatted dropdown",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the dropdown
    DisabledTooltip = "I am disabled!", -- Information shown when you hover over the dropdown while it's disabled

    FormatDisplayValue = function(Value) -- You can change the display value for any values. The value will be still same, only the UI changes.
        if Value == "formatted" then
            return "display formatted" -- formatted -> display formatted but in Options.MyDisplayFormattedDropdown.Value it will still return formatted if its selected.
        end

        return Value
    end,

    Searchable = false, -- true / false, makes the dropdown searchable (great for a long list of values)

    Callback = function(Value)
        print("[cb] Display formatted dropdown got changed. New value:", Value)
    end,

    Disabled = false, -- Will disable the dropdown (true / false)
    Visible = true, -- Will make the dropdown invisible (true / false)
})

-- Multi dropdowns
DropdownGroupBox:AddDropdown("MyMultiDropdown", {
    -- Default is the numeric index (e.g. "This" would be 1 since it if first in the values list)
    -- Default also accepts a string as well

    -- Currently you can not set multiple values with a dropdown

    Values = { "This", "is", "a", "dropdown" },
    Default = 1,
    Multi = true, -- true / false, allows multiple choices to be selected

    Text = "A multi dropdown",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the dropdown

    Callback = function(Value)
        print("[cb] Multi dropdown got changed:")
        for key, value in next, Options.MyMultiDropdown.Value do
            print(key, value) -- should print something like This, true
        end
    end,
})

Options.MyMultiDropdown:SetValue({
    This = true,
    is = true,
})

DropdownGroupBox:AddDropdown("MyDisabledDropdown", {
    Values = { "This", "is", "a", "dropdown" },
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = "A disabled dropdown",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the dropdown
    DisabledTooltip = "I am disabled!", -- Information shown when you hover over the dropdown while it's disabled

    Callback = function(Value)
        print("[cb] Disabled dropdown got changed. New value:", Value)
    end,

    Disabled = true, -- Will disable the dropdown (true / false)
    Visible = true, -- Will make the dropdown invisible (true / false)
})

DropdownGroupBox:AddDropdown("MyDisabledValueDropdown", {
    Values = { "This", "is", "a", "dropdown", "with", "disabled", "value" },
    DisabledValues = { "disabled" }, -- Disabled Values that are unclickable
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = "A dropdown with disabled value",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the dropdown
    DisabledTooltip = "I am disabled!", -- Information shown when you hover over the dropdown while it's disabled

    Callback = function(Value)
        print("[cb] Dropdown with disabled value got changed. New value:", Value)
    end,

    Disabled = false, -- Will disable the dropdown (true / false)
    Visible = true, -- Will make the dropdown invisible (true / false)
})

DropdownGroupBox:AddDropdown("MyVeryLongDropdown", {
    Values = {
        "This",
        "is",
        "a",
        "very",
        "long",
        "dropdown",
        "with",
        "a",
        "lot",
        "of",
        "values",
        "but",
        "you",
        "can",
        "see",
        "more",
        "than",
        "8",
        "values",
    },
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    MaxVisibleDropdownItems = 12, -- Default: 8, allows you to change the size of the dropdown list

    Text = "A very long dropdown",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the dropdown
    DisabledTooltip = "I am disabled!", -- Information shown when you hover over the dropdown while it's disabled

    Searchable = false, -- true / false, makes the dropdown searchable (great for a long list of values)

    Callback = function(Value)
        print("[cb] Very long dropdown got changed. New value:", Value)
    end,

    Disabled = false, -- Will disable the dropdown (true / false)
    Visible = true, -- Will make the dropdown invisible (true / false)
})

DropdownGroupBox:AddDropdown("MyPlayerDropdown", {
    SpecialType = "Player",
    ExcludeLocalPlayer = true, -- true / false, excludes the localplayer from the Player type
    Text = "A player dropdown",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the dropdown

    Callback = function(Value)
        print("[cb] Player dropdown got changed:", Value)
    end,
})

DropdownGroupBox:AddDropdown("MyTeamDropdown", {
    SpecialType = "Team",
    Text = "A team dropdown",
    Tooltip = "This is a tooltip", -- Information shown when you hover over the dropdown

    Callback = function(Value)
        print("[cb] Team dropdown got changed:", Value)
    end,
})

-- Label:AddColorPicker
-- Arguments: Idx, Info

-- You can also ColorPicker & KeyPicker to a Toggle as well

LeftGroupBox:AddLabel("Color"):AddColorPicker("ColorPicker", {
    Default = Color3.new(0, 1, 0), -- Bright green
    Title = "Some color", -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        print("[cb] Color changed!", Value)
    end,
})

Options.ColorPicker:OnChanged(function()
    print("Color changed!", Options.ColorPicker.Value)
    print("Transparency changed!", Options.ColorPicker.Transparency)
end)

Options.ColorPicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

-- Label:AddKeyPicker
-- Arguments: Idx, Info

LeftGroupBox:AddLabel("Keybind"):AddKeyPicker("KeyPicker", {
    -- SyncToggleState only works with toggles.
    -- It allows you to make a keybind which has its state synced with its parent toggle

    -- Example: Keybind which you use to toggle flyhack, etc.
    -- Changing the toggle disables the keybind state and toggling the keybind switches the toggle state

    Default = "MB2", -- String as the name of the keybind (MB1, MB2 for mouse buttons)
    SyncToggleState = false,

    -- You can define custom Modes but I have never had a use for it.
    Mode = "Toggle", -- Modes: Always, Toggle, Hold, Press (example down below)

    Text = "Auto lockpick safes", -- Text to display in the keybind menu
    NoUI = false, -- Set to true if you want to hide from the Keybind menu,

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        print("[cb] Keybind clicked!", Value)
    end,

    -- Occurs when the keybind itself is changed, `NewKey` is a KeyCode Enum OR a UserInputType Enum, `NewModifiers` is a table with KeyCode Enum(s) or nil
    ChangedCallback = function(NewKey, NewModifiers)
        print("[cb] Keybind changed!", NewKey, table.unpack(NewModifiers or {}))
    end,
})

-- OnClick is only fired when you press the keybind and the mode is Toggle
-- Otherwise, you will have to use Keybind:GetState()
Options.KeyPicker:OnClick(function()
    print("Keybind clicked!", Options.KeyPicker:GetState())
end)

Options.KeyPicker:OnChanged(function()
    print(
        "Keybind changed!",
        Options.KeyPicker.Value,
        table.unpack(Options.KeyPicker.Modifiers or {})
    )
end)

task.spawn(function()
    while task.wait(1) do
        if Library.Unloaded then
            break
        end

        -- example for checking if a keybind is being pressed
        local state = Options.KeyPicker:GetState()
        if state then
            print("KeyPicker is being held down")
        end
    end
end)

Options.KeyPicker:SetValue({ "MB2", "Hold" }) -- Sets keybind to MB2, mode to Hold

-- Label:KeyPicker (Press Mode)

local KeybindNumber = 0

LeftGroupBox:AddLabel("Press Keybind"):AddKeyPicker("KeyPicker2", {
    -- Example: Press Keybind which you use to run a callback when the key was pressed.

    Default = "X", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    Mode = "Press",
    WaitForCallback = false, -- Locks the keybind during the execution of Callback and OnChanged.

    Text = "Increase Number", -- Text to display in the keybind menu

    -- Occurs when the keybind is clicked, Value is always `true` for Press keybind.
    Callback = function()
        KeybindNumber = KeybindNumber + 1
        print("[cb] Keybind clicked! Number increased to:", KeybindNumber)
    end,
})

-- Long text label to demonstrate UI scrolling behaviour.
local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox("Groupbox #2")
LeftGroupBox2:AddLabel(
    "This label spans multiple lines! We're gonna run out of UI space...\nJust kidding! Scroll down!\n\n\nHello from below!",
    true
)

local TabBox = Tabs.Main:AddRightTabbox() -- Add Tabbox on right side

-- Anything we can do in a Groupbox, we can do in a Tabbox tab (AddToggle, AddSlider, AddLabel, etc etc...)
local Tab1 = TabBox:AddTab("Tab 1")
Tab1:AddToggle("Tab1Toggle", { Text = "Tab1 Toggle" })

local Tab2 = TabBox:AddTab("Tab 2")
Tab2:AddToggle("Tab2Toggle", { Text = "Tab2 Toggle" })

Library:OnUnload(function()
    print("Unloaded!")
end)

-- Callback-driven key system. This demo validator is intentionally local and not secure;
-- production experiences must verify entitlement on a trusted server or backend.
local DemoKeySystem = KeySystem.new({
    Validate = function(ReceivedKey)
        if ReceivedKey == "EB" then
            return true, "Demo access granted"
        end

        return false, "That demo key is not valid"
    end,
    MaxAttempts = 5,
    CooldownSeconds = 1,
    OnVerified = function()
        Library:Notify({
            Title = "Access granted",
            Description = "The validator callback accepted the submitted key.",
            Time = 4,
        })
    end,
})

-- NOTE: The "UI Settings" tab (which holds ESP + every addon control) and the Main
-- tab used to be hidden behind the KeySystem demo via GateTabs. That is by-design
-- demo behaviour, but it made ESP/features invisible until the demo key `EB` was
-- entered. We keep the KeySystem demo (Attach below) but no longer gate the tabs,
-- so ESP and all addon controls are visible immediately. To restore the locked demo,
-- uncomment the block below.
-- DemoKeySystem:GateTabs(Tabs.Key, {
--     Tabs.Main,
--     Tabs["UI Settings"],
-- }, {
--     DefaultTab = Tabs.Main,
--     HideLoginTabAfterVerification = true,
--     HideSearchBeforeVerification = true,
-- })

DemoKeySystem:Attach(Tabs.Key, {
    Prompt = "Enter `EB` to access the example menu.",
    Placeholder = "Access key",
})

-- UI Settings
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddButton("Focus search (Ctrl+K)", function()
    Window:FocusSearch()
end)

MenuGroup:AddButton("Clear search", function()
    Window:ClearSearch()
end)

MenuGroup:AddButton("Log out", function()
    if not DemoKeySystem:Logout() then
        Library:Notify("No verified login session is active.")
    end
end)

MenuGroup:AddToggle("ShowSearch", {
    Text = "Show Search",
    Default = true,
    Callback = function(Value)
        Window:SetSearchVisible(Value)
    end,
})

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = Library.ShowCustomCursor,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})
MenuGroup:AddToggle("ReducedMotion", {
    Text = "Reduce Motion",
    Default = Library.ReducedMotion,
    Tooltip = "Disables Cyan UI animations for a calmer, more accessible interface.",
    Callback = function(Value)
        Library:SetReducedMotion(Value)
    end,
})
MenuGroup:AddToggle("LiquidGlass", {
    Text = "Liquid Glass",
    Default = Library.GlassEnabled,
    Tooltip = "Applies Cyan translucent glass surfaces, gradients, and highlights.",
    Callback = function(Value)
        Window:SetGlass(Value)
    end,
})
MenuGroup:AddSlider("GlassTransparency", {
    Text = "Glass Transparency",
    Default = Library.GlassTransparency,
    Min = 0,
    Max = 0.85,
    Rounding = 2,
    Callback = function(Value)
        Window:SetGlass(Library.GlassEnabled, Value)
    end,
})
MenuGroup:AddDropdown("GlassPreset", {
    Text = "Glass Preset",
    Values = { "Liquid", "Crystal", "Frosted", "Ocean", "Aurora", "Midnight", "Solid" },
    Default = Window:GetGlassPreset(),
    AllowNull = false,
    Callback = function(Value)
        Window:SetGlassPreset(Value)
    end,
})
MenuGroup:AddToggle("GlassSheen", {
    Text = "Animate Glass",
    Default = true,
    Callback = function(Value)
        Window:SetGlassSheen(Value)
    end,
})
MenuGroup:AddSlider("GlassSheenSpeed", {
    Text = "Glass Sheen Speed",
    Default = 7,
    Min = 2,
    Max = 20,
    Rounding = 0,
    Callback = function(Value)
        Window:SetGlassSheen(Toggles.GlassSheen and Toggles.GlassSheen.Value or false, Value)
    end,
})
MenuGroup:AddToggle("GlassBackgroundMotion", {
    Text = "Animate Background",
    Default = true,
    Callback = function(Value)
        Window:SetGlassBackgroundMotion(Value)
    end,
})
MenuGroup:AddSlider("GlassBackgroundMotionSpeed", {
    Text = "Background Motion Speed",
    Default = 14,
    Min = 4,
    Max = 30,
    Rounding = 0,
    Callback = function(Value)
        Window:SetGlassBackgroundMotion(
            Toggles.GlassBackgroundMotion and Toggles.GlassBackgroundMotion.Value or false,
            Value
        )
    end,
})
MenuGroup:AddToggle("GlassBlur", {
    Text = "Glass Blur",
    Default = false,
    Tooltip = "Applies an optional scene blur while the menu is open.",
    Callback = function(Value)
        Window:SetGlassBlur(Value)
    end,
})
MenuGroup:AddSlider("GlassBlurSize", {
    Text = "Glass Blur Size",
    Default = 8,
    Min = 0,
    Max = 24,
    Rounding = 0,
    Callback = function(Value)
        Window:SetGlassBlur(Toggles.GlassBlur and Toggles.GlassBlur.Value or false, Value)
    end,
})
MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",

    Text = "Notification Side",

    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})
MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",

    Text = "DPI Scale",

    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)

        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddDropdown("MobileLayout", {
    Text = "Mobile Layout",
    Values = { "Compact", "Balanced", "Expanded" },
    Default = Window:GetMobileLayout(),
    AllowNull = false,
    Visible = Library.IsMobile,
    Callback = function(Value)
        Window:SetMobileLayout(Value)
    end,
})

local SwipeEnabled, SwipeThreshold = Window:GetTabSwipeNavigation()
MenuGroup:AddToggle("TabSwipeNavigation", {
    Text = "Swipe Between Tabs",
    Default = SwipeEnabled,
    Visible = Library.IsMobile,
    Callback = function(Value)
        Window:SetTabSwipeNavigation(Value)
    end,
})
MenuGroup:AddSlider("TabSwipeThreshold", {
    Text = "Swipe Threshold",
    Default = SwipeThreshold,
    Min = 24,
    Max = 160,
    Rounding = 0,
    Visible = Library.IsMobile,
    Callback = function(Value)
        Window:SetTabSwipeNavigation(
            Toggles.TabSwipeNavigation and Toggles.TabSwipeNavigation.Value or false,
            Value
        )
    end,
})

MenuGroup:AddSlider("UICornerSlider", {
    Text = "Corner Radius",
    Default = Library.CornerRadius,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(value)
        Window:SetCornerRadius(value)
    end,
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- ESP + Aimbot setup
local ESPManager = ESP.new(Library, {
    TeamColor = Color3.fromRGB(0, 255, 0),
    EnemyColor = Color3.fromRGB(255, 50, 50),
    DefaultBoxColor = Color3.fromRGB(255, 255, 255),
})

local ESPGroup = Tabs["UI Settings"]:AddRightGroupbox("ESP & Aimbot", "eye")

ESPGroup:AddToggle("ESPToggle", {
    Text = "Enable ESP",
    Default = true,
    Callback = function(Value)
        ESPManager:SetEnabled(Value)
    end,
})

ESPGroup:AddToggle("ESPBoxes", {
    Text = "Boxes",
    Default = true,
    Callback = function(Value)
        ESPManager:SetBoxesVisible(Value)
    end,
})

ESPGroup:AddToggle("ESPNames", {
    Text = "Names",
    Default = true,
    Callback = function(Value)
        ESPManager:SetNamesVisible(Value)
    end,
})

ESPGroup:AddToggle("ESPTracers", {
    Text = "Tracers",
    Default = false,
    Callback = function(Value)
        ESPManager:SetTracersVisible(Value)
    end,
})

ESPGroup:AddToggle("ESPTeamCheck", {
    Text = "Team Check",
    Default = false,
    Tooltip = "Hides ESP for players on the same team.",
    Callback = function(Value)
        ESPManager:SetTeamCheck(Value)
    end,
})

ESPGroup:AddDropdown("ESPBoxStyle", {
    Values = { "Corner", "Standard", "Outline" },
    Default = "Corner",
    Text = "Box Style",
    Callback = function(Value)
        if ESPManager.Players then
            for _, Handler in ESPManager.Players do
                if Handler and Handler.Options then
                    Handler.Options.BoxStyle = Value
                end
            end
        end
    end,
})

ESPGroup:AddDivider()

ESPGroup:AddLabel("FOV Circle"):AddKeyPicker("FOVKeybind", {
    Default = "F",
    Mode = "Toggle",
    Text = "Toggle FOV circle",
    NoUI = false,
    Callback = function(Value)
        ESPManager:ShowFOVCircle(Value)
    end,
})

ESPGroup:AddSlider("FOVRadius", {
    Text = "FOV Radius",
    Default = 60,
    Min = 10,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        ESPManager:SetFOVCircle({
            Radius = Value,
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 0.85,
            Enabled = Toggles.FOVKeybind and Toggles.FOVKeybind:GetState() or false,
        })
    end,
})

ESPGroup:AddToggle("FOVFilled", {
    Text = "Filled",
    Default = false,
    Callback = function(Value)
        ESPManager:SetFOVCircle({
            Filled = Value,
            Enabled = Toggles.FOVKeybind and Toggles.FOVKeybind:GetState() or false,
        })
    end,
})

ESPGroup:AddDivider()

ESPGroup:AddLabel("Aimbot helpers")
ESPGroup:AddButton({
    Text = "Lock nearest target",
    Func = function()
        local Target = ESPManager:GetNearestPlayerToMouse(200)
        if Target then
            ESPManager:LockOntoTarget(Target)
            Library:Notify({
                Title = "Target locked",
                Description = "Locked onto " .. Target.Name,
                Time = 2,
            })
        else
            Library:Notify("No target found within range.")
        end
    end,
})

ESPGroup:AddButton({
    Text = "Unlock target",
    Func = function()
        ESPManager:UnlockTarget()
        Library:Notify("Target released.")
    end,
})

ESPGroup:AddDivider()
ESPGroup:AddLabel("Aimbot")

ESPGroup:AddToggle("AimbotEnabled", {
    Text = "Aimbot",
    Default = false,
    Tooltip = "Enables the aimbot system.",
    Callback = function(Value)
        ESPManager:SetAimbotEnabled(Value)
    end,
})

ESPGroup:AddToggle("SilentAim", {
    Text = "Silent Aim",
    Default = false,
    Tooltip = "Silently rotates your character toward the target without visible snapping.",
    Callback = function(Value)
        ESPManager:SetAimbotOptions({ SilentAim = Value })
    end,
})

ESPGroup:AddToggle("AutoFire", {
    Text = "Auto Fire",
    Default = false,
    Tooltip = "Automatically fires your equipped tool when a target is in FOV.",
    Callback = function(Value)
        ESPManager:SetAimbotOptions({ AutoFire = Value })
    end,
})

ESPGroup:AddSlider("AutoFireDelay", {
    Text = "Auto Fire Delay",
    Default = 0.15,
    Min = 0.05,
    Max = 1,
    Rounding = 2,
    Suffix = "s",
    Callback = function(Value)
        ESPManager:SetAimbotOptions({ AutoFireDelay = Value })
    end,
})

ESPGroup:AddSlider("AimbotFOV", {
    Text = "Aimbot FOV",
    Default = 60,
    Min = 5,
    Max = 360,
    Rounding = 0,
    Suffix = "\u{00B0}",
    Callback = function(Value)
        ESPManager:SetAimbotOptions({ FOV = Value })
    end,
})

ESPGroup:AddSlider("AimbotSmoothness", {
    Text = "Smoothness",
    Default = 0.8,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Suffix = "",
    Callback = function(Value)
        ESPManager:SetAimbotOptions({ Smoothness = Value })
    end,
})

ESPGroup:AddSlider("PredictionAmount", {
    Text = "Prediction",
    Default = 0.5,
    Min = 0,
    Max = 2,
    Rounding = 1,
    Suffix = "",
    Callback = function(Value)
        ESPManager:SetAimbotOptions({ PredictionAmount = Value })
    end,
})

ESPGroup:AddDropdown("AimbotHitbox", {
    Text = "Hitbox",
    Values = { "Head", "Torso", "Limb", "Random" },
    Default = "Torso",
    Callback = function(Value)
        ESPManager:SetAimbotOptions({ Hitbox = Value })
    end,
})

ESPGroup:AddDivider()
ESPGroup:AddLabel("Magic Bullet")

ESPGroup:AddToggle("MagicBullet", {
    Text = "Magic Bullet",
    Default = false,
    Tooltip = "Redirects fired projectiles to the locked target.",
    Callback = function(Value)
        ESPManager:SetAimbotOptions({ MagicBullet = Value })
    end,
})

ESPGroup:AddSlider("MagicBulletChance", {
    Text = "Hit Chance",
    Default = 100,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Suffix = "%",
    Callback = function(Value)
        ESPManager:SetAimbotOptions({ MagicBulletChance = Value })
    end,
})

-- Start ESP after a short delay to let players load
task.delay(2, function()
    if Library.Unloaded then
        return
    end

    ESPManager:AddPlayerESP({
        Box = true,
        BoxStyle = "Corner",
        HealthBar = true,
        Name = true,
        Distance = true,
        Tracer = false,
        Chams = false,
        TeamCheck = false,
    })

    ESPManager:SetFOVCircle({
        Radius = 60,
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.85,
        Filled = false,
        Enabled = false,
    })
end)

-- Radar setup
local RadarManager = Radar.new(Library, {
    Range = 150,
    Zoom = 1,
    Size = 180,
    Position = "TopLeft",
    ShowLocalFOV = true,
    FOVAngle = 90,
    BlipStyle = "Arrow",
    BlipSize = 4,
    ShowNames = false,
    ShowGrid = true,
    TeamColor = Color3.fromRGB(0, 255, 0),
    EnemyColor = Color3.fromRGB(255, 50, 50),
    LocalColor = Color3.fromRGB(0, 150, 255),
    Visible = true,
})

local RadarGroup = Tabs["UI Settings"]:AddLeftGroupbox("Radar", "compass")

RadarGroup:AddToggle("RadarToggle", {
    Text = "Enable Radar",
    Default = true,
    Callback = function(Value)
        RadarManager:SetVisible(Value)
    end,
})

RadarGroup:AddSlider("RadarRange", {
    Text = "Range",
    Default = 150,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        RadarManager:SetRange(Value)
    end,
})

RadarGroup:AddSlider("RadarZoom", {
    Text = "Zoom",
    Default = 1,
    Min = 0.5,
    Max = 3,
    Rounding = 1,
    Callback = function(Value)
        RadarManager:SetZoom(Value)
    end,
})

RadarGroup:AddDropdown("RadarPosition", {
    Values = { "TopLeft", "TopRight", "BottomLeft", "BottomRight" },
    Default = "TopLeft",
    Text = "Position",
    Callback = function(Value)
        RadarManager:SetPosition(Value)
    end,
})

RadarGroup:AddDropdown("RadarBlipStyle", {
    Values = { "Arrow", "Dot", "Ring" },
    Default = "Arrow",
    Text = "Blip Style",
    Callback = function(Value)
        RadarManager:SetBlipStyle(Value)
    end,
})

RadarGroup:AddToggle("RadarNames", {
    Text = "Show Names",
    Default = false,
    Callback = function(Value)
        RadarManager:SetShowNames(Value)
    end,
})

RadarGroup:AddSlider("RadarBlipSize", {
    Text = "Blip Size",
    Default = 4,
    Min = 2,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        RadarManager:SetBlipSize(Value)
    end,
})

RadarGroup:AddToggle("RadarFOV", {
    Text = "Show FOV Cone",
    Default = true,
    Callback = function(Value)
        RadarManager:SetShowFOV(Value)
    end,
})

RadarGroup:AddSlider("RadarFOVAngle", {
    Text = "FOV Angle",
    Default = 90,
    Min = 10,
    Max = 360,
    Rounding = 0,
    Suffix = "\u{00B0}",
    Callback = function(Value)
        RadarManager:SetFOVAngle(Value)
    end,
})

-- Movement addon
local MovementManager = Movement.new(Library, {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    AutoNoclipWhenFlying = true,
})

local MoveGroup = Tabs["UI Settings"]:AddRightGroupbox("Movement", "zap")

MoveGroup:AddToggle("WalkSpeedToggle", {
    Text = "Override WalkSpeed",
    Default = false,
    Callback = function(Value)
        if Value then
            MovementManager:SetWalkSpeed(Options.WalkSpeedSlider.Value, true)
        else
            MovementManager:SetWalkSpeed(16, false)
        end
    end,
})

MoveGroup:AddSlider("WalkSpeedSlider", {
    Text = "WalkSpeed",
    Default = 16,
    Min = 1,
    Max = 250,
    Rounding = 0,
    Suffix = " studs/s",
    Callback = function(Value)
        if Toggles.WalkSpeedToggle and Toggles.WalkSpeedToggle.Value then
            MovementManager:SetWalkSpeed(Value, true)
        end
    end,
})

MoveGroup:AddToggle("JumpPowerToggle", {
    Text = "Override Jump Power",
    Default = false,
    Callback = function(Value)
        if Value then
            MovementManager:SetJumpPower(Options.JumpPowerSlider.Value, true)
        else
            MovementManager:SetJumpPower(50, false)
        end
    end,
})

MoveGroup:AddSlider("JumpPowerSlider", {
    Text = "Jump Power",
    Default = 50,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        if Toggles.JumpPowerToggle and Toggles.JumpPowerToggle.Value then
            MovementManager:SetJumpPower(Value, true)
        end
    end,
})

MoveGroup:AddDivider()

MoveGroup:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false,
    Tooltip = "Press Space to go up, Shift to go down, Ctrl to sprint.",
    Callback = function(Value)
        MovementManager:SetFlying(Value)
    end,
})

MoveGroup:AddSlider("FlySpeedSlider", {
    Text = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Suffix = " studs/s",
    Callback = function(Value)
        MovementManager:SetFlySpeed(Value)
    end,
})

MoveGroup:AddToggle("NoclipToggle", {
    Text = "Noclip",
    Default = false,
    Tooltip = "Walk through walls and objects.",
    Callback = function(Value)
        MovementManager:SetNoclipping(Value)
    end,
})

MoveGroup:AddDivider()

MoveGroup:AddLabel("Anti-tools")

MoveGroup:AddToggle("AntiVoidToggle", {
    Text = "Anti Void",
    Default = false,
    Tooltip = "Teleports you back when falling below the map.",
    Callback = function(Value)
        MovementManager:SetAntiVoid(Value)
    end,
})

MoveGroup:AddToggle("AntiTeleportToggle", {
    Text = "Anti Teleport",
    Default = false,
    Tooltip = "Blocks forced teleportation beyond 500 studs.",
    Callback = function(Value)
        MovementManager:SetAntiTeleport(Value)
    end,
})

-- Visuals addon
local VisualsManager = Visuals.new(Library, {})

local VisGroup = Tabs["UI Settings"]:AddLeftGroupbox("Visuals", "eye")

VisGroup:AddToggle("FullbrightToggle", {
    Text = "Fullbright",
    Default = false,
    Tooltip = "Fully illuminates the world. Disables shadows and fog.",
    Callback = function(Value)
        VisualsManager:SetFullbright(Value)
    end,
})

VisGroup:AddToggle("NightVisionToggle", {
    Text = "Night Vision",
    Default = false,
    Tooltip = "Brightens dark areas with a green-tinted overlay.",
    Callback = function(Value)
        VisualsManager:SetNightVision(Value)
    end,
})

VisGroup:AddSlider("NightVisionIntensity", {
    Text = "Night Vision Strength",
    Default = 85,
    Min = 30,
    Max = 100,
    Rounding = 0,
    Suffix = "%",
    Callback = function(Value)
        VisualsManager:SetNightVision(
            Toggles.NightVisionToggle and Toggles.NightVisionToggle.Value or false,
            Value / 100
        )
    end,
})

VisGroup:AddToggle("XRayToggle", {
    Text = "X-Ray",
    Default = false,
    Tooltip = "Highlights players through walls.",
    Callback = function(Value)
        VisualsManager:SetXRay(Value)
    end,
})

VisGroup:AddDivider()

VisGroup:AddToggle("FogOverrideToggle", {
    Text = "Fog Override",
    Default = false,
    Callback = function(Value)
        if Value then
            VisualsManager:SetFogOverride(
                true,
                Options.FogStartSlider.Value,
                Options.FogEndSlider.Value
            )
        else
            VisualsManager:ResetFog()
        end
    end,
})

VisGroup:AddSlider("FogStartSlider", {
    Text = "Fog Start",
    Default = 0,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        if Toggles.FogOverrideToggle and Toggles.FogOverrideToggle.Value then
            VisualsManager:SetFogOverride(true, Value, Options.FogEndSlider.Value)
        end
    end,
})

VisGroup:AddSlider("FogEndSlider", {
    Text = "Fog End",
    Default = 1000,
    Min = 10,
    Max = 10000,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        if Toggles.FogOverrideToggle and Toggles.FogOverrideToggle.Value then
            VisualsManager:SetFogOverride(true, Options.FogStartSlider.Value, Value)
        end
    end,
})

VisGroup:AddDivider()

VisGroup:AddToggle("FPSToggle", {
    Text = "FPS Counter",
    Default = false,
    Tooltip = "Shows real-time framerate in the top-right corner.",
    Callback = function(Value)
        VisualsManager:SetFPSCounter(Value)
    end,
})

-- Camera addon
local CameraManager = Camera.new(Library, {
    ThirdPersonDistance = 8,
    FreecamSpeed = 50,
    FOV = 90,
})

local CamGroup = Tabs["UI Settings"]:AddRightGroupbox("Camera", "camera")

CamGroup:AddToggle("ThirdPersonToggle", {
    Text = "Third Person",
    Default = false,
    Tooltip = "Switches to a third-person perspective behind your character.",
    Callback = function(Value)
        CameraManager:SetThirdPerson(Value)
    end,
})

CamGroup:AddSlider("ThirdPersonDistance", {
    Text = "Distance",
    Default = 8,
    Min = 1,
    Max = 30,
    Rounding = 1,
    Suffix = " studs",
    Callback = function(Value)
        CameraManager:SetThirdPerson(
            Toggles.ThirdPersonToggle and Toggles.ThirdPersonToggle.Value or false,
            Value
        )
    end,
})

CamGroup:AddDivider()

CamGroup:AddToggle("FOVToggle", {
    Text = "Override FOV",
    Default = false,
    Tooltip = "Changes the camera field of view.",
    Callback = function(Value)
        CameraManager:SetFOV(Options.FOVSlider.Value, Value)
    end,
})

CamGroup:AddSlider("FOVSlider", {
    Text = "FOV",
    Default = 90,
    Min = 20,
    Max = 180,
    Rounding = 0,
    Suffix = "\u{00B0}",
    Callback = function(Value)
        if Toggles.FOVToggle and Toggles.FOVToggle.Value then
            CameraManager:SetFOV(Value, true)
        end
    end,
})

CamGroup:AddDivider()

CamGroup:AddToggle("FreecamToggle", {
    Text = "Freecam",
    Default = false,
    Tooltip = "Detaches the camera from your character. WASD to move, mouse to look, E/Q or Space/Shift for vertical.",
    Callback = function(Value)
        CameraManager:SetFreecam(Value)
    end,
})

CamGroup:AddSlider("FreecamSpeed", {
    Text = "Freecam Speed",
    Default = 50,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Suffix = " studs/s",
    Callback = function(Value)
        CameraManager:SetFreecamSpeed(Value)
    end,
})

CamGroup:AddToggle("CameraSpinToggle", {
    Text = "Camera Spin",
    Default = false,
    Tooltip = "Orbits the camera around your character.",
    Callback = function(Value)
        CameraManager:SetSpin(Value)
    end,
})

CamGroup:AddSlider("CameraSpinSpeed", {
    Text = "Spin Speed",
    Default = 30,
    Min = 5,
    Max = 360,
    Rounding = 0,
    Suffix = "\u{00B0}/s",
    Callback = function(Value)
        CameraManager:SetSpin(
            Toggles.CameraSpinToggle and Toggles.CameraSpinToggle.Value or false,
            Value
        )
    end,
})

-- ServerInfo addon
local ServerInfoManager = ServerInfo.new(Library, {
    ShowServerInfo = true,
    ShowPlayerInfo = true,
})

local ServerGroup = Tabs["UI Settings"]:AddLeftGroupbox("Server Info", "server")

ServerGroup:AddToggle("ServerInfoToggle", {
    Text = "Show Server Info",
    Default = true,
    Tooltip = "Shows server statistics panel (FPS, ping, players, etc.).",
    Callback = function(Value)
        ServerInfoManager:SetVisible(Value)
    end,
})

ServerGroup:AddToggle("ServerInfoServerToggle", {
    Text = "Server Details",
    Default = true,
    Tooltip = "Show server data section in the panel.",
    Callback = function(Value)
        ServerInfoManager:SetShowServerInfo(Value)
    end,
})

ServerGroup:AddToggle("ServerInfoPlayerToggle", {
    Text = "Player Details",
    Default = true,
    Tooltip = "Show player info section in the panel.",
    Callback = function(Value)
        ServerInfoManager:SetShowPlayerInfo(Value)
    end,
})

ServerGroup:AddSlider("ServerInfoUpdateInterval", {
    Text = "Update Interval",
    Default = 0.3,
    Min = 0.1,
    Max = 2,
    Rounding = 1,
    Suffix = "s",
    Callback = function(Value)
        ServerInfoManager:SetUpdateInterval(Value)
    end,
})

-- Protections addon
local ProtectionManager = Protections.new(Library, {})

local ProtGroup = Tabs["UI Settings"]:AddLeftGroupbox("Protections", "shield")

ProtGroup:AddToggle("AntiKickToggle", {
    Text = "Anti Kick",
    Default = false,
    Tooltip = "Blocks kick attempts and optionally rejoins the server.",
    Callback = function(Value)
        ProtectionManager:SetAntiKick(
            Value,
            Toggles.AntiKickRejoinToggle and Toggles.AntiKickRejoinToggle.Value or false
        )
    end,
})

ProtGroup:AddToggle("AntiKickRejoinToggle", {
    Text = "Auto Rejoin on Kick",
    Default = true,
    Tooltip = "Automatically rejoins the server if kicked.",
    Callback = function(Value)
        if Toggles.AntiKickToggle and Toggles.AntiKickToggle.Value then
            ProtectionManager:SetAntiKick(true, Value)
        end
    end,
})

ProtGroup:AddDivider()

ProtGroup:AddToggle("AntiCrashToggle", {
    Text = "Anti Crash",
    Default = false,
    Tooltip = "Filters out crash exploits: massive parts, sounds, meshes, and particles.",
    Callback = function(Value)
        ProtectionManager:SetAntiCrash(Value)
    end,
})

ProtGroup:AddToggle("AntiIdleToggle", {
    Text = "Anti Idle",
    Default = false,
    Tooltip = "Prevents auto-kick for being idle by simulating small movements.",
    Callback = function(Value)
        ProtectionManager:SetAntiIdle(Value)
    end,
})

ProtGroup:AddSlider("AntiIdleInterval", {
    Text = "Idle Interval",
    Default = 30,
    Min = 10,
    Max = 120,
    Rounding = 0,
    Suffix = "s",
    Callback = function(Value)
        ProtectionManager:SetAntiIdle(
            Toggles.AntiIdleToggle and Toggles.AntiIdleToggle.Value or false,
            Value
        )
    end,
})

ProtGroup:AddDivider()

ProtGroup:AddToggle("AntiLagToggle", {
    Text = "Anti Lag",
    Default = false,
    Tooltip = "Lowers graphics quality and disables effects for better performance.",
    Callback = function(Value)
        ProtectionManager:SetAntiLag(Value)
    end,
})

ProtGroup:AddDropdown("AntiLagGraphicsLevel", {
    Text = "Graphics Level",
    Values = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" },
    Default = "1",
    Callback = function(Value)
        local Level = tonumber(Value)
        ProtectionManager:SetAntiLagGraphicsLevel(Level)
        if Toggles.AntiLagToggle and Toggles.AntiLagToggle.Value then
            ProtectionManager:SetAntiLag(true, Level)
        end
    end,
})

-- QoL addon
local QoLManager = QoL.new(Library, {})

local QoLGroup = Tabs["UI Settings"]:AddLeftGroupbox("Misc / QoL", "cube")

QoLGroup:AddButton({
    Text = "Rejoin Server",
    Tooltip = "Leaves and rejoins the current server.",
    Callback = function()
        QoLManager:RejoinServer()
    end,
})

QoLGroup:AddButton({
    Text = "Copy Server Link",
    Tooltip = "Copies the current server link to clipboard.",
    Callback = function()
        local Link = QoLManager:CopyServerLink()
        Library:Notify({ Description = "Server link copied:\n" .. Link, Time = 5 })
    end,
})

QoLGroup:AddButton({
    Text = "Server Hop",
    Tooltip = "Teleports to a new random server of this game.",
    Callback = function()
        QoLManager:ServerHop()
    end,
})

QoLGroup:AddDivider()

QoLGroup:AddToggle("ItemEspToggle", {
    Text = "Item ESP",
    Default = false,
    Tooltip = "Highlights dropped items within range.",
    Callback = function(Value)
        QoLManager:SetItemEsp(Value)
    end,
})

QoLGroup:AddSlider("ItemEspRange", {
    Text = "Item ESP Range",
    Default = 100,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        QoLManager:SetItemEspRange(Value)
    end,
})

QoLGroup:AddToggle("AutoCollectToggle", {
    Text = "Auto Collect",
    Default = false,
    Tooltip = "Automatically walks to nearby collectible items.",
    Callback = function(Value)
        QoLManager:SetAutoCollect(Value)
    end,
})

QoLGroup:AddSlider("AutoCollectRange", {
    Text = "Collect Range",
    Default = 20,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        QoLManager:SetAutoCollectRange(Value)
    end,
})

QoLGroup:AddDivider()

QoLGroup:AddToggle("AntiVoidToggle", {
    Text = "Anti Void",
    Default = false,
    Tooltip = "Teleports you back above Y=-50 if you fall into the void.",
    Callback = function(Value)
        QoLManager:SetAntiVoid(Value)
    end,
})

QoLGroup:AddSlider("AntiVoidY", {
    Text = "Void Y Level",
    Default = -50,
    Min = -500,
    Max = 0,
    Rounding = 0,
    Callback = function(Value)
        QoLManager:SetAntiVoidY(Value)
    end,
})

QoLGroup:AddToggle("AutoClickToggle", {
    Text = "Auto Click",
    Default = false,
    Tooltip = "Automatically clicks with your held tool.",
    Callback = function(Value)
        QoLManager:SetAutoClick(Value)
    end,
})

QoLGroup:AddSlider("AutoClickInterval", {
    Text = "Click Interval",
    Default = 0.1,
    Min = 0.02,
    Max = 1,
    Rounding = 2,
    Suffix = "s",
    Callback = function(Value)
        QoLManager:SetAutoClickInterval(Value)
    end,
})

QoLGroup:AddDivider()

QoLGroup:AddSlider("QoLWalkSpeed", {
    Text = "WalkSpeed",
    Default = 16,
    Min = 1,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        QoLManager:SetCharacterWalkSpeed(Value)
    end,
})

QoLGroup:AddSlider("QoLJumpPower", {
    Text = "Jump Power",
    Default = 50,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        QoLManager:SetCharacterJumpPower(Value)
    end,
})

QoLGroup:AddButton({
    Text = "Reset WalkSpeed / Jump",
    Tooltip = "Resets WalkSpeed to 16 and Jump Power to 50.",
    Callback = function()
        QoLManager:ResetCharacterModifiers()
    end,
})

-- UI Utilities addon
local UIManager = UIUtilities.new(Library, {
    Watermark = {
        Title = "Cyan Hub",
        ShowFPS = true,
        ShowPing = true,
        ShowPlayers = true,
        ShowTime = true,
    },
    ColorPalette = {
        Visible = false,
    },
})

local UIGroup = Tabs["UI Settings"]:AddLeftGroupbox("UI Utilities", "palette")

UIGroup:AddToggle("WatermarkToggle", {
    Text = "Watermark",
    Default = true,
    Tooltip = "Shows an on-screen watermark with FPS, ping, and player info.",
    Callback = function(Value)
        UIManager:SetWatermarkVisible(Value)
    end,
})

UIGroup:AddToggle("WatermarkFPS", {
    Text = "Show FPS",
    Default = true,
    Callback = function(Value)
        UIManager:SetWatermarkOption("FPS", Value)
    end,
})

UIGroup:AddToggle("WatermarkPing", {
    Text = "Show Ping",
    Default = true,
    Callback = function(Value)
        UIManager:SetWatermarkOption("Ping", Value)
    end,
})

UIGroup:AddToggle("WatermarkPlayers", {
    Text = "Show Players",
    Default = true,
    Callback = function(Value)
        UIManager:SetWatermarkOption("Players", Value)
    end,
})

UIGroup:AddToggle("WatermarkTime", {
    Text = "Show Time",
    Default = true,
    Callback = function(Value)
        UIManager:SetWatermarkOption("Time", Value)
    end,
})

UIGroup:AddDivider()

UIGroup:AddToggle("PaletteToggle", {
    Text = "Color Palette",
    Default = false,
    Tooltip = "Shows a palette of preset colors. Click to copy RGB to clipboard.",
    Callback = function(Value)
        UIManager:SetPaletteVisible(Value)
    end,
})

UIGroup:AddDivider()

UIGroup:AddLabel("Notification Presets")
UIGroup:AddButton({
    Text = "Test Success",
    Callback = function()
        UIManager:NotifySuccess("Operation completed successfully.")
    end,
})
UIGroup:AddButton({
    Text = "Test Error",
    Callback = function()
        UIManager:NotifyError("Something went wrong.")
    end,
})
UIGroup:AddButton({
    Text = "Test Info",
    Callback = function()
        UIManager:NotifyInfo("Here is some information.")
    end,
})
UIGroup:AddButton({
    Text = "Test Warning",
    Callback = function()
        UIManager:NotifyWarning("This is a warning message.")
    end,
})

-- Player add-on: teleport utilities + best-effort God Mode.
local PlayerManager = Player.new(Library, {})

local PlayerGroup = Tabs["UI Settings"]:AddLeftGroupbox("Player", "user")

local PlayerService = game:GetService("Players")

local TeleportDropdown = PlayerGroup:AddDropdown("TeleportTarget", {
    Text = "Teleport Target",
    Values = (function()
        local Names = {}
        for _, Plr in PlayerService:GetPlayers() do
            if Plr ~= PlayerService.LocalPlayer then
                table.insert(Names, Plr.Name)
            end
        end
        return Names
    end)(),
    Default = nil,
    AllowNull = true,
})

-- Keep the target list live as players join and leave.
local function RefreshTeleportTargets()
    local Names = {}
    for _, Plr in PlayerService:GetPlayers() do
        if Plr ~= PlayerService.LocalPlayer then
            table.insert(Names, Plr.Name)
        end
    end
    TeleportDropdown:SetValues(Names)
end

Library:GiveSignal(PlayerService.PlayerAdded:Connect(RefreshTeleportTargets))
Library:GiveSignal(PlayerService.PlayerRemoving:Connect(RefreshTeleportTargets))

PlayerGroup:AddButton({
    Text = "Refresh Player List",
    Callback = RefreshTeleportTargets,
})

PlayerGroup:AddButton({
    Text = "Teleport to Player",
    Callback = function()
        PlayerManager:TeleportToPlayer(Options.TeleportTarget.Value)
    end,
})

PlayerGroup:AddButton({
    Text = "Teleport to Mouse",
    Callback = function()
        PlayerManager:TeleportToMouse()
    end,
})

PlayerGroup:AddToggle("GodMode", {
    Text = "God Mode",
    Default = false,
    Tooltip = "Best-effort health lock; may not work in games with custom health systems.",
    Callback = function(Value)
        PlayerManager:SetGodMode(Value)
    end,
})

-- Weapon Mods add-on (best-effort, game-dependent).
local WeaponModsManager = WeaponMods.new(Library, {})

local WeaponGroup = Tabs["UI Settings"]:AddRightGroupbox("Weapon Mods", "swords")

WeaponGroup:AddToggle("NoRecoil", {
    Text = "No Recoil",
    Default = false,
    Callback = function(Value)
        WeaponModsManager:Set("NoRecoil", Value)
    end,
})

WeaponGroup:AddToggle("NoSpread", {
    Text = "No Spread",
    Default = false,
    Callback = function(Value)
        WeaponModsManager:Set("NoSpread", Value)
    end,
})

WeaponGroup:AddToggle("InfiniteAmmo", {
    Text = "Infinite Ammo",
    Default = false,
    Callback = function(Value)
        WeaponModsManager:Set("InfiniteAmmo", Value)
    end,
})

WeaponGroup:AddToggle("RapidFire", {
    Text = "Rapid Fire",
    Default = false,
    Callback = function(Value)
        WeaponModsManager:Set("RapidFire", Value)
    end,
})

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place") -- if the game has multiple places inside of it (for example: DOORS)
-- you can use this to save configs for those places separately
-- The path in this script would be: MyScriptHub/specific-game/settings/specific-place
-- [ This is optional ]

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs["UI Settings"])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs["UI Settings"])

-- Launch with the polished professional palette (safe: ignored if unavailable).
pcall(ThemeManager.ApplyTheme, ThemeManager, "Cyan Pro")

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

