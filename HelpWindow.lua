------------------------------------------------------------------------------------------
-- HelpWindow file
-- Originally written by Homeopatix
-- Refactored for AltHolic 4.91
------------------------------------------------------------------------------------------

local HELP_TOPICS = {
    [1] = { title = "PluginTitreHelpWindow",  keys = {1,2,3,4,5,6,7,8,9}, top = 20 },
    [2] = { title = "PluginTitreHelpWindow2", keys = {10,11,12,13,14}, top = 60 },
    [3] = { title = "PluginTitreHelpWindow3", keys = {15,16,17,18,19,20,21}, top = 60 },
    [4] = { title = "PluginTitreHelpWindow4", keys = {22,23,24,25}, top = 100 },
    [5] = { title = "PluginTitreHelpWindow5", keys = {26,27,28,29}, top = 140 },
};

local function GetWindowHeight()
    local requestedHeight = 500;
    if playerAlignement == 1 then
        local language = Turbine.Engine.GetLanguage();
        if language == Turbine.Language.German then
            requestedHeight = 780;
        elseif language == Turbine.Language.French then
            requestedHeight = 740;
        elseif language == Turbine.Language.English then
            requestedHeight = 670;
        end
    end
    return math.min(requestedHeight, Turbine.UI.Display:GetHeight() - 150);
end

local function BuildHelpText(keys)
    local chunks = {};
    for _, index in ipairs(keys) do
        chunks[#chunks + 1] = T["PluginHelpWindow" .. tostring(index)] or "";
    end
    return table.concat(chunks);
end

function GenerateHelpWindow(topicId)
    AltHolicUtil.DetachControl(HelpWindow);
    local topic = HELP_TOPICS[topicId];
    if topic == nil then return; end

    local windowWidth = 400;
    local windowHeight = GetWindowHeight();

    HelpWindow = Turbine.UI.Lotro.GoldWindow();
    HelpWindow:SetSize(windowWidth, windowHeight);
    HelpWindow:SetText(T[topic.title]);
    HelpWindow:SetPosition(
        ((Turbine.UI.Display:GetWidth() - windowWidth) / 2) + 410,
        ((Turbine.UI.Display:GetHeight() - windowHeight) / 2) - 200
    );
    HelpWindow:SetZOrder(1000);
    HelpWindow:SetWantsKeyEvents(true);
    HelpWindow:SetVisible(false);

    local footer = Turbine.UI.Label();
    footer:SetParent(HelpWindow);
    footer:SetSize(150, 10);
    footer:SetPosition(windowWidth / 2 - 75, windowHeight - 17);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    local message = Turbine.UI.Label();
    message:SetParent(HelpWindow);
    message:SetSize(370, math.max(100, windowHeight - topic.top - 70));
    message:SetPosition(topicId == 1 and 15 or (topicId == 2 and 15 or (topicId == 3 and 25 or 35)), topic.top);
    message:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
    message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    message:SetText(BuildHelpText(topic.keys));

    local closeButton = Turbine.UI.Lotro.GoldButton();
    closeButton:SetParent(HelpWindow);
    closeButton:SetPosition(windowWidth / 2 - 125, windowHeight - 40);
    closeButton:SetSize(300, 20);
    closeButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    closeButton:SetText(T["PluginButtonHelpWindow"]);
    closeButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    closeButton:SetVisible(true);
    closeButton:SetMouseVisible(true);

    local function Close()
        HelpWindow:SetVisible(false);
        settings["isHelpWindowVisible"]["value"] = false;
    end

    closeButton.MouseClick = Close;
    HelpWindow.Closing = Close;
    EscapeKeyHandlerForWindows(HelpWindow, settings["isHelpWindowVisible"]["value"]);
end
