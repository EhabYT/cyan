#!/usr/bin/env bash
# Smoke-test persistence guard rails without a Roblox runtime.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LUAU_BIN="${LUAU_BIN:-luau}"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

cat > "$TEMP_DIR/save_prefix.luau" <<'EOF'
local Folders = {}
local Files = {}
function isfolder(Path) return Folders[Path] == true end
function makefolder(Path) Folders[Path] = true end
function isfile(Path) return Files[Path] ~= nil end
function listfiles(_Path) return {} end
function readfile(Path) return Files[Path] end
function writefile(Path, Content) Files[Path] = Content end
function delfile(Path) Files[Path] = nil end
local HttpService = {
    JSONEncode = function(_Self, Value) return Value end,
    JSONDecode = function(_Self, Value) return Value end,
}
game = { GetService = function(_Self, Name) assert(Name == "HttpService") return HttpService end }
EOF

sed 's/^return SaveManager$/local SaveManagerUnderTest = SaveManager/' \
    "$ROOT/addons/SaveManager.lua" > "$TEMP_DIR/save_module.luau"
cat "$TEMP_DIR/save_prefix.luau" "$TEMP_DIR/save_module.luau" > "$TEMP_DIR/save_smoke.luau"
cat >> "$TEMP_DIR/save_smoke.luau" <<'EOF'
assert(SaveManagerUnderTest:IsSupported(), "filesystem capability should be detected")
local SaveLocalization = {
    T = function(_Self, Key) return Key end,
    BindText = function(_Self, Element) return Element end,
}
SaveManagerUnderTest:SetLocalization(SaveLocalization, "save_ui")
assert(SaveManagerUnderTest.Localization == SaveLocalization and SaveManagerUnderTest.LocalizationPrefix == "save_ui", "save localization adapter was not configured")
SaveManagerUnderTest:SetLocalization(nil)
assert(SaveManagerUnderTest.Localization == nil and SaveManagerUnderTest.LocalizationPrefix == "save", "save localization adapter did not reset")
SaveManagerUnderTest:SetFolder("Cyan/Test")
SaveManagerUnderTest:SetSubFolder("place")
assert(Folders["Cyan"] and Folders["Cyan/Test/settings/place"], "nested folders were not created")

local Success, ErrorMessage = SaveManagerUnderTest:Save("../escape")
assert(not Success and ErrorMessage == "Invalid config name provided", "path traversal was not rejected")
Success, ErrorMessage = SaveManagerUnderTest:Load("../escape")
assert(not Success and ErrorMessage == "Invalid config name provided", "invalid load name was not rejected")

Files["Cyan/Test/settings/place/Old.json"] = "{\"objects\":{}}"
Files["Cyan/Test/settings/place/autoload.txt"] = "Old"
SaveManagerUnderTest.AutoloadConfig = nil
Success, ErrorMessage = SaveManagerUnderTest:Rename("Old", "New")
assert(Success, "config rename should succeed: " .. tostring(ErrorMessage))
assert(Files["Cyan/Test/settings/place/Old.json"] == nil, "original config should be removed after rename")
assert(Files["Cyan/Test/settings/place/New.json"] ~= nil, "renamed config should be created")
assert(Files["Cyan/Test/settings/place/autoload.txt"] == "New", "autoload should migrate to renamed config")
EOF

cat > "$TEMP_DIR/theme_prefix.luau" <<'EOF'
local Folders = {}
local Files = {}
function isfolder(Path) return Folders[Path] == true end
function makefolder(Path) Folders[Path] = true end
function isfile(Path) return Files[Path] ~= nil end
function listfiles(_Path) return {} end
function readfile(Path) return Files[Path] end
function writefile(Path, Content) Files[Path] = Content end
function delfile(Path) Files[Path] = nil end
local HttpService = {
    JSONEncode = function(_Self, Value) return Value end,
    JSONDecode = function(_Self, Value) return Value end,
}
game = { GetService = function(_Self, Name) assert(Name == "HttpService") return HttpService end }
local Shared = {}
function getgenv() return Shared end
EOF

sed 's/^return ThemeManager$/local ThemeManagerUnderTest = ThemeManager/' \
    "$ROOT/addons/ThemeManager.lua" > "$TEMP_DIR/theme_module.luau"
cat "$TEMP_DIR/theme_prefix.luau" "$TEMP_DIR/theme_module.luau" > "$TEMP_DIR/theme_smoke.luau"
cat >> "$TEMP_DIR/theme_smoke.luau" <<'EOF'
assert(ThemeManagerUnderTest:IsSupported(), "filesystem capability should be detected")
assert(ThemeManagerUnderTest.BuiltInThemes.Cyan ~= nil, "stable Cyan preset should be available")
local ThemeLocalization = {
    T = function(_Self, Key) return Key end,
    BindText = function(_Self, Element) return Element end,
}
ThemeManagerUnderTest:SetLocalization(ThemeLocalization, "theme_ui")
assert(ThemeManagerUnderTest.Localization == ThemeLocalization and ThemeManagerUnderTest.LocalizationPrefix == "theme_ui", "theme localization adapter was not configured")
ThemeManagerUnderTest:SetLocalization(nil)
assert(ThemeManagerUnderTest.Localization == nil and ThemeManagerUnderTest.LocalizationPrefix == "theme", "theme localization adapter did not reset")
ThemeManagerUnderTest:SetFolder("Cyan/Test")
assert(Folders["Cyan"] and Folders["Cyan/Test/themes"], "theme folder was not created")

local Success, ErrorMessage = ThemeManagerUnderTest:SaveCustomTheme("../escape")
assert(not Success and ErrorMessage == "Invalid theme name provided", "path traversal was not rejected")
Success, ErrorMessage = ThemeManagerUnderTest:ApplyTheme("Default")
assert(not Success and ErrorMessage:find("Library is not set", 1, true), "missing library did not fail cleanly")
EOF

"$LUAU_BIN" "$TEMP_DIR/save_smoke.luau"
"$LUAU_BIN" "$TEMP_DIR/theme_smoke.luau"
echo "persistence add-on smoke checks: OK"
