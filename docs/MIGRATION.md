# Migrating from Obsidian to Cyan 26.7

Cyan 26.7 is a renamed and modernized package. The core element API is intentionally compatible with the current Obsidian source, but identifiers and defaults that form part of the package surface have changed.

## Required changes

| Before | After |
| --- | --- |
| `deividcomsono/obsidian` | `ehabyt/cyan` |
| `Obsidian` / `ObsidianLoading` GUI names | `Cyan` / `CyanLoading` |
| `ObsidianLibSettings` default persistence folder | `CyanLibSettings` |
| `getgenv().ObsidianThemeManager` | `getgenv().CyanThemeManager` |
| Obsidian raw GitHub loader URL | Cyan raw GitHub loader URL |

Update any `require` path and package version first. Existing window, tab, groupbox, and control calls continue to use `Library`.

## Existing saved settings and themes

Cyan does **not** silently move files from `ObsidianLibSettings`; this protects existing files and lets applications choose a migration strategy. To retain an existing folder, set it explicitly before building manager UI:

```luau
SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)

SaveManager:SetFolder("ObsidianLibSettings")
ThemeManager:SetFolder("ObsidianLibSettings")
```

To move to the new default, copy the old folder to `CyanLibSettings` in a host that owns and permits that filesystem operation, then remove the temporary compatibility calls.

## Keyboard and search behavior

Cyan adds `Window:FocusSearch()`, `Window:ClearSearch()`, and `Library:CloseTransientUI()`. `Ctrl+K` focuses search, while Escape releases an active text field before it dismisses transient UI. Escape honors a dialog's `OutsideClickDismiss` policy.

## Persistence availability

Persistence is now capability-aware. Call `SaveManager:IsSupported()` or `ThemeManager:IsSupported()` in hosts where filesystem APIs might be absent. Operations return a descriptive failure instead of calling an unavailable filesystem primitive.
