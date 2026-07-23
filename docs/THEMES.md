# Theming

Cyan ships with a built-in theming engine. Colors are centralized in
`Library.Scheme` and every themed element is registered so a theme change
re-paints the whole UI instantly — including windows, tabs, toggles, sliders,
dropdowns, and the watermark.

## How theming works

- `Library.Scheme` holds the active palette: `BackgroundColor`, `MainColor`,
  `AccentColor`, `OutlineColor`, `FontColor`, `Font`, `RedColor`,
  `DestructiveColor`, `DarkColor`, `WhiteColor`, and `BackgroundImage`.
- `ThemeManager` reads and writes theme files and applies them to `Library.Scheme`.
- `SaveManager` can persist the active theme inside a configuration slot.

## Built-in themes

Apply any built-in theme from the **UI Settings → Themes** groupbox (built by
`ThemeManager:ApplyToTab`) or programmatically:

```luau
ThemeManager:SetTheme("Cyan Pro")
ThemeManager:SetTheme("Midnight")
```

| Theme | Surfaces | Accent | Best for |
| --- | --- | --- | --- |
| `Cyan` | deep navy | cyan | default, high visibility |
| `Default` | deep navy | cyan | alias of Cyan |
| `Cyan Pro` | refined navy | bright cyan | long sessions, crisp contrast |
| `Midnight` | near-black blue | indigo | low-light / OLED |
| `Aurora` | dark teal | emerald | calm, nature themes |
| `Graphite` | dark gray | sky blue | neutral, modern |
| `Bloom` | plum | pink | vibrant, playful |
| `BBot`, `Fatality`, `Jester`, `Mint`, `Tokyo Night`, `Ubuntu`, `Quartz`, `Nord`, `Dracula`, `Monokai`, `Gruvbox`, `Solarized`, `Catppuccin` | classic presets | — | familiar looks |

## Custom themes

1. Open the menu and switch colors live in the **Themes** groupbox.
2. Click **Save Theme**, give it a name, and `ThemeManager` writes a file under
   your configured folder (see `ThemeManager:SetFolder`).
3. Load it later from the same groupbox, or make it the default:

```luau
ThemeManager:SetFolder("MyScriptHub")
ThemeManager:SetDefaultTheme("My Theme")
```

The default theme is auto-applied on the next launch.

## Setting a default theme in your loader

```luau
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MyScriptHub")
ThemeManager:ApplyToTab(Tabs["UI Settings"])
ThemeManager:SetTheme("Cyan Pro") -- optional: start on a specific look
```
