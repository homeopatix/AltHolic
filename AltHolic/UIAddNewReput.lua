------------------------------------------------------------------------------------------
-- UIAddNewReput file
-- Originally written by Homeopatix
-- Refactored for AltHolic 4.91
------------------------------------------------------------------------------------------

local WINDOW_WIDTH = 400;
local WINDOW_HEIGHT = 280;
local INPUT_FORE_COLOR = Turbine.UI.Color(0.7, 0.6, 0.2);
local INPUT_BACK_COLOR = Turbine.UI.Color(0.9, 0.5, 0.7, 0.5);

local function CreateCenteredLabel(parent, y, font, text, color)
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

local function GetRankLabel(index, isFemale)
    if isFemale and index >= 1 and index <= 10 then
        return T["reputpositionFemale" .. tostring(index)];
    end
    return T["reputposition" .. tostring(index)];
end

local function ReputationRankPosition(index)
    if index <= 10 then return index; end
    if index <= 19 then return index - 10; end
    if index <= 24 then return index - 19; end
    if index <= 34 then return index - 24; end
    if index <= 40 then return index - 35; end
    return index - 40;
end

local function BuildRankOptions(playerName)
    local labels = { T["reputposition0"] };
    local positionByLabel = {};
    local isFemale = PlayerDatas[playerName] ~= nil and PlayerDatas[playerName].sexe ~= "male";

    for index = 1, 46 do
        local label = GetRankLabel(index, isFemale);
        labels[#labels + 1] = label;
        positionByLabel[label] = ReputationRankPosition(index);
    end
    return labels, positionByLabel;
end

function CreateAddNewWindowReput(factionName, playerName, reputationIndex)
    AltHolicUtil.DetachControl(AltHolicAddnewWindowReput);
    local rankLabels, positionByLabel = BuildRankOptions(playerName);
    local selectedRank = rankLabels[1];

    AltHolicAddnewWindowReput = Turbine.UI.Lotro.GoldWindow();
    AltHolicAddnewWindowReput:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT);
    AltHolicAddnewWindowReput:SetText(T["PluginReputationUpdateTitle"]);
    AltHolicAddnewWindowReput:SetZOrder(100);
    AltHolicAddnewWindowReput:SetWantsKeyEvents(true);
    AltHolicAddnewWindowReput:SetVisible(false);
    AltHolicAddnewWindowReput:SetPosition(
        (Turbine.UI.Display:GetWidth() - WINDOW_WIDTH) / 2,
        (Turbine.UI.Display:GetHeight() - WINDOW_HEIGHT) / 2
    );

    local footer = Turbine.UI.Label();
    footer:SetParent(AltHolicAddnewWindowReput);
    footer:SetSize(150, 10);
    footer:SetPosition(WINDOW_WIDTH / 2 - 75, WINDOW_HEIGHT - 20);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    CreateCenteredLabel(AltHolicAddnewWindowReput, 30, Turbine.UI.Lotro.Font.TrajanProBold16, factionName);
    CreateCenteredLabel(AltHolicAddnewWindowReput, 45, Turbine.UI.Lotro.Font.Verdana12, T["PluginValueLabel"], Turbine.UI.Color.White);

    local valueInput = Turbine.UI.Lotro.TextBox();
    valueInput:SetParent(AltHolicAddnewWindowReput);
    valueInput:SetSize(120, 40);
    valueInput:SetPosition(140, 70);
    valueInput:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    valueInput:SetText("");
    valueInput:SetForeColor(INPUT_FORE_COLOR);
    valueInput:SetBackColor(INPUT_BACK_COLOR);
    valueInput:SetVisible(true);

    CreateCenteredLabel(AltHolicAddnewWindowReput, 130, Turbine.UI.Lotro.Font.TrajanProBold16, T["PluginReputationsLabel"]);
    CreateCenteredLabel(AltHolicAddnewWindowReput, 145, Turbine.UI.Lotro.Font.Verdana12, T["PluginValueLabel"], Turbine.UI.Color.White);

    local rankDropdown = DropDown.Create(rankLabels, rankLabels[1]);
    rankDropdown:SetParent(AltHolicAddnewWindowReput);
    rankDropdown:ApplyWidth(300);
    rankDropdown:SetMaxItems(48);
    rankDropdown:SetPosition(50, 172);
    rankDropdown:SetVisible(true);
    rankDropdown.ItemChanged = function()
        selectedRank = rankDropdown:GetText();
    end;

    local saveButton = Turbine.UI.Lotro.GoldButton();
    saveButton:SetParent(AltHolicAddnewWindowReput);
    saveButton:SetPosition(WINDOW_WIDTH / 2 - 100, WINDOW_HEIGHT - 50);
    saveButton:SetSize(200, 20);
    saveButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    saveButton:SetText(T["PluginAddNew2"]);
    saveButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    saveButton:SetVisible(true);
    saveButton:SetMouseVisible(true);

    saveButton.MouseClick = function()
        local mappedPosition = positionByLabel[selectedRank];
        if mappedPosition ~= nil then
            RepuPosition[reputationIndex] = mappedPosition;
        end
        RepuName[reputationIndex] = T["reputname" .. tostring(reputationIndex)];
        Reputations[reputationIndex] = tonumber(valueInput:GetText()) or 0;

        SavePlayerReputations();
        AltHolicAddnewWindowReput:SetVisible(false);

        if UIShowReput ~= nil then UIShowReput:SetVisible(false); end
        CreateUIShowReput(playerName);
        UIShowReput:SetVisible(true);
    end;

    EscapeKeyHandlerForWindows(AltHolicAddnewWindowReput, false);
end
