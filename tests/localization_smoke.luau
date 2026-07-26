-- Standalone behavioral checks for Cyan.Localization.

local Localization = require("../addons/Localization")

local function Expect(Condition: boolean, Message: string)
    assert(Condition, Message)
end

local I18n = Localization.new({
    DefaultLocale = "en",
    Locales = {
        en = {
            greeting = "Hello, {name}!",
            fallback = "Fallback text",
        },
        ar = {
            greeting = "مرحبًا، {name}!",
        },
    },
})

Expect(I18n:T("greeting", { name = "Ehab" }) == "Hello, Ehab!", "default translation failed")
Expect(I18n:T("missing") == "missing", "missing key should fall back to itself")

local ChangedLocale = nil
I18n:OnChanged(function(Locale)
    ChangedLocale = Locale
end)
Expect(I18n:SetLocale("ar"), "Arabic locale should register")
Expect(ChangedLocale == "ar", "locale callback did not run")
Expect(I18n:IsRightToLeft(), "Arabic should be right-to-left")
Expect(I18n:T("greeting", { name = "إيهاب" }) == "مرحبًا، إيهاب!", "Arabic translation failed")
Expect(I18n:T("fallback") == "Fallback text", "default locale fallback failed")
Expect(not I18n:SetLocale("missing"), "unknown locale should be rejected")

local MockTarget = { Text = "" }
local Binding = I18n:BindText(MockTarget, "greeting", { name = "سارة" })
Expect(MockTarget.Text == "مرحبًا، سارة!", "binding did not set initial translated text")
I18n:SetLocale("en")
Expect(MockTarget.Text == "Hello, سارة!", "binding did not refresh after locale change")
Binding:Disconnect()
I18n:Destroy()

print("localization smoke checks: OK")
