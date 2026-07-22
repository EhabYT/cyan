-- Standalone behavioral checks for the callback-driven key system.

local KeySystem = require("../addons/KeySystem")

local function Expect(Condition: boolean, Message: string)
    assert(Condition, Message)
end

local Rejections = 0
local States = {}
local Gate = KeySystem.new({
    Validate = function(Key)
        if Key == "approved" then
            return true, "Accepted"
        end
        return false, "Rejected by validator"
    end,
    MaxAttempts = 2,
    OnRejected = function()
        Rejections += 1
    end,
    OnStateChanged = function(_Gate, State)
        table.insert(States, State)
    end,
})

local Allowed, Message = Gate:Verify("   ")
Expect(not Allowed and Message == "Enter an access key", "empty key should be rejected before validation")
Expect(Gate.Attempts == 0, "empty key should not consume an attempt")

Allowed, Message = Gate:Verify("bad")
Expect(not Allowed and Message == "Rejected by validator", "validator rejection should be returned")
Expect(Gate.State == "Rejected" and Gate.Attempts == 1 and Rejections == 1, "first rejection state is incorrect")
Expect(Gate:GetRemainingAttempts() == 1, "remaining attempt count is incorrect")
Expect(States[#States] == "Rejected", "state-change hook did not receive a rejection")

Allowed, Message = Gate:Verify("bad")
Expect(not Allowed and Message == "Too many invalid attempts", "attempt limit should lock the system")
Expect(Gate:IsLocked(), "system should be locked after the configured number of invalid attempts")

Gate:Reset()
Expect(Gate.State == "Idle" and Gate.Attempts == 0 and not Gate:IsLocked(), "reset should restore an idle state")

Allowed, Message = Gate:Verify("  approved  ")
Expect(Allowed and Message == "Accepted", "trimmed valid key should be accepted")
Expect(Gate:IsVerified(), "verified state was not recorded")
local State, StatusMessage = Gate:GetStatus()
Expect(State == "Verified" and StatusMessage == nil, "verified status is incorrect")

local Labels = {}
local SubmittedKey = nil
local ResetCallback = nil
local MockKeyBox = {
    Disabled = false,
    Cleared = false,
    Focused = false,
    TextBox = {},
}
function MockKeyBox:SetDisabled(Value)
    self.Disabled = Value
end
function MockKeyBox:Clear()
    self.Cleared = true
end
function MockKeyBox:Focus()
    self.Focused = true
end

local MockWindow = {
    SearchVisible = true,
}
function MockWindow:IsSearchVisible()
    return self.SearchVisible
end
function MockWindow:SetSearchVisible(Visible)
    self.SearchVisible = Visible
end

local MockKeyTab = {
    Visible = true,
    Shown = false,
    Window = MockWindow,
}
function MockKeyTab:SetVisible(Visible)
    self.Visible = Visible
end
function MockKeyTab:Show()
    self.Shown = true
end
function MockKeyTab:AddLabel(Text)
    local Label = { Text = Text }
    function Label:SetText(NewText)
        self.Text = NewText
    end
    table.insert(Labels, Label)
    return Label
end
function MockKeyTab:AddKeyBox(Callback)
    SubmittedKey = Callback
    return MockKeyBox
end
function MockKeyTab:AddButton(_Text, Callback)
    ResetCallback = Callback
    return {}
end

local ProtectedTab = {
    Visible = true,
    Shown = false,
}
function ProtectedTab:SetVisible(Visible)
    self.Visible = Visible
end
function ProtectedTab:Show()
    self.Shown = true
end

local LogoutCount = 0
local UIGate = KeySystem.new({
    Validate = function(Key)
        return Key == "ui-key", "UI key was rejected"
    end,
    OnLoggedOut = function()
        LogoutCount += 1
    end,
})
UIGate:GateTabs(MockKeyTab, { ProtectedTab }, {
    DefaultTab = ProtectedTab,
    HideLoginTabAfterVerification = true,
    HideSearchBeforeVerification = true,
})
Expect(
    not ProtectedTab.Visible and MockKeyTab.Visible and MockKeyTab.Shown and not MockWindow.SearchVisible,
    "login tab should be the only visible tab before verification"
)

local UI = UIGate:Attach(MockKeyTab, { ShowResetButton = true })
Expect(UI.StatusLabel ~= nil and SubmittedKey ~= nil and ResetCallback ~= nil, "key UI did not bind expected controls")
SubmittedKey("bad")
Expect(UI.StatusLabel.Text:find("Access denied", 1, true) ~= nil, "key UI did not show a rejection")
SubmittedKey("ui-key")
Expect(MockKeyBox.Disabled and MockKeyBox.Cleared, "verified key UI should clear and disable its key box")
Expect(
    ProtectedTab.Visible and ProtectedTab.Shown and not MockKeyTab.Visible and MockWindow.SearchVisible,
    "verified key should unlock protected tabs and restore search"
)
Expect(UIGate:Logout() and LogoutCount == 1, "logout should reset an active verified session")
Expect(
    not ProtectedTab.Visible and MockKeyTab.Visible and not MockWindow.SearchVisible and not MockKeyBox.Disabled,
    "logout should lock protected tabs, hide search, and re-enable key entry"
)
Expect(not UIGate:Logout(), "logout should return false when no verified session exists")
ResetCallback()
Expect(
    not MockKeyBox.Disabled and MockKeyBox.Focused and UIGate.State == "Idle",
    "reset control did not restore key entry"
)

local ErrorGate = KeySystem.new({
    Validate = function()
        error("backend unavailable")
    end,
})
Allowed, Message = ErrorGate:Verify("any")
Expect(not Allowed and Message == "Key verification is temporarily unavailable", "validator errors should not escape")

print("key system smoke checks: OK")
