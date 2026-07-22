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
    return if CurrentSettingsPath == false then false else string.format("%s/%s.json", CurrentSettingsPath, ConfigName)
end

local function DoesConfigExist(ConfigName: string): boolean
    local ConfigPath = GetConfigPath(ConfigName)
    return if ConfigPath == false then false else SafeIsFile(ConfigPath)
end

local function GetAutoloadPath(): false | string
    local CurrentSettingsPath = GetCurrentSettingsPath()
    return if CurrentSettingsPath == false then false else string.format("%s/autoload.txt", CurrentSettingsPath)
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
        if typeof(Option) ~= "table" or typeof(Option.type) ~= "string" or typeof(Option.idx) ~= "string" then
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
                Notify(string.format("Skipped invalid saved setting %q: %s", Option.idx, tostring(ErrorMessage)))
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
                "Config rename was cancelled because autoload could not be updated: " .. tostring(AutoloadError)
        end
    end

    local SuccessDelete, DeleteError = TryFileSystemCall(delfile, CurrentPath)
    if not SuccessDelete then
        return false, "Renamed config was created, but the original could not be removed: " .. tostring(DeleteError)
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
    if not IsValidConfigName(AutoloadConfigName) or string.lower(AutoloadConfigName) == "autoload" then
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
        ConfigurationBox:AddLabel("Configuration persistence is unavailable: " .. tostring(SupportError), true)
        return ConfigurationBox
    end

    local ConfigNameInput, ConfigList, AutoloadConfigLabel
    local function RefreshList()
        ConfigList:SetValues(SaveManager:RefreshConfigList())
        ConfigList:SetValue(nil)
    end

    local function RefreshAutoloadConfigLabel()
        local AutoloadConfigName, _Success, _ErrorMessage = SaveManager:GetAutoloadConfig()

        AutoloadConfigLabel:SetText(string.format("Current autoload config: %s", AutoloadConfigName))
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
            SaveManager.Library:Notify("Config names cannot be empty, reserved, or contain path characters.")
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

                SaveManager.Library:Notify(string.format("Successfully created config %q", ConfigName))
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
                SaveManager.Library:Notify(string.format("Failed to load config %q: %s", ConfigName, ErrorMessage))
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
                            string.format("Failed to overwrite config %q: %s", ConfigName, ErrorMessage)
                        )
                        return
                    end

                    SaveManager.Library:Notify(string.format("Successfully overwrote config %q", ConfigName))
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
                SaveManager.Library:Notify(string.format("Failed to rename config: %s", tostring(ErrorMessage)))
                return
            end

            SaveManager.Library:Notify(string.format("Renamed config %q to %q", CurrentName, NewName))
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
                string.format("Are you sure you want to delete %q? This cannot be undone.", ConfigName),

                "Delete",
                function()
                    local Success, ErrorMessage = SaveManager:Delete(ConfigName)
                    if not Success then
                        SaveManager.Library:Notify(
                            string.format("Failed to delete config %q: %s", ConfigName, ErrorMessage)
                        )
                        return
                    end

                    SaveManager.Library:Notify(string.format("Successfully deleted config %q", ConfigName))
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

            SaveManager.Library:Notify(string.format("Successfully set autoload config to %q", ConfigName))
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
                        SaveManager.Library:Notify(string.format("Failed to reset autoload config: %s", ErrorMessage))
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
        SaveManager.Library.Options.SaveManager_ConfigName, SaveManager.Library.Options.SaveManager_ConfigList

    --// Refresh
    RefreshAutoloadConfigLabel()
    SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })

    return ConfigurationBox
end

SaveManager:BuildFolderTree()
return SaveManager
