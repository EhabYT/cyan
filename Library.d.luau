--!strict
-- Last updated: 2026-07-21
-- Luau type definitions for the Cyan UI Library

--// Helper & Configuration Types
export type Scheme = {
    BackgroundColor: Color3,
    MainColor: Color3,
    AccentColor: Color3,
    OutlineColor: Color3,
    FontColor: Color3,
    Font: Font,
    RedColor: Color3,
    DestructiveColor: Color3,
    DarkColor: Color3,
    WhiteColor: Color3,
    BackgroundImage: string,
}

export type Icon = {
    Url: string,
    ImageRectOffset: Vector2,
    ImageRectSize: Vector2,
}

export type ContextMenu = {
    Active: boolean,
    Holder: GuiObject,
    Menu: GuiObject,
    List: UIListLayout?,
    Signal: RBXScriptConnection?,
    Size: UDim2 | () -> UDim2,

    Open: (self: ContextMenu) -> (),
    Close: (self: ContextMenu) -> (),
    Toggle: (self: ContextMenu) -> (),
    SetSize: (self: ContextMenu, Size: UDim2 | () -> UDim2) -> (),
}

export type Tooltip = {
    Disabled: boolean,
    Hovering: boolean,
    Signals: { [number]: RBXScriptConnection },
    Destroy: (self: Tooltip) -> (),
}

export type Notification = {
    Title: string?,
    Description: string,
    Time: number | Instance,
    SoundId: string | number?,
    Volume: number?,
    Steps: number?,
    Persist: boolean?,
    Icon: string?,
    BigIcon: string?,
    IconColor: Color3 | string?,
    TitleColor: Color3?,
    DescriptionColor: Color3?,
    Destroyed: boolean,

    Resize: (self: Notification) -> (),
    ChangeTitle: (self: Notification, Text: string) -> (),
    ChangeDescription: (self: Notification, Text: string) -> (),
    ChangeStep: (self: Notification, NewStep: number) -> (),
    Destroy: (self: Notification) -> (),
}

export type KeybindToggle = {
    Normal: boolean,
    Holder: TextButton,
    Label: TextLabel,
    Checkbox: Frame,
    Loaded: boolean,

    Display: (self: KeybindToggle, State: boolean) -> (),
    SetText: (self: KeybindToggle, Text: string) -> (),
    SetVisibility: (self: KeybindToggle, Visibility: boolean) -> (),
    SetNormal: (self: KeybindToggle, Normal: boolean) -> (),
}

export type DraggableLabel = {
    Label: TextLabel,
    SetText: (self: DraggableLabel, Text: string) -> (),
    SetVisible: (self: DraggableLabel, Visible: boolean) -> (),
    SetIcon: (self: DraggableLabel, Icon: string) -> (),
    SetIconPosition: (self: DraggableLabel, Position: string) -> (),
}

export type DraggableButton = {
    Button: TextButton,
    SetText: (self: DraggableButton, Text: string) -> (),
    SetIcon: (self: DraggableButton, Icon: string) -> (),
    SetIconPosition: (self: DraggableButton, Position: string) -> (),
}

export type DraggableImageButton = {
    Button: TextButton,
    SetIcon: (self: DraggableImageButton, Icon: string) -> (),
    SetIconSize: (self: DraggableImageButton, Size: number) -> (),
}

--// Element Creation Info Types
export type ButtonInfo = {
    Text: string,
    Func: (FromKeyPicker: boolean?) -> (),
    DoubleClick: boolean?,
    Tooltip: string?,
    DisabledTooltip: string?,
    Risky: boolean?,
    Disabled: boolean?,
    Visible: boolean?,
}

export type ToggleInfo = {
    Text: string,
    Default: boolean?,
    Callback: ((boolean) -> ())?,
    Changed: ((boolean) -> ())?,
    Tooltip: string?,
    DisabledTooltip: string?,
    Risky: boolean?,
    Disabled: boolean?,
    Visible: boolean?,
}

export type InputInfo = {
    Text: string,
    Default: string?,
    Finished: boolean?,
    Numeric: boolean?,
    ClearTextOnFocus: boolean?,
    Placeholder: string?,
    AllowEmpty: boolean?,
    EmptyReset: string?,
    MaxLength: number?,
    Tooltip: string?,
    DisabledTooltip: string?,
    Callback: ((string) -> ())?,
    Changed: ((string) -> ())?,
    Disabled: boolean?,
    Visible: boolean?,
}

export type SliderInfo = {
    Text: string,
    Default: number?,
    Min: number?,
    Max: number?,
    Rounding: number?,
    Prefix: string?,
    Suffix: string?,
    Compact: boolean?,
    HideMax: boolean?,
    FormatDisplayValue: ((Slider, number) -> string)?,
    Tooltip: string?,
    DisabledTooltip: string?,
    Callback: ((number) -> ())?,
    Changed: ((number) -> ())?,
    Disabled: boolean?,
    Visible: boolean?,
    AllowRightClickInput: boolean?,
}

export type DropdownInfo = {
    Text: string?,
    Values: { any },
    Default: any,
    DisabledValues: { any }?,
    Multi: boolean?,
    MaxVisibleDropdownItems: number?,
    SpecialType: "Player" | "Team"?,
    ExcludeLocalPlayer: boolean?,
    AllowNull: boolean?,
    Searchable: boolean?,
    FormatDisplayValue: ((any) -> string)?,
    Tooltip: string?,
    DisabledTooltip: string?,
    Callback: ((any) -> ())?,
    Changed: ((any) -> ())?,
    Disabled: boolean?,
    Visible: boolean?,
}

export type ViewportInfo = {
    Object: BasePart | Model,
    Camera: Camera?,
    Clone: boolean?,
    AutoFocus: boolean?,
    Interactive: boolean?,
    Height: number?,
    Visible: boolean?,
}

export type ImageInfo = {
    Image: string,
    Transparency: number?,
    Color: Color3?,
    RectOffset: Vector2?,
    RectSize: Vector2?,
    ScaleType: Enum.ScaleType?,
    Height: number?,
    Visible: boolean?,
}

export type VideoInfo = {
    Video: string,
    Looped: boolean?,
    Playing: boolean?,
    Volume: number?,
    Height: number?,
    Visible: boolean?,
}

export type UIPassthroughInfo = {
    Instance: GuiBase2d,
    Height: number?,
    Visible: boolean?,
}

export type KeyPickerInfo = {
    Text: string,
    Default: string?,
    Mode: "Always" | "Toggle" | "Hold" | "Press"?,
    Modes: { "Always" | "Toggle" | "Hold" | "Press" }?,
    SyncToggleState: boolean?,
    NoUI: boolean?,
    WaitForCallback: boolean?,
    Callback: ((boolean) -> ())?,
    ChangedCallback: ((Enum.KeyCode | Enum.UserInputType) -> ())?,
    Changed: ((Enum.KeyCode | Enum.UserInputType) -> ())?,
    Clicked: (() -> ())?,
}

export type ColorPickerInfo = {
    Default: Color3?,
    Transparency: number?,
    Title: string?,
    Callback: ((Color3) -> ())?,
    Changed: ((Color3) -> ())?,
}

export type LoadingInfo = {
    Title: string?,
    Icon: string | number?,
    IconSize: UDim2?,
    LoadingIcon: string | number?,
    LoadingIconColor: Color3?,
    LoadingIconTweenTime: number?,
    CurrentStep: number?,
    TotalSteps: number?,
    ShowSidebar: boolean?,
    AutoResizeHeight: boolean?,
    WindowWidth: number?,
    WindowHeight: number?,
    ContentWidth: number?,
    SidebarWidth: number?,
}

--// Addon Types
export type KeyPicker = {
    Text: string,
    Value: string,
    Toggled: boolean,
    Mode: "Always" | "Toggle" | "Hold" | "Press",
    SyncToggleState: boolean,
    Callback: (Toggled: boolean) -> (),
    ChangedCallback: (Key: Enum.KeyCode | Enum.UserInputType) -> (),
    Changed: (Key: Enum.KeyCode | Enum.UserInputType) -> (),
    Clicked: () -> (),
    Type: "KeyPicker",
    Menu: ContextMenu,

    Display: (self: KeyPicker) -> (),
    Update: (self: KeyPicker) -> (),
    GetState: (self: KeyPicker) -> boolean,
    OnChanged: (self: KeyPicker, Func: (Key: Enum.KeyCode | Enum.UserInputType) -> ()) -> (),
    OnClick: (self: KeyPicker, Func: () -> ()) -> (),
    DoClick: (self: KeyPicker) -> (),
    SetValue: (self: KeyPicker, Data: { string }) -> (),
    SetText: (self: KeyPicker, Text: string) -> (),
    Destroy: (self: KeyPicker) -> (),
}

export type ColorPicker = {
    Value: Color3,
    Transparency: number,
    Title: string?,
    Callback: (Value: Color3) -> (),
    Changed: (Value: Color3) -> (),
    Type: "ColorPicker",
    Hue: number,
    Sat: number,
    Vib: number,
    ColorMenu: ContextMenu,
    ContextMenu: ContextMenu,

    SetHSVFromRGB: (self: ColorPicker, Color: Color3) -> (),
    Display: (self: ColorPicker) -> (),
    Update: (self: ColorPicker) -> (),
    OnChanged: (self: ColorPicker, Func: (Value: Color3) -> ()) -> (),
    SetValue: (self: ColorPicker, HSV: { number }, Transparency: number?) -> (),
    SetValueRGB: (self: ColorPicker, Color: Color3, Transparency: number?) -> (),
    Destroy: (self: ColorPicker) -> (),
}

export type Addon = KeyPicker | ColorPicker

--// Base Element Types
export type Label = {
    Text: string,
    DoesWrap: boolean,
    Addons: { [number]: Addon },
    Visible: boolean,
    Type: "Label",
    TextLabel: TextLabel,
    Container: GuiObject,
    Holder: TextLabel,

    SetVisible: (self: Label, Visible: boolean) -> (),
    SetText: (self: Label, Text: string) -> (),

    -- From BaseAddons
    AddKeyPicker: (self: Label, Idx: string, Info: KeyPickerInfo) -> Label,
    AddColorPicker: (self: Label, Idx: string, Info: ColorPickerInfo) -> Label,
    Destroy: (self: Label) -> (),
}

export type Button = {
    Text: string,
    Func: (FromKeyPicker: boolean?) -> (),
    DoubleClick: boolean?,
    Tooltip: string?,
    DisabledTooltip: string?,
    TooltipTable: Tooltip?,
    Risky: boolean,
    Disabled: boolean,
    Visible: boolean,
    Tween: Tween?,
    Type: "Button",
    Base: TextButton,
    Stroke: UIStroke,
    Holder: Frame,
    SubButton: SubButton?,

    AddButton: (
        self: Button,
        Info: ButtonInfo | string,
        Func: (() -> ())?,
        Idx: string?
    ) -> SubButton,
    UpdateColors: (self: Button) -> (),
    SetDisabled: (self: Button, Disabled: boolean) -> (),
    SetVisible: (self: Button, Visible: boolean) -> (),
    SetText: (self: Button, Text: string) -> (),
    Destroy: (self: Button) -> (),
}

export type SubButton = {
    Text: string,
    Func: (FromKeyPicker: boolean?) -> (),
    DoubleClick: boolean?,
    Tooltip: string?,
    DisabledTooltip: string?,
    TooltipTable: Tooltip?,
    Risky: boolean,
    Disabled: boolean,
    Visible: boolean,
    Tween: Tween?,
    Type: "SubButton",
    Base: TextButton,
    Stroke: UIStroke,

    UpdateColors: (self: SubButton) -> (),
    SetDisabled: (self: SubButton, Disabled: boolean) -> (),
    SetVisible: (self: SubButton, Visible: boolean) -> (),
    SetText: (self: SubButton, Text: string) -> (),
    Destroy: (self: SubButton) -> (),
}

export type Toggle = {
    Text: string,
    Value: boolean,
    Tooltip: string?,
    DisabledTooltip: string?,
    TooltipTable: Tooltip?,
    Callback: (Value: boolean) -> (),
    Changed: (Value: boolean) -> (),
    Risky: boolean,
    Disabled: boolean,
    Visible: boolean,
    Addons: { [number]: Addon },
    Type: "Toggle",
    TextLabel: TextLabel,
    Container: GuiObject,
    Holder: TextButton,

    UpdateColors: (self: Toggle) -> (),
    Display: (self: Toggle) -> (),
    OnChanged: (self: Toggle, Func: (Value: boolean) -> ()) -> (),
    SetValue: (self: Toggle, Value: boolean) -> (),
    SetDisabled: (self: Toggle, Disabled: boolean) -> (),
    SetVisible: (self: Toggle, Visible: boolean) -> (),
    SetText: (self: Toggle, Text: string) -> (),

    -- From BaseAddons
    AddKeyPicker: (self: Toggle, Idx: string, Info: KeyPickerInfo) -> Toggle,
    AddColorPicker: (self: Toggle, Idx: string, Info: ColorPickerInfo) -> Toggle,
    Destroy: (self: Toggle) -> (),
}

export type Input = {
    Text: string,
    Value: string,
    Finished: boolean,
    Numeric: boolean,
    ClearTextOnFocus: boolean,
    Placeholder: string,
    AllowEmpty: boolean,
    EmptyReset: string,
    Tooltip: string?,
    DisabledTooltip: string?,
    TooltipTable: Tooltip?,
    Callback: (Value: string) -> (),
    Changed: (Value: string) -> (),
    Disabled: boolean,
    Visible: boolean,
    Type: "Input",
    Holder: Frame,

    UpdateColors: (self: Input) -> (),
    OnChanged: (self: Input, Func: (Value: string) -> ()) -> (),
    SetValue: (self: Input, Text: string) -> (),
    SetDisabled: (self: Input, Disabled: boolean) -> (),
    SetVisible: (self: Input, Visible: boolean) -> (),
    SetText: (self: Input, Text: string) -> (),
    Destroy: (self: Input) -> (),
}

export type Slider = {
    Text: string,
    Value: number,
    Min: number,
    Max: number,
    Prefix: string,
    Suffix: string,
    Compact: boolean?,
    Rounding: number,
    Tooltip: string?,
    DisabledTooltip: string?,
    TooltipTable: Tooltip?,
    Callback: (Value: number) -> (),
    Changed: (Value: number) -> (),
    Disabled: boolean,
    Visible: boolean,
    AllowRightClickInput: boolean,
    Type: "Slider",
    Holder: Frame,

    UpdateColors: (self: Slider) -> (),
    Display: (self: Slider) -> (),
    OnChanged: (self: Slider, Func: (Value: number) -> ()) -> (),
    SetMax: (self: Slider, Value: number) -> (),
    SetMin: (self: Slider, Value: number) -> (),
    SetValue: (self: Slider, Value: number | string) -> (),
    SetDisabled: (self: Slider, Disabled: boolean) -> (),
    SetVisible: (self: Slider, Visible: boolean) -> (),
    SetAllowRightClickInput: (self: Slider, Allow: boolean) -> (),
    SetText: (self: Slider, Text: string) -> (),
    SetPrefix: (self: Slider, Prefix: string) -> (),
    SetSuffix: (self: Slider, Suffix: string) -> (),
    Destroy: (self: Slider) -> (),
}

export type Dropdown = {
    Text: string?,
    Value: { [any]: boolean } | any,
    Values: { any },
    DisabledValues: { any },
    Multi: boolean,
    SpecialType: "Player" | "Team"?,
    ExcludeLocalPlayer: boolean?,
    Tooltip: string?,
    DisabledTooltip: string?,
    TooltipTable: Tooltip?,
    Callback: (Value: any) -> (),
    Changed: (Value: any) -> (),
    Disabled: boolean,
    Visible: boolean,
    Type: "Dropdown",
    Menu: ContextMenu,
    Holder: Frame,

    RecalculateListSize: (self: Dropdown, Count: number?) -> (),
    UpdateColors: (self: Dropdown) -> (),
    Display: (self: Dropdown) -> (),
    OnChanged: (self: Dropdown, Func: (Value: any) -> ()) -> (),
    GetActiveValues: (self: Dropdown) -> { any } | number,
    BuildDropdownList: (self: Dropdown) -> (),
    SetValue: (self: Dropdown, Value: any) -> (),
    SetValues: (self: Dropdown, Values: { any }) -> (),
    AddValues: (self: Dropdown, Values: { any } | string) -> (),
    SetDisabledValues: (self: Dropdown, DisabledValues: { any }) -> (),
    AddDisabledValues: (self: Dropdown, DisabledValues: { any } | string) -> (),
    SetDisabled: (self: Dropdown, Disabled: boolean) -> (),
    SetVisible: (self: Dropdown, Visible: boolean) -> (),
    SetText: (self: Dropdown, Text: string) -> (),
    Destroy: (self: Dropdown) -> (),
}

export type Viewport = {
    Object: BasePart | Model,
    Camera: Camera,
    Interactive: boolean,
    AutoFocus: boolean,
    Visible: boolean,
    Type: "Viewport",
    Holder: Frame,

    SetObject: (self: Viewport, Object: Instance, Clone: boolean?) -> (),
    SetHeight: (self: Viewport, Height: number) -> (),
    Focus: (self: Viewport) -> (),
    SetCamera: (self: Viewport, Camera: Camera) -> (),
    SetInteractive: (self: Viewport, Interactive: boolean) -> (),
    SetVisible: (self: Viewport, Visible: boolean) -> (),
    Destroy: (self: Viewport) -> (),
}

export type Image = {
    Image: string,
    Color: Color3,
    RectOffset: Vector2,
    RectSize: Vector2,
    Height: number,
    ScaleType: Enum.ScaleType,
    Transparency: number,
    Visible: boolean,
    Type: "Image",
    Holder: Frame,

    SetHeight: (self: Image, Height: number) -> (),
    SetImage: (self: Image, NewImage: string) -> (),
    SetColor: (self: Image, Color: Color3) -> (),
    SetRectOffset: (self: Image, RectOffset: Vector2) -> (),
    SetRectSize: (self: Image, RectSize: Vector2) -> (),
    SetScaleType: (self: Image, ScaleType: Enum.ScaleType) -> (),
    SetTransparency: (self: Image, Transparency: number) -> (),
    SetVisible: (self: Image, Visible: boolean) -> (),
    Destroy: (self: Image) -> (),
}

export type Video = {
    Video: string,
    Looped: boolean,
    Playing: boolean,
    Volume: number,
    Height: number,
    Visible: boolean,
    Type: "Video",
    Holder: Frame,
    VideoFrame: VideoFrame,

    SetHeight: (self: Video, Height: number) -> (),
    SetVideo: (self: Video, NewVideo: string) -> (),
    SetLooped: (self: Video, Looped: boolean) -> (),
    SetVolume: (self: Video, Volume: number) -> (),
    SetPlaying: (self: Video, Playing: boolean) -> (),
    Play: (self: Video) -> (),
    Pause: (self: Video) -> (),
    SetVisible: (self: Video, Visible: boolean) -> (),
    Destroy: (self: Video) -> (),
}

export type UIPassthrough = {
    Instance: GuiBase2d,
    Height: number,
    Visible: boolean,
    Type: "UIPassthrough",
    Holder: Frame,

    SetHeight: (self: UIPassthrough, Height: number) -> (),
    SetInstance: (self: UIPassthrough, Instance: GuiBase2d) -> (),
    SetVisible: (self: UIPassthrough, Visible: boolean) -> (),
    Destroy: (self: UIPassthrough) -> (),
}

export type Divider = {
    Type: "Divider",
    Holder: Frame,
    Destroy: (self: Divider) -> (),
}

export type Element =
    Label
    | Button
    | Toggle
    | Input
    | Slider
    | Dropdown
    | Viewport
    | Image
    | Video
    | UIPassthrough
    | Divider
export type Option =
    Toggle
    | Input
    | Slider
    | Dropdown
    | Viewport
    | Image
    | Video
    | UIPassthrough
    | KeyPicker
    | ColorPicker

--// Container Types
export type BaseGroupbox = {
    AddDivider: (self: Groupbox, MarginTop: number?, MarginBottom: number?) -> (),
    AddLabel: (
        self: Groupbox,
        Info: { Text: string, DoesWrap: boolean?, Size: number?, Visible: boolean?, Idx: string? }
            | string,
        DoesWrap: boolean?,
        Idx: string?
    ) -> Label,
    AddButton: (
        self: Groupbox,
        Info: ButtonInfo | string,
        Func: (() -> ())?,
        Idx: string?
    ) -> Button,
    AddCheckbox: (self: Groupbox, Idx: string, Info: ToggleInfo) -> Toggle,
    AddToggle: (self: Groupbox, Idx: string, Info: ToggleInfo) -> Toggle,
    AddInput: (self: Groupbox, Idx: string, Info: InputInfo) -> Input,
    AddSlider: (self: Groupbox, Idx: string, Info: SliderInfo) -> Slider,
    AddDropdown: (self: Groupbox, Idx: string, Info: DropdownInfo) -> Dropdown,
    AddViewport: (self: Groupbox, Idx: string, Info: ViewportInfo) -> Viewport,
    AddImage: (self: Groupbox, Idx: string, Info: ImageInfo) -> Image,
    AddVideo: (self: Groupbox, Idx: string, Info: VideoInfo) -> Video,
    AddUIPassthrough: (self: Groupbox, Idx: string, Info: UIPassthroughInfo) -> UIPassthrough,
    AddDependencyBox: (self: Groupbox) -> DependencyBox,
    AddDependencyGroupbox: (self: Groupbox) -> DependencyGroupbox,
    AddTabbox: (self: Groupbox, Info: { Name: string?, IconName: string? } | string) -> Tabbox,
    SetVisible: (self: Groupbox, Visible: boolean) -> (),
    Show: (self: Groupbox) -> (),
    Hide: (self: Groupbox) -> (),
}

export type DependencyBox = BaseGroupbox & {
    Visible: boolean,
    Dependencies: { [number]: { Element } },
    Holder: Frame,
    Container: Frame,
    Elements: { [number]: Element },
    DependencyBoxes: { [number]: DependencyBox },

    Resize: (self: DependencyBox) -> (),
    Update: (self: DependencyBox, CancelSearch: boolean?) -> (),
    SetupDependencies: (self: DependencyBox, Dependencies: { { Element } }) -> (),
}

export type DependencyGroupbox = BaseGroupbox & {
    Visible: boolean,
    Dependencies: { [number]: { Element } },
    BoxHolder: Frame,
    Holder: Frame,
    Container: Frame,
    Tab: Tab,
    Elements: { [number]: Element },
    DependencyBoxes: { [number]: DependencyBox },

    Resize: (self: DependencyGroupbox) -> (),
    Update: (self: DependencyGroupbox, CancelSearch: boolean?) -> (),
    SetupDependencies: (self: DependencyGroupbox, Dependencies: { { Element } }) -> (),
}

export type Groupbox = BaseGroupbox & {
    BoxHolder: Frame,
    Holder: Frame,
    Container: Frame,
    Tab: Tab,
    DependencyBoxes: { [number]: DependencyBox },
    Elements: { [number]: Element },

    Resize: (self: Groupbox) -> (),
    SetCollapsed: (self: Groupbox, Collapsed: boolean) -> (),
    ToggleCollapsed: (self: Groupbox) -> (),
}

export type SubTab = BaseGroupbox & {
    ButtonHolder: TextButton,
    Container: Frame,
    Tab: Tab,
    Elements: { [number]: Element },
    DependencyBoxes: { [number]: DependencyBox },

    Show: (self: SubTab) -> (),
    Hide: (self: SubTab) -> (),
    Resize: (self: SubTab) -> (),
}

export type Tabbox = {
    ActiveTab: SubTab?,
    BoxHolder: Frame,
    Holder: Frame,
    Tabs: { [string]: SubTab },

    AddTab: (self: Tabbox, Name: string, IconName: string?) -> (SubTab, number),
}

export type Tab = {
    Window: Window,
    Groupboxes: { [string]: Groupbox },
    Tabboxes: { [string]: Tabbox },
    DependencyGroupboxes: { [number]: DependencyGroupbox },
    Sides: { ScrollingFrame },
    WarningBox: {
        IsNormal: boolean,
        LockSize: boolean,
        Visible: boolean,
        Title: string,
        Text: string,
    },

    UpdateWarningBox: (
        self: Tab,
        Info: {
            IsNormal: boolean?,
            LockSize: boolean?,
            Visible: boolean?,
            Title: string?,
            Text: string?,
        }
    ) -> (),
    Resize: (self: Tab, ResizeWarningBox: boolean?) -> (),
    AddGroupbox: (
        self: Tab,
        Info: {
            Side: number,
            Name: string,
            IconName: string?,
            Visible: boolean?,
            Collapsed: boolean?,
            DisableCollapsing: boolean?,
        }
    ) -> Groupbox,
    AddLeftGroupbox: (
        self: Tab,
        Name: string,
        IconName: string?,
        Visible: boolean?,
        Collapsed: boolean?,
        DisableCollapsing: boolean?
    ) -> Groupbox,
    AddRightGroupbox: (
        self: Tab,
        Name: string,
        IconName: string?,
        Visible: boolean?,
        Collapsed: boolean?,
        DisableCollapsing: boolean?
    ) -> Groupbox,
    AddTabbox: (self: Tab, Info: { Side: number, Name: string? }) -> Tabbox,
    AddLeftTabbox: (self: Tab, Name: string?) -> Tabbox,
    AddRightTabbox: (self: Tab, Name: string?) -> Tabbox,
    Hover: (self: Tab, Hovering: boolean) -> (),
    Show: (self: Tab) -> (),
    Hide: (self: Tab) -> (),
    SetVisible: (self: Tab, Visible: boolean) -> (),
}

export type KeyBox = {
    TextBox: TextBox,
    Button: TextButton,
    Disabled: boolean,

    SetDisabled: (self: KeyBox, Disabled: boolean) -> (),
    SetText: (self: KeyBox, Text: string) -> (),
    Clear: (self: KeyBox) -> (),
    Focus: (self: KeyBox) -> (),
    Submit: (self: KeyBox) -> (),
}

export type KeyTab = BaseGroupbox & {
    Elements: { [any]: any },
    IsKeyTab: true,
    Window: Window,
    Container: ScrollingFrame,

    AddKeyBox: (self: KeyTab, Callback: (Key: string) -> ()) -> KeyBox,
    Resize: (self: KeyTab) -> (),
    Hover: (self: KeyTab, Hovering: boolean) -> (),
    Show: (self: KeyTab) -> (),
    Hide: (self: KeyTab) -> (),
    SetVisible: (self: KeyTab, Visible: boolean) -> (),
}

export type LoadingErrorButtonInfo = {
    Title: string?,
    Variant: "Primary" | "Secondary" | "Destructive" | "Ghost"?,
    Callback: ((Loading) -> ())?,
}

export type LoadingSidebar = BaseGroupbox & {
    Elements: { [number]: Element },
    DependencyBoxes: { [number]: DependencyBox },
    Tabboxes: { [string]: Tabbox },
    BoxHolder: ScrollingFrame,
    Container: ScrollingFrame,
    Tab: {
        Elements: { [number]: Element },
        DependencyBoxes: { [number]: DependencyBox },
        DependencyGroupboxes: { [number]: DependencyGroupbox },
        Tabboxes: { [string]: Tabbox },
    },

    Resize: (self: LoadingSidebar) -> (),
}

export type Loading = {
    CurrentStep: number,
    TotalSteps: number,
    ShowSidebar: boolean,
    AutoResizeHeight: boolean,
    IsError: boolean,
    Destroyed: boolean,
    WindowWidth: number,
    WindowHeight: number,
    BaseWindowHeight: number,
    WindowErrorHeight: number,
    ContentWidth: number,
    SidebarWidth: number,
    ScreenGui: ScreenGui,
    Sidebar: LoadingSidebar,

    UpdateLayout: (self: Loading) -> (),
    RecalculateLoadingHeight: (self: Loading) -> (),
    SetMessage: (self: Loading, Text: string) -> (),
    SetDescription: (self: Loading, Text: string) -> (),
    SetLoadingIcon: (self: Loading, Icon: string | number) -> (),
    SetLoadingIconTweenTime: (self: Loading, TweenTime: number) -> (),
    SetLoadingIconColor: (self: Loading, Color: Color3) -> (),
    SetCurrentStep: (self: Loading, Step: number) -> (),
    SetTotalSteps: (self: Loading, Steps: number) -> (),
    SetWindowHeight: (self: Loading, Height: number) -> (),
    SetWindowWidth: (self: Loading, Width: number) -> (),
    SetContentWidth: (self: Loading, Width: number) -> (),
    SetSidebarWidth: (self: Loading, Width: number) -> (),
    ShowSidebarPage: (self: Loading, Bool: boolean) -> (),
    ShowErrorPage: (self: Loading, Enabled: boolean) -> (),
    RecalculateErrorHeight: (self: Loading) -> (),
    SetErrorMessage: (self: Loading, Text: string) -> (),
    SetErrorButtons: (self: Loading, Buttons: { [string]: LoadingErrorButtonInfo }) -> (),
    Destroy: (self: Loading) -> (),
    Continue: (self: Loading) -> (),
}

export type DialogButtonInfo = {
    Title: string,
    Variant: "Primary" | "Secondary" | "Destructive" | "Ghost"?,
    WaitTime: number?,
    Order: number?,
    Callback: ((Dialog) -> ())?,
}

export type Dialog = {
    OutsideClickDismiss: boolean,
    SetTitle: (self: Dialog, Title: string) -> (),
    SetDescription: (self: Dialog, Description: string) -> (),
    AddFooterButton: (self: Dialog, ButtonIdx: string, ButtonInfo: DialogButtonInfo) -> (),
    RemoveFooterButton: (self: Dialog, ButtonIdx: string) -> (),
    SetButtonDisabled: (self: Dialog, ButtonIdx: string, Disabled: boolean) -> (),
    SetButtonOrder: (self: Dialog, ButtonIdx: string, Order: number) -> (),
    Dismiss: (self: Dialog) -> (),
}

export type HeaderButton = {
    Text: string,
    Disabled: boolean,
    Visible: boolean,
    Destroyed: boolean,
    Button: TextButton,

    SetText: (self: HeaderButton, Text: string) -> (),
    SetDisabled: (self: HeaderButton, Disabled: boolean) -> (),
    SetVisible: (self: HeaderButton, Visible: boolean) -> (),
    Destroy: (self: HeaderButton) -> (),
}

export type Window = {
    IsSidebarCompacted: (self: Window) -> boolean,
    GetSidebarWidth: (self: Window) -> number,
    SetSidebarWidth: (self: Window, Width: number) -> (),
    SetCompact: (self: Window, State: boolean) -> (),
    ShowTabInfo: (self: Window, Name: string, Description: string) -> (),
    HideTabInfo: (self: Window) -> (),
    AddTab: (
        self: Window,
        Info: { Name: string, Icon: string?, Description: string? } | string,
        Icon: string?,
        Description: string?
    ) -> Tab,
    AddKeyTab: (
        self: Window,
        Info: { Name: string, Icon: string?, Description: string? } | string,
        Icon: string?,
        Description: string?
    ) -> KeyTab,
    AddDialog: (
        self: Window,
        Idx: string,
        Info: {
            Title: string,
            Description: string?,
            Icon: string?,
            TitleColor: Color3?,
            DescriptionColor: Color3?,
            AutoDismiss: boolean?,
            OutsideClickDismiss: boolean?,
            FooterButtons: { [string]: DialogButtonInfo }?,
        }
    ) -> Dialog,
    ChangeTitle: (self: Window, Title: string) -> (),
    SetBackgroundImage: (self: Window, Image: string) -> (),
    SetFooter: (self: Window, Footer: string) -> (),
    ClearSearch: (self: Window) -> (),
    FocusSearch: (self: Window) -> boolean,
    AddHeaderButton: (
        self: Window,
        Info: {
            Text: string,
            Tooltip: string?,
            Callback: (() -> ())?,
            Disabled: boolean?,
            Visible: boolean?,
        } | string,
        Callback: (() -> ())?
    ) -> HeaderButton,
    SelectTab: (self: Window, Name: string) -> boolean,
    GetActiveTab: (self: Window) -> (Tab | KeyTab)?,
    GetTabs: (self: Window, VisibleOnly: boolean?) -> { Tab | KeyTab },
    NextTab: (self: Window) -> boolean,
    PreviousTab: (self: Window) -> boolean,
    ToggleSidebar: (self: Window) -> (),
    GetPosition: (self: Window) -> UDim2,
    SetPosition: (self: Window, Position: UDim2) -> (),
    Center: (self: Window) -> (),
    ResetPosition: (self: Window) -> (),
    GetSearchText: (self: Window) -> string,
    IsSearchVisible: (self: Window) -> boolean,
    SetSearchPlaceholder: (self: Window, Text: string) -> (),
    SetSearchVisible: (self: Window, Visible: boolean) -> (),
    SetGlass: (
        self: Window,
        Enabled: boolean,
        Transparency: number?,
        StrokeTransparency: number?
    ) -> (),
    SetGlassSheen: (self: Window, Enabled: boolean, Speed: number?) -> (),
    SetGlassBackgroundMotion: (self: Window, Enabled: boolean, Speed: number?) -> (),
    SetGlassBlur: (self: Window, Enabled: boolean, Size: number?) -> (),
    GetGlassPreset: (self: Window) -> string,
    SetGlassPreset: (
        self: Window,
        Preset: "Liquid"
            | "Crystal"
            | "Frosted"
            | "Solid"
            | "Ocean"
            | "Aurora"
            | "Midnight"
            | string
    ) -> boolean,
    RefreshMobileLayout: (self: Window) -> number,
    GetMobileLayout: (self: Window) -> string,
    SetMobileLayout: (
        self: Window,
        Layout: "Compact" | "Balanced" | "Expanded" | string
    ) -> boolean,
    SetTabSwipeNavigation: (self: Window, Enabled: boolean, Threshold: number?) -> (),
    GetTabSwipeNavigation: (self: Window) -> (boolean, number),
    SetCornerRadius: (self: Window, Radius: number) -> (),
    SetAnimations: (
        self: Window,
        Animations: { [string]: boolean }?,
        TabTransitionTime: number?,
        TabSwipeOffset: number?,
        TabSwipeFrom: ("left" | "right" | "top" | "bottom" | string)?
    ) -> (),
    Open: (self: Window) -> (),
    Close: (self: Window) -> (),
    Toggle: (self: Window, Value: boolean?) -> (),
}

--// Main Library Type
export type Library = {
    -- Properties
    Version: string,
    LocalPlayer: Player,
    DevicePlatform: Enum.Platform?,
    IsMobile: boolean,
    IsRobloxFocused: boolean,
    ScreenGui: ScreenGui?,
    Window: Window?,
    SearchText: string,
    Searching: boolean,
    GlobalSearch: boolean,
    LastSearchTab: Tab?,
    ActiveTab: Tab?,
    ActiveLoading: Loading?,
    Tabs: { [string]: Tab | KeyTab },
    DependencyBoxes: { [number]: DependencyBox | DependencyGroupbox },
    KeybindFrame: Frame?,
    KeybindContainer: Frame?,
    KeybindToggles: { [number]: KeybindToggle },
    Notifications: { [GuiObject]: Notification },
    ToggleKeybind: Enum.KeyCode,
    TweenInfo: TweenInfo,
    NotifyTweenInfo: TweenInfo,
    TabTransitionInfo: TweenInfo,
    TabOrder: { Tab | KeyTab },
    TabSwipeOffset: number,
    TabSwipeFrom: string,
    Animations: {
        ToggleWindow: boolean,
        TabSwitch: boolean,
        Groupbox: boolean,
        Dropdown: boolean,
        KeyPicker: boolean,
    },
    PreferredAnimations: { [string]: boolean }?,
    ReducedMotion: boolean,
    Toggled: boolean,
    Unloaded: boolean,
    Labels: { [string | number]: Label },
    Buttons: { [string | number]: Button | SubButton },
    Toggles: { [string | number]: Toggle },
    Options: { [string | number]: Option },
    NotifySide: "Right" | "Left",
    ShowCustomCursor: boolean,
    ForceCheckbox: boolean,
    ShowToggleFrameInKeybinds: boolean,
    NotifyOnError: boolean,
    CantDragForced: boolean,
    DraggableElements: { GuiObject },
    Signals: { [number]: RBXScriptConnection },
    UnloadSignals: { [number]: () -> () },
    MinSize: Vector2,
    DPIScale: number,
    CornerRadius: number,
    IsLightTheme: boolean,
    GlassEnabled: boolean,
    GlassTransparency: number,
    GlassStrokeTransparency: number,
    GlassBlurEffects: { BlurEffect },
    Scheme: Scheme,
    Registry: { [GuiObject]: { [string]: string | () -> Color3 } },
    Scales: { [GuiObject]: { [string]: any } },
    ScalesOffset: { [GuiObject]: { [string]: any } },
    CopiedColor: { Color3 | number }?,
    ImageManager: {
        AddAsset: (
            AssetName: string,
            RobloxAssetId: number,
            URL: string,
            ForceRedownload: boolean?
        ) -> (boolean, string?),
        GetAsset: (AssetName: string) -> string?,
        DownloadAsset: (AssetName: string, ForceRedownload: boolean?) -> (boolean, string?),
    },

    -- Methods
    UpdateDependencyBoxes: (self: Library) -> (),
    UpdateSearch: (self: Library, SearchText: string) -> (),
    AddToRegistry: (
        self: Library,
        Instance: GuiObject,
        Properties: { [string]: string | () -> Color3 }
    ) -> (),
    RemoveFromRegistry: (self: Library, Instance: GuiObject) -> (),
    UpdateColorsUsingRegistry: (self: Library) -> (),
    SetDPIScale: (self: Library, DPIScale: number) -> (),
    SetReducedMotion: (self: Library, Enabled: boolean) -> (),
    GiveSignal: (self: Library, Connection: RBXScriptConnection) -> RBXScriptConnection,
    GetIcon: (self: Library, IconName: string) -> Icon?,
    GetCustomIcon: (self: Library, IconName: string) -> Icon?,
    Validate: (
        self: Library,
        Table: { [string]: any },
        Template: { [string]: any }
    ) -> { [string]: any },
    ResetCursorIcon: (self: Library) -> (),
    ChangeCursorIcon: (self: Library, ImageId: string) -> (),
    ChangeCursorIconSize: (self: Library, Size: UDim2) -> (),
    GetBetterColor: (self: Library, Color: Color3, Add: number) -> Color3,
    GetLighterColor: (self: Library, Color: Color3) -> Color3,
    GetDarkerColor: (self: Library, Color: Color3) -> Color3,
    GetKeyString: (self: Library, KeyCode: Enum.KeyCode) -> string,
    GetTextBounds: (
        self: Library,
        Text: string,
        Font: Font,
        Size: number,
        Width: number?
    ) -> (number, number),
    MouseIsOverFrame: (self: Library, Frame: GuiObject, Mouse: Vector2) -> boolean,
    IsInsideFrame: (self: Library, ParentFrame: GuiObject, Frame: GuiObject) -> boolean,
    SafeCallback: (self: Library, Func: (...any) -> ...any, ...any) -> ...any,
    MakeDraggable: (
        self: Library,
        UI: GuiObject,
        DragFrame: GuiObject,
        IgnoreToggled: boolean?,
        IsMainWindow: boolean?
    ) -> (),
    MakeResizable: (
        self: Library,
        UI: GuiObject,
        DragFrame: GuiObject,
        Callback: (() -> ())?
    ) -> (),
    MakeCover: (self: Library, Holder: GuiObject, Place: string) -> Frame,
    MakeLine: (
        self: Library,
        Frame: GuiObject,
        Info: { AnchorPoint: Vector2?, Position: UDim2, Size: UDim2 }
    ) -> Frame,
    AddOutline: (self: Library, Frame: GuiObject) -> Frame,
    AddBlank: (self: Library, Frame: GuiObject, Size: UDim2) -> (),
    MakeOutline: (self: Library, Frame: GuiObject, Corner: number?, ZIndex: number?) -> Frame,
    AddDraggableLabel: (
        self: Library,
        Text: string | { Text: string, Icon: string?, IconPosition: string? },
        Icon: string?,
        IconPosition: string?
    ) -> DraggableLabel,
    AddDraggableButton: (
        self: Library,
        Text: string | {
            Text: string,
            Callback: (() -> ())?,
            Func: (() -> ())?,
            ExcludeScaling: boolean?,
            ExcludeDragging: boolean?,
            Icon: string?,
            IconPosition: string?,
        },
        Func: ((DraggableButton) -> ())?,
        ExcludeScaling: boolean?,
        ExcludeDragging: boolean?,
        Icon: string?,
        IconPosition: string?
    ) -> DraggableButton,
    AddDraggableImageButton: (
        self: Library,
        Icon: string | {
            Icon: string,
            IconSize: number?,
            Callback: (() -> ())?,
            Func: (() -> ())?,
            ExcludeScaling: boolean?,
            ExcludeDragging: boolean?,
        },
        IconSize: number?,
        Func: ((DraggableImageButton) -> ())?,
        ExcludeScaling: boolean?,
        ExcludeDragging: boolean?
    ) -> DraggableImageButton,
    AddDraggableMenu: (self: Library, Name: string) -> (Frame, Frame),
    SetWatermarkVisibility: (self: Library, Visible: boolean) -> (),
    SetWatermark: (self: Library, Text: string) -> (),
    AddContextMenu: (
        self: Library,
        Holder: GuiObject,
        Size: UDim2 | () -> UDim2,
        Offset: { [number]: number } | () -> { [number]: number },
        List: number?,
        ActiveCallback: ((boolean) -> ())?
    ) -> ContextMenu,
    AddTooltip: (
        self: Library,
        InfoStr: string,
        DisabledInfoStr: string,
        HoverInstance: GuiObject
    ) -> Tooltip,
    CloseTransientUI: (self: Library) -> boolean,
    OnUnload: (self: Library, Callback: () -> ()) -> (),
    Unload: (self: Library) -> (),
    SetIconModule: (self: Library, module: any) -> (),
    SetFont: (self: Library, FontFace: Font | Enum.Font) -> (),
    SetNotifySide: (self: Library, Side: "Left" | "Right") -> (),
    Notify: (
        self: Library,
        Info: {
            Title: string?,
            Description: string,
            Time: number?,
            SoundId: string | number?,
            Volume: number?,
            Steps: number?,
            Persist: boolean?,
            TitleColor: Color3?,
            DescriptionColor: Color3?,
            Icon: string | number?,
            IconColor: Color3 | string?,
            BigIcon: string?,
        } | string,
        Time: number?,
        SoundId: string | number?
    ) -> Notification,
    CreateLoading: (self: Library, LoadingInfo: LoadingInfo) -> Loading,
    CreateWindow: (
        self: Library,
        WindowInfo: {
            Title: string?,
            Footer: string?,
            Position: UDim2?,
            Size: UDim2?,
            Icon: string?,
            IconSize: UDim2?,
            BackgroundImage: string?,
            AutoShow: boolean?,
            Center: boolean?,
            Resizable: boolean?,
            DisableSearch: boolean?,
            SearchbarSize: UDim2?,
            GlobalSearch: boolean?,
            CornerRadius: number?,
            NotifySide: "Left" | "Right"?,
            ShowCustomCursor: boolean?,
            Glass: boolean?,
            GlassTransparency: number?,
            GlassStrokeTransparency: number?,
            GlassPreset: "Liquid"
                | "Crystal"
                | "Frosted"
                | "Solid"
                | "Ocean"
                | "Aurora"
                | "Midnight"
                | "Custom"?,
            GlassSheen: boolean?,
            GlassSheenSpeed: number?,
            GlassBackgroundMotion: boolean?,
            GlassBackgroundMotionSpeed: number?,
            GlassBlur: boolean?,
            GlassBlurSize: number?,
            Font: Font | Enum.Font?,
            ToggleKeybind: Enum.KeyCode?,
            ShowMobileButtons: boolean?,
            MobileButtonsSide: "Left" | "Right"?,
            MobileScale: number?,
            MobileViewportPadding: number?,
            MobileStartCompacted: boolean?,
            MobileLayout: "Compact" | "Balanced" | "Expanded"?,
            EnableTabSwipeNavigation: boolean?,
            TabSwipeNavigationThreshold: number?,
            UnlockMouseWhileOpen: boolean?,
            EnableSidebarResize: boolean?,
            EnableCompacting: boolean?,
            DisableCompactingSnap: boolean?,
            SidebarCompacted: boolean?,
            MinContainerWidth: number?,
            MinSidebarWidth: number?,
            SidebarCompactWidth: number?,
            SidebarCollapseThreshold: number?,
            CompactWidthActivation: number?,
            Animations: {
                ToggleWindow: boolean?,
                TabSwitch: boolean?,
                Groupbox: boolean?,
                Dropdown: boolean?,
                KeyPicker: boolean?,
            }?,
            TabTransitionTime: number?,
            TabSwipeOffset: number?,
            TabSwipeFrom: ("left" | "right" | "top" | "bottom" | string)?,
        }
    ) -> Window,
    Toggle: (self: Library, Value: boolean?) -> (),
}

--// Optional persistence add-on types
export type SaveManager = {
    Library: Library?,
    Folder: string,
    SubFolder: string,
    Ignore: { [string]: boolean },
    LoadingOrder: { string },
    UseLoadingOrder: boolean,
    AutoloadConfig: string?,

    SetLibrary: (self: SaveManager, Library: Library) -> (),
    IsSupported: (self: SaveManager) -> (boolean, string?),
    SetLoadingOrder: (self: SaveManager, Enabled: boolean, Order: { string }?) -> (),
    SetIgnoreIndexes: (self: SaveManager, Indexes: { string }) -> (),
    IgnoreThemeSettings: (self: SaveManager) -> (),
    GetPaths: (self: SaveManager) -> { string },
    BuildFolderTree: (self: SaveManager, SkipWhenCreated: boolean?) -> (boolean, string?),
    CheckFolderTree: (self: SaveManager) -> (boolean, string?),
    CheckSubFolder: (self: SaveManager, CreateFolder: boolean) -> (boolean, string?),
    SetFolder: (self: SaveManager, Folder: string) -> (),
    SetSubFolder: (self: SaveManager, SubFolder: string) -> (),
    RefreshConfigList: (self: SaveManager) -> ({ string }, string?),
    Save: (self: SaveManager, ConfigName: string) -> (boolean, string?),
    Load: (self: SaveManager, ConfigName: string) -> (boolean, string?),
    Delete: (self: SaveManager, ConfigName: string) -> (boolean, string?),
    Rename: (self: SaveManager, CurrentName: string, NewName: string) -> (boolean, string?),
    GetAutoloadConfig: (self: SaveManager) -> (string, boolean, string?),
    SaveAutoloadConfig: (self: SaveManager, ConfigName: string) -> (boolean, string?),
    LoadAutoloadConfig: (self: SaveManager) -> (boolean, string?),
    DeleteAutoLoadConfig: (self: SaveManager) -> (boolean, string?),
    BuildConfigSection: (self: SaveManager, Tab: Tab, IconName: string?) -> Groupbox,
}

export type ThemeManager = {
    Library: Library?,
    Folder: string,
    AppliedToTab: boolean,
    DefaultThemeName: string?,

    SetLibrary: (self: ThemeManager, Library: Library) -> (),
    IsSupported: (self: ThemeManager) -> (boolean, string?),
    GetPaths: (self: ThemeManager) -> { string },
    BuildFolderTree: (self: ThemeManager, SkipWhenCreated: boolean?) -> (boolean, string?),
    CheckFolderTree: (self: ThemeManager) -> (boolean, string?),
    SetFolder: (self: ThemeManager, Folder: string) -> (),
    ReloadCustomThemes: (self: ThemeManager) -> { string },
    GetCustomTheme: (self: ThemeManager, ThemeName: string) -> { [string]: any }?,
    SaveCustomTheme: (self: ThemeManager, ThemeName: string) -> (boolean, string?),
    Delete: (self: ThemeManager, ThemeName: string) -> (boolean, string?),
    GetDefaultTheme: (self: ThemeManager) -> (string, boolean, string?),
    SetDefaultTheme: (self: ThemeManager, Theme: { [string]: any }) -> (),
    SaveDefault: (self: ThemeManager, ThemeName: string) -> (boolean, string?),
    LoadDefault: (self: ThemeManager) -> (boolean, string?),
    DeleteDefaultTheme: (self: ThemeManager) -> (boolean, string?),
    ThemeUpdate: (self: ThemeManager) -> (boolean, string?),
    ApplyTheme: (self: ThemeManager, ThemeName: string) -> (boolean, string?),
    CreateThemeManager: (self: ThemeManager, Themesbox: Groupbox) -> Groupbox,
    CreateGroupBox: (self: ThemeManager, Tab: Tab, IconName: string?) -> Groupbox,
    ApplyToTab: (self: ThemeManager, Tab: Tab, IconName: string?) -> Groupbox,
    ApplyToGroupbox: (self: ThemeManager, Groupbox: Groupbox) -> Groupbox,
}

export type KeySystemState = "Idle" | "Checking" | "Verified" | "Rejected" | "Locked"

export type KeySystemOptions = {
    Validate: (Key: string) -> (boolean, string?),
    MaxAttempts: number?,
    CooldownSeconds: number?,
    OnVerified: ((KeySystem) -> ())?,
    OnRejected: ((KeySystem, string) -> ())?,
    OnLoggedOut: ((KeySystem) -> ())?,
    OnStateChanged: ((KeySystem, KeySystemState, string?) -> ())?,
}

export type KeySystemRemoteOptions = {
    MaxAttempts: number?,
    CooldownSeconds: number?,
    OnVerified: ((KeySystem) -> ())?,
    OnRejected: ((KeySystem, string) -> ())?,
    OnLoggedOut: ((KeySystem) -> ())?,
    OnStateChanged: ((KeySystem, KeySystemState, string?) -> ())?,
}

export type KeySystemUIOptions = {
    Prompt: string?,
    Placeholder: string?,
    CheckingText: string?,
    VerifiedText: string?,
    RejectedPrefix: string?,
    LockedText: string?,
    ResetText: string?,
    ShowResetButton: boolean?,
}

export type KeySystemGateOptions = {
    DefaultTab: Tab | KeyTab?,
    HideLoginTabAfterVerification: boolean?,
    HideSearchBeforeVerification: boolean?,
}

export type KeySystemGateController = {
    Lock: (self: KeySystemGateController) -> (),
    Unlock: (self: KeySystemGateController) -> (),
}

export type KeySystemUI = {
    PromptLabel: Label?,
    StatusLabel: Label?,
    KeyBox: KeyBox,
    ResetButton: Button?,
}

export type KeySystem = {
    State: KeySystemState,
    Attempts: number,
    MaxAttempts: number?,
    CooldownSeconds: number,
    NextAttemptAt: number,
    LastError: string?,

    Verify: (self: KeySystem, Key: string) -> (boolean, string?),
    Reset: (self: KeySystem) -> (),
    GetRemainingAttempts: (self: KeySystem) -> number?,
    GetStatus: (self: KeySystem) -> (KeySystemState, string?),
    IsVerified: (self: KeySystem) -> boolean,
    IsLocked: (self: KeySystem) -> boolean,
    Logout: (self: KeySystem) -> boolean,
    GateTabs: (
        self: KeySystem,
        LoginTab: KeyTab,
        ProtectedTabs: { Tab | KeyTab },
        Options: KeySystemGateOptions?
    ) -> KeySystemGateController,
    Attach: (self: KeySystem, KeyTab: KeyTab, Options: KeySystemUIOptions?) -> KeySystemUI,
}

export type HUDTextInfo = {
    Text: string,
    Value: string | number?,
    Order: number?,
    Visible: boolean?,
}

export type HUDProgressInfo = {
    Text: string,
    Value: number?,
    Order: number?,
    Visible: boolean?,
    Format: ((number) -> string)?,
}

export type HUDTimerInfo = {
    Text: string,
    Duration: number,
    Remaining: number?,
    Running: boolean?,
    Order: number?,
    Visible: boolean?,
    OnCompleted: (() -> ())?,
}

export type HUDWaypointInfo = {
    Text: string,
    Target: Vector3 | BasePart | Attachment | Model | (() -> Vector3?),
    Order: number?,
    Visible: boolean?,
    MaxDistance: number?,
}

export type HUDMarkerInfo = {
    Text: string,
    Target: BasePart | Attachment,
    Color: Color3?,
    MaxDistance: number?,
    AlwaysOnTop: boolean?,
    Visible: boolean?,
}

export type HUDInteractionInfo = HUDMarkerInfo & {
    ActionText: string?,
    HoldDuration: number?,
    OnTriggered: ((Player) -> ())?,
}

export type HUDPartyMember = {
    Id: string,
    Name: string,
    Status: string | number?,
    Visible: boolean?,
}

export type HUDPerformanceInfo = {
    Text: string?,
    Order: number?,
    Visible: boolean?,
    PingProvider: (() -> string | number?)?,
}

export type HUDOptions = {
    Title: string?,
    Position: UDim2?,
    Visible: boolean?,
    UpdateInterval: number?,
}

export type HUDTextEntry = {
    Index: string,
    Text: string,
    Value: string | number?,
    Destroyed: boolean,
    SetText: (self: HUDTextEntry, Text: string) -> (),
    SetValue: (self: HUDTextEntry, Value: string | number?) -> (),
    SetVisible: (self: HUDTextEntry, Visible: boolean) -> (),
    Destroy: (self: HUDTextEntry) -> (),
}

export type HUDProgressEntry = {
    Index: string,
    Text: string,
    Value: number,
    Destroyed: boolean,
    SetText: (self: HUDProgressEntry, Text: string) -> (),
    SetValue: (self: HUDProgressEntry, Value: number) -> (),
    SetVisible: (self: HUDProgressEntry, Visible: boolean) -> (),
    Destroy: (self: HUDProgressEntry) -> (),
}

export type HUDTimer = {
    Duration: number,
    Remaining: number,
    Running: boolean,
    Destroyed: boolean,
    SetRemaining: (self: HUDTimer, Remaining: number) -> (),
    Start: (self: HUDTimer) -> (),
    Pause: (self: HUDTimer) -> (),
    Reset: (self: HUDTimer, Remaining: number?) -> (),
    Destroy: (self: HUDTimer) -> (),
}

export type HUDWaypoint = {
    Destroyed: boolean,
    SetTarget: (
        self: HUDWaypoint,
        Target: Vector3 | BasePart | Attachment | Model | (() -> Vector3?)
    ) -> (),
    Destroy: (self: HUDWaypoint) -> (),
}

export type HUDMarker = {
    Destroyed: boolean,
    SetText: (self: HUDMarker, Text: string) -> (),
    SetVisible: (self: HUDMarker, Visible: boolean) -> (),
    Destroy: (self: HUDMarker) -> (),
}

export type HUDPerformance = {
    Destroyed: boolean,
    Destroy: (self: HUDPerformance) -> (),
}

export type HUD = {
    Library: Library,
    Holder: Frame,
    Container: Frame,
    Title: string,
    Visible: boolean,
    UpdateInterval: number,
    Destroyed: boolean,
    AddText: (self: HUD, Index: string, Info: HUDTextInfo | string) -> HUDTextEntry,
    AddProgress: (self: HUD, Index: string, Info: HUDProgressInfo) -> HUDProgressEntry,
    AddCounter: (self: HUD, Index: string, Info: HUDTextInfo) -> HUDTextEntry,
    AddTimer: (self: HUD, Index: string, Info: HUDTimerInfo) -> HUDTimer,
    AddCooldown: (self: HUD, Index: string, Info: HUDTimerInfo) -> HUDTimer,
    AddProgressRing: (self: HUD, Index: string, Info: HUDProgressInfo) -> HUDTextEntry,
    AddWaypoint: (self: HUD, Index: string, Info: HUDWaypointInfo) -> HUDWaypoint,
    AddObjectiveTracker: (self: HUD, Index: string, Info: HUDWaypointInfo) -> HUDWaypoint,
    AddObjectiveMarker: (self: HUD, Index: string, Info: HUDMarkerInfo) -> HUDMarker,
    AddInteractionPrompt: (self: HUD, Index: string, Info: HUDInteractionInfo) -> HUDMarker,
    SetParty: (self: HUD, Members: { HUDPartyMember }) -> (),
    AddPerformance: (self: HUD, Index: string, Info: HUDPerformanceInfo?) -> HUDPerformance,
    SetUpdateInterval: (self: HUD, Seconds: number) -> (),
    Alert: (self: HUD, Info: { [string]: any } | string, Time: number?) -> Notification,
    GetEntry: (self: HUD, Index: string) -> (HUDTextEntry | HUDProgressEntry)?,
    Remove: (self: HUD, Index: string) -> boolean,
    Clear: (self: HUD) -> (),
    ClearMarkers: (self: HUD) -> (),
    SetVisible: (self: HUD, Visible: boolean) -> (),
    Toggle: (self: HUD) -> (),
    SetTitle: (self: HUD, Title: string) -> (),
    Destroy: (self: HUD) -> (),
}

export type BoxStyle = "Corner" | "Standard" | "Outline"
export type TracerOrigin = "Bottom" | "Middle" | "Mouse"

export type PlayerESPOptions = {
    Enabled: boolean?,
    Box: boolean?,
    BoxStyle: BoxStyle?,
    BoxColor: Color3?,
    BoxTransparency: number?,
    BoxThickness: number?,
    HealthBar: boolean?,
    HealthBarColor: boolean?,
    HealthBarTransparency: number?,
    Name: boolean?,
    NameSize: number?,
    NameColor: Color3?,
    Distance: boolean?,
    DistanceColor: Color3?,
    Tracer: boolean?,
    TracerOrigin: TracerOrigin?,
    TracerColor: Color3?,
    TracerTransparency: number?,
    Chams: boolean?,
    ChamsColor: Color3?,
    ChamsTransparency: number?,
    TeamCheck: boolean?,
    MaxDistance: number?,
    VisibleCheck: boolean?,
    CustomFilter: ((Player) -> boolean)?,
}

export type ObjectESPOptions = {
    Enabled: boolean?,
    Box: boolean?,
    BoxColor: Color3?,
    BoxTransparency: number?,
    Name: boolean?,
    NameColor: Color3?,
    Distance: boolean?,
    DistanceColor: Color3?,
    Tracer: boolean?,
    TracerColor: Color3?,
    TracerTransparency: number?,
    Highlight: boolean?,
    HighlightColor: Color3?,
    HighlightTransparency: number?,
    MaxDistance: number?,
    CustomName: string?,
}

export type AimbotHitbox = "Head" | "Torso" | "Limb" | "Random"

export type AimbotOptions = {
    Enabled: boolean?,
    SilentAim: boolean?,
    Prediction: boolean?,
    PredictionAmount: number?,
    Smoothness: number?,
    Hitbox: AimbotHitbox?,
    AutoFire: boolean?,
    AutoFireDelay: number?,
    FOV: number?,
    MaxDistance: number?,
    TeamCheck: boolean?,
    VisibleCheck: boolean?,
    MagicBullet: boolean?,
    MagicBulletChance: number?,
}

export type FOVCircleOptions = {
    Enabled: boolean?,
    Radius: number?,
    Color: Color3?,
    Transparency: number?,
    Thickness: number?,
    Filled: boolean?,
    Visible: boolean?,
}

export type ESPOptions = {
    UpdateInterval: number?,
    TeamColor: Color3?,
    EnemyColor: Color3?,
    DefaultBoxColor: Color3?,
}

export type PlayerESPHandler = {
    Options: PlayerESPOptions,
    TargetPlayer: Player?,
    Destroyed: boolean,
    Destroy: (self: PlayerESPHandler) -> (),
}

export type ObjectESPHandler = {
    Target: Instance,
    Options: ObjectESPOptions,
    Destroyed: boolean,
    Destroy: (self: ObjectESPHandler) -> (),
}

export type ESPManager = {
    Enabled: boolean,
    BoxesVisible: boolean,
    NamesVisible: boolean,
    TracersVisible: boolean,
    HealthBarsVisible: boolean,
    ChamsVisible: boolean,
    TeamCheck: boolean,
    TeamColor: Color3,
    EnemyColor: Color3,
    DefaultBoxColor: Color3,
    TargetLock: Player?,

    AddPlayerESP: (self: ESPManager, Options: PlayerESPOptions) -> PlayerESPHandler,
    AddObjectESP: (
        self: ESPManager,
        Target: Instance,
        Options: ObjectESPOptions
    ) -> ObjectESPHandler,
    RemovePlayerESP: (self: ESPManager, Player: Player) -> (),
    RemoveObjectESP: (self: ESPManager, Target: Instance) -> (),
    SetEnabled: (self: ESPManager, Enabled: boolean) -> (),
    SetBoxesVisible: (self: ESPManager, Visible: boolean) -> (),
    SetNamesVisible: (self: ESPManager, Visible: boolean) -> (),
    SetTracersVisible: (self: ESPManager, Visible: boolean) -> (),
    SetTeamCheck: (self: ESPManager, Enabled: boolean) -> (),
    SetFOVCircle: (self: ESPManager, Options: FOVCircleOptions) -> (),
    ShowFOVCircle: (self: ESPManager, Visible: boolean) -> (),
    GetNearestPlayerToMouse: (self: ESPManager, MaxDistance: number?) -> (Player?, number?),
    GetNearestPlayerToCharacter: (self: ESPManager, MaxDistance: number?) -> (Player?, number?),
    IsTargetInFOV: (self: ESPManager, Target: Player | Model, FOVRadius: number) -> boolean,
    LockOntoTarget: (self: ESPManager, Player: Player) -> (),
    UnlockTarget: (self: ESPManager) -> (),
    GetLockedTarget: (self: ESPManager) -> Player?,
    GetAllPlayers: (self: ESPManager) -> { Player },
    SetAimbotEnabled: (self: ESPManager, Enabled: boolean) -> (),
    SetAimbotOptions: (self: ESPManager, Options: AimbotOptions) -> (),
    GetAimbotTarget: (self: ESPManager) -> (Player?, Vector3?),
    GetAimbotTargetPosition: (self: ESPManager, Player: Player) -> Vector3?,
    Destroy: (self: ESPManager) -> (),
}

export type BlipStyle = "Dot" | "Arrow" | "Ring"
export type RadarPosition = "TopLeft" | "TopRight" | "BottomLeft" | "BottomRight" | "Custom"

export type RadarOptions = {
    Range: number?,
    Zoom: number?,
    Size: number?,
    Position: RadarPosition?,
    CustomPosition: UDim2?,
    BackgroundTransparency: number?,
    BackgroundColor: Color3?,
    BorderColor: Color3?,
    ShowLocalFOV: boolean?,
    FOVColor: Color3?,
    FOVTransparency: number?,
    FOVAngle: number?,
    BlipStyle: BlipStyle?,
    BlipSize: number?,
    ShowNames: boolean?,
    ShowGrid: boolean?,
    TeamColor: Color3?,
    EnemyColor: Color3?,
    LocalColor: Color3?,
    Visible: boolean?,
    UpdateInterval: number?,
}

export type Radar = {
    Range: number,
    Zoom: number,
    Size: number,
    Visible: boolean,
    BlipStyle: BlipStyle,
    BlipSize: number,
    ShowNames: boolean,
    TeamColor: Color3,
    EnemyColor: Color3,
    LocalColor: Color3,
    Destroyed: boolean,

    SetRange: (self: Radar, Range: number) -> (),
    SetZoom: (self: Radar, Zoom: number) -> (),
    SetVisible: (self: Radar, Visible: boolean) -> (),
    Toggle: (self: Radar) -> (),
    SetPosition: (self: Radar, Position: RadarPosition, CustomPosition: UDim2?) -> (),
    SetBackgroundTransparency: (self: Radar, Transparency: number) -> (),
    SetShowFOV: (self: Radar, Enabled: boolean) -> (),
    SetFOVAngle: (self: Radar, Angle: number) -> (),
    SetBlipStyle: (self: Radar, Style: BlipStyle) -> (),
    SetShowNames: (self: Radar, Show: boolean) -> (),
    SetBlipSize: (self: Radar, Size: number) -> (),
    SetTeamColor: (self: Radar, Color: Color3) -> (),
    SetEnemyColor: (self: Radar, Color: Color3) -> (),
    Destroy: (self: Radar) -> (),
}

export type FlyControl = "Classic" | "Directional"
export type AntiVoidAction = "Teleport" | "Float"

export type MovementOptions = {
    WalkSpeed: number?,
    JumpPower: number?,
    JumpHeight: number?,
    Gravity: number?,
    FlySpeed: number?,
    FlyControl: FlyControl?,
    AutoNoclipWhenFlying: boolean?,
    AntiVoid: boolean?,
    AntiVoidAction: AntiVoidAction?,
    VoidThreshold: number?,
    AntiKick: boolean?,
    AntiTeleport: boolean?,
    AutoUpdateSpeed: boolean?,
}

export type Movement = {
    WalkSpeed: number,
    JumpPower: number,
    FlySpeed: number,
    Flying: boolean,
    Noclipping: boolean,
    AntiVoid: boolean,
    AntiTeleport: boolean,
    Destroyed: boolean,

    SetWalkSpeed: (self: Movement, Speed: number, Enable: boolean?) -> (),
    SetJumpPower: (self: Movement, Power: number, Enable: boolean?) -> (),
    SetJumpHeight: (self: Movement, Height: number, Enable: boolean?) -> (),
    SetGravity: (self: Movement, G: number) -> (),
    ResetGravity: (self: Movement) -> (),
    ToggleFly: (self: Movement) -> (),
    SetFlying: (self: Movement, Fly: boolean) -> (),
    SetNoclipping: (self: Movement, Noclip: boolean) -> (),
    ToggleNoclip: (self: Movement) -> (),
    SetFlySpeed: (self: Movement, Speed: number) -> (),
    SetFlyControl: (self: Movement, Control: FlyControl) -> (),
    SetAntiVoid: (self: Movement, Enabled: boolean, Action: AntiVoidAction?) -> (),
    SetAntiKick: (self: Movement, Enabled: boolean) -> (),
    SetAntiTeleport: (self: Movement, Enabled: boolean) -> (),
    Destroy: (self: Movement) -> (),
}

export type VisualsOptions = {
    Fullbright: boolean?,
    NightVision: boolean?,
    NightVisionIntensity: number?,
    XRay: boolean?,
    FogOverride: boolean?,
    FogStart: number?,
    FogEnd: number?,
    FogColor: Color3?,
    FPSCounter: boolean?,
}

export type Visuals = {
    Fullbright: boolean,
    NightVision: boolean,
    XRay: boolean,
    FogOverride: boolean,
    FPSCounter: boolean,
    Destroyed: boolean,

    SetFullbright: (self: Visuals, Enabled: boolean) -> (),
    SetNightVision: (self: Visuals, Enabled: boolean, Intensity: number?) -> (),
    SetXRay: (self: Visuals, Enabled: boolean) -> (),
    SetFogOverride: (
        self: Visuals,
        Enabled: boolean,
        Start: number?,
        End: number?,
        Color: Color3?
    ) -> (),
    ResetFog: (self: Visuals) -> (),
    SetFPSCounter: (self: Visuals, Enabled: boolean) -> (),
    ResetAll: (self: Visuals) -> (),
    Destroy: (self: Visuals) -> (),
}

export type CameraOptions = {
    ThirdPerson: boolean?,
    ThirdPersonDistance: number?,
    ThirdPersonSmoothness: number?,
    FOV: number?,
    FOVEnabled: boolean?,
    ViewLock: boolean?,
    ViewLockCFrame: CFrame?,
    Spin: boolean?,
    SpinSpeed: number?,
    Freecam: boolean?,
    FreecamSpeed: number?,
}

export type Camera = {
    ThirdPerson: boolean,
    ThirdPersonDistance: number,
    FOV: number,
    FOVEnabled: boolean,
    ViewLock: boolean,
    Spin: boolean,
    SpinSpeed: number,
    Freecam: boolean,
    FreecamSpeed: number,
    Destroyed: boolean,

    SetThirdPerson: (self: Camera, Enabled: boolean, Distance: number?) -> (),
    SetFOV: (self: Camera, FOV: number, Enabled: boolean?) -> (),
    ResetFOV: (self: Camera) -> (),
    SetViewLock: (self: Camera, Enabled: boolean, Target: CFrame?) -> (),
    SetSpin: (self: Camera, Enabled: boolean, Speed: number?) -> (),
    SetFreecam: (self: Camera, Enabled: boolean) -> (),
    SetFreecamSpeed: (self: Camera, Speed: number) -> (),
    ResetAll: (self: Camera) -> (),
    Destroy: (self: Camera) -> (),
}

export type ProtectionOptions = {
    AntiKick: boolean?,
    AntiKickRejoin: boolean?,
    AntiCrash: boolean?,
    AntiCrashFilterParts: boolean?,
    AntiCrashFilterSounds: boolean?,
    AntiCrashFilterMeshes: boolean?,
    AntiCrashFilterParticles: boolean?,
    AntiIdle: boolean?,
    AntiIdleInterval: number?,
    AntiLag: boolean?,
    AntiLagGraphicsLevel: number?,
    AntiLagDisableShadows: boolean?,
    AntiLagDisableEffects: boolean?,
}

export type Protections = {
    AntiKick: boolean,
    AntiKickRejoin: boolean,
    AntiCrash: boolean,
    AntiIdle: boolean,
    AntiLag: boolean,
    Destroyed: boolean,

    SetAntiKick: (self: Protections, Enabled: boolean, Rejoin: boolean?) -> (),
    SetAntiCrash: (
        self: Protections,
        Enabled: boolean,
        FilterParts: boolean?,
        FilterSounds: boolean?,
        FilterMeshes: boolean?,
        FilterParticles: boolean?
    ) -> (),
    SetAntiIdle: (self: Protections, Enabled: boolean, Interval: number?) -> (),
    SetAntiLag: (self: Protections, Enabled: boolean, GraphicsLevel: number?) -> (),
    SetAntiLagGraphicsLevel: (self: Protections, Level: number) -> (),
    DisableAll: (self: Protections) -> (),
    GetStatus: (self: Protections) -> { [string]: boolean },
    Destroy: (self: Protections) -> (),
}

export type ServerInfoOptions = {
    Visible: boolean?,
    Position: UDim2?,
    UpdateInterval: number?,
    ShowServerInfo: boolean?,
    ShowPlayerInfo: boolean?,
}

export type ServerInfo = {
    Visible: boolean,
    ShowServerInfo: boolean,
    ShowPlayerInfo: boolean,
    UpdateInterval: number,
    Destroyed: boolean,

    SetVisible: (self: ServerInfo, Visible: boolean) -> (),
    Toggle: (self: ServerInfo) -> (),
    SelectPlayer: (self: ServerInfo, Player: Player?) -> (),
    GetPlayerList: (self: ServerInfo) -> { Player },
    SetShowServerInfo: (self: ServerInfo, Show: boolean) -> (),
    SetShowPlayerInfo: (self: ServerInfo, Show: boolean) -> (),
    SetUpdateInterval: (self: ServerInfo, Seconds: number) -> (),
    Destroy: (self: ServerInfo) -> (),
}

export type QoLOptions = {
    Visible: boolean?,
    Position: UDim2?,
}

export type QoL = {
    Options: {
        ItemEsp: boolean,
        ItemEspColor: Color3,
        ItemEspTransparency: number,
        ItemEspRange: number,
        AutoCollect: boolean,
        AutoCollectRange: number,
        AntiVoidEnabled: boolean,
        AntiVoidMode: string,
        AntiVoidY: number,
        AutoClick: boolean,
        AutoClickInterval: number,
    },
    Destroyed: boolean,

    TeleportToPlayer: (self: QoL, TargetPlayer: Player) -> (boolean, string?),
    TeleportToPosition: (self: QoL, Position: Vector3) -> (boolean, string?),
    TeleportToCoordinates: (self: QoL, X: number, Y: number, Z: number) -> (boolean, string?),
    TeleportToWaypoint: (self: QoL, Waypoint: CFrame) -> (boolean, string?),
    GetServerId: (self: QoL) -> string,
    GetPlaceId: (self: QoL) -> number,
    RejoinServer: (self: QoL) -> (),
    CopyServerLink: (self: QoL) -> string,
    ServerHop: (self: QoL) -> (),
    SetItemEsp: (self: QoL, Enabled: boolean) -> (),
    SetItemEspColor: (self: QoL, Color: Color3) -> (),
    SetItemEspTransparency: (self: QoL, Transparency: number) -> (),
    SetItemEspRange: (self: QoL, Range: number) -> (),
    SetAutoCollect: (self: QoL, Enabled: boolean) -> (),
    SetAutoCollectRange: (self: QoL, Range: number) -> (),
    SetAntiVoid: (self: QoL, Enabled: boolean, Mode: string?) -> (),
    SetAntiVoidY: (self: QoL, Y: number) -> (),
    SetAntiVoidMode: (self: QoL, Mode: string) -> (),
    SetAutoClick: (self: QoL, Enabled: boolean) -> (),
    SetAutoClickInterval: (self: QoL, Interval: number) -> (),
    SetCharacterWalkSpeed: (self: QoL, Speed: number) -> (),
    SetCharacterJumpPower: (self: QoL, Power: number) -> (),
    ResetCharacterModifiers: (self: QoL) -> (),
    GetPlayerList: (self: QoL) -> { Player },
    GetPlayerByName: (self: QoL, Name: string) -> Player?,
    Destroy: (self: QoL) -> (),
}

export type PaletteColor = {
    Name: string,
    Color: Color3,
}

export type WatermarkOptions = {
    Visible: boolean?,
    Position: UDim2?,
    Title: string?,
    ShowFPS: boolean?,
    ShowPing: boolean?,
    ShowPlayers: boolean?,
    ShowTime: boolean?,
    TextSize: number?,
}

export type ColorPaletteOptions = {
    Visible: boolean?,
    Position: UDim2?,
    Colors: { PaletteColor }?,
    OnColorSelected: ((Color3, string) -> ())?,
}

export type UIUtilitiesOptions = {
    Watermark: WatermarkOptions?,
    ColorPalette: ColorPaletteOptions?,
}

export type UIUtilities = {
    Watermark: Instance?,
    ColorPaletteMenu: Instance?,
    Destroyed: boolean,

    SetWatermarkVisible: (self: UIUtilities, Visible: boolean) -> (),
    SetWatermarkTitle: (self: UIUtilities, Title: string) -> (),
    SetWatermarkOption: (self: UIUtilities, Option: string, Value: boolean) -> (),
    Notify: (self: UIUtilities, Title: string, Description: string, Time: number?) -> (),
    NotifySuccess: (self: UIUtilities, Description: string, Title: string?, Time: number?) -> (),
    NotifyError: (self: UIUtilities, Description: string, Title: string?, Time: number?) -> (),
    NotifyInfo: (self: UIUtilities, Description: string, Title: string?, Time: number?) -> (),
    NotifyWarning: (self: UIUtilities, Description: string, Title: string?, Time: number?) -> (),
    SetPaletteVisible: (self: UIUtilities, Visible: boolean) -> (),
    SetPaletteCallback: (self: UIUtilities, Callback: (Color3, string) -> ()) -> (),
    Destroy: (self: UIUtilities) -> (),
}

export type Package = {
    Library: Library,
    SaveManager: SaveManager,
    ThemeManager: ThemeManager,
    KeySystem: {
        new: (Options: KeySystemOptions) -> KeySystem,
        fromRemote: (Remote: RemoteFunction, Options: KeySystemRemoteOptions?) -> KeySystem,
    },
    HUD: {
        new: (Library: Library, Options: HUDOptions?) -> HUD,
    },
    ESP: {
        new: (Library: Library, Options: ESPOptions?) -> ESPManager,
    },
    Radar: {
        new: (Library: Library, Options: RadarOptions?) -> Radar,
    },
    Movement: {
        new: (Library: Library, Options: MovementOptions?) -> Movement,
    },
    Visuals: {
        new: (Library: Library, Options: VisualsOptions?) -> Visuals,
    },
    Camera: {
        new: (Library: Library, Options: CameraOptions?) -> Camera,
    },
    Protections: {
        new: (Library: Library, Options: ProtectionOptions?) -> Protections,
    },
    ServerInfo: {
        new: (Library: Library, Options: ServerInfoOptions?) -> ServerInfo,
    },
    QoL: {
        new: (Library: Library, Options: QoLOptions?) -> QoL,
    },
    UIUtilities: {
        new: (Library: Library, Options: UIUtilitiesOptions?) -> UIUtilities,
    },
}

return nil
