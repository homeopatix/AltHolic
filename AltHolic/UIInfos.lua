------------------------------------------------------------------------------------------
-- AltHolic information window
------------------------------------------------------------------------------------------

local WINDOW_WIDTH = 320;
local WINDOW_HEIGHT = 535;

local function AddCenteredLabel(parent, text, y, height, font, color)
    local label = Turbine.UI.Label();
    label:SetParent(parent);
    label:SetSize(WINDOW_WIDTH - 20, height or 30);
    label:SetPosition(10, y);
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    label:SetFont(font or Turbine.UI.Lotro.Font.BookAntiquaBold19);
    label:SetForeColor(color or Turbine.UI.Color.Gold);
    label:SetText(text or "");
    return label;
end

local function AddSection(parent, title, value, y)
    AddCenteredLabel(parent, title, y, 25, Turbine.UI.Lotro.Font.Verdana16, Turbine.UI.Color.Lime);
    AddCenteredLabel(parent, "________________________", y + 4, 30,
        Turbine.UI.Lotro.Font.BookAntiquaBold22, Turbine.UI.Color.Blue);
    AddCenteredLabel(parent, value, y + 27, 36, Turbine.UI.Lotro.Font.BookAntiquaBold19, Turbine.UI.Color.Gold);
    return y + 68;
end

function CreateInfosWindow()
    if AltHolicInfosWindow ~= nil then
        AltHolicUtil.DetachControl(AltHolicInfosWindow);
    end

    AltHolicInfosWindow = Turbine.UI.Lotro.GoldWindow();
    AltHolicInfosWindow:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT);
    AltHolicInfosWindow:SetText(T["PluginInformationWindowTitle"]);
    AltHolicInfosWindow:SetZOrder(1);
    AltHolicInfosWindow:SetWantsKeyEvents(true);
    AltHolicInfosWindow:SetVisible(false);
    AltHolicInfosWindow:SetPosition(
        (Turbine.UI.Display:GetWidth() - WINDOW_WIDTH) / 2,
        (Turbine.UI.Display:GetHeight() - WINDOW_HEIGHT) / 2
    );

    local footer = Turbine.UI.Label();
    footer:SetParent(AltHolicInfosWindow);
    footer:SetSize(150, 12);
    footer:SetPosition((WINDOW_WIDTH - 150) / 2, WINDOW_HEIGHT - 20);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    local y = 35;
    AddCenteredLabel(AltHolicInfosWindow, T["PluginName"], y, 36,
        Turbine.UI.Lotro.Font.BookAntiquaBold24, Turbine.UI.Color.Gold);
    y = y + 38;
    AddCenteredLabel(AltHolicInfosWindow, "V " .. tostring(Plugins[pluginName]:GetVersion()), y, 32,
        Turbine.UI.Lotro.Font.BookAntiquaBold24, Turbine.UI.Color.Gold);
    y = y + 48;

    y = AddSection(AltHolicInfosWindow, T["PluginLatestUpdate"],
        T["PluginDateUpdate"], y);

    local translatorText = table.concat({
        T["PluginLangUpdateFR"],
        T["PluginLangUpdateDE"],
        T["PluginLangUpdateEN"],
    }, "   •   ");
    y = AddSection(AltHolicInfosWindow, T["PluginTranslators"], translatorText, y);

    y = AddSection(AltHolicInfosWindow, T["PluginCalcStatVersionText"],
        T["PluginCalcStatVersion"], y);

    AddSection(AltHolicInfosWindow, T["PluginRefactored"],
        T["PluginRefactoredBy"], y);
end
