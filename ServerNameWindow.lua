------------------------------------------------------------------------------------------
-- ServerNameWindow file
-- Originally written by Homeopatix
-- Refactored for AltHolic 4.91
------------------------------------------------------------------------------------------

local WINDOW_WIDTH = 400;
local BASE_WINDOW_HEIGHT = 200;
local ROW_HEIGHT = 35;
local checkboxes = {};

local function GetServerEntries()
    local entries = {};
    for index, name in pairs(ServerNames or {}) do
        entries[#entries + 1] = { index = index, name = name };
    end
    table.sort(entries, function(a, b)
        if type(a.index) == "number" and type(b.index) == "number" then
            return a.index < b.index;
        end
        return tostring(a.name) < tostring(b.name);
    end);
    return entries;
end

local function SetExclusiveServer(selectedIndex)
    for index, checkbox in pairs(checkboxes) do
        checkbox:SetChecked(index == selectedIndex);
    end
end

function GenerateServerNameWindow(playerName)
    AltHolicUtil.DetachControl(ServerNameWindow);
    local servers = GetServerEntries();
    local windowHeight = BASE_WINDOW_HEIGHT + (#servers * 32);
    windowHeight = math.min(windowHeight, Turbine.UI.Display:GetHeight() - 150);
    windowHeight = math.max(BASE_WINDOW_HEIGHT, windowHeight);

    checkboxes = {};

    ServerNameWindow = Turbine.UI.Lotro.GoldWindow();
    ServerNameWindow:SetSize(WINDOW_WIDTH, windowHeight);
    ServerNameWindow:SetText(T["ServerNameWindow"] .. " " .. playerName);
    ServerNameWindow:SetZOrder(100);
    ServerNameWindow:SetWantsKeyEvents(true);
    ServerNameWindow:SetPosition(
        (Turbine.UI.Display:GetWidth() - WINDOW_WIDTH) / 2,
        (Turbine.UI.Display:GetHeight() - windowHeight) / 2
    );
    ServerNameWindow:SetVisible(false);

    local footer = Turbine.UI.Label();
    footer:SetParent(ServerNameWindow);
    footer:SetSize(150, 10);
    footer:SetPosition(WINDOW_WIDTH / 2 - 75, windowHeight - 17);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    local listbox = Turbine.UI.ListBox();
    listbox:SetParent(ServerNameWindow);
    listbox:SetPosition(45, 55);
    listbox:SetSize(WINDOW_WIDTH - 75, windowHeight - 125);

    for _, entry in ipairs(servers) do
        local row = Turbine.UI.Control();
        row:SetSize(WINDOW_WIDTH - 90, ROW_HEIGHT);

        local icon = Turbine.UI.Label();
        icon:SetParent(row);
        icon:SetSize(32, 32);
        icon:SetPosition(0, 1);
        icon:SetBackground(ResourcePath .. "Server_Icon.tga");
        icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
        icon:SetMouseVisible(false);

        local indexLabel = Turbine.UI.Label();
        indexLabel:SetParent(row);
        indexLabel:SetSize(25, 20);
        indexLabel:SetPosition(2, 10);
        indexLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
        indexLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
        indexLabel:SetForeColor(Turbine.UI.Color.Red);
        indexLabel:SetText(tostring(entry.index));
        indexLabel:SetMouseVisible(false);

        local nameLabel = Turbine.UI.Label();
        nameLabel:SetParent(row);
        nameLabel:SetSize(190, 30);
        nameLabel:SetPosition(40, 1);
        nameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
        nameLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
        nameLabel:SetText(entry.name);

        local checkbox = Turbine.UI.Lotro.CheckBox();
        checkbox:SetParent(row);
        checkbox:SetSize(40, 35);
        checkbox:SetPosition(235, 0);
        checkbox:SetText("");
        checkbox:SetVisible(true);
        checkbox:SetMouseVisible(true);
        checkbox:SetChecked(
            PlayerDatas[playerName] ~= nil and PlayerDatas[playerName].serverName == entry.name
        );
        checkbox:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));
        checkboxes[entry.index] = checkbox;

        local currentIndex = entry.index;
        local currentName = entry.name;
        checkbox.CheckedChanged = function()
            if checkbox:IsChecked() then
                SetExclusiveServer(currentIndex);
                PlayerServer[playerName] = currentName;
                SavePlayerServerName(playerName);
            end
        end;

        listbox:AddItem(row);
    end

    if (#servers * ROW_HEIGHT) > listbox:GetHeight() then
        local scrollbar = Turbine.UI.Lotro.ScrollBar();
        scrollbar:SetParent(ServerNameWindow);
        scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
        scrollbar:SetPosition(WINDOW_WIDTH - 25, 55);
        scrollbar:SetSize(10, windowHeight - 125);
        scrollbar:SetMinimum(0);
        scrollbar:SetMaximum(math.max(0, (#servers * ROW_HEIGHT) - listbox:GetHeight()));
        scrollbar:SetValue(0);
        listbox:SetVerticalScrollBar(scrollbar);
    end

    local closeButton = Turbine.UI.Lotro.GoldButton();
    closeButton:SetParent(ServerNameWindow);
    closeButton:SetPosition(WINDOW_WIDTH / 2 - 125, windowHeight - 50);
    closeButton:SetSize(300, 20);
    closeButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    closeButton:SetText(T["PluginCloseButton"]);
    closeButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    closeButton:SetVisible(true);
    closeButton:SetMouseVisible(true);
    closeButton.MouseClick = function()
        ServerNameWindow:SetVisible(false);
        settings["isServerWindowVisible"]["value"] = false;
        UpdateMainWindow();
    end;

    ServerNameWindow.Closing = function()
        settings["isServerWindowVisible"]["value"] = false;
    end;

    EscapeKeyHandlerForWindows(ServerNameWindow, settings["isServerWindowVisible"]["value"]);
end
