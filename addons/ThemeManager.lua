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
    Localization = nil,
    LocalizationPrefix = "theme",

    Folder = "CyanLibSettings",

    AppliedToTab = false,
    DefaultThemeName = nil,

    BuiltInThemes = {
        -- Stable Cyan palette. Unlike "Default", this is never changed by SetDefaultTheme.
        ["Cyan"] = {
            0,
            {
                FontColor = "f0fdff",
                MainColor = "0f263b",
                AccentColor = "22d3ee",
                BackgroundColor = "071a2b",
                OutlineColor = "164e63",
                BackgroundImage = "",
            },
        },
        ["Default"] = {
            1,
            {
                FontColor = "f0fdff",
                MainColor = "0f263b",
                AccentColor = "22d3ee",
                BackgroundColor = "071a2b",
                OutlineColor = "164e63",
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
    },
}

function ThemeManager:SetLibrary(Library)
    ThemeManager.Library = Library
end

-- Optional adapter for Cyan.Localization or a compatible translator. Configure it before building manager UI.
function ThemeManager:SetLocalization(Localizer: any, Prefix: string?)
    assert(
        Localizer == nil or (typeof(Localizer) == "table" and typeof(Localizer.T) == "function"),
        "Localization adapter must provide T(key, parameters)"
    )
    assert(Prefix == nil or typeof(Prefix) == "string", "Localization prefix must be a string or nil")

    ThemeManager.Localization = Localizer
    ThemeManager.LocalizationPrefix = Prefix or "theme"
end

local function Translate(Key: string, Fallback: string, Parameters: { [string]: any }?): string
    local Localizer = ThemeManager.Localization
    if not Localizer then
        return Fallback
    end

    local FullKey = ThemeManager.LocalizationPrefix .. "." .. Key
    local Success, Result = pcall(Localizer.T, Localizer, FullKey, Parameters)
    if Success and typeof(Result) == "string" and Result ~= FullKey then
        return Result
    end

    return Fallback
end

local function BindText(Element: any, Key: string): any
    local Localizer = ThemeManager.Localization
    if not Localizer or typeof(Localizer.BindText) ~= "function" then
        return Element
    end

    local FullKey = ThemeManager.LocalizationPrefix .. "." .. Key
    local Success, Result = pcall(Localizer.T, Localizer, FullKey)
    if Success and Result ~= FullKey then
        pcall(Localizer.BindText, Localizer, Element, FullKey)
    end

    return Element
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
    return if CurrentThemesPath == false then false else string.format("%s/%s.json", CurrentThemesPath, ThemeName)
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
    return if CurrentThemesPath == false then false else string.format("%s/default.txt", CurrentThemesPath)
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
        FontFace = if FontOption and typeof(FontOption.Value) == "string" then FontOption.Value else "Code",
        BackgroundImage = if BackgroundOption and typeof(BackgroundOption.Value) == "string"
            then BackgroundOption.Value
            else (typeof(Library.Scheme.BackgroundImage) == "string" and Library.Scheme.BackgroundImage or ""),
    }

    for _, SchemeIndex in SchemeIndexes do
        local Option = Library.Options and Library.Options[SchemeIndex]
        local Color = if Option and typeof(Option.Value) == "Color3" then Option.Value else Library.Scheme[SchemeIndex]
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
    assert(not ThemeManager.AppliedToTab, "Cannot set default theme after applying ThemeManager to a tab!")
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
            Library:Notify(string.format("Failed to apply default theme: %s", tostring(FetchErrorMessage)))
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
        Library:Notify(string.format("Failed to apply default theme: %s", tostring(LoadErrorMessage)))
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
                Title = Translate("cancel", "Cancel"),
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
        Themesbox:AddLabel(
            Translate("persistence_unavailable", "Theme persistence is unavailable: " .. tostring(SupportError), {
                reason = tostring(SupportError),
            }),
            true
        )
        return Themesbox
    end

    local BuiltInThemesNames = {}
    for Name, _ThemeData in ThemeManager.BuiltInThemes do
        table.insert(BuiltInThemesNames, Name)
    end

    local CustomThemeList, CustomThemeName, ThemeList, FontFace, BackgroundImage, DefaultThemeLabel
    local function AddButton(Key: string, Fallback: string, Callback: () -> ())
        return BindText(Themesbox:AddButton(Translate(Key, Fallback), Callback), Key)
    end
    local function RefreshList()
        CustomThemeList:SetValues(ThemeManager:ReloadCustomThemes())
        CustomThemeList:SetValue(nil)

        ThemeList:SetValues(BuiltInThemesNames)
    end

    local function RefreshDefaultThemeLabel()
        local DefaultThemeName, _Success, _ErrorMessage = ThemeManager:GetDefaultTheme()

        DefaultThemeLabel:SetText(
            Translate("current_default", string.format("Current default theme: %s", DefaultThemeName), {
                name = DefaultThemeName,
            })
        )
        if CustomThemeList and not CustomThemeList.Destroyed then
            RefreshList()
        end
    end

    table.sort(BuiltInThemesNames, function(IndexA, IndexB)
        return ThemeManager.BuiltInThemes[IndexA][1] < ThemeManager.BuiltInThemes[IndexB][1]
    end)

    local function CreateColorOption(Key: string, Text: string, SchemeIndex: string)
        local Label = Themesbox:AddLabel(Translate(Key, Text))
        BindText(Label, Key)
        Label:AddColorPicker(SchemeIndex, {
            Default = ThemeManager.Library.Scheme[SchemeIndex],
        })

        return ThemeManager.Library.Options[SchemeIndex]
    end

    local BackgroundColor = CreateColorOption("background_color", "Background color", "BackgroundColor")
    local MainColor = CreateColorOption("main_color", "Main color", "MainColor")
    local AccentColor = CreateColorOption("accent_color", "Accent color", "AccentColor")
    local OutlineColor = CreateColorOption("outline_color", "Outline color", "OutlineColor")
    local FontColor = CreateColorOption("font_color", "Font color", "FontColor")

    BindText(
        Themesbox:AddDropdown("FontFace", {
            Text = Translate("font_face", "Font Face"),
            Default = "Code",

            Values = { "BuilderSans", "Code", "Fantasy", "Gotham", "Jura", "Roboto", "RobotoMono", "SourceSans" },
            AllowNull = false,
            Multi = false,
        }),
        "font_face"
    )

    BindText(
        Themesbox:AddInput("BackgroundImage", {
            Text = Translate("background_image", "Background Image"),

            Default = "",
            Finished = true,
            ClearTextOnFocus = false,
            ClearTextOnBlur = false,
        }),
        "background_image"
    )

    Themesbox:AddDivider()

    BindText(
        Themesbox:AddDropdown("ThemeManager_ThemeList", {
            Text = Translate("theme_list", "Theme list"),

            Values = BuiltInThemesNames,
            AllowNull = true,
            Multi = false,

            FormatDisplayValue = function(Value: any)
                if Value ~= "Default" and Value == ThemeManager.DefaultThemeName then
                    return Translate("default_suffix", string.format("%s (default)", Value), { name = Value })
                end

                return Value
            end,
            FormatListValue = function(Value: any)
                if Value ~= "Default" and Value == ThemeManager.DefaultThemeName then
                    return Translate("default_suffix", string.format("%s (default)", Value), { name = Value })
                end

                return Value
            end,
        }),
        "theme_list"
    )

    AddButton("set_default", "Set as default", function()
        local ThemeName = ThemeList.Value
        local Success, ErrorMessage = ThemeManager:SaveDefault(ThemeName)
        if not Success then
            ThemeManager.Library:Notify(string.format("Failed to set default theme: %s", tostring(ErrorMessage)))
            return
        end

        ThemeManager.Library:Notify(string.format("Successfully set default theme to %q", ThemeName))
        RefreshDefaultThemeLabel()
    end)

    Themesbox:AddDivider()

    CustomThemeName = BindText(
        Themesbox:AddInput("ThemeManager_CustomThemeName", {
            Text = Translate("custom_theme_name", "Custom theme name"),
        }),
        "custom_theme_name"
    )

    AddButton("create_theme", "Create theme", function()
        local Name = CustomThemeName.Value
        if not IsValidThemeName(Name) or string.lower(Name) == "default" then
            ThemeManager.Library:Notify("Theme names cannot be empty, reserved, or contain path characters.")
            return
        end

        ShowDialog(
            function(): boolean
                return ThemeManager:GetCustomTheme(Name) ~= nil
            end,

            "ThemeManager_CreateTheme",
            Translate("theme_exists", "Theme already exists"),
            Translate(
                "theme_exists_description",
                string.format(
                    "A custom theme named %q already exists. Overwriting it will replace it with your current colors.",
                    Name
                ),
                { name = Name }
            ),

            Translate("overwrite", "Overwrite"),
            function()
                local Success, ErrorMessage = ThemeManager:SaveCustomTheme(Name)
                if not Success then
                    ThemeManager.Library:Notify(string.format("Failed to create theme %q: %s", Name, ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify(string.format("Successfully created theme %q", Name))
                RefreshList()
            end
        )
    end)

    Themesbox:AddDivider()

    CustomThemeList = BindText(
        Themesbox:AddDropdown("ThemeManager_CustomThemeList", {
            Text = Translate("custom_themes", "Custom themes"),

            Values = ThemeManager:ReloadCustomThemes(),
            AllowNull = true,
            Multi = false,

            FormatDisplayValue = function(Value: any)
                if Value == ThemeManager.DefaultThemeName then
                    return Translate("default_suffix", string.format("%s (default)", Value), { name = Value })
                end

                return Value
            end,
            FormatListValue = function(Value: any)
                if Value == ThemeManager.DefaultThemeName then
                    return Translate("default_suffix", string.format("%s (default)", Value), { name = Value })
                end

                return Value
            end,
        }),
        "custom_themes"
    )

    AddButton("load_theme", "Load theme", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("Please select a theme first.")
            return
        end

        local Success, ErrorMessage = ThemeManager:ApplyTheme(Name)
        if not Success then
            ThemeManager.Library:Notify(string.format("Failed to load theme %q: %s", Name, tostring(ErrorMessage)))
            return
        end

        ThemeManager.Library:Notify(string.format("Successfully loaded theme %q", Name))
    end)

    AddButton("overwrite_theme", "Overwrite theme", function()
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
            Translate("overwrite_theme_title", "Overwrite theme"),
            Translate(
                "overwrite_theme_description",
                string.format(
                    "Are you sure you want to overwrite %q with your current colors? This cannot be undone.",
                    Name
                ),
                { name = Name }
            ),

            Translate("overwrite", "Overwrite"),
            function()
                local Success, ErrorMessage = ThemeManager:SaveCustomTheme(Name)
                if not Success then
                    ThemeManager.Library:Notify(
                        string.format("Failed to overwrite theme %q: %s", Name, tostring(ErrorMessage))
                    )
                    return
                end

                ThemeManager.Library:Notify(string.format("Successfully overwrote theme %q", Name))
            end
        )
    end)

    AddButton("delete_theme", "Delete theme", function()
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
            Translate("delete_theme_title", "Delete theme"),
            Translate(
                "delete_theme_description",
                string.format("Are you sure you want to delete %q? This cannot be undone.", Name),
                { name = Name }
            ),

            Translate("delete", "Delete"),
            function()
                local Success, ErrorMessage = ThemeManager:Delete(Name)
                if not Success then
                    ThemeManager.Library:Notify(string.format("Failed to delete theme: %s", ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify(string.format("Successfully deleted theme %q", Name))
                RefreshDefaultThemeLabel()
            end
        )
    end)

    AddButton("refresh_list", "Refresh list", RefreshList)

    AddButton("set_default", "Set as default", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("Please select a theme first.")
            return
        end

        local Success, ErrorMessage = ThemeManager:SaveDefault(Name)
        if not Success then
            ThemeManager.Library:Notify(string.format("Failed to set default theme: %s", tostring(ErrorMessage)))
            return
        end

        ThemeManager.Library:Notify(string.format("Successfully set default theme to %q", Name))
        RefreshDefaultThemeLabel()
    end)

    AddButton("reset_default", "Reset default", function()
        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_ResetDefault",
            Translate("reset_default_title", "Reset default theme"),
            Translate(
                "reset_default_description",
                "Are you sure you want to clear the default theme? The library will revert to its built-in default on next load."
            ),

            Translate("reset", "Reset"),
            function()
                local Success, ErrorMessage = ThemeManager:DeleteDefaultTheme()
                if not Success then
                    ThemeManager.Library:Notify(string.format("Failed to reset default theme: %s", ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify("Successfully reset default theme.")
                RefreshDefaultThemeLabel()
            end
        )
    end)

    DefaultThemeLabel =
        Themesbox:AddLabel(Translate("current_default", "Current default theme: ...", { name = "..." }), true)

    --// Set Variables
    CustomThemeList, CustomThemeName, ThemeList, FontFace, BackgroundImage =
        ThemeManager.Library.Options.ThemeManager_CustomThemeList,
        ThemeManager.Library.Options.ThemeManager_CustomThemeName,
        ThemeManager.Library.Options.ThemeManager_ThemeList,
        ThemeManager.Library.Options.FontFace,
        ThemeManager.Library.Options.BackgroundImage

    if ThemeManager.Localization and typeof(ThemeManager.Localization.OnChanged) == "function" then
        ThemeManager.Localization:OnChanged(function()
            if DefaultThemeLabel and not DefaultThemeLabel.Destroyed then
                RefreshDefaultThemeLabel()
            end
        end)
    end

    --// Handlers
    ThemeList:OnChanged(function()
        local Success, ErrorMessage = ThemeManager:ApplyTheme(ThemeList.Value)
        if not Success then
            ThemeManager.Library:Notify(string.format("Failed to apply theme: %s", tostring(ErrorMessage)))
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
    local Groupbox = Tab:AddLeftGroupbox(Translate("group", "Themes"), IconName or "paintbrush")
    BindText(Groupbox, "group")
    return Groupbox
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
