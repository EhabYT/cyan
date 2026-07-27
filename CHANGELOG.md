## 26.07.2026 — Cyan 26.7.37

```diff
[features]
+ Added localized Quick Actions profiles and a Help panel to UI Settings.
```

## 26.07.2026 — Cyan 26.7.36

```diff
[fixes]
+ Mobile sliders now track touch movement through InputChanged and stop cleanly on touch end.
```

## 26.07.2026 — Cyan 26.7.35

```diff
[fixes]
+ Fixed touch slider dragging to use the active touch position, prevent duplicate drags, and restore original scroll state.
```

## 26.07.2026 — Cyan 26.7.34

```diff
[features]
+ Added a localized Restore UI defaults action that resets visual, accessibility, mobile, and layout preferences.
```

## 26.07.2026 — Cyan 26.7.33

```diff
[features]
+ Personalized the welcome loading message with the local player display name.
```

## 26.07.2026 — Cyan 26.7.32

```diff
[features]
+ Enriched the CyanLogo welcome flow with staged messages, progress, and a desktop feature sidebar.
```

## 26.07.2026 — Cyan 26.7.31

```diff
[features]
+ The example detects a supported Roblox system locale before the welcome screen, preselecting its language for the loading and login experience.
```

## 26.07.2026 — Cyan 26.7.30

```diff
[features]
+ Added a logo-branded welcome loading flow before the key-gated example menu appears.
```

## 26.07.2026 — Cyan 26.7.29

```diff
[fixes]
+ Cleaned stale built-in text bindings and localization callbacks when UI elements or the library unload.
```

## 26.07.2026 — Cyan 26.7.28

```diff
[fixes]
+ Rapid Open/Close requests during window fade animations are queued and applied after the current transition, preventing lost taps.
```

## 26.07.2026 — Cyan 26.7.27

```diff
[changes]
+ Refreshed CheckIcon, LoadingIcon, and the Cyan UI showcase asset for the current rounded, localized Liquid Glass interface.
```

## 26.07.2026 — Cyan 26.7.26

```diff
[features]
+ MobileActionPosition can now be supplied in WindowInfo and is updated as the mobile action is dragged, enabling callers to retain a preferred position.
```

## 26.07.2026 — Cyan 26.7.25

```diff
[features]
+ Added Window:GetMobileActionPosition(), SetMobileActionPosition(), and ResetMobileActionPosition().
+ Added a localized Reset mobile action position button to the mobile settings panel.
```

## 26.07.2026 — Cyan 26.7.24

```diff
[features]
+ The CyanLogo mobile menu action can now be dragged to any safe on-screen position.
+ Added MobileActionsDraggable (enabled by default), movement threshold handling, viewport/safe-area bounds, and tap suppression after a drag.
```

## 26.07.2026 — Cyan 26.7.23

```diff
[features]
+ Added selectable فارسی and اردو language packs with automatic right-to-left login alignment.
+ Expanded the pre-login and settings language selectors to eleven available languages.
```

## 26.07.2026 — Cyan 26.7.22

```diff
[features]
+ Added selectable Português, Italiano, and Русский language packs to the login and UI Settings selectors.
+ Expanded translated login, core settings, command palette, mobile controls, and built-in UI text with safe English fallback for optional application strings.
```

## 26.07.2026 — Cyan 26.7.21

```diff
[features]
+ Added selectable Français, Español, and Türkçe language packs to the login and UI Settings selectors.
+ Added French, Spanish, and Turkish translations for the login, core settings, command palette, mobile controls, and built-in Cyan text; optional persistence messages safely fall back to English when not supplied.
```

## 26.07.2026 — Cyan 26.7.20

```diff
[fixes]
+ Opening a new context menu now immediately removes the previous animated menu, preventing dropdown overlap during fast interaction.
+ Main window dragging now clamps to the active viewport, keeping the menu title bar and controls reachable.
+ Window close now immediately removes active menu overlays before the main frame is hidden.
```

## 26.07.2026 — Cyan 26.7.19

```diff
[fixes]
+ Increased Cyan's default corner radius from 4 to 12 for consistently rounded Liquid Glass surfaces.
+ Context-menu scrolling lists now clip their rows, preventing dropdown options from drawing over nearby controls.
+ Closing a window now dismisses active context menus and command palettes, preventing stray overlays from remaining on screen.
```

## 26.07.2026 — Cyan 26.7.18

```diff
[features]
+ KeySystem UI options now support RightToLeft for correctly aligned login prompt, status, and key entry text.
+ The example applies RTL alignment automatically when Arabic is selected before or after login.
```

## 26.07.2026 — Cyan 26.7.17

```diff
[features]
+ Added an always-available language selector to the Key System tab, so players can choose English, German, or Arabic before login.
+ Login and UI Settings language selectors now stay synchronized through a single locale handler.
```

## 26.07.2026 — Cyan 26.7.16

```diff
[changes]
+ Reorganized the example UI Settings into dedicated Menu, Appearance, Accessibility, and Mobile panels.
+ Balanced the settings across both columns, hides mobile-only controls on desktop, and preserved live English, German, and Arabic localization.
```

## 26.07.2026 — Cyan 26.7.15

```diff
[features]
+ Added configurable MobileLockLongPressDuration (0.25–2 seconds, default 0.55).
+ Mobile lock controls now give localized locked/unlocked notification feedback and use the built-in localization dictionary.
```

## 26.07.2026 — Cyan 26.7.14

```diff
[fixes]
+ Mobile lock action state now resets consistently after a normal menu tap, after using Lock/Unlock, or after outside-tap dismissal.
+ Clarified the mobile CyanLogo gesture: tap toggles the menu; press and hold toggles the lock action.
```

## 26.07.2026 — Cyan 26.7.13

```diff
[fixes]
+ The main CyanLogo mobile button now directly opens or closes the menu on consecutive taps.
+ Press-and-hold now shows or hides only the Lock/Unlock action, as intended; the unused Open/Close panel actions were removed.
```

## 26.07.2026 — Cyan 26.7.12

```diff
[features]
+ Mobile action panels now use one persistent primary action that opens or closes the menu on consecutive taps.
+ Press and hold the CyanLogo mobile button to reveal or hide the optional Lock/Unlock action.

[changes]
+ Simplified the mobile action panel and updated its interaction documentation.
```

## 26.07.2026 — Cyan 26.7.11

```diff
[fixes]
+ The key-gated Example now disables deferred AutoShow and opens explicitly after all gates and settings panels are attached.
+ Added a project invariant that prevents the example from regressing to a deferred-only startup path.
```

## 26.07.2026 — Cyan 26.7.10

```diff
[features]
+ Library:SetLocalization(localizer, prefix) now localizes supported Cyan system text through a Cyan.Localization-compatible adapter.
+ Added live built-in text updates for search, command palette search/empty state, searchable dropdowns, key-box placeholder and submit/verified labels, and double-click confirmation text.
+ Added Library:GetText(), SetText(), and BindSystemText() plus key-box text override methods.

[changes]
+ The example now provides English, German, and Arabic translations for built-in Cyan text and refreshes them when the locale changes.
```

## 26.07.2026 — Cyan 26.7.9

```diff
[features]
+ SaveManager and ThemeManager now support SetLocalization(localizer, prefix) with Cyan.Localization-compatible adapters.
+ The generated configuration and theme panels now update their labels, controls, group titles, default/autoload markers, and Cancel actions live in English, German, and Arabic.
+ Confirmation dialogs and manager text safely retain English fallback strings when an application omits a dictionary key.

[changes]
+ Added localization adapter coverage to the persistence add-on smoke test and documented manager panel localization.
```

## 26.07.2026 — Cyan 26.7.8

```diff
[features]
+ Localization bindings now apply RTL text alignment to supported Cyan labels, buttons, toggles, sliders, dropdowns, tabs, key tabs, and groupboxes.
+ Binding a left-to-right locale restores each control's original text alignment.

[changes]
+ Exposed the backing text labels for supported Cyan controls and expanded localization regression invariants.
```

## 26.07.2026 — Cyan 26.7.7

```diff
[features]
+ Added a localized, login-first Cyan settings example in English, German, and Arabic.
+ UI Settings, Key System states, tab/groupbox titles, and command-palette actions now update live when the locale changes.
+ Tabs, key tabs, and groupboxes now expose SetText() for dynamic titles and localization bindings.
+ Command-palette entries now expose SetText(), SetDescription(), SetKeywords(), and SetOrder() for live updates.
+ KeySystem:Attach() now returns a UI binding with UpdateText() and SetStatus() for localized login prompts, statuses, logout text, and reset controls.

[changes]
+ Removed the Main tab and generic control showcase from Example.lua; the protected example now focuses on Cyan settings, themes, and configuration.
+ Refreshed the Cyan Liquid Glass showcase image and aligned README/example documentation with the key-gated settings flow.
+ Added regression coverage for dynamic KeySystem UI text updates and public text-update APIs.
```

## 21.07.2026 — Cyan 26.7.6

```diff
[breaking changes]
! Package identity is now `ehabyt/cyan` and runtime branding is Cyan.
! SaveManager and ThemeManager use `CyanLibSettings` by default. Existing Obsidian folders are not moved automatically; see docs/MIGRATION.md.
! ThemeManager's global export is now `getgenv().CyanThemeManager`.

[features]
+ Window:FocusSearch(): boolean and Window:ClearSearch() provide explicit search control.
+ Ctrl+K focuses visible search; Escape first releases text input, then dismisses transient UI.
+ Library:CloseTransientUI(): boolean closes the active menu or a dialog that allows outside-click dismissal.
+ SaveManager:IsSupported() and ThemeManager:IsSupported() report filesystem capability before persistence work begins.
+ Library.Version identifies the installed Cyan release.
+ Added `KeySystem`, a callback-driven key-entry addon with verifier isolation, state-change hooks, optional cooldowns, attempt limits, lock/reset state, and KeyTab UI binding.
+ Added `Localization`, with dictionaries, locale fallback, parameter interpolation, RTL support, callbacks, and live text bindings.
+ Added reduced-motion preferences plus richer KeyBox controls (clear, focus, status, Enter submit, and reset support).
+ Added a theme-aware, draggable HUD addon with text and progress entries for experience-owned status data.
+ Added a configurable Liquid Glass menu style with clearer translucent Cyan surfaces, brighter moving reflections, animated sheen, accent strokes, optional blur, and Liquid/Crystal/Frosted/Ocean/Aurora/Midnight/Solid presets.
+ Applied the glass treatment to active tabs, dialogs, notifications, input controls, and mobile action buttons, including iPhone-style touch press feedback.
+ Added a searchable command palette with `Window:AddCommand()`, Ctrl+P, and header action support.
+ Added ordered tab navigation APIs plus Ctrl+PageUp/Ctrl+PageDown shortcuts for visible tabs.
+ Added optional mobile swipe navigation between visible tabs with configurable thresholds.
+ Fixed optional glass blur so it cannot re-enable while Liquid Glass is disabled.
+ Fixed sidebar width clamping on narrow mobile viewports, preventing invalid min/max clamp errors.
+ Added the bundled CyanLogo asset and applied it to the example window, default loading screen, and primary mobile open actions.
+ Added header quick actions plus window tab, sidebar, position, centering, and search-visibility controls for richer menu navigation.
+ Changed the default menu palette to Cyan: deep navy surfaces, cyan accents, and high-contrast cyan-white text.
+ Added an immutable built-in `Cyan` preset so the cyan palette is always available after changing the mutable `Default` theme.
+ ThemeManager can now save the current scheme even when its visual settings panel has not been built.
+ SaveManager can now safely rename configurations and migrate an associated autoload setting.
+ KeySystem can now use a server-owned RemoteFunction through `KeySystem.fromRemote()`.
+ KeySystem can now gate protected tabs so the login tab appears first and the full menu unlocks after verification, including optional search hiding and lock/unlock controls.
+ Added `KeySystem:Logout()` to reset the local key UI and return protected tabs to the login state.
- Removed the Example.lua Experience Status panel from the default showcase; the reusable HUD addon remains available for applications that need it.
+ Added explicit `Window:Open()` and `Window:Close()` controls; mobile action buttons now use debounced touch/mouse activation for reliable open/close behavior.
+ Mobile header actions now have larger touch targets, and the example hides desktop-only quick actions on phones.
+ Mobile windows now start with a compact sidebar by default, reclaiming more content space on narrow screens.
+ Added Compact, Balanced, and Expanded mobile layout presets through `Window:SetMobileLayout()`.
+ Mobile windows now fit the safe viewport area, avoiding notches/system bars and refreshing after portrait/landscape or camera viewport changes.
+ Optimized HUD update work by throttling timer and waypoint rendering while retaining accurate FPS measurement.
+ Hardened DPI scale, notification-side, font, and public-search inputs with validation and safe normalization.
+ Fixed window creation assigning `Enum.Font` directly to the `FontFace` scheme; it now uses the validated font conversion path.

[changes]
+ Fixed the Wally entry point to require package-local modules instead of a non-existent `obsidian/` directory.
+ Added pinned Luau, StyLua, and Wally tooling, CI validation, contributor guidance, and migration documentation.
+ The feature showcase now demonstrates the search API and documents the preferred package-local require flow.

[fixes]
+ Persistence managers now validate folder, config, theme, and autoload names before touching the filesystem.
+ Filesystem calls are guarded; missing capabilities, folder-creation failures, malformed config records, and malformed theme data return useful errors rather than throwing.
+ Theme and configuration controls no longer report success when an underlying save/load operation fails.
+ Added standalone smoke coverage for persistence guard rails and invalid-path handling.
+ Removed the stale `Library:UpdateDPI` declaration and added a validation check that public declarations have matching implementations.
+ Asset downloads now reject invalid and unknown asset names, return useful failures, and no longer leave failed custom assets registered.
+ Icon lookup now handles unavailable or malformed icon modules safely; text measurement now has a safe viewport fallback before a camera exists.
```

## 11.07.2026

```diff
[changes]
+ Loading configs now triggers element callbacks even if their value hasn't changed
```

## 09.07.2026

```diff
[changes]
+ Background Image now supports external URLs using getcustomasset
```

## 07.07.2026

```diff
[features]
+ Dropdown.DragSelect, Dropdown:SetDragSelect(Value: boolean) (only works on non-touch devices and Multi dropdowns)
+ Animations.Groupbox, Animations.KeyPicker

[changes]
+ Notification appear and disappear animations are now smooth

[fixes]
+ Fixed Library.ToggleKeybind
```

## 05.07.2026

```diff
[features]
+ Added Animations.ToggleWindow
+ Added Animations.TabSwitch, TabTransitionTime, TabSwipeOffset, TabSwipeFrom (left/right/top/bottom)
+ Added Animations.Dropdown
+ Window:SetAnimations(Animations, TabTransitionTime, TabSwipeOffset, TabSwipeFrom)
+ Added DisableCollapsing to AddLeftGroupbox, AddRightGroupbox

[changes]
+ KeyPickers now allow setting the bind to any modifier key if it was only pressed and not held down

[fixes]
+ Fixed Library.ToggleKeybind not working properly with modifier keys
+ Fixed KeyPickers firing while picking a bind for any KeyPicker
```

## 02.07.2026

```diff
[changes]
+ Save Manager and Theme Manager refactored
+ Save Manager now saves the keybind menu visibility and position
+ Save Manager and Theme Manager now show what theme is the default and what config is autoloaded inside the dropdowns

[fixes]
+ Fixed dialogs buttons breaking with Destructive buttons if ThemeManager:SetDefaultTheme was used
```

## 01.07.2026

```diff
[features]
+ Confirmation dialogs to destructive actions in Save Manager and Theme Manager
+ Groupbox collapsed state now saves in configuration files
```


## 28.06.2026

```diff
[features]
+ Groupbox:SetVisible(Visible: boolean), Groupbox:Show(), Groupbox:Hide()
+ Groupbox:AddTabbox()
+ Collapse Groupbox arrow (disable with DisableCollapsing option)
+ TitleColor, DescriptionColor options for Library:Notify({ ... })
+ Library.Scheme.BackgroundImage and "Background Image" option in Theme Manager
+ Library.Window

[changes]
+ Tabbox:AddTab() now returns Tab and TabStoringIndex
+ Window BackgroundImage can now be set even when it was previously not set during creation

[fixes]
+ Fixed searching restoring hidden elements each time
+ Fixed attempt to index nil with 'Destroy' errors in Dropdown:BuildDropdownList()
+ Fixed rounded corners with Tab buttons inside Tabbox
+ Fixed Tab button spacing when it doesn't have name
```

## 26.06.2026

```diff
[features]
+ :Destroy() function for every element
+ Volume option for Library:Notify()
+ KeyPicker for buttons (Only works with 'Press' mode, Callback to the button will have an passed value FromKeyPicker which will be true if it was activated by the key picker)
+ Icon and IconPosition parameters to Library:AddDraggableLabel() and Library:AddDraggableButton()
+ Slider.AllowRightClickInput (right click/double tap to open text input for specific value)
+ Library:AddDraggableImageButton()

[changes]
+ Implemented individual rounded corners for certain elements (dropdowns, right-click context menus)
+ Right-click context menus will now connect to the buttons visually
+ Dropdown:GetActiveValues() => Dropdown:GetActiveValues(ReturnCountForMulti: boolean) [true => returns value count]
+ The dropdown menu will now close if the button is not visible on the screen.
+ Other KeyPickers will no longer trigger when you are selecting the keybind
+ Mouse button KeyPickers will no longer trigger when you have the UI opened
+ Draggable labels, buttons, menus and image buttons will now find an position where they won't overlap other dragging elements

[fixes]
+ Fixed AllowNull not properly working with Multi dropdowns
+ Fixed dropdown context menu not matching button size on the X axis

[optimizations]
+ Obsidian Library table will now get properly garbage collected after calling Library:Unload()
```

## 21.04.2026

```diff
[features]
+ SaveManager:SetLoadingOrder(enabled: boolean, order: { })
```

## 05.04.2026

```diff
[features]
+ Library.Scheme.DestructiveColor
+ Library:CreateLoading(LoadingInfo)
~ Read documentation at http://docs.mspaint.cc/obsidian/core/library/loading
```

## 03.04.2026

```diff
[features]
+ Tab:SetVisible()
```

## 28.03.2026

```diff
[features]
+ Dropdown.FormatListValue(Value)
  - Randomized formatting will not be preserved as the function is called every time the context menu is rebuilt
```

## 24.03.2026

```diff
[features]
+ Input.VerifyValue(NewValue: string): boolean
+ Input.ClearTextOnBlur
+ KeyPicker.Blacklisted, KeyPicker.BlacklistedModifiers
+ KeyPicker.Whitelisted, KeyPicker.WhitelistedModifiers

[changes]
+ CornerRadius now applies to more elements
+ Height of the slider increased by 1px
```

## 17.03.2026

```diff
[features]
+ Window:SetCornerRadius(Radius: number)

[fixes]
+ Fixed Window:SetFooter not changing the label text
+ Fixed footer background not properly resizing
+ Fixed Tab buttons not respecting corner radius
```

## 16.01.2026

```diff
[features]
+ Library:ResetCursorIcon()
+ Library:ChangeCursorIcon(ImageId: string)
+ Library:ChangeCursorIconSize(Size: UDim2)
```

## 30.12.2025

```diff
[breaking changes]
! Library.Scheme:
  .Red -> .RedColor
  .Dark -> .DarkColor
  .White -> .WhiteColor
! WindowInfo.Compact -> WindowInfo.SidebarCompacted
! WindowInfo.SidebarMinWidth -> WindowInfo.MinSidebarWidth
! WindowInfo.MinContentWidth -> WindowInfo.MinContainerWidth
- WindowInfo.SidebarCollapseThreshold
- WindowInfo.SidebarHighlightCallback function
- WindowInfo.InitialSidebarWidth
- WindowInfo.InitialSidebarScale

[fixes]
+ Fixed DPI Scaling

[features]
+ WindowInfo.DisableCompactingSnap
  -> WindowInfo.CompactWidthActivation

[changes]
+ WindowInfo.SidebarCompactWidth default value (54) to new value (48)
+ Library:SetWatermark is deprecated due to Library:AddDraggableLabel having the same functionality
```

## 18.12.2025

```diff
+ Patched static key bypass inside Key Box
    * The AddKeyBox function now only takes the callback function
    * The callback function only returns the provided key, you need to implement your own handler inside the callback
```

## 09.11.2025

```diff
+ Added Library.ImageManager (https://docs.mspaint.cc/obsidian/core/library/utility#custom-asset-icons)
```

## 02.11.2025

```diff
+ Warning Box now follows the UI style of Obsidian (rounded corners with outlines)
+ Watermark now correctly resizes itself with new line characters
```

## 01.11.2025

```diff
+ The ignored indexes (SaveManager.SetIgnoreIndexes) are no longer applied when you load a configuration that contains them
```

## 5.10.2025

```diff
+ Added support for modifier keys in KeyPicker (for example: LCtrl + E)
+ Fixed DoClick not calling the correct callbacks
```

## 17.09.2025

```diff
+ Added support for custom icons (rbxasset, rbxassetid, rbxthumb, getcustomasset) for Tabs and Groupboxes
```

## 14.09.2025

```diff
+ Added `Press` mode to `KeyPicker`
```

## 19.08.2025

```diff
+ Fixed `KeyPicker` in Toggle mode not working properly when Key is nil
```

### 12.08.2025

```diff
+ Fixed `Tab:UpdateWarningBox()` not resizing properly
```

### 10.08.2025

```diff
+ Added a LockSize option `Tab:UpdateWarningBox()` to set the maximum size of the warning box to 3.25 size of the Tab Container (optional)
+ Added support for mouse button 3 (middle click)
```

### 17.07.2025

```diff
+ Added Description parameter to `Window:AddTab()` method to set a description for the tab
+ Updated `Window:AddTab()` method to accept a table with Name, Icon, and Description or a table with Name, Icon (optional), and Description (optional)
+ Updated `Library:CreateWindow()`'s WindowInfo parameter to include a `DisableSearch` option to disable the search box in the window
```

### 15.07.2025

```diff
+ Added watermark support to the library
+ Added `Library:SetWatermarkVisibility()` method to toggle the visibility of the watermark
+ Added `Library:SetWatermark()` method to set the watermark text
```

### 14.07.2025

```diff
+ Added `AddImage` component
```

### 13.07.2025

```diff
+ Updated lucide icons to the latest version
+ Changed lucide icons to be using `getcustomasset` to bypass ContentProvider detections
+ Added `AddViewport` component
```

### 12.07.2025

```diff
+ Added `ThemeManager:SetDefaultTheme()` method to set the default theme for the library
+ Improved `Library:SafeCallback()` to handle errors correctly and return everything correctly (previously it would only return the first return value)
+ Added `BackgroundImage` parameter to `Window` constructor to set a background image for the window
```

### 02.07.2025

```diff
+ Added dropdown support for `AddDependencyBox` and `AddDependencyGroupBox`
```

### 15.06.2025

```diff
+ Fixed Obsidian's `Library:Validate()` function to ignore arrays (setting modes option on AddKeyPicker would fail previously)
```

### 04.06.2025

```diff
+ Added Notify.Persist and Notify:Destroy() methods to make persistent notifications easier to manage
+ Added Icon parameter to Groupbox constructor that matches the accent color.
```

### 17.05.2025

```diff
+ Added a new `AddDependencyBox` and `AddDependencyGroupBox` methods to the `Groupbox` class
```

### 18.01.2024

```diff
+ Added a Hover Animation to Buttons
+ Added Risky to Buttons
+ Changed Toggle's Checkbox to Switch (Checkbox is still possible with AddCheckbox)
+ Dropdown disabled values moved to the bottom
+ Fixed DPI Scale issues (Title Wrapping, Slider Fill Bar and Dropdown Menu Size)
```
