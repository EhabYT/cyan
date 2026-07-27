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
            ["loading.title"] = "Welcome to Cyan",
            ["loading.message"] = "Preparing your experience",
            ["loading.description"] = "Please wait while the interface is loading.",
            ["loading.stage.welcome"] = "Welcome to Cyan",
            ["loading.greeting"] = "Welcome, {name}",
            ["loading.stage.welcome_description"] = "A rounded Liquid Glass interface, ready for you.",
            ["loading.stage.prepare"] = "Preparing your experience",
            ["loading.stage.prepare_description"] = "Loading language, appearance, and mobile preferences.",
            ["loading.stage.ready"] = "Everything is ready",
            ["loading.stage.ready_description"] = "Opening secure access now.",
            ["loading.badge.glass"] = "Liquid Glass",
            ["loading.badge.language"] = "Localized",
            ["loading.badge.mobile"] = "Mobile-ready",
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
            ["settings.reset_ui"] = "Restore UI defaults",
            ["settings.reset_ui_done"] = "Cyan interface defaults restored.",
            ["settings.appearance_group"] = "Appearance",
            ["settings.accessibility_group"] = "Accessibility",
            ["settings.mobile_group"] = "Mobile",
            ["settings.reset_mobile_position"] = "Reset mobile action position",
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
            ["library.MobileMenuLabel"] = "Menu",
            ["library.MobileMenuTooltip"] = "Tap to open or close the menu. Press and hold for the lock action.",
            ["library.MobileLockLabel"] = "Lock",
            ["library.MobileUnlockLabel"] = "Unlock",
            ["library.MobileLockTooltip"] = "Lock menu position",
            ["library.MobileLockActionTitle"] = "Menu lock",
            ["library.MobileMenuLocked"] = "Menu position locked",
            ["library.MobileMenuUnlocked"] = "Menu position unlocked",
        },
        de = {
            ["window.title"] = "Cyan",
            ["window.footer"] = "Version: Beispiel",
            ["window.search"] = "Suchen",
            ["loading.title"] = "Willkommen bei Cyan",
            ["loading.message"] = "Deine Oberfläche wird vorbereitet",
            ["loading.description"] = "Bitte warte, während die Oberfläche geladen wird.",
            ["loading.stage.welcome"] = "Willkommen bei Cyan",
            ["loading.greeting"] = "Willkommen, {name}",
            ["loading.stage.welcome_description"] = "Eine abgerundete Liquid-Glass-Oberfläche ist für dich bereit.",
            ["loading.stage.prepare"] = "Deine Oberfläche wird vorbereitet",
            ["loading.stage.prepare_description"] = "Sprache, Erscheinungsbild und mobile Einstellungen werden geladen.",
            ["loading.stage.ready"] = "Alles ist bereit",
            ["loading.stage.ready_description"] = "Der sichere Zugang wird geöffnet.",
            ["loading.badge.glass"] = "Liquid Glass",
            ["loading.badge.language"] = "Lokalisiert",
            ["loading.badge.mobile"] = "Mobil bereit",
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
            ["settings.reset_ui"] = "UI-Standard wiederherstellen",
            ["settings.reset_ui_done"] = "Cyan-Standardoberfläche wurde wiederhergestellt.",
            ["settings.appearance_group"] = "Darstellung",
            ["settings.accessibility_group"] = "Barrierefreiheit",
            ["settings.mobile_group"] = "Mobil",
            ["settings.reset_mobile_position"] = "Mobile Aktion zurücksetzen",
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
            ["library.MobileMenuLabel"] = "Menü",
            ["library.MobileMenuTooltip"] = "Tippen zum Öffnen oder Schließen. Gedrückt halten für die Sperre.",
            ["library.MobileLockLabel"] = "Sperren",
            ["library.MobileUnlockLabel"] = "Entsperren",
            ["library.MobileLockTooltip"] = "Menüposition sperren",
            ["library.MobileLockActionTitle"] = "Menüsperre",
            ["library.MobileMenuLocked"] = "Menüposition gesperrt",
            ["library.MobileMenuUnlocked"] = "Menüposition entsperrt",
        },
        ar = {
            ["window.title"] = "سيان",
            ["window.footer"] = "إصدار: مثال",
            ["window.search"] = "بحث",
            ["loading.title"] = "مرحبًا بك في سيان",
            ["loading.message"] = "يتم تجهيز واجهتك",
            ["loading.description"] = "يرجى الانتظار حتى يتم تحميل الواجهة.",
            ["loading.stage.welcome"] = "مرحبًا بك، {name}",
            ["loading.greeting"] = "مرحبًا بك، {name}",
            ["loading.stage.welcome_description"] = "واجهة Liquid Glass مستديرة وجاهزة لك.",
            ["loading.stage.prepare"] = "يتم تجهيز واجهتك",
            ["loading.stage.prepare_description"] = "يتم تحميل اللغة والمظهر وإعدادات الموبايل.",
            ["loading.stage.ready"] = "كل شيء جاهز",
            ["loading.stage.ready_description"] = "يتم فتح الوصول الآمن الآن.",
            ["loading.badge.glass"] = "Liquid Glass",
            ["loading.badge.language"] = "متعدد اللغات",
            ["loading.badge.mobile"] = "جاهز للموبايل",
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
            ["settings.reset_ui"] = "استعادة إعدادات الواجهة",
            ["settings.reset_ui_done"] = "تمت استعادة إعدادات واجهة سيان الافتراضية.",
            ["settings.appearance_group"] = "المظهر",
            ["settings.accessibility_group"] = "تسهيلات الاستخدام",
            ["settings.mobile_group"] = "الهاتف",
            ["settings.reset_mobile_position"] = "إعادة موضع زر الموبايل",
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
            ["library.MobileMenuLabel"] = "القائمة",
            ["library.MobileMenuTooltip"] = "اضغط لفتح أو إغلاق القائمة. اضغط مطولًا لخيار القفل.",
            ["library.MobileLockLabel"] = "قفل",
            ["library.MobileUnlockLabel"] = "إلغاء القفل",
            ["library.MobileLockTooltip"] = "قفل موضع القائمة",
            ["library.MobileLockActionTitle"] = "قفل القائمة",
            ["library.MobileMenuLocked"] = "تم قفل موضع القائمة",
            ["library.MobileMenuUnlocked"] = "تم إلغاء قفل موضع القائمة",
        },
    },
})

I18n:Register("fr", {
    ["window.title"] = "Cyan",
    ["window.footer"] = "version : exemple",
    ["window.search"] = "Rechercher",
    ["login.prompt"] = "Saisissez `EB` pour accéder au menu d’exemple.",
    ["login.placeholder"] = "Clé d’accès",
    ["login.success.title"] = "Accès autorisé",
    ["login.success.description"] = "Le validateur a accepté la clé envoyée.",
    ["login.idle"] = "État : en attente d’une clé",
    ["login.checking"] = "Vérification de la clé...",
    ["login.verified"] = "Accès autorisé.",
    ["login.rejected_prefix"] = "Accès refusé : ",
    ["login.locked"] = "L’accès est verrouillé. Réinitialisez-le avant de réessayer.",
    ["login.logged_out"] = "État : déconnecté",
    ["login.reset"] = "Réinitialiser la saisie de clé",
    ["login.invalid"] = "Cette clé d’exemple n’est pas valide",
    ["settings.description"] = "Personnalisez l’interface Cyan, les mouvements et l’affichage.",
    ["settings.focus_search"] = "Rechercher (Ctrl+K)",
    ["settings.clear_search"] = "Effacer la recherche",
    ["settings.logout"] = "Se déconnecter",
    ["settings.language"] = "Langue",
    ["settings.show_search"] = "Afficher la recherche",
    ["settings.keybind_menu"] = "Ouvrir le menu des raccourcis",
    ["settings.custom_cursor"] = "Curseur personnalisé",
    ["settings.reduce_motion"] = "Réduire les mouvements",
    ["settings.liquid_glass"] = "Verre liquide",
    ["settings.glass_transparency"] = "Transparence du verre",
    ["settings.glass_preset"] = "Préréglage du verre",
    ["settings.animate_glass"] = "Animer le verre",
    ["settings.glass_sheen_speed"] = "Vitesse de brillance",
    ["settings.animate_background"] = "Animer l’arrière-plan",
    ["settings.background_motion_speed"] = "Vitesse de l’arrière-plan",
    ["settings.glass_blur"] = "Flou du verre",
    ["settings.glass_blur_size"] = "Intensité du flou",
    ["settings.notification_side"] = "Côté des notifications",
    ["settings.dpi_scale"] = "Échelle DPI",
    ["settings.mobile_layout"] = "Disposition mobile",
    ["settings.swipe_tabs"] = "Balayer entre les onglets",
    ["settings.swipe_threshold"] = "Seuil de balayage",
    ["settings.corner_radius"] = "Rayon des coins",
    ["settings.menu_bind"] = "Touche du menu",
    ["settings.unload"] = "Décharger",
    ["settings.appearance_group"] = "Apparence",
    ["settings.accessibility_group"] = "Accessibilité",
    ["settings.mobile_group"] = "Mobile",
    ["tabs.key"] = "Système de clé",
    ["tabs.settings"] = "Paramètres de l’interface",
    ["settings.group_title"] = "Menu Cyan",
    ["command.settings.title"] = "Ouvrir les paramètres",
    ["command.settings.description"] = "Modifier le thème, la langue, le verre et les options mobiles.",
    ["command.reset_layout.title"] = "Réinitialiser la disposition",
    ["command.reset_layout.description"] = "Centrer le menu et restaurer sa position par défaut.",
    ["command.close.title"] = "Fermer le menu",
    ["command.close.description"] = "Masquer le menu Cyan.",
    ["library.SearchPlaceholder"] = "Rechercher",
    ["library.CommandSearchPlaceholder"] = "Rechercher des commandes...",
    ["library.NoCommandsFound"] = "Aucune commande trouvée",
    ["library.DropdownSearchPlaceholder"] = "Rechercher...",
    ["library.KeyPlaceholder"] = "Clé d’accès",
    ["library.KeySubmit"] = "Exécuter",
    ["library.KeyVerified"] = "Vérifiée",
    ["library.DoubleClickConfirmation"] = "Êtes-vous sûr ?",
    ["library.MobileMenuLabel"] = "Menu",
    ["library.MobileMenuTooltip"] = "Touchez pour ouvrir ou fermer. Maintenez pour le verrouillage.",
    ["library.MobileLockLabel"] = "Verrouiller",
    ["library.MobileUnlockLabel"] = "Déverrouiller",
    ["library.MobileLockTooltip"] = "Verrouiller la position du menu",
    ["library.MobileLockActionTitle"] = "Verrouillage du menu",
    ["library.MobileMenuLocked"] = "Position du menu verrouillée",
    ["library.MobileMenuUnlocked"] = "Position du menu déverrouillée",
})

I18n:Register("es", {
    ["window.title"] = "Cyan",
    ["window.footer"] = "versión: ejemplo",
    ["window.search"] = "Buscar",
    ["login.prompt"] = "Introduce `EB` para acceder al menú de ejemplo.",
    ["login.placeholder"] = "Clave de acceso",
    ["login.success.title"] = "Acceso concedido",
    ["login.success.description"] = "El validador aceptó la clave enviada.",
    ["login.idle"] = "Estado: esperando una clave",
    ["login.checking"] = "Comprobando clave...",
    ["login.verified"] = "Acceso concedido.",
    ["login.rejected_prefix"] = "Acceso denegado: ",
    ["login.locked"] = "El acceso está bloqueado. Restablécelo antes de volver a intentarlo.",
    ["login.logged_out"] = "Estado: sesión cerrada",
    ["login.reset"] = "Restablecer entrada de clave",
    ["login.invalid"] = "La clave de ejemplo no es válida",
    ["settings.description"] = "Personaliza la interfaz, el movimiento y la visualización de Cyan.",
    ["settings.focus_search"] = "Enfocar búsqueda (Ctrl+K)",
    ["settings.clear_search"] = "Borrar búsqueda",
    ["settings.logout"] = "Cerrar sesión",
    ["settings.language"] = "Idioma",
    ["settings.show_search"] = "Mostrar búsqueda",
    ["settings.keybind_menu"] = "Abrir menú de atajos",
    ["settings.custom_cursor"] = "Cursor personalizado",
    ["settings.reduce_motion"] = "Reducir movimiento",
    ["settings.liquid_glass"] = "Cristal líquido",
    ["settings.glass_transparency"] = "Transparencia del cristal",
    ["settings.glass_preset"] = "Preajuste del cristal",
    ["settings.animate_glass"] = "Animar cristal",
    ["settings.glass_sheen_speed"] = "Velocidad del brillo",
    ["settings.animate_background"] = "Animar fondo",
    ["settings.background_motion_speed"] = "Velocidad del fondo",
    ["settings.glass_blur"] = "Desenfoque del cristal",
    ["settings.glass_blur_size"] = "Intensidad del desenfoque",
    ["settings.notification_side"] = "Lado de notificaciones",
    ["settings.dpi_scale"] = "Escala DPI",
    ["settings.mobile_layout"] = "Diseño móvil",
    ["settings.swipe_tabs"] = "Deslizar entre pestañas",
    ["settings.swipe_threshold"] = "Umbral de deslizamiento",
    ["settings.corner_radius"] = "Radio de esquinas",
    ["settings.menu_bind"] = "Tecla del menú",
    ["settings.unload"] = "Descargar",
    ["settings.appearance_group"] = "Apariencia",
    ["settings.accessibility_group"] = "Accesibilidad",
    ["settings.mobile_group"] = "Móvil",
    ["tabs.key"] = "Sistema de clave",
    ["tabs.settings"] = "Ajustes de interfaz",
    ["settings.group_title"] = "Menú Cyan",
    ["command.settings.title"] = "Abrir ajustes",
    ["command.settings.description"] = "Cambiar tema, idioma, cristal y opciones móviles.",
    ["command.reset_layout.title"] = "Restablecer diseño",
    ["command.reset_layout.description"] = "Centrar el menú y restaurar su posición predeterminada.",
    ["command.close.title"] = "Cerrar menú",
    ["command.close.description"] = "Ocultar el menú Cyan.",
    ["library.SearchPlaceholder"] = "Buscar",
    ["library.CommandSearchPlaceholder"] = "Buscar comandos...",
    ["library.NoCommandsFound"] = "No se encontraron comandos",
    ["library.DropdownSearchPlaceholder"] = "Buscar...",
    ["library.KeyPlaceholder"] = "Clave de acceso",
    ["library.KeySubmit"] = "Ejecutar",
    ["library.KeyVerified"] = "Verificada",
    ["library.DoubleClickConfirmation"] = "¿Estás seguro?",
    ["library.MobileMenuLabel"] = "Menú",
    ["library.MobileMenuTooltip"] = "Toca para abrir o cerrar. Mantén pulsado para bloquear.",
    ["library.MobileLockLabel"] = "Bloquear",
    ["library.MobileUnlockLabel"] = "Desbloquear",
    ["library.MobileLockTooltip"] = "Bloquear posición del menú",
    ["library.MobileLockActionTitle"] = "Bloqueo del menú",
    ["library.MobileMenuLocked"] = "Posición del menú bloqueada",
    ["library.MobileMenuUnlocked"] = "Posición del menú desbloqueada",
})

I18n:Register("tr", {
    ["window.title"] = "Cyan",
    ["window.footer"] = "sürüm: örnek",
    ["window.search"] = "Ara",
    ["login.prompt"] = "Örnek menüye erişmek için `EB` girin.",
    ["login.placeholder"] = "Erişim anahtarı",
    ["login.success.title"] = "Erişim verildi",
    ["login.success.description"] = "Doğrulayıcı gönderilen anahtarı kabul etti.",
    ["login.idle"] = "Durum: anahtar bekleniyor",
    ["login.checking"] = "Anahtar doğrulanıyor...",
    ["login.verified"] = "Erişim verildi.",
    ["login.rejected_prefix"] = "Erişim reddedildi: ",
    ["login.locked"] = "Erişim kilitli. Tekrar denemeden önce sıfırlayın.",
    ["login.logged_out"] = "Durum: çıkış yapıldı",
    ["login.reset"] = "Anahtar girişini sıfırla",
    ["login.invalid"] = "Bu örnek anahtarı geçerli değil",
    ["settings.description"] = "Cyan arayüzünü, hareketini ve görüntü ayarlarını kişiselleştirin.",
    ["settings.focus_search"] = "Aramaya odaklan (Ctrl+K)",
    ["settings.clear_search"] = "Aramayı temizle",
    ["settings.logout"] = "Çıkış yap",
    ["settings.language"] = "Dil",
    ["settings.show_search"] = "Aramayı göster",
    ["settings.keybind_menu"] = "Kısayol menüsünü aç",
    ["settings.custom_cursor"] = "Özel imleç",
    ["settings.reduce_motion"] = "Hareketi azalt",
    ["settings.liquid_glass"] = "Sıvı cam",
    ["settings.glass_transparency"] = "Cam saydamlığı",
    ["settings.glass_preset"] = "Cam ön ayarı",
    ["settings.animate_glass"] = "Camı canlandır",
    ["settings.glass_sheen_speed"] = "Parlama hızı",
    ["settings.animate_background"] = "Arka planı canlandır",
    ["settings.background_motion_speed"] = "Arka plan hareket hızı",
    ["settings.glass_blur"] = "Cam bulanıklığı",
    ["settings.glass_blur_size"] = "Bulanıklık yoğunluğu",
    ["settings.notification_side"] = "Bildirim tarafı",
    ["settings.dpi_scale"] = "DPI ölçeği",
    ["settings.mobile_layout"] = "Mobil düzen",
    ["settings.swipe_tabs"] = "Sekmeler arasında kaydır",
    ["settings.swipe_threshold"] = "Kaydırma eşiği",
    ["settings.corner_radius"] = "Köşe yarıçapı",
    ["settings.menu_bind"] = "Menü tuşu",
    ["settings.unload"] = "Kaldır",
    ["settings.appearance_group"] = "Görünüm",
    ["settings.accessibility_group"] = "Erişilebilirlik",
    ["settings.mobile_group"] = "Mobil",
    ["tabs.key"] = "Anahtar sistemi",
    ["tabs.settings"] = "Arayüz ayarları",
    ["settings.group_title"] = "Cyan menüsü",
    ["command.settings.title"] = "Ayarları aç",
    ["command.settings.description"] = "Temayı, dili, camı ve mobil seçenekleri değiştirin.",
    ["command.reset_layout.title"] = "Düzeni sıfırla",
    ["command.reset_layout.description"] = "Menüyü ortalayın ve varsayılan konumuna döndürün.",
    ["command.close.title"] = "Menüyü kapat",
    ["command.close.description"] = "Cyan menüsünü gizle.",
    ["library.SearchPlaceholder"] = "Ara",
    ["library.CommandSearchPlaceholder"] = "Komutları ara...",
    ["library.NoCommandsFound"] = "Komut bulunamadı",
    ["library.DropdownSearchPlaceholder"] = "Ara...",
    ["library.KeyPlaceholder"] = "Erişim anahtarı",
    ["library.KeySubmit"] = "Çalıştır",
    ["library.KeyVerified"] = "Doğrulandı",
    ["library.DoubleClickConfirmation"] = "Emin misiniz?",
    ["library.MobileMenuLabel"] = "Menü",
    ["library.MobileMenuTooltip"] = "Açmak veya kapatmak için dokunun. Kilit için basılı tutun.",
    ["library.MobileLockLabel"] = "Kilitle",
    ["library.MobileUnlockLabel"] = "Kilidi aç",
    ["library.MobileLockTooltip"] = "Menü konumunu kilitle",
    ["library.MobileLockActionTitle"] = "Menü kilidi",
    ["library.MobileMenuLocked"] = "Menü konumu kilitlendi",
    ["library.MobileMenuUnlocked"] = "Menü konumunun kilidi açıldı",
})

I18n:Register("pt-BR", {
    ["window.title"] = "Cyan",
    ["window.footer"] = "versão: exemplo",
    ["window.search"] = "Pesquisar",
    ["login.prompt"] = "Digite `EB` para acessar o menu de exemplo.",
    ["login.placeholder"] = "Chave de acesso",
    ["login.success.title"] = "Acesso concedido",
    ["login.success.description"] = "O validador aceitou a chave enviada.",
    ["login.idle"] = "Status: aguardando uma chave",
    ["login.checking"] = "Verificando chave...",
    ["login.verified"] = "Acesso concedido.",
    ["login.rejected_prefix"] = "Acesso negado: ",
    ["login.locked"] = "O acesso está bloqueado. Redefina antes de tentar novamente.",
    ["login.logged_out"] = "Status: desconectado",
    ["login.reset"] = "Redefinir entrada da chave",
    ["login.invalid"] = "Esta chave de exemplo não é válida",
    ["settings.description"] = "Personalize a interface, o movimento e as opções de exibição do Cyan.",
    ["settings.focus_search"] = "Focar pesquisa (Ctrl+K)",
    ["settings.clear_search"] = "Limpar pesquisa",
    ["settings.logout"] = "Sair",
    ["settings.language"] = "Idioma",
    ["settings.show_search"] = "Mostrar pesquisa",
    ["settings.keybind_menu"] = "Abrir menu de atalhos",
    ["settings.custom_cursor"] = "Cursor personalizado",
    ["settings.reduce_motion"] = "Reduzir movimento",
    ["settings.liquid_glass"] = "Vidro líquido",
    ["settings.glass_transparency"] = "Transparência do vidro",
    ["settings.glass_preset"] = "Predefinição do vidro",
    ["settings.animate_glass"] = "Animar vidro",
    ["settings.glass_sheen_speed"] = "Velocidade do brilho",
    ["settings.animate_background"] = "Animar plano de fundo",
    ["settings.background_motion_speed"] = "Velocidade do plano de fundo",
    ["settings.glass_blur"] = "Desfoque do vidro",
    ["settings.glass_blur_size"] = "Intensidade do desfoque",
    ["settings.notification_side"] = "Lado das notificações",
    ["settings.dpi_scale"] = "Escala DPI",
    ["settings.mobile_layout"] = "Layout móvel",
    ["settings.swipe_tabs"] = "Deslizar entre abas",
    ["settings.swipe_threshold"] = "Limite de deslizamento",
    ["settings.corner_radius"] = "Raio dos cantos",
    ["settings.menu_bind"] = "Tecla do menu",
    ["settings.unload"] = "Descarregar",
    ["settings.appearance_group"] = "Aparência",
    ["settings.accessibility_group"] = "Acessibilidade",
    ["settings.mobile_group"] = "Móvel",
    ["tabs.key"] = "Sistema de chave",
    ["tabs.settings"] = "Configurações da interface",
    ["settings.group_title"] = "Menu Cyan",
    ["command.settings.title"] = "Abrir configurações",
    ["command.settings.description"] = "Alterar tema, idioma, vidro e opções móveis.",
    ["command.reset_layout.title"] = "Redefinir layout",
    ["command.reset_layout.description"] = "Centralizar o menu e restaurar sua posição padrão.",
    ["command.close.title"] = "Fechar menu",
    ["command.close.description"] = "Ocultar o menu Cyan.",
    ["library.SearchPlaceholder"] = "Pesquisar",
    ["library.CommandSearchPlaceholder"] = "Pesquisar comandos...",
    ["library.NoCommandsFound"] = "Nenhum comando encontrado",
    ["library.DropdownSearchPlaceholder"] = "Pesquisar...",
    ["library.KeyPlaceholder"] = "Chave de acesso",
    ["library.KeySubmit"] = "Executar",
    ["library.KeyVerified"] = "Verificada",
    ["library.DoubleClickConfirmation"] = "Tem certeza?",
    ["library.MobileMenuLabel"] = "Menu",
    ["library.MobileMenuTooltip"] = "Toque para abrir ou fechar. Mantenha pressionado para bloquear.",
    ["library.MobileLockLabel"] = "Bloquear",
    ["library.MobileUnlockLabel"] = "Desbloquear",
    ["library.MobileLockTooltip"] = "Bloquear posição do menu",
    ["library.MobileLockActionTitle"] = "Bloqueio do menu",
    ["library.MobileMenuLocked"] = "Posição do menu bloqueada",
    ["library.MobileMenuUnlocked"] = "Posição do menu desbloqueada",
})

I18n:Register("it", {
    ["window.title"] = "Cyan",
    ["window.footer"] = "versione: esempio",
    ["window.search"] = "Cerca",
    ["login.prompt"] = "Inserisci `EB` per accedere al menu di esempio.",
    ["login.placeholder"] = "Chiave di accesso",
    ["login.success.title"] = "Accesso consentito",
    ["login.success.description"] = "Il validatore ha accettato la chiave inviata.",
    ["login.idle"] = "Stato: in attesa di una chiave",
    ["login.checking"] = "Verifica della chiave...",
    ["login.verified"] = "Accesso consentito.",
    ["login.rejected_prefix"] = "Accesso negato: ",
    ["login.locked"] = "L’accesso è bloccato. Reimposta prima di riprovare.",
    ["login.logged_out"] = "Stato: disconnesso",
    ["login.reset"] = "Reimposta inserimento chiave",
    ["login.invalid"] = "Questa chiave di esempio non è valida",
    ["settings.description"] = "Personalizza l’interfaccia Cyan, i movimenti e le impostazioni di visualizzazione.",
    ["settings.focus_search"] = "Attiva ricerca (Ctrl+K)",
    ["settings.clear_search"] = "Cancella ricerca",
    ["settings.logout"] = "Disconnetti",
    ["settings.language"] = "Lingua",
    ["settings.show_search"] = "Mostra ricerca",
    ["settings.keybind_menu"] = "Apri menu scorciatoie",
    ["settings.custom_cursor"] = "Cursore personalizzato",
    ["settings.reduce_motion"] = "Riduci movimento",
    ["settings.liquid_glass"] = "Vetro liquido",
    ["settings.glass_transparency"] = "Trasparenza del vetro",
    ["settings.glass_preset"] = "Predefinito vetro",
    ["settings.animate_glass"] = "Anima vetro",
    ["settings.glass_sheen_speed"] = "Velocità della lucentezza",
    ["settings.animate_background"] = "Anima sfondo",
    ["settings.background_motion_speed"] = "Velocità dello sfondo",
    ["settings.glass_blur"] = "Sfocatura del vetro",
    ["settings.glass_blur_size"] = "Intensità della sfocatura",
    ["settings.notification_side"] = "Lato notifiche",
    ["settings.dpi_scale"] = "Scala DPI",
    ["settings.mobile_layout"] = "Layout mobile",
    ["settings.swipe_tabs"] = "Scorri tra le schede",
    ["settings.swipe_threshold"] = "Soglia di scorrimento",
    ["settings.corner_radius"] = "Raggio angoli",
    ["settings.menu_bind"] = "Tasto menu",
    ["settings.unload"] = "Scarica",
    ["settings.appearance_group"] = "Aspetto",
    ["settings.accessibility_group"] = "Accessibilità",
    ["settings.mobile_group"] = "Mobile",
    ["tabs.key"] = "Sistema chiave",
    ["tabs.settings"] = "Impostazioni interfaccia",
    ["settings.group_title"] = "Menu Cyan",
    ["command.settings.title"] = "Apri impostazioni",
    ["command.settings.description"] = "Modifica tema, lingua, vetro e opzioni mobile.",
    ["command.reset_layout.title"] = "Reimposta layout",
    ["command.reset_layout.description"] = "Centra il menu e ripristina la posizione predefinita.",
    ["command.close.title"] = "Chiudi menu",
    ["command.close.description"] = "Nascondi il menu Cyan.",
    ["library.SearchPlaceholder"] = "Cerca",
    ["library.CommandSearchPlaceholder"] = "Cerca comandi...",
    ["library.NoCommandsFound"] = "Nessun comando trovato",
    ["library.DropdownSearchPlaceholder"] = "Cerca...",
    ["library.KeyPlaceholder"] = "Chiave di accesso",
    ["library.KeySubmit"] = "Esegui",
    ["library.KeyVerified"] = "Verificata",
    ["library.DoubleClickConfirmation"] = "Sei sicuro?",
    ["library.MobileMenuLabel"] = "Menu",
    ["library.MobileMenuTooltip"] = "Tocca per aprire o chiudere. Tieni premuto per bloccare.",
    ["library.MobileLockLabel"] = "Blocca",
    ["library.MobileUnlockLabel"] = "Sblocca",
    ["library.MobileLockTooltip"] = "Blocca posizione menu",
    ["library.MobileLockActionTitle"] = "Blocco menu",
    ["library.MobileMenuLocked"] = "Posizione menu bloccata",
    ["library.MobileMenuUnlocked"] = "Posizione menu sbloccata",
})

I18n:Register("ru", {
    ["window.title"] = "Cyan",
    ["window.footer"] = "версия: пример",
    ["window.search"] = "Поиск",
    ["login.prompt"] = "Введите `EB`, чтобы получить доступ к меню примера.",
    ["login.placeholder"] = "Ключ доступа",
    ["login.success.title"] = "Доступ разрешён",
    ["login.success.description"] = "Проверка приняла отправленный ключ.",
    ["login.idle"] = "Статус: ожидание ключа",
    ["login.checking"] = "Проверка ключа...",
    ["login.verified"] = "Доступ разрешён.",
    ["login.rejected_prefix"] = "Доступ запрещён: ",
    ["login.locked"] = "Доступ заблокирован. Сбросьте его перед новой попыткой.",
    ["login.logged_out"] = "Статус: выход выполнен",
    ["login.reset"] = "Сбросить ввод ключа",
    ["login.invalid"] = "Этот ключ примера недействителен",
    ["settings.description"] = "Настройте интерфейс Cyan, движение и параметры отображения.",
    ["settings.focus_search"] = "Фокус поиска (Ctrl+K)",
    ["settings.clear_search"] = "Очистить поиск",
    ["settings.logout"] = "Выйти",
    ["settings.language"] = "Язык",
    ["settings.show_search"] = "Показывать поиск",
    ["settings.keybind_menu"] = "Открыть меню клавиш",
    ["settings.custom_cursor"] = "Пользовательский курсор",
    ["settings.reduce_motion"] = "Уменьшить движение",
    ["settings.liquid_glass"] = "Жидкое стекло",
    ["settings.glass_transparency"] = "Прозрачность стекла",
    ["settings.glass_preset"] = "Предустановка стекла",
    ["settings.animate_glass"] = "Анимировать стекло",
    ["settings.glass_sheen_speed"] = "Скорость блеска",
    ["settings.animate_background"] = "Анимировать фон",
    ["settings.background_motion_speed"] = "Скорость фона",
    ["settings.glass_blur"] = "Размытие стекла",
    ["settings.glass_blur_size"] = "Сила размытия",
    ["settings.notification_side"] = "Сторона уведомлений",
    ["settings.dpi_scale"] = "Масштаб DPI",
    ["settings.mobile_layout"] = "Мобильный макет",
    ["settings.swipe_tabs"] = "Свайп между вкладками",
    ["settings.swipe_threshold"] = "Порог свайпа",
    ["settings.corner_radius"] = "Радиус углов",
    ["settings.menu_bind"] = "Клавиша меню",
    ["settings.unload"] = "Выгрузить",
    ["settings.appearance_group"] = "Внешний вид",
    ["settings.accessibility_group"] = "Доступность",
    ["settings.mobile_group"] = "Мобильное",
    ["tabs.key"] = "Система ключа",
    ["tabs.settings"] = "Настройки интерфейса",
    ["settings.group_title"] = "Меню Cyan",
    ["command.settings.title"] = "Открыть настройки",
    ["command.settings.description"] = "Изменить тему, язык, стекло и мобильные параметры.",
    ["command.reset_layout.title"] = "Сбросить макет",
    ["command.reset_layout.description"] = "Центрировать меню и восстановить позицию по умолчанию.",
    ["command.close.title"] = "Закрыть меню",
    ["command.close.description"] = "Скрыть меню Cyan.",
    ["library.SearchPlaceholder"] = "Поиск",
    ["library.CommandSearchPlaceholder"] = "Поиск команд...",
    ["library.NoCommandsFound"] = "Команды не найдены",
    ["library.DropdownSearchPlaceholder"] = "Поиск...",
    ["library.KeyPlaceholder"] = "Ключ доступа",
    ["library.KeySubmit"] = "Выполнить",
    ["library.KeyVerified"] = "Проверен",
    ["library.DoubleClickConfirmation"] = "Вы уверены?",
    ["library.MobileMenuLabel"] = "Меню",
    ["library.MobileMenuTooltip"] = "Нажмите, чтобы открыть или закрыть. Удерживайте для блокировки.",
    ["library.MobileLockLabel"] = "Заблокировать",
    ["library.MobileUnlockLabel"] = "Разблокировать",
    ["library.MobileLockTooltip"] = "Заблокировать позицию меню",
    ["library.MobileLockActionTitle"] = "Блокировка меню",
    ["library.MobileMenuLocked"] = "Позиция меню заблокирована",
    ["library.MobileMenuUnlocked"] = "Позиция меню разблокирована",
})

I18n:Register("fa", {
    ["window.title"] = "سیان",
    ["window.footer"] = "نسخه: نمونه",
    ["window.search"] = "جستجو",
    ["login.prompt"] = "برای دسترسی `EB` را وارد کنید.",
    ["login.placeholder"] = "کلید دسترسی",
    ["login.success.title"] = "دسترسی مجاز شد",
    ["login.success.description"] = "کلید پذیرفته شد.",
    ["login.idle"] = "وضعیت: در انتظار کلید",
    ["login.checking"] = "در حال بررسی کلید...",
    ["login.verified"] = "دسترسی مجاز شد.",
    ["login.rejected_prefix"] = "دسترسی رد شد: ",
    ["login.locked"] = "دسترسی قفل است.",
    ["login.logged_out"] = "وضعیت: خارج شدید",
    ["login.reset"] = "بازنشانی ورود کلید",
    ["login.invalid"] = "کلید نمونه معتبر نیست",
    ["settings.description"] = "رابط سیان را شخصی‌سازی کنید.",
    ["settings.language"] = "زبان",
    ["settings.logout"] = "خروج",
    ["settings.group_title"] = "منوی سیان",
    ["settings.appearance_group"] = "ظاهر",
    ["settings.accessibility_group"] = "دسترس‌پذیری",
    ["settings.mobile_group"] = "موبایل",
    ["tabs.key"] = "سامانه کلید",
    ["tabs.settings"] = "تنظیمات رابط",
    ["command.settings.title"] = "باز کردن تنظیمات",
    ["command.reset_layout.title"] = "بازنشانی چیدمان",
    ["command.close.title"] = "بستن منو",
    ["library.SearchPlaceholder"] = "جستجو",
    ["library.CommandSearchPlaceholder"] = "جستجوی فرمان‌ها...",
    ["library.NoCommandsFound"] = "فرمانی پیدا نشد",
    ["library.KeyPlaceholder"] = "کلید دسترسی",
    ["library.KeySubmit"] = "اجرا",
    ["library.KeyVerified"] = "تأیید شد",
    ["library.MobileMenuLabel"] = "منو",
    ["library.MobileLockLabel"] = "قفل",
    ["library.MobileUnlockLabel"] = "باز کردن قفل",
    ["library.MobileMenuLocked"] = "جای منو قفل شد",
    ["library.MobileMenuUnlocked"] = "قفل جای منو باز شد",
})

I18n:Register("ur", {
    ["window.title"] = "سیان",
    ["window.footer"] = "ورژن: مثال",
    ["window.search"] = "تلاش",
    ["login.prompt"] = "رسائی کے لیے `EB` درج کریں۔",
    ["login.placeholder"] = "رسائی کلید",
    ["login.success.title"] = "رسائی منظور",
    ["login.success.description"] = "کلید قبول کرلی گئی۔",
    ["login.idle"] = "حالت: کلید کا انتظار",
    ["login.checking"] = "کلید کی جانچ ہو رہی ہے...",
    ["login.verified"] = "رسائی منظور۔",
    ["login.rejected_prefix"] = "رسائی مسترد: ",
    ["login.locked"] = "رسائی مقفل ہے۔",
    ["login.logged_out"] = "حالت: لاگ آؤٹ",
    ["login.reset"] = "کلید کا اندراج ری سیٹ کریں",
    ["login.invalid"] = "مثال کی کلید درست نہیں",
    ["settings.description"] = "سیان انٹرفیس کو ذاتی بنائیں۔",
    ["settings.language"] = "زبان",
    ["settings.logout"] = "لاگ آؤٹ",
    ["settings.group_title"] = "سیان مینو",
    ["settings.appearance_group"] = "ظاہری شکل",
    ["settings.accessibility_group"] = "رسائی پذیری",
    ["settings.mobile_group"] = "موبائل",
    ["tabs.key"] = "کلید کا نظام",
    ["tabs.settings"] = "انٹرفیس ترتیبات",
    ["command.settings.title"] = "ترتیبات کھولیں",
    ["command.reset_layout.title"] = "لے آؤٹ ری سیٹ کریں",
    ["command.close.title"] = "مینو بند کریں",
    ["library.SearchPlaceholder"] = "تلاش",
    ["library.CommandSearchPlaceholder"] = "کمانڈز تلاش کریں...",
    ["library.NoCommandsFound"] = "کوئی کمانڈ نہیں ملی",
    ["library.KeyPlaceholder"] = "رسائی کلید",
    ["library.KeySubmit"] = "عمل کریں",
    ["library.KeyVerified"] = "تصدیق شدہ",
    ["library.MobileMenuLabel"] = "مینو",
    ["library.MobileLockLabel"] = "لاک",
    ["library.MobileUnlockLabel"] = "ان لاک",
    ["library.MobileMenuLocked"] = "مینو کی جگہ لاک ہو گئی",
    ["library.MobileMenuUnlocked"] = "مینو کی جگہ ان لاک ہو گئی",
})

SaveManager:SetLocalization(I18n, "save")
ThemeManager:SetLocalization(I18n, "theme")
Library:SetLocalization(I18n, "library")

local LanguageLocales = {
    English = "en",
    Deutsch = "de",
    ["Français"] = "fr",
    ["Español"] = "es",
    ["Português"] = "pt-BR",
    Italiano = "it",
    ["Русский"] = "ru",
    ["Türkçe"] = "tr",
    ["فارسی"] = "fa",
    ["اردو"] = "ur",
    ["العربية"] = "ar",
}
local InitialLanguage = "English"
local UpdatingLanguage = false
local function SelectLanguage(Value)
    local Locale = LanguageLocales[Value]
    if not Locale or UpdatingLanguage then
        return
    end

    UpdatingLanguage = true
    I18n:SetLocale(Locale)
    for _, OptionId in { "LoginLanguage", "Language" } do
        local LanguageOption = Options[OptionId]
        if LanguageOption and LanguageOption.Value ~= Value then
            LanguageOption:SetValue(Value)
        end
    end
    UpdatingLanguage = false
end

local function ApplySupportedSystemLocale()
    local Success, LocaleId = pcall(function()
        return game:GetService("LocalizationService").RobloxLocaleId
    end)
    if not Success or typeof(LocaleId) ~= "string" then
        return
    end

    local BaseLocale = string.lower(LocaleId):match("^([a-z]+)")
    local LocaleToLanguage = {
        de = "Deutsch",
        fr = "Français",
        es = "Español",
        pt = "Português",
        it = "Italiano",
        ru = "Русский",
        tr = "Türkçe",
        fa = "فارسی",
        ur = "اردو",
        ar = "العربية",
    }
    local Language = BaseLocale and LocaleToLanguage[BaseLocale]
    if Language then
        InitialLanguage = Language
        I18n:SetLocale(LanguageLocales[Language])
    end
end
ApplySupportedSystemLocale()

local WelcomeLoading = Library:CreateLoading({
    Title = I18n:T("loading.title"),
    Icon = CyanLogo,
    IconSize = UDim2.fromOffset(34, 34),
    LoadingIcon = CyanLogo,
    LoadingIconTweenTime = 0,
    CurrentStep = 0,
    TotalSteps = 3,
    ShowSidebar = not Library.IsMobile,
    WindowWidth = 450,
    WindowHeight = 280,
    ContentWidth = 450,
    SidebarWidth = 170,
})
if WelcomeLoading.ShowSidebar and WelcomeLoading.Sidebar then
    WelcomeLoading.Sidebar:AddLabel("Cyan", true)
    WelcomeLoading.Sidebar:AddDivider()
    WelcomeLoading.Sidebar:AddLabel(I18n:T("loading.badge.glass"))
    WelcomeLoading.Sidebar:AddLabel(I18n:T("loading.badge.language"))
    WelcomeLoading.Sidebar:AddLabel(I18n:T("loading.badge.mobile"))
end
local WelcomeName = (Library.LocalPlayer and Library.LocalPlayer.DisplayName) or "Player"
WelcomeLoading:SetMessage(I18n:T("loading.greeting", { name = WelcomeName }))
WelcomeLoading:SetDescription(I18n:T("loading.stage.welcome_description"))
WelcomeLoading:SetCurrentStep(1)
task.wait(0.35)
WelcomeLoading:SetMessage(I18n:T("loading.stage.prepare"))
WelcomeLoading:SetDescription(I18n:T("loading.stage.prepare_description"))
WelcomeLoading:SetCurrentStep(2)

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

Tabs.Key:AddDropdown("LoginLanguage", {
    Text = I18n:T("settings.language"),
    Values = {
        "English",
        "Deutsch",
        "Français",
        "Español",
        "Português",
        "Italiano",
        "Русский",
        "Türkçe",
        "فارسی",
        "اردو",
        "العربية",
    },
    Default = InitialLanguage,
    AllowNull = false,
    Callback = SelectLanguage,
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
    RightToLeft = I18n:IsRightToLeft(),
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
        RightToLeft = I18n:IsRightToLeft(),
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
local AppearanceGroup = Tabs["UI Settings"]:AddLeftGroupbox(I18n:T("settings.appearance_group"), "sparkles")
local AccessibilityGroup = Tabs["UI Settings"]:AddRightGroupbox(I18n:T("settings.accessibility_group"), "accessibility")
local MobileGroup =
    Tabs["UI Settings"]:AddRightGroupbox(I18n:T("settings.mobile_group"), "smartphone", Library.IsMobile)

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
    Values = {
        "English",
        "Deutsch",
        "Français",
        "Español",
        "Português",
        "Italiano",
        "Русский",
        "Türkçe",
        "فارسی",
        "اردو",
        "العربية",
    },
    Default = InitialLanguage,
    AllowNull = false,
    Callback = SelectLanguage,
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
AccessibilityGroup:AddToggle("ShowCustomCursor", {
    Text = I18n:T("settings.custom_cursor"),
    Default = Library.ShowCustomCursor,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})
AccessibilityGroup:AddToggle("ReducedMotion", {
    Text = I18n:T("settings.reduce_motion"),
    Default = Library.ReducedMotion,
    Tooltip = "Disables Cyan UI animations for a calmer, more accessible interface.",
    Callback = function(Value)
        Library:SetReducedMotion(Value)
    end,
})
AppearanceGroup:AddToggle("LiquidGlass", {
    Text = I18n:T("settings.liquid_glass"),
    Default = Library.GlassEnabled,
    Tooltip = "Applies Cyan translucent glass surfaces, gradients, and highlights.",
    Callback = function(Value)
        Window:SetGlass(Value)
    end,
})
AppearanceGroup:AddSlider("GlassTransparency", {
    Text = I18n:T("settings.glass_transparency"),
    Default = Library.GlassTransparency,
    Min = 0,
    Max = 0.85,
    Rounding = 2,
    Callback = function(Value)
        Window:SetGlass(Library.GlassEnabled, Value)
    end,
})
AppearanceGroup:AddDropdown("GlassPreset", {
    Text = I18n:T("settings.glass_preset"),
    Values = { "Liquid", "Crystal", "Frosted", "Ocean", "Aurora", "Midnight", "Solid" },
    Default = Window:GetGlassPreset(),
    AllowNull = false,
    Callback = function(Value)
        Window:SetGlassPreset(Value)
    end,
})
AppearanceGroup:AddToggle("GlassSheen", {
    Text = I18n:T("settings.animate_glass"),
    Default = true,
    Callback = function(Value)
        Window:SetGlassSheen(Value)
    end,
})
AppearanceGroup:AddSlider("GlassSheenSpeed", {
    Text = I18n:T("settings.glass_sheen_speed"),
    Default = 7,
    Min = 2,
    Max = 20,
    Rounding = 0,
    Callback = function(Value)
        Window:SetGlassSheen(Toggles.GlassSheen and Toggles.GlassSheen.Value or false, Value)
    end,
})
AppearanceGroup:AddToggle("GlassBackgroundMotion", {
    Text = I18n:T("settings.animate_background"),
    Default = true,
    Callback = function(Value)
        Window:SetGlassBackgroundMotion(Value)
    end,
})
AppearanceGroup:AddSlider("GlassBackgroundMotionSpeed", {
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
AppearanceGroup:AddToggle("GlassBlur", {
    Text = I18n:T("settings.glass_blur"),
    Default = false,
    Tooltip = "Applies an optional scene blur while the menu is open.",
    Callback = function(Value)
        Window:SetGlassBlur(Value)
    end,
})
AppearanceGroup:AddSlider("GlassBlurSize", {
    Text = I18n:T("settings.glass_blur_size"),
    Default = 8,
    Min = 0,
    Max = 24,
    Rounding = 0,
    Callback = function(Value)
        Window:SetGlassBlur(Toggles.GlassBlur and Toggles.GlassBlur.Value or false, Value)
    end,
})
AccessibilityGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",

    Text = I18n:T("settings.notification_side"),

    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})
AccessibilityGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",

    Text = I18n:T("settings.dpi_scale"),

    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)

        Library:SetDPIScale(DPI)
    end,
})

MobileGroup:AddDropdown("MobileLayout", {
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
MobileGroup:AddToggle("TabSwipeNavigation", {
    Text = I18n:T("settings.swipe_tabs"),
    Default = SwipeEnabled,
    Visible = Library.IsMobile,
    Callback = function(Value)
        Window:SetTabSwipeNavigation(Value)
    end,
})
MobileGroup:AddSlider("TabSwipeThreshold", {
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

local ResetMobileActionButton = MobileGroup:AddButton(I18n:T("settings.reset_mobile_position"), function()
    Window:ResetMobileActionPosition()
end)

AccessibilityGroup:AddSlider("UICornerSlider", {
    Text = I18n:T("settings.corner_radius"),
    Default = Library.CornerRadius,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(value)
        Window:SetCornerRadius(value)
    end,
})

AccessibilityGroup:AddDivider()
local MenuBindLabel = AccessibilityGroup:AddLabel(I18n:T("settings.menu_bind"))
MenuBindLabel:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

local UnloadButton = AccessibilityGroup:AddButton(I18n:T("settings.unload"), function()
    Library:Unload()
end)

local ResetUISettingsButton = AccessibilityGroup:AddButton(I18n:T("settings.reset_ui"), function()
    Toggles.ShowSearch:SetValue(true)
    Toggles.KeybindMenuOpen:SetValue(false)
    Toggles.ShowCustomCursor:SetValue(true)
    Toggles.ReducedMotion:SetValue(false)
    Toggles.LiquidGlass:SetValue(true)
    Options.GlassTransparency:SetValue(0.28)
    Options.GlassPreset:SetValue("Liquid")
    Toggles.GlassSheen:SetValue(true)
    Options.GlassSheenSpeed:SetValue(7)
    Toggles.GlassBackgroundMotion:SetValue(true)
    Options.GlassBackgroundMotionSpeed:SetValue(14)
    Toggles.GlassBlur:SetValue(false)
    Options.GlassBlurSize:SetValue(8)
    Options.NotificationSide:SetValue("Right")
    Options.DPIDropdown:SetValue("100%")
    Options.UICornerSlider:SetValue(12)
    if Library.IsMobile then
        Options.MobileLayout:SetValue("Balanced")
        Toggles.TabSwipeNavigation:SetValue(true)
        Options.TabSwipeThreshold:SetValue(60)
    end
    Window:ResetPosition()
    Window:ResetMobileActionPosition()
    Library:Notify(I18n:T("settings.reset_ui_done"))
end)

local LocalizedSettingsElements = {
    { Tabs.Key, "tabs.key" },
    { Tabs["UI Settings"], "tabs.settings" },
    { MenuGroup, "settings.group_title" },
    { AppearanceGroup, "settings.appearance_group" },
    { AccessibilityGroup, "settings.accessibility_group" },
    { MobileGroup, "settings.mobile_group" },
    { SettingsDescription, "settings.description" },
    { FocusSearchButton, "settings.focus_search" },
    { ClearSearchButton, "settings.clear_search" },
    { LogoutButton, "settings.logout" },
    { Options.LoginLanguage, "settings.language" },
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
    { ResetMobileActionButton, "settings.reset_mobile_position" },
    { Options.UICornerSlider, "settings.corner_radius" },
    { MenuBindLabel, "settings.menu_bind" },
    { UnloadButton, "settings.unload" },
    { ResetUISettingsButton, "settings.reset_ui" },
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

-- Show the access tab only after the welcome screen, login gate, and settings panels are ready.
WelcomeLoading:SetMessage(I18n:T("loading.stage.ready"))
WelcomeLoading:SetDescription(I18n:T("loading.stage.ready_description"))
WelcomeLoading:SetCurrentStep(3)
task.wait(0.45)
WelcomeLoading:Destroy()
Window:Open()
