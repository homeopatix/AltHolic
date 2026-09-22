------------------------------------------------------------------------------------------
-- UIToBeSur file
-- Originally written by Homeopatix
-- Refactored for AltHolic 4.91
------------------------------------------------------------------------------------------

function CreateToBeSurWindow(nameToDelete, deleteMode)
    AltHolicUtil.DetachControl(ToBeSurWindow);
    local windowWidth, windowHeight = 400, 200;

    ToBeSurWindow = Turbine.UI.Lotro.GoldWindow();
    ToBeSurWindow:SetSize(windowWidth, windowHeight);
    ToBeSurWindow:SetText(T["DeleteWindowName"]);
    ToBeSurWindow:SetZOrder(1);
    ToBeSurWindow:SetWantsKeyEvents(true);
    ToBeSurWindow:SetVisible(false);
    ToBeSurWindow:SetPosition(
        (Turbine.UI.Display:GetWidth() - windowWidth) / 2,
        (Turbine.UI.Display:GetHeight() - windowHeight) / 2
    );

    local footer = Turbine.UI.Label();
    footer:SetParent(ToBeSurWindow);
    footer:SetSize(150, 10);
    footer:SetPosition(windowWidth / 2 - 75, windowHeight - 20);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    local question = Turbine.UI.Label();
    question:SetParent(ToBeSurWindow);
    question:SetSize(250, 50);
    question:SetPosition(windowWidth / 2 - 125, 45);
    question:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    question:SetForeColor(Turbine.UI.Color.Gold);
    question:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
    question:SetText(
        deleteMode == 2
            and (T["DeleteTextAll"] .. " ?")
            or (T["DeleteTextAndName"] .. tostring(nameToDelete) .. " ?")
    );

    local function CreateButton(x, color, text)
        local button = Turbine.UI.Lotro.GoldButton();
        button:SetParent(ToBeSurWindow);
        button:SetPosition(x, windowHeight - 70);
        button:SetSize(100, 40);
        button:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
        button:SetForeColor(color);
        button:SetText(text);
        button:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
        button:SetVisible(true);
        button:SetMouseVisible(true);
        return button;
    end

    local yesButton = CreateButton(windowWidth / 2 - 150, Turbine.UI.Color.Green, T["DeleteYes"]);
    local noButton = CreateButton(windowWidth / 2 + 50, Turbine.UI.Color.Red, T["DeleteNo"]);

    yesButton.MouseClick = function()
        if deleteMode == 2 then
            Write(rgb["start"] .. T["PluginName"] .. rgb["clear"] .. " - " .. T["PluginClearAll"]);
            ClearAllPlayer();
        else
            Write(rgb["start"] .. T["PluginName"] .. rgb["clear"] .. " - " .. T["PluginClear"] .. nameToDelete);
            ClearPlayer(nameToDelete);
        end
        ToBeSurWindow:SetVisible(false);
        settings["isToBeSurWindowVisible"]["value"] = false;
    end;

    noButton.MouseClick = function()
        ToBeSurWindow:SetVisible(false);
        settings["isToBeSurWindowVisible"]["value"] = false;
    end;

    ToBeSurWindow.Closing = function()
        settings["isToBeSurWindowVisible"]["value"] = false;
    end;

    EscapeKeyHandlerForWindows(ToBeSurWindow, settings["isToBeSurWindowVisible"]["value"]);
end
