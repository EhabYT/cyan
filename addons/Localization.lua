--!strict
-- Cyan localization helper. It is deliberately independent from the UI runtime
-- so it can be used by menus, HUDs, and server-authorized experience tools.

local Localization = {}
Localization.__index = Localization

export type Dictionary = { [string]: string }
export type Options = {
    DefaultLocale: string?,
    Locale: string?,
    Locales: { [string]: Dictionary }?,
    RightToLeftLocales: { [string]: boolean }?,
}

export type Binding = {
    Update: (self: Binding) -> (),
    Disconnect: (self: Binding) -> (),
}

export type Connection = {
    Disconnect: (self: Connection) -> (),
}

export type Localization = {
    Locale: string,
    DefaultLocale: string,
    Locales: { [string]: Dictionary },

    Register: (self: Localization, Locale: string, Dictionary: Dictionary) -> (),
    HasLocale: (self: Localization, Locale: string) -> boolean,
    SetLocale: (self: Localization, Locale: string) -> boolean,
    GetLocale: (self: Localization) -> string,
    IsRightToLeft: (self: Localization, Locale: string?) -> boolean,
    Translate: (self: Localization, Key: string, Parameters: { [string]: any }?) -> string,
    T: (self: Localization, Key: string, Parameters: { [string]: any }?) -> string,
    BindText: (
        self: Localization,
        Target: any,
        Key: string,
        Parameters: { [string]: any } | () -> { [string]: any }?
    ) -> Binding,
    OnChanged: (self: Localization, Callback: (Locale: string) -> ()) -> Connection,
    Destroy: (self: Localization) -> (),
}

local function NormalizeLocale(Locale: string): string
    return string.lower(Locale:gsub("_", "-"))
end

local function Format(Text: string, Parameters: { [string]: any }?): string
    if typeof(Parameters) ~= "table" then
        return Text
    end

    return (
        Text:gsub("{([%w_%-]+)}", function(Name)
            local Value = Parameters[Name]
            return if Value == nil then "{" .. Name .. "}" else tostring(Value)
        end)
    )
end

local function ResolveParameters(Parameters: any): { [string]: any }?
    if typeof(Parameters) == "function" then
        local Success, Value = pcall(Parameters)
        return if Success and typeof(Value) == "table" then Value else nil
    end

    return if typeof(Parameters) == "table" then Parameters else nil
end

function Localization.new(Options: Options?): Localization
    Options = Options or {}
    assert(typeof(Options) == "table", "Localization options must be a table")

    local DefaultLocale = NormalizeLocale(Options.DefaultLocale or "en")
    local Self: any = setmetatable({
        Locale = NormalizeLocale(Options.Locale or DefaultLocale),
        DefaultLocale = DefaultLocale,
        Locales = {},
        RightToLeftLocales = {
            ar = true,
            he = true,
            fa = true,
            ur = true,
        },
        Bindings = {},
        Callbacks = {},
        Destroyed = false,
    }, Localization)

    if typeof(Options.RightToLeftLocales) == "table" then
        for Locale, Enabled in Options.RightToLeftLocales do
            Self.RightToLeftLocales[NormalizeLocale(Locale)] = Enabled == true
        end
    end
    if typeof(Options.Locales) == "table" then
        for Locale, Dictionary in Options.Locales do
            Self:Register(Locale, Dictionary)
        end
    end

    return Self :: any
end

function Localization:Register(Locale: string, Dictionary: Dictionary)
    assert(typeof(Locale) == "string" and Locale ~= "", "Locale must be a non-empty string")
    assert(typeof(Dictionary) == "table", "Dictionary must be a table")

    self.Locales[NormalizeLocale(Locale)] = Dictionary
end

function Localization:HasLocale(Locale: string): boolean
    return self.Locales[NormalizeLocale(Locale)] ~= nil
end

function Localization:GetLocale(): string
    return self.Locale
end

function Localization:IsRightToLeft(Locale: string?): boolean
    Locale = NormalizeLocale(Locale or self.Locale)
    local BaseLocale = Locale:match("^([^-]+)") or Locale
    return self.RightToLeftLocales[Locale] == true or self.RightToLeftLocales[BaseLocale] == true
end

function Localization:Translate(Key: string, Parameters: { [string]: any }?): string
    assert(typeof(Key) == "string", "Localization key must be a string")

    local Current = self.Locales[self.Locale]
    local Fallback = self.Locales[self.DefaultLocale]
    local Text = (Current and Current[Key]) or (Fallback and Fallback[Key]) or Key
    return Format(Text, Parameters)
end

function Localization:T(Key: string, Parameters: { [string]: any }?): string
    return self:Translate(Key, Parameters)
end

local function GetTextInstance(Target: any): TextLabel | TextButton | TextBox?
    if typeof(Target) == "Instance" then
        if Target:IsA("TextLabel") or Target:IsA("TextButton") or Target:IsA("TextBox") then
            return Target
        end
        return nil
    end

    if typeof(Target) ~= "table" then
        return nil
    end

    local Candidate = Target.TextLabel or Target.TextInstance or Target.Base or Target.Button
    if
        typeof(Candidate) == "Instance"
        and (Candidate:IsA("TextLabel") or Candidate:IsA("TextButton") or Candidate:IsA("TextBox"))
    then
        return Candidate
    end

    return nil
end

local function ApplyAlignment(Self: any, Binding: any)
    local TextInstance = Binding.TextInstance
    if TextInstance and Binding.OriginalTextXAlignment then
        TextInstance.TextXAlignment = if Self:IsRightToLeft()
            then Enum.TextXAlignment.Right
            else Binding.OriginalTextXAlignment
    end
end

local function ApplyText(Self: any, Binding: any)
    local Target = Binding.Target
    if not Target then
        return false
    end

    local Text = Self:Translate(Binding.Key, ResolveParameters(Binding.Parameters))
    if typeof(Target) == "Instance" then
        if not Binding.TextInstance then
            return false
        end

        Target.Text = Text
        ApplyAlignment(Self, Binding)
        return true
    end

    if typeof(Target.SetText) == "function" then
        Target:SetText(Text)
        ApplyAlignment(Self, Binding)
        return true
    end

    if Target.Text ~= nil then
        Target.Text = Text
        ApplyAlignment(Self, Binding)
        return true
    end

    return false
end

function Localization:BindText(
    Target: any,
    Key: string,
    Parameters: { [string]: any } | () -> { [string]: any }?
): Binding
    assert(not self.Destroyed, "Localization has been destroyed")
    assert(typeof(Key) == "string", "Localization key must be a string")

    local Binding: any = {
        Target = Target,
        Key = Key,
        Parameters = Parameters,
        Connected = true,
    }

    Binding.TextInstance = GetTextInstance(Target)
    if Binding.TextInstance then
        Binding.OriginalTextXAlignment = Binding.TextInstance.TextXAlignment
    end

    function Binding:Update()
        if Binding.Connected then
            ApplyText(self._Localization, Binding)
        end
    end

    function Binding:Disconnect()
        if not Binding.Connected then
            return
        end
        Binding.Connected = false
        local Index = table.find(self._Localization.Bindings, Binding)
        if Index then
            table.remove(self._Localization.Bindings, Index)
        end
    end

    Binding._Localization = self
    table.insert(self.Bindings, Binding)
    Binding:Update()
    return Binding
end

function Localization:OnChanged(Callback: (Locale: string) -> ()): Connection
    assert(typeof(Callback) == "function", "Localization callback must be a function")

    local Connection: any = {
        Connected = true,
        Callback = Callback,
        _Localization = self,
    }

    function Connection:Disconnect()
        if not Connection.Connected then
            return
        end
        Connection.Connected = false
        local Index = table.find(Connection._Localization.Callbacks, Connection)
        if Index then
            table.remove(Connection._Localization.Callbacks, Index)
        end
    end

    table.insert(self.Callbacks, Connection)
    return Connection
end

function Localization:SetLocale(Locale: string): boolean
    assert(typeof(Locale) == "string" and Locale ~= "", "Locale must be a non-empty string")
    Locale = NormalizeLocale(Locale)
    if not self:HasLocale(Locale) then
        return false
    end

    self.Locale = Locale

    for Index = #self.Bindings, 1, -1 do
        local Binding = self.Bindings[Index]
        if Binding and Binding.Connected then
            Binding:Update()
        else
            table.remove(self.Bindings, Index)
        end
    end

    for _, Connection in self.Callbacks do
        if Connection.Connected then
            pcall(Connection.Callback, Locale)
        end
    end

    return true
end

function Localization:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    table.clear(self.Bindings)
    table.clear(self.Callbacks)
    table.clear(self.Locales)
end

return Localization
