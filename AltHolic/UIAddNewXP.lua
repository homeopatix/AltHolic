------------------------------------------------------------------------------------------
-- UIAddNewXP file
-- Originally written by Homeopatix
-- Refactored for AltHolic 4.91
------------------------------------------------------------------------------------------

function CreateUIAddNewXP(playerName)
    AltHolicUtil.DetachControl(UIAddNewXP);
    local windowWidth, windowHeight = 300, 120;

    UIAddNewXP = Turbine.UI.Lotro.GoldWindow();
    UIAddNewXP:SetSize(windowWidth, windowHeight);
    UIAddNewXP:SetText(T["PluginXPWindow2"] .. " " .. playerName);
    UIAddNewXP:SetPosition(
        (Turbine.UI.Display:GetWidth() - windowWidth) / 2,
        (Turbine.UI.Display:GetHeight() - windowHeight) / 2
    );
    UIAddNewXP:SetZOrder(100);
    UIAddNewXP:SetWantsKeyEvents(true);

    local prompt = Turbine.UI.Label();
    prompt:SetParent(UIAddNewXP);
    prompt:SetSize(300, 20);
    prompt:SetPosition(0, windowHeight / 2 - 25);
    prompt:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    prompt:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
    prompt:SetForeColor(Turbine.UI.Color.Gold);
    prompt:SetText(T["PluginXPWindow3"]);

    local xpIcon = Turbine.UI.Label();
    xpIcon:SetParent(UIAddNewXP);
    xpIcon:SetSize(32, 32);
    xpIcon:SetPosition(230, windowHeight / 2 - 27);
    xpIcon:SetBackground(0x411A3870);
    xpIcon:SetZOrder(10);
    xpIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);

    local xpBox = Turbine.UI.Lotro.TextBox();
    xpBox:SetParent(UIAddNewXP);
    xpBox:SetSize(150, 30);
    xpBox:SetText("");
    xpBox:SetPosition(windowWidth / 2 - 75, windowHeight / 2 - 5);
    xpBox:SetVisible(true);
    xpBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    xpBox:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));
    xpBox:SetBackColor(Turbine.UI.Color(0.9, 0.5, 0.7, 0.5));

    local saveButton = Turbine.UI.Lotro.GoldButton();
    saveButton:SetParent(UIAddNewXP);
    saveButton:SetPosition(windowWidth / 2 - 100, windowHeight / 2 + 30);
    saveButton:SetSize(200, 20);
    saveButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    saveButton:SetText(T["PluginWalletWindow7"]);
    saveButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    saveButton:SetVisible(true);
    saveButton:SetMouseVisible(true);

    saveButton.MouseClick = function()
        PlayerXp[playerName] = xpBox:GetText();
        UIAddNewXP:SetVisible(false);
        SavePlayerDatas();
        settings["isXPWindowVisible"]["value"] = true;
        CreateUIShowXP(playerName);
        UIShowXP:SetVisible(true);
    end;

    EscapeKeyHandlerForWindows(UIAddNewXP, false);
end
