------------------------------------------------------------------------------------------
-- Epic-book overview window
-- Originally written by Homeopatix; refactored for AltHolic 4.88
------------------------------------------------------------------------------------------

local EPIC_WINDOW_WIDTH = 420;
local EPIC_MIN_HEIGHT = 440;
local EPIC_ROW_HEIGHT = 32;
local EPIC_HEADER_HEIGHT = 30;

local EPIC_VOLUME_ICONS = {
    I   = 0x41101698,
    ["1"] = 0x41101698,
    II  = 0x41101680,
    ["2"] = 0x41101680,
    III = 0x4111F7BA,
    ["3"] = 0x4111F7BA,
    IV  = 0x4111F7BC,
    ["4"] = 0x4111F7BC,
    V   = 0x4113B2E7,
    ["5"] = 0x4113B2E7,
};

local function ShouldDisplayCharacter(name)
    local data = PlayerDatas[name];
    if data == nil or data.align ~= 1 then return false; end

    local selectedServer = settings["serversToDisplay"]["value"];
    return selectedServer == data.serverName
        or selectedServer == T["ServerNamesAll"]
        or selectedServer == "";
end

local function GetEpicCharacterNames()
    local names = {};
    for name in pairs(PlayerDatas) do
        if ShouldDisplayCharacter(name) then
            names[#names + 1] = name;
        end
    end
    table.sort(names);
    return names;
end

local function GetBookCount(playerName)
    local data = PlayerEpique[playerName];
    if data == nil or data.volume == nil then return 0; end
    return tablelength(data.volume);
end

local function GetVolumeIcon(volumeText)
    if volumeText == nil then return nil; end
    local parts = Split(volumeText, " ");
    return EPIC_VOLUME_ICONS[parts[2]];
end

local function TruncateName(name, maxLength)
    if string.len(name) > maxLength then
        return string.sub(name, 1, maxLength - 1) .. "...";
    end
    return name;
end

local function CreateBookEntry(parent, playerName, index, y)
    local epic = PlayerEpique[playerName];
    if epic == nil then return; end

    local volume = epic.volume and epic.volume[index] or nil;
    local book = epic.livre and epic.livre[index] or "";
    local chapter = epic.chapitre and epic.chapitre[index] or "";
    if volume == nil or volume == "" then return; end

    local iconTexture = GetVolumeIcon(volume);
    if iconTexture ~= nil then
        local icon = Turbine.UI.Label();
        icon:SetParent(parent);
        icon:SetSize(32, 32);
        icon:SetPosition(55, y + 3);
        icon:SetBackground(iconTexture);
        icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
        icon:SetVisible(true);
    end

    local label = Turbine.UI.Label();
    label:SetParent(parent);
    label:SetSize(300, 40);
    label:SetPosition(90, y);
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    label:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
    label:SetForeColor(Turbine.UI.Color.Gold);
    label:SetText(volume .. "  " .. book .. "  " .. chapter);
    label:SetVisible(true);
    label:SetMouseVisible(playerName == PlayerName);

    if playerName == PlayerName then
        label.MouseClick = function()
            CreateAddNewWindowEpique(index);
            AltHolicAddnewWindowEpique:SetVisible(true);
        end
    end
end

local function CreateCharacterEpicRow(playerName)
    local bookCount = GetBookCount(playerName);
    local row = Turbine.UI.Control();
    row:SetSize(EPIC_WINDOW_WIDTH - 45, math.max(EPIC_HEADER_HEIGHT, (bookCount * EPIC_ROW_HEIGHT) + EPIC_HEADER_HEIGHT));
    row:SetMouseVisible(true);

    local nameLabel = Turbine.UI.Label();
    nameLabel:SetParent(row);
    nameLabel:SetSize(120, 30);
    nameLabel:SetPosition(40, 4);
    nameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    nameLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
    nameLabel:SetForeColor(playerName == PlayerName and Turbine.UI.Color.Lime or Turbine.UI.Color.White);
    nameLabel:SetText(TruncateName(playerName, 13));

    if playerName == PlayerName then
        DisplayLabelEpique(playerName, 10, 12, T["PluginAddNewEpique"], "AddNew.tga", row);
    end

    for index = 1, bookCount do
        CreateBookEntry(row, playerName, index, EPIC_HEADER_HEIGHT + ((index - 1) * EPIC_ROW_HEIGHT));
    end

    return row;
end

function CreateUIShowEpique()
    local characterNames = GetEpicCharacterNames();
    local desiredHeight = (#characterNames * 20) + 340;
    if settings["nameAccount"]["account1"]["name"] == "" then
        desiredHeight = EPIC_MIN_HEIGHT;
    end

    local maxHeight = Turbine.UI.Display:GetHeight() - 150;
    local windowHeight = math.min(math.max(desiredHeight, EPIC_MIN_HEIGHT), maxHeight);

    UIShowEpique = Turbine.UI.Lotro.GoldWindow();
    UIShowEpique:SetSize(EPIC_WINDOW_WIDTH, windowHeight);
    UIShowEpique:SetText(T["PluginEpiqueWindow1"]);
    UIShowEpique:SetPosition(
        (Turbine.UI.Display:GetWidth() - UIShowEpique:GetWidth()) / 2,
        (Turbine.UI.Display:GetHeight() - UIShowEpique:GetHeight()) / 2
    );
    UIShowEpique:SetZOrder(10);
    UIShowEpique:SetWantsKeyEvents(true);
    UIShowEpique:SetVisible(false);

    local footer = Turbine.UI.Label();
    footer:SetParent(UIShowEpique);
    footer:SetSize(150, 10);
    footer:SetPosition(UIShowEpique:GetWidth() / 2 - 75, UIShowEpique:GetHeight() - 20);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    DisplayHelpButton(UIShowEpique, EPIC_WINDOW_WIDTH, 2);

    local listbox = Turbine.UI.ListBox();
    listbox:SetParent(UIShowEpique);
    listbox:SetSize(EPIC_WINDOW_WIDTH - 40, windowHeight - 150);
    listbox:SetPosition(10, 80);
    listbox:SetMouseVisible(true);
    listbox:SetZOrder(20);

    local contentHeight = 0;
    for _, playerName in ipairs(characterNames) do
        local row = CreateCharacterEpicRow(playerName);
        listbox:AddItem(row);
        contentHeight = contentHeight + row:GetHeight();
    end

    if contentHeight > listbox:GetHeight() then
        local scrollbar = Turbine.UI.Lotro.ScrollBar();
        scrollbar:SetParent(UIShowEpique);
        scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
        scrollbar:SetPosition(EPIC_WINDOW_WIDTH - 20, 80);
        scrollbar:SetSize(10, listbox:GetHeight());
        scrollbar:SetBackColor(Turbine.UI.Color(.1, .1, .2));
        scrollbar:SetMinimum(0);
        scrollbar:SetMaximum(math.max(0, contentHeight - listbox:GetHeight()));
        scrollbar:SetValue(0);
        listbox:SetVerticalScrollBar(scrollbar);
    end

    local closeButton = Turbine.UI.Lotro.GoldButton();
    closeButton:SetParent(UIShowEpique);
    closeButton:SetPosition(EPIC_WINDOW_WIDTH / 2 - 125, windowHeight - 50);
    closeButton:SetSize(300, 20);
    closeButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    closeButton:SetText(T["PluginCloseButton"]);
    closeButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    closeButton:SetVisible(true);
    closeButton:SetMouseVisible(true);
    closeButton.MouseClick = function()
        settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"] = false;
        UIShowEpique:SetVisible(false);
    end

    ClosingTheWindowEpique();
    EscapeKeyHandlerForWindows(UIShowEpique, settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"]);
end
