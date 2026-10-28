------------------------------------------------------------------------------------------
-- LOTRO Points editor
------------------------------------------------------------------------------------------
function CreateUIShowLotro(namePlayerToshow)
    if UIShowLotro ~= nil then
        AltHolicUtil.DetachControl(UIShowLotro);
        UIShowLotro = nil;
    end

    UIShowLotro = Turbine.UI.Lotro.GoldWindow();
    UIShowLotro:SetSize(300, 120);
    UIShowLotro:SetText(T["PluginWalletWindow5"]);
    UIShowLotro:SetPosition((Turbine.UI.Display:GetWidth() - UIShowLotro:GetWidth()) / 2,
        (Turbine.UI.Display:GetHeight() - UIShowLotro:GetHeight()) / 2);
    UIShowLotro:SetZOrder(100);
    UIShowLotro:SetWantsKeyEvents(true);

    AltHolicUtil.CreateLabel(UIShowLotro, T["PluginWalletWindow6"], 0, 35, 300, 20, {
        font = Turbine.UI.Lotro.Font.BookAntiquaBold19, color = Turbine.UI.Color.Gold,
        align = Turbine.UI.ContentAlignment.MiddleCenter
    });

    local lotroIcon = Turbine.UI.Label();
    lotroIcon:SetParent(UIShowLotro);
    lotroIcon:SetSize(25, 25);
    lotroIcon:SetPosition(230, 33);
    lotroIcon:SetBackground(0x411045ED);
    lotroIcon:SetZOrder(10);
    lotroIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    lotroIcon:SetMouseVisible(false);

    local pointsBox = Turbine.UI.Lotro.TextBox();
    pointsBox:SetParent(UIShowLotro);
    pointsBox:SetSize(150, 30);
    pointsBox:SetText(tostring(settings["lotroCoins"]["value"] or ""));
    pointsBox:SetMultiline(false);
    pointsBox:SetPosition(75, 55);
    pointsBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    pointsBox:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));
    pointsBox:SetBackColor(Turbine.UI.Color(0.9, 0.5, 0.7, 0.5));

    local validateButton = Turbine.UI.Lotro.GoldButton();
    validateButton:SetParent(UIShowLotro);
    validateButton:SetPosition(50, 90);
    validateButton:SetSize(200, 20);
    validateButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    validateButton:SetText(T["PluginWalletWindow7"]);
    validateButton:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);

    validateButton.MouseClick = function()
        settings["lotroCoins"]["value"] = tonumber(pointsBox:GetText()) or 0;
        settings["isLotroWindowVisible"]["value"] = false;
        SaveSettings();
        AltHolicUtil.DetachControl(UIShowLotro);
        UIShowLotro = nil;
        CreateUIShowWallet(namePlayerToshow);
        UIShowWallet:SetVisible(true);
        settings["isShowWalletVisible"]["isShowWalletVisible"] = true;
    end

    EscapeKeyHandlerForWindows(UIShowLotro, "isLotroWindowVisible", "value");
end
