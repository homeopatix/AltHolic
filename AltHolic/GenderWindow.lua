------------------------------------------------------------------------------------------
-- GenderWindow file
-- Originally written by Homeopatix
-- Refactored for AltHolic 4.78
------------------------------------------------------------------------------------------

local WINDOW_WIDTH = 400;
local BASE_WINDOW_HEIGHT = 200;
local ROW_HEIGHT = 50;
local ROW_CONTENT_Y = 20;

-- Race portrait texture IDs used by AltHolic's manual gender selector. LOTRO does not
-- expose a reliable character-gender query for offline alts, so the saved manual value
-- remains authoritative for this window.
local MALE_RACE_ICONS = {
    [81]  = 0x4110894A,
    [23]  = 0x41108945,
    [65]  = 0x41108947,
    [114] = 0x4115920D,
    [120] = 0x411DAE7E,
    [73]  = 0x41108946,
    [117] = 0x411C8D6B,
    [125] = 0x4110894A,
};

local FEMALE_RACE_ICONS = {
    [81]  = 0x41108949,
    [23]  = 0x4110894B,
    [65]  = 0x41108948,
    [114] = 0x4115920A,
    [120] = 0x411DAE7E,
    -- Race 73 intentionally has no female selector in the original plugin.
    [117] = 0x411C8D6A,
    [125] = 0x41108949,
};

local function SupportsManualGender(raceId)
    return MALE_RACE_ICONS[raceId] ~= nil;
end

local function CreateLabel(parent, width, height, left, top, text, font, alignment)
    local label = Turbine.UI.Label();
    label:SetParent(parent);
    label:SetSize(width, height);
    label:SetPosition(left, top);
    label:SetTextAlignment(alignment or Turbine.UI.ContentAlignment.MiddleCenter);
    if font ~= nil then label:SetFont(font); end
    label:SetText(text or "");
    return label;
end

local function CreatePortrait(parent, left, top, textureId)
    local portrait = Turbine.UI.Label();
    portrait:SetParent(parent);
    portrait:SetPosition(left, top);
    portrait:SetSize(32, 32);
    portrait:SetZOrder(-1);
    portrait:SetMouseVisible(false);
    portrait:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    if textureId ~= nil then portrait:SetBackground(textureId); end
    return portrait;
end

local function CreateGenderCheckbox(parent, left, top, checked)
    local checkbox = Turbine.UI.Lotro.CheckBox();
    checkbox:SetParent(parent);
    checkbox:SetSize(40, 40);
    checkbox:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    checkbox:SetText("");
    checkbox:SetPosition(left, top);
    checkbox:SetVisible(true);
    checkbox:SetMouseVisible(true);
    checkbox:SetChecked(checked == true);
    checkbox:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));
    return checkbox;
end

local function SaveGender(playerName, value)
    PlayerSexe[playerName] = value;
    SavePlayerSexForSpecialCharacters(playerName);
end

function GenerateGenderWindow()
    -- Release the previous window before rebuilding it. This window is generated on demand
    -- from the current alt list, so rebuilding is preferable to carrying stale row controls.
    AltHolicUtil.DetachControl(GenderWindow);

    local playerNames = {};
    for playerName, playerData in pairs(PlayerDatas) do
        if playerData ~= nil and SupportsManualGender(playerData.rac) then
            playerNames[#playerNames + 1] = playerName;
        end
    end
    table.sort(playerNames);

    local windowHeight = BASE_WINDOW_HEIGHT + (#playerNames * 32);
    local displayHeight = Turbine.UI.Display:GetHeight();
    if displayHeight < windowHeight then
        windowHeight = displayHeight - 150;
    end
    if windowHeight < BASE_WINDOW_HEIGHT then windowHeight = BASE_WINDOW_HEIGHT; end

    GenderWindow = Turbine.UI.Lotro.GoldWindow();
    GenderWindow:SetSize(WINDOW_WIDTH, windowHeight);
    GenderWindow:SetText(T["PluginGenderText"]);
    GenderWindow:SetZOrder(100);
    GenderWindow:SetWantsKeyEvents(true);
    GenderWindow:SetPosition(
        (Turbine.UI.Display:GetWidth() - GenderWindow:GetWidth()) / 2,
        (Turbine.UI.Display:GetHeight() - GenderWindow:GetHeight()) / 2
    );
    GenderWindow:SetVisible(false);

    CreateLabel(
        GenderWindow, 150, 10, WINDOW_WIDTH / 2 - 75, windowHeight - 17,
        T["PluginText"], nil, Turbine.UI.ContentAlignment.MiddleCenter
    );
    CreateLabel(
        GenderWindow, 150, 20, 125, 55,
        T["PluginGenderText1"], Turbine.UI.Lotro.Font.BookAntiquaBold18
    );
    CreateLabel(
        GenderWindow, 150, 20, 230, 55,
        T["PluginGenderText2"], Turbine.UI.Lotro.Font.BookAntiquaBold18
    );

    local listbox = Turbine.UI.ListBox();
    listbox:SetParent(GenderWindow);
    listbox:SetSize(WINDOW_WIDTH - 45, windowHeight - 140);
    listbox:SetPosition(20, 70);
    listbox:SetMouseVisible(true);
    listbox:SetZOrder(20);

    for _, playerName in ipairs(playerNames) do
        local playerData = PlayerDatas[playerName];
        local raceId = playerData.rac;

        local listItem = Turbine.UI.Control();
        listItem:SetSize(WINDOW_WIDTH - 45, ROW_HEIGHT);
        listItem:SetMouseVisible(true);

        CreateLabel(
            listItem, 120, 30, 5, ROW_CONTENT_Y,
            playerName, Turbine.UI.Lotro.Font.BookAntiquaBold22,
            Turbine.UI.ContentAlignment.MiddleLeft
        );

        CreatePortrait(listItem, 160, ROW_CONTENT_Y, MALE_RACE_ICONS[raceId]);
        local maleCheckbox = CreateGenderCheckbox(
            listItem, 202, ROW_CONTENT_Y, playerData.sexe == "male"
        );

        local femaleTexture = FEMALE_RACE_ICONS[raceId];
        if femaleTexture ~= nil then
            CreatePortrait(listItem, 265, ROW_CONTENT_Y, femaleTexture);
            local femaleCheckbox = CreateGenderCheckbox(
                listItem, 307, ROW_CONTENT_Y, playerData.sexe == "female"
            );

            local currentPlayer = playerName;
            maleCheckbox.CheckedChanged = function()
                if maleCheckbox:IsChecked() then
                    femaleCheckbox:SetChecked(false);
                    SaveGender(currentPlayer, "male");
                end
            end;
            femaleCheckbox.CheckedChanged = function()
                if femaleCheckbox:IsChecked() then
                    maleCheckbox:SetChecked(false);
                    SaveGender(currentPlayer, "female");
                end
            end;
        elseif playerData.sexe ~= "male" then
            -- This race only exposes the male portrait option in AltHolic. Save only
            -- when correction is actually needed; opening the window should not write data.
            SaveGender(playerName, "male");
        end

        listbox:AddItem(listItem);
    end

    local scrollbar = Turbine.UI.Lotro.ScrollBar();
    scrollbar:SetParent(GenderWindow);
    scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
    scrollbar:SetPosition(WINDOW_WIDTH - 20, 70);
    scrollbar:SetSize(10, windowHeight - 140);
    scrollbar:SetBackColor(Turbine.UI.Color(0.1, 0.1, 0.2));
    scrollbar:SetMinimum(0);
    scrollbar:SetMaximum(math.max(0, (#playerNames * ROW_HEIGHT) - listbox:GetHeight()));
    scrollbar:SetValue(0);
    listbox:SetVerticalScrollBar(scrollbar);

    local closeButton = Turbine.UI.Lotro.GoldButton();
    closeButton:SetParent(GenderWindow);
    closeButton:SetPosition(WINDOW_WIDTH / 2 - 125, windowHeight - 50);
    closeButton:SetSize(300, 20);
    closeButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    closeButton:SetText(T["PluginCloseButton"]);
    closeButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    closeButton:SetVisible(true);
    closeButton:SetMouseVisible(true);
    closeButton.MouseClick = function()
        CloseGenderWindow();
    end;

    GenderWindow.Closing = function()
        settings["isGenderWindowVisible"]["value"] = false;
    end;

    EscapeKeyHandlerForWindows(GenderWindow, settings["isGenderWindowVisible"]["value"]);
    return GenderWindow;
end

function CloseGenderWindow()
    if GenderWindow ~= nil then GenderWindow:SetVisible(false); end
    settings["isGenderWindowVisible"]["value"] = false;
end
