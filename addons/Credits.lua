--!strict
-- Reusable Cyan credits/community panel.

local Credits = {}
Credits.__index = Credits

export type Info = {
    Title: string?,
    Author: string?,
    Discord: string?,
    Icon: string?,
}

export type Credits = {
    Library: any,
    Title: string,
    Author: string,
    Discord: string,
    Icon: string,
    Attach: (self: Credits, Tab: any) -> any,
}

function Credits.new(Library: any, Info: Info?): Credits
    assert(typeof(Library) == "table", "Credits.new requires a Cyan Library")
    Info = Info or {}

    return setmetatable({
        Library = Library,
        Title = Info.Title or "Credits",
        Author = Info.Author or "Made by EB",
        Discord = Info.Discord or "",
        Icon = Info.Icon or "badge-check",
    }, Credits) :: any
end

function Credits:Attach(Tab: any)
    assert(typeof(Tab) == "table" and typeof(Tab.AddLeftGroupbox) == "function", "Credits:Attach requires a Cyan tab")

    local Group = Tab:AddLeftGroupbox(self.Title, self.Icon)
    Group:AddLabel(self.Author, true)
    if self.Discord ~= "" then
        Group:AddLabel("Community & Discord: " .. self.Discord, true)
    end

    return Group
end

return Credits
