# Localization

`addons/Localization.lua` provides a lightweight translation system for Cyan applications. It has no network dependency and works with standard text instances or Cyan objects exposing `SetText()`.

## Basic use

```luau
local I18n = Cyan.Localization.new({
    DefaultLocale = "en",
    Locales = {
        en = {
            ["menu.title"] = "Settings",
            ["welcome"] = "Welcome, {name}",
        },
        ar = {
            ["menu.title"] = "الإعدادات",
            ["welcome"] = "مرحبًا، {name}",
        },
    },
})

print(I18n:T("welcome", { name = "Ehab" }))
I18n:SetLocale("ar")
```

Translations fall back to the default locale, then to the key itself when a translation is missing.

## Bind UI text

```luau
local Binding = I18n:BindText(SomeTextLabel, "menu.title")

-- Changes every active binding.
I18n:SetLocale("ar")

Binding:Disconnect()
```

`BindText` supports `TextLabel`, `TextButton`, `TextBox`, and Cyan elements with a `SetText()` method, including labels, buttons, toggles, sliders, dropdowns, tabs, key tabs, and groupboxes. For Cyan controls that expose a text instance, bindings also apply right-to-left alignment for Arabic, Hebrew, Persian, and Urdu, then restore the original alignment for left-to-right locales. Custom RTL locales can be configured through `RightToLeftLocales`.

For example, keep a tab and groupbox title synchronized with the selected locale:

```luau
local SettingsTab = Window:AddTab("Settings", "settings")
local Appearance = SettingsTab:AddLeftGroupbox("Appearance")

I18n:BindText(SettingsTab, "tab.settings")
I18n:BindText(Appearance, "group.appearance")
```

## Built-in Cyan text

`Library:SetLocalization(I18n, "library")` localizes Cyan's reusable system text and refreshes existing supported controls when the locale changes. The default keys are `library.SearchPlaceholder`, `library.CommandSearchPlaceholder`, `library.NoCommandsFound`, `library.DropdownSearchPlaceholder`, `library.KeyPlaceholder`, `library.KeySubmit`, `library.KeyVerified`, and `library.DoubleClickConfirmation`. Mobile controls also use `library.MobileMenuLabel`, `library.MobileMenuTooltip`, `library.MobileLockLabel`, `library.MobileUnlockLabel`, `library.MobileLockTooltip`, `library.MobileLockActionTitle`, `library.MobileMenuLocked`, and `library.MobileMenuUnlocked`.

```luau
Library:SetLocalization(I18n, "library")

-- Or override one string without a dictionary.
Library:SetText("NoCommandsFound", "No matching actions")
```

## Persistence manager panels

`SaveManager` and `ThemeManager` can reuse the same localization instance for their generated controls. Configure the adapter **before** building their UI panels; the ordinary labels update live when the locale changes.

```luau
Cyan.SaveManager:SetLocalization(I18n, "save")
Cyan.ThemeManager:SetLocalization(I18n, "theme")

Cyan.SaveManager:BuildConfigSection(SettingsTab)
Cyan.ThemeManager:ApplyToTab(SettingsTab)
```

Add keys such as `save.config_name`, `save.load_config`, `theme.background_color`, and `theme.load_theme` to the dictionaries you pass to `I18n`. If a key is omitted, the manager safely retains its English fallback text.

## Dynamic parameters

Pass a function when parameters change over time:

```luau
I18n:BindText(Label, "welcome", function()
    return { name = Player.DisplayName }
end)
```

Call `Binding:Update()` after the underlying data changes.

## Lifecycle

Use `I18n:OnChanged(callback)` to react to locale changes. Call `I18n:Destroy()` when the localization instance is no longer needed.
