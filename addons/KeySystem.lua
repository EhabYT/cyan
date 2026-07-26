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
    OnLoggedOut: ((KeySystem) -> ())?,
    OnStateChanged: ((KeySystem, State, string?) -> ())?,
}
export type RemoteOptions = {
    MaxAttempts: number?,
    CooldownSeconds: number?,
    OnVerified: ((KeySystem) -> ())?,
    OnRejected: ((KeySystem, string) -> ())?,
    OnLoggedOut: ((KeySystem) -> ())?,
    OnStateChanged: ((KeySystem, State, string?) -> ())?,
}

export type UIOptions = {
    Prompt: string?,
    Placeholder: string?,
    IdleText: string?,
    CheckingText: string?,
    VerifiedText: string?,
    RejectedPrefix: string?,
    LockedText: string?,
    LoggedOutText: string?,
    ResetText: string?,
    ShowResetButton: boolean?,
}

export type UI = {
    PromptLabel: any?,
    StatusLabel: any?,
    KeyBox: any,
    ResetButton: any?,
    LoggedOutText: string,
    SetStatus: (self: UI, Text: string) -> (),
    UpdateText: (self: UI, Options: UIOptions) -> (),
}

export type GateOptions = {
    DefaultTab: any?,
    HideLoginTabAfterVerification: boolean?,
    HideSearchBeforeVerification: boolean?,
}

export type GateController = {
    Lock: (self: GateController) -> (),
    Unlock: (self: GateController) -> (),
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
    Logout: (self: KeySystem) -> boolean,
    GateTabs: (self: KeySystem, LoginTab: any, ProtectedTabs: { any }, Options: GateOptions?) -> GateController,
    Attach: (self: KeySystem, KeyTab: any, Options: UIOptions?) -> UI,
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
        _OnLoggedOut = Options.OnLoggedOut,
        _OnStateChanged = Options.OnStateChanged,
    }, KeySystem)

    return Self :: any
end

-- Creates a key system backed by a server-owned RemoteFunction.
-- The server must validate access and enforce every protected action itself.
function KeySystem.fromRemote(Remote: RemoteFunction, Options: RemoteOptions?): KeySystem
    assert(
        typeof(Remote) == "Instance" and Remote:IsA("RemoteFunction"),
        "KeySystem.fromRemote requires a RemoteFunction"
    )

    local RemoteOptions = Options or {}
    assert(typeof(RemoteOptions) == "table", "Remote key system options must be a table")

    return KeySystem.new({
        Validate = function(Key: string): (boolean, string?)
            local Success, Allowed, Message = pcall(function()
                return Remote:InvokeServer(Key)
            end)
            if not Success then
                return false, "Unable to contact the access service"
            end

            if Allowed == true then
                return true, if typeof(Message) == "string" then Message else nil
            end
            return false, if typeof(Message) == "string" then Message else "Access was not approved"
        end,
        MaxAttempts = RemoteOptions.MaxAttempts,
        CooldownSeconds = RemoteOptions.CooldownSeconds,
        OnVerified = RemoteOptions.OnVerified,
        OnRejected = RemoteOptions.OnRejected,
        OnLoggedOut = RemoteOptions.OnLoggedOut,
        OnStateChanged = RemoteOptions.OnStateChanged,
    })
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

function KeySystem:Logout(): boolean
    if not self:IsVerified() then
        return false
    end

    self:Reset()

    local UI = self._AttachedUI
    if UI then
        if UI.KeyBox and typeof(UI.KeyBox.SetDisabled) == "function" then
            UI.KeyBox:SetDisabled(false)
        end
        if UI.KeyBox and typeof(UI.KeyBox.Clear) == "function" then
            UI.KeyBox:Clear()
        end
        if UI.SetStatus and typeof(UI.SetStatus) == "function" then
            UI:SetStatus(UI.LoggedOutText or "Status: logged out")
        elseif UI.StatusLabel and typeof(UI.StatusLabel.SetText) == "function" then
            UI.StatusLabel:SetText("Status: logged out")
        end
    end

    if self._GateController and typeof(self._GateController.Lock) == "function" then
        self._GateController:Lock()
    end

    if UI and UI.KeyBox and typeof(UI.KeyBox.Focus) == "function" then
        local Focused = pcall(function()
            task.defer(function()
                UI.KeyBox:Focus()
            end)
        end)
        if not Focused then
            UI.KeyBox:Focus()
        end
    end

    RunHook(self._OnLoggedOut, self)
    return true
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

-- Shows a login tab first and keeps supplied tabs unavailable until verification succeeds.
-- This is UI gating only; protected gameplay/actions must still be enforced by the server.
function KeySystem:GateTabs(LoginTab: any, ProtectedTabs: { any }, Options: GateOptions?)
    assert(typeof(LoginTab) == "table" and typeof(LoginTab.Show) == "function", "A valid login tab is required")
    assert(typeof(ProtectedTabs) == "table", "ProtectedTabs must be a table")
    assert(Options == nil or typeof(Options) == "table", "Gate options must be a table")

    Options = Options or {}

    local Window = LoginTab.Window
    local SearchWasVisible = nil

    local function SetProtectedVisible(Visible: boolean)
        for _, Tab in ProtectedTabs do
            if Tab ~= LoginTab and typeof(Tab) == "table" and typeof(Tab.SetVisible) == "function" then
                Tab:SetVisible(Visible)
            end
        end
    end

    local function Lock()
        SetProtectedVisible(false)
        if
            Options.HideSearchBeforeVerification ~= false
            and typeof(Window) == "table"
            and typeof(Window.IsSearchVisible) == "function"
            and typeof(Window.SetSearchVisible) == "function"
        then
            SearchWasVisible = Window:IsSearchVisible()
            Window:SetSearchVisible(false)
        end
        if typeof(LoginTab.SetVisible) == "function" then
            LoginTab:SetVisible(true)
        end
        LoginTab:Show()
    end

    local function Unlock()
        SetProtectedVisible(true)
        if SearchWasVisible == true and typeof(Window) == "table" and typeof(Window.SetSearchVisible) == "function" then
            Window:SetSearchVisible(true)
        end
        if Options.HideLoginTabAfterVerification ~= false and typeof(LoginTab.SetVisible) == "function" then
            LoginTab:SetVisible(false)
        end

        local DefaultTab = Options.DefaultTab or ProtectedTabs[1]
        if typeof(DefaultTab) == "table" and typeof(DefaultTab.Show) == "function" then
            DefaultTab:Show()
        end
    end

    local PreviousOnVerified = self._OnVerified
    self._OnVerified = function(System)
        Unlock()
        RunHook(PreviousOnVerified, System)
    end

    if self:IsVerified() then
        Unlock()
    else
        Lock()
    end

    local Controller = {
        Lock = Lock,
        Unlock = Unlock,
    }
    self._GateController = Controller
    return Controller
end

function KeySystem:Attach(KeyTab: any, Options: UIOptions?): UI
    assert(typeof(KeyTab) == "table" and typeof(KeyTab.AddKeyBox) == "function", "KeyTab with AddKeyBox is required")
    assert(Options == nil or typeof(Options) == "table", "KeySystem UI options must be a table")

    Options = Options or {}
    local Text = {
        Prompt = Options.Prompt or "Enter your access key to continue.",
        Placeholder = Options.Placeholder,
        Idle = Options.IdleText or "Status: waiting for a key",
        Checking = Options.CheckingText or "Checking key...",
        Verified = Options.VerifiedText or "Access granted.",
        RejectedPrefix = Options.RejectedPrefix or "Access denied: ",
        Locked = Options.LockedText or "Access is locked. Reset before trying again.",
        LoggedOut = Options.LoggedOutText or "Status: logged out",
        Reset = Options.ResetText or "Reset key entry",
    }

    local PromptLabel = nil
    local StatusLabel = nil
    if typeof(KeyTab.AddLabel) == "function" then
        PromptLabel = KeyTab:AddLabel(Text.Prompt, true)
        StatusLabel = KeyTab:AddLabel(Text.Idle, true)
    end

    local KeyBox
    local ResetButton = nil
    local function SetStatus(StatusText: string)
        if StatusLabel then
            StatusLabel:SetText(StatusText)
        end
    end

    local function RefreshStatus()
        if self:IsLocked() then
            SetStatus(Text.Locked)
        elseif self:IsVerified() then
            SetStatus(Text.Verified)
        elseif self.State == "Checking" then
            SetStatus(Text.Checking)
        elseif self.State == "Rejected" then
            SetStatus(Text.RejectedPrefix .. tostring(self.LastError or ""))
        else
            SetStatus(Text.Idle)
        end
    end

    KeyBox = KeyTab:AddKeyBox(function(Key: string)
        if self:IsLocked() then
            SetStatus(Text.Locked)
            return
        end

        SetStatus(Text.Checking)
        local Allowed, Message = self:Verify(Key)
        if Allowed then
            SetStatus(Text.Verified)
            if KeyBox and typeof(KeyBox.Clear) == "function" then
                KeyBox:Clear()
            end
            if KeyBox and typeof(KeyBox.SetDisabled) == "function" then
                KeyBox:SetDisabled(true)
            end
            return
        end

        if self:IsLocked() then
            SetStatus(Text.Locked)
            if KeyBox and typeof(KeyBox.SetDisabled) == "function" then
                KeyBox:SetDisabled(true)
            end
            return
        end

        SetStatus(Text.RejectedPrefix .. tostring(Message))
    end)

    if KeyBox and KeyBox.TextBox and Text.Placeholder ~= nil then
        KeyBox.TextBox.PlaceholderText = Text.Placeholder
    end

    if Options.ShowResetButton ~= false and typeof(KeyTab.AddButton) == "function" then
        ResetButton = KeyTab:AddButton(Text.Reset, function()
            self:Reset()
            if KeyBox and typeof(KeyBox.SetDisabled) == "function" then
                KeyBox:SetDisabled(false)
            end
            if KeyBox and typeof(KeyBox.Clear) == "function" then
                KeyBox:Clear()
            end
            SetStatus(Text.Idle)
            if KeyBox and typeof(KeyBox.Focus) == "function" then
                KeyBox:Focus()
            end
        end)
    end

    local UI: any = {
        PromptLabel = PromptLabel,
        StatusLabel = StatusLabel,
        KeyBox = KeyBox,
        ResetButton = ResetButton,
        LoggedOutText = Text.LoggedOut,
    }

    function UI:SetStatus(StatusText: string)
        assert(typeof(StatusText) == "string", "Key system status text must be a string")
        SetStatus(StatusText)
    end

    function UI:UpdateText(NewOptions: UIOptions)
        assert(typeof(NewOptions) == "table", "Key system UI text options must be a table")

        if NewOptions.Prompt ~= nil then
            Text.Prompt = NewOptions.Prompt
        end
        if NewOptions.Placeholder ~= nil then
            Text.Placeholder = NewOptions.Placeholder
        end
        if NewOptions.IdleText ~= nil then
            Text.Idle = NewOptions.IdleText
        end
        if NewOptions.CheckingText ~= nil then
            Text.Checking = NewOptions.CheckingText
        end
        if NewOptions.VerifiedText ~= nil then
            Text.Verified = NewOptions.VerifiedText
        end
        if NewOptions.RejectedPrefix ~= nil then
            Text.RejectedPrefix = NewOptions.RejectedPrefix
        end
        if NewOptions.LockedText ~= nil then
            Text.Locked = NewOptions.LockedText
        end
        if NewOptions.LoggedOutText ~= nil then
            Text.LoggedOut = NewOptions.LoggedOutText
            UI.LoggedOutText = Text.LoggedOut
        end
        if NewOptions.ResetText ~= nil then
            Text.Reset = NewOptions.ResetText
        end

        if PromptLabel then
            PromptLabel:SetText(Text.Prompt)
        end
        if KeyBox and KeyBox.TextBox and Text.Placeholder ~= nil then
            KeyBox.TextBox.PlaceholderText = Text.Placeholder
        end
        if ResetButton and typeof(ResetButton.SetText) == "function" then
            ResetButton:SetText(Text.Reset)
        end
        RefreshStatus()
    end

    self._AttachedUI = UI
    return UI
end

return KeySystem
