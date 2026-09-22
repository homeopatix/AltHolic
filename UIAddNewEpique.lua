------------------------------------------------------------------------------------------
-- UIAddNewEpique file
-- Originally written by Homeopatix
-- Refactored for AltHolic 4.91
------------------------------------------------------------------------------------------

local WINDOW_WIDTH = 400;
local WINDOW_HEIGHT = 360;
local INPUT_FORE_COLOR = Turbine.UI.Color(0.7, 0.6, 0.2);
local INPUT_BACK_COLOR = Turbine.UI.Color(0.9, 0.5, 0.7, 0.5);

local function CreateLabel(parent, y, font, text, color)
    local label = Turbine.UI.Label();
    label:SetParent(parent);
    label:SetSize(350, 40);
    label:SetPosition(25, y);
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    label:SetFont(font);
    label:SetText(text or "");
    label:SetForeColor(color or Turbine.UI.Color.Gold);
    label:SetVisible(true);
    return label;
end

local function CreateInput(parent, x, y, width, value)
    local input = Turbine.UI.Lotro.TextBox();
    input:SetParent(parent);
    input:SetSize(width, 40);
    input:SetPosition(x, y);
    input:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    input:SetText(value or "");
    input:SetForeColor(INPUT_FORE_COLOR);
    input:SetBackColor(INPUT_BACK_COLOR);
    input:SetVisible(true);
    return input;
end

local function CreateButton(parent, x, text, width)
    local button = Turbine.UI.Lotro.GoldButton();
    button:SetParent(parent);
    button:SetPosition(x, WINDOW_HEIGHT - 50);
    button:SetSize(width, 20);
    button:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    button:SetText(text);
    button:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    button:SetVisible(true);
    button:SetMouseVisible(true);
    return button;
end

local function StripPrefix(value, prefix)
    value = tostring(value or "");
    local fullPrefix = tostring(prefix or "") .. " ";
    if string.sub(value, 1, string.len(fullPrefix)) == fullPrefix then
        return string.sub(value, string.len(fullPrefix) + 1);
    end
    return value;
end

local function GetNextEpicIndex(volumeTable)
    local highest = 0;
    for key in pairs(volumeTable or {}) do
        local numericKey = tonumber(key);
        if numericKey ~= nil and numericKey > highest then highest = numericKey; end
    end
    return highest + 1;
end

local function StoreEpicEntry(index, volumeText, bookText, chapterText)
    local playerEpic = PlayerEpique[PlayerName];
    local volume = playerEpic.volume;
    local book = playerEpic.livre;
    local chapter = playerEpic.chapitre;

    volume[index] = T["PluginAddNewBookVolume"] .. " " .. volumeText;

    if string.len(bookText) > 3 then
        book[index] = bookText;
        chapter[index] = chapterText;
    else
        book[index] = T["PluginAddNewBookLivre"] .. " " .. bookText;
        if string.len(chapterText) > 0 and string.len(chapterText) < 4 then
            chapter[index] = T["PluginAddNewBookChapitre"] .. " " .. chapterText;
        else
            chapter[index] = chapterText;
        end
    end
end

local function RefreshEpicWindow()
    if UIShowEpique ~= nil then UIShowEpique:SetVisible(false); end
    CreateUIShowEpique();
    UIShowEpique:SetVisible(true);
end

function CreateAddNewWindowEpique(indexToUpdate)
    AltHolicUtil.DetachControl(AltHolicAddnewWindowEpique);
    local playerEpic = PlayerEpique[PlayerName];
    if playerEpic == nil then return; end

    AltHolicAddnewWindowEpique = Turbine.UI.Lotro.GoldWindow();
    AltHolicAddnewWindowEpique:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT);
    AltHolicAddnewWindowEpique:SetText(
        indexToUpdate ~= nil
            and (T["PluginUpdateTitle"] .. PlayerName)
            or (T["PluginAddNewBook"] .. PlayerName)
    );
    AltHolicAddnewWindowEpique:SetZOrder(100);
    AltHolicAddnewWindowEpique:SetWantsKeyEvents(true);
    AltHolicAddnewWindowEpique:SetVisible(false);
    AltHolicAddnewWindowEpique:SetPosition(
        (Turbine.UI.Display:GetWidth() - WINDOW_WIDTH) / 2,
        (Turbine.UI.Display:GetHeight() - WINDOW_HEIGHT) / 2
    );

    local footer = Turbine.UI.Label();
    footer:SetParent(AltHolicAddnewWindowEpique);
    footer:SetSize(150, 10);
    footer:SetPosition(WINDOW_WIDTH / 2 - 75, WINDOW_HEIGHT - 20);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    local volumeValue, bookValue, chapterValue = "", "", "";
    if indexToUpdate ~= nil then
        volumeValue = StripPrefix(playerEpic.volume[indexToUpdate], T["PluginAddNewBookVolume"]);
        bookValue = StripPrefix(playerEpic.livre[indexToUpdate], T["PluginAddNewBookLivre"]);
        chapterValue = StripPrefix(playerEpic.chapitre[indexToUpdate], T["PluginAddNewBookChapitre"]);
    end

    CreateLabel(AltHolicAddnewWindowEpique, 30, Turbine.UI.Lotro.Font.TrajanProBold25, T["PluginAddNewBookVolume"]);
    CreateLabel(AltHolicAddnewWindowEpique, 45, Turbine.UI.Lotro.Font.Verdana12, T["PluginExample1"], Turbine.UI.Color.White);
    local volumeInput = CreateInput(AltHolicAddnewWindowEpique, 140, 70, 120, volumeValue);

    CreateLabel(AltHolicAddnewWindowEpique, 115, Turbine.UI.Lotro.Font.TrajanProBold25, T["PluginAddNewBookLivre"]);
    CreateLabel(AltHolicAddnewWindowEpique, 130, Turbine.UI.Lotro.Font.Verdana12, T["PluginExample2"], Turbine.UI.Color.White);
    local bookInput = CreateInput(AltHolicAddnewWindowEpique, 140, 155, 120, bookValue);

    CreateLabel(AltHolicAddnewWindowEpique, 200, Turbine.UI.Lotro.Font.TrajanProBold25, T["PluginAddNewBookChapitre"]);
    CreateLabel(AltHolicAddnewWindowEpique, 215, Turbine.UI.Lotro.Font.Verdana12, T["PluginExample3"], Turbine.UI.Color.White);
    local chapterInput = CreateInput(AltHolicAddnewWindowEpique, 100, 240, 200, chapterValue);

    if indexToUpdate ~= nil then
        local updateButton = CreateButton(AltHolicAddnewWindowEpique, WINDOW_WIDTH / 2 - 175, T["PluginUpdate"], 150);
        local deleteButton = CreateButton(AltHolicAddnewWindowEpique, WINDOW_WIDTH / 2 + 25, T["PluginDelete"], 150);

        updateButton.MouseClick = function()
            StoreEpicEntry(indexToUpdate, volumeInput:GetText(), bookInput:GetText(), chapterInput:GetText());
            AltHolicAddnewWindowEpique:SetVisible(false);
            SavePlayerEpique();
            RefreshEpicWindow();
        end;

        deleteButton.MouseClick = function()
            playerEpic.volume[indexToUpdate] = nil;
            playerEpic.livre[indexToUpdate] = nil;
            playerEpic.chapitre[indexToUpdate] = nil;
            AltHolicAddnewWindowEpique:SetVisible(false);
            SavePlayerEpiqueDelete();
            RefreshEpicWindow();
        end;
    else
        local addButton = CreateButton(AltHolicAddnewWindowEpique, WINDOW_WIDTH / 2 - 100, T["PluginAddNew2"], 200);
        addButton.MouseClick = function()
            local newIndex = GetNextEpicIndex(playerEpic.volume);
            StoreEpicEntry(newIndex, volumeInput:GetText(), bookInput:GetText(), chapterInput:GetText());
            AltHolicAddnewWindowEpique:SetVisible(false);
            SavePlayerEpique();
            RefreshEpicWindow();
        end;
    end

    EscapeKeyHandlerForWindows(AltHolicAddnewWindowEpique, false);
end
