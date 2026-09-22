------------------------------------------------------------------------------------------
-- UIAddNew file
-- Originally written by Homeopatix
-- Refactored for AltHolic 4.91
------------------------------------------------------------------------------------------

function CreateAddNewWindow()
    AltHolicUtil.DetachControl(AltHolicAddnewWindow);
    local windowWidth, windowHeight = 300, 150;

    AltHolicAddnewWindow = Turbine.UI.Lotro.GoldWindow();
    AltHolicAddnewWindow:SetSize(windowWidth, windowHeight);
    AltHolicAddnewWindow:SetText(T["PluginAddNew"]);
    AltHolicAddnewWindow:SetZOrder(1);
    AltHolicAddnewWindow:SetWantsKeyEvents(true);
    AltHolicAddnewWindow:SetVisible(false);
    AltHolicAddnewWindow:SetPosition(
        (Turbine.UI.Display:GetWidth() - windowWidth) / 2,
        (Turbine.UI.Display:GetHeight() - windowHeight) / 2
    );

    local footer = Turbine.UI.Label();
    footer:SetParent(AltHolicAddnewWindow);
    footer:SetSize(150, 10);
    footer:SetPosition(windowWidth / 2 - 75, windowHeight - 20);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    local accountNameBox = Turbine.UI.Lotro.TextBox();
    accountNameBox:SetParent(AltHolicAddnewWindow);
    accountNameBox:SetSize(200, 40);
    accountNameBox:SetPosition(50, 50);
    accountNameBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    accountNameBox:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));
    accountNameBox:SetBackColor(Turbine.UI.Color(0.9, 0.5, 0.7, 0.5));
    accountNameBox:SetVisible(true);

    local addButton = Turbine.UI.Lotro.GoldButton();
    addButton:SetParent(AltHolicAddnewWindow);
    addButton:SetPosition(windowWidth / 2 - 100, windowHeight - 40);
    addButton:SetSize(200, 20);
    addButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    addButton:SetText(T["PluginAddNew2"]);
    addButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    addButton:SetVisible(true);
    addButton:SetMouseVisible(true);

    addButton.MouseClick = function()
        local accountName = accountNameBox:GetText() or "";
        settings["nameAccount"]["account1"] = {
            name = accountName,
            nbrAlt = accountName ~= "" and 1 or 0,
            isVisible = accountName ~= "",
        };

        AltHolicAddnewWindow:SetVisible(false);
        SavePlayerDatas();
        SavePlayerEquipment();
        SavePlayerBags();
        SavePlayerVault();
        UpdateMainWindow();
        AltHolicWindow:SetVisible(true);
    end;
end
