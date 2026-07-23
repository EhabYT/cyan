#!/usr/bin/env python3
"""Generate a single-file, offline, ungated bundle from the local Cyan repo.

Each module is embedded exactly as the runtime loader executes it (via
loadstring of the raw file content inside a long-bracket), so `export type`
declarations and top-level returns stay valid. The KeySystem GateTabs call is
not present in Example.lua, so every add-on control renders by default.
"""
import io

ROOT = "."

MODULES = [
    ("Library", "Library.lua"),
    ("ThemeManager", "addons/ThemeManager.lua"),
    ("SaveManager", "addons/SaveManager.lua"),
    ("KeySystem", "addons/KeySystem.lua"),
    ("HUD", "addons/HUD.lua"),
    ("ESP", "addons/ESP.lua"),
    ("Radar", "addons/Radar.lua"),
    ("Movement", "addons/Movement.lua"),
    ("Visuals", "addons/Visuals.lua"),
    ("Camera", "addons/Camera.lua"),
    ("Protections", "addons/Protections.lua"),
    ("ServerInfo", "addons/ServerInfo.lua"),
    ("QoL", "addons/QoL.lua"),
    ("UIUtilities", "addons/UIUtilities.lua"),
    ("Player", "addons/Player.lua"),
    ("WeaponMods", "addons/WeaponMods.lua"),
]


def bracket(content: str) -> str:
    """Return a long-bracket opener/closer that does not appear in content."""
    level = 0
    while ("]" + "=" * level + "]") in content:
        level += 1
    return "[" + "=" * level + "[", "]" + "=" * level + "]"


def main() -> None:
    out = io.StringIO()
    out.write('-- Cyan 26.8.0 — single-file bundle (auto-generated).\n')
    out.write('-- Every add-on is inlined and the "UI Settings" tab is ungated,\n')
    out.write('-- so ESP, Aimbot and all add-on controls render by default.\n')
    out.write('\n')

    for name, path in MODULES:
        with open(f"{ROOT}/{path}", "r", encoding="utf-8") as fh:
            content = fh.read().rstrip("\n")
        open_b, close_b = bracket(content)
        out.write(f'--// {path} //--\n')
        out.write(f'local {name} = (loadstring({open_b}\n')
        out.write(content)
        out.write(f'\n{close_b}))()\n\n')

    with open(f"{ROOT}/Example.lua", "r", encoding="utf-8") as fh:
        example = fh.read()

    marker = 'local UIUtilities = LoadModule("addons/UIUtilities.lua")'
    idx = example.index(marker) + len(marker)
    body = example[idx:].lstrip("\n")

    out.write('--// Example.lua (body) //--\n')
    out.write(body)
    out.write('\n')

    text = out.getvalue()
    for target in ("Cyan.AllInOne.luau", "Cyan.Fixed.luau"):
        with open(f"{ROOT}/{target}", "w", encoding="utf-8") as fh:
            fh.write(text)
        print(f"wrote {target}: {text.count(chr(10)) + 1} lines")


if __name__ == "__main__":
    main()
