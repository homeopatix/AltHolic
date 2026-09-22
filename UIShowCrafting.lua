------------------------------------------------------------------------------------------
-- UIshowEquip file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the equipment window
------------------------------------------------------------------------------------------
function CreateUIShowCrafting(namePlayerToshow)
    if namePlayerToshow == PlayerName then
        GetDataForProfessions();
        SavePlayerProfessions();
    end

    local professions = GetSavedProfessions(namePlayerToshow);

    UIShowCrafting = Turbine.UI.Lotro.GoldWindow();
    UIShowCrafting:SetSize(420, 420);
    UIShowCrafting:SetText((T[ "PluginCrafting" ] or "Crafting") .. " - " .. tostring(namePlayerToshow));
    UIShowCrafting:SetPosition(
        (Turbine.UI.Display:GetWidth() - UIShowCrafting:GetWidth()) / 2,
        (Turbine.UI.Display:GetHeight() - UIShowCrafting:GetHeight()) / 2
    );

    UIShowCrafting.Message = Turbine.UI.Label();
    UIShowCrafting.Message:SetParent(UIShowCrafting);
    UIShowCrafting.Message:SetSize(150, 10);
    UIShowCrafting.Message:SetPosition(UIShowCrafting:GetWidth() / 2 - 75, UIShowCrafting:GetHeight() - 20);
    UIShowCrafting.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    UIShowCrafting.Message:SetText(T[ "PluginText" ]);
    UIShowCrafting:SetZOrder(10);
    UIShowCrafting:SetWantsKeyEvents(true);
    UIShowCrafting:SetVisible(false);

    local startY = 55;
    local rowHeight = 82;
    local visibleCount = math.min(#professions, 4);

    if visibleCount > 0 then
        for x = 1, visibleCount do
            local profession = professions[x];
            local rowY = startY + ((x - 1) * rowHeight);

            local icon = Turbine.UI.Label();
            icon:SetParent(UIShowCrafting);
            icon:SetPosition(25, rowY);
            icon:SetSize(32, 32);
            icon:SetZOrder(21);
            -- Default blending: Overlay is for LOTRO's own texture IDs, not for the
            -- plugin's opaque TGA artwork. The texture is already 32x32, so there is
            -- nothing to stretch either.
            local iconFile = profession.Icon or GetProfessionIconFile(profession.Key, profession.Name);
            if iconFile ~= nil then
                icon:SetBackground(ResourcePath .. iconFile);
            end

            local nameLabel = Turbine.UI.Label();
            nameLabel:SetParent(UIShowCrafting);
            nameLabel:SetPosition(65, rowY);
            nameLabel:SetSize(300, 24);
            nameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold22);
            nameLabel:SetText(profession.Name or "Unknown profession");
            nameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
            nameLabel:SetZOrder(21);

            local proficiency = Turbine.UI.Label();
            proficiency:SetParent(UIShowCrafting);
            proficiency:SetPosition(65, rowY + 24);
            proficiency:SetSize(320, 28);
            proficiency:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold16);
            proficiency:SetText(profession.CurrentLvl or "");
            proficiency:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
            proficiency:SetZOrder(21);
            proficiency:SetForeColor(Turbine.UI.Color(0.8, 0.4, 0.2));

            local mastery = Turbine.UI.Label();
            mastery:SetParent(UIShowCrafting);
            mastery:SetPosition(65, rowY + 50);
            mastery:SetSize(320, 28);
            mastery:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold16);
            mastery:SetText(profession.CurrentMastery or "");
            mastery:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
            mastery:SetZOrder(21);
            mastery:SetForeColor(Turbine.UI.Color(1, 0.9, 0.5));
        end
    else
        local noData = Turbine.UI.Label();
        noData:SetParent(UIShowCrafting);
        noData:SetPosition(45, 120);
        noData:SetSize(330, 100);
        noData:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
        noData:SetText(T[ "PluginStats10" ] or "No crafting data saved.");
        noData:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
        noData:SetZOrder(21);
    end
end
