# Callback-driven key system

`addons/KeySystem.lua` provides the **UI flow** for entering and validating an access key. It deliberately does not contain an allowlist, remote endpoint, bypass routine, or hard-coded secret.

## Use it with a trusted validator

```luau
local Gate = Cyan.KeySystem.new({
    Validate = function(submittedKey)
        -- Delegate to your trusted server/backend and return:
        -- true, optionalSuccessMessage
        -- false, userSafeFailureMessage
        return AccessService:Verify(submittedKey)
    end,
    MaxAttempts = 5,
    CooldownSeconds = 1,
    OnVerified = function()
        StartAuthorizedExperience()
    end,
    OnStateChanged = function(_Gate, state, message)
        print("Access state:", state, message or "")
    end,
})

Gate:Attach(Window:AddKeyTab("Access", "key"), {
    ShowResetButton = true,
    ResetText = "Try a different key",
})
```

`Validate` is the only source of truth. `Verify` trims input, protects the UI from validator callback errors, tracks attempts, enforces optional cooldown/lock behavior, and never retains an accepted submitted key. `GetStatus()` and `GetRemainingAttempts()` expose display-safe state for custom UI. Attached key boxes support Enter-to-submit, clear the accepted text, disable on verification/lock, and optionally add a reset button.

## Gate the menu until login succeeds

Use `GateTabs` immediately before `Attach` to show only the login tab first:

```luau
Gate:GateTabs(LoginTab, {
    MainTab,
    SettingsTab,
}, {
    DefaultTab = MainTab,
    HideLoginTabAfterVerification = true,
    HideSearchBeforeVerification = true,
})

Gate:Attach(LoginTab)
```

This controls the UI flow only. Server code must still validate and enforce all protected actions. `GateTabs` returns a controller with `Lock()` and `Unlock()` methods. Call `Gate:Logout()` to reset the local key UI, lock the protected tabs, hide search again, and return to the login tab.

For a server-backed session, your logout handler should also notify the server to revoke or expire the server-side session.

## Server-backed validation

For a Roblox Studio experience, use a server-owned `RemoteFunction` and keep the entitlement decision on the server:

```luau
local Gate = Cyan.KeySystem.fromRemote(ReplicatedStorage:WaitForChild("VerifyAccessKey"), {
    MaxAttempts = 5,
    CooldownSeconds = 1,
})
```

The server must return `true, message` or `false, userSafeMessage` and independently enforce every protected action. `fromRemote` only provides the client UI and safe callback handling.

## Security boundary

A client-side key prompt is not a security boundary. For production Roblox experiences:

1. Send the submitted key to a server-controlled verifier.
2. Have the server independently verify entitlement.
3. Enforce protected actions and rewards on the server, not merely by hiding client UI.
4. Return concise, user-safe failure messages from the validator; do not expose backend details.

Use an offline callback or local allowlist only for demos, development tools, or non-sensitive UI gating.

## State lifecycle

| State | Meaning |
| --- | --- |
| `Idle` | Ready for a key. |
| `Checking` | Validator callback is executing. |
| `Verified` | Validator accepted the key. The attached key box is disabled. |
| `Rejected` | Validator denied the key; another attempt is allowed. |
| `Locked` | Maximum invalid attempts were reached; call `Gate:Reset()` before retrying. |
