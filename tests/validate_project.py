#!/usr/bin/env python3
"""Fast repository invariants that do not require a Roblox runtime."""

from __future__ import annotations

import re
import tomllib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def fail(message: str) -> None:
    raise SystemExit(f"validation failed: {message}")


def resolve_local_module(source: Path, target: str) -> Path | None:
    base = source.parent / target.removeprefix("./")
    candidates = [base, base.with_suffix(".lua"), base.with_suffix(".luau"), base / "init.luau"]
    return next((candidate for candidate in candidates if candidate.is_file()), None)


def main() -> None:
    with (ROOT / "wally.toml").open("rb") as file:
        package = tomllib.load(file)["package"]

    if package.get("name") != "ehabyt/cyan":
        fail("wally package name must be ehabyt/cyan")
    if package.get("version") != "26.7.34":
        fail("wally package version must be 26.7.34")
    if package.get("realm") != "shared":
        fail("wally package realm must be shared")

    source_files = [
        ROOT / "Library.lua",
        ROOT / "Library.d.luau",
        ROOT / "Example.lua",
        ROOT / "init.luau",
        ROOT / "addons" / "SaveManager.lua",
        ROOT / "addons" / "ThemeManager.lua",
        ROOT / "addons" / "KeySystem.lua",
        ROOT / "addons" / "HUD.lua",
        ROOT / "addons" / "Localization.lua",
    ]
    for source in source_files:
        if not source.is_file():
            fail(f"missing source file: {source.relative_to(ROOT)}")
        text = source.read_text(encoding="utf-8")
        for target in re.findall(r'require\("(\./[^"\n]+)"\)', text):
            if resolve_local_module(source, target) is None:
                fail(f"{source.relative_to(ROOT)} has unresolved local require {target!r}")

    cyan_logo = ROOT / "assets" / "CyanLogo.png"
    if not cyan_logo.is_file() or cyan_logo.stat().st_size == 0:
        fail("bundled CyanLogo asset is missing")

    release_notes = ROOT / "docs" / "RELEASES.md"
    if not release_notes.is_file() or package["version"] not in release_notes.read_text(encoding="utf-8"):
        fail("release notes are missing the current package version")

    library = (ROOT / "Library.lua").read_text(encoding="utf-8")
    declarations = (ROOT / "Library.d.luau").read_text(encoding="utf-8")
    example = (ROOT / "Example.lua").read_text(encoding="utf-8")
    if "AutoShow = false" not in example or "Window:Open()" not in example:
        fail("example must explicitly open after its key-gated setup")
    for locale in ("fr", "es", "pt-BR", "it", "ru", "tr", "fa", "ur"):
        if f'I18n:Register("{locale}"' not in example:
            fail(f"example language pack is missing: {locale}")
    for source_fragment in ("CornerRadius = 12", "ClipsDescendants = true", "CurrentMenu:Close(true)", "FrameAbsolutePosition", "PendingToggle"):
        if source_fragment not in library:
            fail(f"UI robustness improvement is missing: {source_fragment}")
    for api in ("Version", "CloseTransientUI", "ClearSearch", "FocusSearch", "GetText", "SetText", "SetLocalization"):
        if api not in library or api not in declarations:
            fail(f"public API {api} is not implemented and declared")

    if library.count("function Tab:SetText") < 2 or "function Groupbox:SetText" not in library:
        fail("tab, key-tab, and groupbox text APIs are not implemented")
    for type_name in ("Tab", "KeyTab", "Groupbox"):
        if f"SetText: (self: {type_name}, Text: string) -> ()" not in declarations:
            fail(f"{type_name} text API is not declared")

    for method in ("SetText", "SetDescription", "SetKeywords", "SetOrder"):
        if f"function Command:{method}" not in library or f"{method}: (self: Command" not in declarations:
            fail(f"Command method {method} is not implemented and declared")

    for manager in ("SaveManager", "ThemeManager"):
        addon = (ROOT / "addons" / f"{manager}.lua").read_text(encoding="utf-8")
        if "function " + manager + ":IsSupported()" not in addon or "export type " + manager not in declarations:
            fail(f"{manager} filesystem capability API is not implemented and declared")
        if "function " + manager + ":SetLocalization" not in addon or "SetLocalization: (self: " + manager not in declarations:
            fail(f"{manager} localization adapter API is not implemented and declared")

    key_system = (ROOT / "addons" / "KeySystem.lua").read_text(encoding="utf-8")
    for api in (
        "KeySystem.new",
        "KeySystem.fromRemote",
        "function KeySystem:Verify",
        "function KeySystem:Reset",
        "function KeySystem:GetRemainingAttempts",
        "function KeySystem:GetStatus",
        "function KeySystem:Attach",
        "function UI:SetStatus",
        "function UI:UpdateText",
    ):
        if api not in key_system:
            fail(f"KeySystem API {api} is missing")
    for api in ("SetStatus: (self: KeySystemUI", "UpdateText: (self: KeySystemUI"):
        if api not in declarations:
            fail(f"KeySystem UI API {api} is not declared")

    for method in ("SetDisabled", "SetText", "Clear", "Focus", "Submit"):
        if f"function KeyBox:{method}" not in library:
            fail(f"KeyBox method {method} is missing")
    if 'KeySystem = require("./addons/KeySystem")' not in (ROOT / "init.luau").read_text(encoding="utf-8"):
        fail("package entry point does not export KeySystem")

    hud = (ROOT / "addons" / "HUD.lua").read_text(encoding="utf-8")
    for api in (
        "HUD.new",
        "function Self:AddText",
        "function Self:AddProgress",
        "function Self:AddTimer",
        "function Self:AddWaypoint",
        "function Self:AddObjectiveMarker",
        "function Self:SetParty",
        "function Self:AddPerformance",
        "function Self:Destroy",
    ):
        if api not in hud:
            fail(f"HUD API {api} is missing")
    if 'HUD = require("./addons/HUD")' not in (ROOT / "init.luau").read_text(encoding="utf-8"):
        fail("package entry point does not export HUD")

    localization = (ROOT / "addons" / "Localization.lua").read_text(encoding="utf-8")
    for api in (
        "Localization.new",
        "function Localization:SetLocale",
        "function Localization:Translate",
        "function Localization:BindText",
        "local function GetTextInstance",
        "local function ApplyAlignment",
    ):
        if api not in localization:
            fail(f"Localization API {api} is missing")
    if 'Localization = require("./addons/Localization")' not in (ROOT / "init.luau").read_text(encoding="utf-8"):
        fail("package entry point does not export Localization")

    type_implementations = {
        "Library": library,
        "Window": library,
        "SaveManager": (ROOT / "addons" / "SaveManager.lua").read_text(encoding="utf-8"),
        "ThemeManager": (ROOT / "addons" / "ThemeManager.lua").read_text(encoding="utf-8"),
    }
    for type_name, implementation in type_implementations.items():
        type_match = re.search(rf"export type {type_name} = \{{(.*?)^\}}", declarations, re.MULTILINE | re.DOTALL)
        if type_match is None:
            fail(f"missing public type declaration for {type_name}")
        declared_methods = re.findall(rf"^    (\w+): \(self: {type_name}[,)]", type_match.group(1), re.MULTILINE)
        missing_methods = [
            method
            for method in declared_methods
            if re.search(rf"function {type_name}:{re.escape(method)}\b", implementation) is None
        ]
        if missing_methods:
            fail(f"{type_name} declares methods without implementations: {', '.join(missing_methods)}")

    smoke_test = ROOT / "tests" / "smoke_addons.sh"
    key_system_smoke_test = ROOT / "tests" / "keysystem_smoke.luau"
    localization_smoke_test = ROOT / "tests" / "localization_smoke.luau"
    if not smoke_test.is_file() or not key_system_smoke_test.is_file() or not localization_smoke_test.is_file():
        fail("add-on smoke tests are missing")

    active_sources = [
        ROOT / "Library.lua",
        ROOT / "Library.d.luau",
        ROOT / "Example.lua",
        ROOT / "init.luau",
        ROOT / "addons" / "SaveManager.lua",
        ROOT / "addons" / "ThemeManager.lua",
        ROOT / "addons" / "KeySystem.lua",
        ROOT / "addons" / "HUD.lua",
        ROOT / "addons" / "Localization.lua",
    ]
    stale = [path.relative_to(ROOT).as_posix() for path in active_sources if "Obsidian" in path.read_text(encoding="utf-8")]
    if stale:
        fail("stale Obsidian branding in active source: " + ", ".join(stale))

    print("project metadata, local module targets, public declarations, and branding: OK")


if __name__ == "__main__":
    main()
