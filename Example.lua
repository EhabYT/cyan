-- Cyan key-gated settings example.
-- For a Wally/Roblox project, prefer `require(Packages.Cyan)` as documented in README.md.
-- This direct loader is retained for environments that explicitly support game:HttpGet and loadstring.

local repo = "https://raw.githubusercontent.com/EhabYT/cyan/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local KeySystem = loadstring(game:HttpGet(repo .. "addons/KeySystem.lua"))()
local Localization = loadstring(game:HttpGet(repo .. "addons/Localization.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false -- Forces AddToggle to AddCheckbox
Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)

-- CyanLogo is bundled in assets/ and loaded through Cyan's custom asset manager.
local CyanLogo = Library.ImageManager.GetAsset("CyanLogo")

local I18n = Localization.new({
    DefaultLocale = "en",
    Locales = {
        en = {
            ["window.title"] = "Cyan",
            ["window.footer"] = "version: example",
            ["window.search"] = "Search",
            ["login.prompt"] = "Enter `EB` to access the example menu.",
            ["login.placeholder"] = "Access key",
            ["login.success.title"] = "Access granted",
            ["login.success.description"] = "The validator callback accepted the submitted key.",
            ["login.idle"] = "Status: waiting for a key",
            ["login.checking"] = "Checking key...",
            ["login.verified"] = "Access granted.",
            ["login.rejected_prefix"] = "Access denied: ",
            ["login.locked"] = "Access is locked. Reset before trying again.",
            ["login.logged_out"] = "Status: logged out",
            ["login.reset"] = "Reset key entry",
            ["login.invalid"] = "That demo key is not valid",
            ["settings.description"] = "Personalize the Cyan interface, motion, and display settings.",
            ["settings.focus_search"] = "Focus search (Ctrl+K)",
            ["settings.clear_search"] = "Clear search",
            ["settings.logout"] = "Log out",
            ["settings.language"] = "Language",
            ["settings.show_search"] = "Show Search",
            ["settings.keybind_menu"] = "Open Keybind Menu",
            ["settings.custom_cursor"] = "Custom Cursor",
            ["settings.reduce_motion"] = "Reduce Motion",
            ["settings.liquid_glass"] = "Liquid Glass",
            ["settings.glass_transparency"] = "Glass Transparency",
            ["settings.glass_preset"] = "Glass Preset",
            ["settings.animate_glass"] = "Animate Glass",
            ["settings.glass_sheen_speed"] = "Glass Sheen Speed",
            ["settings.animate_background"] = "Animate Background",
            ["settings.background_motion_speed"] = "Background Motion Speed",
            ["settings.glass_blur"] = "Glass Blur",
            ["settings.glass_blur_size"] = "Glass Blur Size",
            ["settings.notification_side"] = "Notification Side",
            ["settings.dpi_scale"] = "DPI Scale",
            ["settings.mobile_layout"] = "Mobile Layout",
            ["settings.swipe_tabs"] = "Swipe Between Tabs",
            ["settings.swipe_threshold"] = "Swipe Threshold",
            ["settings.corner_radius"] = "Corner Radius",
            ["settings.menu_bind"] = "Menu bind",
            ["settings.unload"] = "Unload",
            ["tabs.key"] = "Key System",
            ["tabs.settings"] = "UI Settings",
            ["settings.group_title"] = "Cyan Menu",
            ["command.settings.title"] = "Open UI Settings",
            ["command.settings.description"] = "Change theme, language, glass, and mobile options.",
            ["command.reset_layout.title"] = "Reset menu layout",
            ["command.reset_layout.description"] = "Center the menu and restore its default position.",
            ["command.close.title"] = "Close menu",
            ["command.close.description"] = "Hide the Cyan menu.",
            ["save.group"] = "Configuration",
            ["save.persistence_unavailable"] = "Configuration persistence is unavailable: {reason}",
            ["save.cancel"] = "Cancel",
            ["save.config_name"] = "Config name",
            ["save.create_config"] = "Create config",
            ["save.config_list"] = "Config list",
            ["save.load_config"] = "Load config",
            ["save.overwrite_config"] = "Overwrite config",
            ["save.rename_config"] = "Rename config",
            ["save.delete_config"] = "Delete config",
            ["save.refresh_list"] = "Refresh list",
            ["save.set_autoload"] = "Set as autoload",
            ["save.reset_autoload"] = "Reset autoload",
            ["save.current_autoload"] = "Current autoload config: {name}",
            ["save.autoload_suffix"] = "{name} (autoload)",
            ["theme.group"] = "Themes",
            ["theme.persistence_unavailable"] = "Theme persistence is unavailable: {reason}",
            ["theme.cancel"] = "Cancel",
            ["theme.background_color"] = "Background color",
            ["theme.main_color"] = "Main color",
            ["theme.accent_color"] = "Accent color",
            ["theme.outline_color"] = "Outline color",
            ["theme.font_color"] = "Font color",
            ["theme.font_face"] = "Font Face",
            ["theme.background_image"] = "Background Image",
            ["theme.theme_list"] = "Theme list",
            ["theme.set_default"] = "Set as default",
            ["theme.custom_theme_name"] = "Custom theme name",
            ["theme.create_theme"] = "Create theme",
            ["theme.custom_themes"] = "Custom themes",
            ["theme.load_theme"] = "Load theme",
            ["theme.overwrite_theme"] = "Overwrite theme",
            ["theme.delete_theme"] = "Delete theme",
            ["theme.refresh_list"] = "Refresh list",
            ["theme.reset_default"] = "Reset default",
            ["theme.current_default"] = "Current default theme: {name}",
            ["theme.default_suffix"] = "{name} (default)",
            ["save.config_exists"] = "Config already exists",
            ["save.config_exists_description"] = "A config named {name} already exists. Overwriting will replace it with your current settings.",
            ["save.overwrite"] = "Overwrite",
            ["save.overwrite_config_title"] = "Overwrite config",
            ["save.overwrite_config_description"] = "Are you sure you want to overwrite {name} with your current settings? This cannot be undone.",
            ["save.delete_config_title"] = "Delete config",
            ["save.delete_config_description"] = "Are you sure you want to delete {name}? This cannot be undone.",
            ["save.delete"] = "Delete",
            ["save.reset_autoload_title"] = "Reset autoload config",
            ["save.reset_autoload_description"] = "Are you sure you want to clear the autoload config? No config will be loaded automatically on next launch.",
            ["save.reset"] = "Reset",
            ["theme.theme_exists"] = "Theme already exists",
            ["theme.theme_exists_description"] = "A custom theme named {name} already exists. Overwriting it will replace it with your current colors.",
            ["theme.overwrite"] = "Overwrite",
            ["theme.overwrite_theme_title"] = "Overwrite theme",
            ["theme.overwrite_theme_description"] = "Are you sure you want to overwrite {name} with your current colors? This cannot be undone.",
            ["theme.delete_theme_title"] = "Delete theme",
            ["theme.delete_theme_description"] = "Are you sure you want to delete {name}? This cannot be undone.",
            ["theme.delete"] = "Delete",
            ["theme.reset_default_title"] = "Reset default theme",
            ["theme.reset_default_description"] = "Are you sure you want to clear the default theme? The library will revert to its built-in default on next load.",
            ["theme.reset"] = "Reset",
            ["library.SearchPlaceholder"] = "Search",
            ["library.CommandSearchPlaceholder"] = "Search commands...",
            ["library.NoCommandsFound"] = "No commands found",
            ["library.DropdownSearchPlaceholder"] = "Search...",
            ["library.KeyPlaceholder"] = "Access key",
            ["library.KeySubmit"] = "Execute",
            ["library.KeyVerified"] = "Verified",
            ["library.DoubleClickConfirmation"] = "Are you sure?",
        },
        de = {
            ["window.title"] = "Cyan",
            ["window.footer"] = "Version: Beispiel",
            ["window.search"] = "Suchen",
            ["login.prompt"] = "Gib `EB` ein, um das Beispielmenü zu öffnen.",
            ["login.placeholder"] = "Zugangsschlüssel",
            ["login.success.title"] = "Zugriff erlaubt",
            ["login.success.description"] = "Der Validator hat den Schlüssel akzeptiert.",
            ["login.idle"] = "Status: Warte auf einen Schlüssel",
            ["login.checking"] = "Schlüssel wird geprüft...",
            ["login.verified"] = "Zugriff erlaubt.",
            ["login.rejected_prefix"] = "Zugriff verweigert: ",
            ["login.locked"] = "Der Zugang ist gesperrt. Setze ihn vor einem weiteren Versuch zurück.",
            ["login.logged_out"] = "Status: abgemeldet",
            ["login.reset"] = "Schlüsseleingabe zurücksetzen",
            ["login.invalid"] = "Dieser Beispielschlüssel ist ungültig",
            ["settings.description"] = "Passe die Cyan-Oberfläche, Bewegungen und Anzeigeeinstellungen an.",
            ["settings.focus_search"] = "Suche fokussieren (Strg+K)",
            ["settings.clear_search"] = "Suche leeren",
            ["settings.logout"] = "Abmelden",
            ["settings.language"] = "Sprache",
            ["settings.show_search"] = "Suche anzeigen",
            ["settings.keybind_menu"] = "Tastenkürzel-Menü öffnen",
            ["settings.custom_cursor"] = "Benutzerdefinierter Cursor",
            ["settings.reduce_motion"] = "Bewegung reduzieren",
            ["settings.liquid_glass"] = "Liquid Glass",
            ["settings.glass_transparency"] = "Glas-Transparenz",
            ["settings.glass_preset"] = "Glas-Voreinstellung",
            ["settings.animate_glass"] = "Glas animieren",
            ["settings.glass_sheen_speed"] = "Geschwindigkeit des Glanzes",
            ["settings.animate_background"] = "Hintergrund animieren",
            ["settings.background_motion_speed"] = "Geschwindigkeit der Hintergrundbewegung",
            ["settings.glass_blur"] = "Glas-Unschärfe",
            ["settings.glass_blur_size"] = "Stärke der Glas-Unschärfe",
            ["settings.notification_side"] = "Benachrichtigungsseite",
            ["settings.dpi_scale"] = "DPI-Skalierung",
            ["settings.mobile_layout"] = "Mobiles Layout",
            ["settings.swipe_tabs"] = "Zwischen Tabs wischen",
            ["settings.swipe_threshold"] = "Wischschwelle",
            ["settings.corner_radius"] = "Eckenradius",
            ["settings.menu_bind"] = "Menü-Taste",
            ["settings.unload"] = "Entladen",
            ["tabs.key"] = "Schlüsselsystem",
            ["tabs.settings"] = "UI-Einstellungen",
            ["settings.group_title"] = "Cyan-Menü",
            ["command.settings.title"] = "UI-Einstellungen öffnen",
            ["command.settings.description"] = "Thema, Sprache, Glas und mobile Optionen ändern.",
            ["command.reset_layout.title"] = "Menülayout zurücksetzen",
            ["command.reset_layout.description"] = "Das Menü zentrieren und seine Standardposition wiederherstellen.",
            ["command.close.title"] = "Menü schließen",
            ["command.close.description"] = "Cyan-Menü ausblenden.",
            ["save.group"] = "Konfiguration",
            ["save.persistence_unavailable"] = "Konfigurationsspeicherung ist nicht verfügbar: {reason}",
            ["save.cancel"] = "Abbrechen",
            ["save.config_name"] = "Konfigurationsname",
            ["save.create_config"] = "Konfiguration erstellen",
            ["save.config_list"] = "Konfigurationsliste",
            ["save.load_config"] = "Konfiguration laden",
            ["save.overwrite_config"] = "Konfiguration überschreiben",
            ["save.rename_config"] = "Konfiguration umbenennen",
            ["save.delete_config"] = "Konfiguration löschen",
            ["save.refresh_list"] = "Liste aktualisieren",
            ["save.set_autoload"] = "Als Autoload festlegen",
            ["save.reset_autoload"] = "Autoload zurücksetzen",
            ["save.current_autoload"] = "Aktuelle Autoload-Konfiguration: {name}",
            ["save.autoload_suffix"] = "{name} (Autoload)",
            ["theme.group"] = "Themes",
            ["theme.persistence_unavailable"] = "Theme-Speicherung ist nicht verfügbar: {reason}",
            ["theme.cancel"] = "Abbrechen",
            ["theme.background_color"] = "Hintergrundfarbe",
            ["theme.main_color"] = "Hauptfarbe",
            ["theme.accent_color"] = "Akzentfarbe",
            ["theme.outline_color"] = "Umrissfarbe",
            ["theme.font_color"] = "Schriftfarbe",
            ["theme.font_face"] = "Schriftart",
            ["theme.background_image"] = "Hintergrundbild",
            ["theme.theme_list"] = "Themenliste",
            ["theme.set_default"] = "Als Standard festlegen",
            ["theme.custom_theme_name"] = "Name des benutzerdefinierten Themes",
            ["theme.create_theme"] = "Theme erstellen",
            ["theme.custom_themes"] = "Benutzerdefinierte Themes",
            ["theme.load_theme"] = "Theme laden",
            ["theme.overwrite_theme"] = "Theme überschreiben",
            ["theme.delete_theme"] = "Theme löschen",
            ["theme.refresh_list"] = "Liste aktualisieren",
            ["theme.reset_default"] = "Standard zurücksetzen",
            ["theme.current_default"] = "Aktuelles Standard-Theme: {name}",
            ["theme.default_suffix"] = "{name} (Standard)",
            ["save.config_exists"] = "Konfiguration existiert bereits",
            ["save.config_exists_description"] = "Eine Konfiguration namens {name} existiert bereits. Beim Überschreiben wird sie durch deine aktuellen Einstellungen ersetzt.",
            ["save.overwrite"] = "Überschreiben",
            ["save.overwrite_config_title"] = "Konfiguration überschreiben",
            ["save.overwrite_config_description"] = "Möchtest du {name} wirklich mit deinen aktuellen Einstellungen überschreiben? Dies kann nicht rückgängig gemacht werden.",
            ["save.delete_config_title"] = "Konfiguration löschen",
            ["save.delete_config_description"] = "Möchtest du {name} wirklich löschen? Dies kann nicht rückgängig gemacht werden.",
            ["save.delete"] = "Löschen",
            ["save.reset_autoload_title"] = "Autoload-Konfiguration zurücksetzen",
            ["save.reset_autoload_description"] = "Möchtest du die Autoload-Konfiguration wirklich löschen? Beim nächsten Start wird keine Konfiguration automatisch geladen.",
            ["save.reset"] = "Zurücksetzen",
            ["theme.theme_exists"] = "Theme existiert bereits",
            ["theme.theme_exists_description"] = "Ein benutzerdefiniertes Theme namens {name} existiert bereits. Beim Überschreiben wird es durch deine aktuellen Farben ersetzt.",
            ["theme.overwrite"] = "Überschreiben",
            ["theme.overwrite_theme_title"] = "Theme überschreiben",
            ["theme.overwrite_theme_description"] = "Möchtest du {name} wirklich mit deinen aktuellen Farben überschreiben? Dies kann nicht rückgängig gemacht werden.",
            ["theme.delete_theme_title"] = "Theme löschen",
            ["theme.delete_theme_description"] = "Möchtest du {name} wirklich löschen? Dies kann nicht rückgängig gemacht werden.",
            ["theme.delete"] = "Löschen",
            ["theme.reset_default_title"] = "Standard-Theme zurücksetzen",
            ["theme.reset_default_description"] = "Möchtest du das Standard-Theme wirklich löschen? Beim nächsten Laden wird das integrierte Standard-Theme verwendet.",
            ["theme.reset"] = "Zurücksetzen",
            ["library.SearchPlaceholder"] = "Suchen",
            ["library.CommandSearchPlaceholder"] = "Befehle suchen...",
            ["library.NoCommandsFound"] = "Keine Befehle gefunden",
            ["library.DropdownSearchPlaceholder"] = "Suchen...",
            ["library.KeyPlaceholder"] = "Zugangsschlüssel",
            ["library.KeySubmit"] = "Ausführen",
            ["library.KeyVerified"] = "Verifiziert",
            ["library.DoubleClickConfirmation"] = "Bist du sicher?",
        },
        ar = {
            ["window.title"] = "سيان",
            ["window.footer"] = "إصدار: مثال",
            ["window.search"] = "بحث",
            ["login.prompt"] = "أدخل `EB` لفتح قائمة المثال.",
            ["login.placeholder"] = "مفتاح الدخول",
            ["login.success.title"] = "تم السماح بالدخول",
            ["login.success.description"] = "تم قبول المفتاح بواسطة نظام التحقق.",
            ["login.idle"] = "الحالة: في انتظار مفتاح",
            ["login.checking"] = "جارٍ التحقق من المفتاح...",
            ["login.verified"] = "تم السماح بالدخول.",
            ["login.rejected_prefix"] = "تم رفض الدخول: ",
            ["login.locked"] = "تم قفل الدخول. أعد التعيين قبل المحاولة مرة أخرى.",
            ["login.logged_out"] = "الحالة: تم تسجيل الخروج",
            ["login.reset"] = "إعادة تعيين إدخال المفتاح",
            ["login.invalid"] = "مفتاح المثال غير صالح",
            ["settings.description"] = "خصّص واجهة Cyan والحركة وإعدادات العرض.",
            ["settings.focus_search"] = "تركيز البحث (Ctrl+K)",
            ["settings.clear_search"] = "مسح البحث",
            ["settings.logout"] = "تسجيل الخروج",
            ["settings.language"] = "اللغة",
            ["settings.show_search"] = "إظهار البحث",
            ["settings.keybind_menu"] = "فتح قائمة اختصارات لوحة المفاتيح",
            ["settings.custom_cursor"] = "مؤشر مخصص",
            ["settings.reduce_motion"] = "تقليل الحركة",
            ["settings.liquid_glass"] = "زجاج سائل",
            ["settings.glass_transparency"] = "شفافية الزجاج",
            ["settings.glass_preset"] = "النمط الزجاجي",
            ["settings.animate_glass"] = "تحريك الزجاج",
            ["settings.glass_sheen_speed"] = "سرعة لمعان الزجاج",
            ["settings.animate_background"] = "تحريك الخلفية",
            ["settings.background_motion_speed"] = "سرعة حركة الخلفية",
            ["settings.glass_blur"] = "تمويه الزجاج",
            ["settings.glass_blur_size"] = "شدة تمويه الزجاج",
            ["settings.notification_side"] = "موضع الإشعارات",
            ["settings.dpi_scale"] = "مقياس DPI",
            ["settings.mobile_layout"] = "تخطيط الهاتف",
            ["settings.swipe_tabs"] = "السحب بين علامات التبويب",
            ["settings.swipe_threshold"] = "حد السحب",
            ["settings.corner_radius"] = "استدارة الزوايا",
            ["settings.menu_bind"] = "اختصار القائمة",
            ["settings.unload"] = "إلغاء التحميل",
            ["tabs.key"] = "نظام المفاتيح",
            ["tabs.settings"] = "إعدادات الواجهة",
            ["settings.group_title"] = "قائمة Cyan",
            ["command.settings.title"] = "فتح إعدادات الواجهة",
            ["command.settings.description"] = "غيّر الثيم واللغة والزجاج وإعدادات الهاتف.",
            ["command.reset_layout.title"] = "إعادة تعيين تخطيط القائمة",
            ["command.reset_layout.description"] = "وسّط القائمة واستعد موضعها الافتراضي.",
            ["command.close.title"] = "إغلاق القائمة",
            ["command.close.description"] = "إخفاء قائمة Cyan.",
            ["save.group"] = "الإعدادات المحفوظة",
            ["save.persistence_unavailable"] = "حفظ الإعدادات غير متاح: {reason}",
            ["save.cancel"] = "إلغاء",
            ["save.config_name"] = "اسم الإعداد",
            ["save.create_config"] = "إنشاء إعداد",
            ["save.config_list"] = "قائمة الإعدادات",
            ["save.load_config"] = "تحميل الإعداد",
            ["save.overwrite_config"] = "استبدال الإعداد",
            ["save.rename_config"] = "إعادة تسمية الإعداد",
            ["save.delete_config"] = "حذف الإعداد",
            ["save.refresh_list"] = "تحديث القائمة",
            ["save.set_autoload"] = "تعيين للتحميل التلقائي",
            ["save.reset_autoload"] = "إعادة تعيين التحميل التلقائي",
            ["save.current_autoload"] = "إعداد التحميل التلقائي الحالي: {name}",
            ["save.autoload_suffix"] = "{name} (تحميل تلقائي)",
            ["theme.group"] = "المظاهر",
            ["theme.persistence_unavailable"] = "حفظ المظهر غير متاح: {reason}",
            ["theme.cancel"] = "إلغاء",
            ["theme.background_color"] = "لون الخلفية",
            ["theme.main_color"] = "اللون الرئيسي",
            ["theme.accent_color"] = "لون التمييز",
            ["theme.outline_color"] = "لون الحدود",
            ["theme.font_color"] = "لون الخط",
            ["theme.font_face"] = "نوع الخط",
            ["theme.background_image"] = "صورة الخلفية",
            ["theme.theme_list"] = "قائمة المظاهر",
            ["theme.set_default"] = "تعيين كافتراضي",
            ["theme.custom_theme_name"] = "اسم المظهر المخصص",
            ["theme.create_theme"] = "إنشاء مظهر",
            ["theme.custom_themes"] = "المظاهر المخصصة",
            ["theme.load_theme"] = "تحميل المظهر",
            ["theme.overwrite_theme"] = "استبدال المظهر",
            ["theme.delete_theme"] = "حذف المظهر",
            ["theme.refresh_list"] = "تحديث القائمة",
            ["theme.reset_default"] = "إعادة تعيين الافتراضي",
            ["theme.current_default"] = "المظهر الافتراضي الحالي: {name}",
            ["theme.default_suffix"] = "{name} (افتراضي)",
            ["save.config_exists"] = "الإعداد موجود بالفعل",
            ["save.config_exists_description"] = "يوجد إعداد باسم {name} بالفعل. الاستبدال سيضع إعداداتك الحالية مكانه.",
            ["save.overwrite"] = "استبدال",
            ["save.overwrite_config_title"] = "استبدال الإعداد",
            ["save.overwrite_config_description"] = "هل تريد استبدال {name} بإعداداتك الحالية؟ لا يمكن التراجع عن هذا الإجراء.",
            ["save.delete_config_title"] = "حذف الإعداد",
            ["save.delete_config_description"] = "هل تريد حذف {name}؟ لا يمكن التراجع عن هذا الإجراء.",
            ["save.delete"] = "حذف",
            ["save.reset_autoload_title"] = "إعادة تعيين إعداد التحميل التلقائي",
            ["save.reset_autoload_description"] = "هل تريد مسح إعداد التحميل التلقائي؟ لن يتم تحميل أي إعداد تلقائيًا عند التشغيل التالي.",
            ["save.reset"] = "إعادة تعيين",
            ["theme.theme_exists"] = "المظهر موجود بالفعل",
            ["theme.theme_exists_description"] = "يوجد مظهر مخصص باسم {name} بالفعل. الاستبدال سيضع ألوانك الحالية مكانه.",
            ["theme.overwrite"] = "استبدال",
            ["theme.overwrite_theme_title"] = "استبدال المظهر",
            ["theme.overwrite_theme_description"] = "هل تريد استبدال {name} بألوانك الحالية؟ لا يمكن التراجع عن هذا الإجراء.",
            ["theme.delete_theme_title"] = "حذف المظهر",
            ["theme.delete_theme_description"] = "هل تريد حذف {name}؟ لا يمكن التراجع عن هذا الإجراء.",
            ["theme.delete"] = "حذف",
            ["theme.reset_default_title"] = "إعادة تعيين المظهر الافتراضي",
            ["theme.reset_default_description"] = "هل تريد مسح المظهر الافتراضي؟ ستعود المكتبة إلى المظهر المدمج عند التحميل التالي.",
            ["theme.reset"] = "إعادة تعيين",
            ["library.SearchPlaceholder"] = "بحث",
            ["library.CommandSearchPlaceholder"] = "البحث في الأوامر...",
            ["library.NoCommandsFound"] = "لم يتم العثور على أوامر",
            ["library.DropdownSearchPlaceholder"] = "بحث...",
            ["library.KeyPlaceholder"] = "مفتاح الدخول",
            ["library.KeySubmit"] = "تنفيذ",
            ["library.KeyVerified"] = "تم التحقق",
            ["library.DoubleClickConfirmation"] = "هل أنت متأكد؟",
        },
    },
})

SaveManager:SetLocalization(I18n, "save")
ThemeManager:SetLocalization(I18n, "theme")
Library:SetLocalization(I18n, "library")

local Window = Library:CreateWindow({
    -- Set Center to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Set Resizable to true if you want to have in-game resizable Window
    -- Set MobileButtonsSide to "Left" or "Right" if you want the ui toggle & lock buttons to be on the left or right side of the window
    -- Set ShowCustomCursor to false if you don't want to use the Linoria cursor
    -- NotifySide = Changes the side of the notifications (Left, Right) (Default value = Left)
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = I18n:T("window.title"),
    Icon = CyanLogo,
    IconSize = UDim2.fromOffset(32, 32),
    Footer = I18n:T("window.footer"),
    NotifySide = "Right",
    ShowCustomCursor = true,
    -- Open explicitly after the key gate is attached. This avoids depending on deferred AutoShow behavior.
    AutoShow = false,
})

Window:AddHeaderButton({
    Text = "R",
    Tooltip = "Reset menu position",
    Visible = not Library.IsMobile,
}, function()
    Window:ResetPosition()
end)

Window:AddHeaderButton({
    Text = "S",
    Tooltip = "Toggle compact sidebar",
    Visible = not Library.IsMobile,
}, function()
    Window:ToggleSidebar()
end)

Window:AddHeaderButton({
    Text = "F",
    Tooltip = "Focus search",
    Visible = not Library.IsMobile,
}, function()
    Window:FocusSearch()
end)

Window:SetSearchPlaceholder(I18n:T("window.search"))

local Tabs = {
    Key = Window:AddKeyTab(I18n:T("tabs.key")),
    ["UI Settings"] = Window:AddTab(I18n:T("tabs.settings"), "settings"),
}

Window:AddHeaderButton({
    Text = "P",
    Tooltip = "Command palette (Ctrl+P)",
    Visible = not Library.IsMobile,
}, function()
    Window:OpenCommandPalette()
end)

local SettingsCommand = Window:AddCommand("settings", {
    Title = I18n:T("command.settings.title"),
    Description = I18n:T("command.settings.description"),
    Keywords = "theme glass language mobile",
    Order = 1,
    Callback = function()
        Window:SelectTab("UI Settings")
    end,
})
local ResetLayoutCommand = Window:AddCommand("reset-layout", {
    Title = I18n:T("command.reset_layout.title"),
    Description = I18n:T("command.reset_layout.description"),
    Keywords = "position center layout",
    Order = 2,
    Callback = function()
        Window:ResetPosition()
    end,
})
local CloseCommand = Window:AddCommand("close", {
    Title = I18n:T("command.close.title"),
    Description = I18n:T("command.close.description"),
    Keywords = "hide exit",
    Order = 3,
    Callback = function()
        Window:Close()
    end,
})

-- The protected interface below only contains Cyan menu, accessibility, display,
-- theme, and configuration settings.

-- Callback-driven key system. This demo validator is intentionally local and not secure;
-- production experiences must verify entitlement on a trusted server or backend.
local DemoKeySystem = KeySystem.new({
    Validate = function(ReceivedKey)
        if ReceivedKey == "EB" then
            return true, "Demo access granted"
        end

        return false, I18n:T("login.invalid")
    end,
    MaxAttempts = 5,
    CooldownSeconds = 1,
    OnVerified = function()
        Library:Notify({
            Title = I18n:T("login.success.title"),
            Description = I18n:T("login.success.description"),
            Time = 4,
        })
    end,
})

-- Show the access tab first. UI Settings becomes available only after verification.
DemoKeySystem:GateTabs(Tabs.Key, {
    Tabs["UI Settings"],
}, {
    DefaultTab = Tabs["UI Settings"],
    HideLoginTabAfterVerification = true,
    HideSearchBeforeVerification = true,
})

local DemoKeyUI = DemoKeySystem:Attach(Tabs.Key, {
    Prompt = I18n:T("login.prompt"),
    Placeholder = I18n:T("login.placeholder"),
    IdleText = I18n:T("login.idle"),
    CheckingText = I18n:T("login.checking"),
    VerifiedText = I18n:T("login.verified"),
    RejectedPrefix = I18n:T("login.rejected_prefix"),
    LockedText = I18n:T("login.locked"),
    LoggedOutText = I18n:T("login.logged_out"),
    ResetText = I18n:T("login.reset"),
})

local function ApplyLocale()
    Window:ChangeTitle(I18n:T("window.title"))
    Window:SetFooter(I18n:T("window.footer"))
    Window:SetSearchPlaceholder(I18n:T("window.search"))
    DemoKeyUI:UpdateText({
        Prompt = I18n:T("login.prompt"),
        Placeholder = I18n:T("login.placeholder"),
        IdleText = I18n:T("login.idle"),
        CheckingText = I18n:T("login.checking"),
        VerifiedText = I18n:T("login.verified"),
        RejectedPrefix = I18n:T("login.rejected_prefix"),
        LockedText = I18n:T("login.locked"),
        LoggedOutText = I18n:T("login.logged_out"),
        ResetText = I18n:T("login.reset"),
    })

    SettingsCommand:SetText(I18n:T("command.settings.title"))
    SettingsCommand:SetDescription(I18n:T("command.settings.description"))
    ResetLayoutCommand:SetText(I18n:T("command.reset_layout.title"))
    ResetLayoutCommand:SetDescription(I18n:T("command.reset_layout.description"))
    CloseCommand:SetText(I18n:T("command.close.title"))
    CloseCommand:SetDescription(I18n:T("command.close.description"))
end
I18n:OnChanged(ApplyLocale)

-- UI Settings
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox(I18n:T("settings.group_title"), "wrench")
local SettingsDescription = MenuGroup:AddLabel(I18n:T("settings.description"), true)
MenuGroup:AddDivider()

local FocusSearchButton = MenuGroup:AddButton(I18n:T("settings.focus_search"), function()
    Window:FocusSearch()
end)

local ClearSearchButton = MenuGroup:AddButton(I18n:T("settings.clear_search"), function()
    Window:ClearSearch()
end)

local LogoutButton = MenuGroup:AddButton(I18n:T("settings.logout"), function()
    if not DemoKeySystem:Logout() then
        Library:Notify("No verified login session is active.")
    end
end)

MenuGroup:AddDropdown("Language", {
    Text = I18n:T("settings.language"),
    Values = { "English", "Deutsch", "العربية" },
    Default = "English",
    AllowNull = false,
    Callback = function(Value)
        local Locale = ({
            English = "en",
            Deutsch = "de",
            ["العربية"] = "ar",
        })[Value]
        if Locale then
            I18n:SetLocale(Locale)
        end
    end,
})

MenuGroup:AddToggle("ShowSearch", {
    Text = I18n:T("settings.show_search"),
    Default = true,
    Callback = function(Value)
        Window:SetSearchVisible(Value)
    end,
})

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = I18n:T("settings.keybind_menu"),
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text = I18n:T("settings.custom_cursor"),
    Default = Library.ShowCustomCursor,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})
MenuGroup:AddToggle("ReducedMotion", {
    Text = I18n:T("settings.reduce_motion"),
    Default = Library.ReducedMotion,
    Tooltip = "Disables Cyan UI animations for a calmer, more accessible interface.",
    Callback = function(Value)
        Library:SetReducedMotion(Value)
    end,
})
MenuGroup:AddToggle("LiquidGlass", {
    Text = I18n:T("settings.liquid_glass"),
    Default = Library.GlassEnabled,
    Tooltip = "Applies Cyan translucent glass surfaces, gradients, and highlights.",
    Callback = function(Value)
        Window:SetGlass(Value)
    end,
})
MenuGroup:AddSlider("GlassTransparency", {
    Text = I18n:T("settings.glass_transparency"),
    Default = Library.GlassTransparency,
    Min = 0,
    Max = 0.85,
    Rounding = 2,
    Callback = function(Value)
        Window:SetGlass(Library.GlassEnabled, Value)
    end,
})
MenuGroup:AddDropdown("GlassPreset", {
    Text = I18n:T("settings.glass_preset"),
    Values = { "Liquid", "Crystal", "Frosted", "Ocean", "Aurora", "Midnight", "Solid" },
    Default = Window:GetGlassPreset(),
    AllowNull = false,
    Callback = function(Value)
        Window:SetGlassPreset(Value)
    end,
})
MenuGroup:AddToggle("GlassSheen", {
    Text = I18n:T("settings.animate_glass"),
    Default = true,
    Callback = function(Value)
        Window:SetGlassSheen(Value)
    end,
})
MenuGroup:AddSlider("GlassSheenSpeed", {
    Text = I18n:T("settings.glass_sheen_speed"),
    Default = 7,
    Min = 2,
    Max = 20,
    Rounding = 0,
    Callback = function(Value)
        Window:SetGlassSheen(Toggles.GlassSheen and Toggles.GlassSheen.Value or false, Value)
    end,
})
MenuGroup:AddToggle("GlassBackgroundMotion", {
    Text = I18n:T("settings.animate_background"),
    Default = true,
    Callback = function(Value)
        Window:SetGlassBackgroundMotion(Value)
    end,
})
MenuGroup:AddSlider("GlassBackgroundMotionSpeed", {
    Text = I18n:T("settings.background_motion_speed"),
    Default = 14,
    Min = 4,
    Max = 30,
    Rounding = 0,
    Callback = function(Value)
        Window:SetGlassBackgroundMotion(
            Toggles.GlassBackgroundMotion and Toggles.GlassBackgroundMotion.Value or false,
            Value
        )
    end,
})
MenuGroup:AddToggle("GlassBlur", {
    Text = I18n:T("settings.glass_blur"),
    Default = false,
    Tooltip = "Applies an optional scene blur while the menu is open.",
    Callback = function(Value)
        Window:SetGlassBlur(Value)
    end,
})
MenuGroup:AddSlider("GlassBlurSize", {
    Text = I18n:T("settings.glass_blur_size"),
    Default = 8,
    Min = 0,
    Max = 24,
    Rounding = 0,
    Callback = function(Value)
        Window:SetGlassBlur(Toggles.GlassBlur and Toggles.GlassBlur.Value or false, Value)
    end,
})
MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",

    Text = I18n:T("settings.notification_side"),

    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})
MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",

    Text = I18n:T("settings.dpi_scale"),

    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)

        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddDropdown("MobileLayout", {
    Text = I18n:T("settings.mobile_layout"),
    Values = { "Compact", "Balanced", "Expanded" },
    Default = Window:GetMobileLayout(),
    AllowNull = false,
    Visible = Library.IsMobile,
    Callback = function(Value)
        Window:SetMobileLayout(Value)
    end,
})

local SwipeEnabled, SwipeThreshold = Window:GetTabSwipeNavigation()
MenuGroup:AddToggle("TabSwipeNavigation", {
    Text = I18n:T("settings.swipe_tabs"),
    Default = SwipeEnabled,
    Visible = Library.IsMobile,
    Callback = function(Value)
        Window:SetTabSwipeNavigation(Value)
    end,
})
MenuGroup:AddSlider("TabSwipeThreshold", {
    Text = I18n:T("settings.swipe_threshold"),
    Default = SwipeThreshold,
    Min = 24,
    Max = 160,
    Rounding = 0,
    Visible = Library.IsMobile,
    Callback = function(Value)
        Window:SetTabSwipeNavigation(Toggles.TabSwipeNavigation and Toggles.TabSwipeNavigation.Value or false, Value)
    end,
})

MenuGroup:AddSlider("UICornerSlider", {
    Text = I18n:T("settings.corner_radius"),
    Default = Library.CornerRadius,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(value)
        Window:SetCornerRadius(value)
    end,
})

MenuGroup:AddDivider()
local MenuBindLabel = MenuGroup:AddLabel(I18n:T("settings.menu_bind"))
MenuBindLabel:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

local UnloadButton = MenuGroup:AddButton(I18n:T("settings.unload"), function()
    Library:Unload()
end)

local LocalizedSettingsElements = {
    { Tabs.Key, "tabs.key" },
    { Tabs["UI Settings"], "tabs.settings" },
    { MenuGroup, "settings.group_title" },
    { SettingsDescription, "settings.description" },
    { FocusSearchButton, "settings.focus_search" },
    { ClearSearchButton, "settings.clear_search" },
    { LogoutButton, "settings.logout" },
    { Options.Language, "settings.language" },
    { Toggles.ShowSearch, "settings.show_search" },
    { Toggles.KeybindMenuOpen, "settings.keybind_menu" },
    { Toggles.ShowCustomCursor, "settings.custom_cursor" },
    { Toggles.ReducedMotion, "settings.reduce_motion" },
    { Toggles.LiquidGlass, "settings.liquid_glass" },
    { Options.GlassTransparency, "settings.glass_transparency" },
    { Options.GlassPreset, "settings.glass_preset" },
    { Toggles.GlassSheen, "settings.animate_glass" },
    { Options.GlassSheenSpeed, "settings.glass_sheen_speed" },
    { Toggles.GlassBackgroundMotion, "settings.animate_background" },
    { Options.GlassBackgroundMotionSpeed, "settings.background_motion_speed" },
    { Toggles.GlassBlur, "settings.glass_blur" },
    { Options.GlassBlurSize, "settings.glass_blur_size" },
    { Options.NotificationSide, "settings.notification_side" },
    { Options.DPIDropdown, "settings.dpi_scale" },
    { Options.MobileLayout, "settings.mobile_layout" },
    { Toggles.TabSwipeNavigation, "settings.swipe_tabs" },
    { Options.TabSwipeThreshold, "settings.swipe_threshold" },
    { Options.UICornerSlider, "settings.corner_radius" },
    { MenuBindLabel, "settings.menu_bind" },
    { UnloadButton, "settings.unload" },
}

for _, Entry in LocalizedSettingsElements do
    I18n:BindText(Entry[1], Entry[2])
end

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place") -- if the game has multiple places inside of it (for example: DOORS)
-- you can use this to save configs for those places separately
-- The path in this script would be: MyScriptHub/specific-game/settings/specific-place
-- [ This is optional ]

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs["UI Settings"])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs["UI Settings"])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

-- Show the access tab only after the login gate and all settings panels are ready.
Window:Open()
