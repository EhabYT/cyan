--!strict
-- Cyan callback-driven access-key UI.
-- This module intentionally does not ship keys or contact a key service itself.
-- The host owns verification through the Validate callback.

local KeySystem = {}
KeySystem.__index = KeySystem

export type State = "Idle" | "Checking" | "Verified" | "Rejected" | "Locked"
export type Validator = (Key: string) -> (boolean, string?)
export type Options = {
    Validate: Validator,
    MaxAttempts: number?,
    CooldownSeconds: number?,
    OnVerified: ((KeySystem) -> ())?,
    OnRejected: ((KeySystem, string) -> ())?,
    OnStateChanged: ((KeySystem, State, string?) -> ())?,
}
export type UIOptions = {
    Prompt: string?,
    Placeholder: string?,
    CheckingText: string?,
    VerifiedText: string?,
    RejectedPrefix: string?,
    LockedText: string?,
    ResetText: string?,
    ShowResetButton: boolean?,
}

export type KeySystem = {
    State: State,
    Attempts: number,
    MaxAttempts: number?,
    CooldownSeconds: number,
    NextAttemptAt: number,
    LastError: string?,

    Verify: (self: KeySystem, Key: string) -> (boolean, string?),
    Reset: (self: KeySystem) -> (),
    GetRemainingAttempts: (self: KeySystem) -> number?,
    GetStatus: (self: KeySystem) -> (State, string?),
    IsVerified: (self: KeySystem) -> boolean,
    IsLocked: (self: KeySystem) -> boolean,
    Attach: (self: KeySystem, KeyTab: any, Options: UIOptions?) -> any,
}

local function Trim(Value: string): string
    return Value:match("^%s*(.-)%s*$")
end

local function CallSafely(Callback: (...any) -> ...any, ...: any): (boolean, ...any)
    return pcall(Callback, ...)
end

local function RunHook(Callback: ((...any) -> ())?, ...: any)
    if typeof(Callback) == "function" then
        -- Access state must not be changed by a consumer callback error.
        pcall(Callback, ...)
    end
end

function KeySystem:_SetState(State: State, Message: string?)
    self.State = State
    RunHook(self._OnStateChanged, self, State, Message)
end

function KeySystem.new(Options: Options): KeySystem
    assert(typeof(Options) == "table", "KeySystem options must be a table")
    assert(typeof(Options.Validate) == "function", "KeySystem requires an Options.Validate callback")

    local MaxAttempts = Options.MaxAttempts
    if MaxAttempts ~= nil then
        assert(typeof(MaxAttempts) == "number" and MaxAttempts >= 1, "MaxAttempts must be a positive number")
        MaxAttempts = math.floor(MaxAttempts)
    end

    local CooldownSeconds = Options.CooldownSeconds or 0
    assert(typeof(CooldownSeconds) == "number" and CooldownSeconds >= 0, "CooldownSeconds must be non-negative")

    local Self = setmetatable({
        State = "Idle" :: State,
        Attempts = 0,
        MaxAttempts = MaxAttempts,
        CooldownSeconds = CooldownSeconds,
        NextAttemptAt = 0,
        LastError = nil,

        _Validate = Options.Validate,
        _OnVerified = Options.OnVerified,
        _OnRejected = Options.OnRejected,
        _OnStateChanged = Options.OnStateChanged,
    }, KeySystem)

    return Self :: any
end

function KeySystem:IsVerified(): boolean
    return self.State == "Verified"
end

function KeySystem:IsLocked(): boolean
    return self.State == "Locked"
end

function KeySystem:Reset()
    self.Attempts = 0
    self.NextAttemptAt = 0
    self.LastError = nil
    self:_SetState("Idle")
end

function KeySystem:GetRemainingAttempts(): number?
    if self.MaxAttempts == nil then
        return nil
    end

    return math.max(0, self.MaxAttempts - self.Attempts)
end

function KeySystem:GetStatus(): (State, string?)
    return self.State, self.LastError
end

function KeySystem:Verify(Key: string): (boolean, string?)
    if self:IsVerified() then
        return true, "Access has already been verified"
    end
    if self:IsLocked() then
        return false, "Too many invalid attempts. Reset the key system before trying again"
    end
    if typeof(Key) ~= "string" then
        return false, "Key must be a string"
    end

    Key = Trim(Key)
    if Key == "" then
        return false, "Enter an access key"
    end

    local Now = os.clock()
    if Now < self.NextAttemptAt then
        local Remaining = math.ceil(self.NextAttemptAt - Now)
        return false,
            string.format("Please wait %d second%s before trying again", Remaining, if Remaining == 1 then "" else "s")
    end

    self:_SetState("Checking")
    local Invoked, Allowed, Message = CallSafely(self._Validate, Key)
    if not Invoked then
        self.LastError = "Key verification is temporarily unavailable"
        self:_SetState("Rejected", self.LastError)
        RunHook(self._OnRejected, self, self.LastError)
        return false, self.LastError
    end

    if Allowed == true then
        self.LastError = nil
        self:_SetState("Verified", if typeof(Message) == "string" then Message else nil)
        -- Deliberately do not retain the entered key after verification.
        RunHook(self._OnVerified, self)
        return true, if typeof(Message) == "string" and Message ~= "" then Message else "Access granted"
    end

    self.Attempts += 1
    self.LastError = if typeof(Message) == "string" and Message ~= "" then Message else "Invalid access key"
    self.NextAttemptAt = Now + self.CooldownSeconds

    if self.MaxAttempts and self.Attempts >= self.MaxAttempts then
        self.LastError = "Too many invalid attempts"
        self:_SetState("Locked", self.LastError)
    else
        self:_SetState("Rejected", self.LastError)
    end

    RunHook(self._OnRejected, self, self.LastError)
    return false, self.LastError
end

function KeySystem:Attach(KeyTab: any, Options: UIOptions?)
    assert(typeof(KeyTab) == "table" and typeof(KeyTab.AddKeyBox) == "function", "KeyTab with AddKeyBox is required")
    assert(Options == nil or typeof(Options) == "table", "KeySystem UI options must be a table")

    Options = Options or {}
    local Prompt = Options.Prompt or "Enter your access key to continue."
    local CheckingText = Options.CheckingText or "Checking key..."
    local VerifiedText = Options.VerifiedText or "Access granted."
    local RejectedPrefix = Options.RejectedPrefix or "Access denied: "
    local LockedText = Options.LockedText or "Access is locked. Reset before trying again."
    local ResetText = Options.ResetText or "Reset key entry"

    local PromptLabel = nil
    local StatusLabel = nil
    if typeof(KeyTab.AddLabel) == "function" then
        PromptLabel = KeyTab:AddLabel(Prompt, true)
        StatusLabel = KeyTab:AddLabel("Status: waiting for a key", true)
    end

    local KeyBox
    local function SetStatus(Text: string)
        if StatusLabel then
            StatusLabel:SetText(Text)
        end
    end

    KeyBox = KeyTab:AddKeyBox(function(Key: string)
        if self:IsLocked() then
            SetStatus(LockedText)
            return
        end

        SetStatus(CheckingText)
        local Allowed, Message = self:Verify(Key)
        if Allowed then
            SetStatus(VerifiedText)
            if KeyBox and typeof(KeyBox.Clear) == "function" then
                KeyBox:Clear()
            end
            if KeyBox and typeof(KeyBox.SetDisabled) == "function" then
                KeyBox:SetDisabled(true)
            end
            return
        end

        if self:IsLocked() then
            SetStatus(LockedText)
            if KeyBox and typeof(KeyBox.SetDisabled) == "function" then
                KeyBox:SetDisabled(true)
            end
            return
        end

        SetStatus(RejectedPrefix .. tostring(Message))
    end)

    if KeyBox and KeyBox.TextBox and typeof(Options.Placeholder) == "string" then
        KeyBox.TextBox.PlaceholderText = Options.Placeholder
    end

    local ResetButton = nil
    if Options.ShowResetButton ~= false and typeof(KeyTab.AddButton) == "function" then
        ResetButton = KeyTab:AddButton(ResetText, function()
            self:Reset()
            if KeyBox and typeof(KeyBox.SetDisabled) == "function" then
                KeyBox:SetDisabled(false)
            end
            if KeyBox and typeof(KeyBox.Clear) == "function" then
                KeyBox:Clear()
            end
            SetStatus("Status: waiting for a key")
            if KeyBox and typeof(KeyBox.Focus) == "function" then
                KeyBox:Focus()
            end
        end)
    end

    return {
        PromptLabel = PromptLabel,
        StatusLabel = StatusLabel,
        KeyBox = KeyBox,
        ResetButton = ResetButton,
    }
end

return KeySystem
