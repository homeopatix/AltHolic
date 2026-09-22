------------------------------------------------------------------------------------------
-- InfoWindow file
-- Originally written by Homeopatix
-- Refactored for AltHolic 4.91
------------------------------------------------------------------------------------------

local WINDOW_WIDTH = 400;
local WINDOW_HEIGHT = 500;

local function CloseInfoWindow()
    if InfoWindow ~= nil then InfoWindow:SetVisible(false); end
    settings["isInfoWindowVisible"]["value"] = false;
end

function GenerateInfosWindow(playerName)
    AltHolicUtil.DetachControl(InfoWindow);
    InfoWindow = Turbine.UI.Lotro.GoldWindow();
    InfoWindow:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT);
    InfoWindow:SetText(T["PluginInfo1"] .. playerName);
    InfoWindow:SetPosition(
        (Turbine.UI.Display:GetWidth() - WINDOW_WIDTH) / 2,
        (Turbine.UI.Display:GetHeight() - WINDOW_HEIGHT) / 2
    );
    InfoWindow:SetZOrder(1000);
    InfoWindow:SetWantsKeyEvents(true);
    InfoWindow:SetVisible(false);

    local footer = Turbine.UI.Label();
    footer:SetParent(InfoWindow);
    footer:SetSize(150, 10);
    footer:SetPosition(WINDOW_WIDTH / 2 - 75, WINDOW_HEIGHT - 17);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    local textBox = Turbine.UI.Lotro.TextBox();
    textBox:SetParent(InfoWindow);
    textBox:SetSize(380, 360);
    textBox:SetPosition(10, 40);
    textBox:SetText(
        PlayerInfos[playerName] ~= nil and PlayerInfos[playerName].info or ""
    );
    textBox:SetVisible(true);
    textBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    textBox:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));
    textBox:SetBackColor(Turbine.UI.Color(0.9, 0.5, 0.7, 0.5));

    local function CreateButton(y, label)
        local button = Turbine.UI.Lotro.GoldButton();
        button:SetParent(InfoWindow);
        button:SetPosition(WINDOW_WIDTH / 2 - 125, y);
        button:SetSize(300, 20);
        button:SetFont(Turbine.UI.Lotro.Font.Verdana16);
        button:SetText(label);
        button:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
        button:SetVisible(true);
        button:SetMouseVisible(true);
        return button;
    end

    local saveButton = CreateButton(WINDOW_HEIGHT - 90, T["PluginInfo2"]);
    local clearButton = CreateButton(WINDOW_HEIGHT - 65, T["PluginInfo3"]);
    local closeButton = CreateButton(WINDOW_HEIGHT - 40, T["PluginCloseButton"]);

    saveButton.MouseClick = function()
        SavePlayerInfos(playerName, textBox:GetText());
        CloseInfoWindow();
        UpdateMainWindow();
        UpdateBar();
    end;

    clearButton.MouseClick = function()
        textBox:SetText("");
        SavePlayerInfos(playerName, "");
        CloseInfoWindow();
        UpdateMainWindow();
        UpdateBar();
    end;

    closeButton.MouseClick = CloseInfoWindow;

    ClosingTheInfoWindow();
    EscapeKeyHandlerForWindows(InfoWindow, settings["isInfoWindowVisible"]["value"]);
end
