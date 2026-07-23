-- Cyan feature showcase.
-- For a Wally/Roblox project, prefer `require(Packages.Cyan)` as documented in README.md.
-- This direct loader is retained for environments that explicitly support game:HttpGet and loadstring.

local repo = "https://raw.githubusercontent.com/EhabYT/cyan/main/"

-- Load a Cyan module.
-- 1) Prefer the local sibling file so a cloned/checked-out repo runs fully offline
--    and uses the exact code you have (including ungated addon wiring).
-- 2) Fall back to the published `main` branch over HTTP for pasted single-file loaders.
-- A failed local read never breaks startup: we always fall back to the remote copy.
local function LoadModule(RelativePath)
    if typeof(readfile) == "function" then
        local ok, content = pcall(readfile, RelativePath)
        if ok and type(content) == "string" and #content > 0 then
            local okCompile, chunk = pcall(loadstring, content)
            if okCompile and chunk then
                local okRun, module = pcall(chunk)
                if okRun then
                    return module
                end
            end
        end
    end
    return loadstring(game:HttpGet(repo .. RelativePath))()
end

local Library = LoadModule("Library.lua")
local ThemeManager = LoadModule("addons/ThemeManager.lua")
local SaveManager = LoadModule("addons/SaveManager.lua")
local KeySystem = LoadModule("addons/KeySystem.lua")
local HUD = LoadModule("addons/HUD.lua")
local ESP = LoadModule("addons/ESP.lua")
local Radar = LoadModule("addons/Radar.lua")
local Movement = LoadModule("addons/Movement.lua")
local Visuals = LoadModule("addons/Visuals.lua")
local Camera = LoadModule("addons/Camera.lua")
local Protections = LoadModule("addons/Protections.lua")
local ServerInfo = LoadModule("addons/ServerInfo.lua")
local QoL = LoadModule("addons/QoL.lua")
local UIUtilities = LoadModule("addons/UIUtilities.lua")
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
