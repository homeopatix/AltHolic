------------------------------------------------------------------------------------------
-- OptionsWindowBar file
-- Originally written by Homeopatix
-- Refactored for AltHolic 4.91
------------------------------------------------------------------------------------------

local WINDOW_WIDTH = 400;
local WINDOW_HEIGHT = 680;
local OPTION_X = 100;
local OPTION_START_Y = 90;
local OPTION_STEP_Y = 25;
local OPTION_COLOR = Turbine.UI.Color(0.7, 0.6, 0.2);

local BAR_ICON_OPTIONS = {
    { setting = "displayBarIcon2",  text = "PluginOptionBar2"  },
    { setting = "displayBarIcon16", text = "PluginOptionBar16" },
    { setting = "displayBarIcon3",  text = "PluginOptionBar3"  },
    { setting = "displayBarIcon4",  text = "PluginOptionBar4"  },
    { setting = "displayBarIcon5",  text = "PluginOptionBar5"  },
    { setting = "displayBarIcon6",  text = "PluginOptionBar6"  },
    { setting = "displayBarIcon7",  text = "PluginOptionBar7"  },
    { setting = "displayBarIcon8",  text = "PluginOptionBar8"  },
    { setting = "displayBarIcon9",  text = "PluginOptionBar9"  },
    { setting = "displayBarIcon10", text = "PluginOptionBar10" },
    { setting = "displayBarIcon11", text = "PluginOptionBar11" },
    { setting = "displayBarIcon12", text = "PluginOptionBar12" },
    { setting = "displayBarIcon13", text = "PluginOptionBar13" },
    { setting = "displayBarIcon14", text = "PluginOptionBar14" },
    { setting = "displayBarIcon15", text = "PluginOptionBar15" },
    { setting = "displayTokensIcon", text = "PluginOptionBarTokens" },
};

local function CreateCheckbox(parent, definition, y)
    local checkbox = Turbine.UI.Lotro.CheckBox();
    checkbox:SetParent(parent);
    checkbox:SetSize(300, 40);
    checkbox:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    checkbox:SetText(T[definition.text]);
    checkbox:SetPosition(OPTION_X, y);
    checkbox:SetVisible(true);
    checkbox:SetChecked(settings[definition.setting]["value"] == true);
    checkbox:SetForeColor(OPTION_COLOR);
    return checkbox;
end

local function CreateFooter(parent)
    local footer = Turbine.UI.Label();
    footer:SetParent(parent);
    footer:SetSize(150, 10);
    footer:SetPosition(WINDOW_WIDTH / 2 - 75, WINDOW_HEIGHT - 17);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);
end

function GenerateOptionsWindowBar()
    AltHolicUtil.DetachControl(OptionsWindowBar);
    OptionsWindowBar = Turbine.UI.Lotro.GoldWindow();
    OptionsWindowBar:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT);
    OptionsWindowBar:SetText(T["PluginOptionsBarText"]);
    OptionsWindowBar:SetZOrder(0);
    OptionsWindowBar:SetWantsKeyEvents(true);
    OptionsWindowBar:SetPosition(
        (Turbine.UI.Display:GetWidth() - WINDOW_WIDTH) / 2,
        (Turbine.UI.Display:GetHeight() - WINDOW_HEIGHT) / 2
    );
    OptionsWindowBar:SetVisible(false);
    CreateFooter(OptionsWindowBar);

    local titleX = 50;
    local y = 60;
    local titleColor = Turbine.UI.Color.Lime;
    local lineColor = Turbine.UI.Color.Blue;
    TitleDisplayer(OptionsWindowBar, titleX, y, T["PluginOptionBar1"], titleColor, lineColor);

    local subtitle = Turbine.UI.Label();
    subtitle:SetParent(OptionsWindowBar);
    subtitle:SetSize(300, 40);
    subtitle:SetPosition(titleX, y + 5);
    subtitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    subtitle:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    subtitle:SetText(T["PluginOptionBar0"]);

    local checkboxes = {};
    y = OPTION_START_Y;
    for _, definition in ipairs(BAR_ICON_OPTIONS) do
        checkboxes[definition.setting] = CreateCheckbox(OptionsWindowBar, definition, y);
        y = y + OPTION_STEP_Y;
    end

    y = y + 40;
    TitleDisplayer(OptionsWindowBar, titleX, y, T["PluginOptionBar20"], titleColor, lineColor);

    local bagSizeDefinition = { setting = "displayBarBagSize", text = "PluginOptionBar21" };
    local bagSizeCheckbox = CreateCheckbox(OptionsWindowBar, bagSizeDefinition, y + 5);

    local validateButton = Turbine.UI.Lotro.GoldButton();
    validateButton:SetParent(OptionsWindowBar);
    validateButton:SetPosition(WINDOW_WIDTH / 2 - 125, WINDOW_HEIGHT - 50);
    validateButton:SetSize(300, 20);
    validateButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    validateButton:SetText(T["PluginOptionValidate"]);
    validateButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    validateButton:SetVisible(true);
    validateButton:SetMouseVisible(true);

    validateButton.MouseClick = function()
        for _, definition in ipairs(BAR_ICON_OPTIONS) do
            settings[definition.setting]["value"] = checkboxes[definition.setting]:IsChecked();
        end
        settings["displayBarBagSize"]["value"] = bagSizeCheckbox:IsChecked();
        settings["isOptionsWindowBarVisible"]["isOptionsWindowBarVisible"] = false;
        OptionsWindowBar:SetVisible(false);

        if settings["displayBarWindow"]["value"] == true and AltHolicBar ~= nil then
            AltHolicBar:SetVisible(true);
        end

        SaveSettings();
        UpdateBar();
    end;

    ClosingTheWindowOptionsBar();
    EscapeKeyHandlerForWindows(
        OptionsWindowBar,
        settings["isOptionsWindowBarVisible"]["isOptionsWindowBarVisible"]
    );
end
