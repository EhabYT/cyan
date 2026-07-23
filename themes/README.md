# Themes

Cyan's curated themes live in `addons/ThemeManager.lua` → `BuiltInThemes`.
They are pure color data and require no extra files.

## Built-in themes

`Cyan`, `Default`, `Cyan Pro`, `Midnight`, `Aurora`, `Graphite`, `Bloom`,
`BBot`, `Fatality`, `Jester`, `Mint`, `Tokyo Night`, `Ubuntu`, `Quartz`,
`Nord`, `Dracula`, `Monokai`, `Gruvbox`, `Solarized`, `Catppuccin`.

## Add your own

1. Launch the menu and open **UI Settings → Themes**.
2. Tune colors live, then **Save Theme** with a name.
3. `ThemeManager` writes a theme file under the folder set by
   `ThemeManager:SetFolder(...)`. Load it anytime, or make it the default with
   `ThemeManager:SetDefaultTheme(name)`.

See `docs/THEMES.md` for the full guide.
