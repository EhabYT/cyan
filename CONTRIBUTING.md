# Contributing to Cyan

## Before opening a change

1. Keep public behavior backwards-compatible unless the change is documented in `CHANGELOG.md` and `docs/MIGRATION.md`.
2. Update `Library.d.luau` whenever a public `Library`, `Window`, dialog, or element API changes.
3. Add a concise example to `Example.lua` for user-facing controls or behavior.
4. Do not add remote code execution, input automation, or gameplay-altering features to this UI package.

## Local checks

Install the pinned tools with `rokit install`, then run:

```sh
# StyLua parses files as part of formatting verification.
stylua --check Library.lua Library.d.luau Example.lua init.luau addons tests/keysystem_smoke.luau
python3 tests/validate_project.py
bash tests/smoke_addons.sh
luau tests/keysystem_smoke.luau
wally package --output /tmp/cyan.wally
```

## Style

- Use Luau types for public APIs and preserve `--!strict` in declaration modules.
- Use `Library:GiveSignal` for library-owned connections so `Library:Unload()` can clean them up.
- Make optional host capabilities explicit. Add-ons must return useful errors when a required API is unavailable.
- Keep direct network loading opt-in and document it; package-local `require` is the preferred consumption path.
